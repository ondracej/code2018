function [] = plotZScoresDPrimes_WN(experiment, recSession, NeuronName, oo)
dbstop if error
if nargin <3
    
    experiment = 1;
    recSession = 3;
    NeuronName = 'N-03';
    oo =1;
end

C_OBJ = chicken_OT_analysis_OBJ(experiment, recSession);

%%
allStims = C_OBJ.RS_INFO.StimProtocol_name;
tf = find(strcmpi(allStims,'WhiteNoise'));

audSelInd = tf(1); % SpikesThis is the index, spikesnot the stim number!!!
Stim = C_OBJ.RS_INFO.StimProtocol_name{audSelInd};
disp(Stim);

%audSelInd = 2; % SpikesThis is the index, spikesnot the stim number!!!

FigSaveDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/Figs/EnvAnalysis-HRTF/MLD/';

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
z_score_cov = (meanStim - meanSpont) / sqrt((stdStim^2 + stdSpont^2) - 2*covar(1, 2));

WN.FR_Spont(oo) = FR_Spont;
WN.FR_Stim(oo) = FR_Stim;
WN.FR_Spont_post(oo) = FR_Spont_post;

WN.meanPreStimFR(oo) = meanPreStimFR;
WN.meanStimFR(oo) = meanStimFR;
WN.meanPostStimFR(oo) = meanPostStimFR;

WN.stdFRStim(oo) = stdFRStim;
WN.stdFRSpont(oo) = stdFRSpont;
WN.stdFRSpontPost(oo) = stdFRSpontPost;

WN.semFRStim(oo) = semFRStim;
WN.semFRSpont(oo) = semFRSpont;
WN.semFRSpontPost(oo) = semFRSpontPost;

WN.z_score_cov(oo) = z_score_cov;

%%

saveName = [FigSaveDir 'AuditoryPlots'];

plotpos = [0 0 25 20];
print_in_A4(0, saveName, '-djpeg', 1, plotpos);
disp('')
print_in_A4(0, saveName, '-depsc', 1, plotpos);

disp('')

end