function [] = eeg_lfp_song_analysis_makeComparisonsAcrossFiles_CorCoh()

% 
% NegDir = 'G:\Dropbox\02_talks\2026\EBM\Datasets\NegEV\';
% PosDir = 'G:\Dropbox\02_talks\2026\EBM\Datasets\posEV\';
% 
% %% delta/gamma files
% %NegLFPfiles = {'chronic_2021-07-30_20-54-58_allLFP_dyData-7' , 'chronic_2021-07-31_21-50-14_allLFP_dyData-7', 'chronic_2021-08-04_22-02-26_CorCoh-7', 'chronic_2021-08-05_22-06-10_allLFP_dyData-7', 'chronic_2021-08-12_21-55-12_allLFP_dyData-6'};
% NegFiles = {'chronic_2021-07-30_20-54-58_CorCoh-7' , 'chronic_2021-07-31_21-50-14_CorCoh-7', 'chronic_2021-08-04_22-02-26_CorCoh-7', 'chronic_2021-08-05_22-06-10_CorCoh-7', 'chronic_2021-08-12_21-55-12_CorCoh-6'};
% %NegFiles = {'chronic_2021-07-30_20-54-58_allLFP_dyData-7' , 'chronic_2021-08-12_21-55-12_allLFP_dyData-6', 'chronic_2021-07-31_21-50-14_allLFP_dyData-7'};
% PosFiles = {'chronic_2021-07-16_19-14-55_CorCoh-7', 'chronic_2021-07-17_21-27-58_CorCoh-7', 'chronic_2021-07-18_21-43-38_CorCoh-7', 'chronic_2021-07-26_21-35-23_CorCoh-7', 'chronic_2021-08-11_20-48-49_CorCoh-6', };
% %PosLFPfiles = {'chronic_2021-07-16_19-14-55_allLFP_dyData-7', 'chronic_2021-07-26_21-35-23_allLFP_dyData-7', 'chronic_2021-08-11_20-48-49_allLFP_dyData-6', 'chronic_2021-07-17_21-27-58_allLFP_dyData-7', 'chronic_2021-07-18_21-43-38_allLFP_dyData-7'};
% nRounds = 2;
% 
% 
% %%
% negages = [66 67 71 72 79];
% posages = [52 53 54 62 78];
% 
% [h, p] = ranksum(negages, posages)
% 
% figure(134); clf
% xes = ones(1,numel(negages));
% 
% plot(xes, negages, 'ko')
% hold on
% 
% plot(xes*2, posages, 'kd')
% hold on
% xlim([0 3])
% 
% ylabel ('Age (dph)')
% 
% 
%                
%                 plotpos = [0 0 18 10];
%                 plot_filename = [NegDir '__agestats'];
%                 print_in_A4(0, plot_filename, '-djpeg', 0, plotpos);
%                 print_in_A4(0, plot_filename, '-depsc', 0, plotpos);
%                 
% 
% 
% 
% for j = 1:nRounds
%     
%     switch j
%         case 1
%             lab = 'Large \Delta EV';
%             nFiles= numel(NegFiles);
%             dataDir = NegDir;
%             files = NegFiles;
%           %  lfpFiles = NegLFPfiles;
%         case 2
%             lab = 'Small \Delta EV';
%             nFiles= numel(PosFiles);
%             dataDir = PosDir;
%             files = PosFiles;
%            % lfpFiles = PosLFPfiles;
%     end
%     
%     nHoursToAnalyze = 9;
%             hoursAfterLightsOff = 2;
%             
%             
%             MedianDeltaMedian = [];
%             MedianDeltaStd = [];
%             MedianDeltaSEM = [];
%             
%             MedianGammaMedian = [];
%             MedianGammStd = [];
%             MedianGammaSEM = [];
%             
%             allDeltaMedians = [];
%             allDeltaNan_sem = [];
%             
%             allGammaMedians = [];
%             allGammaNan_sem = [];
%             
%         
%         allChans = [];
%           nanmedianCorrs = [];


CohDir = 'X:\EEG-LFP-songLearning\JaniesAnalysis\ALL_PLOTS\w025\All_LFP_dy\BurstDetection\'

   fileNames = dir(fullfile(CohDir, '*COH*'));
   
nFiles = numel(fileNames);
    for k = 1:nFiles
        c =  load([CohDir fileNames(k).name]);
       % d = load([dataDir lfpFiles{k}]);
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
        
%         timeWin_s = 20; %seconds
%         tOn = d.D.tOn_s;
%         
%         bins_per_min = 60/timeWin_s;
%         binsInHour = bins_per_min*60;
%         analysisBins_cnt = nHoursToAnalyze*binsInHour;
%         
%         %% d/y
%         
%         %subplot(3, 1, 1)
%         
%         isArtifact = d.D.isArtifact;
%         artifactInds = d.D.isArtifact; % identify where all the artifact files are
%         
%         LightsOff_min = d.INFO.totalDur_min_start_lightsOff;
%         LightsOff_s_bins = LightsOff_min*bins_per_min; %3 bins per min for 20 s bins
%         
%         % 2 hours after lights off = 360, 20 s bins
%         %1 min = 3 bins, 3*60 = 1 hr, 180*2  = 360
%         onsetBins = LightsOff_s_bins+hoursAfterLightsOff*binsInHour; % 2 hours after lights off
%         offsetBins = onsetBins+analysisBins_cnt;
%         tOn_toAnalyze = tOn(onsetBins:offsetBins);
%         artifactInds_toAnalyze = logical(artifactInds(onsetBins:offsetBins));
%         
%         %   minChannels = floor(nChans*.5);       % ripple must appear on >= channels
%         nBinsToAnalyze = numel(tOn_toAnalyze);
%         %
        %% delta
        
        corrVals_Nan = corrVals;
        
        
      %  corrVals_Nan(:, artifactInds_toAnalyze) = NaN;
        
      %  medianCorrs = nanmedian(corrVals, 2);
        
        
        nanmedianCorrs{k} = nanmedian(corrVals_Nan, 2);
        %varCorr(k) = var(nanmedianCorrs);
        
        %allMedianCorrs(k) = median(nanmedianCorrs, 2);
        
        
    end
    allnanMedianCorrs{j} = nanmedianCorrs;
    
end

%%
figure (342); clf
subplot(1, 2, 1)
hold on
for i = 1:numel(nanmedianCorrs)
    %y = allMeans_large{i};
    y = allnanMedianCorrs{1, 1}{1, i};
    y = y(~isnan(y));
    
    if ~isempty(y)
        
        [f, yi] = ksdensity(y);
        f = f / max(f) * 0.3;   % control width
        
        %fill([i+f, i-fliplr(f)], ...
        fill([(i)+f, (i)-fliplr(f)], ...
            [yi, fliplr(yi)], ...
            [0.3 0.7 0.9], ...
            'EdgeColor','k','FaceAlpha',0.8)
        
    end
    % plot(i, median(y), 'k.', 'MarkerSize',18)
end

ylim([ -1 1.2])
subplot(1, 2, 2)
hold on
for i = 1:numel(nanmedianCorrs)
    %y = allMeans_large{i};
    y = allnanMedianCorrs{1, 2}{1, i};
    y = y(~isnan(y));
    
    if ~isempty(y)
        
        [f, yi] = ksdensity(y);
        f = f / max(f) * 0.3;   % control width
        
        %fill([i+f, i-fliplr(f)], ...
        fill([(i)+f, (i)-fliplr(f)], ...
            [yi, fliplr(yi)], ...
            [0.3 0.7 0.9], ...
            'EdgeColor','k','FaceAlpha',0.8)
        
    end
    
    ylim([ -1 1.2])
    % plot(i, median(y), 'k.', 'MarkerSize',18)
end


%%
               
                plotpos = [0 0 18 10];
                plot_filename = [NegDir '__corrs'];
                print_in_A4(0, plot_filename, '-djpeg', 0, plotpos);
                print_in_A4(0, plot_filename, '-depsc', 0, plotpos);
               

  %%  
    
    
    NegAndPos_MedianDeltaMedian(:,j) = MedianDeltaMedian;
    NegAndPos_MedianGammaMedian(:,j) = MedianGammaMedian;
    
    NegAndPos_MedianDeltaMedian_sem(:,j) = MedianDeltaSEM;
    NegAndPos_MedianGammaMedian_sem(:,j) = MedianGammaSEM;
[h,p] = ranksum(NegAndPos_MedianDeltaMedian(:,1), NegAndPos_MedianDeltaMedian(:,2))




disp('')
    
end






