:-module(subst_e,[]).

%this makes sure bagof produces shared variables!
attr_unify_hook(Subst_e,Variable):-get_attr(Variable,subst_e,Variable_subst_e),Subst_e=Variable_subst_e.