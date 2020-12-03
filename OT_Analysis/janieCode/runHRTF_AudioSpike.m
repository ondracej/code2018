function [] = runHRTF_AudioSpike()


%% Get variables
HRIR_To_Load = 'D:\Janie\Dropbox\codetocopy\HRIRconv_100hz-5000hz_Dur-250ms';%###  from  cb_chooseHRIR
HRTF_DegSteps = 5.265;%### from  cb_chooseDeg
defAzRange = '-180:180';
defEleRange = '-67.5:67.5';

%% Load the HRIR File

HRIR = load(HRIR_To_Load); % this will work as long as the runAudioSpikeGUI is in the same dir as the file...

azVec = -73.125:HRTF_DegSteps:73.125;
elVec = -180:HRTF_DegSteps:180;


%% Parse the ranges
colon = ':';
colInd = find(defAzRange == colon);

%azdegvon = -180; %degree azi (-90:7.5:90)
%azdegbis = 180; %degree azi (-90:7.5:90)
%eledegvon = -67.5; %degree ele (-82.5:7.5:82.5)!!!
%eledegbis = 67.5; %degree ele (-82.5:7.5:82.5)!!!

azdegvon = str2num(defAzRange(1:colInd-1));
azdegbis = str2num(defAzRange(colInd+1:end));
azvon_startInd = find(azVec == azdegvon);
azbis_endInd = find(azVec == azdegbis);

colInd = find(defEleRange == colon);

eledegvon = str2num(defEleRange(1:colInd-1));
eledegbis = str2num(defEleRange(colInd+1:end));
elevon_startInd = find(elVec == eledegvon);
elebis_endInd = find(elVec == eledegbis);

%% Define Vectors
stepwidth = HRTF_DegSteps;

% currTest = ['HRTF__Az_' num2str(azdegvon) '-' num2str(round(azdegbis)) '_El_' num2str(round(eledegvon)) '-' num2str(azdegbis) '_st_' num2str(round(stepwidth))];
% append_to_log(['% ' currTest])
% setappdata(fH100, 'currTest', currTest);%###

azvec = azdegvon:stepwidth:azdegbis;
elevec = eledegvon:stepwidth:eledegbis;

az_ZeroInd = find(azvec == 0);
el_ZeroInd = find(elevec == 0);

sig_ch1 = squeeze(HRIR.spatial(:,:,:,1));   %ohr 1  %27,65,7758 (elevation,azimuth, stimvector)
sig_ch1 = sig_ch1(elevon_startInd:stepwidth/HRIR_Res_deg:elebis_endInd, azvon_startInd:stepwidth/HRIR_Res_deg:azbis_endInd,:);

sig_ch2 = squeeze(HRIR.spatial(:,:,:,2)); %ohr 2
sig_ch2 = sig_ch2(elevon_startInd:stepwidth/HRIR_Res_deg:elebis_endInd, azvon_startInd:stepwidth/HRIR_Res_deg:azbis_endInd,:);

%% Calculate RMS on ZeroInd

zeroAzEl_ch1  = squeeze(sig_ch1(el_ZeroInd,az_ZeroInd,:))';
zeroAzEl_ch2  = squeeze(sig_ch2(el_ZeroInd,az_ZeroInd,:))';

%azvec(az_ZeroInd)
%elevec(el_ZeroInd)

rmsCh1 = -rms(zeroAzEl_ch1);
rmsCh2 = -rms(zeroAzEl_ch2);

%% Pack Stimuli Into an Audio Spike Structure

cnt = 1;
for i = 1:numel(elevec)
    for j = 1:numel(azvec)
        
        signalsq_Ch1 = squeeze(sig_ch1(i,j,:))';
        signalsq_2_Ch2 = squeeze(sig_ch2(i,j,:))';
        
        this_azi = num2str(azvec(j));
        this_ele = num2str(elevec(i));
        
        label_text = ['az_' this_azi '__el_' this_ele];
        
        AudioSpike.Stimuli(cnt).Name          = label_text;
        AudioSpike.Stimuli(cnt).FileName      = ['signals/' label_text '.wav'];
        AudioSpike.Stimuli(cnt).RMS           = [rmsCh1 ; rmsCh2]';
        AudioSpike.Stimuli(cnt).Azimuth       = this_azi;
        AudioSpike.Stimuli(cnt).Elevation     = this_ele;
        AudioSpike.Stimuli(cnt).Data          = [signalsq_Ch1; signalsq_2_Ch2]'; % column vector, ch1 and ch2
        
        
        cnt = cnt+1;
    end
end

%% Add a silent trial

silentTrial = ones(1, size(signalsq_Ch1, 2))*0;

AudioSpike.Stimuli(cnt).Name          = 'Silent';
AudioSpike.Stimuli(cnt).FileName      = ['signals/Silent.wav'];
AudioSpike.Stimuli(cnt).RMS           = [rmsCh1 ; rmsCh2]';
AudioSpike.Stimuli(cnt).Azimuth       = nan; % Not sure what values to add here
AudioSpike.Stimuli(cnt).Elevation     = nan; % Not sure what values to add here
AudioSpike.Stimuli(cnt).Data          = [silentTrial; silentTrial]';


%% Parameters
% SPL
defLevelSPL = getappdata(fH100, 'defLevelSPL');%###

AudioSpike.Parameters(1).Name            = 'Level';
AudioSpike.Parameters(1).Unit            = 'dB';
AudioSpike.Parameters(1).Log             = 0; % axis to be plotted linear
AudioSpike.Parameters(1).Level           = [defLevelSPL]';%NOTE: if more than one output channel is specified in settings above,
% then you may either specify only one column vector (user for ALL channels) or one column for each channel

AudioSpike.Parameters(2).Name            = 'Azimuth';
AudioSpike.Parameters(2).Unit            = 'degree';
AudioSpike.Parameters(2).Log             = 0;

AudioSpike.Parameters(3).Name            = 'Elevation';
AudioSpike.Parameters(3).Unit            = 'degree';
AudioSpike.Parameters(3).Log             = 0;

setappdata(fH100, 'AudioSpike', AudioSpike);%###

cb_setupAudioSpikeSettingsParams(fH100)

disp('')

end
