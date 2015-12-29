:-module(cost_i,[]).

%this makes sure bagof produces shared variables!
attr_unify_hook(Cost_i,Variable):-get_attr(Variable,cost_i,Variable_Cost_i),Cost_i==Variable_Cost_i.