:-module(mode_f,[]).

%this makes sure bagof produces shared variables!
attr_unify_hook(Mode_f,Variable):-get_attr(Variable,mode_f,Variable_Mode_f),Mode_f==Variable_Mode_f.