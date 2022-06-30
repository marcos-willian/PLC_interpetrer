(* PlcInterp *)


exception Impossible
exception HDEmptySeq
exception TLEmptySeq
exception ValueNotFoundInMatch
exception NotAFunc

fun eval (expr:expr) (env:plcVal env) : plcVal =
    case expr of
          ConI(n) => IntV(n)
        | ConB(b) => BoolV(b)
        | ESeq(t) => SeqV []
        | Var(x) => lookup env x
        | Let(var,init,prog) => 
            eval prog ((var,(eval init env))::env)
        (*| Letrec(funName,parT,par,retT,body,prog) => 
            let
                val envN = (par, parT)::env
                val envNew = (funName,FunT(parT, retT))::envN
                val t1 = teval body envNew
            in *)
        | Prim1(opr,exp) =>
            (case opr of
                  "!" => if eval exp env = BoolV(false) then
                            BoolV(true) 
                         else
                            BoolV(false)
            )         




