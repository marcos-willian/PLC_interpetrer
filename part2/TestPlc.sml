CM.make("$/basis.cm");
CM.make("$/ml-yacc-lib.cm");

use "Environ.sml";
use "Absyn.sml";
use "PlcParserAux.sml";
use "PlcParser.yacc.sig";
use "PlcParser.yacc.sml";
use "PlcLexer.lex.sml";
use "Parse.sml";
use "PlcChecker.sml";
use "PlcInterp.sml";
use "Plc.sml";

Control.Print.printLength := 1000;
Control.Print.printDepth  := 1000;
Control.Print.stringDepth := 1000;

open PlcFrontEnd;

exception NONEs;
fun r ():unit =
    case TextIO.inputLine TextIO.stdIn of
        NONE => raise NONEs
    |   SOME s =>let in print((run (fromString s)) ^"\n"); r() end;

