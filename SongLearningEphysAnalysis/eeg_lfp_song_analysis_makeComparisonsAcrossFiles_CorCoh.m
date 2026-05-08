function [] = eeg_lfp_song_analysis_makeComparisonsAcrossFiles_CorCoh()


NegDir = 'G:\Dropbox\02_talks\2026\EBM\Datasets\NegEV\';
PosDir = 'G:\Dropbox\02_talks\2026\EBM\Datasets\posEV\';

%% delta/gamma files
NegLFPfiles = {'chronic_2021-07-30_20-54-58_allLFP_dyData-7' , 'chronic_2021-08-12_21-55-12_allLFP_dyData-6', 'chronic_2021-08-05_22-06-10_allLFP_dyData-7', 'chronic_2021-07-31_21-50-14_allLFP_dyData-7'};
NegFiles = {'chronic_2021-07-30_20-54-58_CorCoh-7' , 'chronic_2021-08-12_21-55-12_CorCoh-6', 'chronic_2021-08-05_22-06-10_CorCoh-7', 'chronic_2021-07-31_21-50-14_CorCoh-7'};
%NegFiles = {'chronic_2021-07-30_20-54-58_allLFP_dyData-7' , 'chronic_2021-08-12_21-55-12_allLFP_dyData-6', 'chronic_2021-07-31_21-50-14_allLFP_dyData-7'};
PosFiles = {'chronic_2021-07-16_19-14-55_CorCoh-7', 'chronic_2021-07-26_21-35-23_CorCoh-7', 'chronic_2021-08-11_20-48-49_CorCoh-6', 'chronic_2021-07-17_21-27-58_CorCoh-7', 'chronic_2021-07-18_21-43-38_CorCoh-7'};
PosLFPfiles = {'chronic_2021-07-16_19-14-55_allLFP_dyData-7', 'chronic_2021-07-26_21-35-23_allLFP_dyData-7', 'chronic_2021-08-11_20-48-49_allLFP_dyData-6', 'chronic_2021-07-17_21-27-58_allLFP_dyData-7', 'chronic_2021-07-18_21-43-38_allLFP_dyData-7'};
nRounds = 2;

for j = 1:nRounds
    
    switch j
        case 1
            lab = 'Large \Delta EV';
            nFiles= numel(NegFiles);
            dataDir = NegDir;
            files = NegFiles;
            lfpFiles = NegLFPfiles;
        case 2
            lab = 'Small \Delta EV';
            nFiles= numel(PosFiles);
            dataDir = PosDir;
            files = PosFiles;
            lfpFiles = PosLFPfiles;
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
        c =  load([dataDir files{k}]);
        d = load([dataDir lfpFiles{k}]);
        corrs = c.CORCOH.corrR;
        cohDelta = c.CORCOH.deltaCOH;
        cohGamma = c.CORCOH.gammaCOH;
        chanComparisons = c.CORCOH.corrR_chanNames;
        
        corrsInds = find(corrs{1,1} ~=0);
      
        corrVals = [];
        for o = 1:numel(corrs)
            if ~isempty(corrs{1,o})
                corrVals(:,o) = corrs{1,o}(corrsInds); % reads across the rows
            else
                corrVals(:,o) = NaN; % reads across the rows
            end
        end
        
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
        
        corrVals_Nan = corrVals;
        
        
        corrVals_Nan(:, artifactInds_toAnalyze) = NaN;
        
        medianCorrs = nanmedian(corrVals, 2);
        
        
        nanmedianCorrs = nanmedian(corrVals_Nan, 2);
        varCorr(k) = var(nanmedianCorrs);
        
        allMedianCorrs(k) = median(nanmedianCorrs);
        
        
    end
    
    NegAndPos_MedianDeltaMedian(:,j) = MedianDeltaMedian;
    NegAndPos_MedianGammaMedian(:,j) = MedianGammaMedian;
    
    NegAndPos_MedianDeltaMedian_sem(:,j) = MedianDeltaSEM;
    NegAndPos_MedianGammaMedian_sem(:,j) = MedianGammaSEM;
    
end

[h,p] = ranksum(NegAndPos_MedianDeltaMedian(:,1), NegAndPos_MedianDeltaMedian(:,2))




disp('')
end




