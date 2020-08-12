package vct.experiments.python

import vct.col.ast.`type`.{ClassType, PrimitiveType, TypeVariable}
import vct.col.ast.expr.{BindingExpression, Dereference, MethodInvokation, NameExpression, OperatorExpression}
import vct.col.ast.expr.constant.ConstantExpression
import vct.col.ast.stmt.composite.{BlockStatement, IfStatement, LoopStatement}
import vct.col.ast.stmt.decl.{ASTClass, ASTSpecial, Axiom, AxiomaticDataType, Contract, DeclarationStatement, Method, ProgramUnit}
import vct.col.ast.stmt.terminal.{AssignmentStatement, ReturnStatement}

import scala.collection.mutable

class CollectADTUses(program: ProgramUnit) extends PythonVisitor(program) {
  val types: mutable.Set[ClassType] = mutable.Set()

  override def visit(cls: ASTClass): Unit = recurse(cls)
  override def visit(method: Method): Unit = recurse(method)
  override def visit(c: Contract): Unit = recurse(c)

  override def visit(e: BlockStatement): Unit = recurse(e)
  override def visit(e: DeclarationStatement): Unit = recurse(e)
  override def visit(e: ASTSpecial): Unit = recurse(e)
  override def visit(e: AssignmentStatement): Unit = recurse(e)
  override def visit(s: IfStatement): Unit = recurse(s)
  override def visit(s: ReturnStatement): Unit = recurse(s)
  override def visit(s: LoopStatement): Unit = recurse(s)

  override def visit(e: MethodInvokation): Unit = recurse(e)
  override def visit(e: OperatorExpression): Unit = recurse(e)
  override def visit(e: NameExpression): Unit = recurse(e)
  override def visit(e: ConstantExpression): Unit = recurse(e)
  override def visit(e: BindingExpression): Unit = recurse(e)
  override def visit(e: Dereference): Unit = recurse(e)

  override def visit(t: PrimitiveType): Unit = recurse(t)
  override def visit(t: ClassType): Unit = {
    if(!Set("Ref", "<<null>>").contains(t.getName)) {
      types += t
    }
  }
  override def visit(v: TypeVariable): Unit = recurse(v)

  override def visit(adt: AxiomaticDataType): Unit = {} // we disallow further concrete instatiations from ADTs
  override def visit(axiom: Axiom): Unit = recurse(axiom)
}

