%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This is the LP implementation of the generalization part of the amalgamation module    %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%
%%% Defining Part %%%
%%%%%%%%%%%%%%%%%%%%%

%%% The base program is iteration independent. These are just some auxiliary predicates.
#program  base. 
pathGenCost(Spec,0,1,1) :- spec(Spec).

costNumber(0..100).
pow2(N,P) :- P = @pow(N,2), costNumber(N).

%%% Define steps
#program cumulative(t).
s(t).

%%% We have a total (or partial) priority order on predicates, operators and axioms, and generalisations should account for that order. Hence, we assign a cost to removal actions that coincides with the priority of the axiom, operator, predicate or sort to remove. This allows us to define when a generalisation action is optimal, i.e., when there is no cheaper action for which the preconditions are met.  Then we count the number of non-optimal generalisation operations as the number of operations that do not respect the priority order. This is used to prune the search space. 
isOptimal(A1,Spec,t) :- poss(A1,Spec,t), cost(A1,Spec,C1), 0{ a(A2,Spec) : poss(A2,Spec,t), cost(A2,Spec,C2), C2 < C1  }0.
nonOptimalSteps(N,Spec,t) :- spec(Spec), N = {a(A,Spec) : exec(A,Spec,T),  not isOptimal(A,Spec,T), T <= t}.

notGenericReached(t) :- spec(Spec1), spec(Spec2), notEqual(Spec1,Spec2,t), Spec1 != Spec2.
genericReached(t) :- not notGenericReached(t).

%%%%%%%%%%%%%%%%%%%%%%%
%%% Generating Part %%%
%%%%%%%%%%%%%%%%%%%%%%%

%% %% % Generate generalization search space. If the generic space is not yet reached, execute a generalization operation. 
0{exec(A,Spec,t) : a(A,Spec),  poss(A,Spec,t)}1 :- not genericReached(t), spec(Spec).
%% 0{exec(A,Spec,t) : a(A,Spec),  isOptimal(A,Spec,t)}1 :- not genericReached(t), spec(Spec).



%% %%%%%%%%%%%%%%%%%%%%
%% %%% Testing Part %%%
%% %%%%%%%%%%%%%%%%%%%%

%% If something is renamed to somehting in a specification Sepc, then Spec must not be altered. 
:- isRenamedTo(Spec,t), exec(_,Spec,t).

%% %% Domain-independent heuristics:
%% %% Speedup 1: No "gaps" on operation steps: if no operation happens at a step for a certain spec, then no operations will happen in the future anymore. This has to be disabled if using a generation rule which only applies one operation per step in total. 
%% specModified(Spec,t) :- exec(_,Spec,t).
%% :- specModified(Spec,t), not specModified(Spec,T_before), T_before < t, s(T_before), not isRenamedTo(Spec,t).

%% %% Speedup 2: Allow only a limited number on non-optimal steps. 
:- nonOptimalSteps(N,Spec,t), N > 0.

%% %% Disable models where the generic space is not yet reached. The external atom query(t) is induced into the Logic Program externally in the iterationCore-py.lp main loop.
#external query(t).
:- query(t), notGenericReached(t).
%% :- query(t), t < 4.

%%% Compute generalisation cost of individual paths and path combination. 
pathGenCost(Spec,CBefore,S,t+1) 				:- 	not exec(_,Spec,t), pathGenCost(Spec,CBefore,S,t), not genericReached(t).
pathGenCost(Spec,CBefore+CNow,S+1,t+1) 			:- 	exec(A,Spec,t), cost(A,Spec,CNow), pathGenCost(Spec,CBefore,S,t).

combinedGenCost(Spec1,S1,Spec2,S2,C,t) 	:- 	C = C1 + PC2, pow2(C2,PC2), pathGenCost(Spec1,C1,S1,T1),  pathGenCost(Spec2,C2,S2,T2), 
											genericReached(t), Spec1 != Spec2, C1 <= C2.


%% #show pathGenCost/4.
#show combinedGenCost/6.
#show s/1.

#show notGenericReached/1.
%% #show removableAx/2.
%% #show poss/3.
%% #show cost/3.
%% #show wouldBeOptimal/3.
%% #show opNotEquivalent/4.
%% notEqual(Spec1,Spec2,t) :- predNotEquivalent(Spec1,Spec2,_,t).
%% notEqual(Spec1,Spec2,t) :- sortNotEquivalent(Spec1,Spec2,_,t).
%% #show axNotEquivalent/4.
%% #show isOptimal/3.
%% #show nonOptimalSteps/3.
%% #show a/2.
%% #show notGenericReached/1.
#show exec/3.
