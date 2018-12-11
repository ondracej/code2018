function [] =  turtleSleepAnalysisScripts()
dbstop if error

SessionToAnalyze = 1;

[turtleSleep_DB] = turtleSleepDataBase();

%% Unpack Variables from Database

INFO = turtleSleep_DB(SessionToAnalyze).INFO;
Session = turtleSleep_DB(SessionToAnalyze).Session;
DIR = turtleSleep_DB(SessionToAnalyze).DIR;
REC = turtleSleep_DB(SessionToAnalyze).REC;
ShW = turtleSleep_DB(SessionToAnalyze).ShW;
DB = turtleSleep_DB(SessionToAnalyze).DB;
Breathing = turtleSleep_DB(SessionToAnalyze).Breathing;
Tracking = turtleSleep_DB(SessionToAnalyze).Tracking;
Plotting = turtleSleep_DB(SessionToAnalyze).Plotting;
Artifacts = turtleSleep_DB(SessionToAnalyze).Artifacts;
%% Check Data Best Channel

%[MAX, MIN, STD] = checkData(REC.bestCSC, DIR, Plotting);

%allMaxV = round(MAX.max_V);
%allMax_V_BP = round(MAX.max_V_BP);
%allmax_HP = round(MAX.max_HP);
%allmax_LF_BP = round(MAX.max_LF_BP);

%% Define Delta Cutoff Freq

%runFeqBandDetection(REC.bestCSC, DIR, Plotting)

%% Detect Sharp Waves

defineShWTemplate_FirstPass_LFBP(ShW, DIR, REC, Artifacts, Plotting)

%% make template

makeShWTemplates(ShW, DIR, REC, Plotting)

%% Detect Peaks using template

peakDetectionWithTemplate(ShW, DIR, REC, Artifacts, Plotting)

%%
% find periods of no sharp waves - calc beta range

%%
% sharp wave statistics
%%
% calc delta beta ratio - whole night
%%
% calc temp for night

%%
%calc  HR

%%
%calc
%%
% calc surfacing cycles


%%
end
