%% Preview Data

dbstop if error

% Code dependencies
pathToCodeRepository = 'C:\Users\Administrator\Documents\code\GitHub\code2018\';
pathToOpenEphysAnalysisTools = 'C:\Users\Administrator\Documents\code\GitHub\analysis-tools\';
%pathToNSKToolbox = 'C:\Users\Administrator\Documents\code\GitHub\code2018\NSKToolBox\';
pathToNSKToolbox = 'C:\Users\Janie\Documents\GitHub\NeuralElectrophysilogyTools\';

addpath(genpath(pathToCodeRepository)) 
addpath(genpath(pathToOpenEphysAnalysisTools)) 
addpath(genpath(pathToNSKToolbox)) 

%%

dataDir = 'E:\ZF-59-15\20190428\20-20-36\Ephys';

%%
dataRecordingObj = OERecordingMF(dataDir);
dataRecordingObj = getFileIdentifiers(dataRecordingObj); % creates dataRecordingObject
%%
timeSeriesViewer(dataRecordingObj); % loads all the channels
%5, 4, 6, 3, 9, 16, 8, 1, 11, 14, 12, 13, 10, 15, 7, 2

%7 10 2 15 3 14 4 13 1 16 5 12 6 11 8 9 %chonic
%14 13 1 16 5 12 6 11 8 9 %chonic
%5, 4, 6, 3, 9, 16, 8, 1, 11, 14, 12, 13, 10, 15, 7, 2 %acute
%LFP scale = 500
%Spike scale = 150
%timeWin = 40000