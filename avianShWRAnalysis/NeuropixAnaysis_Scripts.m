
close all 
clear all

%%
%AnalysisDir = 'Z:\JanieData\Neuropixel\w051\w051_raw_g0\'; %- incomplete / short file'
%AnalysisDir = 'Z:\JanieData\Neuropixel\w051\w051_raw-02_g0\'; 
%AnalysisDir = 'Z:\JanieData\Neuropixel\w051\w051_raw-03_g0\';
%AnalysisDir = 'Z:\JanieData\Neuropixel\w051\w051_raw-05_g0\';
%AnalysisDir = 'Z:\JanieData\Neuropixel\w050\raw_04_LH_P3_g0\';

%AnalysisDir = 'Z:\JanieData\Neuropixel\w050\raw_01_LH_P1_g0\'; - No Sorting??
%AnalysisDir = 'Z:\JanieData\Neuropixel\w050\raw_02_LH_P2_g0\'; - no spikes?
%AnalysisDir = 'Z:\JanieData\Neuropixel\w050\raw_04_LH_P3_g0\'; -no spikes
AnalysisDir = 'Z:\JanieData\Neuropixel\w050\raw_05_RH_P1_g0\';


cd(AnalysisDir)

np_OBJ = NeuropixAnalysis_OBJ();

%%
[np_OBJ] = getStimDurationsFromWavFile(np_OBJ);

np_OBJ = loadNidaqFindStimEdges(np_OBJ);

%%
np_OBJ  = syncSquareWave(np_OBJ);
%%
np_OBJ = remapNiStimsToImecStream(np_OBJ);

%%
[np_OBJ] = loadSpikes(np_OBJ);

%%
np_OBJ = alignSpikesToStims(np_OBJ);

np_OBJ = alignSpikesToStims_spont(np_OBJ);

%%
np_OBJ = calcDPrimeSelectivity_FRstats(np_OBJ);

%%
np_OBJ = makeSummaryPlotsForNeurons(np_OBJ);
