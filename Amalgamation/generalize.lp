%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This is the LP implementation of the generalization part of the amalgamation module    %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%
%%% Defining Part %%%
%%%%%%%%%%%%%%%%%%%%%

%%% The base program is iteration independent. These are just some auxiliary predicates.
#program  base1. 

%%% Declare Axioms, sorts, operators, predicats.
%% axiom(Ax) :- hasAxiom(_,Ax,1).
operator(Op) :- hasOp(_,Op,1).
predicate(Pred) :- hasPred(_,Pred,1).
sort(S) :- hasSort(_,S,1).

%%% Declare atomic generalization operations. 
% Removal actions
a(rmOp(OP),I) :- removableOp(I,OP).
a(rmPred(PRED),I) :- removablePred(I,PRED).
a(rmAx(Ax),I) :- removableAx(I,Ax).
a(rmSort(S),I) :- removableSort(I,S).
%Renaming actions
% Rename Op1 to Op2.
a(renameOp(Op1,Op2),I1) :- removableOp(I1,Op1), removableOp(I2,Op2).

% Determine removability of elements by priority.
removableOp(I,Op) :- priorityOp(I,Op,-1,1).
removableAx(I,Ax) :- priorityAx(I,Ax,-1,1).
removablePred(I,Pred) :- priorityPred(I,Pred,-1,1).
removableSort(I,Sort) :- prioritySort(I,Sort,-1,1).

%%% Define steps
#program cumulative1(t).
s(t).

%%% Set preconditions for atomic generalization operations

% Remove Operator
%% #external rmOpAllowed.
%% poss(rmOp(Op),I,t) :- hasOp(I,Op,t), removableOp(I,Op), 0{hasAxiom(I,Ax,t) : axInvolvesPredOpSort(Ax,Op)}0.
% Rename Operator.
poss(renameOp(Op1,Op2),I,t) :- hasOp(I,Op1,t), removableOp(I,Op1), hasOp(I2,Op2,t), not sortsNotEqual(Op1,Op2,t), removableOp(I2,Op2), Op1 != Op2, not wasRenamedToBefore(I,Op2,t), I != I2,
	not hasOp(I,Op2,t),
	not hasOp(I2,Op1,t).

%% exec(renameOp(v1,v2),s1,1).
%% exec(renameOp(v1,v2),s2,1).

wasRenamedToBefore(I,Op2,t) :- exec(renameOp(Op1,Op2),I,T), T < t.
sortsNotEqual(Op1,Op2,t) :- opHasSort(Op1,S,Pos,t), not opHasSort(Op2,S,Pos,t), operator(Op2). 
sortsNotEqual(Op1,Op2,t) :- opHasSort(Op2,S,Pos,t), not opHasSort(Op1,S,Pos,t), operator(Op1). 
sortsNotEqual(Op1,Op2,t) :- sortsNotEqual(Op2,Op1,t).

% Remove Predicate
%% #external rmPredAllowed.
%% poss(rmPred(Pred),I,t) :- hasPred(I,Pred,t), removablePred(I,Pred), 0{hasAxiom(I,Ax,t) : axInvolvesPredOpSort(Ax,Pred)}0.

% Remove Sort 
%% #external rmSortAllowed.
%% poss(rmSort(S),I,t) :- hasSort(I,S,t), removableSort(I,S) , isNotParentSort(I,S,t), noOpUsesSort(I,S,t), noPredUsesSort(I,S,t), noAxUsesSort(I,S,t).
%% isNotParentSort(I,S,t) :- 0{hasSort(I,S_child,t) : isParentSort(I,S, S_child)}0, hasSort(I,S,t).
%% noOpUsesSort(I,S,t) :- 0{hasOp(I,Op,t) : opHasSort(Op,S,_,t)}0, hasSort(I,S,t).
%% noPredUsesSort(I,S,t) :- 0{hasPred(I,Pred,t) : predHasSort(Pred,S_,t)}0, hasSort(I,S,t).
%% noAxUsesSort(I,S,t) :- 0{hasAx(I,Ax,t) : axInvolvesPredOpSort(Ax,S)}0, hasSort(I,S,t).

% Remove Axiom
%% #external rmAxAllowed.
%% poss(rmAx(Ax),I,t) :- hasAxiom(I,Ax,t), removableAx(I,Ax).

% Some auxiliary information to quickly tell whether a spec was modified at a time point.
specModified(I,t) :- exec(A,I,t).

%% Inertia for sorts, operators and predicates and axioms
hasOp(I,OP,t+1) :- hasOp(I,OP,t), not exec(rmOp(OP),I,t), not exec(renameOp(OP,_),I,t).
hasPred(I,P,t+1) :- hasPred(I,P,t), not exec(rmPred(P),I,t).
hasSort(I,S,t+1) :- hasSort(I,S,t), not exec(rmSort(S),I,t).
opHasSort(Op,S,Pos,t+1) :- opHasSort(Op,S,Pos,t).

hasAxiom(I,A,t+1) :- hasAxiom(I,A,t), not exec(rmAx(A),I,t), 0{exec(renameOp(Op1,Op2),I,t) : axInvolvesPredOpSort(Ax,Op1)}0.
newAxiomRenameOp(I,AxOld,AxNew,Op1,Op2,t) :- hasAxiom(I,AxOld,t), exec(renameOp(Op1,Op2),I,t), axInvolvesPredOpSort(AxOld,Op1), AxNew = @getNewAxIdOpRename(AxOld,Op1,Op2).
hasAxiom(I,AxNew,t+1) :- newAxiomRenameOp(I,AxOld,AxNew,Op1,Op2,t).

%% Copy old operators from axiom, except the one operator to be renamed.
%% axInvolvesPredOpSort(AxNew,OpOld) :- newAxiomRenameOp(I,AxOld,AxNew,Op1,Op2,t), axInvolvesPredOpSort(AxOld,OpOld), OpOld != Op1.
%% Add new operator to new axiom
%% axInvolvesPredOpSort(AxNew,Op2) :- newAxiomRenameOp(I,AxOld,AxNew,Op1,Op2,t).
%% axiom(AxNew) :- newAxiomRenameOp(I,AxOld,AxNew,Op1,Op2,t)

%% Change operator, predicate and sort names.
hasOp(I,OpNew,t+1) :- exec(renameOp(OpOld,OpNew),I,t).

%% Copy prioritis when renaming things. The sum of priorities is assigned if the operator already exists. 
priorityOp(I,Op,P,t+1) :- priorityOp(I,Op,P,t), not exec(renameOp(Op,_),I,t), not exec(rmOp(Op),I,t).
priorityOp(I,Op2,P,t+1) :- priorityOp(I,Op1,P,t), exec(renameOp(Op1,Op2),I,t), not hasOp(I,Op2,t). 
priorityOp(I,Op2,P1+P2,t+1) :- priorityOp(I,Op1,P1,t), exec(renameOp(Op1,Op2),I,t), hasOp(I,Op2,t), priorityOp(I,Op2,P2,t). 

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

%% Speedup 2: have a total (or partial) priority order on predicates, operators and axioms, and do generalization strictly in that order. That is, only do optimal generalizations in terms of priority. The advantage is the much better performance, the disadvantage is that only optimal blends are generated. Optimal blends are often good, but not always the "best" or "most interesting" blends. 
:- not stepOptimal(I,t), specModified(I,t).

%% Disable models where the generic space is not yet reached. The external atom query(t) is induced into the Logic Program externally in the iterationCore-py.lp main loop.
#external query1(t).
:- query1(t), notGenericReached(t).

%%%%%%%%%%%%%%%%%%%%%%%
%%% Evaluation Part %%%
%%%%%%%%%%%%%%%%%%%%%%%

%% Determine whether predicates, operators or axioms are present in all input spaces, i.e., if there is no spec that does not have the axiom, predicate or operator.
allSpecsHaveAx(Ax,t) :- 0{spec(I_other) : not hasAxiom(I_other,Ax,t), spec(I_other)}0, hasAxiom(_,Ax,t).
allSpecsHavePred(PRED,t) :- 0{spec(I_other) : not hasPred(I_other,PRED,t), spec(I_other)}0, predicate(PRED).
allSpecsHaveOp(OP,t) :- 0{spec(I_other) : not hasOp(I_other,OP,t), spec(I_other)}0, operator(OP).
%% For sorts this does not work due to subsorts, because sometimes it is necessary to remove a child sort that is common in all input spaces to be able to remove a parent sort that is present in only one input space. Maybe a modified version is possible that respects subsorts. 
allSpecsHaveSort(S,t) :- 0{spec(I_other) : not hasSort(I_other,S,t), spec(I_other)}0, sort(S).

stepOptimal(I,t) :- rmLowestPriorityAx(I,Ax,t).
stepOptimal(I,t) :- rmLowestPriorityOp(I,Op,t).
stepOptimal(I,t) :- rmLowestPriorityPred(I,Pred,t).
stepOptimal(I,t) :- rmLowestPrioritySort(I,Sort,t).
stepOptimal(I,t) :- exec(renameOp(Op1,Op2),I,t).
%% stepOptimal(I,t) :- spec(I).

%% Determine when the axiom with the lowest possible priority has been removed. It should be impossible to remove an axiom that exists in all input spaces TODO: Write similar rules for predicates and operators. For Sorts, this is a bit more difficult because of subsorting. 
rmLowestPriorityAx(I,Ax,t) :- priorityAx(I,Ax,P,t), exec(rmAx(Ax),I,t), not allSpecsHaveAx(Ax,t), 0{hasAxiom(I,Ax_other,t) : priorityAx(I,Ax_other,P_other,t), Ax != Ax_other, P_other < P, removableAx(I,Ax_other), not allSpecsHaveAx(Ax_other,t)}0.
rmLowestPriorityOp(I,Op,t) :- priorityOp(I,Op,P,t), exec(rmOp(Op),I,t), not allSpecsHaveOp(Op,t), 0{hasOp(I,Op_other,t) : priorityOp(I,Op_other,P_other,t), Op != Op_other, P_other < P, removableOp(I,Op_other), not allSpecsHaveOp(Op_other,t)}0.
rmLowestPriorityPred(I,Pred,t) :- priorityPred(I,Pred,P,t), exec(rmPred(Pred),I,t), not allSpecsHavePred(Pred,t), 0{hasPred(I,Pred_other,t) : priorityPred(I,Pred_other,P_other,t), Pred != Pred_other, P_other < P, removablePred(I,Pred_other), not allSpecsHavePred(Pred_other,t)}0.
rmLowestPrioritySort(I,Sort,t) :- prioritySort(I,Sort,P,t), exec(rmSort(Sort),I,t), not allSpecsHaveSort(Sort,t), 0{hasSort(I,Sort_other,t) : prioritySort(I,Sort_other,P_other,t), Sort != Sort_other, P_other < P, removableSort(I,Sort_other), not allSpecsHaveSort(Sort_other,t)}0.


%% totalGenValue(V,t) :- V = {stepOptimal(I,T) : s(T), spec(I)}, not notGenericReached(t).
%% #maximize{V@1 : totalGenValue(V,t)}.


%% #show hasOp/3.
#show newAxiomRenameOp/6.
%% #show totalGenValue/2.
#show exec/3.
%% #show stepOptimal/2.
%% #show rmLowestPriorityAx/3.
%% #show genericReachedAt/2.
%% #show s/1.