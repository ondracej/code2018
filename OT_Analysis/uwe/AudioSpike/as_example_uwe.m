% example for setting up a very simple AudioSpike measurement from scratch

clear AudioSpike;

% first: add path to AudioSpike tool scripts: mandatory!!
addpath('tools');


% 1. create settings
AudioSpike.Settings.SampleRate           = 192000;
AudioSpike.Settings.SampleRateDevider    = 2;
AudioSpike.Settings.EpocheLength         = 0.4983;
AudioSpike.Settings.PreStimulus          = 0.05;%%0.0100
AudioSpike.Settings.RepetitionPeriod     = 0.500;%%0.6500
AudioSpike.Settings.StimulusRepetition   = 5;
AudioSpike.Settings.OutputChannels       = [1];
AudioSpike.Settings.InputChannels        = [1];%%%[1 2];
AudioSpike.Settings.RandomMode           = 1;

% 2. create measurement parameters
AudioSpike.Parameters(1).Name            = 'Level';
AudioSpike.Parameters(1).Unit            = 'dB';
AudioSpike.Parameters(1).Log             = 0;
AudioSpike.Parameters(1).Level           = [40:10:70]';%[40:10:70]'

AudioSpike.Parameters(2).Name            = 'Frequency';
AudioSpike.Parameters(2).Unit            = 'Hz';
AudioSpike.Parameters(2).Log             = 1;% nur im plot!!

AudioSpike.Parameters(3).Name            = 'dur';
AudioSpike.Parameters(3).Unit            = 'ms';
AudioSpike.Parameters(3).Log             = 0;

% 3. create stimuli
% create a hanning window of 100ms length
han     = hanning(1920);
durs=[1920 2*1920 ];
%durs=[ 2*1920 2*1920];
% generate 100ms sine signals with ramp over complete length

freqvec=30000:10000:80000;

for i=1:length(freqvec)
    for k=1:2
        label_text=[ num2str(freqvec(i)/1000) 'kHz, ' num2str(durs(k))];
        index = (i-1)*length(durs) + k;
        freq    = freqvec(i);
        AudioSpike.Stimuli(index).Name               = label_text;
        AudioSpike.Stimuli(index).FileName           = ['signals/' num2str(freq) '_' num2str(durs(k)) '.wav'];
        AudioSpike.Stimuli(index).Frequency          = freq;
        han=hanning(durs(k));
        AudioSpike.Stimuli(index).dur                = durs(k);
        AudioSpike.Stimuli(index).RMS = -3.02;% dB full scaleinterne Calib [- 3.02 -3.02] (2 channels)
        
        AudioSpike.Stimuli(index).Data               = sin(([0:durs(k)-1]' * freq / AudioSpike.Settings.SampleRate) .*2*pi) .* han;
        
    end
end


%rms = sqrt(Mean(x^2))



%AudioSpike
%return
% 4. call helper script to generate XML from struct and wav files from
% stimulus data
audiospike_createmeas(AudioSpike, 'as_example.xml');

% 5. run AudioSpike passing the name of the created XML
system('start bin\audiospike.exe command=measure file=as_example.xml subpath=xyz');


% returnhere. Below is an example for loading a result
%return;

% 6. after AudioSpikes stopped: load the result!
%result = audiospike_loadresult('Results\test\result.xml', 1);

