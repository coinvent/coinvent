%
% PREFERENCE STATEMENTS
%

#preference(p1,aso){
  exec(rmAx(AX2),I,t)  > exec(rmAx(AX1),I,t)  :- priority(I,AX1,P1), priority(I,AX2,P2), P1 > P2, AX1 != AX2, s(T_before), T_before < t.
}.
#optimize(p1).


priority(1,8).
priority(2,3).


exec((rmAx(2),s1,1) , exec((rmAx(1),s1,2).
>
exec((rmAx(1),s1,1) , exec((rmAx(2),s1,2).




