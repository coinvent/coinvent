:-module(cost_p,[]).

%this makes sure bagof produces shared variables!
attr_unify_hook(Cost_p,Variable):-
    get_attr(Variable,cost_p,Variable_Cost_p),
    Cost_p==Variable_Cost_p.