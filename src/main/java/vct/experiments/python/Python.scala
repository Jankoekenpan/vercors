package vct.experiments.python

import vct.col.ast.stmt.decl.ProgramUnit
import vct.logging.PassReport

import scala.collection.JavaConverters.iterableAsScalaIterableConverter

object Python {
  def verify(arg: PassReport): Unit = Python(arg.getOutput).verify
}

case class Python(program: ProgramUnit) {
  def verify: Unit = {
    val instance = z3.Instance()

    // Assert prelude stuff
    // Import ADTs

    // === Start proving methods ===
    // Name expression results
    val expr = new NameExpressions(program)
    program.asScala.foreach(_.accept(expr))
    // Name path conditions
    val pc = new PathConditions(program)
    program.asScala.foreach(_.accept(pc))

    println()
  }
}