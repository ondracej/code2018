
function [] = janie_chicken_HRTF_Ch1Ch2output_AudioSpike()
dbstop if error
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

repetitionPeriod_ms = 1000; % Time between epoches in milliseconds

preThreshold_ms = 50; % Time in milliseconds to extract for each spike before thresold crossing
spikeLength_ms = 50 + preThreshold_ms;  % Total length in milliseconds to extract/plot for each spike (Pre-Threshold + time from threshold crossing to spike end)

sampleRate = 44100 ; % Samplerate for soundcard to be used
sampleRateDevider = 1.4; % Downsampling devider. The signals recorded from the inputs (electrodes) are downsampled by this factor

stimDur_s =  stimDur_ms /1000;
preStimulus_s = preStimulus_ms/1000; 
repetitionPeriod_s = repetitionPeriod_ms/1000; % Time between epoches in milliseconds
preThreshold_s = preThreshold_ms/1000; % Time in milliseconds to extract for each spike before thresold crossing
spikeLength_s = spikeLength_ms/1000;  % Total length in milliseconds to extract/plot for each spike (Pre-Threshold + time from threshold crossing to spike end)
epochLength_s = stimDur_s + preStimulus_s; % Epoche length in milliseconds

%% load HRTF

%load('D:\Hansa\HRIRconv.mat'); 
%load('D:\Janie\AudioSpike_v_10202017\HRIRconv.mat'); 

load('/home/janie/Dropbox/codetocopy/HRIRconv_100hz-7000hz_Dur-250ms.mat'); 

%% Based on SpaceStimChickRX6_2.m

sig_ch1 = squeeze(spatial(:,:,:,1));   %ohr 1  %27,65,7758 (elevation,azimuth, stimvector)
sig_ch2 = squeeze(spatial(:,:,:,2)); %ohr 2


%% %% determine spatial range in azimuth and elevation
azdegvon = -180; %degree azi (-90:7.5:90)
azdegbis = 180; %degree azi (-90:7.5:90)

eledegvon = -67.5; %degree ele (-82.5:7.5:82.5)!!!
eledegbis = 67.5; %degree ele (-82.5:7.5:82.5)!!!


HRIR_Res_deg = 5.625;
%stepwidth=16.875;% 7.5, 7.5 oder 15� Schritte 24.3.09
%stepwidth = HRIR_Res_deg*2;

stepwidth = HRIR_Res_deg;

%%% f�r Test nur mittleren Stimulus%%
% azdegvon=0; %degree azi (-90:7.5:90)
% azdegbis=0; %degree azi (-90:7.5:90)
% eledegvon=-7.5; %degree ele (-82.5:7.5:82.5)!!!
% eledegbis=-7.5; %degree ele (-82.5:7.5:82.5)!!!

azvon = (azdegvon-(HRIR_Res_deg*32))/HRIR_Res_deg+65;
azbis = (azdegbis-(HRIR_Res_deg*32))/HRIR_Res_deg+65;

elevon = (eledegvon-(HRIR_Res_deg*13))/HRIR_Res_deg+27;
elebis = (eledegbis-(HRIR_Res_deg*13))/HRIR_Res_deg+27;

azvec = azdegvon:stepwidth:azdegbis; %alle azimuth position (wichtig f�r stimulus Grid)in 7.5� oder 15� Schritten 24.3.09
elevec = eledegvon:stepwidth:eledegbis ; %alle elevation position  24.3.09

 %sig_ch1_a = sig_ch1(elevon:stepwidth/5.625:elebis, azvon:stepwidth/5.625:azbis,     :);% begrenzt r�umlichen bereich 24.3.09
 %sig_ch2_a = sig_ch2(elevon:stepwidth/5.625:elebis, azvon:stepwidth/5.625:azbis,    :);% begrenzt r�umlichen bereich 24.3.09
 sig_ch1 = sig_ch1(elevon:stepwidth/5.625:elebis, azvon:stepwidth/5.625:azbis,     :);% begrenzt r�umlichen bereich 24.3.09
 sig_ch2 = sig_ch2(elevon:stepwidth/5.625:elebis, azvon:stepwidth/5.625:azbis,    :);% begrenzt r�umlichen bereich 24.3.09

 sig_ch1_a = sig_ch1(elevon:stepwidth/HRIR_Res_deg:elebis, azvon:stepwidth/HRIR_Res_deg:azbis,     :);% begrenzt r�umlichen bereich 24.3.09
 sig_ch2_a = sig_ch2(elevon:stepwidth/HRIR_Res_deg:elebis, azvon:stepwidth/HRIR_Res_deg:azbis,    :);% begrenzt r�umlichen bereich 24.3.09

%%
    
    n_stim = prod(size(sig_ch1(:,:,1)));
    
    ele_v = [];
    az_v = [];
    sound_v_Ch1 = [];
    sound_v2_Ch2 = [];
    maxiall = [];
    stdall = [];
    
    for i = 1:size(sig_ch1,1); %ele 9
        for j = 1:size(sig_ch1,2);%azi 22
       
            signalsq_Ch1 = squeeze(sig_ch1(i,j,:))';
            signalsq_2_Ch2 = squeeze(sig_ch2(i,j,:))';
            
            this_azi = num2str(azvec(j));
            this_ele = num2str(elevec(i));
            
            label_text = ['az_' this_azi '__el_' this_ele];
            %freq = round(freqVector(i));
            
            AudioSpike.Stimuli(i).Name          = label_text;
            AudioSpike.Stimuli(i).FileName      = ['signals/' label_text '.wav'];
            
            
            
            AudioSpike.Stimuli(i).RMS           = -rms(F_sin_ramp);
            AudioSpike.Stimuli(i).Frequency     = freq;
            AudioSpike.Stimuli(i).Data          = F_sin_ramp ;
            
            
            sound_v_Ch1 = [sound_v_Ch1 signalsq_Ch1];
            sound_v2_Ch2 = [sound_v2_Ch2 signalsq_2_Ch2];
            
            az_v = [az_v azvec(j)];
            ele_v = [ele_v elevec(i)];
        end
    end
    
    %maxout=max(maxiall)
    %stdout=max(stdall)
    %az_v;
    %ele_v;
    
%     figure(10),plot(sound_v)
    
%% Add a silent trial
    %%%  Nullstimulus hinzuf�gen und az/ele vector und n_stim anpassen%%%%%%%%%%%%%%%%%%
    sound_v_Ch1 = [sound_v_Ch1 zeros(1,size(sig_ch1,3))];%%extra Leer-stimulus f�r Spontanaktivit�t
    sound_v2_Ch2 = [sound_v2_Ch2 zeros(1,size(sig_ch2,3))];%%extra Leer-stimulus f�r Spontanaktivit�t
    
    az_v=[az_v -100];
    ele_v=[ele_v -100];
    nStim=nStim+1;
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


maxval= max(abs(sound_v_Ch1));

ampfac=9.9/maxval;

sound_v_Ch1=sound_v_Ch1*ampfac;% max Amplitude = 9.9 V ;
sound_v2_Ch2=sound_v2_Ch2*ampfac;


% maxi=max(sound_v)
% maxi2=max(sound_v2)
% figure,plot(sound_v);
% figure,plot(sound_v2);



%define a vector of start samples
startall=0:len:length(sound_v_Ch1);%1 �berhang
startall=startall(1:length(startall)-1);%Uberhang weg

%define a vector of stop samples
stopall=len-1:len:length(sound_v_Ch1);

tic
%%%%%%%%%%%%%%indices f�r Brainware stimulusgrid %%%%%%%%%%%%%%%%%%%

SPL_1=vonSPL;

%% H�hnchen 
maxSPL_1=95;%Max SPL LS1 bei 10V(am RX6), 10dBAtt 
maxSPL_2=95;%Max SPL LS2 bei 10V ;


SPL_2=SPL_1;% level auf beiden Ohren prinzipiell gleich



if Loch==2;% Seitenumkehr f�r Ipsi/contra
    SPL_1b=SPL_1;%Ausgabewert Kanal_1
    SPL_2b=SPL_2;%Ausgabewert Kanal_2
    SPLcontra=SPL_1b;%wert f�r BW stimulus Grid
    SPLipsi=SPL_2b;%wert f�r BW stimulus Grid
else
    SPL_1b=SPL_2;
    SPL_2b=SPL_1;
    SPLcontra=SPL_2b;%wert f�r BW stimulus Grid
    SPLipsi=SPL_1b;%wert f�r BW stimulus Grid
end

Atten1= maxSPL_1-SPL_1b+10; %10dB Grundeinstellung(bei 9.9 V Output vom RV6)
Atten2= maxSPL_2-SPL_2b+10;
%%%%%%%%%%%%%%SPL-Error-Warnung%%%%%%

if SPL_1 > maxSPL_1 | SPL_1 >maxSPL_2;
    err;
    error ('SPL zu hoch');
end

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
    AudioSpike.Stimuli(i).Frequency     = freq;
    AudioSpike.Stimuli(i).Data          = F_sin_ramp ;
    
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

AudioSpike.Parameters(1).Name            = 'Elevation';
AudioSpike.Parameters(1).Unit            = 'Deg';
AudioSpike.Parameters(1).Log             = 0;

AudioSpike.Parameters(1).Level           = [SPLvector_contra; SPLvector_ipsi]';

AudioSpike.Parameters(2).Name            = 'Azimuth';
AudioSpike.Parameters(2).Unit            = 'Deg';
AudioSpike.Parameters(2).Log             = 0;% nur im plot!!

%% Create XML file from Matlab Stucture 

AudioSpikeFile_xml = [SettingFileName '.xml'];

audiospike_createmeas(AudioSpike, AudioSpikeFile_xml);
system('start bin\audiospike.exe command=measure file=freqTuning_Ch1Ch2_1-1.xml subpath=bla');
%eval(['system([''start bin\audiospike.exe command=measure file= ' AudioSpikeFile_xml ' subpath=' thisDate_txt '''])']);

%audiospike_createmeas(AudioSpike, AudioSpikeFile_xml);


%system('start audiospike.exe command=result file=pfad'); lade result nach

end

