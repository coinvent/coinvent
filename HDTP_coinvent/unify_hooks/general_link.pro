:-module(general_link,[]).

%this makes sure bagof produces shared variables!
attr_unify_hook(General_link,Variable):-get_attr(Variable,general_link,Variable_general_link),General_link=Variable_general_link.