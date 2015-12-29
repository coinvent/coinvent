:-module(subst_preload,[subst_preload/2]).

% reads settings for substitutions from a file and incorporates this
% knowledge into the attributes of the corresponding variables

subst_preload(DomainName,Subst):-
    (DomainName=''->Settings=[];load_subst(DomainName,subst(Settings))),
    findall(S,(member(S,Settings),functor(S,mode,_)),ModeSettings),
    append([mode('<->',all,denied),mode('->',all,denied),mode(',',all,denied),mode(';',all,denied),mode('not',all,denied)],ModeSettings,ModeSettings_new),
    set_modes(ModeSettings_new,Subst),
    findall(S,(member(S,Settings),functor(S,cost,_)),CostSettings),
    set_costs(CostSettings,Subst).

set_modes([mode(Name,Transformation,Mode)|ModeSettings],Subst):- 
    (find_by_attr(name,Name,Subst,Variable)->
                                     set_mode(Transformation,Variable,Mode) 
                                    ; 
                                     true
    ),
    !,
    set_modes(ModeSettings,Subst).

set_modes([],_).

set_mode(all,ConstVar,Mode):-
    set_mode(permutation,ConstVar,Mode),
    set_mode(embedding  ,ConstVar,Mode),
    set_mode(insertion  ,ConstVar,Mode),
    set_mode(fixation   ,ConstVar,Mode).

set_mode(permutation,ConstVar,Mode) :-
    put_attr(ConstVar,mode_p,Mode).

set_mode(embedding  ,ConstVar,Mode) :-
    put_attr(ConstVar,mode_e,Mode).

set_mode(insertion  ,ConstVar,Mode) :-
    put_attr(ConstVar,mode_i,Mode).

set_mode(fixation   ,ConstVar,Mode) :-
    put_attr(ConstVar,mode_f,Mode).

set_costs([cost(Name,Transformation,Cost)|CostSettings],Subst):- 
    (find_by_attr(name,Name,Subst,Variable)->
                                     set_cost(Transformation,Variable,Cost) 
                                    ; 
                                     true
    ),
    !,
    set_costs(CostSettings,Subst).

set_costs([],_).

set_cost(permutation,ConstVar,Cost) :-
    put_attr(ConstVar,cost_p,Cost).

set_cost(insertion  ,ConstVar,Cost) :-
    put_attr(ConstVar,cost_i,Cost).

set_cost(embedding  ,ConstVar,Cost) :-
    put_attr(ConstVar,cost_e,Cost).
    
set_cost(fixation   ,ConstVar,Cost) :-
    put_attr(ConstVar,cost_f,Cost).
