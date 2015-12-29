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
spec_then(Decls) --> decl_list(Decls).

%----

decl_list(Decls) --> decl(Decls1),blanks,decl_list(Decls2),{append(Decls1,Decls2,Decls)}.
decl_list([]) --> [].

%decl([Name]) --> identifier(Name),{not(Name='end')}.
decl(Decls) --> sortdecl(Decls).
decl(Decls) --> preddecl(Decls).
decl(Decls) --> opsdecl(Decls).
decl(Decls) --> formuladecl(Decls).


%----
%::= VAR ,..., VAR : SORT
%::= QUANTIFIER VAR-DECL ;...; VAR-DECL "." FORMULA

quantifier(Q) --> quantname(Name),!,blanks,vardecl_list(Vars),{Q=..[Name|[Vars]]}.

quantname(forall) --> "forall".
quantname(exists) --> "exists".

vardecl_list([Vardecl|Vardecls]) --> vardecl(Vardecl),blanks,";",!,blanks,vardecl_list(Vardecls).
vardecl_list([Vardecl]) --> vardecl(Vardecl).

vardecl(vars(Vars:([]->Sort))) --> var_list(Vars),blanks,":",!,blanks,identifier(Sort).

var_list([Var|Vars]) --> identifier(Var),blanks,",",!,blanks,var_list(Vars).
var_list([Var]) --> identifier(Var).

formuladecl([quantified(Q,Formulas)]) --> quantifier(Q),!,blanks,formula_list(Formulas),blanks,maybe(";").
formuladecl(Formulas) --> formula_list(Formulas).

formula_list([formula(F)|Formulas]) --> ".",blanks,formula(F),blanks,formula_list(Formulas),!.
formula_list([formula(F)]) --> ".",blanks,formula(F),blanks,maybe(";").

formula([quantified(Q,Formulas)]) --> quantifier(Q),blanks,".",!,blanks,formula(Formulas).
formula(not(Formula)) --> "not",!,blanks,formula(Formula).
formula(Formula) --> "(",blanks,formula(F1),blanks,opsymbol(Name),blanks,formula(F2),blanks,")",!,{Formula=..[Name,F1,F2]}.
formula(Formula) --> identifier(Name),"(",!,blanks,arglist(Args),blanks,")",{Formula=..[Name|Args]}.
formula(Formula) --> identifier(Formula).
formula(Formula) --> "(",blanks,formula(Formula),blanks,")".

arglist([Arg|Args]) --> formula(Arg),blanks,",",!,blanks,arglist(Args).
arglist([Arg]) --> formula(Arg).

%----

opsdecl(Ops) --> ("ops";"op"),!,blanks,operator_list(Ops).

operator_list(Ops) --> operator(Ops1),blanks,";",blanks,operator_list(Ops2),{append(Ops1,Ops2,Ops)}.
operator_list(Ops) --> operator(Ops),blanks,maybe(";").

operator(Ops) --> opnames(Names),blanks,":",blanks,opsignature(Sig),{findall(op(Name,Sig),member(Name,Names),Ops)}.

opnames([Name|Names]) --> opname(Name),blanks,",",!,blanks,prednames(Names).
opnames([Name]) --> predname(Name).

opname(Name) --> "__",blanks,opsymbol(Name),blanks,"__",!.
opname(Name) --> identifier(Name).

opsymbol('=>') --> "if".
opsymbol(Atom) --> string_without(" \r\n\t_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'",Codes),{atom_codes(Atom,Codes)}.

opsignature(Signature->Sort) --> signature(Signature),blanks,"->",blanks,identifier(Sort),!.
opsignature([]->Sort) --> identifier(Sort).

%----

preddecl(Preds) --> ("preds";"pred"),!,blanks,pred_list(Preds).

pred_list(Preds) --> pred(Preds1),blanks,";",blanks,pred_list(Preds2),{append(Preds1,Preds2,Preds)}.
pred_list(Preds) --> pred(Preds),blanks,maybe(";").

pred(Predicates) --> prednames(Names),blanks,":",blanks,signature(Signature),{findall(pred(Name,Signature),member(Name,Names),Predicates)}.

prednames([Name|Names]) --> predname(Name),blanks,",",!,blanks,prednames(Names).
prednames([Name]) --> predname(Name).


predname(Name) --> "__",blanks,opsymbol(Name),blanks,"__",!.
predname(Name) --> identifier(Name).

signature([Sort|Sorts]) --> identifier(Sort),blanks,"*",blanks,signature(Sorts).
signature([Sort]) --> identifier(Sort).

%----

%Todo: sort,sort,sort sort<sort

sortdecl(Sorts) -->  ("sorts";"sort"),!,blanks,sort_listsemi(Sorts).

sort_listsemi(Sorts) --> sort_listcomma(Sorts1),blanks,";",blanks,sort_listsemi(Sorts2),{append(Sorts1,Sorts2,Sorts)}.
sort_listsemi(Sorts) --> sort_listcomma(Sorts),blanks,";".

sort_listcomma([sort(Sort)|Sorts]) --> identifier(Sort),blanks,",",blanks,sort_listcomma(Sorts).
sort_listcomma([sort(Sort)]) --> identifier(Sort).

%----

atom_without(EndCodes,Atom) --> string_without(EndCodes,Codes),{atom_codes(Atom,Codes)}.
atom_nonblanks(Atom) --> nonblanks(Codes),{atom_codes(Atom,Codes)}.

identifier(Atom) --> number(Atom),!.
identifier(Atom) --> string_without(" =:;.+*,(){}\r\n\t",Codes),{atom_codes(Atom,Codes),not(Atom='')}.

maybe(Sign)-->Sign.
maybe(_)-->[].

%----

% analogy('analogyname',domain('sourcename',[b,a]),domain('targetname',[c,d])))
transform_spec([],[],[]).
transform_spec([formula(Form)|T],Sig           ,[Form|F]):-!,transform_spec(T,Sig,F).
transform_spec([pred(N,S)    |T],[sig(N,S)|Sig],F       ):-!,transform_spec(T,Sig,F).
transform_spec([op(N,S)      |T],[sig(N,S)|Sig],F       ):-!,transform_spec(T,Sig,F).
transform_spec([quantified(forall(VarDecl),QForms)|T],SigRet,FRet):-!,
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

% %% comments
filter_comments([37,37|Codes],NewCodes):-
    append(_,[10|CodesRest],Codes),!,
    filter_comments(CodesRest,NewCodes).

% % comment %
filter_comments([37|Codes],NewCodes):-
    append(_,[37|CodesRest],Codes),!,
    filter_comments(CodesRest,NewCodes).

filter_comments([C|Codes],[C|NewCodes]):-
    filter_comments(Codes,NewCodes).


%% % text %
%% %%

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
    open(File,read,Stream),
    read_stream_to_codes(Stream,CodesWithComments),
    filter_comments(CodesWithComments,CodesWithLineEndings),
    filter_codes(CodesWithLineEndings,Codes),
    phrase(casl(Parse),Codes),!,
    %print(Parse),nl,
    Parse=casl([spec(Name,Spec)|_]),
    transform_spec(Spec,Sig,Domain).
    %print(Domain),nl,
    %print(Sig),nl.
