function [] = makeObjFileCombinedCObjFiles()

dbstop if error
close all

DataType = 1; % HRTF
%DataType = 2; % WN


dataDir1 = '/media/dlc/Data8TB/TUM/OT/OTData/Results/_data_20171212/01-HRTF_20171212_194136_0001/__Spikes/C_OBJ.mat';
dataDir2 = '/media/dlc/Data8TB/TUM/OT/OTData/Results/_data_20171212/01-HRTF_20171212_203543_0001/__Spikes/C_OBJ.mat';

dbstop if error

experiment = 3; %efc
recSession = 6; %sc

%audSelInd_1 = 2; % This is the index, not the stim number!!!
%audSelInd_2 = 6; % This is the index, not the stim number!!!

expTxt = ['--E' num2str(experiment) '-Rs' num2str(recSession)];

%%
%[OT_DB] = OT_database();

%% Create Chicken Analysis Object

%C_OBJ = chicken_OT_analysis_OBJ(experiment, recSession);

%% %% Stimulus Protocol
% Stim Protocol: (1) HRTF; (2) Tuning; (3) IID; (4) ITD; (5) WN

%selection = C_OBJ.RS_INFO.ResultDirName{audSelInd_1};

%textSearch1 = selection;

%FileObj1 = dir(fullfile(DataToUseDir,['*' textSearch1  '*']));

disp('Loading Saved Object...')
dataSet1 = load(dataDir1);

%% %% Stimulus Protocol
% Stim Protocol: (1) HRTF; (2) Tuning; (3) IID; (4) ITD; (5) WN

%selection = C_OBJ.RS_INFO.ResultDirName{audSelInd_2};

%textSearch2 = selection;

%FileObj2 = dir(fullfile(DataToUseDir,['*' textSearch2  '*']));

disp('Loading Saved Object...')
dataSet2 = load(dataDir2);


%% COmpare spike wabveforms - make sure UMS2K is added to path

figH = figure(592); clf

D1_spikes = dataSet1.C_OBJ.SPKS.spikes;
D1_clustOfInterest = dataSet1.C_OBJ.SPKS.clustOfInterest;

D1_assigns = D1_spikes.assigns;
D1_inds = find(D1_assigns == D1_clustOfInterest);
D1_waveforms = D1_spikes.waveforms;
D1_waveformsOfInterest = D1_spikes.waveforms(D1_inds,:);

D1_MeanWaveform = nanmean(D1_waveformsOfInterest, 1);
axis tight
timepoints = 1:1:size(D1_MeanWaveform, 2);
timepoints_ms = (timepoints/D1_spikes.params.Fs)*1000;
subplot(2, 2, 1)
plot(timepoints_ms, D1_waveformsOfInterest', 'b')
hold on
plot(timepoints_ms, D1_MeanWaveform', 'k', 'linewidth', 2)
axis tight
ylim([-1 1])
title('Dataset 1')
xlabel('Time [ms]')

D2_spikes = dataSet2.C_OBJ.SPKS.spikes;
D2_clustOfInterest = dataSet2.C_OBJ.SPKS.clustOfInterest ;

D2_assigns = D2_spikes.assigns;
D2_inds = find(D2_assigns == D2_clustOfInterest);
D2_waveforms = D2_spikes.waveforms;
D2_waveformsOfInterest = D2_spikes.waveforms(D2_inds,:);

D2_MeanWaveform = nanmean(D2_waveformsOfInterest, 1);
subplot(2, 2, 3)
plot(timepoints_ms, D2_waveformsOfInterest', 'b')
hold on
plot(timepoints_ms, D2_MeanWaveform', 'k', 'linewidth', 2)
axis tight
ylim([-1 1])
title('Dataset 1')
xlabel('Time [ms]')
subplot(2, 2, [2 4])
hold on

plot(timepoints_ms, D1_waveformsOfInterest', 'k')
hold on
plot(timepoints_ms, D2_waveformsOfInterest', 'k')

plot(timepoints_ms, D1_MeanWaveform', 'b', 'linewidth', 2)
plot(timepoints_ms, D2_MeanWaveform', 'r', 'linewidth', 2)
axis tight
ylim([-1 1])
xlabel('Time [ms]')
%plot_waveforms(D2_spikes, D2_clustOfInterest);

annotation(figH,'textbox',...
    [0.05 0.9 0.50 0.1],...
    'String',{dataSet1.C_OBJ.PATHS.audStimDir expTxt},...
    'LineStyle','none',...
    'FitBoxToText','off');

%%
disp('Printing Plot')
set(0, 'CurrentFigure', figH)
plotpos = [0 0 20 15];
FigSavePath = ['/media/dlc/Data8TB/TUM/OT/OTProject/FinalPopulation_Janie-Feb2020/N027_C3/' dataSet1.C_OBJ.PATHS.audStimDir expTxt 'Spikes'];
print_in_A4(0, FigSavePath, '-djpeg', 0, plotpos);
disp(['Saved Figure: '  FigSavePath ])

%% Making Rasters

allFR = [];
for q = 1:2
    
    thisObj = [];
    if q == 1
        thisObj= dataSet1.C_OBJ;
    elseif q == 2
        thisObj= dataSet2.C_OBJ;
    end
    
    data = thisObj.S_SPKS.SORT.AllStimResponses_Spk_s;
    nStims = thisObj.S_SPKS.INFO.nStims;
    nReps = thisObj.S_SPKS.INFO.nReps;
    
    
    range = 0:300;
    cnt = 1;
    Twin_s = 0.3;
    
    FR_spks = [];
    for j = 1:nStims
        for k = 1:nReps
            
            spks = (data{1, j}{1,k})*1000;
            
            %these_spks_on_chan = spks(spks >= reshapedOnsets(p) & spks <= reshapedOffsets(p))-reshapedOnsets(p);
            
            %FRs(k) = numel(spks(spks >= range (1) & spks <= range (end)));
            
            FR_spks(cnt) = (numel(spks(spks >= range (1) & spks <= range (end))))/Twin_s;
            
            cnt = cnt+1;
            disp('')
        end
        
    end
    
    allFR{q} = FR_spks;
    
end

[p,h] = ranksum(allFR{1},allFR{2});

sigText = ['p = ' num2str(p) ', h = ' num2str(h)];


figH = figure (201); clf

%% HRTFs

if DataType == 1
    
    plotRasterHRTF(dataSet1, 1) % this is for HRTFs
    annotation(figH,'textbox',...
        [0.05 0.9 0.50 0.1],...
        'String',{sigText},...
        'LineStyle','none',...
        'FitBoxToText','off');
    
    plotRasterHRTF(dataSet2, 2)
    
elseif DataType ==2
    plotRasterWN(dataSet1, 1) % this is for WN
    
    annotation(figH,'textbox',...
        [0.05 0.9 0.50 0.1],...
        'String',{sigText},...
        'LineStyle','none',...
        'FitBoxToText','off');
    
    plotRasterWN(dataSet2, 2)
    
    
end
%% Combining spikes

sortedSpikes1 = dataSet1.C_OBJ.S_SPKS.SORT.allSpksMatrix;
sortedSpikes2 = dataSet2.C_OBJ.S_SPKS.SORT.allSpksMatrix;

combinedSPKS = [];
for k = 1: size(sortedSpikes1, 1)
    for j = 1: size(sortedSpikes1, 2)
        combinedSPKS{k, j} = [sortedSpikes1{k, j} sortedSpikes2{k, j}];
    end
end

TAGEND = '-Combined';
OBJS.dataSet1 = dataSet1;
OBJS.dataSet2 = dataSet2;

disp('Data combined')

savePath = [['/media/dlc/Data8TB/TUM/OT/OTAnalysis/CombinedHRTFDataSets_JanieFeb/'] dataSet1.C_OBJ.PATHS.audStimDir expTxt TAGEND];

disp('Saving Objects...')
tic
save(savePath, 'OBJS', 'combinedSPKS', '-v7.3')
toc
disp(['Saved: '  savePath])

disp('Printing Plot')
set(0, 'CurrentFigure', figH)
plotpos = [0 0 20 15];
FigSavePath = ['/media/dlc/Data8TB/TUM/OT/OTProject/FinalPopulation_Janie-Feb2020/N027_C3/' dataSet1.C_OBJ.PATHS.audStimDir expTxt TAGEND];
print_in_A4(0, FigSavePath, '-djpeg', 0, plotpos);
disp(['Saved Figure: '  FigSavePath ])

%%


%% Print Figure


%%
end


function [] = plotRasterHRTF(dataSet, plotnum)

subplot(2, 1, plotnum)
blueCol = [0.2 0.7 0.8];

n_elev = 13;
n_azim = 33;

scanrate = dataSet.C_OBJ.Fs;
cnt = 1;

sortedData = dataSet.C_OBJ.S_SPKS.SORT.allSpksMatrix;
sortedDataNames = dataSet.C_OBJ.S_SPKS.SORT.allSpksStimNames;

nReps = dataSet.C_OBJ.S_SPKS.INFO.nReps;
repsToPlot = 1:nReps;

for azim = 1:n_azim
    for elev = 1:n_elev
        
        for k = repsToPlot
            
            %must subtract start_stim to arrange spikes relative to onset
            theseSpks_ms = (sortedData{elev, azim}{1,k}) /scanrate *1000;
            ypoints = ones(numel(theseSpks_ms))*cnt;
            hold on
            plot(theseSpks_ms, ypoints, 'k.', 'linestyle', 'none', 'MarkerFaceColor','k','MarkerEdgeColor','k')
            
            cnt = cnt +1;
            
        end
        if elev == n_elev
            line([0 300], [cnt cnt], 'color', blueCol)
            %text(-20, cnt-30, (sortedDataNames{elev, azim}(4:10)))
        end
    end
end
set(gca,'ytick',[])

title (dataSet.C_OBJ.PATHS.audStimDir)
%xlabel('Time [ms]')
ylabel('Reps | Azimuth')
axis tight

end


function [] = plotRasterWN(dataSet, plotnum)


allSpksMatrix = dataSet.C_OBJ.S_SPKS.SORT.allSpksMatrix;
blueCol = [0.2 0.7 0.8];
scanrate = dataSet.C_OBJ.Fs;
subplot(2, 1, plotnum)
nStimTypes = numel(allSpksMatrix);
cnt =1;

for j = 1 : nStimTypes
    nTheseReps = numel(allSpksMatrix{j});
    for k = 1: nTheseReps
        
        %must subtract start_stim to arrange spikes relative to onset
        spks = allSpksMatrix{1,j}{1,k} /scanrate *1000;
        %theseSpks_ms = spks /scanrate *1000;
        ypoints = ones(numel(spks))*cnt;
        hold on
        plot(spks, ypoints, 'k.', 'linestyle', 'none', 'MarkerFaceColor','k','MarkerEdgeColor','k')
        
        cnt = cnt +1;
        
        if k == nTheseReps
            line([0 300], [cnt cnt], 'color', blueCol)
            %text(-20, cnt-30, (sortedDataNames{elev, azim}(4:10)))
        end
    end
    
    
end
set(gca,'ytick',[])

title (dataSet.C_OBJ.PATHS.audStimDir)
%xlabel('Time [ms]')
ylabel('Reps | WN')
axis tight

end
