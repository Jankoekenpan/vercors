package vct.experiments.python

import scala.collection.mutable

class Scope {
  private val stack: mutable.ArrayStack[mutable.Map[String, Option[z3.Name]]]
    = mutable.ArrayStack(mutable.Map[String, Option[z3.Name]]())

  def push(): Unit = {
    stack.push(stack.top.clone)
  }

  def pop(): Unit = {
    stack.pop
  }

  def put(name: String, value: z3.Name): Unit = {
    stack.top(name) = Some(value)
  }

  def havoc(): Unit = {
    for(name <- stack.top.keys) {
      stack.top(name) = None
    }
  }

  def get(name: String): Option[z3.Name] = {
    // A name not being in scope is an error, but it being indeterminate is defined.
    stack.top(name)
  }
}