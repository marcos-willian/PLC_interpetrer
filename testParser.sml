(* Infrastructure to run the Plc Front-End *)

CM.make("$/basis.cm");
CM.make("$/ml-yacc-lib.cm");

use "Environ.sml";
use "Absyn.sml";
use "PlcParserAux.sml";
use "PlcParser.y.sig";
use "PlcParser.y.sml";
use "PlcLexer.lex.sml";
use "Parse.sml";

Control.Print.printLength := 1000;
Control.Print.printDepth  := 1000;
Control.Print.stringDepth := 1000;

open PlcFrontEnd;

fromString "15";
fromString "true";
fromString "()";
fromString "(6,false)";
fromString "(6,false)[1]";
fromString "([Bool] [])";
fromString "print x; true";
fromString "3::7::t";
fromString "fn (Int x) => -x end";
fromString "var x = 9; x + 3";
fromString "fun f(Int x) = x; f(1)";
fromString "match x with | 0 -> 1| _ -> -1 end";
fromString "fun f(Int x, Int y) = x - y; f(5,4)";
fromString "fun rec f (Int x) : Int = if x <= 0 then 1 else x + f(x-1); f(5)";
fromString "fun rec len([Int] l): Int = if ise(l) then 0 else 1 + len(tl(l)); len(1::2::([Int] [])) (*Teste*)";

use "testParserCases.sml"; (*Testa o arquivo de testes, retornando uma lista de booleanos
se todos os elementos da lista forem true, todos os testes passaram*)

(*)
use "testParserCases.sml"*)

(* Try to add a systematic way of using the test cases in
   testParserCases to stress test your parser *)


