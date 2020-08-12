package vct.experiments.python

/**
  * Reference-equality inducing box
  */
case class Box[+T <: AnyRef](get: T) {
  override def toString: String = get.toString
  override def equals(obj: Any): Boolean = obj match {
    case box: Box[T] => box.get.eq(get)
    case _ => false
  }
  override def hashCode(): Int = System.identityHashCode(get)
}