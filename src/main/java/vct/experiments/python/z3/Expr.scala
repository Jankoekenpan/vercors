package vct.experiments.python.z3

import java.io.Writer

import vct.col.ast.`type`.{ClassType, PrimitiveSort, PrimitiveType, Type, TypeVariable}

object Util {
  def typeToName(t: Type, typeArgs: Map[String, Type] = Map()): String = t match {
    case t: PrimitiveType => t.sort match {
      case PrimitiveSort.Integer => "Int"
      case PrimitiveSort.Boolean => "Bool"
      case PrimitiveSort.Resource => "Heap"
      case PrimitiveSort.Fraction | PrimitiveSort.ZFraction | PrimitiveSort.Rational => "Real"
    }
    case t: ClassType =>
      if(t.getName == "<<null>>") {
        "Ref"
      } else {
        if(t.args.nonEmpty) {
          t.getName + "<" + t.args.map(arg => typeToName(arg.asInstanceOf[Type], typeArgs)).mkString("$") + ">"
        } else {
          t.getName
        }
      }
    case t: TypeVariable =>
      typeToName(typeArgs(t.name), typeArgs)
  }

  def typeToExpr(t: Type, typeArgs: Map[String, Type] = Map()): Expr = Name(typeToName(t, typeArgs))
}

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
    for (arg <- args) {
      w.write(" ")
      arg.write(w)
    }
    w.write(")")
  }
}