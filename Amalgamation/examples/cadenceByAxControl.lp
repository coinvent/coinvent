
#program cumulative1(t).

%%%%% Only remove an axiom if a contradicting axiom has not been removed before from another spec.

%% It is mandatory to remove an axiom if at least one other input spec has an axiom that involves the same removable operator.
%% manRmAxWithPO(PO,t) :- hasAxiom(I1,Ax1,t), axInvolvesPredOp(Ax1,PO), hasAxiom(I2,Ax2,t), axInvolvesPredOp(Ax2,PO), removable(PO), I1 != I2, Ax1 != Ax2.
%% If there is am axiom such that one input spec has a contradicting axiom (determined by manRmAx), remove it. 
%% :- exec(rmAx(I1,Ax1),t), axInvolvesPredOp(Ax1,PO), not manRmAxWithPO(PO,t), manRmAxWithPO(_,t).
%%%%%%

%% Must remove an axiom if there is another spec with a contradicting axiom.
%% :- not axInvolvesPredOp(Ax1,PO), exec(rmAx(I,Ax1),t), hasAxiom(I1,Ax1,t), axInvolvesPredOp(Ax1,PO)

%% Only remove an axiom if it is not the case that all other input spaces have the axiom. 
:- exec(rmAx(I,Ax1),t), IHasAx = {hasAxiom(I2,Ax,t) : spec(I2)}, numSpecs(IHasAx). 

%% Remove axioms alternatingly, i.e. only consider symmetric blends
:- altered(I,t), altered(I,t-1), s(t), s(t-1).

exec(rmAxDirectly(phrygiancadence,25),t) :- t = 1. %% prefinal
exec(rmAxDirectly(perfect7cadence,2),t) :- t = 2.  %% final
exec(rmAxDirectly(phrygiancadence,29),t) :- t = 3. %% pfrel
exec(rmAxDirectly(perfect7cadence,4),t) :- t = 4.  %% rootsRel
exec(rmAxDirectly(phrygiancadence,27),t) :- t = 5. %% bassRel

%% exec(rmAx(perfect7cadence,2),t) :- t = 6.
%% exec(rmAx(phrygiancadence,27),t) :- t = 7.
%% exec(rmAx(perfect7cadence,3),t) :- t = 8.
%% exec(rmAx(phrygiancadence,26),t) :- t = 9.
%% exec(rmAx(perfect7cadence,5),t) :- t = 10.






%% #program volatile1(t).
%% #external query1(t).
%% :- not isGeneric(I,t), query1(t), spec(I).


%% #show exec/2.
%% #show isGeneric/2.
%% #show s/1