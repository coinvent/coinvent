#program base.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% spec S1 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

spec(spec_S1).
hasId(spec_S1,0).

%% sorts %%
hasSort(spec_S1,sort_ThisSort1,0).
isNonDataSort(spec_S1,sort_ThisSort1).
sortHasPriority(spec_S1,sort_ThisSort1,1).

hasSort(spec_S1,sort_Value,0).
isDataSort(spec_S1,sort_Value).
sortHasPriority(spec_S1,sort_Value,0).

%% operators %%
hasOp(spec_S1,po_f,0).
opHasSort(spec_S1,po_f,sort_Value,domain,0).
isNonDataOp(spec_S1,po_f).
opHasPriority(spec_S1,po_f,1).

hasOp(spec_S1,po_o1,0).
opHasSort(spec_S1,po_o1,sort_ThisSort1,domain,0).
isNonDataOp(spec_S1,po_o1).
opHasPriority(spec_S1,po_o1,1).

hasOp(spec_S1,po_v1,0).
opHasSort(spec_S1,po_v1,sort_Value,domain,0).
isDataOp(spec_S1,po_v1).
opHasPriority(spec_S1,po_v1,0).

hasOp(spec_S1,po_v2,0).
opHasSort(spec_S1,po_v2,sort_Value,domain,0).
isDataOp(spec_S1,po_v2).
opHasPriority(spec_S1,po_v2,0).

%% predicates %%
%% axioms %%

%% Axiom Ax1-1:p:4 %%
hasAxiom(spec_S1,0,0).
axHasEquivalenceClass(spec_S1,0,0,0).
isNonDataAx(spec_S1,0).
axHasPriority(spec_S1,0,4).
axInvolvesPredOp(spec_S1,0,po_v1,0).
axInvolvesPredOp(spec_S1,0,po_f,0).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% spec S2 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

spec(spec_S2).
hasId(spec_S2,1).

%% sorts %%
hasSort(spec_S2,sort_ThisSort2,0).
isNonDataSort(spec_S2,sort_ThisSort2).
sortHasPriority(spec_S2,sort_ThisSort2,1).

hasSort(spec_S2,sort_Value,0).
isDataSort(spec_S2,sort_Value).
sortHasPriority(spec_S2,sort_Value,0).

%% operators %%
hasOp(spec_S2,po_f,0).
opHasSort(spec_S2,po_f,sort_Value,domain,0).
isNonDataOp(spec_S2,po_f).
opHasPriority(spec_S2,po_f,1).

hasOp(spec_S2,po_o2,0).
opHasSort(spec_S2,po_o2,sort_ThisSort2,domain,0).
isNonDataOp(spec_S2,po_o2).
opHasPriority(spec_S2,po_o2,1).

hasOp(spec_S2,po_v1,0).
opHasSort(spec_S2,po_v1,sort_Value,domain,0).
isDataOp(spec_S2,po_v1).
opHasPriority(spec_S2,po_v1,0).

hasOp(spec_S2,po_v2,0).
opHasSort(spec_S2,po_v2,sort_Value,domain,0).
isDataOp(spec_S2,po_v2).
opHasPriority(spec_S2,po_v2,0).

%% predicates %%
%% axioms %%

%% Axiom Ax2-1:p:4 %%
hasAxiom(spec_S2,4,0).
axHasEquivalenceClass(spec_S2,4,4,0).
isNonDataAx(spec_S2,4).
axHasPriority(spec_S2,4,4).
axInvolvesPredOp(spec_S2,4,po_v2,0).
axInvolvesPredOp(spec_S2,4,po_f,0).




