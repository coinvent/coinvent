:-module(sort_link,[]).

attr_unify_hook(Sort_link,Variable):-get_attr(Variable,sort_link,Variable_sort_link),Sort_link=Variable_sort_link.