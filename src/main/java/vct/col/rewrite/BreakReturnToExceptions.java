package vct.col.rewrite;

import vct.col.ast.expr.NameExpression;
import vct.col.ast.expr.StandardOperator;
import vct.col.ast.generic.ASTNode;
import vct.col.ast.stmt.composite.LoopStatement;
import vct.col.ast.stmt.composite.TryCatchBlock;
import vct.col.ast.stmt.decl.*;
import vct.col.ast.stmt.terminal.ReturnStatement;
import vct.col.ast.type.*;
import vct.col.ast.util.AbstractRewriter;
import vct.col.ast.util.ContractBuilder;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;

/**
 * Turns a program with break and return into a program using exceptions for control flow.
 * Note that while all uses of return are replaced with throws, it is not the case that after this pass
 * no return is present in the function. The pass places one return at the end of the function so another
 * pass later can decide how return should be encoded (e.g. via assignment to a variable, or something else). The
 * pass then also ensures that all control flow from break and return is redirected to this one return statement
 * using exceptions.
 */
public class BreakReturnToExceptions extends AbstractRewriter {
    private Set<String> breakLabels = new HashSet<>();
    private boolean encounteredReturn = false;
    private Set<String> exceptionTypes = new HashSet<>();
    private int uniqueCatchVarCounter = 0;

    /**
     * At this point method overloading is not yet resolved. Therefore, to be safe, we append
     * uniqueMethodIdCounter to any name that must be derived from the current method. As it is
     * incremented upon entry of a new method, this results in unique names.
     */
    private int uniqueMethodIdCounter = 0;

    public BreakReturnToExceptions(ProgramUnit source) {
        super(source);
    }

    public ClassType getExceptionType(String prefix, String id) {
        return getExceptionType(prefix, id, new PrimitiveType(PrimitiveSort.Void));
    }

    /**
     * Generates a unique catch var name. Vercors doesn't scope variables properly so each variable name needs to be unique.
     * If this is ever fixed or offloaded to some separate phase this method can be replaced with just the constant "e".
     */
    private String getUniqueCatchVarName() {
        // ucv == unique catch var
        return "ucv_" + uniqueCatchVarCounter++;
    }

    public String getExceptionClassName(String prefix, String id) {
        return "__" + prefix + "_" + id + "_ex";
    }

    public ASTClass createExceptionClass(String prefix, String id, Type arg) {
        String name = getExceptionClassName(prefix, id);

        ASTClass exceptionClass = create.new_class(
                name,
                null,
                null
        );

        if (arg != null && !arg.isVoid()) {
            ContractBuilder cb = new ContractBuilder();
            cb.ensures(create.expression(StandardOperator.Star,
                    create.expression(StandardOperator.Perm,
                            create.dereference(create.reserved_name(ASTReserved.This), "value"),
                            create.reserved_name(ASTReserved.FullPerm)
                    ),
                    create.expression(StandardOperator.EQ,
                            create.dereference(create.reserved_name(ASTReserved.This), "value"),
                            create.argument_name("returnValue")
                    )
            ));

            Method exceptionConstructor = create.method_kind(
                    Method.Kind.Constructor,
                    create.primitive_type(PrimitiveSort.Void),
                    cb.getContract(),
                    name,
                    new DeclarationStatement[] {
                            create.field_decl("returnValue", arg)
                    },
                    null
            );
            exceptionClass.add(exceptionConstructor);
            exceptionClass.add(create.field_decl("value", arg));
        } else {
            create.addZeroConstructor(exceptionClass);
        }

        return exceptionClass;
    }

    /**
     * Returns a class type parameterized by a prefix and id. If it doesn't exist also creates a class definition.
     * If arg is not Void or null, then a constructor is added for the class that takes an argument. This argument
     * is added in the e field in the class.
     */
    public ClassType getExceptionType(String prefix, String id, Type arg) {
        String name = getExceptionClassName(prefix, id);

        if (!exceptionTypes.contains(name)) {
            ASTClass exceptionClass = createExceptionClass(prefix, id, arg);
            target().add(exceptionClass);
            exceptionTypes.add(name);
        }

        return create.class_type(name);
    }

    public ClassType getReturnExceptionType(Method method) {
        return getExceptionType("return", method.getName() + "_" + uniqueMethodIdCounter, method.getReturnType());
    }

    public void post_visit(ASTNode node) {
        // Wrap statement in try-catch if one of the labels is broken to
        // Collect all used break labels within statement
        ArrayList<NameExpression> usedLabels = new ArrayList<>();
        for (NameExpression label : node.getLabels()) {
            if (breakLabels.contains(label.getName())) {
                usedLabels.add(label);
                breakLabels.remove(label.getName());
            }
        }

        if (usedLabels.size() > 0) {
            // There were breaks involved! Add catch clauses
            TryCatchBlock tryCatchBlock = create.try_catch(create.block(result), null);
            for (NameExpression label : usedLabels) {
                tryCatchBlock.addCatchClauseArray(
                        getUniqueCatchVarName(),
                        new Type[] { getExceptionType("break", label.getName()) },
                        create.block());
            }

            if (result instanceof LoopStatement) {
                ((LoopStatement) result).fixate();
            }

            result = tryCatchBlock;
        }

        super.post_visit(node);
    }

    public void visit(Method method) {
        // Pure methods and predicates are not touched at all
        if (!(method.getKind() == Method.Kind.Constructor || method.getKind() == Method.Kind.Plain)) {
            result = copy_rw.rewrite(method);
            return;
        }

        super.visit(method);
        Method resultMethod = (Method) result;

        if (encounteredReturn) {
            TryCatchBlock tryCatchBlock = create.try_catch(create.block(resultMethod.getBody()), null);

            ClassType exceptionType = getReturnExceptionType(method);
            String catchVarName = getUniqueCatchVarName();
            ASTNode getReturnValueExpr = create.dereference(create.local_name(catchVarName), "value");
            ReturnStatement returnStatement = create.return_statement(getReturnValueExpr);
            tryCatchBlock.addCatchClauseArray(catchVarName, new Type[] { exceptionType }, create.block(returnStatement));
            resultMethod.setBody(create.block(tryCatchBlock));

            encounteredReturn = false;
        }

        if (breakLabels.size() != 0) {
            Warning("Some break labels were not deleted, even though they should be. This indicates a logic error.");
            breakLabels.clear();
        }

        uniqueMethodIdCounter += 1;
    }

    public void visit(ASTSpecial special) {
        switch (special.kind) {
            default:
                super.visit(special);
                break;
            case Break:
                visitBreak(special);
                break;
            case Continue:
                Abort("Not supported");
                break;
        }
    }

    public void visitBreak(ASTSpecial breakStatement) {
        String id = ((NameExpression) breakStatement.args[0]).getName();
        breakLabels.add(id);
        result = create.special(ASTSpecial.Kind.Throw, create.new_object(getExceptionType("break", id)));
    }

    @Override
    public void visit(ReturnStatement returnStatement) {
        encounteredReturn = true;

        ASTNode expr = returnStatement.getExpression();

        // TODO (Bob): If we know we didn't pass any finally's we can do a jump to the end and check the postcondition...?
        ASTSpecial returnThrow = null;
        if (expr != null){
            ClassType exceptionType = getReturnExceptionType(current_method());
            returnThrow = create.special(ASTSpecial.Kind.Throw, create.new_object(exceptionType, rewrite(expr)));
        } else {
            ClassType exceptionType = getReturnExceptionType(current_method());
            returnThrow = create.special(ASTSpecial.Kind.Throw, create.new_object(exceptionType));
        }
       result = returnThrow;

        // TODO (Bob): Add this in the catch clause?
        // for(ASTNode n : returnStatement.get_after()){
        //     block.add(rewrite(n));
        // }
    }
}
