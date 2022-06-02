
            
            
            
                
                        
            
            WavCrossings_s = WavCrossings_fs/fs_ni;
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            %%
            [b1,a1] = butter(2,[1000 6000]/(fs_ni/2)); % ripple burst spectral range
            micFilt=filtfilt(b1,a1,WavChan);
            
            tic
            wavChan_rms = rms(micFilt, 1);
            toc
            
            %  figure; plot(wavChan_rms(1100*fs_ni:1200*fs_ni))
            
            %wavChanSquared = wavChan_rms.^2;
            
            %data = WavChan - mean(WavChan);
            %data = data * (double(intmax('int16')) / max(abs(data)) );
            
            %  maxVal = max(wavChan_rms);
            % figure; plot(wavChan_rms(300*fs_ni:400*fs_ni))
            figure; plot(wavChan_rms(1100*fs_ni:1200*fs_ni))
            
            WavChan_Thresh = 12;
            
            WavCrossings_fs = find(wavChan_rms >= WavChan_Thresh);
            WavCrossings_s = WavCrossings_fs/fs_ni;
            
            WavCrossings_diff_s = diff(WavCrossings_s);
            largeDiffs_inds = find(WavCrossings_diff_s > 1.6);
            largeWavCrossings_s  = WavCrossings_diff_s(largeDiffs_inds);
            largeWavCrossings_fs = WavCrossings_fs(largeDiffs_inds);% these are the offsets
            timepoints_fs = 1:1:numel(WavChan);
            timepoints_s = timepoints_fs / fs_ni;
            
            
            seg_s = 55;
            seg_samp = seg_s*fs_ni;
            
            seg_s_long = 60;
            seg_samp_long = seg_s_long*fs_ni;
            
            tOn = 1:seg_samp:nSamp;
            nTon = numel(tOn);
            
            
            envWin = 0.200*fs_ni;
            thresh = 12;
            allOnsets = []; allOffsets = [];
            for j = 1:nTon
                if j == nTon
                    ROI = tOn(j): numel(WavChan);
                else
                    
                    ROI = tOn(j): tOn(j)+seg_samp_long;
                end
                
                
                env = envelope(wavChan_rms(ROI),envWin,'peak');
                
                
                %env_zscore = zscore(env);
                
                %thresh = (envMax - envMedian)*1.2;
                
                %  allThresh(j) = thresh;
                crossings_fs = find(env >= thresh);
                crossings_s = crossings_fs/fs_ni;
                
                crossings_diffs_s = diff(crossings_s);
                largeDiffsInds = find(crossings_diffs_s > 1.8);
                
                largeCrossings_s = crossings_s(largeDiffsInds);
                largeCrossings_fs = crossings_fs(largeDiffsInds); % Offsets
                
                thisOnset = []; thisOffset = [];
                for o = 1:numel(largeCrossings_fs)
                    offsetInd = largeDiffsInds(o);
                    if o == 1
                        
                        thisOnset(o) = crossings_fs(1) + tOn(j);
                        thisOffset(o) = crossings_fs(offsetInd) + tOn(j);
                        
                    else
                        onsetInd = largeDiffsInds(o-1) +1;
                        
                        thisOnset(o) = crossings_fs(onsetInd) + tOn(j);
                        thisOffset(o) = crossings_fs(offsetInd) + tOn(j);
                    end
                    
                end
                %
                %                  figure(301); plot(timepoints_s(ROI), env);
                %                  axis tight
                %                  ylim([0 30])
                %                  hold on
                %                    plot(thisOnset/fs_ni, 20, 'kv')
                %                    plot(thisOffset/fs_ni, 20, 'rv')
                
                %                 pause
                allOnsets{j} = thisOnset;
                allOffsets{j} = thisOffset;
                
            end
            
            allOnsetsConcat = sort(cell2mat(allOnsets));
            allOffsetsConcat = sort(cell2mat(allOffsets));
            
            allOnsetsConcat_s = allOnsetsConcat/fs_ni;
            diffOnsets = diff(allOnsetsConcat);
            
            diffOnsets_s = diffOnsets/fs_ni;
            smallDiff_inds = find(diffOnsets < 3*fs_ni);
            
            consecutiveDiffs = diff(smallDiff_inds);
            consecDiffsOnes = find(consecutiveDiffs == 1);
            consecDiffsOnesInds = consecDiffsOnes +1;
            smallDiff_inds_Consec = smallDiff_inds(consecDiffsOnesInds);
            
            allOnsetsConcat(smallDiff_inds_Consec) = [];
            allOnsetsConcat_s(smallDiff_inds_Consec) = [];
            
            diffOnsets = diff(allOnsetsConcat);
            diffOnsets_s = diffOnsets/fs_ni;
            smallDiff_inds = find(diffOnsets < 3*fs_ni);
            remvInds = smallDiff_inds+1;
            
            allOnsetsConcat(remvInds) = [];
            allOnsetsConcat_s(remvInds) = [];
            
            %%
            
            allOffsetsConcat_s = allOffsetsConcat/fs_ni;
            diffOffsets = diff(allOffsetsConcat);
            
            diffOffsets_s = diffOffsets/fs_ni;
            smallDiff_inds = find(diffOffsets < 3*fs_ni);
            
            consecutiveDiffs = diff(smallDiff_inds);
            consecDiffsOnes = find(consecutiveDiffs == 1);
            consecDiffsOnesInds = consecDiffsOnes +1;
            smallDiff_inds_Consec = smallDiff_inds(consecDiffsOnesInds);
            
            allOffsetsConcat(smallDiff_inds_Consec) = [];
            allOffsetsConcat_s(smallDiff_inds_Consec) = [];
            
            diffOffsets = diff(allOffsetsConcat);
            diffOffsets_s = diffOffsets/fs_ni;
            smallDiff_inds = find(diffOffsets < 3*fs_ni);
            remvInds = smallDiff_inds+1;
            
            allOffsetsConcat(remvInds) = [];
            allOffsetsConcat_s(remvInds) = [];
            
            
            %%
            
            
            allOnsetsUnique = unique(allOnsetsConcat);
            allOffsetsUnique = unique(allOffsetsConcat);
            
            
            for j = 1:nTon
                ROI = tOn(j): tOn(j)+seg_samp_long;
                %thisSeg = WavChan(tOn(j): tOn(j)+seg_samp);
                
                
                allOnsets_inds = find(allOnsetsUnique <= ROI(end) & allOnsetsUnique >= ROI(1)) ;
                thisOnset_s = allOnsetsUnique ./ fs_ni;
                theseOnsets = thisOnset_s(allOnsets_inds);
                
                allOffsets_inds = find(allOffsetsUnique <= ROI(end) & allOffsetsUnique >= ROI(1)) ;
                thisOffset_s = allOffsetsUnique ./ fs_ni;
                theseOffsets = thisOffset_s(allOffsets_inds);
                
                %theseOffsets_durs_s = allDurations_s(allOnsets_inds);
                %theseOffsets = theseOnsets + theseOffsets_durs_s;
                
                
                figure(104); clf
                subplot(3, 1, 1)
                plot(timepoints_s(ROI), wavChan_rms(ROI));
                
                subplot(3, 1, 2)
                env = envelope(wavChan_rms(ROI),envWin,'peak');
                theseTimepoints = timepoints_s(ROI);
                plot(theseTimepoints, env);
                
                
                
                axis tight
                ylim([0 40])
                line([theseTimepoints(1) theseTimepoints(end)], [thresh, thresh], 'color', 'r')
                
                
                subplot(3, 1, 3)
                specgram1((WavChan(ROI)./100),513,fs_ni,400,360);
                ylim([0 10000])
                % figure; plot(rms(WavChan(ROI), 1))
                
                
                subplot(3, 1, 1)
                hold on
                plot(theseOnsets, 20, 'rv')
                plot(theseOffsets, 20, 'kv')
                axis tight
                ylim([-50 50])
                
                
                pause
            end
            
            
            
            
            % figure; plot(tooLargeCrossings)
            %            thisOnset = []; thisOffset = [];
            %             for j = 1: numel(largeWavCrossings_fs)
            %                 offsetInd = largeDiffs_inds(j);
            %
            %                 if j == 1
            %
            %                 thisOnset(j) = WavCrossings_fs(1);
            %                 thisOffset(j) = WavCrossings_fs(offsetInd);
            %
            %
            %
            %                 else
            %                           onsetInd = largeDiffs_inds(j-1) +1;
            %
            %                 thisOnset(j) = WavCrossings_fs(onsetInd);
            %                 thisOffset(j) = WavCrossings_fs(offsetInd);
            %                 end
            %             end
            %
            %
            
            thisOnset = []; thisOffset = [];
            for j = 1: numel(largeWavCrossings_fs)
                offsetInd = largeDiffs_inds(j);
                
                if j == 1
                    
                    thisOnset(j) = WavCrossings_fs(1);
                    thisOffset(j) = WavCrossings_fs(offsetInd);
                    
                    
                    
                else
                    onsetInd = largeDiffs_inds(j-1) +1;
                    
                    thisOnset(j) = WavCrossings_fs(onsetInd);
                    thisOffset(j) = WavCrossings_fs(offsetInd);
                end
            end
            
            
            
            allDurationsThresholded_fs = thisOffset - thisOnset;
            allDurationsThresholded_s = allDurationsThresholded_fs./fs_ni;
            
            
            calcWN1_dur = allDurationsThresholded_s(1:50);
            calcREV_dur = allDurationsThresholded_s(51:100);
            calcCON_dur = allDurationsThresholded_s(101:350);
            for j = 1:numel(allDurationsThresholded_s)
                mismatch(j) = allDurationsThresholded_s(j) - allDurations_s(j);
            end
            
            figure; plot(mismatch)
            
            figure(201);
            plot(calcREV_dur, 'k*', 'linestyle', '-')
            hold on
            plot(allStims2_s, 'b*', 'linestyle', '-')
            
            figure(202);
            plot(calcWN1_dur, 'k*', 'linestyle', '-')
            hold on
            plot(allStims1_s, 'b*', 'linestyle', '-')
            
            figure(203);
            plot(calcCON_dur, 'k*', 'linestyle', '-')
            hold on
            plot(allStims3_s, 'b*', 'linestyle', '-')
            
            %% Check Onsets / Offsets
            
            
            
            
            %
            %             for j = 1:nTon
            %                 ROI = tOn(j): tOn(j)+seg_samp_long;
            %                 %thisSeg = WavChan(tOn(j): tOn(j)+seg_samp);
            %
            %
            %                 allOnsets_inds = find(thisOnset <= ROI(end) & thisOnset >= ROI(1)) ;
            %                 allOffsets_inds = find(thisOffset <= ROI(end) & thisOnset >= ROI(1));
            %
            %                 thisOnset_s = thisOnset ./ fs_ni;
            %                 thisOffset_s = thisOffset ./ fs_ni;
            %
            %                 thisOnset_s = thisOnset_s(allOnsets_inds);
            %                 thisOffset_s = thisOffset_s(allOffsets_inds);
            %
            %                 theseOnsets = thisOnset(allOnsets_inds);
            %                 theseOffsets = thisOffset(allOffsets_inds);
            %
            %                 figure(104); clf
            %                 subplot(3, 1, 1)
            %                 plot(timepoints_s(ROI), WavChan(ROI));
            %
            %                 subplot(3, 1, 2)
            %                 bla = envelope(wavChan_rms(ROI),0.05*fs_ni,'peak');
            %                 plot(timepoints_s(ROI), bla);
            %
            %
            %                  subplot(3, 1, 3)
            %                 specgram1((WavChan(ROI)./100),513,fs_ni,400,360);
            %                 ylim([0 10000])
            %                % figure; plot(rms(WavChan(ROI), 1))
            %
            %
            %
            %                 subplot(3, 1, 1)
            %                  hold on
            %                 plot(timepoints_s(theseOnsets), 20, 'rv')
            %                 plot(timepoints_s(theseOffsets), 20, 'kv')
            %                 axis tight
            %                 ylim([-50 50])
            %
            %                 subplot(3, 1, 2)
            %                 hold on
            %                 plot(timepoints_s(theseOnsets), 30, 'rv')
            %                 plot(timepoints_s(theseOffsets), 30, 'kv')
            %                 axis tight
            %                 ylim([0 50])
            %
            %
            %
            %                 pause
            %             end
            
            
            timepoints_fs = 1:1:numel(WavChan);
            timepoints_s = timepoints_fs / fs_ni;
            
            
            figure(103); clf
            plot(timepoints_s(588987904:588987904+20*fs_ni), WavChan(588987904:588987904+20*fs_ni))
            hold on
            plot(timepoints_s(thisOffset), 20, 'rv')
            plot(timepoints_s(thisOnset), 20, 'kv')
            xlim([0 360])
            
            
            
            figure(103); clf
            plot(timepoints_s(1:120*fs_ni), WavChan(1:120*fs_ni))
            hold on
            plot(timepoints_s(5854490), 20, 'rv')
            plot(timepoints_s(6354490), 20, 'rv')
            
            plot(timepoints_s(largeWavCrossings_fs(1:20)), 20, 'rv')
            
            
            
            smoothWin_s = 0.01;
            smoothWin_samp = smoothWin_s*fs_ni;
            
            
            seg_s = 60;
            seg_samp = seg_s*fs_ni;
            
            tOn = 1:seg_samp:nSamp;
            nTon = numel(tOn);
            
            for j = 1:nTon
                thisSeg = WavChan(tOn(j): tOn(j)+seg_samp);
                
                WavChan_envelope = envelope(thisSseg , smoothWin_samp);
            end