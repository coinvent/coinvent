:-module(cost_f,[]).

%this makes sure bagof produces shared variables!
attr_unify_hook(Cost_f,Variable):-
    get_attr(Variable,cost_f,Variable_Cost_f),
    Cost_f==Variable_Cost_f.