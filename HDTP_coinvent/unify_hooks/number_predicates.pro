:-module(number_predicates,[]).

attr_unify_hook(Number,Variable):-get_attr(Variable,number_predicates,Variable_Number),Variable_Number==Number.