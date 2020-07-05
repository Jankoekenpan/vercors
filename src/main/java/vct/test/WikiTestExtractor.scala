package vct.test

import java.io.File
import java.nio.file.Path
import java.util.stream.Collectors

import com.google.gson.{Gson, JsonObject}
import hre.config.{OptionParser, StringListSetting, StringSetting}

import sys.process._
import hre.lang.System._

import scala.collection.JavaConverters._
import scala.util.Properties

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
//      print(block.getAsJsonObject.get("t"))
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
