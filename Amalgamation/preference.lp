%
% PREFERENCE STATEMENTS
%

#preference(p1,aso){
  exec(rmAx(AX2),I,t)  > exec(rmAx(AX1),I,t)  :- priority(I,AX1,P1), priority(I,AX2,P2), P1 > P2, AX1 != AX2, s(t).
.
}.
#optimize(p1).

