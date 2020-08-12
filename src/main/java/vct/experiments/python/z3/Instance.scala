package vct.experiments.python.z3

import java.io.{BufferedReader, InputStreamReader, OutputStreamWriter}
import hre.lang.System._

case class Instance() {
  private val process = new ProcessBuilder("z3", "-smt2", "-in").start()

  private val in = new BufferedReader(new InputStreamReader(process.getInputStream))
  private val out = new OutputStreamWriter(process.getOutputStream)
  def assert(e: Expr): Unit = {
    Apply("assert", e).write(out)
    out.write("\n")
  }

  def checkSat: String = {
    out.write("(check-sat)\n")
    in.readLine.strip
  }

  def push(): Unit = {
    out.write("(push)\n")
  }

  def pop(): Unit = {
    out.write("(pop)\n")
  }

  def declareSort(sort: String): Unit = {
    Output("%s", s"declaring $sort")
    out.write(s"(declare-sort $sort)\n")
  }

  def declareConst(name: String, t: Expr): Unit = {
    Output("%s", s"declaring constant $name as $t")
    out.write(s"(declare-const $name ")
    t.write(out)
    out.write(")\n")
  }

  def declareFunc(name: String, args: Seq[Expr], res: Expr) = {
    Output("%s", s"declaring function $name with arguments $args and result $res")
    out.write(s"(declare-fun $name (")
    if(args.nonEmpty) {
      args.head.write(out)
      for (arg <- args.tail) {
        out.write(" ")
        arg.write(out)
      }
    }
    out.write(") ")
    res.write(out)
    out.write(")\n")
  }

}
