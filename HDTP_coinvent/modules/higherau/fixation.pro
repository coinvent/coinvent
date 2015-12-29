% make_pname_variable
% determine if function symbol is a constant and can be made into a variable 
make_pname_variable(C,C_new,Pname,Pname_new,F,F_new):-
    get_attr(Pname,type,atomic),!,
    not(get_attr(Pname,mode_f,denied)),
    set_pname_fixation(C,C_new,Pname,Pname_new,F,F_new).    

make_pname_variable(C,C,Pname,Pname,F,F).

get_pname_variable(Pname,Pname_new):-
    get_attr(Pname,type,atomic),!,
    get_attr(Pname,var_link,Pname_new).

get_pname_variable(Pname,Pname).
    
set_pname_fixation(C,C,Pname,Pname_new,F,F) :-
    get_attr(Pname,subst_f,[f(Pname_new)]),!.
    
set_pname_fixation(C,C,Pname,Pname_new,F,F) :-
    fixation_local_subst_member(f(Pname,Pname_new),F),!.
    
set_pname_fixation(C,C_new,Pname,Pname_new,F,[f(Pname,Pname_new)|F]) :-
    get_attr(Pname,var_link,Pname_new),
    (get_attr(Pname,cost_f,free)->C_new=C;cost_fixation_new(C,C_new,Pname,Pname_new)).

%dont have to check for length because of unique name assumption
fixation_local_subst_member(f(Pname,Pname_new),[f(FPname,Pname_new)|_]) :-
    Pname==FPname,!. 
    
fixation_local_subst_member(Match,[_|Rest]):-
    fixation_local_subst_member(Match,Rest).