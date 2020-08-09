package vct.experiments.python

import vct.col.ast.`type`.{ClassType, FunctionType, PrimitiveType, RecordType, TupleType, TypeExpression, TypeVariable}
import vct.col.ast.expr.constant.{ConstantExpression, StructValue}
import vct.col.ast.expr.{BindingExpression, Dereference, FieldAccess, MethodInvokation, NameExpression, OperatorExpression, StandardProcedure}
import vct.col.ast.generic.ASTNode
import vct.col.ast.langspecific.c.{CFunctionType, OMPFor, OMPForSimd, OMPParallel, OMPParallelFor, OMPSection, OMPSections}
import vct.col.ast.stmt.composite.{ActionBlock, BlockStatement, Constraining, ForEachLoop, Hole, IfStatement, Lemma, LoopStatement, ParallelAtomic, ParallelBarrier, ParallelBlock, ParallelInvariant, ParallelRegion, Switch, Synchronized, TryCatchBlock, TryWithResources, VectorBlock}
import vct.col.ast.stmt.decl.{ASTClass, ASTSpecial, Axiom, AxiomaticDataType, Contract, DeclarationStatement, Method, NameSpace, ProgramUnit, VariableDeclaration}
import vct.col.ast.stmt.terminal.{AssignmentStatement, ReturnStatement}
import vct.col.ast.util.{ASTVisitor, RecursiveVisitor}

abstract class PythonVisitor(arg: ProgramUnit) extends RecursiveVisitor[Unit](arg) {
  // Expressions
  def visit(e: OperatorExpression): Unit
  def recurse(e: OperatorExpression): Unit = super.visit(e)
  def visit(e: NameExpression): Unit
  def recurse(e: NameExpression): Unit = super.visit(e)
  def visit(e: ConstantExpression): Unit
  def recurse(e: ConstantExpression): Unit = super.visit(e)
  def visit(e: MethodInvokation): Unit
  def recurse(e: MethodInvokation): Unit = super.visit(e)
  def visit(e: BindingExpression): Unit
  def recurse(e: BindingExpression): Unit = super.visit(e)
  def visit(e: Dereference): Unit
  def recurse(e: Dereference): Unit = super.visit(e)

  // Statements
  def visit(s: BlockStatement): Unit
  def recurse(s: BlockStatement): Unit = super.visit(s)
  def visit(s: DeclarationStatement): Unit
  def recurse(s: DeclarationStatement): Unit = super.visit(s)
  def visit(special: ASTSpecial): Unit
  def recurse(special: ASTSpecial): Unit = super.visit(special)
  def visit(s: AssignmentStatement): Unit
  def recurse(s: AssignmentStatement): Unit = super.visit(s)
  def visit(s: IfStatement): Unit
  def recurse(s: IfStatement): Unit = super.visit(s)
  def visit(s: ReturnStatement): Unit
  def recurse(s: ReturnStatement): Unit = super.visit(s)
  def visit(s: LoopStatement): Unit
  def recurse(s: LoopStatement): Unit = super.visit(s)

  // Declarations
  def visit(c: ASTClass): Unit
  def recurse(c: ASTClass): Unit = super.visit(c)
  def visit(m: Method): Unit
  def recurse(m: Method): Unit = super.visit(m)
  def visit(contract: Contract): Unit
  def recurse(contract: Contract): Unit = super.visit(contract)
  def visit(adt: AxiomaticDataType): Unit
  def recurse(adt: AxiomaticDataType): Unit = super.visit(adt)
  def visit(axiom: Axiom): Unit
  def recurse(axiom: Axiom): Unit = super.visit(axiom)

  // Types
  def visit(t: PrimitiveType): Unit
  def recurse(t: PrimitiveType): Unit = super.visit(t)
  def visit(t: ClassType): Unit
  def recurse(t: ClassType): Unit = super.visit(t)
  def visit(v: TypeVariable): Unit
  def recurse(v: TypeVariable): Unit = super.visit(v)

  // Rewritten away
  override def visit(parallel: OMPParallel): Unit = ???
  override def visit(section: OMPSection): Unit = ???
  override def visit(sections: OMPSections): Unit = ???
  override def visit(loop: OMPFor): Unit = ???
  override def visit(loop: OMPParallelFor): Unit = ???
  override def visit(loop: OMPForSimd): Unit = ???
  override def visit(p: StandardProcedure): Unit = ???
  override def visit(v: StructValue): Unit = ???
  override def visit(t: FunctionType): Unit = ???
  override def visit(t: RecordType): Unit = ???
  override def visit(s: ForEachLoop): Unit = ???
  override def visit(parallelBarrier: ParallelBarrier): Unit = ???
  override def visit(parallelBlock: ParallelBlock): Unit = ???
  override def visit(variableDeclaration: VariableDeclaration): Unit = ???
  override def visit(tupleType: TupleType): Unit = ???
  override def visit(hole: Hole): Unit = ???
  override def visit(actionBlock: ActionBlock): Unit = ???
  override def visit(t: TypeExpression): Unit = ???
  override def visit(parallelAtomic: ParallelAtomic): Unit = ???
  override def visit(nameSpace: NameSpace): Unit = ???
  override def visit(tcb: TryCatchBlock): Unit = ???
  override def visit(a: FieldAccess): Unit = ???
  override def visit(inv: ParallelInvariant): Unit = ???
  override def visit(region: ParallelRegion): Unit = ???
  override def visit(vb: VectorBlock): Unit = ???
  override def visit(c: Constraining): Unit = ???
  override def visit(s: Switch): Unit = ???
  override def visit(t: TryWithResources): Unit = ???
  override def visit(sync: Synchronized): Unit = ???
  override def visit(t: CFunctionType): Unit = ???
  override def visit(lemma: Lemma): Unit = ???
}
