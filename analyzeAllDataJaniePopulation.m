function [] = analyzeAllDataJaniePopulation()


dbstop if error
doPrint = 1;

PopulationDir = '/home/janie/LRZ Sync+Share/OT_Project/AllData/';
dirD = '/';

figSavePath = ['/home/janie/LRZ Sync+Share/OT_Project/AllData/Figs/'];

search_file = ['N*'];
dir_files = dir(fullfile(PopulationDir, search_file));
nDirs = numel(dir_files);

allDirNames = cell(1, nDirs);
for j = 1:nDirs
    allDirNames{j} = dir_files(j).name;
end

for k = 1:nDirs
    
    d = load([PopulationDir allDirNames{k}]);
    OBJ = d.OBJ;
    
    fieldNames = fieldnames(OBJ);
    
    nFields = numel(fieldNames);
    
    
    for j = 1:nFields
        
        thisField = fieldNames{j};
        
        switch thisField
            
            case 'WN'
                
                combinedSPKS = OBJ.WN.combinedSPKS;
                stimNames = OBJ.WN.stimNames;
                stimInfo = OBJ.WN.stimInfo;
                
                WN_FRsmoothed = plotRasterWN(combinedSPKS, stimNames, stimInfo, allDirNames{k});
                
            case 'IID'
                
                combinedSPKS = OBJ.IID.combinedSPKS;
                stimNames = OBJ.IID.stimNames;
                stimInfo = OBJ.IID.stimInfo;
                
                IID_FRsmoothed  = plotRasterIID(1, combinedSPKS, stimNames, stimInfo, allDirNames{k});
                
            case 'ITD'
                
                combinedSPKS = OBJ.ITD.combinedSPKS;
                stimNames = OBJ.ITD.stimNames;
                stimInfo = OBJ.ITD.stimInfo;
                
                ITD_FRsmoothed  = plotRasterIID(2, combinedSPKS, stimNames, stimInfo, allDirNames{k});
                
            case 'HRTF'
                
                combinedSPKS = OBJ.HRTF.combinedSPKS;
                stimNames = OBJ.HRTF.stimNames;
                stimInfo = OBJ.HRTF.stimInfo;
                
                HRTF_FRsmoothed = plotRasterHRTF(combinedSPKS, stimNames, stimInfo, allDirNames{k});
                
        end
        
        
        
        
        
        
         AzContra = [1:16]; % 33 total, 17 is 0;
    AzIpsi = [18:33]; % 33 total, 17 is 0;
    ELTop = [1:6]; % 13 total, 7 is 0;
    ELDown = [7:13]; % 13 total, 7 is 0;
    
    D.INFO.AzContra{s} = AzContra;
    D.INFO.AzIpsi{s} = AzIpsi;
    D.INFO.ELTop{s} = ELTop;
    D.INFO.ELDown{s} = ELDown;
    
    %this_d_prime(p, q) = 2 * (meanA - meanB) / sqrt(stdA^2 + stdB^2);
    %% Azimuth
    % During Stim Trials
    AZ_Stim_inds_contra = AZ_stimTrials(AzContra,:);
    AZ_Stim_inds_ispi = AZ_stimTrials(AzIpsi,:);
    
    AZ_Stim_inds_contra_mean = nanmean(nanmean(AZ_Stim_inds_contra));
    AZ_Stim_inds_ispi_mean = nanmean(nanmean(AZ_Stim_inds_ispi));
    
    AZ_Stim_inds_contra_std = nanstd(nanstd(AZ_Stim_inds_contra));
    AZ_Stim_inds_ispi_std = nanstd(nanstd(AZ_Stim_inds_ispi));
    
    D_Az_Stim = 2* (AZ_Stim_inds_contra_mean - AZ_Stim_inds_ispi_mean) / sqrt(AZ_Stim_inds_contra_std^2 + AZ_Stim_inds_ispi_std^2);
    
    % During Spont Trials
    AZ_Spont_inds_contra = AZ_spontTrials(AzContra,:);
    AZ_Spont_inds_ispi = AZ_spontTrials(AzIpsi,:);
    
    AZ_Spont_inds_contra_mean = nanmean(nanmean(AZ_Spont_inds_contra));
    AZ_Spont_inds_ispi_mean = nanmean(nanmean(AZ_Spont_inds_ispi));
    
    AZ_Spont_inds_contra_std = nanstd(nanstd(AZ_Spont_inds_contra));
    AZ_Spont_inds_ispi_std = nanstd(nanstd(AZ_Spont_inds_ispi));
    
    D_Az_Spont = 2* (AZ_Spont_inds_contra_mean - AZ_Spont_inds_ispi_mean) / sqrt(AZ_Spont_inds_contra_std^2 + AZ_Spont_inds_ispi_std^2);
    
    % Pooled Trials
    AZ_All_inds_contra = allSummedAz(AzContra,:);
    AZ_All_inds_ispi = allSummedAz(AzIpsi,:);
    
    AZ_All_inds_contra_mean = nanmean(nanmean(AZ_All_inds_contra));
    AZ_All_inds_ispi_mean = nanmean(nanmean(AZ_All_inds_ispi));
    
    AZ_All_inds_contra_std = nanstd(nanstd(AZ_All_inds_contra));
    AZ_All_inds_ispi_std = nanstd(nanstd(AZ_All_inds_ispi));
    
    D_Az_All = 2* (AZ_All_inds_contra_mean - AZ_All_inds_ispi_mean) / sqrt(AZ_All_inds_contra_std^2 + AZ_All_inds_ispi_std^2);
    
    %% Elevation
    
    % During Stim Trials
    EL_Stim_inds_contra = EL_stimTrials(ELTop,:);
    EL_Stim_inds_ispi = EL_stimTrials(ELDown,:);
    
    EL_Stim_inds_contra_mean = nanmean(nanmean(EL_Stim_inds_contra));
    EL_Stim_inds_ispi_mean = nanmean(nanmean(EL_Stim_inds_ispi));
    
    EL_Stim_inds_contra_std = nanstd(nanstd(EL_Stim_inds_contra));
    EL_Stim_inds_ispi_std = nanstd(nanstd(EL_Stim_inds_ispi));
    
    D_EL_Stim = 2* (EL_Stim_inds_contra_mean - EL_Stim_inds_ispi_mean) / sqrt(EL_Stim_inds_contra_std^2 + EL_Stim_inds_ispi_std^2);
    
    pooled_D_EL_Stim(s) =  D_EL_Stim;
    
    % During Spont Trials
    EL_Spont_inds_contra = EL_spontTrials(ELTop,:);
    EL_Spont_inds_ispi = EL_spontTrials(ELDown,:);
    
    EL_Spont_inds_contra_mean = nanmean(nanmean(EL_Spont_inds_contra));
    EL_Spont_inds_ispi_mean = nanmean(nanmean(EL_Spont_inds_ispi));
    
    EL_Spont_inds_contra_std = nanstd(nanstd(EL_Spont_inds_contra));
    EL_Spont_inds_ispi_std = nanstd(nanstd(EL_Spont_inds_ispi));
    
    D_EL_Spont = 2* (EL_Spont_inds_contra_mean - EL_Spont_inds_ispi_mean) / sqrt(EL_Spont_inds_contra_std^2 + EL_Spont_inds_ispi_std^2);
    
    pooled_D_EL_Spont(s) =  D_EL_Spont;
    
    % Pooled Trials
    EL_All_inds_contra = allSummedAz(ELTop,:);
    EL_All_inds_ispi = allSummedAz(ELDown,:);
    
    EL_All_inds_contra_mean = nanmean(nanmean(EL_All_inds_contra));
    EL_All_inds_ispi_mean = nanmean(nanmean(EL_All_inds_ispi));
    
    EL_All_inds_contra_std = nanstd(nanstd(EL_All_inds_contra));
    EL_All_inds_ispi_std = nanstd(nanstd(EL_All_inds_ispi));
    
    D_EL_All = 2* (EL_All_inds_contra_mean - EL_All_inds_ispi_mean) / sqrt(EL_All_inds_contra_std^2 + EL_All_inds_ispi_std^2);
    
    pooled_D_EL_All(s) =  D_EL_All;
    
    D.DATA.pooled_D_EL_Stim{s} = pooled_D_EL_Stim;
    D.DATA.pooled_D_EL_Spont{s} = pooled_D_EL_Spont;
    D.DATA.pooled_D_EL_All{s} = pooled_D_EL_All;
   
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        %%
        saveName = [figSavePath allDirNames{k}(1:4)];
        if doPrint
            disp('Printing Plot')
            set(0, 'CurrentFigure', figH)
            
            plotpos = [0 0 40 20];
            tic
            print_in_A4(0, saveName , '-djpeg', 0, plotpos);
            toc
        end
        
        disp('Clearing vars...')
        clear('d')
        clear('OBJ')
        
    end
    
end
end


function [FRsmoothed] = plotRasterHRTF(dataSet, stimNames, stimInfo, dirName)


pos = [.05 .7 .4 .25];
axes('position',pos );cla

blueCol = [0.2 0.7 0.8];

n_elev = 13;
n_azim = 33;

scanrate = stimInfo.Fs;
cnt = 1;

%sortedData = dataSet.C_OBJ.S_SPKS.SORT.allSpksMatrix;
%sortedDataNames = dataSet.C_OBJ.S_SPKS.SORT.allSpksStimNames;

nReps = numel(dataSet{1,1});
repsToPlot = 1:nReps;

allSpksFR = zeros(stimInfo.epochLength_samps,1);
for azim = 1:n_azim
    for elev = 1:n_elev
        
        for k = repsToPlot
            
            %must subtract start_stim to arrange spikes relative to onset
            %theseSpks_ms = (sortedData{elev, azim}{1,k}) /scanrate *1000;
            spks = (dataSet{elev, azim}{1,k});
            ypoints = ones(numel(spks))*cnt;
            hold on
            plot(spks, ypoints, 'k.', 'linestyle', 'none', 'MarkerFaceColor','k','MarkerEdgeColor','k')
            
            cnt = cnt +1;
            
            nbr_spks = numel(spks);
            for ind = 1 : nbr_spks
                allSpksFR(spks(ind)) = allSpksFR(spks(ind)) +1;
                
            end
            
        end
        if elev == n_elev
            line([0 300], [cnt cnt], 'color', blueCol)
            %text(-20, cnt-30, (sortedDataNames{elev, azim}(4:10)))
        end
    end
end
set(gca,'ytick',[])
set(gca,'xtick',[])

title (['HRTF | ' dirName(1:4)])
ylabel('Reps | Azimuth')
axis tight
xlim([0 stimInfo.epochLength_samps])

%% PSTH

pos = [.05 .55 .4 .12];
axes('position',pos );cla

smoothiWin = round(stimInfo.Fs*.005);% 5 ms

FRsmoothed = smooth(allSpksFR, smoothiWin)/stimInfo.nStims;
timepoints = 1:1:numel(FRsmoothed);
timepoints_ms = timepoints/stimInfo.Fs*1000;


plot(timepoints_ms, FRsmoothed, 'color', 'k', 'LineWidth', 1)
axis tight
yss = ylim;
%xlim([0 stimInfo.epochLength_samps])

area([stimInfo.stimStart_samp/stimInfo.Fs*1000  stimInfo.stimStop_samp/stimInfo.Fs*1000], [yss(2)  yss(2)], 'FaceColor', blueCol, 'EdgeColor', blueCol)
hold on
plot(timepoints_ms, FRsmoothed, 'color', 'k', 'LineWidth', 1)

ylim([yss])
xlabel('Time [ms]')
ylabel('FR [Hz]')

end


function [FRsmoothed ] = plotRasterWN(dataSet, stimNames, stimInfo, dirName)

pos = [.55 .7 .4 .25];
axes('position',pos );cla


%allSpksMatrix = dataSet.C_OBJ.S_SPKS.SORT.allSpksMatrix;
blueCol = [0.2 0.6 0.8];
scanrate = stimInfo.Fs;

nStimTypes = numel(dataSet);
cnt = 1;
allSpksFR = zeros(stimInfo.epochLength_samps,1);


for j = 1 : nStimTypes
    nTheseReps = numel(dataSet{j});
    for k = 1: nTheseReps
        
        %must subtract start_stim to arrange spikes relative to onset
        %spks = dataSet{1,j}{1,k} /scanrate *1000;
        spks = dataSet{1,j}{1,k};
        %theseSpks_ms = spks /scanrate *1000;
        ypoints = ones(numel(spks))*cnt;
        hold on
        plot(spks, ypoints, 'k.', 'linestyle', 'none', 'MarkerFaceColor','k','MarkerEdgeColor','k')
        
        cnt = cnt +1;
        nbr_spks = numel(spks);
        for ind = 1 : nbr_spks
            allSpksFR(spks(ind)) = allSpksFR(spks(ind)) +1;
            
        end
        
        if k == nTheseReps
            line([0 stimInfo.epochLength_samps], [cnt cnt], 'color', blueCol)
            %text(-20, cnt-30, (sortedDataNames{elev, azim}(4:10)))
        end
    end
    
end

set(gca,'ytick',[])
set(gca,'xtick',[])

title (['WN | ' dirName(1:4)])
%xlabel('Time [ms]')
ylabel('Reps | WN')
axis tight
xlim([0 stimInfo.epochLength_samps])

%% PSTH

pos = [.55 .55 .4 .12];
axes('position',pos );cla

smoothiWin = round(stimInfo.Fs*.005);% 5 ms
FRsmoothed = smooth(allSpksFR, smoothiWin)/nTheseReps;
timepoints = 1:1:numel(FRsmoothed);
timepoints_ms = timepoints/stimInfo.Fs*1000;


plot(timepoints_ms, FRsmoothed, 'color', 'k', 'LineWidth', 1)
axis tight
yss = ylim;

area([stimInfo.stimStart_samp/stimInfo.Fs*1000  stimInfo.stimStop_samp/stimInfo.Fs*1000], [yss(2)  yss(2)], 'FaceColor', blueCol, 'EdgeColor', blueCol)
hold on
plot(timepoints_ms, FRsmoothed, 'color', 'k', 'LineWidth', 1)

ylim([yss])

%xlim([0 stimInfo.epochLength_samps])
xlabel('Time [ms]')
ylabel('FR [Hz]')


end



function [FRsmoothed ] = plotRasterIID(IID_ITD_switch, dataSet, stimNames, stimInfo, dirName)

switch IID_ITD_switch
    
    case 1
        
        titlePart = 'IID';
        
        pos2 = [.05 .05 .2 .4];
        pos1 = [.25 .05 .2 .4];
        areaLim = 0.1;
        offsetCnt = .0075;
    case 2
        titlePart = 'ITD';
        pos2 = [.55 .05 .2 .4];
        pos1 = [.75 .05 .2 .4];
        areaLim = 0.19;
        offsetCnt = .0076;
end

blueCol = [0.2 0.6 0.8];

allSpksMatrix = dataSet;
epochLength_samps = stimInfo.epochLength_samps;
stimStart_samp = stimInfo.stimStart_samp;
stimStop_samp = stimInfo.stimStop_samp;

jSColors = {[.84  .17 .05], [.36 .27 .53],   [.21 .44 .12],  [.94, .56 .078],  [.039 .3 .99],  [.22 .52 .55], [.72 .15 .25]};
repCols = repmat(jSColors, 1, 1000);
%% Concat all responses

nStimTypes = numel(allSpksMatrix);
nRepsInStim = numel(allSpksMatrix{1});

conCatAll = [];
cnt =1;
for j = 1:nStimTypes
    nTheseReps = numel(allSpksMatrix{j});
    for k = 1: nTheseReps
        conCatAll{cnt} = allSpksMatrix{1,j}{1,k};
        cnt = cnt +1;
    end
end
%%

nStimTypes = numel(allSpksMatrix);

for j = 1:nStimTypes
    theseReps = allSpksMatrix{j};
    
    thisUniqStimFR  = zeros(1,epochLength_samps); % we define a vector for integrated FR
    allSpksFR = zeros(epochLength_samps,1);
    
    for ss = 1:numel(theseReps)
        
        these_spks_on_Chan = theseReps{ss};
        nbr_spks = size(these_spks_on_Chan, 2);
        
        % add a 1 to the FR vector for every spike
        for ind = 1 : nbr_spks
            
            if these_spks_on_Chan(ind) == 0
                continue
            else
                
                thisUniqStimFR(these_spks_on_Chan(ind)) = thisUniqStimFR(these_spks_on_Chan(ind)) +1;
                allSpksFR(these_spks_on_Chan(ind)) = allSpksFR(these_spks_on_Chan(ind)) +1;
            end
        end
        
    end
    allFR{j} = thisUniqStimFR;
    allSpkFR{j} = allSpksFR;
end

%%
nAllReps = numel(conCatAll);
axes('position',pos1); cla

for s = 1 : nAllReps
    
    these_spks_on_chan = conCatAll{s};
    ypoints = ones(numel(these_spks_on_chan))*cnt;
    hold on
    
    plot(these_spks_on_chan, ypoints, 'k.', 'linestyle', 'none', 'MarkerFaceColor','k','MarkerEdgeColor','k')
    cnt = cnt +1;
    
    if mod(s, nRepsInStim) == 0
        line([0 epochLength_samps], [cnt cnt], 'color', 'k')
    end
    
end

set(gca,'ytick',[])
set(gca,'xtick',[])


ylabel('Reps')
axis tight
xlim([0 stimInfo.epochLength_samps])

%% Firing Rate

axes('position',pos2); cla
smoothiWin = round(stimInfo.Fs*.005);% 5 ms

offset = 0;

area([stimStart_samp/stimInfo.Fs*1000  stimStop_samp/stimInfo.Fs*1000], [areaLim areaLim], 'FaceColor', blueCol, 'EdgeColor', blueCol)


for p = 1:numel(allFR)
    
    thisFR = allFR{p};
    
    thisText = stimNames{p};
    
    FRsmoothed = smooth(thisFR, smoothiWin, 'lowess')/nRepsInStim;
    timepoints = 1:1:numel(FRsmoothed);
    timepoints_ms = timepoints/stimInfo.Fs*1000;
    
    hold on
    plot(timepoints_ms, FRsmoothed+offset, 'color', repCols{p}, 'LineWidth', 1)
    text(-50, [offset], thisText);
    offset = offset + offsetCnt;
    set(gca,'ytick',[])
end
yss = ylim;
axis tight
%xlim([0 stimInfo.epochLength_samps])
title ([titlePart ' | ' dirName(1:4)])
xlabel('Time [ms]')
%ylabel('FR [Hz]')


end



