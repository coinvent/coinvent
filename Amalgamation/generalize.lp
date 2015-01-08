%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This is the LP implementation of the generalization part of the amalgamation module    %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%
%%% Defining Part %%%
%%%%%%%%%%%%%%%%%%%%%

%%% The base program is iteration independent. These are just some auxiliary predicates.
#program  base1. 

%%% Declare atomic generalization operations. (Sorts are automatically removed if there is no operator or predicate left that utilizes the sort. Therefore there is no explicit operation to remove sorts.)
a(rmOp(OP),I) :- removable(I,OP).
a(rmPred(PRED),I) :- removable(I,PRED).
%% a(rmAxDirectly(Ax),I) :- removable(I,Ax).
a(rmAx(Ax),I) :- removable(I,Ax).
a(rmSort(S),I) :- removable(I,S).

%%% Initial generalization value is 0 for all specs.
genValue(I,0,1) :- spec(I).

%%% Define steps
#program cumulative1(t).
s(t).

%%% Set preconditions for atomic generalization operations

% Remove Operator
%% #external rmOpAllowed.
%% poss(rmOp(Op),I,t) :- hasOp(I,Op,t), removable(I,Op), 0{hasAxiom(I,Ax,t) : axInvolvesPredOp(Ax,Op)}0.

% Remove Predicate
%% #external rmPredAllowed.
%% poss(rmPred(Pred),I,t) :- hasPred(I,Pred,t), removable(I,Pred), 0{hasAxiom(I,Ax,t) : axInvolvesPredOp(Ax,Pred)}0.

% Remove Sort 
%% #external rmSortAllowed.
%% poss(rmSort(S),I,t) :- hasSort(I,S,t), removable(I,S) , isNotParentSort(I,S,t), noOpUsesSort(I,S,t), noPredUsesSort(I,S,t).
%% isNotParentSort(I,S,t) :- 0{hasSort(I,S_child,t) : isParentSort(I,S, S_child)}0, hasSort(I,S,t).
%% noOpUsesSort(I,S,t) :- 0{hasOp(I,Op,t) : opHasSort(I,Op,S)}0, hasSort(I,S,t).
%% noPredUsesSort(I,S,t) :- 0{hasPred(I,Op,t) : predHasSort(I,Op,S)}0, hasSort(I,S,t).

% Remove Axiom
%% #external rmAxAllowed.
%% poss(rmAxDirectly(Ax),I,t) :- hasAxiom(I,Ax,t), removable(I,Ax).
poss(rmAx(Ax),I,t) :- hasAxiom(I,Ax,t), removable(I,Ax).

% Indirect Axiom Removal
%% exec(rmAx(AX),I,t) :- exec(rmOp(OP),I,t), hasAxiom(I,AX,t), axInvolvesPredOp(AX,OP).
%% exec(rmAx(AX),I,t) :- exec(rmPred(P),I,t), hasAxiom(I,AX,t), axInvolvesPredOp(AX,P).
% Direct Axiom Removal
%% exec(rmAx(AX),I,t) :- exec(rmAxDirectly(AX),I,t).

% Some auxiliary information to quickly tell whether a spec was modified at a time point.
specModified(I,t) :- exec(A,I,t).

%% Inertia for operators and predicates and axioms
hasOp(I,OP,t+1) :- hasOp(I,OP,t), not exec(rmOp(OP),I,t).
hasPred(I,P,t+1) :- hasPred(I,P,t), not exec(rmPred(P),I,t).
hasAxiom(I,A,t+1) :- hasAxiom(I,A,t), not exec(rmAx(A),I,t).
hasSort(I,S,t+1) :- hasSort(I,S,t), not exec(rmSort(S),I,t).

%%%%%%%%%% Check if a generic space hase been reached %%%%%%%%%%
% A generic space is reached if there are total morphisms between all generalized versions of all input spaces, i.e. when for all input spaces a generalized vesion is found that is isomorphic with all other generalized versions of input spaces. In this preliminary version we make restriction that we only consider identity morphisms. We also assume that symbols in one input space mean the same as symbols in the other input space. (E.e. we can only have a (river)bank in one input space and a (financial)bank in the other if the symbols are not equal, i.e. we would have to explicitly say river_bank and financial_bank.) Overloading is also not supported.

% In other words, generalized versions of input spaces I1 and I2 are generic spaces when there exists a total bi-directional morphism (mapping) between them. Accordingly, for three input spaces, we would check whether there are total morphisms between all three input spaces. If this is the case, all three generalized versions of input spaces are generic spaces.
% To find the generic spaces, we have to investigate the morphisms between the generalized versions of the input spaces. This is done as follows:

% First, check whether there can be partial identity morphisms of axioms, sorts, operators and predicates from an input space I1 to an input space I2. There can not be partial identity morphisms if for axioms, sorts, operators and predicates one element does occur in I1 but not in I2.
notPartialIdMorph(I1,I2,t) :- hasAxiom(I1,AX,t), not hasAxiom(I2,AX,t), spec(I2), I1 != I2.
notPartialIdMorph(I1,I2,t) :- hasOp(I1,OP,t), not hasOp(I2,OP,t), spec(I2), I1 != I2.
notPartialIdMorph(I1,I2,t) :- hasPred(I1,P,t), not hasPred(I2,P,t), spec(I2), I1 != I2.
notPartialIdMorph(I1,I2,t) :- hasSort(I1,S,t), not hasSort(I2,S,t), spec(I2), I1 != I2.

% Next, we check if two spaces I2 and I1 are _not_ isomorphisc. This is the case if there is no partial identity morphism from I2 to I1 or no partial id morphism from I1 to I2.
isNotIsomorphic(I1,I2,t) :- notPartialIdMorph(I2,I1,t), I1 != I2. 
isNotIsomorphic(I1,I2,t) :- notPartialIdMorph(I1,I2,t), I1 != I2. 

% Finally we determine whether an input space I1 is generic wrt. all other input spaces. This is the case if there is no space with which I1 is not isomorphic.
allIsomorphic(I1,t) :- spec(I1), {isNotIsomorphic(I1,I2,t) : spec(I2)}0. 
% If there is at least one spec which is not isomorphic with all other input spaces, we have not reached the generic space.
notGenericReached(t) :- not allIsomorphic(I,t), spec(I). 

% Determine when the generic space has been reached.
%% genericReachedAt(T,t) :- notGenericReached(T-1), not notGenericReached(T), s(T).


%%%%%%%%%%%%%%%%%%%%%%%
%%% Generating Part %%%
%%%%%%%%%%%%%%%%%%%%%%%

%% % Generate generalization search space. If the generic space is not yet reached, execute a generalization operation. I tested three generation rule variations. The last seems to be the fastest for a small planning horizon, even though the search space becomes bigger that way.
%% This does not work anymore properly after introducing generalization operations on sorts. 
%% 0{exec(A,I,t) : a(A,I),  poss(A,I,t), notPartialIdMorph(I,I2,t), spec(I2), I != I2 }1 :- notGenericReached(t), spec(I).
%% This seems to be quite OK:
0{exec(A,I,t) : a(A,I),  poss(A,I,t), not allIsomorphic(I,t)}1 :- notGenericReached(t), spec(I).
%% This seems to be fastest for a small planning horizon:
%% 0{exec(A,I,t) : poss(A,I,t)}1 :- notGenericReached(t), spec(I).

%%%%%%%%%%%%%%%%%%%%
%%% Testing Part %%%
%%%%%%%%%%%%%%%%%%%%

%% Domain-independent heuristics:
%% Speedup 1: No "gaps" on operation steps: if no operation happens at a step, then no operations will happen in the future anymore. 
:- specModified(I,t), not specModified(I,T_before), T_before < t, s(T_before).

%% Speedup 2: Do not remove predicates, operators or axioms if they are present in all input spaces, i.e., if there is no spec that does not have the axiom, predicate or operator.
%% :- exec(rmAxDirectly(Ax),I,t), 0{spec(I_other) : not hasAxiom(I_other,Ax,t), spec(I_other)}0.
:- exec(rmAx(Ax),I,t), 0{spec(I_other) : not hasAxiom(I_other,Ax,t), spec(I_other)}0.
:- exec(rmPred(PRED),I,t), 0{spec(I_other) : not hasPred(I_other,PRED,t), spec(I_other)}0.
:- exec(rmOp(OP),I,t), 0{spec(I_other) : not hasOp(I_other,OP,t), spec(I_other)}0.
%% For sorts this speedup does not work due to subsorts, because sometimes it is necessary to remove a child sort that is common in all input spaces to be able to remove a parent sort that is present in only one input space. Maybe a modified version is possible that respects subsorts. 
%% :- exec(rmSort(S),I,t), 0{spec(I_other) : not hasSort(I_other,S,t), spec(I_other)}0.

%% Speedup 3 (optional): have a total (or partial) priority order on predicates, operators and axioms, and do generalization strictly in that order. That is, only do optimal generalizations in terms of priority. The advantage is the much better performance, the disadvantage is that only optimal blends are generated. Optimal blends are often good, but not always the "best" or "most interesting" blends. 
%% :- not stepOptimal(I,t), specModified(I,t).

%% Disable models where the generic space is not yet reached. The external atom query(t) is induced into the Logic Program externally in the iterationCore-py.lp main loop.
#external query1(t).
:- query1(t), notGenericReached(t).


%%%%%%%%%%%%%%%%%%%%%%%
%%% Evaluation Part %%%
%%%%%%%%%%%%%%%%%%%%%%%

stepOptimal(I,t) :- not specModified(I,t), spec(I).
stepOptimal(I,t) :- rmLowestPriorityAx(I,Ax,t).
rmLowestPriorityAx(I,Ax,t) :- priority(I,Ax,P), exec(rmAx(Ax),I,t), 0{hasAxiom(I,Ax_other,t) : priority(I,Ax_other,P_other), Ax != Ax_other, P_other < P, removable(I,Ax_other)}0.

totalGenValue(V,t) :- V = {stepOptimal(I,T) : s(T), spec(I)}, not notGenericReached(t).

#maximize{V@1 : totalGenValue(V,t)}.


#show totalGenValue/2.
#show exec/3.
%% #show genericReachedAt/2.
%% #show s/1.