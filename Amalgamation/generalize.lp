%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This is the LP implementation of the generalization part of the amalgamation module    %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%
%%% Defining Part %%%
%%%%%%%%%%%%%%%%%%%%%

%%% The base program is iteration independent. These are just some auxiliary predicates.
#program  base1. 

%%% Define steps
#program cumulative1(t).
s(t).

%%% We have a total (or partial) priority order on predicates, operators and axioms, and generalisations should account for that order. Hence, we assign a cost to removal actions that coincides with the priority of the axiom, operator, predicate or sort to remove. This allows us to define when a generalisation action is optimal, i.e., when there is no cheaper action for which the preconditions are met.  Then we count the number of non-optimal generalisation operations as the number of operations that do not respect the priority order. This is used to prune the search space. 
isOptimal(A1,I,t) :- exec(A1,I,t), cost(A1,I,C1), 0{ a(A2,I) : poss(A2,I,t), cost(A2,I,C2), C2 < C1  }0.
nonOptimalSteps(N,I,t) :- spec(I), N = {a(A,I) : exec(A,I,T),  not isOptimal(A,I,T), T <= t}.

notGenericReached(t) :- spec(Spec1), spec(Spec2), notEqual(Spec1,Spec2,t), Spec1 != Spec2.
genericReached(t) :- not notGenericReached(t).

%%%%%%%%%%%%%%%%%%%%%%%
%%% Generating Part %%%
%%%%%%%%%%%%%%%%%%%%%%%

%% %% % Generate generalization search space. If the generic space is not yet reached, execute a generalization operation. 
%% 0{exec(A,I,t) : a(A,I),  poss(A,I,t)}1 :- not genericReached(t), spec(I).
1{exec(A,I,t) : a(A,I),  poss(A,I,t), spec(I)}1 :- not genericReached(t).

%% %%%%%%%%%%%%%%%%%%%%
%% %%% Testing Part %%%
%% %%%%%%%%%%%%%%%%%%%%

%% %% Domain-independent heuristics:
%% %% Speedup 1: No "gaps" on operation steps: if no operation happens at a step for a certain spec, then no operations will happen in the future anymore. This has to be disabled if using a generation rule which only applies one operation per step in total. 
specModified(I,t) :- exec(_,I,t).
%% :- specModified(I,t), not specModified(I,T_before), T_before < t, s(T_before).

%% %% Speedup 2: Allow only a limited number on non-optimal steps. 
:- nonOptimalSteps(N,I,t), N >= 1.

%% %% Disable models where the generic space is not yet reached. The external atom query(t) is induced into the Logic Program externally in the iterationCore-py.lp main loop.
#external query1(t).
:- query1(t), notGenericReached(t).
:- query1(t), t < 4.

%% #show isOptimal/3.
%% #show nonOptimalSteps/3.
#show genericReached/1.
%% #show notGenericReached/1.
#show exec/3.