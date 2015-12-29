:-module(var_link,[]).

%this makes sure bagof produces shared variables!
attr_unify_hook(Var_link,Variable):-get_attr(Variable,var_link,Variable_var_link),Var_link=Variable_var_link.