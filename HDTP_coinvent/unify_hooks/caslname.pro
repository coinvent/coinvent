:-module(caslname,[]).

attr_unify_hook(CaslName,Variable):-get_attr(Variable,caslname,Variable_CaslName),Variable_CaslName=CaslName.