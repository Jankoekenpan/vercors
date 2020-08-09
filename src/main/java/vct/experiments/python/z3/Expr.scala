package vct.experiments.python.z3

import java.io.Writer

sealed trait Expr {
  def write(w: Writer)
}

case class Name(name: String) extends Expr {
  override def write(w: Writer): Unit = w.write(name)
}

case class Apply(func: String, args: Expr*) extends Expr {
  override def write(w: Writer): Unit = {
    w.write("(")
    w.write(func)
    for(arg <- args) {
      w.write(" ")
      arg.write(w)
    }
    w.write(")")
  }
}