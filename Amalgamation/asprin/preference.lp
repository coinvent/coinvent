%
% PREFERENCE STATEMENTS
%

#preference(p1,aso){
  a(X) > a(Y) :- gr(X), gr(Y), X = Y - 1.
}.
#optimize(p1).

