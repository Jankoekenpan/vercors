package vct.experiments.python.z3

import java.io.{BufferedReader, InputStreamReader, OutputStreamWriter}

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
}
