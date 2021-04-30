pathToNeuralElectrophysilogyTools = 'C:\Users\Janie\Documents\GitHub\NeuralElectrophysilogyTools\timeSeriesViewer\';
addpath(genpath(pathToNeuralElectrophysilogyTools))

dataDir = 'E:\MPI\lizard_14\12.06.2015\17-10-54_cheetah'; % No slash at end
dataRecordingObj = NLRecording(dataDir);
%%
chan = 32;
seg_ms = 1000;
TOn=0:seg_ms:(dataRecordingObj.recordingDuration_ms-seg_ms);

Fs = dataRecordingObj.samplingFrequency;

%%
ind = 1;
[tmpV, t_ms] =dataRecordingObj.getData(chan,TOn(ind),seg_ms);

%%
V = squeeze(tmpV);
figure; plot(t_ms, V);

%EOF
