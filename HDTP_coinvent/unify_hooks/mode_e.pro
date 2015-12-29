:-module(mode_e,[]).

%this makes sure bagof produces shared variables!
attr_unify_hook(Mode_e,Variable):-get_attr(Variable,mode_e,Variable_Mode_e),Mode_e==Variable_Mode_e.