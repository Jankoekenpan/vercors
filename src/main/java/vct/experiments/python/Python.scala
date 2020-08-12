package vct.experiments.python

import vct.col.ast.`type`.{ClassType, Type}
import vct.col.ast.stmt.decl.{AxiomaticDataType, ProgramUnit}
import vct.logging.PassReport

import scala.collection.JavaConverters.iterableAsScalaIterableConverter

object Python {
  def verify(arg: PassReport): Unit = Python(arg.getOutput).verify
}

case class Python(program: ProgramUnit) {
  def visit[T <: PythonVisitor](visitor: T): T = {
    program.asScala.foreach(_.accept(visitor))
    visitor
  }

  def declareADTs(instance: z3.Instance, adtUses: Set[ClassType]): Unit = {
    for(adtUse <- adtUses) {
      val adt = adtUse.definition.asInstanceOf[AxiomaticDataType]
      assert(adtUse.args.size == adt.parameters.size)
      val typeArgs = adt.parameters.map(_.name).zip(adtUse.args.map(_.asInstanceOf[Type])).toMap
      val sortName = z3.Util.typeToName(ClassType(List(adt.name), adtUse.args))
      instance.declareSort(sortName)
    }

    for(adtUse <- adtUses) {
      val adt = adtUse.definition.asInstanceOf[AxiomaticDataType]
      val typeArgs = adt.parameters.map(_.name).zip(adtUse.args.map(_.asInstanceOf[Type])).toMap
      for(method <- adt.mappingsJava.asScala ++ adt.constructorsJava.asScala) {
        instance.declareFunc(
          method.name,
          method.getArgs.map(arg => z3.Util.typeToExpr(arg.getType, typeArgs)),
          z3.Util.typeToExpr(method.getReturnType, typeArgs))
      }
    }

    for(adtUse <- adtUses) {
      val adt = adtUse.definition.asInstanceOf[AxiomaticDataType]
      val typeArgs = adt.parameters.map(_.name).zip(adtUse.args.map(_.asInstanceOf[Type])).toMap
      for(axiom <- adt.axiomsJava.asScala) {
        axiom.rule
      }
    }
  }

  def verify: Unit = {
    val instance = z3.Instance()

    instance.declareSort("Heap")
    instance.declareSort("Ref")

    val adtUse = visit(new CollectADTUses(program))
    declareADTs(instance, adtUse.types.toSet)

    // === Start proving methods ===
    // Name all the things
    val names = visit(new MakeNames(program, instance))

    println()
  }
}