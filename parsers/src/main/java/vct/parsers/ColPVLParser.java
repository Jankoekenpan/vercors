package vct.parsers;

import static hre.lang.System.*;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;

import hre.lang.HREExitException;
import hre.tools.TimeKeeper;
import org.antlr.v4.runtime.BailErrorStrategy;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;

import org.antlr.v4.runtime.atn.PredictionMode;
import org.antlr.v4.runtime.misc.ParseCancellationException;
import vct.antlr4.generated.PVLLexer;
import vct.antlr4.generated.PVLParser;
import vct.col.ast.stmt.decl.ProgramUnit;
import vct.parsers.rewrite.FlattenVariableDeclarations;
import vct.col.ast.syntax.PVLSyntax;
import vct.parsers.rewrite.PVLPostProcessor;
import vct.parsers.rewrite.SpecificationCollector;

/**
 * Parse specified code and convert the contents to COL. 
 */
public class ColPVLParser implements Parser {

  private static PVLParser parser = null;

  @Override
  public ProgramUnit parse(File file) {
    String file_name=file.toString();
      try {
        TimeKeeper tk=new TimeKeeper();
        ErrorCounter ec=new ErrorCounter(file_name);

        CharStream input = CharStreams.fromStream(new FileInputStream(file));
        PVLLexer lexer = new PVLLexer(input);
        lexer.removeErrorListeners();
        lexer.addErrorListener(ec);
        CommonTokenStream tokens = new CommonTokenStream(lexer);

        if (parser == null) {
          parser = new PVLParser(null);
          parser.setErrorHandler(new BailErrorStrategy());
        }
        parser.setInputStream(tokens);

        parser.removeErrorListeners();
        parser.addErrorListener(ec);

        PVLParser.ProgramContext tree;

        try {
          // First we try parsing in SLL mode (as recommended in the FAQ)
          // If that fails, it's probably a syntax error. This must however be
          // double-checked by parsing with LL mode, since some grammars fail in SLL
          // for _some_ inputs that are still valid inputs.
          parser.getInterpreter().setPredictionMode(PredictionMode.SLL);
          tree = parser.program();
        } catch (ParseCancellationException e) {
          parser.reset();
          parser.getInterpreter().setPredictionMode(PredictionMode.LL);
          tree = parser.program();
        }

        Progress("parsing pass took %dms",tk.show());
        ec.report();
        Debug("parser got: %s",tree.toStringTree(parser));

        ProgramUnit pu = PVLtoCOL.convert(tree,file_name,tokens,parser);
        Progress("AST conversion pass took %dms",tk.show());
        
        pu=new FlattenVariableDeclarations(pu).rewriteAll();
        Progress("Variable pass took %dms",tk.show());
        
        pu=new SpecificationCollector(PVLSyntax.get(),pu).rewriteAll();
        Progress("Shuffling specifications took %dms",tk.show());    
        Debug("after collecting specifications %s",pu);
        
        pu=new PVLPostProcessor(pu).rewriteAll();
        Progress("Post processing pass took %dms",tk.show());
        return pu;
      } catch(HREExitException e) {
        throw e;
      } catch (FileNotFoundException e) {
        Fail("File %s has not been found",file_name);
      } catch (Exception e) {
        DebugException(e);
        Abort("Exception %s while parsing %s",e.getClass(),file_name);
      } catch (Throwable e) {
        DebugException(e);
        Warning("Exception %s while parsing %s",e.getClass(),file_name);
        throw e;
      }
     return null;
  }

}

