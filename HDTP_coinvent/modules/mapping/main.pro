:- configure(config).

mapping_cont(preanalogy(Cost,source(S_open,S_closed,S_nomatch),target(T_open,T_closed,T_nomatch),G,Transfer),Result):-
    (flag(maprules)->S_open=S_open_new,S_nomatch=S_nomatch_new,
                     T_open=T_open_new,T_nomatch=T_nomatch_new
                    ;
                     filterclauses(S_open,S_nomatch,S_open_new,S_nomatch_new),
                     filterclauses(T_open,T_nomatch,T_open_new,T_nomatch_new)
    ),
    mapping_cont([preanalogy(Cost,source(S_open_new,S_closed,S_nomatch_new),target(T_open_new,T_closed,T_nomatch_new),G,Transfer)],Result).    

mapping_cont([Preanalogy|_Ps_rest],Preanalogy):-
    is_solved(Preanalogy),
    Preanalogy\=preanalogy(_Cost,_Source,_Target,[],_Transfer).

mapping_cont([Preanalogy|Ps_rest],Result):-
    not(is_solved(Preanalogy)),!,
    expand_que(Preanalogy,Ps_rest,Ps_new),
    mapping_cont(Ps_new,Result).

mapping_cont([_Preanalogy|Ps_rest],Result):-
    mapping_cont(Ps_rest,Result).
    

% expand_que(+,+,-)
% takes preanalogy and adds new aligments thereby creating new preanalogies                 
expand_que(Preanalogy,Ps_rest,Ps_new):-
    %Preanalogy=preanalogy(AnalogyCost,_,target(Open,_,_),G,_),
    %length(Open,T),
    %print(T),nl,
    %print_pretty_generalisation_domain(G),nl,
    %print(AnalogyCost),nl,
    select_sourceterm(Preanalogy,Preanalogy_without_S_term,S_term),!,
    generate_antiunipairs(Preanalogy_without_S_term,S_term,Antiunipairs),
    %print('generating possible antiunification pairs done'),nl,
    generate_preanalogies(Antiunipairs,Ps_from_antiu),
    %print('generating preanalogies done'),nl,
    generate_nomatch(S_term,Preanalogy_without_S_term,Preanalogy_nomatch),
    pmerge(Preanalogy_nomatch,Ps_from_antiu,Ps_tmp),
    %print('merging nomatch preanalogie done'),nl,
    ord_union(Ps_tmp,Ps_rest,Ps_new).
    %print('merging preanalogies done'),nl.

expand_que(_Preanalogy,Ps_rest,Ps_rest).
    
% incorporates heuristic when a preanalogy is considered to be a mapped analogy
is_solved(preanalogy(_Cost,source([],_S_closed,_S_nomatch),target(_,_T_closed,_T_nomatch),_G,_Transfer)).

% generate_antiunipairs(+,+,-)
% generates pairs of a source and a target term that should be antiunified 
generate_antiunipairs(Preanalogy,S_term,Antiunipairs):-
    %print_term(S_term),nl,
    bagof(antiupair(S_term,T_term,Preanalogy_new),select_targetterm(Preanalogy,Preanalogy_new,S_term,T_term),Antiunipairs),!.

generate_antiunipairs(_Preanalogy,_S_term,[]).

generate_nomatch(S_term,preanalogy(Analogycost,S,T,G,Transfer),preanalogy(Analogycost_new,source(S_open_new,S_closed_new,[S_term_copy|S_nomatch_new]),T_new,G_new,Transfer_new)):-
    copy_term(((S,T,G,Transfer),S_term),((source(S_open_new,S_closed_new,S_nomatch_new),T_new,G_new,Transfer_new),S_term_copy)),
    cost_nomatch(S_term,Cost),
    plus(Analogycost,Cost,Analogycost_new).

% computes costs for non matched terms    
cost_nomatch(Attributevar:_,Cost):-
    get_attr(Attributevar,number_predicates,Numberofpredicates),!,
    Cost is (Numberofpredicates*2).

% heuristic that selects the next source term that should be antiunified          
select_sourceterm(preanalogy(Cost,source(S_open     ,        S_closed ,S_nomatch),Target,G,Transfer),
                  preanalogy(Cost,source(S_open_rest,[S_term|S_closed],S_nomatch),Target,G,Transfer),
                  S_term):-
    select(S_term,S_open,S_open_rest).

select_targetterm(preanalogy(Cost,Source,target(T_open     ,        T_closed ,T_nomatch),G,Transfer),
                  preanalogy(Cost,Source,target(T_open_rest,[T_term|T_closed],T_nomatch),G,Transfer),
                  S_term,
                  T_term):-
    % only match clauses to clauses and facts to facts
    (is_clause(S_term)->select(T_term,T_open,T_open_rest),is_clause(T_term)
                       ;select(T_term,T_open,T_open_rest),not(is_clause(T_term))
    ).


% checks if a term contains an implication as primary functor
is_clause(_:(Functorvar,_)):-
    get_attr(Functorvar,name,Functoratom),
    member(Functoratom,['=>','<=>']).

generate_preanalogies(Antiunipairs,R):-
    generate_preanalogies(Antiunipairs,[],R).

% generate_preanalogies(+,+,-)
% given pairs of terms m antiunifies them and with the new mappings generates new preanalogies
generate_preanalogies([],R,R).
    
generate_preanalogies([antiupair(Source_term,Target_term,Preanalogy)|Rest],P_old,P_new):-
    %print('antiunify '),print_term(Source_term),print(' '),print_term(Target_term),nl,
    antiunify_terms(Source_term,Target_term,16777215,A_results),!,
    %length(A_results,Length),
    %print('got '),print(Length),print(' generalisations'),nl,
    generate_preanalogies_from_antiu(Preanalogy,A_results,Ps_gen),
    psmerge(Ps_gen,P_old,P_tmp),
    generate_preanalogies(Rest,P_tmp,P_new).

% generate_preanalogies_from_antiu(+,+,-)
% given mappings generates new preanalogies
generate_preanalogies_from_antiu(_,[],[]).
 
generate_preanalogies_from_antiu(Preanalogy,[Antiu_result|Antiu_results],[preanalogy(P_gen_cost,Source,Target,Gs_new,Transfer)|P_gens]):-
    %first we clone the current state
    %Antiu_result = result(_,S,T),    
    %print_antiinstance(S),print(' linkwith '),print_antiinstance(T),nl,
    copy_term((Preanalogy,Antiu_result),(Preanalogy_clone,Antiu_result_clone)),
    %print('copied analogy'),nl,
    %unpack then merge
    Preanalogy_clone   = preanalogy(AnalogyCost,Source,Target,Gs,Transfer),
    Antiu_result_clone = result(AntiunifyCost,anti(_SC,(_SM,Source_Subst),Source_antiu_struct),anti(_TC,(_TM,Target_Subst),Target_antiu_struct)),    
    %print_antiinstance(anti(_SC,(_SM,Source_Subst),Source_antiu_struct)),print(' linkwith '),print_antiinstance(anti(_TC,(_TM,Target_Subst),Target_antiu_struct)),nl,
    %trace,
    inline_substitutions(Source_Subst),
    %print('inline Source Substitutions done'),nl,
    inline_substitutions(Target_Subst),
    %print('inline Target Substitutions done'),nl,
    linktogether(Source_antiu_struct,Target_antiu_struct,G_new),
    %notrace,nodebug,
    %print('Linking Variables together done'),nl,
    plus(AnalogyCost,AntiunifyCost,P_gen_cost),
    %preserve order creation in list
    append(Gs,[G_new],Gs_new),
    generate_preanalogies_from_antiu(Preanalogy,Antiu_results,P_gens).    

% filterclause(+,+,-,-)
% filtes clauses out from a list of terms and adds them to the closed list
filterclauses([],Closed,[],Closed).
filterclauses([Term|Rest],Closed,Rest_new,[Term|Closed_new]):-
    is_clause(Term),!,
    filterclauses(Rest,Closed,Rest_new,Closed_new).
        
filterclauses([Term|Rest],Closed,[Term|Rest_new],Closed_new):-
    filterclauses(Rest,Closed,Rest_new,Closed_new).

% pmerge(+,+,-)
% merge single preanalogy into the que
% NOTE: ord_add_element is slower
pmerge(Preanalogy,Old,Merge):-
    arg(1,Preanalogy,Cost),
    pmerge(Cost,Preanalogy,Old,Merge).
    
pmerge(_,P,[],[P]).
pmerge(Cost_new,P_new,[Preanalogy|Old],[P_new,Preanalogy|Old]):-
    arg(1,Preanalogy,Cost_old),
    Cost_new < Cost_old,!.    

pmerge(Cost,P_new,[Preanalogy|Old],[Preanalogy|Merge]):-
    pmerge(Cost,P_new,Old,Merge).   

% alternative:
% pmerge(Preanalogy,Set,Set_new):-ord_add_element(Set,Preanalogy,Set_new).

% psmerge(+,+,-)
% merge list of equal cost preanalogies
% all the preanlogies generated had the same cost! because antiunification generates list of same cost         

psmerge([],L,L).
psmerge([Preanalogy|Rest],Old,Merge):-
    arg(1,Preanalogy,Cost),
    psmerge(Cost,[Preanalogy|Rest],Old,Merge).

psmerge(_,Ps,[],Ps).
psmerge(Cost_new,Ps_new,[Preanalogy|Old],Merge):-
    arg(1,Preanalogy,Cost_old),
    Cost_new < Cost_old,!,
    append(Ps_new,[Preanalogy|Old],Merge),!.        

psmerge(Cost,Ps_new,[Preanalogy|Old],[Preanalogy|Merge]):-
    psmerge(Cost,Ps_new,Old,Merge).        

% alternative:
% psmerge(Preanalogies,Set,Union):-ord_union(Preanalogies,Set,Union).