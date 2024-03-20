function [WN] = calcFRZScores_WN(experiment, recSession, NeuronName, oo, maxNum, WN)

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
tf = find(strcmpi(allStims,'WhiteNoise'));

audSelInd = tf(1); % SpikesThis is the index, spikesnot the stim number!!!
Stim = C_OBJ.RS_INFO.StimProtocol_name{audSelInd};
disp(Stim);

%audSelInd = 2; % SpikesThis is the index, spikesnot the stim number!!!

%FigSaveDir = '/media/janie/300GBPassport/OTProject/MLD/';
FigSaveDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/';

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


stimNames = C_OBJ.S_SPKS.SORT.allSpksStimNames;
SpkResponses = C_OBJ.S_SPKS.SORT.allSpksMatrix;

nRows = size(stimNames, 1);
nCols = size(stimNames, 2);
cnnt = 1;

smoothWin_ms = 2;

cnnt = 1;

figure(406); clf

for j = 1:nRows
    for k = 1:nCols
        thisSpkResp = SpkResponses{j,k};
        nReps = size(thisSpkResp, 2);
        for o = 1:50
            
            thisRep = thisSpkResp{1, o};
            
            PreStimSpkCnts(o) = numel(find(thisRep > PreStimStartTime_samp & thisRep <= StimStartTime_samp));
            StimSpkCnts(o) = numel(find(thisRep > StimStartTime_samp & thisRep <= PostStimStartTime_samp));
            PostStimSpkCnts(o) = numel(find(thisRep > PostStimStartTime_samp & thisRep <= EndTime_samp));
            
            
            all_PreStimSpkCnts(cnnt) =  PreStimSpkCnts(o);
            all_StimSpkCnts(cnnt) =   StimSpkCnts(o);
            all_PostStimSpkCnts(cnnt) = PostStimSpkCnts(o);
            
            cnnt = cnnt+1;
        end
        
    end
end

FR_Spont = all_PreStimSpkCnts / 0.1;
FR_Stim = all_StimSpkCnts / 0.1;
FR_Spont_post = all_PostStimSpkCnts / 0.1;

meanPreStimFR = mean(FR_Spont);
meanStimFR = mean(FR_Stim);
meanPostStimFR = mean(FR_Spont_post);

stdFRStim = std(FR_Stim);
stdFRSpont = std(FR_Spont);
stdFRSpontPost = std(FR_Spont_post);

semFRStim = stdFRStim / (sqrt(numel(FR_Stim)));
semFRSpont = stdFRSpont / (sqrt(numel(FR_Spont)));
semFRSpontPost = stdFRSpontPost / (sqrt(numel(FR_Spont_post)));

covar = cov(FR_Stim, FR_Spont);
z_score_cov = (meanStimFR - meanPreStimFR) / sqrt((stdFRStim^2 + stdFRSpont^2) - 2*covar(1, 2));

WN.FR_Spont(oo,:) = FR_Spont;
WN.FR_Stim(oo,:) = FR_Stim;
WN.FR_Spont_post(oo,:) = FR_Spont_post;

WN.meanPreStimFR(oo) = meanPreStimFR;
WN.meanStimFR(oo) = meanStimFR;
WN.meanPostStimFR(oo) = meanPostStimFR;

WN.stdFRSpont(oo) = stdFRSpont;
WN.stdFRStim(oo) = stdFRStim;
WN.stdFRSpontPost(oo) = stdFRSpontPost;

WN.semFRSpont(oo) = semFRSpont;
WN.semFRStim(oo) = semFRStim;
WN.semFRSpontPost(oo) = semFRSpontPost;

WN.z_score_cov(oo) = z_score_cov;

%%
if oo == maxNum
    
    [p h] = ttest(WN.meanPreStimFR,WN.meanStimFR);
    [p h] = ttest(WN.meanPostStimFR,WN.meanStimFR);
    
    allWNSpontMeans = mean(WN.meanPreStimFR);
    allWNStimMeans = mean(WN.meanStimFR);
    allmeanPostStimFR = mean(WN.meanPostStimFR);
    
    allStdFRSpont = std(WN.meanPreStimFR);
    allStdFRStim = std(WN.meanStimFR);
    allStdFRSpontPost = std(WN.meanPostStimFR);
    
    allSemFRSpont = allStdFRSpont / (sqrt(numel(WN.meanPreStimFR)));
    allSemFRStim = allStdFRStim / (sqrt(numel(WN.meanStimFR)));
    allSemFRSpontPost = allStdFRSpontPost / (sqrt(numel(WN.meanPostStimFR)));
    
    
    WN.allWNSpontMeans = allWNSpontMeans;
    WN.allWNStimMeans = allWNStimMeans;
    WN.allmeanPostStimFR = allmeanPostStimFR;
    
    WN.allStdFRSpont = allStdFRSpont;
    WN.allStdFRStim = allStdFRStim;
    WN.allStdFRSpontPost = allStdFRSpontPost;
    
    WN.allSemFRSpont = allSemFRSpont;
    WN.allSemFRStim = allSemFRStim;
    WN.allSemFRSpontPost = allSemFRSpontPost;
    
    
    subplot(2, 1, 1)
    
    
    bar(1, allWNSpontMeans, 'FaceColor',[1 1 1])
    hold on
    er = errorbar(1, allWNSpontMeans, allSemFRSpont, allSemFRSpont);
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    
    hold on
    bar(2,allWNStimMeans, 'FaceColor',[0 .0 0])
    er = errorbar(2,allWNStimMeans,allSemFRStim, allSemFRStim);
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    
    bar(3,allmeanPostStimFR, 'FaceColor',[.5 .5 .5])
    er = errorbar(3,allmeanPostStimFR,allSemFRSpontPost, allSemFRSpontPost);
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    
    set(gca, 'xtick', [1 2 3]);
    set(gca, 'xticklabel', {'Baseline' ; 'Stimulus' ; 'Post'});
    ylabel('Firing  Rate [Hz]')
    ylim ([0 30])
    
    
    saveName = [FigSaveDir 'WN_FR'];
    
    plotpos = [0 0 15 12];
    print_in_A4(0, saveName, '-djpeg', 0, plotpos);
    disp('')
    print_in_A4(0, saveName, '-depsc', 0, plotpos);
    
    %%
    
    zscores= WN.z_score_cov;
    xes = ones(1, numel(zscores));
    jitterAmount = 0.1;
    jitterValuesX = 2*(rand(size(zscores))-0.5)*jitterAmount;   % +
    
    cols = cell2mat({[0 0 0]});
    %cols = cell2mat({[0.6350, 0.0780, 0.1840]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; [0, 0, 0]; [0.4940, 0.1840, 0.5560]});
    
    figure(102); clf
    h = scatterhist(zscores,jitterValuesX, 'Kernel','on', 'Location','NorthEast',...
        'Direction','out', 'LineStyle',{'-','-'}, 'Marker','..', 'Markersize', 20, 'color', 'k');
       
    boxplot(h(2),zscores,'orientation','horizontal',...
        'label',{''},'color', 'k', 'plotstyle', 'compact', 'Whisker', 10);
    
    
    
    axis(h(2),'auto');  % Sync axes
    
    
    
    yss = ylim;
    xss = xlim;
    
    hold on
    line([.5 .5], [yss(1) yss(2)], 'color', 'k', 'linestyle', ':')
    line([-.5 -.5], [yss(1) yss(2)], 'color', 'k', 'linestyle', ':')
    
      
    saveName = [FigSaveDir 'WN_Zscore'];
    
    plotpos = [0 0 15 12];
    print_in_A4(0, saveName, '-djpeg', 0, plotpos);
    disp('')
    print_in_A4(0, saveName, '-depsc', 0, plotpos);
    
    % subplot(2, 1, 2); cla
    % scatter(xes, zscores, 'filled', 'jitter','on', 'jitterAmount',0.3);
    % ylim([-5 10])
    % xlim([.5 1.5])
    % hold on
    % line([.5 1.5], [0,0], 'color', 'k')
    % line([.5 1.5], [.5,.5], 'color', 'k', 'linestyle', ':')
    % line([.5 1.5], [-.5,-.5], 'color', 'k', 'linestyle', ':')
    % set(gca,'xtick',[])
    % ylabel('Z-Score')
    
    %%
    
    
 
    saveName = [FigSaveDir 'WN_FR-Zscores.mat'];
    
    save(saveName, 'WN')
end

disp('')

end