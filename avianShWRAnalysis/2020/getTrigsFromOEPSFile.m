function [] = getTrigsFromOEPSFile()
dbstop if error
%106_ADC5

nVidFrames = 968943;
LightOffFrame= 53849;
LightOnFrame= 911321;
FPS = 20;

%TriggerFile = 'H:\HamedsData\w038_w037\chronic_2021-08-31_21-59-35\150_ADC3.continuous'; 2, 3 %?? Irregular
TriggerFile = 'H:\HamedsData\w038_w037\w037\chronic_2021-09-20_22-02-53\150_ADC5.continuous'; %?? Irregular
%TriggerFile = 'H:\HamedsData\w025_w027\chronic_2021-08-09_21-51-42-trig ok\150_ADC5.continuous'; %?? Irregular
%%
addpath(genpath('C:\Users\Neuropix\Documents\GitHub\analysis-tools\'));

%%
[filepath,name,ext] = fileparts(TriggerFile);

[data, timestamps, info] = load_open_ephys_data(TriggerFile);
fs = info.header.sampleRate;
figure; plot(data(1:40*fs))

% test = diff(info.ts);
% figure
% plot(info.ts(1:end-1), test );

TrigInds = find(data>4.5);
diffInds = diff(TrigInds);
largeDiffs = find(diffInds >1);

allFrameTrigs_samps = TrigInds(largeDiffs);

nTrigs = numel(allFrameTrigs_samps);
half = round(nTrigs/2); % there are 2 times as many triggers because its an up down thing?

if FPS == 20    
    if half*2 ~= nVidFrames
        keyboard % there is a problem
    end
elseif FPS == 10
    if half ~= nVidFrames
        keyboard % there is a problem
    end
end

divider = round(nTrigs/nVidFrames);

trigs = allFrameTrigs_samps;
trigs = trigs(1:divider:end,:);

%%
TRIGS.nVidFrames = nVidFrames;
TRIGS.nTrigs = nTrigs;

TRIGS.allTrigs_samp = trigs;

TRIGS.LightOff_frame = LightOffFrame;
TRIGS.LightOff_samp = trigs(LightOffFrame);

TRIGS.LightOn_frame = LightOnFrame;
TRIGS.LightOn_samp = trigs(LightOnFrame);

TRIGS.divider = divider;
TRIGS.fs = fs;
TRIGS.TriggerFile = TriggerFile;

save([filepath '\TRIGS.mat'], 'TRIGS');
disp(['Saved: ' filepath '\TRIGS.mat'])
%[pks,locs,w,p] = findpeaks(data, 'MinPeakHeight', 1); % this is very slow
%nTrigs = numel(locs);


end