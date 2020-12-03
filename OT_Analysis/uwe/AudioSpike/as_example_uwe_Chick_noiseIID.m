% example for setting up a very simple AudioSpike measurement from scratch

clear AudioSpike;

% first: add path to AudioSpike tool scripts: mandatory!!
addpath('tools');

%%%% general setting
n_reps =10;%str2num(get(findobj(gcf,'tag','edit3'),'string'));% number of repetions
EpoLe = 0.4;%str2num(get(findobj(gcf,'tag','edit2'),'string'));%[s]
RepPe=0.5;%
PrePause=0.05;%[s]

srate=44100;
dur=0.1;



%%%SPL range
SPL_step=5; %stepwidth dB
vonSPL=40;
bisSPL=70;
stepwidthSPL=5;%stepwidthSPL

n_stepsSPL_a= round((bisSPL-vonSPL)/stepwidthSPL);
bisSPL=vonSPL+(stepwidthSPL*n_stepsSPL_a);
n_stepsSPL=n_stepsSPL_a+1;
SPLvector=linspace(vonSPL,bisSPL,n_stepsSPL);%final SPL vector

binaural= 2;%get(findobj(gcf,'tag','popupmenu2'),'value');%normal=1, bintest=2, moncontra=3,monipsi=4

if binaural==1;
    SPLvector_contra=   SPLvector;
    SPLvector_ipsi=   SPLvector;
elseif binaural==2;
    SPLvector_contra=   SPLvector;
    SPLvector_ipsi=   fliplr(SPLvector);
elseif binaural==3;
    SPLvector_contra=   SPLvector;
    SPLvector_ipsi=   zeros(size(SPLvector));
elseif binaural==4;
    SPLvector_contra=   zeros(size(SPLvector));
    SPLvector_ipsi=   SPLvector;
end







% 1. create settings
AudioSpike.Settings.SampleRate           = srate;
AudioSpike.Settings.SampleRateDevider    = 1;
AudioSpike.Settings.EpocheLength         = EpoLe;
AudioSpike.Settings.PreStimulus          = PrePause;
AudioSpike.Settings.RepetitionPeriod     = RepPe;
AudioSpike.Settings.StimulusRepetition   = n_reps;
AudioSpike.Settings.OutputChannels       = [1 2];
AudioSpike.Settings.InputChannels        = [1];%%%[1 2];
AudioSpike.Settings.RandomMode           = 1;

% 2. create measurement parameters (zwei kanalig als 2 spalten!!)
AudioSpike.Parameters(1).Name            = 'Level';
AudioSpike.Parameters(1).Unit            = 'dB';
AudioSpike.Parameters(1).Log             = 0;

AudioSpike.Parameters(1).Level           = [SPLvector_contra;SPLvector_ipsi]'; %%%noch checken!!!

% 3. create stimuli

t = 0:1/srate:dur-1/srate;%%
noise_sig=randn(1,length(t));
noise_sig=noise_sig/max(abs(noise_sig)); %maxAmplitude =1
noise_sig=wind(srate,0.005,noise_sig);

for i=1:1;%length(SPLvector_contra);
    label_text=[ 'noise'];
    AudioSpike.Stimuli(i).Name               = label_text;
    AudioSpike.Stimuli(i).FileName           = ['signals_noise.wav'];
    AudioSpike.Stimuli(i).noise              = 1;
    AudioSpike.Stimuli(i).Data               = noise_sig;
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