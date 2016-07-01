:- module(casl_parser,[parse_casl/3,read_casl/3,casl/3,casl_symbol/1]).

casl_symbol(Atom):-
  member(Atom,['true','false','=','=e=','not','/\\','\\/','=>','<=>']).

% swipl -G0 -T0 -L0 -s hdtp.pro -t "parse_casl(\"spec Atom = . a; end\",\"spec Atom = . a\r\n.b; end\",X),print(X).
% swipl -G0 -T0 -L0 -s hdtp.pro -t "read_casl(\"../test.txt\",\"../test.txt\",X),print(X)."

casl(casl(Specs)) --> header,specs(Specs),blanks.


header --> blanks,"logic",blanks,"CASL",blanks,!.
header --> blanks.

specs([]) --> [].

specs([Spec]) --> spec(Spec).

specs([Spec|Specs]) --> spec(Spec),blanks,specs(Specs).



spec(spec(Name,Decls)) -->
         "spec",blanks,identifier(Name),blanks,"=",!,blanks,
         spec_then(Decls),blanks,
         "end".

%spec_then(Decls) --> decl_list(Decls1),blanks,"then",!,blanks,spec_then(Decls2),{append(Decls1,Decls2,Decls)}.
spec_then(Decls) --> decl_list([],Decls).

%----

decl_list(Decls1,Decls4) --> decl(Decls1,Decls2),blanks,{append(Decls1,Decls2,Decls3)},decl_list(Decls3,Decls4).
decl_list(Decls,Decls) --> [].

%decl([Name]) --> identifier(Name),{not(Name='end')}.
decl(_,Decls) --> sortdecl(Decls).
decl(_,Decls) --> preddecl(Decls).
decl(_,Decls) --> opsdecl(Decls).
decl(OpDecls,Decls) --> formuladecl(OpDecls,Decls).


%----
%::= VAR ,..., VAR : SORT
%::= QUANTIFIER VAR-DECL ;...; VAR-DECL "." FORMULA

quantifier_chain(Q) --> quantifier_chain_aux(Name,[],Vars),{nonvar(Name),Vars\=[],Q=..[Name,Vars]}.
quantifier_chain_aux(Name,Vars1,Vars2) --> ".",blanks,quantifier(Name,Vars),!,blanks,{append(Vars1,Vars,Vars3)},quantifier_chain_aux(Name,Vars3,Vars2).
quantifier_chain_aux(_Name,Vars,Vars) --> [].

quantifier(Name,Vars) --> quantname(Name),!,blanks,vardecl_list(Vars).

quantname(forall) --> "forall".
quantname(exists) --> "exists".

vardecl_list([Vardecl|Vardecls]) --> vardecl(Vardecl),blanks,";",!,blanks,vardecl_list(Vardecls).
vardecl_list([Vardecl]) --> vardecl(Vardecl).

vardecl(vars(Vars:([]->Sort))) --> var_list(Vars),blanks,":",!,blanks,identifier(Sort).

var_list([Var|Vars]) --> identifier(Var),blanks,",",!,blanks,var_list(Vars).
var_list([Var]) --> identifier(Var).

formuladecl(OpDecls,[quantified(Q,Formulas)]) --> quantifier_chain(Q),!,blanks,formula_list(OpDecls,Formulas).
formuladecl(OpDecls,Formulas) --> formula_list(OpDecls,Formulas).

formula_list(OpDecls,[formula(F)|Formulas]) --> ".",blanks,formula(OpDecls,F),blanks,formula_list(OpDecls,Formulas),!.
formula_list(OpDecls,[formula(F)]) --> ".",blanks,formula(OpDecls,F),blanks,";".

formula(OpDecls,Formula) --> biformula(OpDecls,Formula).

biformula(OpDecls,Formula) --> impformula(OpDecls,F), blanks, biformula_aux(OpDecls,F,Formula).
biformula_aux(OpDecls,F1,Formula) --> "<=>",!, blanks, impformula(OpDecls,F2),{F3=..['<=>',F1,F2]}, blanks, biformula_aux(OpDecls,F3,Formula).
biformula_aux(_OpDecls,F,F) --> {}.

impformula(OpDecls,Formula) --> conformula(OpDecls,F), blanks, impformula_aux(OpDecls,F,Formula).
impformula_aux(OpDecls,F1,Formula) --> "=>",!, blanks, conformula(OpDecls,F2),{F3=..['=>',F1,F2]}, blanks, impformula_aux(OpDecls,F3,Formula).
impformula_aux(_OpDecls,F,F) --> {}.

conformula(OpDecls,Formula) --> eqformula(OpDecls,F), blanks, conformula_aux(OpDecls,F,Formula).
conformula_aux(OpDecls,F1,Formula) --> "/\\",!, blanks, eqformula(OpDecls,F2),{F3=..['/\\',F1,F2]}, blanks, conformula_aux(OpDecls,F3,Formula).
conformula_aux(OpDecls,F1,Formula) --> "\\/",!, blanks, eqformula(OpDecls,F2),{F3=..['\\/',F1,F2]}, blanks, conformula_aux(OpDecls,F3,Formula).
conformula_aux(_OpDecls,F,F) --> {}.

eqformula(OpDecls,Formula) --> opformula(OpDecls,F), blanks, eqformula_aux(OpDecls,F,Formula).
eqformula_aux(OpDecls,F1,Formula) --> "= ",!,blanks, opformula(OpDecls,F2),{F3=..['=',F1,F2]}, blanks, eqformula_aux(OpDecls,F3,Formula).
eqformula_aux(_OpDecls,F,F) --> {}.

opformula(OpDecls,Formula) --> iformula(OpDecls,F), blanks, opformula_aux(OpDecls,F,Formula).
opformula_aux(OpDecls,F1,Formula) --> opsymbol(Name)," ",{atomic_list_concat(["__",Name,"__"],OpName),(member(op(OpName,_),OpDecls);member(pred(OpName,_),OpDecls))},!,blanks,iformula(OpDecls,F2),{F3=..[Name,F1,F2]}, blanks, opformula_aux(OpDecls,F3,Formula).
opformula_aux(_OpDecls,F,F) --> {}.


%%iformula(OpDecls,[quantified(Q,Formulas)]) --> quantifier(Q),!,blanks,formula_list(OpDecls,Formulas).
iformula(OpDecls,not(Formula)) --> "not",!,blanks,iformula(OpDecls,Formula).
iformula(OpDecls,Formula) --> "(",blanks,formula(OpDecls,Formula),blanks,")".
iformula(OpDecls,Formula) --> identifier(Name),"(",!,blanks,arglist(OpDecls,Args),blanks,")",{Formula=..[Name|Args]}.
iformula(_OpDecls,Formula) --> identifier(Formula).

arglist(OpDecls,[Arg|Args]) --> formula(OpDecls,Arg),blanks,",",!,blanks,arglist(OpDecls,Args).
arglist(OpDecls,[Arg]) --> formula(OpDecls,Arg).

%----

opsdecl(Ops) --> ("ops";"op"),!,blanks,operator_list(Ops).

operator_list(Ops) --> operator(Ops1),blanks,";",blanks,operator_list(Ops2),{append(Ops1,Ops2,Ops)}.
operator_list(Ops) --> operator(Ops),blanks,maybe(";").

operator(Ops) --> opnames(Names),blanks,":",blanks,opsignature(Sig),{findall(op(Name,Sig),member(Name,Names),Ops)}.

opnames([Name|Names]) --> opname(Name),blanks,",",!,blanks,prednames(Names).
opnames([Name]) --> predname(Name).

opname(Name) --> "__",blanks,opsymbol(InfixName),blanks,"__",!,{atomic_list_concat(["__",InfixName,"__"],Name)}.
opname(Name) --> identifier(Name).

opsymbol(Atom) --> string_without(" .;()\r\n\t_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'",Codes),{atom_codes(Atom,Codes)}.

opsignature(Signature->Sort) --> signature(Signature),blanks,"->",blanks,identifier(Sort),!.
opsignature([]->Sort) --> identifier(Sort).

%----

preddecl(Preds) --> ("preds";"pred"),!,blanks,pred_list(Preds).

pred_list(Preds) --> pred(Preds1),blanks,";",blanks,pred_list(Preds2),{append(Preds1,Preds2,Preds)}.
pred_list(Preds) --> pred(Preds),blanks,maybe(";").

pred(Predicates) --> prednames(Names),blanks,":",blanks,signature(Signature),{findall(pred(Name,Signature),member(Name,Names),Predicates)}.

prednames([Name|Names]) --> predname(Name),blanks,",",!,blanks,prednames(Names).
prednames([Name]) --> predname(Name).


predname(Name) --> "__",blanks,opsymbol(InfixName),blanks,"__",!,{atomic_list_concat(["__",InfixName,"__"],Name)}.
predname(Name) --> identifier(Name).

signature([Sort|Sorts]) --> identifier(Sort),blanks,"*",blanks,signature(Sorts).
signature([Sort]) --> identifier(Sort).

%----

sortdecl([]) -->  ("sorts";"sort"),blanks,identifier(_),blanks,"=",!,blanks,subsortdecl,maybe(";").
sortdecl(Sorts) -->  ("sorts";"sort"),blanks,sort_listsemi(Sorts).

sort_listsemi(Sorts) --> sort_list(Sorts1),blanks,";",blanks,sort_list(Sorts2),{append(Sorts1,Sorts2,Sorts)}.
sort_listsemi(Sorts) --> sort_list(Sorts),blanks,";".

sort_list(Sorts) --> sort_listcomma(Sorts).
sort_list([]) --> sort_listsubsort.

sort_listcomma([sort(Sort)|Sorts]) --> identifier(Sort),blanks,",",blanks,sort_listcomma(Sorts).
sort_listcomma([sort(Sort)]) --> identifier(Sort).

sort_listsubsort --> identifier(_),blanks,",",blanks,sort_listsubsort.
sort_listsubsort --> identifier(_),blanks,"<",blanks,identifier(_).


subsortdecl --> "{",blanks,identifier(_),blanks,":",blanks,identifier(_),blanks,".",blanks,formula([],_),blanks,"}".

%----

atom_without(EndCodes,Atom) --> string_without(EndCodes,Codes),{atom_codes(Atom,Codes)}.
atom_nonblanks(Atom) --> nonblanks(Codes),{atom_codes(Atom,Codes)}.

identifier(Atom) --> number(Atom),!.
identifier(Atom) --> string_without(" \\/=:;.+*,(){}\r\n\t",Codes),{atom_codes(Atom,Codes),not(Atom='')}.

maybe(Sign)-->Sign.
maybe(_)-->[].

%----

% analogy('analogyname',domain('sourcename',[b,a]),domain('targetname',[c,d])))
transform_spec([],[],[]).
transform_spec([formula(Form)|T],Sig           ,[Form|F]):-!,transform_spec(T,Sig,F).
transform_spec([pred(N,S)    |T],[sig(N,S)|Sig],F       ):-!,transform_spec(T,Sig,F).
transform_spec([op(N,S)      |T],[sig(N,S)|Sig],F       ):-!,transform_spec(T,Sig,F).
transform_spec([quantified(forall(VarDecl),QForms)|T],SigRet,FRet):-!,
    %print(QForms),nl,
    collect_qvars(VarDecl,VSig,VarMap),
    convert_qforms(QForms,VSig,CSig,VarMap,CForms),
    append(CForms,F,FRet),
    append(CSig,Sig,SigRet),
    transform_spec(T,Sig,F).

transform_spec([_|T],Sig,F):-  transform_spec(T,Sig,F).

convert_qforms([],_VSig,[],_VarMap,[]).
convert_qforms([formula(Form)|Forms],VSig,CSig,VarMap,[CForm|CForms]):-
    copy_term((Form,VarMap,VSig),(FormCopy,VarMapCopy,VSigCopy)),
    append(VSigCopy,CSigRet,CSig),
    convert_qform(FormCopy,VarMapCopy,CForm),
    convert_qforms(Forms,VSig,CSigRet,VarMap,CForms).

convert_qform(Atom,Varmap,Var):-
    atom(Atom),
    member(Atom:Var,Varmap),!.

convert_qform(Form,Varmap,CForm):-
    Form=..[Sym|Args],
    convert_qargs(Args,Varmap,CArgs),
    CForm=..[Sym|CArgs].

convert_qargs([],_VarMap,[]).
convert_qargs([Arg|Args],VarMap,[CArg|CArgs]):-
    convert_qform(Arg,VarMap,CArg),
    convert_qargs(Args,VarMap,CArgs).

collect_qvars([],[],[]).
collect_qvars([vars(Varnames:Type)|Rest],Sig,Varmap):-
    add_varnames(Varnames,Type,VarSig,VarmapNew),
    append(VarmapNew,VarmapRet,Varmap),
    append(VarSig,SigRet,Sig),
    collect_qvars(Rest,SigRet,VarmapRet).

add_varnames([],_Type,[],[]).
add_varnames([Name|Rest],Type,[sig(Var,Type)|SigRet],[Name:Var|VarmapRet]):-
    put_attr(Var,sig,Type),
    add_varnames(Rest,Type,SigRet,VarmapRet).


parse_casl(Casl,Hdtp) :-
    atom_codes(Casl,Codes),
    phrase(casl(Parse),Codes),!,
    transform(Parse,Hdtp).

% hacked comment filter - not syntax aware
filter_comments([],[]).

% comments
filter_comments([37,37|Codes],NewCodes):-
    append(_,[10|CodesRest],Codes),!,
    filter_comments(CodesRest,NewCodes).

% comment
filter_comments([37|Codes],NewCodes):-
    append(_,[37|CodesRest],Codes),!,
    filter_comments(CodesRest,NewCodes).

filter_comments([C|Codes],[C|NewCodes]):-
    filter_comments(Codes,NewCodes).


%
%
filter_codes([],[]).

filter_codes([C|Codes],R):-
    member(C,[9,10,13]),!,   % \t\n\r
    filter_codes(Codes,R).

filter_codes([C|Codes],[C|R]):-
    filter_codes(Codes,R).

parse_casl(String1,String2,analogy('',Domain1,Domain2)):-
    parse_casl_domain(String1,Domain1),
    parse_casl_domain(String2,Domain2).

read_casl(File1,File2,analogy('',Domain1,Domain2)):-
    read_casl_domain(File1,Domain1),
    read_casl_domain(File2,Domain2).

parse_casl_domain(String,domain(Name,Sig,Domain)) :-
    string_codes(String,CodesWithComments),
    filter_comments(CodesWithComments,CodesWithLineEndings),
    filter_codes(CodesWithLineEndings,Codes),
    phrase(casl(Parse),Codes),
    !,
    Parse=casl([spec(Name,Spec)|_]),
    transform_spec(Spec,Sig,Domain).

read_casl_domain(File,domain(Name,Sig,Domain)) :-
    catch(open(File,read,Stream),E,(print_message(error,E),halt)),
    read_stream_to_codes(Stream,CodesWithComments),
    close(Stream),
    filter_comments(CodesWithComments,CodesWithLineEndings),
    filter_codes(CodesWithLineEndings,Codes),
    phrase(casl(Parse),Codes),!,
    %print(Parse),nl,
    Parse=casl([spec(Name,Spec)|_]),
    transform_spec(Spec,Sig,Domain).
    %print(Domain),nl,
    %print(Sig),nl.
