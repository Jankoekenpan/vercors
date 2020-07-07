package vct.test.wikitestextractor

import scala.util.matching.Regex

object Snip {
  def of(rawBlock: RawBlock): Option[Snip] = {
    if (rawBlock.isComment) {
      val r = new Regex(raw"(?s)\s*(snip|standalone-snip)\s*([a-zA-Z0-9_\-]+)(.*)")
      r.findPrefixMatchOf(rawBlock.innerComment) match {
        case Some(m) => {
          val opts = Map(
            "name" -> m.group(2),
            "standalone" -> (if (m.group(1).equals("snip")) "false" else "true")
          )
          Some(Snip(opts, m.group(3)))
        }
        case _ => None
      }
    } else {
      None
    }
  }
}

case class Snip(var options: Map[String, String], var contents: String) {
  def appendContents(str: String): Unit = this.contents += str
  def setOption(k: String, v: String): Unit = this.options = this.options ++ Map(k -> v)

  def isStandalone: Boolean = this.options.get("standalone").contains("true")
}
