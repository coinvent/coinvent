%-------------------------------------------------------------------------------
% insertion
%-------------------------------------------------------------------------------

% unpack 
term_insertion_new(anti(C,(_,s(F,I,E,P)),Term),anti(C_new,(i(Place_new),s(F_new,I_new,E,P)),Term_new)) :-
	uinsertion(C,C_new,Term,Term_new,16777215,Place_new,I,I_new,F,F_new).

term_insertion(anti(C,(i(Place),s(F,I,E,P)),Term),anti(C_new,(i(Place_new),s(F_new,I_new,E,P)),Term_new)) :-
	uinsertion(C,C_new,Term,Term_new,Place,Place_new,I,I_new,F,F_new).

uinsertion(_C,_C_new,A:Var,_,Place,_Place_new,_I,_I_new,_F,_F_new):-
    (
        get_attr(A,place,Place_tmp),
        Place_tmp>=Place
    ;
        %if not a predicate
        var(Var)
    ),
    !,fail.

% recursion on predicate arguments
uinsertion(C,C_new,A:(Pname,Args),A:(Pname,Args_new),Place,Place_new,I,I_new,F,F_new) :- 
    append(Args_before,[Arg|Args_after],Args),
	uinsertion(C,C_new,Arg,Arg_new,Place,Place_new,I,I_new,F,F_new),   
    append(Args_before,[Arg_new|Args_after],Args_new).

uinsertion(_C,_C_new,_A:(Pname,_Args),_,_Place,_Place_new,_I,_I_new,_F,_F_new):-
    get_attr(Pname,mode_i,denied),!,fail.

%insert a variable/predicate with arity 0 into variable/predicate with arity one
uinsertion(C,C_new,A:(Pname,[Aarg:Arg]),A:Pname_new,Place,Place_new,I,I_new,F,F_new) :-
    var(Arg),
    get_attr(Arg,type,atomic),
 	get_attr(Aarg,place,Place_new),
	Place_new<Place,
	%make_pname_atomic(Arg,Arg_atomic),
    make_pname_variable(C,C_tmp,Arg,Arg_var,F,F_tmp),
	(get_attr(Pname,mode_i,keep)->
	                              set_pname_insertion_keep(C_tmp,C_new,Arg_var,Pname,Pname_new,0,I,I_new),
	                              F_new = F_tmp   
	                             ;     
	                              make_pname_variable(C_tmp,C_tmp2,Pname,Pname_var,F_tmp,F_new),
	                              set_pname_insertion(C_tmp2,C_new,Arg_var,Pname_var,Pname_new,0,I,I_new)
    ).

%insert a variable/predicate with arity 0
uinsertion(C,C_new,A:(Pname,Args),A:(Pname_new,Args_new),Place,Place_new,I,I_new,F,F_new) :-
 	append(Args_before,[Aarg:Arg|Args_after],Args),
	var(Arg),
	get_attr(Arg,type,atomic),
	get_attr(Aarg,place,Place_new),
	(Place_new<Place->true;!,fail),
    append(Args_before,Args_after,Args_new),
	length(Args_before,PlaceOfArg),
	%make_pname_atomic(Arg,Arg_atomic),
    make_pname_variable(C,C_tmp,Arg,Arg_var,F,F_tmp),
	(get_attr(Pname,mode_i,keep)->
	                              set_pname_insertion_keep(C_tmp,C_new,Arg_var,Pname,Pname_new,PlaceOfArg,I,I_new),
	                              F_new = F_tmp
	                             ;
	                              make_pname_variable(C_tmp,C_tmp2,Pname,Pname_var,F_tmp,F_new),
	                              set_pname_insertion(C_tmp2,C_new,Arg_var,Pname_var,Pname_new,PlaceOfArg,I,I_new)
    ).

%OPT: use ordering in subst_i
set_pname_insertion(C,C,Insertion,Pname,Pname_new,PlaceOfArg,I,I) :-
    get_attr(Pname,subst_i,SubstI),    
    insertion_global_subst_member(i(Pname_new,PlaceOfArg,Insertion),SubstI),!.

set_pname_insertion(C,C,Insertion,Pname,Pname_new,PlaceOfArg,I,I) :-
    insertion_local_subst_member(i(Pname,Pname_new,PlaceOfArg,Insertion),I),!.   
   
set_pname_insertion(C,C_new,Insertion,Pname,Pname_new,PlaceOfArg,I,[i(Pname,Pname_new,PlaceOfArg,Insertion)|I]) :-
    copy_attribute(sort_link,Pname,Pname_new),
    (get_attr(Pname,cost_i,free)->C_new=C;cost_insertion_new(C,C_new,Insertion,Pname,Pname_new,PlaceOfArg)).

set_pname_insertion_keep(C,C_new,Insertion,Pname,Pname_new,PlaceOfArg,I,[i(Pname,Pname_new,PlaceOfArg,Insertion)|I]) :-
    copy_for_keepmode(Pname,Pname_new),
    (get_attr(Pname,cost_i,free)->C_new=C;cost_insertion_new(C,C_new,Insertion,Pname,Pname_new,PlaceOfArg)).


insertion_local_subst_member(i(Pname,Pname_new,PlaceOfArg,Insertion),[i(IPname,Pname_new,PlaceOfArg,IInsertion)|_]) :-
    Pname==IPname,
    Insertion==IInsertion,!. 
    
insertion_local_subst_member(Match,[_|Rest]):-
    insertion_local_subst_member(Match,Rest).
    
insertion_global_subst_member(i(Pname,PlaceOfArg,Insertion),[i(Pname,PlaceOfArg,SubstInsertion)|_]) :-
    Insertion==SubstInsertion,!. 

insertion_global_subst_member(Match,[_|Rest]):-
    insertion_global_subst_member(Match,Rest).    