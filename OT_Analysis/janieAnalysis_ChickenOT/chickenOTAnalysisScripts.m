% Chicken OT Analysis Scripts

%% Database

clear all
dbstop if error
close all

%%
%[OT_DB] = OT_database();

%% Create Chicken Analysis Object

experiment = 6; %efc
recSession = 1; %sFigSaveNamec

C_OBJ = chicken_OT_analysis_OBJ(experiment, recSession);

% %% Stimulus Protocol
% Stim Protocol: (1) HRTF; (2) Tuning; (3) IID; (4) ITD; (5) WN

audSelInd = 6; % SpikesThis is the index, spikesnot the stim number!!!

selection = C_OBJ.RS_INFO.ResultDirName{audSelInd};
disp(selection)

%% RE Loading Object 0 ONLY USE IF analyzed before!!!
%%
disp('Loading Saved Object...')

audStimDir = C_OBJ.RS_INFO.ResultDirName{audSelInd};
objFile = 'C_OBJ.mat';printRaster_IID_Ver1
objPath = [C_OBJ.PATHS.OT_Data_Path C_OBJ.INFO.expDir C_OBJ.PATHS.dirD audStimDir C_OBJ.PATHS.dirD '__Spikes' C_OBJ.PATHS.dirD objFile];
load(objPath);
disp(['Loaded: ' objPath])

%% Select Stimulus Protocol and Load data results

C_OBJ = getAudioSpikeResults(C_OBJ, audSelInd);
C_OBJ = organizeStimRepetitions(C_OBJ, audSelInd);

% Plot the results
nReps = 300;
C_OBJ = plotEpochs(C_OBJ, nReps);
set(gca, 'YMinorTick', 'on', 'YMinorGrid','on')
axis tight
%% Load Saved Spikes to Object

%[spikes, SpkThresh] =  loadSpikes(C_OBJ);

%% Define spike threhsold and save Figure

%SpkThresh = 0.4;
SpkThresh = 0.11;
%setThreshAndPrintFig(C_OBJ, SpkThresh)

% Print spikes7
ylim([-1 1])

disp('Printing Plot')
%set(0, 'CurrentFigure', figH5)

FigSaveName = [C_OBJ.PATHS.spkSavePath '_spikesResp'];
            
saveName = C_OBJ.PATHS.audStimDir;
%mediaSavePath = ['/home/janie/Data/TUM/OTAnalysis/allITDJanie/' saveName '_spikesResp'];
%mediaSavePath = ['/home/janie/Data/TUM/OTAnalysis/allWNsJanie/' saveName '_spikesResp'];
mediaSavePath = ['/home/janie/Data/TUM/OTAnalysis/allIIDJanie/' saveName '_spikesResp'];

plotpos = [0 0 15 10];
%print_in_A4(0, FigSaveName, export_to, 0, plotpos);
%print_in_A4(0, FigSaveName, '-depsc', 0, plotpos);
%print_in_A4(0, FigSaveName, '-djpeg', 0, plotpos);
print_in_A4(30, mediaSavePath, '-djpeg', 0, plotpos);

% Run Spike Sort - Make sure UMS2K 5is on the path6

clear('spikes')
spikes = ss_default_params(C_OBJ.Fs, 'thresh', SpkThresh );
spikes = ss_detect(C_OBJ.O_STIMS.allEpochData, spikes);

%spikes = ss_align(spikes);3
spikes = ss_kmeans(spikes);
spikes = ss_energy(spikes);
spikes = ss_aggregate(spikes);

%% Split Merge

splitmerge_tool(spikes)

%% Print Spike Cluster5


%% Outlier
outlier_tool(spikes)

%% Define Cluster of Interest

clustOfInterest = 11; 
nSpikesInCluster = numel(find(spikes.assigns == clustOfInterest));
disp(['nSpikes = ' num2str(nSpikesInCluster)]);

% Save Spikes

%C_OBJ.PATHS.spkSavePath = '/media/janie/Data64GB/OTData/OT/Results/_data_20171213/01-HRTF_20171213_132824_0001/__Spikes/';

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
%objSaveName = ['/home/janie/Data/TUM/OTAnalysis/allWNsJanie/allObjs/' C_OBJ.PATHS.audStimDir '_C_OBJ.mat']; 
objSaveName = ['/home/janie/Data/TUM/OTAnalysis/allIIDJanie/allObjs/' C_OBJ.PATHS.audStimDir '_C_OBJ.mat']; 

save(objSaveName , 'C_OBJ', '-v7.3')
disp(['Saved: '  objSaveName])

%
printRaster_IID_Ver1(C_OBJ, 1) % IID


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




%%



%loadAudSpikeEpochsToSpikeSort
%sortSpikesAndMakeRasters



