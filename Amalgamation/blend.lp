
#const istop  = "SAT".
#const imin   = 1.
#const imax   = 100.
#const iquery = 1.

#program  base1. 
altered(I,0) :- spec(I).
numGeneralizations(I,0,1) :- spec(I).
numSpecs(N) :- N = {spec(I)}.

%%% Define steps
#program cumulative1(t).
s(t).

%%% Define generalization actions (Sorts are automatically removed if there is no operator or predicate left that utilizes the sort)

% Remove Operator
%% a(rmOp(I,OP),t) :- hasOp(I,OP,t), removable(I,OP).
% Remove Predicate
%% a(rmPred(I,PRED),t) :- hasPred(I,PRED,t), removable(I,PRED).
% Remove Axiom
a(rmAxDirectly(I,Ax),t) :- hasAxiom(I,Ax,t), removable(I,Ax).

%% a(rmAx(I,Ax),t) :- hasAxiom(I,Ax,t), not hasAxiom(I2,Ax,t), spec(I2), I2 != I.

% Generate generalization search space
1{exec(A,t) : a(A,t)}1 :- {isGeneric(I,t)}0. 

altered(I,t) :- exec(rmOp(I,OP),t).
altered(I,t) :- exec(rmPred(I,P),t).
altered(I,t) :- exec(rmAx(I,Ax),t).

% Indirect Axiom Removal
exec(rmAx(I,AX),t) :- exec(rmOp(I,OP),t), hasAxiom(I,AX,t), axInvolvesPredOp(AX,OP).
exec(rmAx(I,AX),t) :- exec(rmPred(I,P),t), hasAxiom(I,AX,t), axInvolvesPredOp(AX,P).
% Direct Axiom Removal
exec(rmAx(I,AX),t) :- exec(rmAxDirectly(I,AX),t).

%% Inertia for operators and predicates and axioms
hasOp(I,OP,t+1) :- hasOp(I,OP,t), not exec(rmOp(I,OP),t).
hasPred(I,P,t+1) :- hasPred(I,P,t), not exec(rmPred(I,P),t).
hasAxiom(I,A,t+1) :- hasAxiom(I,A,t), not exec(rmAx(I,A),t).

% check if a generic space has been created. 
isGeneric(I1,t) :- spec(I1), {isNotGeneric(I1,I2,t) : spec(I2)}0. %I1 is generic wrt. all input spaces, if there is no space of which I1 is not a generalization

% I2 is not a generalization of I1, if there is no identity morphism between I1 and I2.  TODO: in fact, this is not necessarily identity morphisms; it can also be isomorphisms. 
isNotGeneric(I1,I2,t) :- notPartialIdMorph(I2,I1,t), I1 != I2. 
isNotGeneric(I1,I2,t) :- notPartialIdMorph(I1,I2,t), I1 != I2. 


notPartialIdMorph(I1,I2,t) :- hasAxiom(I1,AX,t), not hasAxiom(I2,AX,t), spec(I2). %Determines whether there is no partial identity morphism for axioms from I1 to I2.
notPartialIdMorph(I1,I2,t) :- hasOp(I1,OP,t), not hasOp(I2,OP,t), spec(I2). %Determines whether there is no partial identity morphism for operators from I1 to I2.
notPartialIdMorph(I1,I2,t) :- hasPred(I1,P,t), not hasPred(I2,P,t), spec(I2). %Determines whether there is no partial identity morphism for predicates from I1 to I2.
%% notPartialIdMorph(I1,I2,t) := hasSort(I1,S,t), not hasSort(I2,S,t). %Determines whether there is no partial identity morphism for sorts from I1 to I2. (TODO: this is probably implicitly tested via operators and predicates. But think about it...)

% An input spec has a sort, if it is used by an opertor or a predicate. 
hasSort(I,S,t) :- hasOp(I,OP,t), opHasSort(OP,S). 
hasSort(I,S,t) :- hasPred(I,P,t), predHasSort(P,S). 

#program volatile1(t).
#external query1(t).
:- not isGeneric(I,t), query1(t), spec(I).

#show numSpecs/1.
#show exec/2.
#show isGeneric/2.
#show s/1.