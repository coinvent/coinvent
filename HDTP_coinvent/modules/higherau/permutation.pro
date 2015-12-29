%-------------------------------------------------------------------------------
% permutation
%-------------------------------------------------------------------------------

% unpack 
term_permutation_new(anti(C,(_,s(F,I,E,P)),Term),anti(C_new,(p(Place_new),s(F_new,I,E,P_new)),Term_new)) :-
	upermutation(C,C_new,Term,Term_new,16777215,Place_new,P,P_new,F,F_new).
	
term_permutation(anti(C,(p(Place),s(F,I,E,P)),Term),anti(C_new,(p(Place_new),s(F_new,I,E,P_new)),Term_new)) :-
	upermutation(C,C_new,Term,Term_new,Place,Place_new,P,P_new,F,F_new).
	
upermutation(_C,_C_new,A:Var,_,Place,_Place_new,_P,_P_new,_F,_F_new):-
    (
        get_attr(A,place,Place_tmp),
        Place_tmp>=Place
    ;
        var(Var)
    ),
    !,fail.

% recursion on predicate arguments
upermutation(C,C_new,A:(Pname,Args),A:(Pname,Args_new),Place,Place_new,P,P_new,F,F_new) :-   
    append(Args_before,[Arg|Args_after],Args),
	upermutation(C,C_new,Arg,Arg_new,Place,Place_new,P,P_new,F,F_new),   
    append(Args_before,[Arg_new|Args_after],Args_new).

upermutation(_C,_C_new,_A:(Pname,_Args),_,_Place,_Place_new,_P,_P_new,_F,_F_new):-
    get_attr(Pname,mode_p,denied),!,fail.

upermutation(C,C_new,A:(Pname,Args),A:(Pname_new,Args_new),Place,Place_new,P,P_new,F,F_new) :-
    get_attr(A,place,Place_new), 
    Place_new < Place,
    make_vars(Args,VariableArgs),!,
    permutation(VariableArgs,VariableArgs_new),
	not(VariableArgs==VariableArgs_new), %makes sure it is infact not a copy but a real permutation
	copy_term((VariableArgs,VariableArgs_new),(Args,Args_new)), %copy the permutation structure
	(get_attr(Pname,mode_p,keep)->
	                              set_pname_permutation_keep(C,C_new,(VariableArgs,VariableArgs_new),Pname,Pname_new,P,P_new),
                                  F=F_new
                                 ;
                                  make_pname_variable(C,C_tmp,Pname,Pname_var,F,F_new),
                                  set_pname_permutation(C_tmp,C_new,(VariableArgs,VariableArgs_new),Pname_var,Pname_new,P,P_new)
    ).
     
set_pname_permutation(C,C,Permutation,Pname,Pname_new,P,P) :-
    get_attr(Pname,subst_p,SubstP),
    permutation_global_subst_member(p(Pname_new,Permutation),SubstP),!.

set_pname_permutation(C,C,Permutation,Pname,Pname_new,P,P) :-
    permutation_local_subst_member(p(Pname,Pname_new,Permutation),P),!.
	
set_pname_permutation(C,C_new,Permutation,Pname,Pname_new,P,[p(Pname,Pname_new,Permutation)|P]) :-
    copy_attribute(sort_link,Pname,Pname_new),
    (get_attr(Pname,cost_p,free)->C_new=C;cost_permutation_new(C,C_new,Permutation,Pname,Pname_new)).

% TODO: Hack find general solution for all substitutions and reason about it
%set_pname_permutation_keep(C,C_new,Permutation,Pname,Pname_new,P,[p(Pname,Pname_new,Permutation)|P]) :-
set_pname_permutation_keep(C,C_new,Permutation,Pname,Pname_new,P,P) :-
    Pname=Pname_new,
    %copy_for_keepmode(Pname,Pname_new),
    (get_attr(Pname,cost_p,free)->C_new=C;cost_permutation_new(C,C_new,Permutation,Pname,Pname_new)).

permutation_local_subst_member((Pname,Pname_new,Permutation),[p(PPname,Pname_new,PPermutation)|_]) :-
    Pname==PPname,
    Permutation=@=PPermutation,!.

permutation_local_subst_member(Match,[_|Rest]) :-
    permutation_local_subst_member(Match,Rest).    

permutation_global_subst_member(p(Pname,Permutation),[p(Pname,SubstPermutation)|_]) :-
    Permutation=@=SubstPermutation,!.

permutation_global_subst_member(Match,[_|Rest]) :-
    permutation_global_subst_member(Match,Rest). 

% make a variable pattern
make_vars([],[]).
make_vars([_|Tail],[_|Tail_new]) :-
	make_vars(Tail,Tail_new).