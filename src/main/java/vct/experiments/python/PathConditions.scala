package vct.experiments.python

import vct.col.ast.`type`.{ClassType, PrimitiveType, TypeVariable}
import vct.col.ast.expr.constant.ConstantExpression
import vct.col.ast.expr.{BindingExpression, Dereference, MethodInvokation, NameExpression, OperatorExpression, StandardOperator}
import vct.col.ast.generic.ASTNode
import vct.col.ast.stmt.composite.{BlockStatement, IfStatement, LoopStatement}
import vct.col.ast.stmt.decl.{ASTClass, ASTSpecial, Axiom, AxiomaticDataType, Contract, DeclarationStatement, Method, ProgramUnit}
import vct.col.ast.stmt.terminal.{AssignmentStatement, ReturnStatement}

import scala.collection.mutable

class PathConditions(program: ProgramUnit) extends PythonVisitor(program) {
  val entryPc: mutable.Map[ASTNode, z3.Name] = mutable.Map()
  var count = 0

  private def name: String = {
    count += 1
    f"pc_$count"
  }

  override def visit(cls: ASTClass): Unit = {
    recurse(cls)
  }

  override def visit(method: Method): Unit = {
    entryPc += method -> z3.Name(name)
    recurse(method)
  }

  override def visit(c: Contract): Unit = {
    entryPc += c -> z3.Name(name)
    recurse(c)
  }

  override def visit(e: BlockStatement): Unit = {
    entryPc += e -> z3.Name(name)
    recurse(e)
  }

  override def visit(e: DeclarationStatement): Unit = {
    entryPc += e -> z3.Name(name)
    recurse(e)
  }

  override def visit(e: ASTSpecial): Unit = {
    entryPc += e -> z3.Name(name)
    recurse(e)
  }

  override def visit(e: AssignmentStatement): Unit = {
    entryPc += e -> z3.Name(name)
    recurse(e)
  }

  override def visit(s: IfStatement): Unit = {
    entryPc += s -> z3.Name(name)
    recurse(s)
  }

  override def visit(s: ReturnStatement): Unit = {
    entryPc += s -> z3.Name(name)
    recurse(s)
  }

  override def visit(s: LoopStatement): Unit = {
    entryPc += s -> z3.Name(name)
    recurse(s)
  }

  override def visit(e: MethodInvokation): Unit = {
    entryPc += e -> z3.Name(name)
    recurse(e)
  }

  override def visit(e: OperatorExpression): Unit = {
    entryPc += e -> z3.Name(name)
    recurse(e)
  }

  override def visit(e: NameExpression): Unit = {
    entryPc += e -> z3.Name(name)
    recurse(e)
  }

  override def visit(e: ConstantExpression): Unit = {
    entryPc += e -> z3.Name(name)
    recurse(e)
  }

  override def visit(e: BindingExpression): Unit = {
    entryPc += e -> z3.Name(name)
    recurse(e)
  }

  override def visit(e: Dereference): Unit = {
    entryPc += e -> z3.Name(name)
    recurse(e)
  }

  override def visit(t: PrimitiveType): Unit = {}
  override def visit(t: ClassType): Unit = {}
  override def visit(v: TypeVariable): Unit = {}

  override def visit(adt: AxiomaticDataType): Unit = {}
  override def visit(axiom: Axiom): Unit = {}
}
