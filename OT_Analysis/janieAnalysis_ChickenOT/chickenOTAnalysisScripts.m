% Chicken OT Analysis Scripts

%% Database

clear all
dbstop if error
close all

%%
%[OT_DB] = OT_database();

%% Create Chicken Analysis Object

experiment = 1;
recSession = 12;

C_OBJ = chicken_OT_analysis_OBJ(experiment, recSession);

%%
audSelInd = 6; % This is the index, not the stim number!!!

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

%% Plot the results

nReps = 300;
C_OBJ = plotEpochs(C_OBJ, nReps);

%% Load Saved Spikes to Object

%[spikes, SpkThresh] =  loadSpikes(C_OBJ);

%% Define spike threhsold and save Figure

SpkThresh = 0.4;
%SpkThresh = -0.2;
%setThreshAndPrintFig(C_OBJ, SpkThresh)

%% Run Spike Sort

clear('spikes')
spikes = ss_default_params(C_OBJ.Fs, 'thresh', SpkThresh );
spikes = ss_detect(C_OBJ.O_STIMS.allEpochData, spikes);

%spikes = ss_align(spikes);
spikes = ss_kmeans(spikes);
spikes = ss_energy(spikes);
spikes = ss_aggregate(spikes);

%% Split Merge

splitmerge_tool(spikes)

%% Print Spike Cluster


%% Outlier
outlier_tool(spikes)

%% Save Spikes

spkSaveName = [C_OBJ.PATHS.spkSavePath 'AllSpks.mat'];
save(spkSaveName, 'spikes', 'SpkThresh')
disp(['Saved: '  spkSaveName])

%% Define Cluster of Interest

clustOfInterest = 1; 
nSpikesInCluster = numel(find(spikes.assigns == clustOfInterest));
disp(['nSpikes = ' num2str(nSpikesInCluster)]);
    
%% Print spike waveforms

FinalSavePath = [C_OBJ.PATHS.spkSavePath 'C' num2str(clustOfInterest)];

figH2 = figure(102);
plot_waveforms(spikes, clustOfInterest);


%%
figure(figH2)
ylim([-1 1])

disp('Printing Plot')
set(0, 'CurrentFigure', figH2)

FigSaveName = [FinalSavePath '_ClustWaveforms-' num2str(clustOfInterest)];
dropBoxSavePath = [C_OBJ.PATHS.dropboxPath C_OBJ.RS_INFO.expTextLabel '__' C_OBJ.PATHS.audStimDir '_ClustWaveforms-' num2str(clustOfInterest)];
            
plotpos = [0 0 15 10];
%print_in_A4(0, FigSaveName, export_to, 0, plotpos);
print_in_A4(0, FigSaveName, '-depsc', 0, plotpos);
print_in_A4(0, FigSaveName, '-djpeg', 0, plotpos);
%print_in_A4(0, dropBoxSavePath, '-depsc', 0, plotpos);

%% Add spikes to object

C_OBJ = addSpikesToObject(C_OBJ, spikes, clustOfInterest);

%% Sort all Spikes to the stims | S_SPKS

C_OBJ = sortSpikesToStims(C_OBJ);

%% Save Object (without graphisc handle)

cobjSaveName = [C_OBJ.PATHS.spkSavePath 'C_OBJ.mat'];
save(cobjSaveName , 'C_OBJ', '-v7.3')
disp(['Saved: '  cobjSaveName])

%% Define Analysis Window

[C_OBJ] = defineAnalysisWindow(C_OBJ);

%% WN with raster, psth and z score
printRaster_WN_Ver2(C_OBJ)

%%

printRaster_IID_Ver1(C_OBJ, 1) % IID
printRaster_IID_Ver1(C_OBJ, 2) % ITD

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



