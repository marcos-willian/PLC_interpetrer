
%%

%name PlcParser

%pos int

%term NUM of int | EOF
%nonterm PLC of expr

%eop EOF

%noshift EOF

%start PLC

%%

PLC : NUM       (ConI(NUM))
