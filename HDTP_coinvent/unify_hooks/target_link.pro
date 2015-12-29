:-module(target_link,[]).

%this makes sure bagof produces shared variables!
attr_unify_hook(Target_link,Variable):-get_attr(Variable,target_link,Variable_target_link),Target_link=Variable_target_link.