
%% Data loading

% bins size = 20 s

LFP = data;
nCh = size(LFP,2);
nSamp = size(LFP,1);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Ripple filter
rippleBand = [80 250];

%% BANDPASS FILTER (stable SOS)
[z,p,k] = butter(4,rippleBand/(fs/2),'bandpass');
[sos,g] = zp2sos(z,p,k);

rippleLFP = filtfilt(sos,g,LFP);

%% Hilbert envelope
rippleEnv = abs(hilbert(rippleLFP));
%                        figure; plot(env)
%% Smooth envelope
%env = movmean(env, round(0.005*fs));
rippleEnv = movmean(rippleEnv, round(0.020*fs));

%% Z-score per channel
rippleZ = (rippleEnv - mean(rippleEnv))./std(rippleEnv);

%{
                            %% Raw data
                            figure(104); clf
                            subplot(5, 2, 1)
                            hold on
                            t = (1:length(LFP))/fs;
                            offset = 0;
                            for j = 1:nCh
                                plot(t, LFP(:,j)+offset);
                                text(0, offset, chanSet{j}(5:8), 'interpreter', 'none')
                                offset = offset +500;
                            end
                            axis tight
                            title('Raw LFP')
                            
                            subplot(5, 2, 2)
                            hold on
                            t = (1:length(LFP))/fs;
                            offset = 0;
                            for j = 1:nCh
                                plot(t, LFP(:,j)+offset);
                                text(0, offset, chanSet{j}(5:8), 'interpreter', 'none')
                                offset = offset +500;
                            end
                            ylim([-100 3500])
                            title('Raw LFP')
                            
                            %% sharp wave filter
                            subplot(5, 2, 3)
                            hold on
                            offset = 0;
                            for j = 1:nCh
                                plot(t, sharpLFP(:,j)+offset);
                                offset = offset +80;
                            end
                            ylim([-100 600])
                            title('LFP - Sharp wave filter (8-40 Hz)')
                            
                            
                            %% sharp z
                            subplot(5, 2, 5)
                            hold on
                            offset = 0;
                            for j = 1:nCh
                                %plot(t, DataSeg_LF(j,:) +offset);
                                plot(t, sharpZ(:,j) +offset);
                                %plot(env(:,j)+offset);
                                offset = offset +10;
                            end
                            
                            axis tight
                            title('Z-Scored Sharp wave envelope')
                            disp('')
                            
                            
                            
                            %% delta
                            
                            subplot(5, 2, 7)
                            hold on
                            offset = 0;
                            for j = 1:nCh
                                plot(t, LFP_delta(:,j)+offset);
                                offset = offset +80;
                            end
                            ylim([-100 700])
                            title('LFP - delta filter (1-4 Hz)')
                            
                            
                            %% sharp z
                            subplot(5, 2, 9)
                            hold on
                            offset = 0;
                            for j = 1:nCh
                                %plot(t, DataSeg_LF(j,:) +offset);
                                plot(t, deltaZ(:,j) +offset);
                                %plot(env(:,j)+offset);
                                offset = offset +5;
                            end
                            
                            axis tight
                            title('Z-Scored delta envelope')
                            disp('')
                            
                            %%    Delta
                            
                            subplot(5, 2, 4)
                            hold on
                            offset = 0;
                            for j = 1:nCh
                                plot(t, LFP_delta(:,j)+offset);
                                offset = offset +80;
                            end
                            ylim([-100 700])
                            title('LFP - delta filter (1-4 Hz)')
                            
                            
                            %% Delta z
                            subplot(5, 2, 6)
                            hold on
                            offset = 0;
                            for j = 1:nCh
                                %plot(t, DataSeg_LF(j,:) +offset);
                                plot(t, deltaZ(:,j) +offset);
                                %plot(env(:,j)+offset);
                                offset = offset +5;
                            end
                            
                            ylim([-5 40])
                            title('Z-Scored delta envelope')
                            disp('')
                            
                            
                            %% ripple LFP
                            figure(104);
                            subplot(5, 2, 8)
                            
                            offset = 0;
                            for j = 1:nCh
                                hold on
                                %plot(t, DataSeg_LF(j,:) +offset);
                                plot(t, rippleLFP(:,j) +offset);
                                %plot(env(:,j)+offset);
                                offset = offset +100;
                            end
                            
                            ylim([-100 700])
                            title('Ripple Filter')
                            disp('')
                            
                            %% Ripple Z
                            subplot(5, 2, 10)
                            hold on
                            offset = 0;
                            for j = 1:nCh
                                %plot(t, DataSeg_LF(j,:) +offset);
                                plot(t, rippleZ(:,j) +offset);
                                %plot(env(:,j)+offset);
                                offset = offset +5;
                            end
                            ylim([-5 35])
                            title('Z-Scored Ripple envelope')
                            disp('')
%}
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Ripple Detection

RippleDetectThresh = 0.9;
RipplePeak = 0.9;        % peak threshold
minRippleDur = 0.01;         % 10 ms% 10 ms
maxRippleDur = 0.150;         % 120 ms

%% Detect candidate ripple periods
%candidate = rippleZ > RippleDetectThresh;
meanRippleZ = mean(rippleZ, 2);
candidate = meanRippleZ > RippleDetectThresh;
%{
                                                        figure(105); clf
                                                        subplot(2, 1, 1)
                                                        plot(sumRippleZ)
                                                        subplot(2, 1, 2)
                                                        plot(mean(rippleZ, 2))
%}
%% Duration constraints
minFrames = round(minRippleDur*fs);
maxFrames = round(maxRippleDur*fs);

cleanMask = false(size(candidate));

for ch = 1:nCh
    %for ch = 1
    
    %d = diff([0; candidate(:,ch); 0]);
    d = diff([0; candidate; 0]);
    starts = find(d==1);
    ends = find(d==-1)-1;
    
    for i = 1:length(starts)
        
        dur = ends(i)-starts(i)+1;
        
        if dur >= minFrames && dur <= maxFrames
            
            if max(meanRippleZ(starts(i):ends(i),ch)) > RipplePeak
                
                cleanMask(starts(i):ends(i),ch) = true;
                
            end
            
        end
        
    end
    
end

%% Multi-channel coincidence
activeChannels = sum(cleanMask,2);
minChannels = 1; % defines how many channels need to have ripples, can also be 1
rippleMask = activeChannels >= minChannels;

%% Extract ripple events
d = diff([0; rippleMask; 0]);
starts = find(d==1);
ends = find(d==-1)-1;

ripples.samples = [starts ends];
ripples.time = [starts ends] ./ fs;
ripples.dur = [ends - starts] ./ fs;
%% Compute ripple peaks
nEvents = size(starts,1);
ripples.peakTime = zeros(nEvents,1);
ripples.peakPower = zeros(nEvents,1);

for i = 1:nEvents
    
    seg = rippleZ(starts(i):ends(i),:);
    [peakPower, idx] = max(seg(:));
    
    rippleSample = starts(i) + mod(idx,size(seg,1)) - 1;
    
    ripples.peakTime(i) = rippleSample / fs;
    ripples.peakPower(i) = peakPower;
    
end


  %% Do some filtering out of double detections
peakTimeDiff = diff(ripples.peakTime);
smallDiffInds = find(peakTimeDiff < 0.1);
smallDiffInds_corrected = smallDiffInds+1; % make sure to take the correct onset
peakTimeAdj = ripples.peakTime;
peakTimeAdj(smallDiffInds_corrected) = [];

%%
%{
                            figure(107)
                            subplot(3, 1, 3)
                            %                             plot(t, deltaZ(:,1))
                            %                             hold on
                            %                             plot(t, meanRippleZ)
                            %
                            hold on
                            for i = 1:size(peakTimeAdj,1)
                                xline(peakTimeAdj(i,1),'k', 'linestyle', '-');
                            end
                            
                            subplot(3, 1, 1)
                            %                             plot(t, deltaZ(:,1))
                            %                             hold on
                            %                             plot(t, meanRippleZ)
                            %
                            hold on
                            for i = 1:size(peakTimeAdj,1)
                                xline(peakTimeAdj(i,1),'k', 'linestyle', '-');
                            end
                         
%}
%% If this looks ok, then change them all
ripples.peakTime(smallDiffInds_corrected) = [];
ripples.peakPower(smallDiffInds_corrected) = [];
ripples.time(smallDiffInds_corrected,:) = [];
ripples.dur(smallDiffInds_corrected,:) = [];

