(* Plc Lexer *)

(* User declarations *)

open Tokens
type pos = int
type slvalue = Tokens.svalue
type ('a,'b) token = ('a,'b) Tokens.token
type lexresult = (slvalue, pos)token

(* A function to print a message error on the screen. *)
val error = fn x => TextIO.output(TextIO.stdOut, x ^ "\n")
val lineNumber = ref 0
val pos = ref 0

(* Get the current line being read. *)
fun getLineAsString() =
    let
        val lineNum = !lineNumber
    in
        Int.toString lineNum
    end

(* Define what to do when the end of the file is reached. *)
fun eof () = Tokens.EOF(!pos,!pos)

(* Initialize the lexer. *)
fun init() = ()
%%
%header (functor PlcLexerFun(structure Tokens: PlcParser_TOKENS));
digit=[0-9];
name=[a-z A-Z "_"][a-z A-Z "_" 0-9]*;
ws = [\ \t];

%%

{ws}+       => (lex());
{digit}+    => (Tokens.NUM (valOf (Int.fromString yytext), !pos, !pos));
{name}+     => (case yytext of
                    "var" => Tokens.VAR (!pos, !pos)
                |   _ => Tokens.NAME (yytext, !pos, !pos));
"="         => (Tokens.OPequal (!pos, !pos));
"+"         => (Tokens.OPplus (!pos, !pos));
"var"       => (Tokens.VAR (!pos, !pos));
";"         => (Tokens.OPsemicolon(!pos, !pos));
