function [] = plotSummaryDataAllPopOTData_V2ForPaper()

dbstop if error
doPrint = 1;

PopulationDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/MLD-AllData/';

figSavePath = ['/media/dlc/Data8TB/TUM/OT/OTProject/MLD/Figs/MLDRastersEpsc/'];

search_file = ['N*'];
dir_files = dir(fullfile(PopulationDir, search_file));
nDirs = numel(dir_files);

allDirNames = cell(1, nDirs);
for j = 1:nDirs
    allDirNames{j} = dir_files(j).name;
end
thisset = [35 36];

for k = thisset
    
    figH = figure(100);clf
    pause(.1)
    
    d = load([PopulationDir allDirNames{k}]);
    OBJ = d.OBJ;
    
    %     isHRTF = isfield(OBJ, 'HRTF');
    %     isIID = isfield(OBJ, 'IID');
    %     isITD = isfield(OBJ, 'ITD');
    %     isWN = isfield(OBJ, 'WN');
    
    %%
    
    if isfield(OBJ, 'HRTF');
        combinedSPKS = OBJ.HRTF.combinedSPKS;
        stimNames = OBJ.HRTF.stimNames;
        stimInfo = OBJ.HRTF.stimInfo;
        
        plotRasterHRTF(combinedSPKS, stimNames, stimInfo, allDirNames{k})
        
    end
    
    if isfield(OBJ, 'IID');
        combinedSPKS  = OBJ.IID.combinedSPKS;
        stimNames  = OBJ.IID.stimNames;
        stimInfo = OBJ.IID.stimInfo;
        
        plotRasterIID(1, combinedSPKS, stimNames, stimInfo, allDirNames{k})
        
    end
    
    
    if isfield(OBJ, 'ITD')
        combinedSPKS = OBJ.ITD.combinedSPKS;
        stimNames = OBJ.ITD.stimNames;
        stimInfo = OBJ.ITD.stimInfo;
        
        plotRasterIID(2, combinedSPKS, stimNames, stimInfo, allDirNames{k})
    end
    
%     if isfield(OBJ, 'WN')
%         combinedSPKS= OBJ.WN.combinedSPKS;
%         stimNames= OBJ.WN.stimNames;
%         stimInfo = OBJ.WN.stimInfo;
%         
%         plotRasterWN(combinedSPKS, stimNames, stimInfo, allDirNames{k})
%         
%     end
    
    BIRDINFO = OBJ.BIRDINFO;
    
    %%
    
    saveName = [figSavePath allDirNames{k}(1:4)];
    if doPrint
        disp('Printing Plot')
        set(0, 'CurrentFigure', figH)
        
        plotpos = [0 0 7 20];
        tic
       % print_in_A4(0, saveName , '-djpeg', 0, plotpos);
        print_in_A4(0, saveName , '-depsc', 0, plotpos);
        toc
    end
    
    disp('Clearing vars...')
    clear('d')
    clear('OBJ')
    
end

end


function [] = plotRasterHRTF(dataSet, stimNames, stimInfo, dirName)


% pos = [.05 .7 .4 .25];
% axes('position',pos );cla

subplot(3, 1, 1)

blueCol = [0.2 0.7 0.8];

n_elev = 13;
n_azim = 33;

scanrate = stimInfo.Fs;
cnt = 1;

%sortedData = dataSet.C_OBJ.S_SPKS.SORT.allSpksMatrix;
%sortedDataNames = dataSet.C_OBJ.S_SPKS.SORT.allSpksStimNames;

nReps = numel(dataSet{1,1});
%repsToPlot = 1:nReps;

repsToPlot = 1:2;
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
            line([0 0.3*scanrate], [cnt cnt], 'color', blueCol)
            %text(-20, cnt-30, (sortedDataNames{elev, azim}(4:10)))
        end
    end
end

axis tight
xlim([0 0.3*scanrate])

xtick_ms = 0:0.1:0.3;

xtick_samp = xtick_ms*scanrate;
set(gca, 'xtick', xtick_samp)
xticklabs = {'0', '100', '200', '300'};
set(gca,'xticklabel', xticklabs)

%set(gca,'ytick',[])
%set(gca,'xtick',[])

title (['HRTF | ' dirName(1:4)])
ylabel('Reps | Azimuth')


%% PSTH
% 
% pos = [.05 .55 .4 .12];
% axes('position',pos );cla
% 
% smoothiWin = round(stimInfo.Fs*.005);% 5 ms
% FRsmoothed = smooth(allSpksFR, smoothiWin)/stimInfo.nStims;
% timepoints = 1:1:numel(FRsmoothed);
% timepoints_ms = timepoints/stimInfo.Fs*1000;
% 
% 
% plot(timepoints_ms, FRsmoothed, 'color', 'k', 'LineWidth', 1)
% axis tight
% yss = ylim;
% %xlim([0 stimInfo.epochLength_samps])
% 
% area([stimInfo.stimStart_samp/stimInfo.Fs*1000  stimInfo.stimStop_samp/stimInfo.Fs*1000], [yss(2)  yss(2)], 'FaceColor', blueCol, 'EdgeColor', blueCol)
% hold on
% plot(timepoints_ms, FRsmoothed, 'color', 'k', 'LineWidth', 1)
% 
% ylim([yss])
% xlabel('Time [ms]')
% ylabel('FR [Hz]')

end


function [] = plotRasterWN(dataSet, stimNames, stimInfo, dirName)

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



function [] = plotRasterIID(IID_ITD_switch, dataSet, stimNames, stimInfo, dirName)

switch IID_ITD_switch
    
    case 1
        
        titlePart = 'IID';
        subplot(3, 1, 2)
        %pos2 = [.05 .05 .2 .4];
        %pos1 = [.25 .05 .2 .4];
        areaLim = 0.1;
        offsetCnt = .0075;
        stimSet = [2 3 4 5 6 7 8 9 10 11 12];
        %stimSet = [1 2 3 4 5 6 7 8 9 10 11];
    case 2
        subplot(3, 1, 3)
        titlePart = 'ITD';
        %pos2 = [.55 .05 .2 .4];
        %pos1 = [.75 .05 .2 .4];
        areaLim = 0.19;
        offsetCnt = .0076;
       stimSet = [ 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21];
        %stimSet = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17];
         
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
%for j = 1:nStimTypes
for j = stimSet
    nTheseReps = numel(allSpksMatrix{j});
    
    if nTheseReps > 15
        nTheseReps = 25;
        nRepsInStim = 25;
    end
    
     for k = 1: nTheseReps   
        conCatAll{cnt} = allSpksMatrix{1,j}{1,k};
         allnames{cnt} = stimNames{1,j};
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
%axes('position',pos1); cla
cnt = 1;
for s = 1 : nAllReps
    
    these_spks_on_chan = conCatAll{s};
    ypoints = ones(numel(these_spks_on_chan))*cnt;
    hold on
    
    plot(these_spks_on_chan, ypoints, 'k.', 'linestyle', 'none', 'MarkerFaceColor','k','MarkerEdgeColor','k')
    cnt = cnt +1;
    
    if mod(s, nRepsInStim) == 0
        line([0 epochLength_samps], [cnt cnt], 'color', blueCol)
    end
    
end

scanrate = stimInfo.Fs;
axis tight
xlim([0 0.3*scanrate])

xtick_ms = 0:0.1:0.3;

xtick_samp = xtick_ms*scanrate;
set(gca, 'xtick', xtick_samp)
xticklabs = {'0', '100', '200', '300'};
set(gca,'xticklabel', xticklabs)

ylabel('Reps')
ylim([0 nAllReps])
%% Firing Rate
% 
% axes('position',pos2); cla
% smoothiWin = round(stimInfo.Fs*.005);% 5 ms
% 
% offset = 0;
% 
% area([stimStart_samp/stimInfo.Fs*1000  stimStop_samp/stimInfo.Fs*1000], [areaLim areaLim], 'FaceColor', blueCol, 'EdgeColor', blueCol)
% 
% 
% for p = 1:numel(allFR)
%     
%     thisFR = allFR{p};
%     
%     thisText = stimNames{p};
%     
%     FRsmoothed = smooth(thisFR, smoothiWin, 'lowess')/nRepsInStim;
%     timepoints = 1:1:numel(FRsmoothed);
%     timepoints_ms = timepoints/stimInfo.Fs*1000;
%     
%     hold on
%     plot(timepoints_ms, FRsmoothed+offset, 'color', repCols{p}, 'LineWidth', 1)
%     text(-50, [offset], thisText);
%     offset = offset + offsetCnt;
%     set(gca,'ytick',[])
% end
% yss = ylim;
% axis tight
% %xlim([0 stimInfo.epochLength_samps])
% title ([titlePart ' | ' dirName(1:4)])
% xlabel('Time [ms]')
% %ylabel('FR [Hz]')


end



