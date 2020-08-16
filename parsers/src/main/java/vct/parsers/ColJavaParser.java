

package vct.parsers;

import static hre.lang.System.*;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;

import hre.tools.TimeKeeper;
import org.antlr.v4.runtime.BailErrorStrategy;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.Lexer;

import org.antlr.v4.runtime.atn.PredictionMode;
import org.antlr.v4.runtime.misc.ParseCancellationException;
import vct.antlr4.generated.*;
import vct.col.ast.stmt.decl.ProgramUnit;
import vct.parsers.rewrite.*;
import vct.col.ast.syntax.JavaDialect;
import vct.col.ast.syntax.JavaSyntax;

/**
 * Parse specified code and convert the contents to COL. 
 */
public class ColJavaParser implements Parser {

  public final int version;
  public final boolean twopass;
  public final boolean topLevelSpecs;

  private static JavaParser javaParser = null;

  public ColJavaParser(int version, boolean twopass, boolean topLevelSpecs){
    this.version=version;
    this.twopass=twopass;
    this.topLevelSpecs = topLevelSpecs;

    if (javaParser == null) {
      javaParser = new JavaParser(null);
      javaParser.setErrorHandler(new BailErrorStrategy());
    }
  }

  @Override
  public ProgramUnit parse(File file) {
    String file_name=file.toString();
      try {
        TimeKeeper tk=new TimeKeeper();

        CharStream input = CharStreams.fromStream(new FileInputStream(file));

        ProgramUnit pu;
        ErrorCounter ec=new ErrorCounter(file_name);

        if (version != 7) {
          Abort("Only Java 7 supported");
        }

        Lexer lexer = new LangJavaLexer(input);
        CommonTokenStream tokens = new CommonTokenStream(lexer);

        javaParser.reset();
        javaParser.setInputStream(tokens);

        javaParser.removeErrorListeners();
        javaParser.addErrorListener(ec);
        lexer.removeErrorListeners();
        lexer.addErrorListener(ec);

        JavaParser.CompilationUnitContext tree;

        if(this.topLevelSpecs) {
          javaParser.specLevel = 1;
        } else {
          javaParser.specLevel = 0;
        }

        try {
          // First we try parsing in SLL mode (as recommended in the FAQ)
          // If that fails, it's probably a syntax error. This must however be
          // double-checked by parsing with LL mode, since some grammars fail in SLL
          // for _some_ inputs that are still valid inputs.
          javaParser.getInterpreter().setPredictionMode(PredictionMode.SLL);
          tree = javaParser.compilationUnit();
        } catch (ParseCancellationException e) {
          javaParser.reset();
          javaParser.getInterpreter().setPredictionMode(PredictionMode.LL);
          tree = javaParser.compilationUnit();
        }

        ec.report();
        Progress("first parsing pass took %dms",tk.show());

        pu=JavaJMLtoCOL.convert(tree,file_name,tokens,javaParser);
        Progress("AST conversion took %dms",tk.show());
        Debug("program after Java parsing:%n%s",pu);

        pu=new FlattenVariableDeclarations(pu).rewriteAll();
        Progress("Flattening variables took %dms",tk.show());
        Debug("program after flattening variables:%n%s",pu);

        pu=new SpecificationCollector(JavaSyntax.getJava(JavaDialect.JavaVerCors),pu).rewriteAll();
        Progress("Shuffling specifications took %dms",tk.show());
        Debug("program after collecting specs:%n%s",pu);

        pu=new JavaPostProcessor(pu).rewriteAll();
        Progress("post processing took %dms",tk.show());

        pu = new RewriteWithThen(pu).rewriteAll();
        Progress("rewriting with/then blocks took %dms", tk.show());

        pu=new AnnotationInterpreter(pu).rewriteAll();
        Progress("interpreting annotations took %dms",tk.show());

        pu=new FilterSpecIgnore(pu).rewriteAll();
        Progress("filtering spec_ignore took %dms",tk.show());

        return pu;
      } catch (FileNotFoundException e) {
        Fail("File %s has not been found",file_name);
      } catch (Exception e) {
        DebugException(e);
        Abort("Exception %s while parsing %s",e.getClass(),file_name);
      } catch (Throwable e){
        DebugException(e);
        Warning("Exception %s while parsing %s",e.getClass(),file_name);
        throw e;
      }
    return null;
  }

}

