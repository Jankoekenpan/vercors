package vct.test

import java.io.File
import java.nio.file.Path
import java.util.stream.Collectors

import com.google.gson.{Gson, JsonArray, JsonElement, JsonObject}
import hre.config.{OptionParser, StringSetting}

import sys.process._
import hre.lang.System._

import scala.collection.JavaConverters._
import scala.util.Properties

// Pandoc datetypes

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

// Custom snip datatypes, embedded in html

case class Snip (name: String, standalone: Boolean, lang: String)

// Extractor

object WikiTestExtractor {
  /** Turns relative and absolute paths into absolute paths
    *
    * Calls Abort if PATH is not set
    */
  def findBinary(path: Path): Option[File] =
    if (path.isAbsolute) {
      val maybeFile = path.toFile
      if (maybeFile.isFile && maybeFile.canExecute) {
        Some(maybeFile)
      } else {
        None
      }
    } else {
      Properties.envOrNone("PATH") match {
        case Some(envPath) => {
          envPath.split(":").toStream
            .map(prefix => Path.of(prefix).resolve(path).toFile)
            .find(p => p.isFile && p.canExecute)
        }
        case None => {
          Abort("PATH not set")
          ???
        }
      }
    }

  def collectSnippets(pandocBin: File, file: File): Seq[String] = {
    if (!file.getAbsolutePath.contains("Exception")) {
      return Seq()
    }

    val out = new StringBuilder
    val err = new StringBuilder
    val json = s"""${pandocBin} -f gfm -t json ${file}""" ! ProcessLogger(out append _, err append _)
    if (json != 0) {
      Output(err.toString)
      Abort(s"""Pandoc error code: ${json}""")
    }
    val gson = new Gson
    val obj = gson.fromJson(out.toString(), classOf[JsonObject])
    val blocks = obj.get("blocks")
    for (block <- blocks.getAsJsonArray.iterator().asScala) {
      Block.of(block) match {
        case Some(value) => value match {
          case CodeBlock(attributes, txt) => println(s"Code block: ${attributes}")
          case r@RawBlock(format, txt) => {
            println(s"Raw block: ${format}")
            if (r.isComment) {
              println(r.innerComment)
            }
          }
          case _ => ()
        }
        case None => ()
      }
    }
    Seq()
  }

  def main(args: Array[String]): Unit = {
    hre.lang.System.setOutputStream(System.out, hre.lang.System.LogLevel.All)
    hre.lang.System.setErrorStream(System.err, hre.lang.System.LogLevel.All)

    val clops = new OptionParser
    clops.add(clops.getHelpOption, "help")

    val wikiPathOpt = new StringSetting("./vercors.wiki")
    clops.add(wikiPathOpt.getAssign("Path to vercors wiki directory"), "wiki-path")

    val pandocPathOpt = new StringSetting("pandoc")
    clops.add(pandocPathOpt.getAssign("Path to pandoc binary"), "pandoc-path")

    val input: Array[String] = clops.parse(args)

    val pandocPathStr = pandocPathOpt.get()
    val pandocPath = Path.of(pandocPathStr)
    val pandocBin = findBinary(Path.of(pandocPathStr)) match {
      case Some(p) => p
      case None => Abort(s"""Could not resolve pandoc binary path "${pandocPath.toString}""""); ???
    }

    println(s"""Using pandoc binary: ${pandocBin}""")

    val wikiDir = if (wikiPathOpt.used()) {
      val wikiPath = Path.of(wikiPathOpt.get()).toFile
      if (wikiPath.isDirectory) {
        wikiPath
      } else {
        Abort("Wiki path is not a dir")
        ???
      }
    } else {
      Abort("Wiki path not set")
      ???
    }

    println(s"""Using wiki dir: ${wikiDir}""")

    val wikiFiles = wikiDir.listFiles()
      .filter(p => p.isFile && p.getName.endsWith(".md"))
      .map(p => {
        println(s"""Processing ${p}""")
        collectSnippets(pandocBin, p)
      })
      .toSeq

    println(wikiFiles)

//    s"""${pandocBin} --help""" ! ProcessLogger(line => println(line), err => ())

    // pandoc -f gfm -t json vercors.wiki/Tutorial-Exceptions.md
  }
}
