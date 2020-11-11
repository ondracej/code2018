function [IIDs] = doAnalysisOnITDs(experiment, recSession, NeuronName, oo, maxNum, IIDs)

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
FigSaveDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/Figs/ITDs/';

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
StimSet = [5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21];
if oo == 20
    StimSet = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17];
end

stimNames = C_OBJ.S_SPKS.SORT.allSpksStimNames
SpkResponses = C_OBJ.S_SPKS.SORT.allSpksMatrix;

%%
allStimSpksOverReps = [];
allMeansStimSpksOverReps = [];
allstdsStimSpksOverReps = [];
winSize_ms = 100;
winSize_samp = winSize_ms/1000*SamplingRate; 
   
    for j = 1: numel(StimSet)
        cnnt = 1;
      
        all_StimSpkCnts = [];
     
        thisInd = StimSet(j);
        
        thisSpkResp = SpkResponses{1,thisInd};
        nReps = size(thisSpkResp, 2);
        
        for o = 1:nReps
            
            thisRep = thisSpkResp{1, o};
            
            % Look in a 10 ms window 
            %PreStimSpkCnts(o) = numel(find(thisRep > PreStimStartTime_samp & thisRep <= StimStartTime_samp));
            StimSpkCnts(o) = numel(find(thisRep > StimStartTime_samp & thisRep <= PostStimStartTime_samp));
            %PostStimSpkCnts(o) = numel(find(thisRep > PostStimStartTime_samp & thisRep <= EndTime_samp));
            
            %StimSpkCnts(o) = numel(find(thisRep > StimStartTime_samp & thisRep <= StimStartTime_samp + winSize_samp));
            
            
            %all_PreStimSpkCnts(cnnt) =  PreStimSpkCnts(o);
            all_StimSpkCnts(cnnt) =   StimSpkCnts(o);
            %all_PostStimSpkCnts(cnnt) = PostStimSpkCnts(o);
            
            cnnt = cnnt+1;
        end
        
        
        allStimSpksOverReps{j} =  all_StimSpkCnts/0.1;
        
        allmeans(j) = nanmean(allStimSpksOverReps{j});
        allstds(j) = nanstd(allStimSpksOverReps{j});
        allsems(j) = ( allstds(j)) / sqrt(numel(all_StimSpkCnts));
    end
    
figure(406); clf
xes = 1:1:17;
errorbar(xes,allmeans,allsems, 'ko-', 'linewidth', 1)
%plot(xes, allmeans, 'ko-', 'linewidth', 1)
axis tight
xlim([0 18])
%ylim([0 50])
xticks = 1:2:17;
set(gca, 'xtick', xticks)
%set(gca, 'xticklabel', {'-1 ms', '-0.75 ms', '-0.50 ms', '-0.25 ms', '0 ms', '0.25 ms', '0.50 ms', '0.75 ms', '1 ms'})
set(gca, 'xticklabel', {'-2ms', '-1.5ms', '-1ms', '-0.5ms', '0 ms', '0.5ms', '1ms', '1.5ms', '2ms'})
ylabel('Mean Spikes')
xlabel('Delay')

saveName = [FigSaveDir NeuronName '-ITD-Spikecounts'];

plotpos = [0 0 25 12];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);
disp(saveName)
print_in_A4(0, saveName, '-depsc', 0, plotpos);

%%
ITDs.allStimSpksOverReps{oo,:} = allStimSpksOverReps;
ITDs.allmeans{oo,:} = allmeans;
ITDs.allstds{oo,:} = allstds;
ITDs.allsems{oo,:} = allsems;
%%
%{
if oo == maxNum
    
    
    for z = 1:24
        dB50(z) = IIDs.D_Stim{1,z}(1,1);
        dB40(z) = IIDs.D_Stim{1,z}(1,2);
        dB30(z) = IIDs.D_Stim{1,z}(1,3);
        dB20(z) = IIDs.D_Stim{1,z}(1,4);
        dB10(z) = IIDs.D_Stim{1,z}(1,5);
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
    
    
    
    saveName = [FigSaveDir 'IID_DScore.mat'];
    
    save(saveName, 'IIDs')
end

disp('')
%}
end
