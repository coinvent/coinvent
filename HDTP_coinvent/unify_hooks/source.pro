:-module(source,[]).

attr_unify_hook(Source,Variable):-get_attr(Variable,source,Variable_Source),Variable_Source==Source.