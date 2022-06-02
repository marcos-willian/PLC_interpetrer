cls
@echo off
del PlcParser.y.sml
del PlcParser.y.sig
del PlcLexer.lex.sml

ml-yacc PlcParser.y && ml-lex PlcLexer.lex