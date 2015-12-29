:-module(sig,[]).

attr_unify_hook(Sig,Variable):-get_attr(Variable,sig,Variable_Sig),Variable_Sig=Sig.