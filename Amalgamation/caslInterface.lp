%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This contains the LP interface for the amalgams module for the language CASL, extended with priorities. 
%% OUTPUT:
%% The module triggers the following atoms which are needed in the language-independent part of the amalgamation module:
%% 1. non-equality of conceptual spaces 
%% 		-- notEqual(<spec>,<spec>,t)
%% 2. Definition of atomic generalisation operations 
%% 		-- a(<act>) 					%% the declaration of an operation
%%		-- poss(<act>,<spec>,t)			%% the language specific precondition of an operation
%%		-- cost(<act>,<spec>,<cost>)	%% the cost of an action
%% INPUT:
%% The module relies on the following axioms which are produced by the language-independent part of the amalgamation module:
%% 1. Execution of an operation
%% 		-- exec(<act>,<spec>,t)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Main Interface  Part %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% The base program is iteration independent. These are just some auxiliary predicates.
#program  base1. 

% The specification that provides the vocabulary is the one with the lowest id (for now). 
specProvidesVocabulary(Spec1) :- spec(Spec1), hasId(Spec1,Id1), 0{spec(Spec2) : hasId(Spec2,Id2), Id2 > Id1}0.
#show specProvidesVocabulary/1.

%%%% Operator declaration %%%%

% Removal operators
a(rmOp(Op),Spec) 		:- removableOp(Spec,Op).
a(rmPred(Pred),Spec) 	:- removablePred(Spec,Pred).
a(rmSort(Spec),Sort) 	:- removableSort(Spec,Sort).
%% a(rmAx(Ax),Spec) :- removableAx(Spec,Ax).

% Renaming operators. Only non-data elements can be renamed.
a(renameOp(Op1,Op2,Spec2),Spec1) 		:- 	hasOp(Spec1,Op1,1), hasOp(Spec2,Op2,1), Spec1 != Spec2, Op1 != Op2, 
											isNonDataOp(Spec1,Op1), isNonDataOp(Spec2,Op2).
% Renaming predicates.
a(renamePred(Pred1,Pred2,Spec2),Spec1) 	:- 	hasPred(Spec1,Pred1,1), hasPred(Spec2,Pred2,1), Spec1 != Spec2, Pred1 != Pred2.

% Renaming sorts.
a(renameSort(Sort1,Sort2,Spec2),Spec1) 	:- 	hasSort(Spec1,Sort1,1), hasSort(Spec2,Sort2,1), Spec1 != Spec2, Sort1 != Sort2,
											isNonDataSort(Spec1,Sort1), isNonDataSort(Spec2,Sort2).


%%%% Cost of actions %%%%
% Cost of removal actions is equal to priority of the elements to be removed.  
cost(rmOp(Op),Spec,C) 		:- a(rmOp(Op),Spec), 		opHasPriority(Spec,Op,C).
cost(rmPred(Pred),Spec,C) 	:- a(rmPred(Pred),Spec), 	predHasPriority(Spec,Pred,C).
cost(rmSort(Sort),Spec,C) 	:- a(rmSort(Sort),Spec), 	sortHasPriority(Spec,Sort,C).
%% cost(a(rmAx(Ax),Spec),Spec,C) 		:- a(rmAx(Ax),Spec), 		axHasPriority(Spec,Ax,C).
% Cost of renaming actions is always 0.
cost(renameOp(Op1,Op2,Spec2),Spec1,0)			:- a(renameOp(Op1,Op2,Spec2),Spec1).
cost(renamePred(Pred1,Pred2,Spec2),Spec1,0)		:- a(renamePred(Pred1,Pred2,Spec2),Spec1).
cost(renameSort(Sort1,Sort2,Spec2),Spec1,0)		:- a(renameSort(Sort1,Sort2,Spec2),Spec1).

%%% Start to iterate over t.
#program cumulative1(t).

%%%% Action preconditions %%%%%

%%% Removal Operators
%% TODO: Removal is only possible if there exists another spec without the operator, predicate or sort.
% Remove Operator
poss(rmOp(Op),Spec,t) 		:- 	hasOp(Spec,Op,t),	removableOp(Spec,Op), exOtherSpecWithoutOp(Spec,Op,t),
								0{hasAxiom(Spec,Ax,t) : axInvolvesPredOp(Spec,Ax,Op,t)}0.
exOtherSpecWithoutOp(Spec1,Op,t) :- hasOp(Spec1,Op,t), not hasOp(Spec2,Op,t), spec(Spec2), Spec1 != Spec2. 

% Remove Predicate
poss(rmPred(Pred),Spec,t) 	:- 	hasPred(Spec,Pred,t), removablePred(Spec,Pred), exOtherSpecWithoutPred(Spec,Pred,t), 
								0{hasAxiom(Spec,Ax,t) : axInvolvesPredOp(Spec,Ax,Pred,t)}0.
exOtherSpecWithoutPred(Spec1,Pred,t) :- hasPred(Spec1,Pred,t), not haspred(Spec2,Pred,t), spec(Spec2), Spec1 != Spec2. 

% Remove Sort 
poss(rmSort(Sort),Spec,t) 	:- 	hasSort(Spec,Sort,t), removableSort(Spec,Sort), exOtherSpecWithoutSort(Spec,Sort,t),
								isNotParentSort(Spec,Sort,t),
								noOpUsesSort(Spec,Sort,t), noPredUsesSort(Spec,Sort,t), noAxUsesSort(Spec,Sort,t).
exOtherSpecWithoutSort(Spec1,Sort,t) :- hasSort(Spec1,Sort,t), not hasSort(Spec2,Sort,t), spec(Spec2), Spec1 != Spec2. 								

isNotParentSort(Spec,Sort,t) 	:- 	0{hasParentSort(Spec,_,Sort,t)}0, 							hasSort(Spec,Sort,t).
noOpUsesSort(Spec,Sort,t) 		:- 	0{hasOp(Spec,Op,t) : opHasSort(Spec,Op,Sort,_,t)}0, 		hasSort(Spec,Sort,t).
noPredUsesSort(Spec,Sort,t) 	:- 	0{hasPred(Spec,Pred,t) : predHasSort(Spec,Pred,Sort,_,t)}0, hasSort(Spec,Sort,t).
noAxUsesSort(Spec,Sort,t) 		:- 	0{hasAx(Spec,Ax,t) : axInvolvesSort(Spec,Ax,Sort)}0, 	hasSort(Spec,Sort,t).

% Remove Axiom
%% poss(rmAx(Ax),Spec,t) :- hasAxiom(Spec,Ax,t), removableAx(Spec,Ax).

%%% Rename Operator
poss(renameOp(Op1,Op2,Spec2),Spec1,t) :- 	a(renameOp(Op1,Op2,Spec2),Spec1), hasOp(Spec1,Op1,t), hasOp(Spec2,Op2,t),
											not opSortsNotEquivalent(Spec1,Op1,Spec2,Op2,t), 
											not hasOp(Spec1,Op2,t), not hasOp(Spec2,Op1,t),
												specProvidesVocabulary(Spec2).

%%% Rename Predicate
poss(renamePred(Pred1,Pred2,Spec2),Spec1,t) :- 	a(renamePred(Pred1,Pred2,Spec2),Spec1), hasPred(Spec1,Pred1,t), hasPred(Spec2,Pred2,t), 
												not predSortsNotEquivalent(Spec1,Pred1,Spec2,Pred2,t), 
												not hasPred(Spec1,Pred2,t), not hasPred(Spec2,Pred1,t),
												specProvidesVocabulary(Spec2).

%%% Rename Sort
poss(renameSort(Sort1,Sort2,Spec2),Spec1,t) :- 	a(renameSort(Sort1,Sort2,Spec2),Spec1), hasSort(Spec1,Sort1,t), hasSort(Spec2,Sort2,t), 
												%% TODO: in which way do sorts have to be equivalent when renaming them? Parent sorts equivalent? Child sorts equivalen? Both?
												not hasSort(Spec1,Sort2,t), not hasSort(Spec2,Sort1,t),
												specProvidesVocabulary(Spec2).


%%%% Equality of conceptual spaces %%%%
%% equal(Spec,Spec,t) 		:- 	spec(Spec).
equal(Spec1,Spec2,t) 	:- 	not notEqual(Spec1,Spec2,t), spec(Spec1), spec(Spec2).

notEqual(Spec1,Spec2,t) :- opNotEquivalent(Spec1,Spec2,_,t).
notEqual(Spec1,Spec2,t) :- predNotEquivalent(Spec1,Spec2,_,t).
notEqual(Spec1,Spec2,t) :- sortNotEquivalent(Spec1,Spec2,_,t).
%% notEqual(Spec1,Spec2,t) :- axNotEquivalent(Spec1,Spec2,_,t).


sortNotEquivalent(Spec1,Spec2,Sort,t) 	:- hasSort(Spec1,Sort,t), 	spec(Spec2), not sortEquivalent(Spec1,Spec2,Sort,t), Spec1 != Spec2.
sortNotEquivalent(Spec1,Spec2,Sort,t) 	:- hasSort(Spec1,Sort,t), 	spec(Spec2), not hasSort(Spec2,Sort,t), Spec1 != Spec2.
opNotEquivalent(Spec1,Spec2,Op,t) 		:- hasOp(Spec1,Op,t), 		spec(Spec2), not opEquivalent(Spec1,Spec2,Op,t), Spec1 != Spec2.
opNotEquivalent(Spec1,Spec2,Op,t) 		:- hasOp(Spec1,Op,t), 		spec(Spec2), not hasOp(Spec2,Op,t), Spec1 != Spec2.
predNotEquivalent(Spec1,Spec2,Pred,t) 	:- hasPred(Spec1,Pred,t), 	spec(Spec2), not predEquivalent(Spec1,Spec2,Pred,t), Spec1 != Spec2.
predNotEquivalent(Spec1,Spec2,Pred,t) 	:- hasPred(Spec1,Pred,t), 	spec(Spec2), not hasPred(Spec2,Pred,t), Spec1 != Spec2.
%% axNotEquivalent(Spec1,Spec2,Ax1,t)		:- hasAxiom(Spec1,Ax1,t), 	spec(Spec2), 0{axEquivalent(Spec1,Ax1,Spec2,Ax2,t) : hasAxiom(Spec2,Ax2,t)}0.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Internal Language Specific Part %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Determine removability of elements. This is static and hence belongs to the base part of the LP.
#program base1.
% Only non-data elements with a priority != -1 can be removed. (Setting priority to -1 is a workaround to manually define non-removable elements in a spec.)
removableOp(Spec,Op) 		:- isNonDataOp(Spec,Op), not opHasPriority(Spec,Op,-1).
removablePred(Spec,Pred) 	:- predHasPriority(Spec,Pred,P), P != -1.
removableSort(Spec,Sort) 	:- isNonDataSort(Spec,Sort), not sortHasPriority(Spec,Sort,-1).
%% removableAx(Spec,Ax) 		:- isNonDataAx(Spec,Ax), not axHasPriority(Spec,Ax,-1).

%%%% Inertia axioms for sorts, operators, predicates and axioms (i.e. quantifications and atoms in axioms). This is dynamic and we need to iterate over t.
#program cumulative1(t).
hasOp(Spec,Op,t+1) 		:- 	hasOp(Spec,Op,t), 		not exec(rmOp(Op),Spec,t), 		not exec(renameOp(Op,_,_),Spec,t).
hasPred(Spec,Pred,t+1) :- 	hasPred(Spec,Pred,t), 	not exec(rmPred(Pred),Spec,t), 	not exec(renamePred(Pred,_,_),Spec,t).		
hasSort(Spec,Sort,t+1) :- 	hasSort(Spec,Sort,t), 	not exec(rmSort(Sort),Spec,t), 	not exec(renameSort(Sort,_,_),Spec,t).		
%% hasAxiom(Spec,A,t+1) :- hasAxiom(Spec,A,t), not exec(rmAx(A),Spec,t).		

hasParentSort(Spec,Sort_child,Sort,t+1) :- hasParentSort(Spec,Sort_child,Sort,t),	not exec(renameSort(Sort,_,_),Spec,t).
hasParentSort(Spec,Sort,Sort_par,t+1) 	:- hasParentSort(Spec,Sort,Sort_par,t), 	not exec(renameSort(Sort,_,_),Spec,t).
opHasSort(Spec,Op,Sort,Pos,t+1) 		:- opHasSort(Spec,Op,Sort,Pos,t), 			not exec(renameSort(Sort,_,_),Spec,t).
predHasSort(Spec,Pred,Sort,Pos,t+1) 	:- predHasSort(Spec,Pred,Sort,Pos,t), 		not exec(renameSort(Sort,_,_),Spec,t).

%% axInvolvesPredOp(Spec,Ax,Op1,t+1) 	:- 	axInvolvesPredOp(Spec1,Ax,Op1,t),		not exec(renameOp(Op1,_,_),Spec1,t).
%% axInvolvesPredOp(Spec,Pred1,t+1) 	:- 	axInvolvesPredOp(Spec1,Ax,Pred1,t),		not exec(renamePred(Pred1,_,_),Spec1,t).
%% axChanged(Spec1,Ax1,Op1,Op2,t) 		:- 	axInvolvesPredOp(Spec1,Ax,Op1,t),		exec(renameOp(Op1,Op2,Spec2),Spec1,t).
%% axChanged(Spec1,Ax1,Pred1,Pred2,t) 	:- 	axInvolvesPredOp(Spec1,Ax,Pred1,t),		exec(renamePred(Pred1,Pred2,Spec2),Spec1,t).
%% TODO: axInvolvesSort (for quantifications)



%%%% Effect axioms of renamings for sorts, operators, predicates and axioms (i.e. quantifications and atoms in axioms)
% Effects of renaming sorts:
hasSort(Spec,Sort2,t+1) 					:-	hasSort(Spec,Sort1,t), 					exec(renameSort(Sort1,Sort2,Spec2),Spec,t).
hasParentSort(Spec,Sort_child,Sort2,t+1) 	:-	hasParentSort(Spec,Sort_child,Sort1,t),	exec(renameSort(Sort1,Sort2,Spec2),Spec,t).
hasParentSort(Spec,Sort2,Sort_par,t+1) 		:-	hasParentSort(Spec,Sort1,Sort_par,t), 	exec(renameSort(Sort1,Sort2,Spec2),Spec,t).
opHasSort(Spec,Op,Sort2,Pos,t+1) 			:-	opHasSort(Spec,Op,Sort1,Pos,t),			exec(renameSort(Sort1,Sort2,Spec2),Spec,t).
predHasSort(Spec,Pred,Sort2,Pos,t+1) 		:- 	predHasSort(Spec,Pred,Sort1,Pos,t), 	exec(renameSort(Sort1,Sort2,Spec2),Spec,t).
% Effects of renaming operators:
hasOp(Spec1,Op2,t+1) 						:-	hasOp(Spec1,Op1,t),						exec(renameOp(Op1,Op2,Spec2),Spec1,t).
%% axInvolvesPredOp(Spec,Ax,Op2,t+1) 			:- 	axInvolvesPredOp(Spec1,Ax,Op1,t),		exec(renameOp(Op1,Op2,Spec2),Spec1,t).
% Effects of renaming predicates:
hasPred(Spec1,Pred2,t+1) 					:- 	hasPred(Spec1,Pred1,t),					exec(renamePred(Pred1,Pred2,Spec2),Spec1,t).
%% axInvolvesPredOp(Spec,Pred2,t+1) 			:- 	hasPred(Spec1,Op1,t),					exec(renamePred(Pred1,Pred2,Spec2),Spec1,t).
% TODO: Effects of renaming sorts on axioms (i.e., axInvolvesSort)

%%%% Equivalence of axioms, operators, predicates and sorts %%%%

% Sorts are equivalent if their names and parent sorts are equal. 
sortEquivalent(Spec1,Spec2,Sort,t) 	:- 	Spec1 != Spec2, hasSort(Spec1,Sort,t), hasSort(Spec2,Sort1,t), 
										hasParentSort(Spec1,Sort,PSort,t), hasParentSort(Spec2,Sort,PSort,t), 
										sortEquivalent(Spec1,Spec2,PSort,t).
% Sorts are equivalent if their names and are equal and they don't have parent sorts. 
sortEquivalent(Spec1,Spec2,Sort,t) 	:- 	Spec1 != Spec2, hasSort(Spec1,Sort,t), hasSort(Spec2,Sort,t), 
										0{hasParentSort(Spec1,Sort,PSort,t) : hasSort(Spec1,PSort,t)}0,
										0{hasParentSort(Spec2,Sort,PSort,t) : hasSort(Spec2,PSort,t)}0.						
																		
%  An operator is equivalent in two different specs if its sorts are equivalent. 
opEquivalent(Spec1,Spec2,Op,t) 				:- 	Spec1 != Spec2, hasOp(Spec1,Op,t), hasOp(Spec2,Op,t), 
												not opSortsNotEquivalent(Spec1,Spec2,Op,t). 
opEquivalent(Spec1,Spec2,Op,t)				:- 	opEquivalent(Spec2,Spec1,Op,t).

opSortsNotEquivalent(Spec1,Spec2,Op,t) 		:- 	Spec1 != Spec2, opSortsNotEquivalent(Spec1,Op,Spec2,Op,t).
opSortsNotEquivalent(Spec1,Op1,Spec2,Op2,t) :- 	Spec1 != Spec2, hasOp(Spec1,Op1,t), hasOp(Spec2,Op2,t), 
												opHasSort(Spec1,Op1,Sort,Pos,t), not opSortsEquivalentAtPos(Spec1,Op1,Spec2,Op2,Pos,t).

opSortsEquivalentAtPos(Spec1,Op1,Spec2,Op2,Pos,t) 	:- 	Spec1 != Spec2, hasOp(Spec1,Op1,t), hasOp(Spec2,Op2,t),
														opHasSort(Spec1,Op1,Sort,Pos,t), opHasSort(Spec2,Op2,Sort,Pos,t),
														sortEquivalent(Spec1,Spec2,Sort,t).

%  A predicate is equivalent in two different specs if its sorts are equivalent. 
predEquivalent(Spec1,Spec2,Pred,t) 					:- 	Spec1 != Spec2, hasPred(Spec1,Pred,t), hasPred(Spec2,Pred,t), 
														not predSortsNotEquivalent(Spec1,Spec2,Pred,t). 
predEquivalent(Spec1,Spec2,Pred,t)					:- 	predEquivalent(Spec2,Spec1,Pred,t).													

predSortsNotEquivalent(Spec1,Spec2,Pred,t)			:- predSortsNotEquivalent(Spec1,Pred,Spec2,Pred,t).
predSortsNotEquivalent(Spec1,Pred1,Spec2,Pred2,t) 	:- 	Spec1 != Spec2, hasPred(Spec1,Pred1,t), hasPred(Spec2,Pred2,t), 
														predHasSort(Spec1,Pred1,Sort,Pos,t), not predSortsEquivalentAtPos(Spec1,Pred1,Spec2,Pred2,Pos,t).

predSortsEquivalentAtPos(Spec1,Pred1,Spec2,Pred2,Pos,t) 	:- 	Spec1 != Spec2, hasPred(Spec1,Pred1,t), hasPred(Spec2,Pred2,t), 
																predHasSort(Spec1,Pred1,Sort,Pos,t), predHasSort(Spec2,Pred2,Sort,Pos,t), 
																sortEquivalent(Spec1,Spec2,Sort,t).

% The set of axioms in two specs are not equivalent if there is at least one axiom in a spec for which the other spec has no equivalent.
%% axNotEquivalent(Spec1,Spec2,t) :- Spec1 != Spec2, 0{axEquivalent(Spec1,Ax1,Spec2,Ax2,t)}0, hasAxiom(Spec1,Ax1,t), spec(Spec2).

%% axEquivalent(Spec1,Ax1,Spec2,Ax2,t) :- hasEquivalenceClass(Spec1,Ax1,C,t), hasEquivalenceClass(Spec2,Ax2,C,t)

%% hasEquivalenceClass(Spec,Ax,EC,t+1) :- hasEquivalenceClass(Spec,Ax,EC,t), not axChanged(Spec,Ax,t).

%% hasEquivalenceClass(Spec,Ax,EC,t+1) :- hasEquivalenceClass(Spec,Ax,EC,t), axChanged(Spec,Ax,OpFrom,OpTo,t), EC := @newEquivalenceClass(Spec,Ax,OpFrom,OpTo).


%% #show predEquivalent/4.
%% #show hasSort/3.
%% #show poss/3.
%% #show a/2.
#show s/1.