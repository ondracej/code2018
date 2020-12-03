% example for setting up a very simple AudioSpike measurement from scratch
clear all;

% first: add path to AudioSpike tool scripts: mandatory!!
addpath('tools');


SampleRate = 192000;


% 1. create settings
AudioSpike.Settings.SampleRate           = SampleRate;
AudioSpike.Settings.SampleRateDevider    = 2;
AudioSpike.Settings.EpocheLength         = 0.4983;
AudioSpike.Settings.PreStimulus          = 0.0100;
AudioSpike.Settings.RepetitionPeriod     = 0.650;
AudioSpike.Settings.StimulusRepetition   = 5;
AudioSpike.Settings.OutputChannels       = [1];
AudioSpike.Settings.InputChannels        = [1];
AudioSpike.Settings.RandomMode           = 1;
% optional: specify threshold (one per input channel. If omitted value from
% INI-file (last threshold set by user in GUI is used
%AudioSpike.Settings.Thresholds           = [0.107];

% 2. create measurement parameters 
AudioSpike.Parameters(1).Name            = 'Level';
AudioSpike.Parameters(1).Unit            = 'dB';
AudioSpike.Parameters(1).Log             = 0;
AudioSpike.Parameters(1).Level           = [30:10:60]';
AudioSpike.Parameters(2).Name            = 'Frequency';
AudioSpike.Parameters(2).Unit            = 'Hz';
AudioSpike.Parameters(2).Log             = 1;

% 3. create stimuli
% create a hanning window of 100ms length
han     = hanning(SampleRate/10);
% generate 100ms sine signals with ramp over complete length

freqvec=30000:10000:80000;

for i=1:length(freqvec)
    label_text=[ num2str(freqvec(i)/1000) 'kHz'];
freq    = freqvec(i);
AudioSpike.Stimuli(i).Name               = label_text;
AudioSpike.Stimuli(i).FileName           = ['signals/' num2str(freq) '.wav'];
AudioSpike.Stimuli(i).Frequency          = freq;
AudioSpike.Stimuli(i).Data               = sin(([0:length(han)-1]' * freq / AudioSpike.Settings.SampleRate) .*2*pi) .* han;

end

% 4. define cluster window (optional). Possible values for X- and Y-axis
% are:
% TotalAmp
% Peak1
% Peak2
% PeakPos
% PeakNeg
% PeakToPeak
% TrigToPeak
AudioSpike.Cluster(1).X = 'Peak1';
AudioSpike.Cluster(1).Y = 'Peak2';
%AudioSpike.Cluster(2).X = 'Peak1';
%AudioSpike.Cluster(2).Y = 'PeakToPeak';


% 5. call helper script to generate XML from struct and wav files from 
% stimulus data
audiospike_createmeas(AudioSpike, 'as_example.xml');

% 6. run AudioSpike passing the name of the created XML AND the default subpath to
% be used for the result
%system('start audiospike.exe as_example.xml abc');
system('start bin\audiospike.exe command=measure file=as_example.xml subpath=xyz');

% returnhere. Below is an example for loading a result
return;

% 7. after AudioSpikes stopped: load the result!
% here you have to adjust for the reasl result name/path
LoadRawEpoches = 0;
result = audiospike_loadresult('Results\test\result.xml', LoadRawEpoches);

