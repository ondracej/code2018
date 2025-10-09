%% OCtober 2020 - Final Analysis Scripts for OT Analysis


%% converting to plexon
ConvertAudioSpikeToPlexon()
PlotSpikesShapesFromPlexonFiles

%% OT Database
OT_database.m
OTDatabaseTemplate.m

%% First Analysis Pipeline

chickenOTAnalysisScripts.m
chicken_OT_analysis_OBJ.m

%%
% For plotting single HRTFs
HRTFAnalaysisAudSpikeData.m

%% For paper

plotMLDNeurons % depth of neurons
plotRawDataExample

plotSpectrogramHRTFData
makePlotHRTFEnvs

% HRTF
plotZScoresDPrimes_MLD

%WN Analysis
calcFRZScores_WN
analyzeWN_FR_responses
STA_for_WN_Stims_V2
PoolStatsOverWNSTAs
RastersForAmplitudeEnvelopWN

%% Population analaysis

runJaniesAnalysis_batchProcess_JanieFinalAnalysis 
% This plots aSRFs, azimuth / elevation d primes, matrix rasters, 
% requires a directory of mat files (usually in the 'Analysis' directory that have combined or single repetition data: 
% e.g., N-03_01-HRTF_20171214_132223_0001--E1-Rs3-Single.mat

%
wrapperForSTAAnalysis.m
%% This is what we used!

%% STA Analysis




% This calls the following programs:
%ExpInds = [3 8 10 12 13 16 17 19 21 23 25 27 28 29 31 33 34 36 37 38 39 40 41 42 43 44 45 46]; %HRTF
%AllWN_ExpInds = [3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 19 20 21 23 25 27 28 29 30 31 33 34 35 36 37 38 39 40 42 43 44 ]; %WN

% requires a directory of the unsorted original signals, e.g., SignalDir
    STA_for_HRTF_Stims
    EnvCalc_for_HRTF_Stims
    RastersForAmplitudeEnvelopHRTF
    plotNormHRTFWinSelection
    AnalysiWindowDefinition_HRTF
    STA_for_HRTF_Stims_FreqTime
    
    STRF_preprocessing_OT
    
    EnvCalc_for_WN_Stims
    STA_for_WN_Stims
    calcFRZScores_WN
    RastersForAmplitudeEnvelopWN

    doAnalysisOnIIDs
    
    doAnalysisOnITDs
    doAnalysisOnITDs_v2
    
% These programs call 
% C_OBJ = chicken_OT_analysis_OBJ(experiment, recSession);
%And so requires the following info defined in the wrapper (matches the info in the database
%NeuronName = 'N-28';
%experiment = 10; %efc
%recSession = 1; %sFigSaveName


plotSummaryDataAllPopOTData
% Runs from the 'All Data' directory and plots raster plots for all neurons
% -requires the output from combineAllDataIntoOneObj


%% Code to combine files

% To combine single WN or HRTF files, outpute required for runJaniesAnalysis_batchProcess_JanieFinalAnalysis
makeObjFileCombinedCObjFiles

% For IIT ITD analysis, outpute required for runJaniesAnalysis_batchProcess_JanieFinalAnalysis
makeObjFileSingleCObjFiles

 combineAllDataIntoOneObj
% Input:  PopulationDir = '/home/janie/Data/TUM/OTAnalysis/FinalPopulation_Janie/';
% Output: AllDataDir = '/home/janie/Data/TUM/OTAnalysis/AllData/';
% Filename:  saveName = [allDirNames{k} '-AllStims.mat'];


%%
 combineAllSPKSIntoOneObj
% Input:  PopulationDir = '/home/janie/Data/TUM/OTAnalysis/FinalPopulation_Janie/';
% Output: AllDataDir = '/home/janie/Data/TUM/OTAnalysis/AllSPKData/';
% Filename: saveName = [allDirNames{k} '-AllSPKS.mat'];

%
combineOTObjectDataSets % Old, do not use
% For combining two sets of same stimuli with user interface, also makes rasters - 
% Input:  DataToUseDir = '/home/janie/LRZ Sync+Share/OT_Analysis/OTAnalysis/allWNsJanie/allObjs/';
% Output: savePath = [[DataToUseDir 'Data/'] dataSet1.C_OBJ.PATHS.audStimDir expTxt TAGEND];

combineOTObjectDataSets_loadFromDir % used to combine WN, HRTfs
% Does the same thing but from a directory
% Input: DataToUseDir = '/home/janie/Data/OTAnalysis/allWNsJanie/allObjs/';
% Output: savePath = [[DataToUseDir 'CombinedData/'] dataSet1.C_OBJ.PATHS.audStimDir expTxt TAGEND];

combineOTObjectDataSets_singleObjects % To use for objects that are not being combined
% Input: DataToUseDir = '/home/janie/Data/TUM/OTAnalysis/allIIDJanie/allObjs/';
% Output:   savePath = ['/home/janie/Data/TUM/OTAnalysis/allIIDJanie/allObjs/UncombinedData/' dataSet1.C_OBJ.PATHS.audStimDir expTxt TAGEND];



%% Misc HRTF plotting


AnalysiWindowDefinition_HRTF

%% Other code
CalcEnvelopeWNAnalysis.m
jbfill
%UMS2K-master
specgram
getAxPos
InitMPI
InitVarsConfigClass
redblue
helperCWTTimeFreqPlot

%% Analysis of Hansa's data set

runJaniesAnalysisHansasData_batchProcess
runJaniesAnalysisHansasData_batchProcess_10msAnalysis


