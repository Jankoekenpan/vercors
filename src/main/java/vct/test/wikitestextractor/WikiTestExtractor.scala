package vct.test.wikitestextractor

import java.io.File
import java.nio.file.Path

import com.google.gson.{Gson, JsonObject}
import hre.config.{OptionParser, StringSetting}
import hre.lang.System._

import scala.collection.JavaConverters._
import scala.collection.mutable
import scala.sys.process._
import scala.util.Properties

object WikiTestExtractor {
  /** Turns relative and absolute paths into absolute paths, given the PATH variable
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

  def collectSnippets(pandocBin: File, file: File): Seq[Snip] = {
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

    var previousSnip: Snip = null
    val snips = mutable.ArrayBuffer[Snip]()

    for (block <- blocks.getAsJsonArray.iterator().asScala) {
      Block.of(block) match {
        case Some(value) => value match {
          case CodeBlock(attributes, txt) =>
            if (previousSnip != null && attributes.classes.nonEmpty) {
              previousSnip.appendContents(txt)
              previousSnip.setOption("language", attributes.classes.head)
              snips.append(previousSnip)
              previousSnip = null
            }

          case r: RawBlock =>
            Snip.of(r) match {
              case Some(snip) => {
                if (snip.isStandalone) {
                  snips.append(snip)
                } else {
                  previousSnip = snip
                }
              }
              case _ => ()
            }

          case _ => if (previousSnip != null)
            println("Discarding previousSnip " + previousSnip)
            previousSnip = null
        }
        case None => ()
      }
    }
    snips.toSeq
  }

  def groupSnippets(snips: Seq[Snip]): Seq[(String, String)] = {
    val snipTotalContents = mutable.Map[String, String]().withDefaultValue("")
    for (snip <- snips) {
      val snipName = snip.options("name")
      val totalContents = snipTotalContents(snipName)
      snipTotalContents.put(snipName, totalContents + snip.contents)
    }
    snipTotalContents.toSeq
  }

  def main(args: Array[String]): Unit = {
    hre.lang.System.setOutputStream(System.out, hre.lang.System.LogLevel.All)
    hre.lang.System.setErrorStream(System.err, hre.lang.System.LogLevel.All)

    val clops = new OptionParser
    clops.add(clops.getHelpOption, "help")

    val wikiPathOpt = new StringSetting(null)
    clops.add(wikiPathOpt.getAssign("Path to vercors wiki directory"), "wiki-path")

    val pandocPathOpt = new StringSetting(null)
    clops.add(pandocPathOpt.getAssign("Path to pandoc binary"), "pandoc-path")

    val input: Array[String] = clops.parse(args)
    if (input.length != 0) {
      for (arg <- input) {
        Output(arg)
      }
      Abort("There were unused arguments")
    }

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

    println(s"Using wiki dir: ${wikiDir}")

    val wikiFiles = wikiDir.listFiles()
      .filter(p => p.isFile && p.getName.endsWith(".md"))
      .flatMap(p => {
        println(s"Processing ${p}")
        val snips = collectSnippets(pandocBin, p)
        groupSnippets(snips)
      })
      .toSeq

    println(s"Num test files collected: ${wikiFiles.length}")
  }
}
