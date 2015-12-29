:- module(transfer,[transfer/2]).

transfer([],[]).

transfer([Preanalogy|Preanalogies],[Preanalogies_result|Preanalogies_new]):-
    transfer_preanalogy(Preanalogy,Preanalogies_result),
    transfer(Preanalogies,Preanalogies_new).

transfer_preanalogy(Preanalogy,Preanalogies_new):-
    Preanalogy=preanalogy(_Cost,source(_S_open,_S_closed,S_nomatch),target(T_open,T_closed,_T_nomatch),_G,_Transfer),
    append(T_open,T_closed,T_terms),
    collect_struct_variables(T_terms,T_variables),
    %print_variable_names(T_variables),nl,
    %print_pretty_domain(S_nomatch),nl,
    (S_nomatch=[]->Preanalogies_new=[Preanalogy]
                  ;
                   transfer_terms(S_nomatch,T_variables,Preanalogy,[],Preanalogies_new)
    ).

transfer_terms([S_struct|S_nomatch],T_variables,Preanalogy,Preanalogies,Preanalogies_new):-
    transfer_term(S_struct,T_variables,Preanalogy,Preanalogies_tmp),
    append(Preanalogies,Preanalogies_tmp,Preanalogies_tmp2),
    transfer_terms(S_nomatch,T_variables,Preanalogy,Preanalogies_tmp2,Preanalogies_new).    

transfer_terms([],_T_variables,_Preanalogy,Preanalogies,Preanalogies).

transfer_term(S_struct,T_variables,Preanalogy,Preanalogies):-
    (
     bagof(Preanalogy_new,(build_general_term(S_struct,T_variables,T_struct),
                           copy_term((S_struct,T_struct,Preanalogy),(S_struct_copy,T_struct_copy,Preanalogy_copy)),
                           linktogether(S_struct_copy,T_struct_copy,G_struct),
                           %print_pretty_generalisation_term(G_struct),nl,
                           integrate_transfer(S_struct_copy,G_struct,Preanalogy_copy,Preanalogy_new)
                          ),Preanalogies)
    ;
     Preanalogies=[Preanalogy]
    ),!.

% TODO keep S_struct out of S_nomatch list        
integrate_transfer(S_struct,G_struct,preanalogy(Cost,source(S_open,S_closed           ,S_nomatch),target(T_open,T_closed,T_nomatch),G,Transfer)
                                    ,preanalogy(Cost,source(S_open,[S_struct|S_closed],S_nomatch),target(T_open,T_closed,T_nomatch),G,[G_struct|Transfer])).
    

build_general_term(S_struct,T_variables,T_struct):-
    build_target_term(S_struct,T_struct,T_variables,_),
    %nl,print('antiunifying: '),print_term(S_struct),print(' with '),print_term(T_struct),nl,nl,
    % TODO make better api call here
    higherau:gcheck(16777215,anti(0,(_,s([],[],[],[])),S_struct),anti(0,(_,s([],[],[],[])),T_struct),
                    % make sure no fixations (substitutions) have to be made
                             anti(0,(_,s([],[],[],[])),_       ),anti(0,(_,s([],[],[],[])),_       )).
    
build_target_term(S_a:S_var,T_a:T_var,T_variables,T_variables_new):-
    % TODO: make sure if links are used the copy doesnt interupt consistency
    var(S_var),!,
    copy_term(S_a,T_a),
    build_target_var(S_var,T_var,T_variables,T_variables_new).
    
build_target_term(S_a:(S_var,S_struct_list),T_a:(T_var,T_struct_list),T_variables,T_variables_new):-
    % TODO: make sure if links are used the copy doesnt interupt consistency
    copy_term(S_a,T_a),
    build_target_var(S_var,T_var,T_variables,T_variables_tmp),
    build_target_term_list(S_struct_list,T_struct_list,T_variables_tmp,T_variables_new).

build_target_term_list([S_struct|S_struct_list],[T_struct|T_struct_list],T_variables,T_variables_new):-
    build_target_term(S_struct,T_struct,T_variables,T_variables_tmp),
    build_target_term_list(S_struct_list,T_struct_list,T_variables_tmp,T_variables_new).        

build_target_term_list([],[],T_variables,T_variables).

get_atomvar(T_var,T_atomvar):-
    get_attr(T_var,reverse_link,f_reverse(T_atomvar)),!.
    
get_atomvar(T_var,T_var).

% use existing mapped target variable
build_target_var(S_atomvar,T_atomvar,T_variables,T_variables):-
    higherau:get_pname_variable(S_atomvar,S_var),
    get_attr(S_var,general_link,G_var_list),!,
    member(G_var,G_var_list),
    get_attr(G_var,target_link,T_var),
    get_atomvar(T_var,T_atomvar).

% atomic variable with name exists
build_target_var(S_var,T_var,T_variables,T_variables):-
    get_attr(S_var,type,atomic),
    get_attr(S_var,name,S_name),
    find_by_attr(name,S_name,T_variables,T_var),!.

% atomic variable doesnt exist
build_target_var(S_var,T_var,T_variables,T_variables_new):-
    get_attr(S_var,type,atomic),!,
    get_attr(S_var,name,Name),
    get_attr(S_var,sort_link,S_SortVar),
    get_attr(S_SortVar,name,Sort),
    % TODO: we search T_variables again here which is not needed , maybe merge with case before or simplyfy
    build_atomic_Variable(Name,T_var,_,Sort,transfer,T_variables,T_variables_new,[],_Sorts).

% variable
build_target_var(S_var,T_var,T_variables,T_variables_new):-
    get_attr(S_var,name,Name),
    get_attr(S_var,sort_link,S_SortVar),
    get_attr(S_SortVar,name,Sort),
    atomic_list_concat(['Transfer_',Name],Name_transfer),
    build_variable_Variable(Name_transfer,T_var,Sort,transfer,T_variables,T_variables_new,[],_Sorts).