package vct.experiments.python

import vct.col.ast.`type`.{ClassType, PrimitiveSort, PrimitiveType, Type, TypeVariable}
import vct.col.ast.expr.constant.ConstantExpression
import vct.col.ast.expr.{BindingExpression, Dereference, MethodInvokation, NameExpression, OperatorExpression, StandardOperator}
import vct.col.ast.generic.ASTNode
import vct.col.ast.stmt.composite.{BlockStatement, IfStatement, LoopStatement}
import vct.col.ast.stmt.decl.{ASTClass, ASTSpecial, Axiom, AxiomaticDataType, Contract, DeclarationStatement, Method, ProgramUnit}
import vct.col.ast.stmt.terminal.{AssignmentStatement, ReturnStatement}

import scala.collection.mutable

class MakeNames(program: ProgramUnit, instance: z3.Instance) extends PythonVisitor(program) {
  val pcNames: mutable.Map[Box[ASTNode], z3.Name] = mutable.Map()
  var pcCount = 0

  private def pcName: String = {
    pcCount += 1
    val name = f"pc_$pcCount"
    instance.declareConst(name, z3.Name("Bool"))
    name
  }

  val exprNames: mutable.Map[Box[ASTNode], z3.Name] = mutable.Map()
  var exprCount = 0

  private def exprName(t: Type): String = {
    exprCount += 1
    val name = f"expr_$pcCount"
    instance.declareConst(name, z3.Util.typeToExpr(t))
    name
  }

  val heapNames: mutable.Map[Box[ASTNode], z3.Name] = mutable.Map()
  var heapCount = 0

  private def heapName: String = {
    heapCount += 1
    val name = f"heap_$heapCount"
    instance.declareConst(name, z3.Name("Heap"))
    name
  }

  override def visit(cls: ASTClass): Unit = {
    recurse(cls)
  }

  override def visit(method: Method): Unit = {
    pcNames += Box(method) -> z3.Name(pcName)
    heapNames += Box(method) -> z3.Name(heapName)
    recurse(method)
  }

  override def visit(c: Contract): Unit = {
    pcNames += Box(c) -> z3.Name(pcName)
    heapNames += Box(c) -> z3.Name(heapName)
    recurse(c)
  }

  override def visit(e: BlockStatement): Unit = {
    pcNames += Box(e) -> z3.Name(pcName)
    heapNames += Box(e) -> z3.Name(heapName)
    recurse(e)
  }

  override def visit(e: DeclarationStatement): Unit = {
    pcNames += Box(e) -> z3.Name(pcName)
    heapNames += Box(e) -> z3.Name(heapName)
    recurse(e)
  }

  override def visit(e: ASTSpecial): Unit = {
    pcNames += Box(e) -> z3.Name(pcName)
    heapNames += Box(e) -> z3.Name(heapName)
    recurse(e)
  }

  override def visit(e: AssignmentStatement): Unit = {
    pcNames += Box(e) -> z3.Name(pcName)
    heapNames += Box(e) -> z3.Name(heapName)
    recurse(e)
  }

  override def visit(s: IfStatement): Unit = {
    pcNames += Box(s) -> z3.Name(pcName)
    heapNames += Box(s) -> z3.Name(heapName)
    recurse(s)
  }

  override def visit(s: ReturnStatement): Unit = {
    pcNames += Box(s) -> z3.Name(pcName)
    heapNames += Box(s) -> z3.Name(heapName)
    recurse(s)
  }

  override def visit(s: LoopStatement): Unit = {
    pcNames += Box(s) -> z3.Name(pcName)
    heapNames += Box(s) -> z3.Name(heapName)
    recurse(s)
  }

  override def visit(e: MethodInvokation): Unit = {
    pcNames += Box(e) -> z3.Name(pcName)
    if(!e.getType.isPrimitive(PrimitiveSort.Void))
      exprNames += Box(e) -> z3.Name(exprName(e.getType))
    heapNames += Box(e) -> z3.Name(heapName)
    recurse(e)
  }

  override def visit(e: OperatorExpression): Unit = {
    pcNames += Box(e) -> z3.Name(pcName)
    exprNames += Box(e) -> z3.Name(exprName(e.getType))
    heapNames += Box(e) -> z3.Name(heapName)
    recurse(e)
  }

  override def visit(e: NameExpression): Unit = {
    pcNames += Box(e) -> z3.Name(pcName)
    exprNames += Box(e) -> z3.Name(exprName(e.getType))
    heapNames += Box(e) -> z3.Name(heapName)
    recurse(e)
  }

  override def visit(e: ConstantExpression): Unit = {
    pcNames += Box(e) -> z3.Name(pcName)
    exprNames += Box(e) -> z3.Name(exprName(e.getType))
    heapNames += Box(e) -> z3.Name(heapName)
    recurse(e)
  }

  override def visit(e: BindingExpression): Unit = {
    pcNames += Box(e) -> z3.Name(pcName)
    exprNames += Box(e) -> z3.Name(exprName(e.getType))
    heapNames += Box(e) -> z3.Name(heapName)
    recurse(e)
  }

  override def visit(e: Dereference): Unit = {
    pcNames += Box(e) -> z3.Name(pcName)
    exprNames += Box(e) -> z3.Name(exprName(e.getType))
    heapNames += Box(e) -> z3.Name(heapName)
    recurse(e)
  }

  override def visit(t: PrimitiveType): Unit = {}
  override def visit(t: ClassType): Unit = {}
  override def visit(v: TypeVariable): Unit = {}

  override def visit(adt: AxiomaticDataType): Unit = {}
  override def visit(axiom: Axiom): Unit = {}
}
