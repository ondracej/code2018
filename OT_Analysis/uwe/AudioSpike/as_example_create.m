% example for setting up a very simple AudioSpike measurement from scratch
clear all;
SampleRate = 44100;


% 1. create settings
AudioSpike.Settings.SampleRate           = SampleRate;
AudioSpike.Settings.SampleRateDevider    = 1;
AudioSpike.Settings.EpocheLength         = 0.4983;
AudioSpike.Settings.PreStimulus          = 0.0100;
AudioSpike.Settings.RepetitionPeriod     = 0.650;
AudioSpike.Settings.StimulusRepetition   = 3;
% mulstiple channels possible!
AudioSpike.Settings.OutputChannels       = [1];
AudioSpike.Settings.InputChannels        = [1];
AudioSpike.Settings.RandomMode           = 0;
% optional: specify threshold (one per input channel. If omitted value from
% INI-file (last threshold set by user in GUI is used
AudioSpike.Settings.Thresholds           = [-0.107];

% 2. create measurement parameters
% NOTE: the parameter 'Level' is magic: here you may specify a level list
% (one column per channel) directly that is used for ALL stimuli
% For ALL other parameters each stmulus defined below MUST have a numerical
% value!
AudioSpike.Parameters(1).Name            = 'Level';
AudioSpike.Parameters(1).Unit            = 'dB';
AudioSpike.Parameters(1).Log             = 0; % axis to be plotted linear
% NOTE: if more than one output channel is specified in settings above,
% then you may either specify only one column vector (user for ALL
% channels) or one column for each channel
AudioSpike.Parameters(1).Level           = [50 70 90]';

% create 'Frequency' as second parameter
AudioSpike.Parameters(2).Name            = 'Frequency';
AudioSpike.Parameters(2).Unit            = 'Hz';
AudioSpike.Parameters(2).Log             = 1; % axis to be plotted log

% create 'Duration' as third parameter
AudioSpike.Parameters(3).Name            = 'Duration';
AudioSpike.Parameters(3).Unit            = 'ms';



% 3. create stimuli
freqs  = [250 500 1000];
durs   = [100 200];
% do a loop through desired frequencies and durations
for f = 1:length(freqs)
    for d = 1:length(durs)
        % calculate stimulus index (must be ascending 1...N)
        index = (f-1)*length(durs) + d;
        % get freqquency and duration for THIS stimulus
        freq  = freqs(f);
        dur   = durs(d);
        % set displayed name of stimulus
        AudioSpike.Stimuli(index).Name               = [num2str(freq) 'Hz, ' num2str(dur) 'ms'];
        % set filename
        % NOTE: filename is mandatory. If you specify the audio data in
        % 'Data' below, then the tool script audiospike_createmeas called in
        % 6. below will create the needed audio file from these Data with
        % the specified filename. If you leave Data empty, then the audio
        % file speicfied here MUST exist: AudioSpike will load it!
        AudioSpike.Stimuli(index).FileName           = ['signals/' num2str(freq) '_' num2str(dur) '.wav'];
        AudioSpike.Stimuli(index).Frequency          = freq;
        AudioSpike.Stimuli(index).Duration           = dur;
        % create the stimulus (optional, see above)
        samples = floor(dur * SampleRate / 1000);
        han = hanning(samples);
        AudioSpike.Stimuli(index).Data               = sin(([0:samples-1]' * freq / SampleRate) .*2*pi) .* han;
    end
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
audiospike_createmeas(AudioSpike, 'aw_example_create.xml');

% 6. run AudioSpike passing command to execute, filename to pass and
% optional subpath default for results 
% possible values for 'command':
%   command=measure     passed file is loaded as new measurement (template)
%   command=append      passed file (stimuli and/or levels) are appended
%                       to currently loaded result
%   command=result      passed file is loaded as a measurement result
system('start audiospike.exe command=measure file=aw_example_create.xml subpath=test');

% return here. Below is an example for loading a result
return;

% 7. after AudioSpikes has finished you may load the result to MATLAB!
% here you have to adjust for the reasl result name/path
% - flag, if you want to load the raw recorded epoches as well
LoadRawEpoches = 0;
result = audiospike_loadresult('Results\test\result.xml', LoadRawEpoches);

