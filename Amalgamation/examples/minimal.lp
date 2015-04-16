#program base.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% spec S1 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

spec(spec_S1).
hasId(spec_S1,0).

%% sorts %%
hasSort(spec_S1,sort_Value,0).
isNonDataSort(spec_S1,sort_Value).
sortHasPriority(spec_S1,sort_Value,1).

%% operators %%
hasOp(spec_S1,po_f,0).
opHasSort(spec_S1,po_f,sort_Value,domain,0).
isNonDataOp(spec_S1,po_f).
opHasPriority(spec_S1,po_f,1).

hasOp(spec_S1,po_v1,0).
opHasSort(spec_S1,po_v1,sort_Value,domain,0).
isNonDataOp(spec_S1,po_v1).
opHasPriority(spec_S1,po_v1,6).

%% predicates %%
%% axioms %%

%% Axiom Ax1-1:p:2 %%
hasAxiom(spec_S1,0,0).
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
isNonDataSort(spec_S2,sort_Value).
sortHasPriority(spec_S2,sort_Value,1).

%% operators %%
hasOp(spec_S2,po_f,0).
opHasSort(spec_S2,po_f,sort_Value,domain,0).
isNonDataOp(spec_S2,po_f).
opHasPriority(spec_S2,po_f,1).

hasOp(spec_S2,po_v2,0).
opHasSort(spec_S2,po_v2,sort_Value,domain,0).
isNonDataOp(spec_S2,po_v2).
opHasPriority(spec_S2,po_v2,4).

%% predicates %%
%% axioms %%

%% Axiom Ax2-1:p:4 %%
hasAxiom(spec_S2,2,0).
isNonDataAx(spec_S2,2).
axHasPriority(spec_S2,2,4).
axInvolvesPredOp(spec_S2,2,po_v2,0).
axInvolvesPredOp(spec_S2,2,po_f,0).




