:-module(linking,[linktogether/3]).

%-------------------------------------------------------------------------------

% makes generalized terms if given source and target terms that are known to be anti-unifiable

% linktogether... (+,+,-)
linktogether(_Source_tag:Source_struct,_Target_tag:Target_struct,_:Generalisation):-
    var(Source_struct),
    var(Target_struct),!,
    linktogether_variables(Source_struct,Target_struct,Generalisation).

linktogether(_Source_tag:(Source_var,Source_arg),_Target_tag:(Target_var,Target_arg),_:(Generalisation_var,Generalisation_arg)):-
    linktogether_arguments(Source_arg,Target_arg,Generalisation_arg),
    linktogether_variables(Source_var,Target_var,Generalisation_var).


linktogether_arguments([],[],[]).
linktogether_arguments([Source_arg|Sargs],[Target_arg|Targs],[Generalisation_arg|Gargs]):-
    linktogether(Source_arg,Target_arg,Generalisation_arg),
    linktogether_arguments(Sargs,Targs,Gargs).

% use already existing generalisation if it fits
linktogether_variables(Source_atomvar,Target_atomvar,Source_generalisation_var):-
    higherau:get_pname_variable(Source_atomvar,Source_var),
    higherau:get_pname_variable(Target_atomvar,Target_var),
    get_attr(Source_var,general_link,Source_generalisation_var_list),
    get_attr(Target_var,general_link,Target_generalisation_var_list),
    member(Source_generalisation_var,Source_generalisation_var_list),
    member(Target_generalisation_var,Target_generalisation_var_list),
    Source_generalisation_var==Target_generalisation_var,!.

linktogether_variables(Source_atomvar,Target_atomvar,Generalisation_var):-
    higherau:get_pname_variable(Source_atomvar,Source_var),
    higherau:get_pname_variable(Target_atomvar,Target_var),
    add_attr(Source_var,general_link,Generalisation_var),
    add_attr(Target_var,general_link,Generalisation_var),
    put_attr(Generalisation_var,source_link,Source_var),
    put_attr(Generalisation_var,target_link,Target_var),
    %TODO find out generalised sort in ontology
    get_attr(Source_var,sort_link,Source_SortVar),
    get_attr(Target_var,sort_link,Target_SortVar),       
    lca_sorts(Source_SortVar,Target_SortVar,Sort),
    build_sort_Variable(Sort,Generalisation_SortVar,[],_),
    put_attr(Generalisation_var,sort_link,Generalisation_SortVar),
    term_to_atom(Generalisation_var,Nameinternal),
    atomic_list_concat(['General',Nameinternal],Name),
    put_attr(Generalisation_var,name,Name).

%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------

% add_attr(+,+,+)
% helper to handle lists in attributes 

% case if attribute does not exist
add_attr(Variable,Name,Value):-
    not(get_attr(Variable,Name,_)),!,
    put_attr(Variable,Name,[Value]).

% case if attribute with list is already present    
add_attr(Variable,Name,Value):-
    get_attr(Variable,Name,Values),
    put_attr(Variable,Name,[Value|Values]).