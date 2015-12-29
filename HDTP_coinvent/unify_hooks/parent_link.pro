:-module(parent_link,[]).

attr_unify_hook(Parent_link,Variable):-get_attr(Variable,parent_link,Variable_parent_link),Parent_link=Variable_parent_link.