
function [] = collateAllResponsesForNeurons()

experiment = 1; %efc
recSession = 2; %sc

C_OBJ = chicken_OT_analysis_OBJ(experiment, recSession);

% %% Stimulus Protocol
% Stim Protocol: (1) HRTF; (2) Tuning; (3) IID; (4) ITD; (5) WN

audSelInd = 1; % This is the index, not the stim number!!!

selection = C_OBJ.RS_INFO.ResultDirName{audSelInd};
disp(selection)


%%














end
