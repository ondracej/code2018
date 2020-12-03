% example appending new frequency and two levels to an existing one-output-channel
% measurement
clear all;

% 1. set mandatory values: 
% - sample rate needed by helper skript to create wave files from data
SampleRate = 44100;

AudioSpike.Settings.SampleRate           = SampleRate;

% - new level(s) to be appended: must be written exactly to this path AND
% must contain correct column count (same as measurement, where these data
% should be appended to)
AudioSpike.Settings.Level           = [75 85]';

% 2. create stimuli to be appended: NOTE: this loop is identical to the
% creation loop in aw_example_create.m
% - new frequency
freqs  = [750];
% NOTE: we need the durations here as well to create stimuli with both
% existing durations for the new frequency!
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



% 3. call helper script to generate XML from struct and wav files from
% stimulus data
audiospike_createmeas(AudioSpike, 'sw_example_append.xml');

% 4. optional: load the result, were you want to append the new data to
% system('start audiospike.exe command=result file=results\test \result_0001.xml');
% IMPORTANT NOTE: if you load the result directly before appending new
% data, then you have to pause here: otherwise the append command is called
% before the reult loading is complete!!!
% pause

% 5. append new data to it
system('start audiospike.exe command=append file=sw_example_append.xml');