package vct.test.wikitestextractor

import scala.collection.JavaConverters._
import com.google.gson.{JsonArray, JsonElement, JsonObject}
import hre.lang.System.Abort

object Block {
  def of(json: JsonElement): Option[Block] = {
    RawBlock.of(json)
      .orElse(CodeBlock.of(json))
  }
}

abstract class Block
object RawBlock {
  def of(obj: JsonObject): Option[RawBlock] = {
    if (obj.has("t")) {
      val t = obj.get("t").getAsString
      val c = obj.get("c").getAsJsonArray
      t match {
        case "RawBlock" => Some(RawBlock(c.get(0).getAsString, c.get(1).getAsString.trim))
        case _ => None
      }
    } else {
      None
    }
  }

  def of(json: JsonElement): Option[RawBlock] =
    if (json.isJsonObject) {
      of(json.getAsJsonObject)
    } else {
      None
    }
}

case class RawBlock(format: String, txt: String) extends Block {
  def isComment = txt.startsWith("<!--") && txt.endsWith("-->")

  def innerComment = if (isComment) {
    txt.substring("<!--".length, txt.length - "-->".length)
  } else {
    Abort("Cannot take inner comment if block is not actually comment")
    ???
  }
}

object Attr {
  def of(arr: JsonArray): Option[Attr] = {
    val classes = arr.get(1)
      .getAsJsonArray
      .asScala
      .map(_.getAsString)
      .toSeq
    Some(Attr(arr.get(0).getAsString, classes, Map()))
  }

  def of(json: JsonElement): Option[Attr] =
    if (json.isJsonArray) {
      of(json.getAsJsonArray)
    } else {
      None
    }
}

case class Attr(identifier: String, classes: Seq[String], kvPairs: Map[String, String])

object CodeBlock {
  def of(json: JsonObject): Option[CodeBlock] =
    if (json.get("t").getAsString == "CodeBlock") {
      val c = json.get("c").getAsJsonArray
      Some(CodeBlock(Attr.of(c.get(0)).get, c.get(1).getAsString))
    } else {
      None
    }

  def of(json: JsonElement): Option[CodeBlock] =
    if (json.isJsonObject) {
      of(json.getAsJsonObject)
    } else {
      None
    }
}

case class CodeBlock(attributes: Attr, txt: String) extends Block
