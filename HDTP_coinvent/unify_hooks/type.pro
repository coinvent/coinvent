:-module(type,[]).

attr_unify_hook(Type,Variable):-get_attr(Variable,type,Variable_Type),Variable_Type==Type.