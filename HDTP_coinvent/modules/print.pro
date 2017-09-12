:- module(print,[print_withattributes/1,
                 print_result/1,
                 print_result_list/1,
                 print_antiinstance/1,
                 print_antiinstances/1,
                 print_term/1,
                 print_term_follow_links/1,
                 print_generalisation_term/1,
                 print_variable_name/1,
                 print_variable_names/1,
                 print_pretty_domain/1,
                 print_pretty_generalisation_domain/1,
                 print_pretty_generalisation_term/1,
                 print_pretty_results/1,
                 print_pretty_antiu_results/1,
                 print_casl/1]).

% print_pretty_X are predicates meant for user output of internal structures

print_casl(Preanalogy):-
    print_casl_mapping(Preanalogy).

print_casl_mapping(preanalogy(Cost,_Source,_Target,Generalisation,_Transfer)):-
    set_prolog_flag(gc,false),
    collect_struct_variables(Generalisation,Variables),
    extract_mappings(Variables,Mappings),
    sort(Mappings,Mappings_sort),
    nl,
    flag(sourcedomainname,S_domain_name,S_domain_name),
    flag(targetdomainname,T_domain_name,T_domain_name),    
    flag(genoutputnumber,Gen_number,Gen_number),
    plus(1,Gen_number,Gen_number_succ),
    flag(genoutputnumber,_,Gen_number_succ),
    format('spec Generalisation~w =',[Gen_number]),
    nl,
    print_casl_sigs(Mappings_sort,[],_Gsorts),
    print_pretty_casl_generalisation_terms(Generalisation),
    write('end'),nl,
    nl,
    format('%Generalisation~d mapping ~w to ~w Cost = ~d',[Gen_number,S_domain_name,T_domain_name,Cost]),nl,
    nl,
    format('view mapping~d_1 : Generalisation~d to ~w =',[Gen_number,Gen_number,S_domain_name]),nl,
    filter_symbol_mappings(Mappings_sort,Mappings_symbols),
    print_casl_mapping_source(Mappings_symbols),nl,
    nl,
    format('view mapping~d_2 : Generalisation~d to ~w =',[Gen_number,Gen_number,T_domain_name]),nl,
    print_casl_mapping_target(Mappings_symbols),nl,
    format('spec blend = combine mapping~d_1, mapping~d_2',[Gen_number,Gen_number]),nl,
    nl,
    set_prolog_flag(gc,true).

print_casl_sigs([],Sorts,Sorts).

print_casl_sigs([mapping(Svar,Var,Tvar)|Mappings],Sorts,Sorts_out):-!,
    get_attr(Svar,sig,Ssig),
    get_attr(Tvar,sig,Tsig),
    print_casl_sig(Var,Ssig,Tsig,Sorts,Sorts_new),
    print_casl_sigs(Mappings,Sorts_new,Sorts_out).


print_casl_sigs([mapping(_,Svar,Var,Tvar,_)|Mappings],Sorts,Sorts_out):-
    get_attr(Svar,sig,Ssig),
    get_attr(Tvar,sig,Tsig),
    generalisation_casl_atom(Var,Varatom),
    print_casl_sig(Varatom,Ssig,Tsig,Sorts,Sorts_new),
    print_casl_sigs(Mappings,Sorts_new,Sorts_out).

print_casl_sig(Var,[]->Ssort,[]->Tsort,Sorts,Sorts_new):-
    var(Var),!,
    merge_sort(Ssort,Tsort,_Msort,Sorts,Sorts_new).

print_casl_sig(Varatom,[]->Ssort,[]->Tsort,Sorts,Sorts_new):-
    !,
    merge_sorts([Ssort],[Tsort],[Msort],Sorts,Sorts_new),
    format('op ~w : ~w;',[Varatom,Msort]),nl.

print_casl_sig(Varatom,Ssig->Ssort,Tsig->Tsort,Sorts,Sorts_new):-
    !,
    merge_sorts([Ssort|Ssig],[Tsort|Tsig],[Msort|Msig],Sorts,Sorts_new),
    format('op ~w : ',[Varatom]),
    print_casl_sig_arglist(Msig),
    format('-> ~w ;',[Msort]),nl.

print_casl_sig(Varatom,Ssig,Tsig,Sorts,Sorts_new):-
    merge_sorts(Ssig,Tsig,Msig,Sorts,Sorts_new),
    format('pred ~w : ',[Varatom]),
    print_casl_sig_arglist(Msig),
    format(' ;'),nl.

print_casl_sig_arglist([Sort]):-
    !,format('~w',[Sort]).
    
print_casl_sig_arglist([Sort|Sorts]):-
    format('~w * ',[Sort]),
    print_casl_sig_arglist(Sorts).    
    
merge_sorts([],[],[],Sorts,Sorts).

merge_sorts([Sort1|Sorts1],[Sort2|Sorts2],[Msort|Msorts],Sorts,Sorts_out):-
    merge_sort(Sort1,Sort2,Msort,Sorts,Sorts_new),
    merge_sorts(Sorts1,Sorts2,Msorts,Sorts_new,Sorts_out).

merge_sort(Sort1,Sort2,Sort,Sorts,Sorts):-
    casl_sort(Sort1,Sort2,Sort),
    member(Sort,Sorts),!.
    
merge_sort(Sort1,Sort2,Sort,Sorts,[Sort|Sorts]):-
    casl_sort(Sort1,Sort2,Sort),
    format('sort ~w ;',Sort),nl.

casl_sort(Sort,Sort,Sort):-!.
casl_sort(Sort1,Sort2,Sort):-
    atomic_list_concat([Sort1,'_',Sort2],Sort).

      
print_pretty_casl_generalisation_terms([]):-!.

print_pretty_casl_generalisation_terms([Term]):-!,
    print_pretty_casl_generalisation_term(Term),nl.
    
print_pretty_casl_generalisation_terms([Term|Terms]):-
    print_pretty_casl_generalisation_term(Term),nl,
    print_pretty_casl_generalisation_terms(Terms).

print_pretty_casl_generalisation_term(Term):-
    collect_struct_variables([Term],Variables),
    extract_variable_mappings(Variables,VarMapping),
    (VarMapping==[] -> true ; print_pretty_casl_forall(VarMapping)),
    write('. '),print_casl_generalisation_term(Term), write(' ;').


print_pretty_casl_forall(VarMapping):-
    write('forall '),
    print_pretty_casl_forall_sigs(VarMapping).

print_pretty_casl_forall_sigs([Mapping]):-!,
    print_pretty_casl_forall_sig(Mapping).

print_pretty_casl_forall_sigs([Mapping|Mappings]):-
    print_pretty_casl_forall_sig(Mapping), write(' ; '),
    print_pretty_casl_forall_sigs(Mappings).

print_pretty_casl_forall_sig(mapping(Svar,Var,Tvar)):-
    get_attr(Svar,sig,([]->Ssort)),
    get_attr(Tvar,sig,([]->Tsort)),
    generalisation_casl_atom(Var,Varatom),
    casl_sort(Ssort,Tsort,Sort),
    format('~w : ~w ',[Varatom,Sort]).

print_casl_mapping_target([mapping(_,_,Var,_,T_name)]):-
    generalisation_casl_atom(Var,Varatom),
    format('  ~w |-> ~w',[Varatom,T_name]),nl,!.

print_casl_mapping_target([]).

print_casl_mapping_target([mapping(_,_,Var,_,T_name)|Mappings]):-
    generalisation_casl_atom(Var,Varatom),
    format('  ~w |-> ~w,',[Varatom,T_name]),nl,
    print_casl_mapping_target(Mappings).

print_casl_mapping_source([mapping(S_name,_,Var,_,_)]):-
    generalisation_casl_atom(Var,Varatom),
    format('  ~w |-> ~w',[Varatom,S_name]),nl,!.

print_casl_mapping_source([]).

print_casl_mapping_source([mapping(S_name,_,Var,_,_)|Mappings]):-
    generalisation_casl_atom(Var,Varatom),
    format('  ~w |-> ~w,',[Varatom,S_name]),nl,
    print_casl_mapping_source(Mappings).

print_pretty_results([]).

print_pretty_results([[Preanalogy|Preanalogies]|Gs_rest]):-
    print_pretty_generalisation(Preanalogy),
    %print(Preanalogy),nl,
    write('    transfers:'),nl,
    print_pretty_transfers_list([Preanalogy|Preanalogies]),
    nl,nl,
    print_pretty_results(Gs_rest).

print_pretty_generalisation(preanalogy(Cost,_Source,_Target,Generalisation,_Transfer)):-
    write('generalisation = '),nl,print_pretty_generalisation_domain(Generalisation),nl,
    write('    costs = '),write(Cost),nl,
    collect_struct_variables(Generalisation,Variables),
    extract_mappings(Variables,Mappings),
    sort(Mappings,Mappings_sort),
    nl,
    write('    mappings:'),nl,
    format('        ~w~t~30|| ~w      ',['Source','Target']),nl,
    write('        --------------------------------------------'),nl,
    print_pretty_mappings(Mappings_sort),nl.

print_pretty_mappings([]).

print_pretty_mappings([mapping(S_name,_,_,_,T_name)|Mappings]):-
    format('        ~w~t~30|| ~w      ',[S_name,T_name]),nl,
    print_pretty_mappings(Mappings).
    
print_pretty_transfers_list([]).
    
print_pretty_transfers_list([Preanalogy|Preanalogies]):-
    print_pretty_transfers(Preanalogy),nl,
    print_pretty_transfers_list(Preanalogies).

print_pretty_transfers(preanalogy(_Cost,_Source,_Target,_Generalisation,[])):-
    write('        nothing transfered'),!.

% TODO: handle case with more than one transfer
print_pretty_transfers(preanalogy(_Cost,_Source,_Target,_Generalisation,[G_struct])):-
    unstruct_generalisation_term_bylink(source_link,G_struct,S_struct),
    unstruct_generalisation_term_bylink(target_link,G_struct,T_struct),
    antiu_trace_all(S_struct,S_tracepath),
    antiu_trace_all(T_struct,T_tracepath),
    last(S_tracepath,trace(_,S_struct_final)),
    last(T_tracepath,trace(_,T_struct_final)),
    write('        source candidate      '),print_term(S_struct_final),nl,
    write('                  transfered  '),print_term(T_struct_final),nl,
    write('              generalisation  '),print_generalisation_term(G_struct),nl. 


print_withattributes(Term):-
    write_term(Term,[attributes(write)]).

print_pretty_generalisation_domain(Terms):-
    write('    domain(['),nl,
    print_pretty_generalisation_terms(Terms),
    write('           ])').

print_pretty_generalisation_terms([]):-!.

print_pretty_generalisation_terms([Term]):-!,
    print_pretty_generalisation_term(Term),nl.
    %print('$ '),print_term_follow_links(Term),nl.

print_pretty_generalisation_terms([Term|Terms]):-
    print_pretty_generalisation_term(Term),write(','),nl,
    %print('$ '),print_term_follow_links(Term),nl,
    print_pretty_generalisation_terms(Terms).

print_pretty_generalisation_term(Term):-
    write('        '),print_generalisation_term(Term).


print_pretty_domain(Terms):-
    write('domain(['),nl,
    print_pretty_terms(Terms),
    write('       ])').

print_pretty_terms([]).
print_pretty_terms([Term]):-!,
    print_pretty_term(Term),nl.
    
print_pretty_terms([Term|Terms]):-
    print_pretty_term(Term),write(','),nl,
    print_pretty_terms(Terms).

print_pretty_term(Term):-
    write('        '),print_term(Term).

print_antiinstance(anti(Cost,Mode,Term)):-
    write('anti('),
    write(Cost),
    write(','),
    write(Mode),
    write(','),
    print_term_follow_links(Term),
    write(')').
    
print_antiinstances([Antiinstance|Antiinstances]):-
    print_antiinstance(Antiinstance),nl,
    print_antiinstances(Antiinstances).    
    
print_antiinstances([]).

print_variable_names([Var]):-!,
    print_variable_name(Var).

print_variable_names([Var|Variables]):-
    print_variable_name(Var),write(','),
    print_variable_names(Variables).

print_variable_name(Var):-
    unstruct_term(_:Var,Name),
    write(Name).

% print term with resolved names
print_term_follow_links(Term_struct):-
    unstruct_term_follow_links(Term_struct,Term),
    write(Term).

print_term(Term_struct):-
    unstruct_term(Term_struct,Term),
    write(Term).

print_casl_generalisation_term(Term_struct):-
    unstruct_casl_generalisation_term(Term_struct,Term),
    write_casl_term(Term).

write_casl_term(Var):- 
    var(Var),!,write(Var).
write_casl_term(Term):- 
    Term=..[Op],!,
    write(Op).
% predefined infix operators
write_casl_term(Term):-
    Term=..[Op,Arg1,Arg2],
    member(Op,['=','=e=','not','/\\','\\/','=>','<=>']),!, 
    write('( '),
    write_casl_term(Arg1),
    write(' '),
    write(Op),
    write(' '),
    write_casl_term(Arg2),
    write(' )').
write_casl_term(Term):-
    Term=..[Op|Args],
    write(Op),
    write('( '),
    write_casl_terms(Args),
    write(' )').

write_casl_terms([Term]):- 
    !, write_casl_term(Term).
write_casl_terms([Term|Terms]):- 
    write_casl_term(Term),
    write(' , '),
    write_casl_terms(Terms).

print_generalisation_term(Term_struct):-
    unstruct_generalisation_term(Term_struct,Term),
    write(Term).

print_pretty_antiu_results([]).
print_pretty_antiu_results([Result|R_rest]):-
    %safety so we dont mangle with other resultterms
    copy_term(Result,result(_Cost,anti(_SC,(_SM,S_Subst),S_term),anti(_TC,(_TM,T_Subst),T_term))),
    inline_substitutions(S_Subst),
    inline_substitutions(T_Subst),
    linktogether(S_term,T_term,G_new),
    print_term_follow_links(G_new),print(' --> '),print_generalisation_term(G_new),nl,nl,
    print_antiu_trace(G_new,S_term),
    nl,nl,
    print_antiu_trace(G_new,T_term),
    nl,
    print_pretty_antiu_results(R_rest).

% prints antiunification result
print_result(result(C,Antiinstance1,Antiinstance2)):-
    write(C),write(' : '),print_antiinstance(Antiinstance1),write(' ~~~ '),print_antiinstance(Antiinstance2),nl.
    
print_result_list([]).
print_result_list([Result|Rest]) :-
    print_result(Result),
    print_result_list(Rest).

% predicate to trace an anti-instance to its original term]
%
% G_struct , anti-instance after renaming (in generalized theory)
% Term_struct, anti-instance before renaming (in source or target)
    
print_antiu_trace(G_struct,Term_struct):-
    antiu_trace_all(Term_struct,Tracepath),
    write('anti-instance: '),print_term_follow_links(G_struct),nl,
    write('renaming   '),
    write('    -> '),
    print_term(Term_struct),nl,
    print_antiu_trace_path(Tracepath).
    
print_antiu_trace_path([]).
print_antiu_trace_path([trace(Reversename,Term)|Trace_path]):-
    reverselink_name(Reversename,Name),
    write(Name),print('    -> '),print_term(Term),nl,
    print_antiu_trace_path(Trace_path).

% names for reverse links needed for the tracer

reverselink_name(p_reverse,'permutation').
reverselink_name(e_reverse,'insertion  ').
reverselink_name(i_reverse,'insertion  ').
reverselink_name(f_reverse,'fixation   ').
