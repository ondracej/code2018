
function [] = janie_chicken_freqTuning_Ch1Ch2output_AudioSpike()

binaural= 1;%normal=1, binaural=2, moncontra=3,monipsi=4

SettingFileName = 'freqTuning_Ch1Ch2_1-1';
ShortFileName = 'FT_Ch1Ch2_1-1';

c = clock;
c = fix(c);
thisDate_txt = [num2str(c(1)) num2str(c(2)) num2str(c(3)) '_' num2str(c(4)) num2str(c(5)) num2str(c(6))];

%% General Stimulus setting for %% AudioSpike Settings v 1.0.1.0

stimDur_ms = 500;
preStimulus_ms = 100; % Length of silence within an epoche before stimulus is played in milliseconds
nStimulusRepetition = 20; % number of times the stimulus list is presented. If randomization is activated the stimulus list is shuffled before each repetition
randomMode = 1; % switch random order of stimuli on/off (1/0)

rampDur_ms = 5;

repetitionPeriod_ms = 1000; % Time between epoches in milliseconds

preThreshold_ms = 50; % Time in milliseconds to extract for each spike before thresold crossing
spikeLength_ms = 50 + preThreshold_ms;  % Total length in milliseconds to extract/plot for each spike (Pre-Threshold + time from threshold crossing to spike end)

sampleRate = 44100 ; % Samplerate for soundcard to be used
sampleRateDevider = 1.4; % Downsampling devider. The signals recorded from the inputs (electrodes) are downsampled by this factor

stimDur_s =  stimDur_ms /1000;
preStimulus_s = preStimulus_ms/1000; 
rampDur_s = rampDur_ms /1000;
repetitionPeriod_s = repetitionPeriod_ms/1000; % Time between epoches in milliseconds
preThreshold_s = preThreshold_ms/1000; % Time in milliseconds to extract for each spike before thresold crossing
spikeLength_s = spikeLength_ms/1000;  % Total length in milliseconds to extract/plot for each spike (Pre-Threshold + time from threshold crossing to spike end)
epochLength_s = stimDur_s + preStimulus_s; % Epoche length in milliseconds

%% SPL range

SPLstep_dB = 5; %stepwidth dB
range_SPL_lo = 40; %& 45 seems to be the lowest limint, some kind of calibration problem...
range_SPL_hi = 70;

SPLvector = range_SPL_lo:SPLstep_dB:range_SPL_hi;

if binaural == 1 % ch 1 and ch 2 are the same
    SPLvector_contra = SPLvector;
    SPLvector_ipsi = SPLvector;

elseif binaural == 2 % ch 1 decreasing, ch 2 increasing
    SPLvector_contra = SPLvector;
    SPLvector_ipsi = fliplr(SPLvector);

elseif binaural == 3 % ch 1 only, ch 2 silent
    SPLvector_contra = SPLvector;
    SPLvector_ipsi = zeros(size(SPLvector));

elseif binaural == 4 % ch 2 only, ch 1 silent
    SPLvector_contra = zeros(size(SPLvector));
    SPLvector_ipsi = SPLvector;
end

%% Frequency Range

rangeFreq_lo_hz = 100;
rangeFreq_hi_hz = 6000;

fc_hz = 2000; % carrier freq
nOct = 3; % n octaves
stepsOct = 8;

f_lo = fc_hz/(2^nOct);
f_hi = fc_hz*(2^nOct);

freqs = logspace(log10(f_lo),log10(f_hi),(nOct *2 * stepsOct)+1);

%%limit frequency range
freqVector = freqs(find(freqs <= rangeFreq_hi_hz & freqs >=rangeFreq_lo_hz));
nFreqs = numel(freqVector);

%% http://www.h6.dion.ne.jp/~fff/old/technique/auditory/matlab.html#cramp
%% Prepare tone
%cf = 2000;                  % carrier frequency (Hz)
%sf = 22050;                 % sample frequency (Hz)
%d = 1.0;                    % duration (s)
%n = sf * d;                 % number of samples
%s = (1:n) / sf;             % sound data preparation
%s = sin(2 * pi * cf * s);   % sinusoidal modulation
%% prepare ramp
% dr = d / 10;
% nr = floor(sf * dr);
% r = sin(linspace(0, pi/2, nr));
% r = [r, ones(1, n - nr * 2), fliplr(r)];
%
%% make ramped sound
% s = s .* r;
% sound(s, sf);               % sound presentation
% pause(d + 0.5);             % waiting for sound end
% plot(s);

%%

nSamp = stimDur_s*sampleRate;
t = (1:nSamp) / sampleRate;   

% prepare ramp
nr = floor(sampleRate * rampDur_s);
ramp = sin(linspace(0, pi/2, nr));
ramp = [ramp, ones(1, nSamp - nr * 2), fliplr(ramp)];

%% Create AudioSpike Structure

clear AudioSpike;
addpath('D:\Janie\AudioSpike_v1.0.1.0_10202017\tools');
addpath('D:\Janie\AudioSpike_v1.0.1.0_10202017\MatlabCode\');
%% AudioSpike Stimulus 

for i = 1:nFreqs
    
    F_sin = sin(2 * pi * freqVector(i) * t);   % sinusoidal modulation
    F_sin_ramp = F_sin .* ramp;
    
    % Plot
    %     figure; plot(F_sin, 'k')
    %     hold on ; plot(F_sin_ramp, 'b')
    %     xlim([0 2*nr])
    %
    label_text=[ num2str(round(freqVector(i))/1000) 'kHz'];
    freq = round(freqVector(i));
    
    %%
    AudioSpike.Stimuli(i).Name          = label_text;
    AudioSpike.Stimuli(i).FileName      = ['signals/' num2str(freq) '.wav'];
    AudioSpike.Stimuli(i).RMS           = -rms(F_sin_ramp);
    AudioSpike.Stimuli(i).Data          = F_sin_ramp ;
    
    AudioSpike.Stimuli(i).Frequency     = freq;
%     if i == nFreqs
%         AudioSpike.Stimuli(i+1).Name          = 'Silent';
%         AudioSpike.Stimuli(i+1).FileName      = ['signals/Silent.wav'];
%         AudioSpike.Stimuli(i+1).RMS           = AudioSpike.Stimuli(i).RMS;
%         AudioSpike.Stimuli(i+1).Frequency     = 0;
%         AudioSpike.Stimuli(i+1).Data          = ones(1, size(F_sin_ramp, 2))*0;
%     end
end

%% AudioSpike Settings 

% 1. create settings
AudioSpike.Settings.SampleRate           = sampleRate;
AudioSpike.Settings.SampleRateDevider    = sampleRateDevider;
AudioSpike.Settings.EpocheLength         = epochLength_s;
AudioSpike.Settings.PreStimulus          = preStimulus_s;
AudioSpike.Settings.RepetitionPeriod     = repetitionPeriod_s;
AudioSpike.Settings.StimulusRepetition   = nStimulusRepetition;
AudioSpike.Settings.SpikeLength          = spikeLength_s;
AudioSpike.Settings.PreThreshold         = preThreshold_s;
AudioSpike.Settings.OutputChannels       = [1 2];
AudioSpike.Settings.InputChannels        = [1];
AudioSpike.Settings.RandomMode           = randomMode;

%% AudioSpike Parameters 

AudioSpike.Parameters(1).Name            = 'Level';
AudioSpike.Parameters(1).Unit            = 'dB';
AudioSpike.Parameters(1).Log             = 0;

AudioSpike.Parameters(1).Level           = [SPLvector_contra; SPLvector_ipsi]';

AudioSpike.Parameters(2).Name            = 'Frequency';
AudioSpike.Parameters(2).Unit            = 'Hz';
AudioSpike.Parameters(2).Log             = 1;% nur im plot!!

%% Create XML file from Matlab Stucture 

AudioSpikeFile_xml = [SettingFileName '.xml'];

audiospike_createmeas(AudioSpike, AudioSpikeFile_xml);
system('start bin\audiospike.exe command=measure file=freqTuning_Ch1Ch2_1-1.xml subpath=bla');
%eval(['system([''start bin\audiospike.exe command=measure file= ' AudioSpikeFile_xml ' subpath=' thisDate_txt '''])']);

%audiospike_createmeas(AudioSpike, AudioSpikeFile_xml);


%system('start audiospike.exe command=result file=pfad'); lade result nach

end

