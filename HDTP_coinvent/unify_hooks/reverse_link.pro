:-module(reverse_link,[]).

%this makes sure bagof produces shared variables!
attr_unify_hook(Reverse_link,Variable):-get_attr(Variable,reverse_link,Variable_reverse_link),Reverse_link=Variable_reverse_link.