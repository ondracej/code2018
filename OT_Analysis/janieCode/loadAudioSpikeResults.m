function []  = loadAudioSpikeResults()

dbstop if error


resultsPath = '/home/janie/Dropbox/codetocopy/test/results/20171029_192725_hrtf_0001/result_0001.xml';

close all

% first: add path to AudioSpike tool scripts: mandatory!!
addpath('/home/janie/Dropbox/codetocopy/test/tools/');

%%
% 1. set flag, if you want to load the raw recorded epoche wave data as well
LoadRawEpoches = 1;

%% Make sure to fix the code here for linux vs pc
result = audiospike_loadresult(resultsPath, LoadRawEpoches);

fs = result.Settings.SampleRate;

FS = fs / result.Settings.SampleRateDevider;


timepoints = 1:1:numel(result.Epoches(2).Data);
timepoints_s = timepoints/FS;

% as an example show access to a spike and an epoche:

% 3. display properties of first epoche and plot it
disp('properties of first epoche:');
Epoche_1 = result.Epoches(1)
plot(timepoints_s , result.Epoches(2).Data);

% 3. display properties of first spike and plot it
disp('properties of first selected spike:');
Epoche_1 = result.Spikes(1)
figure
plot(result.Spikes(2).Data);

end
