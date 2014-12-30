%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This is the LP implementation of the blending part of the amalgamation module    %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%
%%% Defining Part %%%
%%%%%%%%%%%%%%%%%%%%%
#program base.
#const minGenSteps = 0.
% Determine the point where generalizations are found:
#program cumulative1(t).
%% notGenericReached(T)
bs(t).

blendNumGeneralizations(N,t) :- genericReachedAt(GR,t), N = t-GR.
#show blendNumGeneralizations/2.

%% %%%%%%%%%%%%%%%%%%%%%%%
%% %%% Generating Part %%%
%% %%%%%%%%%%%%%%%%%%%%%%%

%% To keep things simple we concentrate on two input spaces to be blended first. We extend this later to an arbitrary number of input spaces.
%% colimit(I1,T1,I2,T2,t) :- specModified(I1,T1+1), specModified(I2,T2+1), T1 + T2 = N, I1 > I2, blendNumGeneralizations(N,t).
1{colimit(I1,T1,I2,T2,t) : specModified(I1,T1+1), specModified(I2,T2+1), T1 + T2 = N, I1 > I2}1 :-  blendNumGeneralizations(N,t).
%% 1{colimit(I1,T1,I2,T2,t) : specModified(I1,T1+1), specModified(I2,T2+1), T1 + T2 = 1, I1 > I2}1.% :- blendNumGeneralizations(N,t).
#show colimit/5.


%% %% %%%%%%%%%%%%%%%%%%%%%%%
%% %% %%% Computing Part %%%
%% %% %%%%%%%%%%%%%%%%%%%%%%%
%% %% Get value of colimit
%% colimitVal(I1,T1,I2,T2,V,t) :- colimit(I1,T1,I2,T2,t), V = @getColimitVal(I1,T1,I2,T2).

%% #show colimitVal/6.

%% %%%%%%%%%%%%%%%%%%%%
%% %%% Testing Part %%%
%% %%%%%%%%%%%%%%%%%%%%

%% %% Disable models where the generic space is not yet reached. The external atom query(t) is induced into the Logic Program externally in the iterationCore-py.lp main loop.
#external query1(t).
:- N < minGenSteps, blendNumGeneralizations(N,t), query1(t).

%% #show exec/3.
%% %% #show s/1.