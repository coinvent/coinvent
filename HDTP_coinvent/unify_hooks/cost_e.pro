:-module(cost_e,[]).

%this makes sure bagof produces shared variables!
attr_unify_hook(Cost_e,Variable):-get_attr(Variable,cost_e,Variable_Cost_e),Cost_e==Variable_Cost_e.