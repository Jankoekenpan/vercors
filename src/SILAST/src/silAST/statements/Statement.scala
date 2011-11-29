package silAST.statements

import silAST.ASTNode
import silAST.expressions.ProgramExpression
import silAST.expressions.util.PArgumentSequence
import silAST.symbols.{ProgramVariableSequence, Method, Field, ProgramVariable}
import silAST.types.DataType
import silAST.expressions.Expression
import silAST.expressions.PredicateExpression
import silAST.source.SourceLocation

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
sealed abstract class Statement(sl : SourceLocation) extends ASTNode(sl) {
  override def toString: String
}


//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
case class Assignment private [silAST](
                                sl : SourceLocation,
                                val target: ProgramVariable,
                                val source: ProgramExpression
                                )
  extends Statement(sl) {
  override def toString: String = target.name + ":=" + source.toString

  override def subNodes: Seq[ASTNode] = List(target, source)
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
case class FieldAssignment private [silAST](
                                     sl : SourceLocation,
                                     val target: ProgramVariable,
                                     val field: Field,
                                     val source: ProgramExpression
                                     )
  extends Statement(sl) {
  override def toString: String = target.name + "." + field.name + " := " + source.toString

  override def subNodes: Seq[ASTNode] = List(target, field, source)
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
case class NewStatement private [silAST](
                                  sl : SourceLocation,
                                  val target: ProgramVariable,
                                  val dataType: DataType
                                  )
  extends Statement(sl)
{
  override def toString: String = target.name + ":= new " + dataType.toString

  override def subNodes: Seq[ASTNode] = List(target, dataType)
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
case class CallStatement private [silAST]
    (
            sl : SourceLocation,
            val targets: ProgramVariableSequence,
            val receiver: ProgramExpression,
            val method: Method,
            val arguments: PArgumentSequence
    )
  extends Statement(sl) {
  override def toString: String = targets.toString + " := " + receiver.toString + "." + method.name + arguments.toString

  override def subNodes: Seq[ASTNode] = List(targets, receiver, method, arguments)
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
case class inhale private [silAST](
                  sl : SourceLocation,
                  val expression: Expression
            )
  extends Statement(sl)
{
  override def toString: String = "inhale " + expression.toString

  override def subNodes: Seq[ASTNode] = List(expression)
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
case class exhale private [silAST](
                            sl : SourceLocation,
                            val expression: Expression
                            )
  extends Statement(sl)
{
  override def toString: String = "exhale " + expression.toString

  override def subNodes: Seq[ASTNode] = List(expression)
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//TODO:fold/unfold arrays?
case class fold private [silAST](
                          sl : SourceLocation,
                          val predicate: PredicateExpression
                          )
  extends Statement(sl) {
  override def toString: String = "fold " + predicate.toString

  override def subNodes: Seq[ASTNode] = List(predicate)
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
case class unfold private [silAST](
                            sl : SourceLocation,
                            val predicate: PredicateExpression
                            )
  extends Statement(sl) {
  override def toString: String = "unfold " + predicate.toString

  override def subNodes: Seq[ASTNode] = List(predicate)
}
