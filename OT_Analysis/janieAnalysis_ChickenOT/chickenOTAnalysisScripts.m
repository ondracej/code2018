% Chicken OT Analysis Scripts

%% Database

clear all
dbstop if error
close all
   
%%
%[OT_DB] = OT_database();

%% Create Chicken Analysis Object

experiment = 1; %efc
recSession = 10; %sFigSaveNamec

C_OBJ = chicken_OT_analysis_OBJ(experiment, recSession);

%% Stimulus Protocol
% Stim Protocol: (1) HRTF; (2) Tuning; (3) IID; (4) ITD; (5) WN

audSelInd = 5; % SpikesThis is the index, spikesnot the stim number!!!
selection = C_OBJ.RS_INFO.ResultDirName{audSelInd};
disp(selection)

%% RE Loading Object 0 ONLY USE IF analyzed before!!!
%%
disp('Loading Saved Object...')

audStimDir = C_OBJ.RS_INFO.ResultDirName{audSelInd};
objFile = 'C_OBJ.mat';
objPath = [C_OBJ.PATHS.OT_Data_Path C_OBJ.INFO.expDir C_OBJ.PATHS.dirD audStimDir C_OBJ.PATHS.dirD '__Spikes' C_OBJ.PATHS.dirD objFile];
load(objPath);
disp(['Loaded: ' objPath])

%% Select Stimulus Protocol and Load data results

C_OBJ = getAudioSpikeResults(C_OBJ, audSelInd);
C_OBJ = organizeStimRepetitions(C_OBJ, audSelInd);
%%
% Plot the results
nReps = 100;
C_OBJ = plotEpochs(C_OBJ, nReps);
set(gca, 'YMinorTick', 'on', 'YMinorGrid','on')
axis tight
%% Load Saved Spikes to Object

%[spikes, SpkThresh] =  loadSpikes(C_OBJ);

%% Define spike threhsold and save Figure

%SpkThresh = 0.4;
SpkThresh = 0.12;
%setThreshAndPrintFig(C_OBJ, SpkThresh)

% Print spikes7
ylim([-1 1])

disp('Printing Plot')
%set(0, 'CurrentFigure', figH5)

FigSaveName = [C_OBJ.PATHS.spkSavePath '_spikesResp'];
            
saveName = C_OBJ.PATHS.audStimDir;
%mediaSavePath = ['/home/janie/Data/TUM/OTAnalysis/allITDJanie/' saveName '_spikesResp'];
%mediaSavePath = ['/home/janie/Data/OTAnalysis/allWNsJanie/' saveName '_spikesResp'];
mediaSavePath = ['/media/dlc/Data8TB/TUM/OT/OTProject/MLD/TuningJanie/' saveName '_spikesResp'];
%mediaSavePath = ['/home/janie/Data/TUM/OTAnalysis/allIIDJanie/' saveName '_spikesResp'];

plotpos = [0 0 15 10];
%print_in_A4(0, FigSaveName, export_to, 0, plotpos);
%print_in_A4(0, FigSaveName, '-depsc', 0, plotpos);
%print_in_A4(0, FigSaveName, '-djpeg', 0, plotpos);
print_in_A4(30, mediaSavePath, '-djpeg', 0, plotpos);

%% Run Spike Sort - Make sure UMS2K 5is on the path6

clear('spikes')
spikes = ss_default_params(C_OBJ.Fs, 'thresh', SpkThresh );
spikes = ss_detect(C_OBJ.O_STIMS.allEpochData, spikes);

%spikes = ss_align(spikes);
spikes = ss_kmeans(spikes);
spikes = ss_energy(spikes);
spikes = ss_aggregate(spikes);

%% Split Merge

splitmerge_tool(spikes)

%% Print Spike Cluster5


%% Outlier
outlier_tool(spikes)

%% Define Cluster of Interest

clustOfInterest = 8; 
nSpikesInCluster = numel(find(spikes.assigns == clustOfInterest));
disp(['nSpikes = ' num2str(nSpikesInCluster)]);

% Save Spikes

C_OBJ.PATHS.spkSavePath = '/media/dlc/Data8TB/TUM/OT/OTProject/OTData/Results/_data_20171214/02-Tuning_20171214_170403_0001/__Spikes/';

spkSaveName = [C_OBJ.PATHS.spkSavePath 'AllSpks.mat'];
save(spkSaveName, 'spikes', 'SpkThresh')
disp(['Saved: '  spkSaveName])

% Add spikes to object

C_OBJ = addSpikesToObject(C_OBJ, spikes, clustOfInterest);

% Sort all Spikes to the stims | S_SPKS

C_OBJ = sortSpikesToStims(C_OBJ);

% Save Object (without graphisc handle)

cobjSaveName = [C_OBJ.PATHS.spkSavePath 'C_OBJ.mat'];
save(cobjSaveName , 'C_OBJ', '-v7.3')
%
% To save only the object
% save to special directory

%objSaveName = ['/home/janie/Data/TUM/OTAnalysis/allITDJanie/allObjs/' C_OBJ.PATHS.audStimDir '_C_OBJ.mat']; 
%objSaveName = ['/home/janie/Data/OTAnalysis/allWNsJanie/allObjs/' C_OBJ.PATHS.audStimDir '_C_OBJ.mat']; 
objSaveName = ['/media/dlc/Data8TB/TUM/OT/OTProject/MLD/allTuningObjs/' C_OBJ.PATHS.audStimDir '_C_OBJ.mat']; 
%objSaveName = ['/home/janie/Data/TUM/OTAnalysis/allIIDJanie/allObjs/' C_OBJ.PATHS.audStimDir '_C_OBJ.mat']; 

save(objSaveName , 'C_OBJ', '-v7.3')
disp(['Saved: '  objSaveName])

%
%printRaster_IID_Ver1(C_OBJ, 1) % IID


%%
% WN with raster, psth and z score
printRaster_WN_Ver2(C_OBJ)

%% ITD
printRaster_IID_Ver1(C_OBJ, 2) % ITD

%% Print spike waveforms

FinalSavePath = [C_OBJ.PATHS.spkSavePath 'C' num2str(clustOfInterest)];

figH2 = figure(102);

plot_waveforms(spikes, clustOfInterest);

%
figure(figH2)
ylim([-1 1])

disp('Printing Plot')
set(0, 'CurrentFigure', figH2)

FigSaveName = [FinalSavePath '_ClustWaveforms-' num2str(clustOfInterest)];
%dropBoxSavePath = [C_OBJ.PATHS.dropboxPath C_OBJ.RS_INFO.expTextLabel '__' C_OBJ.PATHS.audStimDir '_ClustWaveforms-' num2str(clustOfInterest)];
            
plotpos = [0 0 15 10];
%print_in_A4(0, FigSaveName, export_to, 0, plotpos);
%print_in_A4(0, FigSaveName, '-depsc', 0, plotpos);
print_in_A4(0, FigSaveName, '-djpeg', 0, plotpos);
%print_in_A4(0, dropBoxSavePath, '-depsc', 0, plotpos);



%% Define Analysis Window - This is where we plot rasters and audspat RFs

[C_OBJ] = defineAnalysisWindow(C_OBJ);
%
[C_OBJ] = analyzeHRTFs(C_OBJ);

%%
printRaster_IID_Ver1(C_OBJ, 1) % IID


%% Make a raster Ver 1

printRasterVer1(C_OBJ)

%% Silent Raster  - for HRTF
printRasterVer1_silent(C_OBJ);

%% Make a raster for all WN + PSTH

printRaster_WN_Ver1(C_OBJ)


%% Print raster for HRTF  = per column

printRaster_HRTF_Ver2_OverAz(C_OBJ)

printRaster_HRTF_Ver2_OverEl(C_OBJ)




%% Other scripts for population analysis

 combineAllDataIntoOneObj
% Input:  PopulationDir = '/home/janie/Data/TUM/OTAnalysis/FinalPopulation_Janie/';
% Output: AllDataDir = '/home/janie/Data/TUM/OTAnalysis/AllData/';
% Filename:  saveName = [allDirNames{k} '-AllStims.mat'];

%% 
 combineAllSPKSIntoOneObj
% Input:  PopulationDir = '/home/janie/Data/TUM/OTAnalysis/FinalPopulation_Janie/';
% Output: AllDataDir = '/home/janie/Data/TUM/OTAnalysis/AllSPKData/';
% Filename: saveName = [allDirNames{k} '-AllSPKS.mat'];

%% 
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


%%

HRTFAnalaysisAudSpikeData % code for analyzing HRTFs?
runJaniesAnalysis_batchProcess_JanieFinalAnalysis % ccode for batch processinng HRTF data

%% 
plotSummaryDataAllPopOTData
%Goes over all the data and makes a single fig with raster plots of all
% available data
% Input: PopulationDir = '/home/janie/Data/TUM/OTAnalysis/AllData/';
% Output:   figSavePath = ['/home/janie/Data/TUM/OTAnalysis/AllData/Figs/'];
% saveName = [figSavePath allDirNames{k}(1:4)];







%loadAudSpikeEpochsToSpikeSort
%sortSpikesAndMakeRasters



