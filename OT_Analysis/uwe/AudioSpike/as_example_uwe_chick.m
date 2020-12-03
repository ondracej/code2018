% example for setting up a very simple AudioSpike measurement from scratch

clear AudioSpike;

% first: add path to AudioSpike tool scripts: mandatory!!
addpath('tools');

%%%%spatial noise stimuli
load('D:\Hansa\HRIRconv.mat'); 

%spatial(elen,azn,:,ear)


sig=squeeze(spatial(:,:,:,1));   %ohr 1  %27,65,7758 (elevation,azimuth, stimvector)
sig_2=squeeze(spatial(:,:,:,2)); %ohr 2

azdegvon=-180; %degree azi (-90:7.5:90)
azdegbis=180; %degree azi (-90:7.5:90)
eledegvon=-67.5; %degree ele (-82.5:7.5:82.5)!!!
eledegbis=67.5; %degree ele (-82.5:7.5:82.5)!!!

azvon=(azdegvon-(5.625*32))/5.625+65;
azbis=(azdegbis-(5.625*32))/5.625+65;
elevon=(eledegvon-(5.625*13))/5.625+27;
elebis=(eledegbis-(5.625*13))/5.625+27;

stepwidth=16.875;% 7.5, 7.5 oder 15� Schritte 

azvec=azdegvon:stepwidth:azdegbis;%alle azimuth position (wichtig f�r stimulus Grid)in 7.5� oder 15� Schritten
elevec=eledegvon:stepwidth:eledegbis;%alle elevation position  

sig=sig(elevon:stepwidth/5.625:elebis, azvon:stepwidth/5.625:azbis,     :);% begrenzt r�umlichen bereich 
sig_2=sig_2(elevon:stepwidth/5.625:elebis, azvon:stepwidth/5.625:azbis,    :);% begrenzt r�umlichen bereich 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1. create settings
AudioSpike.Settings.SampleRate           = 44100;%!!!! noch anpassen!!!
AudioSpike.Settings.SampleRateDevider    = 1;
AudioSpike.Settings.EpocheLength         = 0.4983;
AudioSpike.Settings.PreStimulus          = 0.05;%%0.0100
AudioSpike.Settings.RepetitionPeriod     = 0.500;%%0.6500
AudioSpike.Settings.StimulusRepetition   = 3;
AudioSpike.Settings.OutputChannels       = [1 2];%[1 2];
AudioSpike.Settings.InputChannels        = [1];%%%[1 2];
AudioSpike.Settings.RandomMode           = 1;

% 2. create measurement parameters
AudioSpike.Parameters(1).Name            = 'Level';
AudioSpike.Parameters(1).Unit            = 'dB';
AudioSpike.Parameters(1).Log             = 0;
AudioSpike.Parameters(1).Level           = [70 70];%[40:10:70]',  [40:5:70;fliplr(40:5:70)]'

AudioSpike.Parameters(2).Name            = 'Azimuth';
AudioSpike.Parameters(2).Unit            = 'deg';
AudioSpike.Parameters(2).Log             = 0;% nur im plot!!

AudioSpike.Parameters(3).Name            = 'Elevation';
AudioSpike.Parameters(3).Unit            = 'deg';
AudioSpike.Parameters(3).Log             = 0;

% 3. "create" stimuli


for i=1:length(azvec)
    
    for k=1:length(elevec)
        label_text=[ num2str(azvec(i)/1000) 'deg, ' num2str(elevec(k))];
        
        index = (i-1)*length(elevec) + k;%!!!! Achtung!!!
       
        AudioSpike.Stimuli(index).Name               = label_text;
        AudioSpike.Stimuli(index).FileName           = ['signals/' num2str(azvec(i)) '_' num2str(elevec(k)) '.wav'];
        AudioSpike.Stimuli(index).Azimuth            = azvec(i);
      
        AudioSpike.Stimuli(index).Elevation          = elevec(k);
        AudioSpike.Stimuli(index).Data               = [squeeze(sig(k,i,:)) squeeze(sig_2(k,i,:))  ] ;%%% columnn vectors!!!!!
        
    end
end









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

