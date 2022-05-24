
%%

%name PlcParser

%pos int

%term  NUM of int | NAME of string | TRUE | FALSE 
    |  OPnot  | OPminus | HD | TL | ISE | PRINT | OPdisjun | OPplus | OPtimes | OPdiv | OPequal | OPVbar
    | OPdiff | OPless | OPlessEq | OP2cons | OPsemicolon | OParrow | OP2arrow | OPcons | OPunder | OPcolon
    |  Lbrace | Rbrace | Lpar | Rpar | Lbracket | Rbracket 
    |  FUN  | REC |IF | THEN | ELSE | MATCH | WITH | VAR | FN | END | NIL | BOOL | INT 
    |  EOF  | NEWLINE

%right OPsemicolon OParrow
%nonassoc IF 
%left ELSE
%left OPdisjun
%left OPequal OPdiff
%left OPless OPlessEq
%right OP2cons 
%left OPplus OPminus
%left OPtimes OPdiv
%nonassoc OPnot HD TL ISE PRINT 
%left Lbracket

%keyword FUN REC IF THEN ELSE MATCH WITH VAR FN END NIL BOOL INT FALSE TRUE HD TL PRINT OPunder
%nonterm PLC of expr | prog of expr | EXPR of expr  | decl of string*expr | args | type | atomicExpr of expr | appExpr of expr 
        |matchExpr of (expr option * expr) list | condExpr of expr option
        |const of expr | comps of expr| typedVar | params | types | atomicType

%eop EOF NEWLINE

%noshift EOF

%start PLC

%%
PLC:        prog                        ( prog )
prog:       EXPR                        ( EXPR )      
    |       decl OPsemicolon prog       ( Let(#1 decl, #2 decl, prog) )

decl:       VAR NAME OPequal EXPR       ( (NAME, EXPR) )
    |       FUN NAME args OPequal EXPR  ( (NAME, EXPR) )
    |       FUN REC NAME args OPcons type OPequal EXPR ( (NAME, EXPR) )

EXPR:       atomicExpr                  ( atomicExpr )
    |       appExpr                     ( appExpr )
    |       IF EXPR THEN EXPR ELSE EXPR ( If(EXPR1, EXPR2, EXPR3) )
    |       MATCH EXPR WITH matchExpr   ( Match(EXPR, matchExpr) )
    |       OPnot EXPR                  ( Prim1("!", EXPR) )
    |       OPminus EXPR                ( Prim1("-", EXPR) )
    |       HD EXPR                     ( Prim1("hd", EXPR) )
    |       TL EXPR                     ( Prim1("tl", EXPR) )
    |       ISE EXPR                    ( Prim1("ise", EXPR) )
    |       PRINT EXPR                  ( Prim1("print", EXPR) )
    |       EXPR OPdisjun EXPR          ( Prim2("&&", EXPR1, EXPR2) )
    |       EXPR OPplus EXPR            ( Prim2("+", EXPR1 , EXPR2 ) )
    |       EXPR OPminus EXPR           ( Prim2("-", EXPR1 , EXPR2 ) )
    |       EXPR OPtimes EXPR           ( Prim2("*", EXPR1 , EXPR2 ) )
    |       EXPR OPdiv EXPR             ( Prim2("/", EXPR1 , EXPR2 ) )
    |       EXPR OPequal EXPR           ( Prim2("=", EXPR1 , EXPR2 ) )
    |       EXPR OPdiff EXPR            ( Prim2("<>", EXPR1 , EXPR2 ) )
    |       EXPR OPless EXPR            ( Prim2("<", EXPR1 , EXPR2 ) )
    |       EXPR OPlessEq EXPR          ( Prim2("<=", EXPR1 , EXPR2 ) )
    |       EXPR OP2cons EXPR           ( Prim2("::", EXPR1 , EXPR2 ) )
    |       EXPR OPsemicolon EXPR       ( EXPR1 ; EXPR2 )
    |       EXPR Lbracket NUM Rbracket  ( )

atomicExpr: const                       ( const )
    |       NAME                        ( Var NAME )
    |       Lbrace prog Rbrace          ( )
    |       Lpar EXPR Rpar              ( )
    |       comps                       ( )
    |       FN args OP2arrow EXPR END   ( )

appExpr:    atomicExpr atomicExpr       ( atomicExpr atomicExpr )
    |       appExpr atomicExpr          ( appExpr atomicExpr )

const:      TRUE                        ( ConB true )
    |       FALSE                       ( ConB false)
    |       NUM                         ( ConI NUM )
    |       Lpar Rpar                   ( List [] )
    |       Lpar type Lbracket Rbracket Rpar    ( )

comps:      EXPR OPcolon EXPR           ( )
    |       EXPR OPcolon comps          ( )

matchExpr:  END                         ( [ ] )
    |       OPVbar condExpr OParrow EXPR matchExpr ( (condExpr, EXPR)::matchExpr )

condExpr:   EXPR                        ( SOME (EXPR) )
    |       OPunder                     ( NONE )

args:       Lpar Rpar                   ( )
    |       Lpar params Rpar            ( )

params:     typedVar                    ( )
    |       typedVar OPcolon params     ( )

typedVar:   type NAME                   ( )

type:       atomicType                  ( )
    |       Lpar types Rpar             ( )

atomicType: NIL                         ( )
    |       BOOL                        ( )
    |       INT                         ( )
    |       Lpar type Rpar              ( )

types:      type OPcolon type           ( )
    |       type OPcolon types          ( )

