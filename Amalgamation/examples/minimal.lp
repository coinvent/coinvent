#program base.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% spec S1 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

spec(spec_S1).
hasId(spec_S1,0).

%% sorts %%
hasSort(spec_S1,sort_Value,0).
isDataSort(spec_S1,sort_Value).
sortHasPriority(spec_S1,sort_Value,1).

%% operators %%
hasOp(spec_S1,po_f,0).
opHasSort(spec_S1,po_f,sort_Value,domain,0).
isNonDataOp(spec_S1,po_f).
opHasPriority(spec_S1,po_f,1).

hasOp(spec_S1,po_v1,0).
opHasSort(spec_S1,po_v1,sort_Value,domain,0).
isDataOp(spec_S1,po_v1).
opHasPriority(spec_S1,po_v1,1).

hasOp(spec_S1,po_v2,0).
opHasSort(spec_S1,po_v2,sort_Value,domain,0).
isDataOp(spec_S1,po_v2).
opHasPriority(spec_S1,po_v2,1).

%% predicates %%
%% axioms %%

%% Axiom Ax1-1:p:2 %%
hasAxiom(spec_S1,0,0).
axHasEquivalenceClass(spec_S1,0,0,0).
isNonDataAx(spec_S1,0).
axHasPriority(spec_S1,0,2).
axInvolvesPredOp(spec_S1,0,po_v1,0).
axInvolvesPredOp(spec_S1,0,po_f,0).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% spec S2 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

spec(spec_S2).
hasId(spec_S2,1).

%% sorts %%
hasSort(spec_S2,sort_Value,0).
isDataSort(spec_S2,sort_Value).
sortHasPriority(spec_S2,sort_Value,1).

%% operators %%
hasOp(spec_S2,po_f,0).
opHasSort(spec_S2,po_f,sort_Value,domain,0).
isNonDataOp(spec_S2,po_f).
opHasPriority(spec_S2,po_f,1).

hasOp(spec_S2,po_v1,0).
opHasSort(spec_S2,po_v1,sort_Value,domain,0).
isDataOp(spec_S2,po_v1).
opHasPriority(spec_S2,po_v1,1).

hasOp(spec_S2,po_v2,0).
opHasSort(spec_S2,po_v2,sort_Value,domain,0).
isDataOp(spec_S2,po_v2).
opHasPriority(spec_S2,po_v2,1).

%% predicates %%
%% axioms %%

%% Axiom Ax2-1:p:4 %%
hasAxiom(spec_S2,3,0).
axHasEquivalenceClass(spec_S2,3,3,0).
isNonDataAx(spec_S2,3).
axHasPriority(spec_S2,3,4).
axInvolvesPredOp(spec_S2,3,po_v2,0).
axInvolvesPredOp(spec_S2,3,po_f,0).




