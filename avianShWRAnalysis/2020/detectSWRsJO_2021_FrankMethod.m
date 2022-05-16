function [] = detectSWRsJO_2021_FrankMethod()


addpath(genpath('C:\Users\Neuropix\Documents\GitHub\code2018\'));
addpath(genpath('C:\Users\Neuropix\Documents\GitHub\NeuralElectrophysilogyTools\'));

%SessionDir = 'G:\SWR\ZF-60-88\20190429\15-48-05\Ephys\'; % need dirdelim at end
%rippleChans = [2 7 13 12 11 1 16 3 6 4 5];

isChronic = 1;
doPlot = 1;
%% 72-01

%SessionDir = 'Z:\JanieData\JanieSpikeSorting\ZF-72-01\20210225_15-05-52\Ephys\';
%SessionDir = 'G:\SWR\ZF-72-01\20210225\15-18-05\Ephys\';
%rippleChans = [7 8 4 14 11];

%SessionDir = 'G:\SWR\ZF-72-01\20210225\16-15-23\Ephys\';
%rippleChans = [10 9 8 14 5 2];

%SessionDir = 'G:\SWR\ZF-72-01\20210225\16-44-46\Ephys\';
%rippleChans = [10 12 7 11];

%SessionDir = 'G:\SWR\ZF-72-01\20210225\17-21-11\Ephys\';
%rippleChans = [6 12 16 9 15];

%SessionDir = 'G:\SWR\ZF-72-01\20210225\17-42-17\Ephys\';
%rippleChans = [10 9 3 13 12];

%% o3b7 chronic

%SessionDir = 'G:\SWR\ZF-o3b7\20200116\18-21-31\Ephys\';
%rippleChans = [11 8 9];
%s_ToLightOff = 5909;

% SessionDir = 'G:\SWR\ZF-o3b7\20200117\17-56-38\Ephys\';
% rippleChans = [11 8 9];
% s_ToLightOff = 7402 ;

%SessionDir = 'G:\SWR\ZF-o3b7\20200118\19-50-48\Ephys\';
%rippleChans = [11 8 9];
%s_ToLightOff = 552;

%SessionDir = 'G:\SWR\ZF-o3b7\0200125\18-01-36\Ephys\';
%rippleChans = [11 8 9];
%s_ToLightOff = 7104;

%SessionDir = 'G:\SWR\ZF-o3b7\20200128\19-37-53\Ephys\';
%rippleChans = [11 8 9];
%s_ToLightOff = 1365;

%SessionDir = 'G:\SWR\ZF-o3b7\20200203\18-41-49\Ephys\';
%rippleChans = [11 8 9];
%s_ToLightOff = 4691;

%% 72-96

%SessionDir = 'G:\SWR\ZF-72-96\20200108\13-57-02\Ephys\';
%SessionDir = 'G:\SWR\ZF-72-96\20200108\14-03-08\Ephys\';
%rippleChans = [7 8 14 11 ];

%% 71-76 chronic

%SessionDir = 'G:\SWR\ZF-71-76_Final\20190919\17-51-46\Ephys\';
% SessionDir = 'G:\SWR\ZF-71-76_Final\20190920\18-37-00\Ephys\';
% rippleChans = [7 10 2];
% s_ToLightOff = 4980;

% SessionDir = 'G:\SWR\ZF-71-76_Final\20190919\17-51-46\Ephys\';
% rippleChans = [7 10 2];
% s_ToLightOff = 7694;

% SessionDir = 'G:\SWR\ZF-71-76_Final\20190917\16-05-11\Ephys\';
% rippleChans = [7 10 2];
% s_ToLightOff = 14089;

%SessionDir = 'G:\SWR\ZF-71-76_Final\20190916\18-05-58\Ephys\';
%rippleChans = [7 10 2];
%s_ToLightOff = 6842;

% SessionDir = 'G:\SWR\ZF-71-76_Final\20190923\18-21-42\Ephys\';
% rippleChans = [7 10 2];
% s_ToLightOff = 5898;


%% w044
 %SessionDir = 'H:\HamedsData\w042_w044\w044\chronic_2022-01-01_20-26-41\Ephys\';
 %rippleChans = [9 10 11];
 %s_ToLightOff = 1999;
 
%% w027

 SessionDir = 'H:\HamedsData\w025_w027\w027\chronic_2021-08-04_22-02-26\Ephys\';
 rippleChans = [49 50];
 s_ToLightOff = 21142;


%%
%SessionDir = 'G:\SWR\ZF-72-96\20200108\14-03-08\Ephys\';
%rippleChans = [1 5 11 14 4 8 7 9];


%SessionDir = 'G:\SWR\ZF-71-76\20190916\18-05-58\Ephys\';
%rippleChans = [15 14 12 7 2 5];
%SW_Chan = 15;

%SW_ind = find(rippleChans == SW_Chan);
%k=2001

%Adults
%artifactThresh_pos = 600;
%artifactThresh_neg = -800;

%juveiles
artifactThresh_pos = 500;
artifactThresh_neg = -300;

%artifactThresh_pos = 600;
%artifactThresh_neg = -1600;

%chanMap = [7 10 2 15 3 14 4 13 1 16 5 12 6 11 8 9];
%chanMap = [13 1 16 5 12 6 11 8 9];

%chanMap = [5 4 6 3 9 16 8 1 11 14 12 13 10 15 7 2];

%chanMap = [10 12 7 11 9 6 8 5 3 16 4 1 13 15 14 2];
%chanMap = [10 12 7 11 9 6 8 5 3 16 4 13 15 14 2];%remove chan 1 broken
ch = rippleChans;
%ch = 7;
%%
[filepath,name,ext] = fileparts(SessionDir);

endout=regexp(SessionDir,filesep,'split');
birdName = endout{4};
RecSession = endout{5};

plotDir = [filepath '\Detections\'];

if exist(plotDir, 'dir') == 0
    mkdir(plotDir);
    disp(['Created: '  plotDir])
end



%dataDir = obj.DIR.ephysDir;

dataRecordingObj = OERecordingMF(SessionDir);
dataRecordingObj = getFileIdentifiers(dataRecordingObj); % creates dataRecordingObject

Fs_orig = dataRecordingObj.samplingFrequency;
recordingDur_ms = dataRecordingObj.recordingDuration_ms;
recordingDur_s = recordingDur_ms/1000;


%%
%https://elifesciences.org/articles/64505#s4
%Sharp wave ripples were detected using the same method as in Kay et al., 2016. Each CA1 LFP was obtained by downsampling the original
%30 kHz electrical potential to 1.5 kHz and bandpass filtering between 0.5 Hz and 400 Hz. This was further bandpass filtered for the ripple
%band (150–250 Hz), squared, and then summed across tetrodes—forming a single population trace over time. This trace was smoothed with a
%Gaussian with a 4 ms standard deviation and the square root of this trace was taken to get an estimate of the population ripple band power.
%Candidate SWR times were found by z-scoring the population power trace of an entire recording session and finding times when the z-score
%exceeded two standard deviations for a minimum of 15 ms and the speed of the animal was less than 4 cm/s. The SWR times were then extended before
%and after the threshold crossings to include the time until the population trace returned to the mean value. The code used for ripple detection
%can be found at https://github.com/Eden-Kramer-Lab/ripple_detection (Denovellis, 2021b). We only analyzed SWRs with spikes from at least two tetrodes.


DS_Factor = 20;
% bandPassFilter1 = [.5 400];
% Ripple = [150 250];
% SWFil = [.5 8];

bandPassFilter1 = [1 400];
Ripple = [6 150];
SWFil = [.5 4]; %not using this...


fObj = filterData(Fs_orig);

fobj.filt.F2=filterData(Fs_orig);
fobj.filt.F2.downSamplingFactor=DS_Factor; % original is 128 for 32k for sampling rate of 250
fobj.filt.F2=fobj.filt.F2.designDownSample;
fobj.filt.F2.padding=true;
fobj.filt.F2Fs=fobj.filt.F2.filteredSamplingFrequency;

Fss = fobj.filt.F2Fs;

%BandPass 1
fobj.filt.BP1=filterData(Fss);
fobj.filt.BP1.highPassCutoff=bandPassFilter1(1);
fobj.filt.BP1.lowPassCutoff=bandPassFilter1(2);
fobj.filt.BP1.filterDesign='butter';
fobj.filt.BP1=fobj.filt.BP1.designBandPass;
fobj.filt.BP1.padding=true;

%BandPass 1
fobj.filt.Rip1=filterData(Fss);
fobj.filt.Rip1.highPassCutoff=Ripple(1);
fobj.filt.Rip1.lowPassCutoff=Ripple(2);
fobj.filt.Rip1.filterDesign='butter';
fobj.filt.Rip1=fobj.filt.Rip1.designBandPass;
fobj.filt.Rip1.padding=true;

fobj.filt.SW1=filterData(Fss);
fobj.filt.SW1.highPassCutoff=SWFil(1);
fobj.filt.SW1.lowPassCutoff=SWFil(2);
fobj.filt.SW1.filterDesign='butter';
fobj.filt.SW1=fobj.filt.SW1.designBandPass;
fobj.filt.SW1.padding=true;

% Original SW filter
fobj.filt.SW2=filterData(Fss);
fobj.filt.SW2.lowPassPassCutoff=30;% this captures the LF pretty well for detection
fobj.filt.SW2.lowPassStopCutoff=40;
fobj.filt.SW2.attenuationInLowpass=20;
fobj.filt.SW2=fobj.filt.SW2.designLowPass;
fobj.filt.SW2.padding=true;
            
fobj.filt.FN =filterData(Fss);
fobj.filt.FN.filterDesign='cheby1';
fobj.filt.FN.padding=true;
fobj.filt.FN=fobj.filt.FN.designNotch;


%% Get a sample size for the population z score calculation

smoothWin_ms = 15;
smoothWin_sampls = round((smoothWin_ms/1000)*Fss);


seg_s= 20;
seg_ms = seg_s*1000;

TOn=1:seg_s*1000:(recordingDur_s*1000);

if isChronic
    nSegsToDark = round(s_ToLightOff/seg_s);
    darkSession_s = 43200;
    nSegsDarkSession = darkSession_s/ seg_s;
    TOn = TOn(nSegsToDark:nSegsToDark+nSegsDarkSession-1);
end

nCycles = numel(TOn);
if nCycles >20
    nTestSegments  = round(nCycles*.33);
else
    nTestSegments = round(nCycles*0.33);
end

rng(1); % for reproducibiity
pCycle=sort(randperm(nCycles,nTestSegments));


powerTrace_rip = []; sqrt_SW = [];
for i=1:numel(pCycle)
    
    
    [rawData,t_ms]=dataRecordingObj.getData(ch,TOn(pCycle(i)), seg_ms);
    DataSeg_DS = fobj.filt.F2.getFilteredData(rawData); % raw data --> downsampled data
    DataSeg_BP = fobj.filt.BP1.getFilteredData(DataSeg_DS); % downsampled data --> band passed data
     
    sumData = (sum(squeeze(DataSeg_BP)))/ numel(ch); % The sum will be huge numbers
    
    artifactPosCheck = sum(sumData > artifactThresh_pos);
    artifactNegCheck = sum(sumData < artifactThresh_neg);
    
    if artifactPosCheck || artifactNegCheck
        disp('Artifact Detected')
        %keyboard
        % figure(105); plot(sumData)
        continue
    end
    
   
    DataSeg_BP_N = fobj.filt.FN.getFilteredData(DataSeg_BP); % band passed data --> notch filtered data
    
%     bla = squeeze(rawData);
%     figure(105); clf
%     subplot(2, 1, 1)
%     plot(bla(3,:)); axis tight
%     subplot(2, 1, 2)
%     plot(squeeze(DataSeg_BP_N(1,:,:))); axis tight
%  
    DataSeg_Ripp = fobj.filt.Rip1.getFilteredData(DataSeg_BP_N); % notch filted data --> ripple filter
    
    squared_rip = squeeze(DataSeg_Ripp).^2;
    summed_rip = sum(squared_rip);
    smoothedSums2 = smoothdata(summed_rip, 'gaussian', smoothWin_sampls);
    %smoothedSums2 = smooth(summed_rip, smoothWin_sampls);
    
    powerTrace_rip{i} = sqrt(smoothedSums2);
    
    %{
        figure; subplot(4, 1, 1)
        plot(squeeze(DataSeg_Ripp(1,:,:))); axis tight
        subplot(4, 1, 2)
        plot(squared_rip(1,:)); axis tight
        subplot(4, 1, 3)
        plot(summed_rip); axis tight
        subplot(4, 1, 4)
        plot(powerTrace_rip{i}); axis tight
    %}
    
    %  Here it does not help very much to combine the diff channels, so
    %  lets rather pick one chanel and do the SW detection from that
    
   
    
     %DataSeg_SW = squeeze(fobj.filt.SW2.getFilteredData(DataSeg_DS)); % downsampled data --> SW Filter original
     DataSeg_SW{i} = squeeze(fobj.filt.SW2.getFilteredData(DataSeg_BP)); % downsampled data --> SW Filter original
   
end

%      for q = 1:size(DataSeg_SW, 1)
%          allMins(q) = min(DataSeg_SW(q,:));
%      end
%      
%      [minVal, minChanInd] = min(allMins);
%   

allCHans = cell2mat(DataSeg_SW);
squaredAllSW = allCHans.^2;
sqrtAllSW = sqrt(squaredAllSW);
[maxVal, ~] = max(sqrtAllSW, [], 2);
[maxVal2, SW_ind] = max(maxVal, [], 1);

sqrt_SW = sqrtAllSW(SW_ind,:);

   %  DataSeg_SW_negChan =  DataSeg_SW(SW_ind,:);
    
    % squared_SW = DataSeg_SW_negChan.^2;
     
    %squared_SW = squeeze(DataSeg_SW).^2;
    %summed_SW = sum(squared_SW);
    %sqrt_SW{i} = sqrt(squared_SW);
    
    
     %{
        figure(104); clf;
        subplot(4, 1, 1)
        plot(squeeze(DataSeg_SW_negChan(1,:,:))); axis tight
        title('raw SW data')
        subplot(4, 1, 2)
        plot(squared_SW(1,:)); axis tight
        title('squared SW data')
        %subplot(4, 1, 3)
        %plot(summed_SW); axis tight
        %title('summed SW data')
        subplot(4, 1, 4)
        plot(sqrt_SW{i}); axis tight
        title('sqrt SW data')
    %}
    
    
%end

powerTrace_rip_sample = cell2mat(powerTrace_rip);
[Z_sample_rip,mean_sample_rip,std_sample_rip]= zscore(powerTrace_rip_sample);
mean_zscore_powerTrace_sample = mean(Z_sample_rip);

%SW_sum_sample = cell2mat(sqrt_SW);
%SW_sum_sample = cell2mat(DataSeg_SW_negChan);
[Z_sample_sw,mean_sample_sw,std_sample_sw]= zscore(sqrt_SW);
mean_zscore_sw_sample = mean(Z_sample_sw);


%figure; plot(powerTrace_rip_sample(1:60*Fss))
%figure; plot(Z_sample_sw(1:20*Fss))

%% Now collect samples

seg_s= 18; % 2 second overlap
seg_ms= 20*1000;
TOn = 1:seg_s*1000:recordingDur_s*1000; % Needs to be in ms

if isChronic
    nSegsToDark = round(s_ToLightOff/seg_s);
    darkSession_s = 43200;
    nSegsDarkSession = darkSession_s/ seg_s;
    TOn = TOn(nSegsToDark:nSegsToDark+nSegsDarkSession-1);
end

for k=1:numel(TOn)-1
    allArtInds  = [];
  
    [rawData,t_ms]=dataRecordingObj.getData(ch,TOn(k), seg_ms);
    
    DataSeg_DS = fobj.filt.F2.getFilteredData(rawData); % raw data --> down sampled
    [DataSeg_BP tds] = fobj.filt.BP1.getFilteredData(DataSeg_DS); % down sampled  --> band passed
       
    %Artifacts
    sumData = (sum(squeeze(DataSeg_BP)))/ numel(ch); % The sum will be huge numbers
    
    artifactPosCheck = sum(sumData > artifactThresh_pos);
    artifactNegCheck = sum(sumData < artifactThresh_neg);
    
    if artifactPosCheck || artifactNegCheck
        disp('Artifact Detected')
        %keyboard
        % figure(130); plot(sumData)
        
        artsPos = find(sumData > artifactThresh_pos);
        artsNeg = find(sumData < artifactThresh_neg);
        allArtInds = sort([artsPos  artsNeg]);
        
    end
    
 
    DataSeg_BP_N = fobj.filt.FN.getFilteredData(DataSeg_BP); % band passed --> notch filtered
    
    DataSeg_Ripp = fobj.filt.Rip1.getFilteredData(DataSeg_BP_N); % notch filter --> rippled
    
    squared_rip = squeeze(DataSeg_Ripp).^2;
    summed_rip = sum(squared_rip);
    smoothedSums2 = smoothdata(summed_rip, 'gaussian', smoothWin_sampls);
    %smoothedSums2 = smooth(summed_rip, smoothWin_sampls);
    
    powerTrace_rip = sqrt(smoothedSums2);
    
    zscore_rip = (powerTrace_rip - mean_sample_rip) / std_sample_rip;
    zscore_rip(allArtInds) = 1e-15;
    
    %zscore_ripOld = zscore(powerTrace_rip);
    %mean_zscore_rip = mean(zscore_rip);
    %median_zscore_rip = median(zscore_rip);
    
    %squared_SW = squeeze(DataSeg_SW).^2;
    %summed_SW = sum(squared_SW);
    %sqrt_SW = sqrt(summed_SW);
    
    %zscore_SW = (summed_SW - mean_sample_sw) / std_sample_sw;
    
    DataSeg_SW = squeeze(fobj.filt.SW2.getFilteredData(DataSeg_BP)); % down sampled  --> sharp wave
    
    DataSeg_SW_negChan =  DataSeg_SW(SW_ind,:);
    squared_SW = DataSeg_SW_negChan.^2;
    sqrt_SW = sqrt(squared_SW);
    
    zscore_SW = (sqrt_SW - mean_sample_sw) / std_sample_sw;
    %zscore_SW = zscore(DataSeg_SW_minChan);
    zscore_SW(allArtInds) = 1e-15;
    %%
    figure(100); clf;
    
    subplot(5, 1, 1)
    plot(squeeze(DataSeg_BP(1,:,:))); axis tight
    hold on
    yvals = zeros(1, numel(allArtInds));
    plot(allArtInds, yvals, 'k.')
    ylim([-500 400])
    title('BP Raw Data')
    
    %     subplot(5, 1, 2)
    %     plot(squeeze(DataSeg_Ripp(1,:,:))); axis tight
    %     ylim([-25 25])
    
    subplot(5, 1, 2)
    plot(tds/1000, summed_rip); axis tight
    ylim([0 3e4])
    title('Summed Ripple Population')
    %plot(hi)
    %[hi, lo] = envelope(summed_rip);
    
    subplot(5, 1, 3)
    plot(zscore_rip); axis tight
    line([0 30000], [mean_zscore_powerTrace_sample mean_zscore_powerTrace_sample], 'color', 'k')
    ylim([0 5])
    title('Population Ripple Z-score')
    
    %     subplot(5, 1, 4)
    %     plot(squeeze(DataSeg_SW(1,:,:))); axis tight
    %     ylim([-600 300])
    
    subplot(5, 1, 4)
    plot(DataSeg_SW_negChan); axis tight
    %ylim([0 5e5])
    title('Summed Population SW')
    
    subplot(5, 1, 5)
    plot(zscore_SW); axis tight
    ylim([0 4])
    title('Population SW Z-Score')
    %%  Ripple Detections
    
    minWidth_ms = 10;
    midWidth_samples = round(minWidth_ms/1000*Fss);
    thresh = 2;
    
    subplot(5, 1, 3)
    line([0 30000], [thresh thresh], 'color', 'r')
    
    peakDistance_ms = 100;
    peakDistance_sample = round(peakDistance_ms/1000*Fss);
    
    [pks_r,locs_r,w_r,p_r] = findpeaks(zscore_rip, 'MinPeakHeight', thresh, 'MinPeakWidth',  midWidth_samples, 'MinPeakDistance', peakDistance_sample );
    subplot(5, 1, 3)
    hold on
    plot(locs_r,pks_r,'ko')
    
    %% Find onsets and offsets of ripples
    nPeaks_rip = numel(locs_r);
    
    AllRippleDetections= [];
    
    if nPeaks_rip > 0
        searchWin_ms =  1200;
        searchWin_samples =  searchWin_ms/1000*Fss;
        % MAKE SURE TO MAKE THESE POINTS RELATIVE TO THE TON AT THE END!!!
        
        cnt_rip = 1;
        for j = 1:nPeaks_rip
            
            thisPeak = locs_r(j);
            
            if thisPeak <= searchWin_samples
                continue
            else
                ROI_l = zscore_rip(thisPeak-searchWin_samples: thisPeak);
            end
            
            rip_l_inds = find(ROI_l <= mean_zscore_powerTrace_sample);
            
            if isempty(rip_l_inds) % probably a case where there is an artifact
               % keyboard
                continue
            end
            
            maxVal = numel(ROI_l) - rip_l_inds(end); % the largest value will be the index closest to the peak detection (for l)
            
            RipLOnset = thisPeak-maxVal;
            
            if thisPeak+searchWin_samples >= numel(zscore_rip)
                continue
            else
                ROI_r = zscore_rip(thisPeak:thisPeak+searchWin_samples);
            end
            
            rip_r_inds = find(ROI_r <= mean_zscore_powerTrace_sample);
            
            if isempty(rip_r_inds) % probably a case where there is an artifact
               % keyboard
                continue
            end
            
            minVal = rip_r_inds(1); % the smallest value will be the index closest to the peak detection (for l)
            
            RipROffset = thisPeak+minVal;
            
            subplot(5, 1, 2)
            %line([RipLOnset RipLOnset], [-15 15], 'color', 'r')
            %line([RipROffset RipROffset], [-15 15], 'color', 'r')
            
            subplot(5, 1, 3)
            line([RipLOnset RipLOnset], [0 6], 'color', 'r')
            line([RipROffset RipROffset], [0 6], 'color', 'r')
            
            subplot(5, 1, 1)
            line([RipLOnset RipLOnset], [-400 200], 'color', 'r')
            line([RipROffset RipROffset], [-400 200], 'color', 'r')
            
            AllRippleDetections(cnt_rip ,1) = RipLOnset;
            AllRippleDetections(cnt_rip ,2) = thisPeak;
            AllRippleDetections(cnt_rip ,3) = RipROffset;
            cnt_rip = cnt_rip +1;
            
        end
        
        AllRippleDetections_abs{k} = AllRippleDetections*DS_Factor+TOn(k)/1000*Fss;
        AllRippleDetections_rel{k} = AllRippleDetections*DS_Factor;
        %   RippleDurations{k} = (AllRippleDetections(:,3) - AllRippleDetections(:,1))/Fss;
    else
        AllRippleDetections_abs{k} = [];
        AllRippleDetections_rel{k} = [];
        %   RippleDurations{k} = [];
        
    end
    
    
    %%  SW Detections
    
    minWidth_ms = 15;
    midWidth_samples = round(minWidth_ms*1000/Fss);
    thresh = 2;
    
    subplot(5, 1, 5)
    line([0 30000], [thresh thresh], 'color', 'r')
    
    peakDistance_ms = 200;
    peakDistance_sample = round(peakDistance_ms*1000/Fss);
    
    [pks_sw,locs_sw,w_sw,p_sw] = findpeaks(zscore_SW, 'MinPeakHeight', thresh, 'MinPeakWidth',  midWidth_samples, 'MinPeakDistance', peakDistance_sample );
    subplot(5, 1, 5)
    hold on
    plot(locs_sw,pks_sw,'bo')
    
    subplot(5, 1, 1)
    hold on
    plot(locs_sw,pks_sw,'rv')
    
    nPeaks_sw = numel(locs_sw);
    
    AllSWDetections = [];
    
    if nPeaks_sw > 0
        
        searchWin_ms =  1200;
        searchWin_samples =  searchWin_ms/1000*Fss;
        
        cnt_sw = 1;
        for j = 1:nPeaks_sw
            
            thisPeak = locs_sw(j);
            
            % Check to see if peak val in original data is pos or negative
            
            DataSeg_SW_sq = squeeze(DataSeg_SW);
            maxPeakVal = max(DataSeg_SW_sq(:,thisPeak));
            
            if maxPeakVal > 0
                disp('Positive SW detected');
               % keyboard
                continue
            end
            
            if thisPeak <= searchWin_samples
                continue
            else
                ROI_l = zscore_SW(thisPeak-searchWin_samples: thisPeak);
            end
            
            sw_l_inds = find(ROI_l <= mean_zscore_sw_sample);
            if isempty(sw_l_inds) % probably a case where there is an artifact
              %  keyboard
                continue
            end
            maxVal = numel(ROI_l) - sw_l_inds(end); % the largest value will be the index closest to the peak detection (for l)
            
            SwLOnset = thisPeak-maxVal;
            
            if thisPeak+searchWin_samples >= numel(zscore_SW)
                continue
            else
                ROI_r = zscore_SW(thisPeak:thisPeak+searchWin_samples);
            end
            
            sw_r_inds = find(ROI_r <= mean_zscore_sw_sample);
            if isempty(sw_r_inds) % probably a case where there is an artifact
             %   keyboard
                continue
            end
            minVal = sw_r_inds(1); % the smallest value will be the index closest to the peak detection (for l)
            
            SwROffset = thisPeak+minVal;
            
            subplot(5, 1, 1)
            line([SwLOnset SwLOnset], [-400 200], 'color', 'g')
            line([SwROffset SwROffset], [-400 200], 'color', 'g')
            
            subplot(5, 1, 4)
            line([SwLOnset SwLOnset], [-200 100], 'color', 'g')
            line([SwROffset SwROffset], [-200 100], 'color', 'g')
            ylim([-500 250])
            
            subplot(5, 1, 5)
            line([SwLOnset SwLOnset], [0 6], 'color', 'g')
            line([SwROffset SwROffset], [0 6], 'color', 'g')
            ylim([0 6])
            
            AllSWDetections(cnt_sw,1) = SwLOnset;
            AllSWDetections(cnt_sw,2) = thisPeak;% samples
            AllSWDetections(cnt_sw,3) = SwROffset;
            cnt_sw = cnt_sw+1;
        end
        
        
        AllSWDetections_abs{k} = AllSWDetections*DS_Factor+TOn(k)/1000*Fss;
         AllSWDetections_rel{k} = AllSWDetections *DS_Factor;
        %  SWDurations{k} = (AllSWDetections(:,3) - AllSWDetections(:,1))/Fss;
        
    else
        AllSWDetections_abs{k} = [];
        AllSWDetections_rel{k} = [];
        %  SWDurations{k} = [];
    end
    
    
    %%
    if doPlot
        
        plot_filename = [plotDir 'SWR-' sprintf('%03d', k)];
        
        plotpos = [0 0 15 15];
        print_in_A4(0, plot_filename, '-djpeg', 0, plotpos);
        %print_in_A4(0, plot_filename, '-depsc', 0, plotpos);
    end
    
    allArtifacts_abs{k} = allArtInds+TOn(k)/1000*Fss;
end

D.AllRippleDetections_abs = AllRippleDetections_abs;
D.AllRippleDetections_rel = AllRippleDetections_rel;
%D.RippleDurations = RippleDurations;
D.AllSWDetections_abs = AllSWDetections_abs;
D.AllSWDetections_rel = AllSWDetections_rel;
D.allArtifacts_abs = allArtifacts_abs;
D.INFO.SessionDir = SessionDir;
D.INFO.rippleChans = rippleChans;
D.INFO.SWChan = rippleChans(SW_ind);
D.INFO.artifactThresh_pos = artifactThresh_pos;
D.INFO.artifactThresh_neg = artifactThresh_neg;
D.INFO.TOn = TOn;
D.INFO.seg_ms = seg_ms;
D.INFO.birdName = birdName;
D.INFO.RecSession = RecSession;

%D.AllSWDetections_rel = AllSWDetections_rel;
%D.SWDurations = SWDurations;

DetectionSaveName = [plotDir '__SWR-Detections.mat'];
save(DetectionSaveName, 'D');

disp(['Saved:' DetectionSaveName ])
disp(['SWR Channel:' num2str(D.INFO.SWChan) ])

end




