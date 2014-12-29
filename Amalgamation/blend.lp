%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This is the LP implementation of the blending part of the amalgamation module    %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%
%%% Defining Part %%%
%%%%%%%%%%%%%%%%%%%%%

%% %%% The base program is iteration independent. These are just some auxiliary predicates.
#program base2. 
#const minGenSteps = 1.
%% notConsistentReached(0..minGenSteps-1).
%% #show notConsistentReached/1.

%% %%% Declare atomic generalization operations. (Sorts are automatically removed if there is no operator or predicate left that utilizes the sort. Therefore there is no explicit operation to remove sorts.)
%% a(rmOp(OP),I) :- removable(I,OP).
%% a(rmPred(PRED),I) :- removable(I,PRED).
%% a(rmAxDirectly(Ax),I) :- removable(I,Ax).


%% %%% Define steps
#program cumulative2(t).
bs(t).


%% %%%%%%%%%%%%%%%%%%%%%%%
%% %%% Generating Part %%%
%% %%%%%%%%%%%%%%%%%%%%%%%

%% To keep things simple we concentrate on two input spaces to be blended first. We extend this later to an arbitrary number of input spaces.
%% colimit(I1,T1,I2,T2,t) :- specModified(I1,T1+1), specModified(I2,T2+1), T1 + T2 = t, I1 > I2.
1{colimit(I1,T1,I2,T2,t) : specModified(I1,T1+1), specModified(I2,T2+1), T1 + T2 = t, I1 > I2}1.
%% #show colimit/5.


%% %%%%%%%%%%%%%%%%%%%%%%%
%% %%% Computing Part %%%
%% %%%%%%%%%%%%%%%%%%%%%%%
%% Get value of colimit
colimitVal(I1,T1,I2,T2,V,t) :- colimit(I1,T1,I2,T2,t), V = @getColimitVal(I1,T1,I2,T2).

#show colimitVal/6.

%% %%%%%%%%%%%%%%%%%%%%
%% %%% Testing Part %%%
%% %%%%%%%%%%%%%%%%%%%%

%% %% Disable models where the generic space is not yet reached. The external atom query(t) is induced into the Logic Program externally in the iterationCore-py.lp main loop.
#external query2(t).
:- t < minGenSteps, query2(t).

%% #show exec/3.
%% %% #show s/1.