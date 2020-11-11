function [ITDs] = doAnalysisOnITDs_v2(experiment, recSession, NeuronName, oo, maxNum, ITDs)

if nargin <3
    
    experiment = 1;
    recSession = 3;
    NeuronName = 'N-03';
    oo =1;
end

C_OBJ = chicken_OT_analysis_OBJ(experiment, recSession);
dbstop if error

%%
allStims = C_OBJ.RS_INFO.StimProtocol_name;
tf = find(strcmpi(allStims,'ITD'));

audSelInd = tf(1); % SpikesThis is the index, spikesnot the stim number!!!
Stim = C_OBJ.RS_INFO.StimProtocol_name{audSelInd};
disp(Stim);

%audSelInd = 2; % SpikesThis is the index, spikesnot the stim number!!!

%FigSaveDir = '/media/janie/300GBPassport/OTProject/MLD/';
FigSaveDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/Figs/ITDs/ITD-Dprime/';

%% Stimulus Protocol
% Stim Protocol: (1) HRTF; (2) Tuning; (3) IID; (4) ITD; (5) WN

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

%%

%% Settings

SamplingRate = C_OBJ.SETTINGS.SampleRate;
PreStimStartTime_s = 0; % 0-100  ms
StimStartTime_s = 0.1; % 100  - 200 ms
PostStimStartTime_s = 0.2; % 200 - 300 ms
EndTime = 0.3;

PreStimStartTime_samp = PreStimStartTime_s* SamplingRate;
StimStartTime_samp = StimStartTime_s* SamplingRate;
PostStimStartTime_samp = PostStimStartTime_s* SamplingRate;
EndTime_samp = EndTime* SamplingRate;

%%
%Stims Names = R then L
RStimInds = [21 20 19 18 17 16 15 14];
LStimInds = [5 6 7 8 9 10 11 12];
EqInd = 13;

if oo ==20
    RStimInds = [17 16 15 14 13 12 11 10];
LStimInds = [1 2 3 4 5 6 7 8];
end

stimNames = C_OBJ.S_SPKS.SORT.allSpksStimNames
SpkResponses = C_OBJ.S_SPKS.SORT.allSpksMatrix;

%%
allStimSpksOverReps = [];
allMeansStimSpksOverReps = [];
allstdsStimSpksOverReps = [];
for q = 1:2
    switch q
        case 1
            thisStimSet = RStimInds;
        case 2
            thisStimSet = LStimInds;
        case 3
            thisStimSet = EqInd;
    end
    
    % Here we calculate the spks over the matched indeces for left versus
    % right loundess over the different loudness separations
    for j = 1: numel(thisStimSet)
        cnnt = 1;
        all_PreStimSpkCnts = [];
        all_StimSpkCnts = [];
        all_PostStimSpkCnts = [];
        
        thisInd = thisStimSet(j);
        
        thisSpkResp = SpkResponses{1,thisInd};
        nReps = size(thisSpkResp, 2);
        
        for o = 1:nReps
            
            thisRep = thisSpkResp{1, o};
            
            PreStimSpkCnts(o) = numel(find(thisRep > PreStimStartTime_samp & thisRep <= StimStartTime_samp));
            StimSpkCnts(o) = numel(find(thisRep > StimStartTime_samp & thisRep <= PostStimStartTime_samp));
            PostStimSpkCnts(o) = numel(find(thisRep > PostStimStartTime_samp & thisRep <= EndTime_samp));
            
            
            all_PreStimSpkCnts(cnnt) =  PreStimSpkCnts(o);
            all_StimSpkCnts(cnnt) =   StimSpkCnts(o);
            all_PostStimSpkCnts(cnnt) = PostStimSpkCnts(o);
            
            cnnt = cnnt+1;
        end
        
        [p, h] = ranksum(all_StimSpkCnts, all_PreStimSpkCnts);
        
        allPs{q, j} = p;
        allHs{q, j} = h;
        
        allStimSpksOverReps{q, j} =  all_StimSpkCnts;
        allMeansStimSpksOverReps{q, j} =  nanmean(all_StimSpkCnts);
        allstdsStimSpksOverReps{q, j} =  nanstd(all_StimSpkCnts);
        
        allStimSpksOverReps{q, j} =  all_StimSpkCnts;
        allMeansStimSpksOverReps{q, j} =  nanmean(all_StimSpkCnts);
        allstdsStimSpksOverReps{q, j} =  nanstd(all_StimSpkCnts);
        
        
    end
    
end

% here we have the d primes for the 5 different decible differents
for w = 1:8
    %D_Az_Stim = 2* (AZ_Stim_inds_contra_mean - AZ_Stim_inds_ispi_mean) / sqrt(AZ_Stim_inds_contra_std^2 + AZ_Stim_inds_ispi_std^2);
    thisDPrime = 2* (allMeansStimSpksOverReps{1,w} - allMeansStimSpksOverReps{2,w}) / sqrt(allstdsStimSpksOverReps{1,w}^2 + allstdsStimSpksOverReps{2,w}^2);
    D_Stim(w) = thisDPrime;
end

%%
figure(406); clf
xes = 1:1:8;
plot(xes, D_Stim, 'ko-', 'linewidth', 1)
hold on
line([0 9], [0 0], 'color', 'k')
xlim([0 9])
ylim([-5 2])
xticks = 1:1:8;
set(gca, 'xtick', xticks)
set(gca, 'xticklabel', {'2ms', '1.75ms', '1.5ms', '1.25ms','1ms', '0.75ms', '0.5ms', '0.25ms'})


saveName = [FigSaveDir NeuronName '-ITD-DPrime'];

plotpos = [0 0 15 12];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);
disp(saveName)
print_in_A4(0, saveName, '-depsc', 0, plotpos);


ITDs.allStimSpksOverReps{oo,:} = allStimSpksOverReps;
ITDs.allMeansStimSpksOverReps{oo,:} = allMeansStimSpksOverReps;
ITDs.allstdsStimSpksOverReps{oo,:} = allstdsStimSpksOverReps;

ITDs.allPs{oo} = allPs;
ITDs.allHs{oo} = allHs;

ITDs.D_Stim{oo} = D_Stim;

%%
if oo == maxNum
    
    
    for z = 1:23
        ITD_1(z) = ITDs.D_Stim{1,z}(1,1);
        ITD_2(z) = ITDs.D_Stim{1,z}(1,2);
        ITD_3(z) = ITDs.D_Stim{1,z}(1,3);
        ITD_4(z) = ITDs.D_Stim{1,z}(1,4);
        ITD_5(z) = ITDs.D_Stim{1,z}(1,5);
        ITD_6(z) = ITDs.D_Stim{1,z}(1,6);
        ITD_7(z) = ITDs.D_Stim{1,z}(1,7);
        ITD_8(z) = ITDs.D_Stim{1,z}(1,8);
    end
    allITDs = [ITD_1 ;ITD_2; ITD_3; ITD_4; ITD_5 ;ITD_6 ;ITD_7; ITD_8 ]; % to make left negative
      
    for i = 1:8
        for j = 1:8
    [p(i, j), h(i, j)] = ranksum(allITDs(i,:), allITDs(j,:));
        end
    end
    
        
    ITDs.ITD_1 = ITD_1;
    ITDs.ITD_2 = ITD_2;
    ITDs.ITD_3 = ITD_3;
    ITDs.ITD_4 = ITD_4;
    ITDs.ITD_5 = ITD_5;
    ITDs.ITD_6 = ITD_6;
    ITDs.ITD_7 = ITD_7;
    ITDs.ITD_8 = ITD_8;
    
    group1 = ones(1, size(ITD_1, 2))*1;
    group2 = ones(1, size(ITD_2, 2))*2;
    group3 = ones(1, size(ITD_3, 2))*3;
    group4 = ones(1, size(ITD_4, 2))*4;
    group5 = ones(1, size(ITD_5, 2))*5;
    group6 = ones(1, size(ITD_6, 2))*6;
    group7 = ones(1, size(ITD_7, 2))*7;
    group8 = ones(1, size(ITD_8, 2))*8;
    
    
    groups = [group1 group2 group3 group4 group5 group6 group7 group8];
    
    
    xes = [ITD_1 ITD_2 ITD_3 ITD_4 ITD_5 ITD_6 ITD_7 ITD_8 ]; % to make left negative
    allITDs = [ITD_1 ;ITD_2; ITD_3; ITD_4; ITD_5 ;ITD_6 ;ITD_7; ITD_8 ]; % to make left negative
    jitterAmount = 0.1;
    jitterValues1 = 2*(rand(size(ITD_1))-0.5)*jitterAmount;   % +
    jitterValues2 = 2*(rand(size(ITD_2))-0.5)*jitterAmount;   % +
    jitterValues3 = 2*(rand(size(ITD_3))-0.5)*jitterAmount;   % +
    jitterValues4 = 2*(rand(size(ITD_4))-0.5)*jitterAmount;   % +
    jitterValues5 = 2*(rand(size(ITD_5))-0.5)*jitterAmount;   % +
    jitterValues6 = 2*(rand(size(ITD_6))-0.5)*jitterAmount;   % +
    jitterValues7 = 2*(rand(size(ITD_7))-0.5)*jitterAmount;   % +
    jitterValues8 = 2*(rand(size(ITD_8))-0.5)*jitterAmount;   % +
  
    yes = [jitterValues1 jitterValues2 jitterValues3 jitterValues4 jitterValues5 jitterValues6 jitterValues7 jitterValues8];
    
    %%
    
    figure(406); clf
    cols = cell2mat({[0 0.4470 0.7410]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; [0, 0, 0]; [0.4940, 0.1840, 0.5560]; [0.4660 0.6740 0.1880]; [0.3010 0.7450 0.9330]; [0.6350 0.0780 0.1840]});
    
    h = scatterhist(xes,yes,'Group',groups,'Kernel','on', 'Location','NorthEast',...
        'Direction','out', 'LineStyle',{'-','-'}, 'Marker','..', 'Markersize', 20, 'color', cols);
    
    clr = get(h(1),'colororder');
    boxplot(h(2),xes,groups,'orientation','horizontal',...
        'label',{'','','','', '','','',''},'color',cols, 'plotstyle', 'compact', 'Whisker', 10);
    
    
    axis(h(1),'auto');  % Sync axes
    
    
    yss = ylim;
    
    hold on
    line([0 0], [yss(1) yss(2)], 'color', 'k', 'linestyle', '-')
    
    line([1 1], [yss(1) yss(2)], 'color', 'k', 'linestyle', ':')
    line([-1 -1], [yss(1) yss(2)], 'color', 'k', 'linestyle', ':')
    
    
    saveName = [FigSaveDir 'ITD_DprimeSummary'];
    
    plotpos = [0 0 25 20];
    print_in_A4(0, saveName, '-djpeg', 0, plotpos);
    disp('')
    print_in_A4(0, saveName, '-depsc', 0, plotpos);
    
    
    %%
    figure(142); clf
    subplot(1, 2,1 )
    binsC_H = -4:.25:2;
    for jj = 1:8
        
        
        [cx,cy]=hist(allITDs(jj,:),binsC_H);
        bla = cumsum(cx) ./ sum(cx);
        hold on
        plot(cy, (bla), 'linewidth', 1, 'color', cols(jj,:) )
        clear('cx','cy');
    end
    yticks = [0:0.25:1];
    set(gca, 'ytick', yticks)
    legend({'1', '2', '3', '4', '5', '6', '7', '8'})
    ToPlot = [ 1 5 8];
    subplot(1, 2,2 )
    for jj = ToPlot
        
        [cx,cy]=hist(allITDs(jj,:),binsC_H);
        bla = cumsum(cx) ./ sum(cx);
        hold on
        plot(cy, (bla), 'linewidth', 1, 'color', cols(jj,:) )
        clear('cx','cy');
    end
    set(gca, 'ytick', yticks)
    
    %%
    
    saveName = [FigSaveDir 'ITD_DprimeSummary_cumSum'];
    
    plotpos = [0 0 20 15];
    print_in_A4(0, saveName, '-djpeg', 0, plotpos);
    disp('')
    print_in_A4(0, saveName, '-depsc', 0, plotpos);
    
    %%
    saveName = [FigSaveDir 'ITD_DScore.mat'];
    
    save(saveName, 'ITDs')
end

disp('')

end
