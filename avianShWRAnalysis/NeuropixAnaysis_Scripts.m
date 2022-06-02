

AnalysisDir = 'F:\Neuropixel-w051\';


cd(AnalysisDir)

np_OBJ = NeuropixAnalysis_OBJ();

%%
[np_OBJ] = getStimDurationsFromWavFile(np_OBJ);

np_OBJ = loadNidaqFindStimEdges(np_OBJ);

%%

np_OBJ  = syncSquareWave(np_OBJ);