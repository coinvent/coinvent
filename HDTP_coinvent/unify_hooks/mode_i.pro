:-module(mode_i,[]).

%this makes sure bagof produces shared variables!
attr_unify_hook(Mode_i,Variable):-get_attr(Variable,mode_i,Variable_Mode_i),Mode_i==Variable_Mode_i.