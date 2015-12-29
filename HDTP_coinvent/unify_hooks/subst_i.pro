:-module(subst_i,[]).

%this makes sure bagof produces shared variables!
attr_unify_hook(Subst_i,Variable):-get_attr(Variable,subst_i,Variable_subst_i),Subst_i=Variable_subst_i.