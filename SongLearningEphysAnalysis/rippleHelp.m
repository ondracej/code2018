             %%
                            
                            
                            % LFP: [samples x channels]
% ripples: struct from ripple detector
% ch: channel to analyze

win = round(0.2*fs);  % 200 ms window

nEvents = length(ripples.peakTime);

allSpec = [];

for i = 1:nEvents
    
    center = round(ripples.peakTime(i)*fs);
    
    if center-win < 1 || center+win > size(LFP,1)
        continue
    end
    
    segment = LFP(center-win:center+win,ch);
    
    [S,F,T] = spectrogram(segment, ...
        round(0.01*fs), ...
        round(0.008*fs), ...
        256, fs);
    
    P = abs(S).^2;
    
    if isempty(allSpec)
        allSpec = zeros(size(P,1),size(P,2),nEvents);
    end
    
    allSpec(:,:,i) = P;
    
end

meanSpec = mean(allSpec,3);

figure
imagesc(T-0.2, F, log10(meanSpec))
axis xy
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('Ripple Triggered Spectrogram')
colorbar
ylim([0 400])

end
                            
       %%
       
     
win = round(0.1*fs);  % ?100 ms window
nEvents = length(ripples.peakTime);

nCh = size(LFP,2);

cohAccum = [];

for i = 1:nEvents
    
    center = round(ripples.peakTime(i)*fs);
    
    if center-win < 1 || center+win > size(LFP,1)
        continue
    end
    
    seg = LFP(center-win:center+win,:);
    
    % Compute coherence for first two channels
    [Cxy,F] = mscohere(seg(:,1),seg(:,2), ...
        round(0.02*fs), ...
        round(0.015*fs), ...
        256, fs);
    
    cohAccum(:,i) = Cxy;
    
end

meanCoh = mean(cohAccum,2);

figure
plot(F,meanCoh,'LineWidth',2)
xlabel('Frequency (Hz)')
ylabel('Coherence')
title('Ripple-triggered Coherence')
xlim([0 400])
       
       
%%



% LFP: [samples x channels]
% ripples: output from ripple detector
% ch: channel to visualize
ch = 1;
%% PARAMETERS
win = round(0.2*fs);   % ?200 ms window
nEvents = length(ripples.peakTime);

lfpSegments = [];
envSegments = [];
specAccum = [];

%% ripple-band filter
[b,a] = butter(4,[120 250]/(fs/2),'bandpass');
rippleBand = filtfilt(b,a,LFP(:,ch));

env = abs(hilbert(rippleBand));

for i = 1:nEvents
    
    center = round(ripples.peakTime(i)*fs);
    
    if center-win < 1 || center+win > size(LFP,1)
        continue
    end
    
    seg = rippleBand(center-win:center+win);
    envSeg = env(center-win:center+win);
    
    lfpSegments(:,end+1) = seg;
    envSegments(:,end+1) = envSeg;
    
    % Spectrogram
    [S,F,T] = spectrogram(seg, ...
        round(0.01*fs), ...
        round(0.008*fs), ...
        256, fs);
    
    P = abs(S).^2;
    
    if isempty(specAccum)
        specAccum = zeros(size(P,1),size(P,2),nEvents);
    end
    
    specAccum(:,:,i) = P;
    
end

%% Compute averages
meanLFP = mean(lfpSegments,2);
meanEnv = mean(envSegments,2);
meanSpec = mean(specAccum,3);

t = (-win:win)/fs;

%% Plot figure
figure

subplot(3,1,1)
plot(t, meanLFP,'k','LineWidth',2)
xlabel('Time (s)')
ylabel('Ripple LFP')
title('Ripple-Aligned Average LFP')
xlim([-0.2 0.2])

subplot(3,1,2)
plot(t, meanEnv,'r','LineWidth',2)
xlabel('Time (s)')
ylabel('Envelope')
title('Ripple Envelope')
xlim([-0.2 0.2])

subplot(3,1,3)
imagesc(T-0.2, F, log10(meanSpec))
axis xy
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('Ripple-triggered Spectrogram')
ylim([0 400])
colorbar

end
