
        function [] = standalone_analysis_of_infraslow_Rhythm()
           
           
        ephysData = 'X:\EEG-LFP-songLearning\JaniesAnalysis\ALL_PLOTS\w025\All_LFP_dy\chronic_2021-07-30_20-54-58_allLFP_dyData-7.mat';
        filename = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w025\DATA_EPHYS\chronic_2021-07-30_20-54-58\150_CH10.continuous';
           
        a = load(ephysData );
        
        timeWin_s = a.D.timeWin_s; %seconds
                    tOn_orig = a.D.tOn_s;
                 artifactInds = a.D.isArtifact; % identify where all the artifact files are
               LightsOff_min = a.INFO.totalDur_min_start_lightsOff;         
                    
            dbstop if error
            colOrder = {[0, 0.4470, 0.7410], [0.8500, 0.3250, 0.0980], [0.9290, 0.6940, 0.1250], [0.4940, 0.1840, 0.5560],...
                [0.4660, 0.6740, 0.1880], [0.3010, 0.7450, 0.9330], [0.6350, 0.0780, 0.1840]};
            
          
                    %% only detect swr in the analysis windows
                    
                    nHoursToAnalyze = 9;
                    hoursAfterLightsOff = 2;
                    
                    bins_per_min = 60/timeWin_s;
                    binsInHour = bins_per_min*60;
                    analysisBins_cnt = nHoursToAnalyze*binsInHour;
                    
                    
                    
                    LightsOff_s_bins = LightsOff_min*bins_per_min; %3 bins per min for 20 s bins
                    
                    % 2 hours after lights off = 360, 20 s bins
                    %1 min = 3 bins, 3*60 = 1 hr, 180*2  = 360
                    onsetBins = LightsOff_s_bins+hoursAfterLightsOff*binsInHour; % 2 hours after lights off
                    offsetBins = onsetBins+analysisBins_cnt;
                
                    tON = tOn_orig(onsetBins);
                    tOFF = tOn_orig(offsetBins);
                    
                    timeWin_s = 600;% s, expect a 50 s period
                    
                      tOn_toAnalyze = tON:timeWin_s:tOFF;
                tOn_toAnalyze = tOn_toAnalyze(2:end);
                
                nBinsToAnalyze = numel(tOn_toAnalyze);
                    
                fs = 30000;
                
                %%     Delta Band
                %  deltaBand = [1 8];
                
                %% Beta Band
                betaBand = [10 30];
                  smoothWin_s = 10; 
                  smoothWin_samp = smoothWin_s*fs; 
                for o = 1: nBinsToAnalyze
                          disp([num2str(o) '/' num2str(nBinsToAnalyze)])
                         
                                [LFP, timestamps, info] = load_open_ephys_data_chunked(filename,tOn_toAnalyze(o), tOn_toAnalyze(o)+timeWin_s);
                       
                                
                                
                                results = run_infraslow_pipeline(LFP, fs)
                                
                                
                            
% PLOT_INFRASLOW_RESULTS  Quick visualization of pipeline output

figure('Color', 'w');

subplot(2,1,1);
imagesc(results.win_centers_s, results.lags_s, results.acf_matrix');
axis xy;
xlabel('Window center (s)'); ylabel('Lag (s)');
title('Sliding autocorrelation (normalized)');
colorbar;

subplot(2,1,2);
plot(results.lags_s, results.acf_mean, 'k-', 'LineWidth', 1.5); hold on;
yline(0, 'k:');
if ~isempty(results.shuffled_acf_mean)
    plot(results.lags_s, results.shuffled_acf_mean, 'r-', 'LineWidth', 1);
end
if ~isnan(results.neg_peak_lag)
    plot(results.neg_peak_lag, results.neg_peak_val, 'bv', ...
        'MarkerFaceColor', 'b', 'MarkerSize', 8);
end
if ~isnan(results.pos_peak_lag)
    plot(results.pos_peak_lag, results.pos_peak_val, 'g^', ...
        'MarkerFaceColor', 'g', 'MarkerSize', 8);
end
xlabel('Lag (s)'); ylabel('Normalized autocorrelation');
legend({'Mean ACF', 'zero', 'Shuffled control', 'First neg. peak', 'First pos. peak'}, ...
    'Location', 'best');
title('Mean autocorrelation function');



                                
                            %% DESIGN FILTER (use SOS for stability)
                            [z,p,k] = butter(4, betaBand/(fs/2), 'bandpass');
                            [sos,g] = zp2sos(z,p,k);
                            
                            %% APPLY ZERO-PHASE FILTER
                            LFP_beta = filtfilt(sos, g, LFP);
                            
                            betaEnv = abs(hilbert(LFP_beta));
                            betaZ = (betaEnv - median(betaEnv))./mad(betaEnv,1);
                            
                              smoothed_beta = smoothdata(betaEnv, 'gaussian', smoothWin_samp);
                              
                            
                            figure(242); clf
                            subplot(3, 1, 1)
                            plot(LFP_beta)
                            
                            subplot(3, 1, 2)
                            plot(betaEnv)
                            
                            subplot(3, 1, 3)
                            plot(betaZ)
                            
                              smoothed_min = smoothdata(smoothed_raw, 'gaussian', smoothWin_frames);
                            
                            
                saveName = [plotPath obj.EPHYS.EphysRecName{jq} '_BurstDetection-' num2str(nChans)];
                
                if exist(saveDir, 'dir') == 0
                    mkdir(saveDir);
                    disp(['Created: '  saveDir])
                end
                
                save([saveName '.mat'], 'BURSTS', 'INFO', 'params', '-v7.3')
                
                disp(['Saved:' saveName])
                end
                
   
            
          