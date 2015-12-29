:-module(mode_p,[]).

%this makes sure bagof produces shared variables!
attr_unify_hook(Mode_p,Variable):-get_attr(Variable,mode_p,Variable_Mode_p),Mode_p==Variable_Mode_p.