function [] = eeg_lfp_song_analysis_makeComparisonsAcrossFiles_allLFP_dyData()


NegDir = 'G:\Dropbox\02_talks\2026\EBM\Datasets\NegEV\';
PosDir = 'G:\Dropbox\02_talks\2026\EBM\Datasets\posEV\';

%% delta/gamma files

NegFiles = {'chronic_2021-07-30_20-54-58_allLFP_dyData-7' , 'chronic_2021-08-12_21-55-12_allLFP_dyData-6', 'chronic_2021-08-05_22-06-10_allLFP_dyData-7', 'chronic_2021-07-31_21-50-14_allLFP_dyData-7', 'chronic_2021-08-04_22-02-26_allLFP_dyData-7'};
%NegFiles = {'chronic_2021-07-30_20-54-58_allLFP_dyData-7' , 'chronic_2021-08-12_21-55-12_allLFP_dyData-6', 'chronic_2021-07-31_21-50-14_allLFP_dyData-7'};
PosFiles = {'chronic_2021-07-16_19-14-55_allLFP_dyData-7', 'chronic_2021-07-26_21-35-23_allLFP_dyData-7', 'chronic_2021-08-11_20-48-49_allLFP_dyData-6', 'chronic_2021-07-17_21-27-58_allLFP_dyData-7', 'chronic_2021-07-18_21-43-38_allLFP_dyData-7'};


nRounds = 2;

for j = 1:nRounds
    
    switch j
        case 1
            lab = 'Large \Delta EV';
            nFiles= numel(NegFiles);
            dataDir = NegDir;
            files = NegFiles;
        case 2
            lab = 'Small \Delta EV';
            nFiles= numel(PosFiles);
            dataDir = PosDir;
            files = PosFiles;
    end
    
    nHoursToAnalyze = 9;
            hoursAfterLightsOff = 2;
          MedianDeltaMedian = [];
        MedianDeltaStd = [];
        MedianDeltaSEM = [];
        
        MedianGammaMedian = [];
        MedianGammStd = [];
        MedianGammaSEM = [];
        
        allDeltaMedians = [];
        allDeltaNan_sem = [];
        
        allGammaMedians = [];
        allGammaNan_sem = [];
        
        
        allChans = [];
          
    for k = 1:nFiles
        d =  load([dataDir files{k}]);
        
        
        nChans = numel(d.D.chanNamesSet);
        
        timeWin_s = 20; %seconds
        tOn = d.D.tOn_s;
        
        bins_per_min = 60/timeWin_s;
        binsInHour = bins_per_min*60;
        analysisBins_cnt = nHoursToAnalyze*binsInHour;
        
        %% d/y
        
        %subplot(3, 1, 1)
        
        isArtifact = d.D.isArtifact;
        artifactInds = d.D.isArtifact; % identify where all the artifact files are
        
        LightsOff_min = d.INFO.totalDur_min_start_lightsOff;
        LightsOff_s_bins = LightsOff_min*bins_per_min; %3 bins per min for 20 s bins
        
        % 2 hours after lights off = 360, 20 s bins
        %1 min = 3 bins, 3*60 = 1 hr, 180*2  = 360
        onsetBins = LightsOff_s_bins+hoursAfterLightsOff*binsInHour; % 2 hours after lights off
        offsetBins = onsetBins+analysisBins_cnt;
        tOn_toAnalyze = tOn(onsetBins:offsetBins);
        artifactInds_toAnalyze = logical(artifactInds(onsetBins:offsetBins));
        
        %   minChannels = floor(nChans*.5);       % ripple must appear on >= channels
        nBinsToAnalyze = numel(tOn_toAnalyze);
        %
        %% delta
        
        chanNamesSet = d.D.chanNamesSet;
        deltaNan_median = [];deltaNan_sem = [];
        gammaNan_median = []; gammaNan_sem = [];
        Chans = [];
        for ss = 1:nChans
            
            
            deltaNan = d.D.bufferedDelta_median(ss,onsetBins:offsetBins);
            deltaNan(artifactInds_toAnalyze) = NaN;
            
            deltaNan_median(ss) = nanmedian(deltaNan);
            deltaNan_std = nanstd(deltaNan);
            nNonNan = sum(~isnan(deltaNan));
            deltaNan_sem(ss) =  deltaNan_std/(sqrt(nNonNan));
            
            
            gammaNan = d.D.bufferedDeltaGammaRatio_median(ss,onsetBins:offsetBins);
            gammaNan(artifactInds_toAnalyze) = NaN;
            
            gammaNan_median(ss) = nanmedian(gammaNan);
            gammaNan_std = nanstd(gammaNan);
            nNonNan = sum(~isnan(gammaNan));
            gammaNan_sem(ss) =  gammaNan_std/(sqrt(nNonNan));
     
               Chans{ss} = chanNamesSet{ss};
        end
     
        
        
        MedianDeltaMedian(k) = nanmedian(deltaNan_median);
        MedianDeltaStd(k) = nanstd(deltaNan_median);
        MedianDeltaSEM(k) = MedianDeltaStd(k) / sqrt(numel(deltaNan_median));
        
        MedianGammaMedian(k) = nanmedian(gammaNan_median);
        MedianGammStd(k) = nanstd(gammaNan_median);
        MedianGammaSEM(k) = MedianGammStd(k) / sqrt(numel(gammaNan_median));
        
        %allDeltaMedians(:,k) = deltaNan_median;
       % allDeltaNan_sem(:,k) = deltaNan_sem;
        
        
        %allGammaMedians(:,k) = gammaNan_median;
        %allGammaNan_sem(:,k) = gammaNan_sem;
        
        
        allChans{k} = Chans;
        
        
    end
    
    NegAndPos_MedianDeltaMedian(:,j) = MedianDeltaMedian;
    NegAndPos_MedianGammaMedian(:,j) = MedianGammaMedian;
    
    NegAndPos_MedianDeltaMedian_sem(:,j) = MedianDeltaSEM;
    NegAndPos_MedianGammaMedian_sem(:,j) = MedianGammaSEM;
    
end

[h,p] = ranksum(NegAndPos_MedianDeltaMedian(:,1), NegAndPos_MedianDeltaMedian(:,2))




disp('')
end




