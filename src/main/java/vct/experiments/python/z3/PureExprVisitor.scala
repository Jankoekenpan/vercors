package vct.experiments.python.z3

import vct.col.ast.`type`.{ClassType, PrimitiveType, TypeVariable}
import vct.col.ast.expr.constant.ConstantExpression
import vct.col.ast.expr.{BindingExpression, Dereference, MethodInvokation, NameExpression, OperatorExpression}
import vct.col.ast.stmt.composite.{BlockStatement, IfStatement, LoopStatement}
import vct.col.ast.stmt.decl.{ASTClass, ASTSpecial, Axiom, AxiomaticDataType, Contract, DeclarationStatement, Method, ProgramUnit}
import vct.col.ast.stmt.terminal.{AssignmentStatement, ReturnStatement}
import vct.experiments.python.PythonVisitor

class PureExprVisitor(source: ProgramUnit) extends PythonVisitor(source) {
  override def visit(cls: ASTClass): Unit = ???
  override def visit(method: Method): Unit = ???
  override def visit(c: Contract): Unit = ???

  override def visit(e: BlockStatement): Unit = ???
  override def visit(e: DeclarationStatement): Unit = ???
  override def visit(e: ASTSpecial): Unit = ???
  override def visit(e: AssignmentStatement): Unit = ???
  override def visit(s: IfStatement): Unit = ???
  override def visit(s: ReturnStatement): Unit = ???
  override def visit(s: LoopStatement): Unit = ???

  override def visit(e: MethodInvokation): Unit = recurse(e)
  override def visit(e: OperatorExpression): Unit = recurse(e)
  override def visit(e: NameExpression): Unit = recurse(e)
  override def visit(e: ConstantExpression): Unit = recurse(e)
  override def visit(e: BindingExpression): Unit = recurse(e)
  override def visit(e: Dereference): Unit = recurse(e)

  override def visit(t: PrimitiveType): Unit = recurse(t)
  override def visit(t: ClassType): Unit = recurse(t)
  override def visit(v: TypeVariable): Unit = recurse(v)

  override def visit(adt: AxiomaticDataType): Unit = {}
  override def visit(axiom: Axiom): Unit = {}
}
