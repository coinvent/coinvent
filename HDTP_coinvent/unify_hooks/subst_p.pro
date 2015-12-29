:-module(subst_p,[]).

%this makes sure bagof produces shared variables!
attr_unify_hook(Subst_p,Variable):-get_attr(Variable,subst_p,Variable_subst_p),Subst_p=Variable_subst_p.