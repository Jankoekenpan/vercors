parser grammar JavaParser;
options {tokenVocab = LangJavaLexer;}
import LangJavaParser, SpecParser;

@parser::members {
    private static int ghostLevel = 0;
}

identifier : javaIdentifier ;

extraIdentifier : valReserved ;

extraType : ('resource' | 'process' | 'frac' | 'zfrac' | 'rational');

extraAnnotation
    : 'pure'
    | 'inline'
    | 'thread_local'
    ;

extraStatement
    : 'with' block // not really a statement.
    | 'then' block // not really a statement.
    | 'given' localVariableDeclaration ';' // makes T x,y; possible
    | 'yields' localVariableDeclaration ';' // makes T x,y; possible
    | valContractClause
    | valStatement
    ;

extraPrimary
    : Identifier ':' expression // used for witness labels
    | valPrimary
    ;


extraDeclaration
    : functionDeclaration
    | axiomDeclaration
    | valContractClause
    ;

startSpec: LineStartSpec | BlockStartSpec;
endSpec: EndSpec;

/* We use the elements of the Java 7 grammar to define
 function and axiom declarations.
 */

functionDeclaration
    : modifier* type Identifier formalParameters '=' expression ';'
    ;

axiomDeclaration
    : 'axiom' Identifier '{' expression '==' expression '}'
    ;


/* The current API has only one category of specifications.
 * This is the specification sequence
 */
specificationSequence : ( classBodyDeclaration | statement )* ;

/* sequence of declarations only */
javaDeclarations : classBodyDeclaration* ;

/* sequence of statements only  */
javaStatements : statement* ;
