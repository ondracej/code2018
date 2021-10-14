 function [] = detectSWRsJO_2021()
            
 
 SessionDir = 'G:\SWR\ZF-o3b11\20210223\16-34-06\'; % need dirdelim at end
 chanToUse = 12;
 plotDir = [];
 
 
            %%
            doPlot = 1;
            dbstop if error
            
           search = ['*CH' num2str(chanToUse) '*'];
            matchFile = dir(fullfile(SessionDir, search));
            fileName = [SessionDir matchFile(1).name];
            
            [data, timestamps, info] = load_open_ephys_data(fileName);
            Fs = info.header.sampleRate;
            
            [V_uV_data_full,nshifts] = shiftdim(data',-1);
            
            thisSegData = V_uV_data_full(:,:,:);
            thisSegData_s = timestamps(1:end) - timestamps(1);
            recordingDuration_s = thisSegData_s(end);
            
            
            
            
            
            %% Create Filters
            
            rippleFilter = [80 300];
            sharpWaveFilter = [1 6];
            bandPassFilter = [1 2000];
            DS_Factor = 20;
            %% Hameds approach
            %[b1,a1] = butter(2,[150 400]/(fs/2)); % ripple burst spectral range
            %[b2,a2] = butter(2,[.2 20]/(fs/2)); % sharp wave range
            %ripple=filtfilt(b1,a1,SWR);
            %sharp_wave=filtfilt(b2,a2,SWR);
            
            %%
            
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
            
            
            fObj = filterData(Fs);
            
            %downsamples
            fobj.filt.F=filterData(Fs);
            fobj.filt.F.downSamplingFactor=120; % original is 128 for 32k for sampling rate of 250
            fobj.filt.F=fobj.filt.F.designDownSample;
            fobj.filt.F.padding=true;
            fobj.filt.FFs=fobj.filt.F.filteredSamplingFrequency;
            
            fobj.filt.F2=filterData(Fs);
            fobj.filt.F2.downSamplingFactor=DS_Factor; % original is 128 for 32k for sampling rate of 250
            fobj.filt.F2=fobj.filt.F2.designDownSample;
            fobj.filt.F2.padding=true;
            fobj.filt.FFs=fobj.filt.F2.filteredSamplingFrequency;
            

            % Sharp Wave
            fobj.filt.SW=filterData(Fs);
            fobj.filt.SW.highPassCutoff=sharpWaveFilter(1);
            fobj.filt.SW.lowPassCutoff=sharpWaveFilter(2);
            fobj.filt.SW.filterDesign='butter';
            fobj.filt.SW=fobj.filt.SW.designBandPass;
            fobj.filt.SW.padding=true;
            
            % Ripples
             fobj.filt.Ripple=filterData(Fs);
            fobj.filt.Ripple.highPassCutoff=rippleFilter(1);
            fobj.filt.Ripple.lowPassCutoff=rippleFilter(2);
            fobj.filt.Ripple.filterDesign='butter';
            fobj.filt.Ripple=fobj.filt.Ripple.designBandPass;
            fobj.filt.Ripple.padding=true;
            
            %BandPass
            fobj.filt.BP=filterData(Fs);
            fobj.filt.BP.highPassCutoff=bandPassFilter(1);
            fobj.filt.BP.lowPassCutoff=bandPassFilter(2);
            fobj.filt.BP.filterDesign='butter';
            fobj.filt.BP=fobj.filt.BP.designBandPass;
            fobj.filt.BP.padding=true;
            
            %notch Does not work in 2018b using both toolboxes
%             fobj.filt.FN =filterData(Fs);
%             fobj.filt.FN.filterDesign='cheby1';
%             fobj.filt.FN.padding=true;
%             fobj.filt.FN=fobj.filt.FN.designNotch;
            
%             fobj.filt.FH2=filterData(Fs);
%             fobj.filt.FH2.highPassCutoff=100;
%             fobj.filt.FH2.lowPassCutoff=2000;
%             fobj.filt.FH2.filterDesign='butter';
%             fobj.filt.FH2=fobj.filt.FH2.designBandPass;
%             fobj.filt.FH2.padding=true;
            
           
            
            %% For estimating scale
            
            seg_s= 20;
            TOn=1:seg_s*Fs:(recordingDuration_s*Fs-seg_s*Fs);
           
            nCycles = numel(TOn);
            if nCycles >20
                nTestSegments  = 20;
            end
            
            rng(1); % for reproducibiity
            pCycle=sort(randperm(nCycles,nTestSegments));
             
              for i=1:numel(pCycle)-1
                
                thisROI = TOn(pCycle(i)):TOn(pCycle(i)+1);
                SegData = V_uV_data_full(:,:, thisROI);
                
                DataSeg_ripple = squeeze(fobj.filt.Ripple.getFilteredData(SegData));
                DataSeg_SW = squeeze(fobj.filt.SW.getFilteredData(SegData));
            
               
                win_len=round(Fs/20) ; % sliding window for the RMS envelope % 50 ms
                [up_ripple,lo_ripple] = envelope(DataSeg_ripple,win_len,'rms');
                [up_SW,lo_SW] = envelope(DataSeg_SW,win_len,'rms');
                
              
                % figure; plot(up_ripple)
                % figure; plot(up_SW)
                
                %                 figure; plot(DataSeg_ripple)
                %                 figure; plot(DataSeg_SW)
                %                 figure; plot(squeeze(SegData))
                
                
                    %tr=median(up)+2*iqr(up);
                th_SW(i) = .95*iqr(up_SW);
                th_ripple(i) = median(up_ripple) + 2*iqr(up_ripple);
                
              end
              
              median_th_SW = median(th_SW);
              median_th_ripple = median(th_ripple);
            
            
            
            
            seg_s=20;
            TOn=1:seg_s*Fs:(recordingDuration_s*Fs-seg_s*Fs);
            overlapWin = 2*Fs;
            
            nCycles = numel(TOn);
            
            rcnt = 1;
            scnt = 1;
            
            templatePeaks = [];
            ripplePeaks = [];
            
            for i=1:nCycles-1
               % for i=2000:2200
                
                disp([num2str(i) '/' num2str(nCycles)])
                figure(300); clf
                if i ==1
                    thisROI = TOn(i):TOn(i+1);
                else
                    thisROI = TOn(i)-overlapWin:TOn(i+1);
                end
                
                SegData = V_uV_data_full(:,:, thisROI);
                SegData_s = thisSegData_s(thisROI);
                
                DataSeg_ripple = squeeze(fobj.filt.Ripple.getFilteredData(SegData));
                %DataSeg_LF = fobj.filt.FL.getFilteredData(SegData);
                %DataSeg_SW = fobj.filt.SW.getFilteredData(DataSeg_LF);
                
                DataSeg_BP = fobj.filt.BP.getFilteredData(SegData);
                DataSeg_BPFL = fobj.filt.FL.getFilteredData(DataSeg_BP);
                %DataSeg_FNotch = squeeze(fobj.filt.FN.getFilteredData(DataSeg_BP));
                %DataSeg_LF = squeeze(fobj.filt.FL.getFilteredData(DataSeg_BP));
                %DataSeg_HF = squeeze(fobj.filt.FH2.getFilteredData(DataSeg_BP));
                
                smoothWin = 0.10*Fs;
                DataSeg_rect_HF = smooth(DataSeg_ripple.^2, smoothWin);
                %DataSeg_ripple_rms_smooth = smooth(rms(squeeze(DataSeg_ripple), 2), smoothWin );
                %DataSeg_SW_rms_smooth = smooth(rms(squeeze(DataSeg_SW), 2), smoothWin );
                %DataSeg_ripple = squeeze(DataSeg_ripple);
                Data_SegData = squeeze(SegData);
                %DataSeg_LF = squeeze(DataSeg_LF);
                DataSeg_BPFL = squeeze(DataSeg_BPFL);
                DataSeg_BP = squeeze(DataSeg_BP);
                %%
                %smoothWin = 0.10*Fs;
                %DataSeg_LF_neg = -DataSeg_LF;
                %figure; plot(DataSeg_LF_neg)
                %DataSeg_ripple_rms = smooth(DataSeg_HF.^2, smoothWin);
                %baseline = mean(DataSeg_rect_HF)*2;
                
                %figure; plot(SegData_s, DataSeg_rect_HF); axis tight
                
                %% Find Peaks in ripples first
                interPeakDistance = 0.1*Fs;
                minPeakWidth = 0.01*Fs;
                %minPeakHeight = 200;
                %minPeakHeight = ripple_Std*3;
                minPeakHeight =scaleEstimator_ripple;
                %minPeakProminence = 5;
                
                %[peakH,peakTime_Fs, peakW, peakP]=findpeaks(DataSeg_ripple_rms_smooth,'MinPeakHeight',minPeakHeight, 'MinPeakWidth', minPeakWidth, 'MinPeakProminence',minPeakProminence, 'MinPeakDistance', interPeakDistance, 'WidthReference','halfprom'); %For HF
                [peakH,peakTime_Fs, peakW, peakP]=findpeaks(DataSeg_rect_HF,'MinPeakHeight',minPeakHeight, 'MinPeakWidth', minPeakWidth,'MinPeakDistance', interPeakDistance, 'WidthReference','halfprom'); %For HF
                %[peakH,peakTime_Fs, peakW, peakP]=findpeaks(DataSeg_rect_HF,'MinPeakWidth', minPeakWidth,'MinPeakDistance', interPeakDistance, 'WidthReference','halfheight'); %For HF
                
                %minPeakHeight_SW = 120;
                %minPeakHeight_SW = 100;
                minPeakHeight_SW = scaleEstimator_sw;
                interPeakDistance_SW = 0.1*Fs;
                minPeakWidth_SW = 0.01*Fs;
                
                [peakSW_H,peakTimeSW_Fs, peakSW_W, peakSW_P]=findpeaks(-DataSeg_BPFL,'MinPeakHeight',minPeakHeight_SW, 'MinPeakWidth', minPeakWidth_SW,'MinPeakDistance', interPeakDistance_SW, 'WidthReference','halfheight'); %For HF
                %%
                
                absPeakTime_ripples_s =  SegData_s(peakTime_Fs);
                absPeakTime_ripples_fs = peakTime_Fs+thisROI(1)-1;
                
                absPeakTime_SW_s =  SegData_s(peakTimeSW_Fs);
                absPeakTime_SW_fs = peakTimeSW_Fs+thisROI(1)-1;
                
                % relPeakTime_s  = peakTime_Fs;
                
                %%
                if doPlot
                    
                    %                     figure(100);clf;
                    %
                    %                     subplot(3,1,1)
                    %                     plot(SegData_s, squeeze(DataSeg_BP), 'k'); title( ['Raw']);
                    %                     axis tight
                    %                     %ylim([-300 300])
                    %
                    %                     subplot(3, 1, 2)
                    %                     plot(SegData_s, squeeze(DataSeg_ripple), 'k'); title( ['Ripple']);
                    %                     axis tight
                    %                     % ylim([-80 80])
                    %
                    %                     subplot(3, 1, 3)
                    %                     plot(SegData_s, DataSeg_ripple_rms_smooth, 'k'); title( ['Ripple Rectified']);
                    %                     axis tight
                    %                     ylim([0 400])
                    %                     hold on
                    %                     plot(SegData_s(peakTime_Fs), 10, 'rv')
                    %                     axis tight
                    %
                    
                    figure(300);
                    
                    subplot(5, 1, 1)
                    plot(SegData_s, Data_SegData); title( ['Raw Voltage']);
                    hold on
                    if ~isempty(peakTime_Fs)
                        plot(SegData_s(peakTime_Fs), 0, 'r*')
                    end
                    
                    if ~isempty(peakTimeSW_Fs)
                        plot(SegData_s(peakTimeSW_Fs), 0, 'rv')
                    end
                    axis tight
                    
                    subplot(5, 1, 2)
                    plot(SegData_s, DataSeg_BP); title( ['BP Filter']);
                    hold on
                    if ~isempty(peakTime_Fs)
                        plot(SegData_s(peakTime_Fs), 0, 'r*')
                    end
                    
                    if ~isempty(peakTimeSW_Fs)
                        plot(SegData_s(peakTimeSW_Fs), 0, 'rv')
                    end
                    axis tight
                    
                    subplot(5, 1, 3)
                    plot(SegData_s, -DataSeg_BPFL); title(['Neg BP LF']);
                    hold on
                    if ~isempty(peakTimeSW_Fs)
                        plot(SegData_s(peakTimeSW_Fs), -DataSeg_BPFL(peakTimeSW_Fs), 'rv');
                    end
                    axis tight
                    
                    subplot(5,1, 4)
                    plot(SegData_s, DataSeg_ripple); title( ['ripple band']);
                    hold on;
                    axis tight
                    
                    subplot(5, 1,5)
                    plot(SegData_s, DataSeg_rect_HF); title( ['Ripple rms smooth']);
                    hold on;
                    if ~isempty(peakTime_Fs)
                        plot(SegData_s(peakTime_Fs), DataSeg_rect_HF(peakTime_Fs), 'r*');
                    end
                    
                    axis tight
                    %ylim([0 500])
                    
                end
                
                %%
                
                WinSizeL = 0.1*Fs;
                WinSizeR = 0.1*Fs;
                
                %% Go through Ripple peaks first
                for q =1:numel(peakTime_Fs)
                    
                    if doPlot
                        
                        figure(300);
                        
                        %                     subplot(5, 1, 3)
                        %                     plot(SegData_s, -DataSeg_BPFL); title(['Neg BP LF']);
                        %                     hold on
                        %                     plot(SegData_s(peakTimeSW_Fs), -DataSeg_BPFL(peakTimeSW_Fs), 'bv');
                        %                     axis tight
                        %
                        subplot(5, 1,5)
                        hold on
                        plot(SegData_s(peakTime_Fs(q)), DataSeg_rect_HF(peakTime_Fs(q)), 'b*');
                        axis tight
                        %ylim([0 500])
                        
                        
                    end
                    
                    winROI = peakTime_Fs(q)-WinSizeL:peakTime_Fs(q)+WinSizeR;
                    
                    if winROI(end) > size(SegData_s, 1) || winROI(1) <0
                        disp('Win is too big/small')
                        continue
                    else
                        
                        smoothWinW = 0.05*Fs;
                        rippleWin = smooth(DataSeg_rect_HF(winROI), smoothWinW);
                        
                        minPeakWidth = 0.015*Fs;
                        %minPeakProminence = 1;
                        
                        %[peakH_LF,peakTime_Fs_LF, peakW_LF, peakP_LF]=findpeaks(rippleWin,'MinPeakHeight',minPeakHeight_LF,'MinPeakWidth', minPeakWidth_LF, 'WidthReference','halfprom'); %For HF
                        %[peakH_ripcheck,peakTime_Fs_ripcheck, peakW_ripcheck, peakP_ripcheck]=findpeaks(rippleWin,'MinPeakWidth', minPeakWidth, 'MinPeakProminence',minPeakProminence,'WidthReference','halfheight'); %For HF
                        [peakH_ripcheck,peakTime_Fs_ripcheck, peakW_ripcheck, peakP_ripcheck]=findpeaks(rippleWin,'MinPeakWidth', minPeakWidth, 'WidthReference','halfheight'); %For HF
                        
                        peak_ms = (peakW_ripcheck/Fs)*1000;
                        %% Test
                        %{
                            figure(104);clf
                            winROI_ms = SegData_s(winROI)*1000;
                            plot(winROI_ms , rippleWin); axis tight
                            hold on
                            plot(winROI_ms (peakTime_Fs_ripcheck), rippleWin(peakTime_Fs_ripcheck), '*')
                        %}
                        %%
                        disp('')
                        
                        if numel(peakTime_Fs_ripcheck) == 1 % sharp wave and ripple
                            
                            Ripple.peakH(rcnt) = peakH(q);
                            Ripple.asPeakTime_fs(rcnt) = absPeakTime_ripples_fs(q);
                            Ripple.absPeakTime_s(rcnt) = absPeakTime_ripples_s(q);
                            Ripple.peakW(rcnt) = peakW(q);
                            Ripple.peakP(rcnt) = peakP(q);
                            
                            absPeakTime_Fs_rippleCheck = (peakTime_Fs_ripcheck + peakTime_Fs(q)-WinSizeL) +thisROI(1)-1; % this is realtive to both the LF window and the larger ROI
                            
                            Ripple.peakH_ripcheck(rcnt) = peakH_ripcheck;
                            Ripple.absPeakTime_Fs_LF(rcnt) = absPeakTime_Fs_rippleCheck;
                            Ripple.peakW_ripcheck(rcnt) = peakW_ripcheck;
                            Ripple.peakP_ripcheck(rcnt) = peakP_ripcheck;
                            
                            rcnt = rcnt+1;
                            
                            if doPlot
                                RelPeak_fs = absPeakTime_Fs_rippleCheck-thisROI(1)-1;
                                subplot(5, 1,5)
                                hold on
                                plot(SegData_s(RelPeak_fs), DataSeg_rect_HF(RelPeak_fs), 'ko');
                                axis tight
                                %ylim([0 500])
                            end
                            
                            
                            %% Test
                            % testROI = asPeakTime_fs(q)-0.2*Fs:asPeakTime_fs(q)+0.2*Fs;% THis is the HF, it will be offset from the peak of the SHW
                            % figure; plot(SegData_s(testROI), DataSeg_rect_HF(testROI)); axis tight
                            % figure; plot(SegData_s(testROI), DataSeg_FNotch(testROI)); axis tight
                            %line([ thisSegData_s(asPeakTime_fs(q)) thisSegData_s(asPeakTime_fs(q))], [-1000 500]);
                            
                            %testROI = absPeakTime_Fs_LF-(0.2*Fs):absPeakTime_Fs_LF+(0.2*Fs);
                            %figure(200); plot(SegData_s(testROI),  DataSeg_LF(testROI), 'k'); axis tight
                            %hold on; plot(SegData_s(testROI), DataSeg_FNotch(testROI)); axis tight
                            %line([ thisSegData_s(absPeakTime_Fs_LF(q)) thisSegData_s(absPeakTime_Fs_LF(q))], [-1000 500]);
                            
                            
                        elseif isempty(peakTime_Fs_ripcheck) % only ripple, no SW
                            
                            continue
                        else % two detections
                            %choose HighestPeak
                            [pmax, maxInd] = max(peakH_ripcheck);
                            
                            Ripple.peakH(rcnt) = peakH(q);
                            Ripple.asPeakTime_fs(rcnt) = absPeakTime_ripples_fs(q);
                            Ripple.absPeakTime_s(rcnt) = absPeakTime_ripples_s(q);
                            Ripple.peakW(rcnt) = peakW(q);
                            Ripple.peakP(rcnt) = peakP(q);
                            
                            absPeakTime_Fs_rippleCheck = (peakTime_Fs_ripcheck(maxInd) + peakTime_Fs(q)-WinSizeL) +thisROI(1)-1; % this is realtive to both the LF window and the larger ROI
                            
                            Ripple.peakH_ripcheck(rcnt) = peakH_ripcheck(maxInd);
                            Ripple.absPeakTime_Fs_LF(rcnt) = absPeakTime_Fs_rippleCheck;
                            Ripple.peakW_ripcheck(rcnt) = peakW_ripcheck(maxInd);
                            Ripple.peakP_ripcheck(rcnt) = peakP_ripcheck(maxInd);
                            
                            rcnt = rcnt+1;
                            
                            RelPeak_fs = absPeakTime_Fs_rippleCheck-thisROI(1)-1;
                            if doPlot
                                subplot(5, 1,5)
                                hold on
                                plot(SegData_s(RelPeak_fs), DataSeg_rect_HF(RelPeak_fs), 'ko');
                                axis tight
                            end
                            continue
                            
                        end
                    end
                    
                end
                
                
                
                
                %%
                
                
                
                %  absPeakTime_SW_s =  SegData_s(peakTimeSW_Fs);
                % absPeakTime_SW_fs = peakTimeSW_Fs+thisROI(1)-1;
                
                
                
                
                %% Now For SWs
                
                for q =1:numel(peakTimeSW_Fs)
                    
                    if doPlot
                        
                        figure(300);
                        
                        subplot(5, 1, 3)
                        %plot(SegData_s, -DataSeg_BPFL); title(['Neg BP LF']);
                        hold on
                        plot(SegData_s(peakTimeSW_Fs(q)), -DataSeg_BPFL(peakTimeSW_Fs(q)), 'bv');
                        axis tight
                        
                    end
                    
                    winROI = peakTimeSW_Fs(q)-WinSizeL:peakTimeSW_Fs(q)+WinSizeR;
                    
                    if winROI(end) >= size(SegData_s, 1) || winROI(1) <=0
                        disp('Win is too big/small')
                        continue
                    else
                        
                        SWWin = -DataSeg_BPFL(winROI);
                        
                        minPeakWidth = 0.015*Fs;
                        minPeakProminence = 5;
                        
                        %[peakH_LF,peakTime_Fs_LF, peakW_LF, peakP_LF]=findpeaks(rippleWin,'MinPeakHeight',minPeakHeight_LF,'MinPeakWidth', minPeakWidth_LF, 'WidthReference','halfprom'); %For HF
                        [peakH_SWcheck,peakTime_Fs_SWcheck, peakW_SWcheck, peakP_SWcheck]=findpeaks(SWWin,'MinPeakWidth', minPeakWidth, 'MinPeakProminence',minPeakProminence,'WidthReference','halfheight'); %For HF
                        
                        peak_ms = (peakW_SWcheck/Fs)*1000;
                        %% Test
                        %{
                        figure(104);clf
                        winROI_ms = SegData_s(winROI)*1000;
                        plot(winROI_ms , SWWin); axis tight
                        hold on
                        plot(winROI_ms (peakTime_Fs_SWcheck), SWWin(peakTime_Fs_SWcheck), '*')
                        %}
                        %%
                        disp('')
                        
                        if numel(peakTime_Fs_SWcheck) == 1 % sharp wave and ripple
                            
                            SW.peakSW_H(scnt) = peakSW_H(q);
                            SW.absPeakTime_SW_fs(scnt) = absPeakTime_SW_fs(q);
                            SW.absPeakTime_SW_s(scnt) = absPeakTime_SW_s(q);
                            SW.peakSW_W(scnt) = peakSW_W(q);
                            SW.peakSW_P(scnt) = peakSW_P(q);
                            
                            absPeakTime_Fs_SWCheck = (peakTime_Fs_SWcheck + peakTimeSW_Fs(q)-WinSizeL) +thisROI(1)-1; % this is realtive to both the LF window and the larger ROI
                            
                            SW.peakH_SWcheck(scnt) = peakH_SWcheck;
                            SW.absPeakTime_Fs_LF(scnt) = absPeakTime_Fs_SWCheck;
                            SW.peakW_SWcheck(scnt) = peakW_SWcheck;
                            SW.peakP_SWcheck(scnt) = peakP_SWcheck;
                            
                            
                            scnt = scnt+1;
                            
                            %plot(SegData_s, -DataSeg_BPFL); title(['Neg BP LF']);
                            RelPeak_fs = absPeakTime_Fs_SWCheck-thisROI(1)-1;
                            
                            if doPlot
                                subplot(5, 1, 3)
                                hold on
                                plot(SegData_s(RelPeak_fs), -DataSeg_BPFL(RelPeak_fs), 'ko');
                                axis tight
                            end
                            
                            
                            %% Test
                            % testROI = asPeakTime_fs(q)-0.2*Fs:asPeakTime_fs(q)+0.2*Fs;% THis is the HF, it will be offset from the peak of the SHW
                            % figure; plot(SegData_s(testROI), DataSeg_rect_HF(testROI)); axis tight
                            % figure; plot(SegData_s(testROI), DataSeg_FNotch(testROI)); axis tight
                            %line([ thisSegData_s(asPeakTime_fs(q)) thisSegData_s(asPeakTime_fs(q))], [-1000 500]);
                            
                            %testROI = absPeakTime_Fs_LF-(0.2*Fs):absPeakTime_Fs_LF+(0.2*Fs);
                            %figure(200); plot(SegData_s(testROI),  DataSeg_LF(testROI), 'k'); axis tight
                            %hold on; plot(SegData_s(testROI), DataSeg_FNotch(testROI)); axis tight
                            %line([ thisSegData_s(absPeakTime_Fs_LF(q)) thisSegData_s(absPeakTime_Fs_LF(q))], [-1000 500]);
                            
                            
                        elseif isempty(peakTime_Fs_SWcheck) % only ripple, no SW
                            
                            continue
                        else % two detections
                            %choose HighestPeak
                            [pmax, maxInd] = max(peakH_SWcheck);
                            
                            SW.peakSW_H(scnt) = peakSW_H(q);
                            SW.absPeakTime_SW_fs(scnt) = absPeakTime_SW_fs(q);
                            SW.absPeakTime_SW_s(scnt) = absPeakTime_SW_s(q);
                            SW.peakSW_W(scnt) = peakSW_W(q);
                            SW.peakSW_P(scnt) = peakSW_P(q);
                            
                            absPeakTime_Fs_SWCheck = (peakTime_Fs_SWcheck(maxInd) + peakTimeSW_Fs(q)-WinSizeL) +thisROI(1)-1; % this is realtive to both the LF window and the larger ROI
                            
                            SW.peakH_SWcheck(scnt) = peakH_SWcheck(maxInd);
                            SW.absPeakTime_Fs_LF(scnt) = absPeakTime_Fs_SWCheck;
                            SW.peakW_SWcheck(scnt) = peakW_SWcheck(maxInd);
                            SW.peakP_SWcheck(scnt) = peakP_SWcheck(maxInd);
                            
                            
                            scnt = scnt+1;
                            RelPeak_fs = absPeakTime_Fs_SWCheck-thisROI(1)-1;
                            if doPlot
                                subplot(5, 1, 3)
                                %plot(SegData_s, -DataSeg_BPFL); title(['Neg BP LF']);
                                hold on
                                plot(SegData_s(RelPeak_fs), -DataSeg_BPFL(RelPeak_fs), 'ko');
                                axis tight
                            end
                            continue
                            
                        end
                    end
                    
                end
                
                
                if doPlot
                    PlotDir = [obj.DIR.plotDir];
                    if exist(PlotDir, 'dir') == 0
                        mkdir(PlotDir);
                        disp(['Created: '  PlotDir])
                    end
                    plot_filename = [PlotDir 'SWR_Detections-Plots' sprintf('%03d', i)];
                    
                    plotpos = [0 0 25 15];
                    figure(300);
                    print_in_A4(0, plot_filename, '-djpeg', 0, plotpos);
                    print_in_A4(0, plot_filename, '-depsc', 0, plotpos);
                end
                
            end
            
            DetectionSaveName = [obj.DIR.analysisDir obj.Session.time '__SWR-Detections.mat'];
            save(DetectionSaveName, 'Ripple', 'SW');
            
            disp(['Saved:' DetectionSaveName ])
            
              end
        
        