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
AudioSpike.Settings.OutputChannels       = [1 2];
AudioSpike.Settings.InputChannels        = [1];%%%[1 2];
AudioSpike.Settings.RandomMode           = 1;

% 2. create measurement parameters (zwei kanalig als 2 spalten!!)
AudioSpike.Parameters(1).Name            = 'Level';
AudioSpike.Parameters(1).Unit            = 'dB';
AudioSpike.Parameters(1).Log             = 0;
AudioSpike.Parameters(1).Level           = [40:5:70;fliplr(40:5:70)]'


AudioSpike.Parameters(2).Name            = 'Frequency';
AudioSpike.Parameters(2).Unit            = 'Hz';
AudioSpike.Parameters(2).Log             = 1;% nur im plot!!

%%%(Programm fügt zusätzliche Parametwer der "Reihe" nach ein (Spalten!!)

% 3. create stimuli
% create a hanning window of 100ms length
han     = hanning(19200);

% generate 100ms sine signals with ramp over complete length

freqvec=60000;


for i=1:length(freqvec)
    label_text=[ num2str(freqvec/1000) 'kHz, '];
    
    freq    = freqvec(i);
    AudioSpike.Stimuli(i).Name               = label_text;
    AudioSpike.Stimuli(i).FileName           = ['signals/' num2str(freq) '.wav'];
    AudioSpike.Stimuli(i).Frequency          = freq;
   
        
    AudioSpike.Stimuli(i).Data               = sin(([0:length(han)-1]' * freq / AudioSpike.Settings.SampleRate) .*2*pi) .* han;
    
end


%AudioSpike
%return
% 4. call helper script to generate XML from struct and wav files from
% stimulus data
audiospike_createmeas(AudioSpike, 'as_example.xml');



% 5. run AudioSpike passing the name of the created XML
system('start bin\audiospike.exe command=measure file=as_example.xml subpath=xyz');

%system('start audiospike.exe command=result file=pfad'); lade result nach
%AudioSpike!!!


% 6. after AudioSpikes stopped: load the result to matlab!!!!!
% result = audiospike_loadresult('Results\test\result.xml', 1);