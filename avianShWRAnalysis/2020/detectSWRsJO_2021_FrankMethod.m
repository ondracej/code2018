function [] = detectSWRsJO_2021_FrankMethod()


%SessionDir = 'G:\SWR\ZF-60-88\20190429\15-48-05\Ephys\'; % need dirdelim at end
%rippleChans = [2 7 13 12 11 1 16 3 6 4 5];

%SessionDir = 'G:\SWR\ZF-72-96\20200108\14-03-08\Ephys\';
%rippleChans = [1 5 11 14 4 8 7 9];

SessionDir = 'G:\SWR\ZF-71-76\20190916\18-05-58\Ephys\';
rippleChans = [15 14 12 7 2 5];
%k=2001

artifactThresh_pos = 600;
artifactThresh_neg = -800;

%chanMap = [7 10 2 15 3 14 4 13 1 16 5 12 6 11 8 9];
%chanMap = [13 1 16 5 12 6 11 8 9];

%chanMap = [5 4 6 3 9 16 8 1 11 14 12 13 10 15 7 2];

%chanMap = [10 12 7 11 9 6 8 5 3 16 4 1 13 15 14 2];
%chanMap = [10 12 7 11 9 6 8 5 3 16 4 13 15 14 2];%remove chan 1 broken
ch = rippleChans;
%ch = 7;
%%
[filepath,name,ext] = fileparts(SessionDir);

plotDir = [filepath '\Detections\'];

if exist(plotDir, 'dir') == 0
    mkdir(plotDir);
    disp(['Created: '  plotDir])
end

doPlot = 1;

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
SWFil = [.5 4];


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

nCycles = numel(TOn);
if nCycles >20
    nTestSegments  = round(nCycles*.33);
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
        %figure(105); plot(sumData)
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
     DataSeg_SW = fobj.filt.SW2.getFilteredData(DataSeg_DS); % downsampled data --> SW Filter
    
    squared_SW = squeeze(DataSeg_SW).^2;
    summed_SW = sum(squared_SW);
    sqrt_SW{i} = sqrt(summed_SW);
    
     %{
        figure; subplot(4, 1, 1)
        plot(squeeze(DataSeg_SW(1,:,:))); axis tight
        subplot(4, 1, 2)
        plot(squared_SW(1,:)); axis tight
        subplot(4, 1, 3)
        plot(summed_SW); axis tight
        subplot(4, 1, 4)
        plot(sqrt_SW{i}); axis tight
    %}
    
    
end

powerTrace_rip_sample = cell2mat(powerTrace_rip);
[Z_sample_rip,mean_sample_rip,std_sample_rip]= zscore(powerTrace_rip_sample);
mean_zscore_powerTrace_sample = mean(Z_sample_rip);

SW_sum_sample = cell2mat(sqrt_SW);
[Z_sample_sw,mean_sample_sw,std_sample_sw]= zscore(SW_sum_sample);
mean_zscore_sw_sample = mean(Z_sample_sw);


%figure; plot(powerTrace_rip_sample(1:60*Fss))

%% Now collect samples

seg_s= 18; % 2 second overlap
seg_ms= 20*1000;
TOn = 1:seg_s*1000:recordingDur_s*1000; % Needs to be in ms

for k=1:numel(TOn)-1
    allArtInds  = [];
  
    [rawData,t_ms]=dataRecordingObj.getData(ch,TOn(k), seg_ms);
    
    DataSeg_DS = fobj.filt.F2.getFilteredData(rawData); % raw data --> down sampled
    DataSeg_BP = fobj.filt.BP1.getFilteredData(DataSeg_DS); % down sampled  --> band passed
       
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
   
    
    DataSeg_SW = fobj.filt.SW2.getFilteredData(DataSeg_DS); % down sampled  --> sharp wave
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
    
    squared_SW = squeeze(DataSeg_SW).^2;
    summed_SW = sum(squared_SW);
    sqrt_SW = sqrt(summed_SW);
    
    %zscore_SW = (summed_SW - mean_sample_sw) / std_sample_sw;
    zscore_SW = (sqrt_SW - mean_sample_sw) / std_sample_sw;
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
    plot(summed_rip); axis tight
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
    plot(summed_SW); axis tight
    ylim([0 5e5])
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
            line([RipLOnset RipLOnset], [-15 15], 'color', 'r')
            line([RipROffset RipROffset], [-15 15], 'color', 'r')
            
            subplot(5, 1, 3)
            line([RipLOnset RipLOnset], [0 6], 'color', 'r')
            line([RipROffset RipROffset], [0 6], 'color', 'r')
            
            subplot(5, 1, 1)
            line([RipLOnset RipLOnset], [-400 200], 'color', 'r')
            line([RipROffset RipROffset], [-400 200], 'color', 'r')
            
            AllRippleDetections(j,1) = RipLOnset;
            AllRippleDetections(j,2) = thisPeak;
            AllRippleDetections(j,3) = RipROffset;
        end
        
        AllRippleDetections_abs{k} = AllRippleDetections+TOn(k)/1000*Fss;
        %  AllRippleDetections_rel{k} = AllRippleDetections(:,:);
        %   RippleDurations{k} = (AllRippleDetections(:,3) - AllRippleDetections(:,1))/Fss;
    else
        AllRippleDetections_abs{k} = [];
        %   AllRippleDetections_rel{k} = [];
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
            
            subplot(5, 1, 5)
            line([SwLOnset SwLOnset], [0 6], 'color', 'g')
            line([SwROffset SwROffset], [0 6], 'color', 'g')
            
            
            AllSWDetections(j,1) = SwLOnset;
            AllSWDetections(j,2) = thisPeak;
            AllSWDetections(j,3) = SwROffset;
        end
        
        
        AllSWDetections_abs{k} = AllSWDetections+TOn(k)/1000*Fss;
        % AllSWDetections_rel{k} = AllSWDetections;
        %  SWDurations{k} = (AllSWDetections(:,3) - AllSWDetections(:,1))/Fss;
        
    else
        AllSWDetections_abs{k} = [];
        %AllSWDetections_rel{k} = [];
        %  SWDurations{k} = [];
    end
    
    
    %%
    if doPlot
        
        plot_filename = [plotDir 'SWR-' sprintf('%03d', k)];
        
        plotpos = [0 0 25 15];
        print_in_A4(0, plot_filename, '-djpeg', 0, plotpos);
        %print_in_A4(0, plot_filename, '-depsc', 0, plotpos);
    end
    
    allArtifacts_abs{k} = allArtInds+TOn(k)/1000*Fss;
end

D.AllRippleDetections_abs = AllRippleDetections_abs;
%D.AllRippleDetections_rel = AllRippleDetections_rel;
%D.RippleDurations = RippleDurations;
D.AllSWDetections_abs = AllSWDetections_abs;
D.allArtifacts_abs = allArtifacts_abs;

%D.AllSWDetections_rel = AllSWDetections_rel;
%D.SWDurations = SWDurations;

DetectionSaveName = [plotDir '__SWR-Detections.mat'];
save(DetectionSaveName, 'D');

disp(['Saved:' DetectionSaveName ])

end



