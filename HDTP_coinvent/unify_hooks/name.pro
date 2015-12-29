:-module(name,[]).

attr_unify_hook(Name,Variable):-get_attr(Variable,name,Variable_Name),Variable_Name==Name.