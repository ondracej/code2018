function [IIDs] = doAnalysisOnIIDs(experiment, recSession, NeuronName, oo, maxNum, IIDs)

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
tf = find(strcmpi(allStims,'IID'));

audSelInd = tf(1); % SpikesThis is the index, spikesnot the stim number!!!
Stim = C_OBJ.RS_INFO.StimProtocol_name{audSelInd};
disp(Stim);

%audSelInd = 2; % SpikesThis is the index, spikesnot the stim number!!!

%FigSaveDir = '/media/janie/300GBPassport/OTProject/MLD/';
FigSaveDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/Figs/IIDs/';

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
RStimInds = [2 3 4 5 6];
LStimInds = [12 11 10 9 8];
EqInd = 8;

if oo == 21
    RStimInds = [5 6 7 8 9];
    LStimInds = [15 14 13 12 11];
    EqInd = 10;
    
elseif oo == 22
    RStimInds = [1 2 3 4 5];
    LStimInds = [11 10 9 8 7];
    EqInd = 10;
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
for w = 1:5
    %D_Az_Stim = 2* (AZ_Stim_inds_contra_mean - AZ_Stim_inds_ispi_mean) / sqrt(AZ_Stim_inds_contra_std^2 + AZ_Stim_inds_ispi_std^2);
    thisDPrime = 2* (allMeansStimSpksOverReps{1,w} - allMeansStimSpksOverReps{2,w}) / sqrt(allstdsStimSpksOverReps{1,w}^2 + allstdsStimSpksOverReps{2,w}^2);
    D_Stim(w) = thisDPrime;
end

%%
figure(406); clf
xes = 1:1:5;
plot(xes, D_Stim, 'ko-', 'linewidth', 1)
xlim([0 6])
%ylim([-30 2])
xticks = 1:1:5;
set(gca, 'xtick', xticks)
set(gca, 'xticklabel', {'50 dB', '40 dB', '30 dB', '20 dB', '10 dB'})


saveName = [FigSaveDir NeuronName '-IID-DPrime'];

plotpos = [0 0 15 12];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);
disp('')
print_in_A4(0, saveName, '-depsc', 0, plotpos);


IIDs.allStimSpksOverReps{oo,:} = allStimSpksOverReps;
IIDs.allMeansStimSpksOverReps{oo,:} = allMeansStimSpksOverReps;
IIDs.allstdsStimSpksOverReps{oo,:} = allstdsStimSpksOverReps;

IIDs.allPs{oo} = allPs;
IIDs.allHs{oo} = allHs;

IIDs.D_Stim{oo} = D_Stim;

%%
if oo == maxNum
    
    
    for z = 1:24
        dB50(z) = IIDs.D_Stim{1,z}(1,1);
        dB40(z) = IIDs.D_Stim{1,z}(1,2);
        dB30(z) = IIDs.D_Stim{1,z}(1,3);
        dB20(z) = IIDs.D_Stim{1,z}(1,4);
        dB10(z) = IIDs.D_Stim{1,z}(1,5);
    end
    
        allIIDs = [ dB50 ;dB40 ;dB30 ;dB20 ;dB10]; % to make left negative
    for i = 1:5
        for j = 1:5
    [p(i, j), h(i, j)] = ranksum(allIIDs(i,:), allIIDs(j,:));
        end
    end
    
    
    IIDs.dB50 = dB50;
    IIDs.dB40 = dB40;
    IIDs.dB30 = dB30;
    IIDs.dB20 = dB20;
    IIDs.dB10 = dB10;
    
    group1 = ones(1, size(dB50, 2))*1;
    group2 = ones(1, size(dB40, 2))*2;
    group3 = ones(1, size(dB30, 2))*3;
    group4 = ones(1, size(dB20, 2))*4;
    group5 = ones(1, size(dB10, 2))*5;
    
    groups = [group1 group2 group3 group4 group5];
    
    
    xes = [ dB50 dB40 dB30 dB20 dB10]; % to make left negative

    
    jitterAmount = 0.1;
    jitterValues1 = 2*(rand(size(dB50))-0.5)*jitterAmount;   % +
    jitterValues2 = 2*(rand(size(dB40))-0.5)*jitterAmount;   % +
    jitterValues3 = 2*(rand(size(dB30))-0.5)*jitterAmount;   % +
    jitterValues4 = 2*(rand(size(dB20))-0.5)*jitterAmount;   % +
    jitterValues5 = 2*(rand(size(dB10))-0.5)*jitterAmount;   % +
    
    yes = [jitterValues1 jitterValues2 jitterValues3 jitterValues4 jitterValues5];
    
    %%
    
    figure(406); clf
    cols = cell2mat({[0.6350, 0.0780, 0.1840]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; [0, 0, 0]; [0.4940, 0.1840, 0.5560]});
    
    h = scatterhist(xes,yes,'Group',groups,'Kernel','on', 'Location','NorthEast',...
        'Direction','out', 'LineStyle',{'-','-'}, 'Marker','..', 'Markersize', 20, 'color', cols);
    
    clr = get(h(1),'colororder');
    boxplot(h(2),xes,groups,'orientation','horizontal',...
        'label',{'','','','',''},'color',cols, 'plotstyle', 'compact', 'Whisker', 10);
    
    
    axis(h(1),'auto');  % Sync axes
    
    
    yss = ylim;
    
    hold on
    line([0 0], [yss(1) yss(2)], 'color', 'k', 'linestyle', '-')
    
    line([1 1], [yss(1) yss(2)], 'color', 'k', 'linestyle', ':')
    line([-1 -1], [yss(1) yss(2)], 'color', 'k', 'linestyle', ':')
    
    
    saveName = [FigSaveDir 'IID_DprimeSummary'];
    
    plotpos = [0 0 25 20];
    print_in_A4(0, saveName, '-djpeg', 0, plotpos);
    disp('')
    print_in_A4(0, saveName, '-depsc', 0, plotpos);
    
    
    %%
    
    
      %%
    figure(142); clf
    subplot(1, 2, 1)
    binsC_H = -25:1:10;
    for jj = 1:5
        
        
        [cx,cy]=hist(allIIDs(jj,:),binsC_H);
        bla = cumsum(cx) ./ sum(cx);
        hold on
        plot(cy, (bla), 'linewidth', 1, 'color', cols(jj,:) )
        clear('cx','cy');
    end
    yticks = [0:0.25:1];
    set(gca, 'ytick', yticks)
    legend({'1', '2', '3', '4', '5'})
    
    saveName = [FigSaveDir 'IID_DprimeSummary_cumSum'];
    
    plotpos = [0 0 20 15];
    print_in_A4(0, saveName, '-djpeg', 0, plotpos);
    disp('')
    print_in_A4(0, saveName, '-depsc', 0, plotpos);
    
    %%
    saveName = [FigSaveDir 'IID_DScore.mat'];
    
    save(saveName, 'IIDs')
end

disp('')

end
