:-module(subst_f,[]).

%this makes sure bagof produces shared variables!
attr_unify_hook(Subst_f,Variable):-get_attr(Variable,subst_f,Variable_subst_f),Subst_f=Variable_subst_f.