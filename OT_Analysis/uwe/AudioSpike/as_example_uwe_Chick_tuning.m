% example for setting up a very simple AudioSpike measurement from scratch

clear AudioSpike;

% first: add path to AudioSpike tool scripts: mandatory!!
addpath('tools');

%%%% general setting
n_reps =2;%str2num(get(findobj(gcf,'tag','edit3'),'string'));% number of repetions
EpoLe = 0.4;%str2num(get(findobj(gcf,'tag','edit2'),'string'));%[s]
RepPe=0.5;%
PrePause=0.05;%[s]

srate=44100;
dur=0.1;

%%%SPL range
SPL_step=5; %stepwidth dB
vonSPL=50;
bisSPL=80;
stepwidthSPL=5;%stepwidthSPL

n_stepsSPL_a= round((bisSPL-vonSPL)/stepwidthSPL);
bisSPL=vonSPL+(stepwidthSPL*n_stepsSPL_a);
n_stepsSPL=n_stepsSPL_a+1;
SPLvector=linspace(vonSPL,bisSPL,n_stepsSPL);%final SPL vector

binaural= 1;%get(findobj(gcf,'tag','popupmenu2'),'value');%normal=1, binaural=2, moncontra=3,monipsi=4

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

%%%Frequency range
%%%%%%log-Steps

fc= 2000; %str2num(get(findobj(gcf,'tag','edit4'),'string'));
n_oct=1;%str2num(get(findobj(gcf,'tag','edit5'),'string'));
steps_oct=8;%str2num(get(findobj(gcf,'tag','edit6'),'string'));
fu=fc/(2^n_oct);
fo=fc*(2^n_oct);
freqs=logspace(log10(fu),log10(fo),(n_oct*2*steps_oct)+1);
%%limit frequency range
freqvector=freqs(find(freqs <6000 & freqs >=200));%%%%%%%%%%%%%%200Hz bis 6kHz möglich
n_stepsFreq=length(freqvector);

t = 0:1/srate:dur-1/srate;%%
%sig=sin(2*pi*t*freqvector(i));%Puretone %neu
%sig1=wind(srate,0.005,sig1);

% 1. create settings
AudioSpike.Settings.SampleRate           = srate;
AudioSpike.Settings.SampleRateDevider    = 2;%1
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

AudioSpike.Parameters(2).Name            = 'Frequency';
AudioSpike.Parameters(2).Unit            = 'Hz';
AudioSpike.Parameters(2).Log             = 1;% nur im plot!!

% 3. create stimuli
% generate 100ms sine signals with ramp over complete length


for i=1:length(freqvector)
    label_text=[ num2str(round(freqvector(i))/1000) 'kHz'];
    
    freq    = round(freqvector(i));
    AudioSpike.Stimuli(i).Name               = label_text;
    AudioSpike.Stimuli(i).FileName           = ['signals/' num2str(freq) '.wav'];
    AudioSpike.Stimuli(i).Frequency          = freq;
    AudioSpike.Stimuli(i).Data               = wind(srate,0.005,sin(2*pi*t*freqvector(i)));
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