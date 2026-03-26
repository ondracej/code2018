function SWR = detectSharpWaveRipples(LFP, fs)

% LFP: [samples x channels]
% fs: sampling rate (1000?2000 Hz recommended)

nCh = size(LFP,2);
nSamp = size(LFP,1);

%% PARAMETERS

fObj = filterData(fs);

fobj.filt.FL=filterData(fs);
fobj.filt.FL.lowPassPassCutoff=30;% this captures the LF pretty well for detection
fobj.filt.FL.lowPassStopCutoff=40;
fobj.filt.FL.attenuationInLowpass=20;
fobj.filt.FL=fobj.filt.FL.designLowPass;
fobj.filt.FL.padding=true;

figure; plot(LFP(:, 2))
LFP_shift = shiftdim(LFP',-1);
LFP_shift_sq = squeeze(LFP_shift);
figure;plot(LFP_shift_sq(2,:))
DataSeg_LF = squeeze(fobj.filt.FL.getFilteredData(LFP_shift));
  
figure(304); clf

plot(LFP(:, 2))
hold on
plot(DataSeg_LF(2,:))

%%

%sharpBand = [8 40];
sharpBand = [8 40];
rippleBand = [120 250];

%%
lowPassPassCutoff = 20;
lowPassStopCutoff = 60;
attenuationInLowpass = 10;

%lowPassPassCutoff = 30;
%lowPassStopCutoff = 40;
%attenuationInLowpass = 20;

lpFilt = designfilt('lowpassiir', ...
    'PassbandFrequency',lowPassPassCutoff, ...
    'StopbandFrequency',lowPassStopCutoff, ...
    'PassbandRipple',1, ...
    'StopbandAttenuation',attenuationInLowpass, ...
    'SampleRate',fs);
%%

sharpThresh = 3;      % z threshold
rippleThresh = 3.5;
ripplePeak = 5;

minSharpDur = 0.05;
maxSharpDur = 0.20;

minRippleDur = 0.02;
maxRippleDur = 0.12;

minChannels = 3;

%% SHARP WAVE FILTER

[b,a] = butter(3, sharpBand/(fs/2),'bandpass');
sharpLFP = filtfilt(b,a,LFP);
sharpEnv = abs(hilbert(sharpLFP));
sharpZ = (sharpEnv - median(sharpEnv))./mad(sharpEnv,1);

%%

med = median(DataSeg_LF);
maddd = mad(DataSeg_LF,1);
figure; plot(maddd);

%%
figure(104); clf
subplot(3, 1, 1)
hold on
t = (1:length(LFP))/fs;
offset = 0;
for j = 1:nCh
    plot(t, LFP(:,j)+offset);
    text(0, offset, chanNamesSet{j}(5:8), 'interpreter', 'none')
    offset = offset +500;
end


subplot(3, 1, 2)
hold on
offset = 0;
for j = 1:nCh
    plot(t, sharpLFP(:,j)+offset);
    offset = offset +80;
end


subplot(3, 1, 3)
hold on
offset = 0;
for j = 1:nCh
    %plot(t, DataSeg_LF(j,:) +offset);
    plot(t, sharpZ(:,j) +offset);
    %plot(env(:,j)+offset);
    offset = offset +10;
end
ylim([-5 80])


figure; plot(sharpZ(:,1));

%%
sharpMask = sharpZ > sharpThresh;

%% SHARP WAVE EVENTS

minFrames = round(minSharpDur*fs);
maxFrames = round(maxSharpDur*fs);

sharpEvents = false(nSamp,1);

for ch = 1:nCh

    d = diff([0; sharpMask(:,ch); 0]);
    starts = find(d==1);
    ends = find(d==-1)-1;

    for i = 1:length(starts)

        dur = ends(i)-starts(i)+1;

        if dur>=minFrames && dur<=maxFrames
            sharpEvents(starts(i):ends(i)) = true;
        end

    end
end

%% RIPPLE FILTER

[b,a] = butter(4, rippleBand/(fs/2),'bandpass');
rippleLFP = filtfilt(b,a,LFP);

rippleEnv = abs(hilbert(rippleLFP));

rippleEnv = movmean(rippleEnv, round(0.004*fs));

rippleZ = (rippleEnv - median(rippleEnv))./mad(rippleEnv,1);

rippleMask = rippleZ > rippleThresh;

%% RIPPLE EVENTS

minFrames = round(minRippleDur*fs);
maxFrames = round(maxRippleDur*fs);

rippleClean = false(size(rippleMask));

for ch = 1:nCh

    d = diff([0; rippleMask(:,ch); 0]);
    starts = find(d==1);
    ends = find(d==-1)-1;

    for i = 1:length(starts)

        dur = ends(i)-starts(i)+1;

        if dur>=minFrames && dur<=maxFrames

            if max(rippleZ(starts(i):ends(i),ch)) > ripplePeak
                rippleClean(starts(i):ends(i),ch) = true;
            end

        end

    end
end

%% MULTI CHANNEL CONSENSUS

activeRippleCh = sum(rippleClean,2);
rippleEvents = activeRippleCh >= minChannels;

%% REQUIRE RIPPLE INSIDE SHARP WAVE

SWRmask = rippleEvents & sharpEvents;

%% EXTRACT EVENTS

d = diff([0; SWRmask; 0]);
starts = find(d==1);
ends = find(d==-1)-1;

SWR.samples = [starts ends];
SWR.time = SWR.samples / fs;

%% FIND RIPPLE PEAKS

nEvents = length(starts);

SWR.peakTime = zeros(nEvents,1);
SWR.peakPower = zeros(nEvents,1);

for i = 1:nEvents

    seg = rippleZ(starts(i):ends(i),:);

    [p,idx] = max(seg(:));

    [row,~] = ind2sub(size(seg),idx);

    peakSample = starts(i) + row - 1;

    SWR.peakTime(i) = peakSample/fs;
    SWR.peakPower(i) = p;

end

end