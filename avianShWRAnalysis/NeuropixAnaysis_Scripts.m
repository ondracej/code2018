

AnalysisDir = 'G:\Neuropixel\w051\w051_raw-04_g0\';


cd(AnalysisDir)

np_OBJ = NeuropixAnalysis_OBJ();

%%
[np_OBJ] = getStimDurationsFromWavFile(np_OBJ);

np_OBJ = loadNidaqFindStimEdges(np_OBJ);

%%

np_OBJ  = syncSquareWave(np_OBJ);
%%

[np_OBJ] = loadSpikes(np_OBJ);

%%
np_OBJ = alignSpikesToStims(np_OBJ);