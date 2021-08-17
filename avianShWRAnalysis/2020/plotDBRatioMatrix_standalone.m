
        function [] = plotDBRatioMatrix_standalone(params)
            dbstop if error
            
       
           %eval(['fileAppend = ''106_CH' num2str(chanToUse) '.continuous'';'])
            %eval(['fileAppend = ''100_CH' num2str(chanToUse) '.continuous'';'])
            fileName = [params.SessionDir params.chanToUse];
            
            [data, timestamps, info] = load_open_ephys_data(fileName);
            thisSegData_s = timestamps(1:end) - timestamps(1);
            Fs = info.header.sampleRate;
            
            
            samples = size(data, 1);
            recordingDuration_s  = samples/Fs;
            totalTime = recordingDuration_s;
            batchDuration_s = 1*60*30; % 30 min
            batchDuration_samp = batchDuration_s*Fs;
            
            tOn_s = 1:batchDuration_s:totalTime;
            tOn_samp = tOn_s*Fs;
            nBatches = numel(tOn_samp);
            
            Plotting.titleTxt = [params.BirdName ' | ' params.DateTime];
            Plotting.saveTxt = [params.BirdName '_' params.DateTime];
            
            %% Filters
            fObj = filterData(Fs);
            
            fobj.filt.F=filterData(Fs);
            %fobj.filt.F.downSamplingFactor=120; % original is 128 for 32k
            fobj.filt.F.downSamplingFactor=100; % original is 128 for 32k
            fobj.filt.F=fobj.filt.F.designDownSample;
            fobj.filt.F.padding=true;
            fobj.filt.FFs=fobj.filt.F.filteredSamplingFrequency;
            
            %fobj.filt.FL=filterData(Fs);
            %fobj.filt.FL.lowPassPassCutoff=4.5;
            %fobj.filt.FL.lowPassStopCutoff=6;
            %fobj.filt.FL.attenuationInLowpass=20;
            %fobj.filt.FL=fobj.filt.FL.designLowPass;
            %fobj.filt.FL.padding=true;
            
            fobj.filt.FL=filterData(Fs);
            fobj.filt.FL.lowPassPassCutoff=30;% this captures the LF pretty well for detection
            fobj.filt.FL.lowPassStopCutoff=40;
            fobj.filt.FL.attenuationInLowpass=20;
            fobj.filt.FL=fobj.filt.FL.designLowPass;
            fobj.filt.FL.padding=true;
            
            fobj.filt.BP=filterData(Fs);
            fobj.filt.BP.highPassCutoff=1;
            fobj.filt.BP.lowPassCutoff=2000;
            fobj.filt.BP.filterDesign='butter';
            fobj.filt.BP=fobj.filt.BP.designBandPass;
            fobj.filt.BP.padding=true;
            
            fobj.filt.FH2=filterData(Fs);
            fobj.filt.FH2.highPassCutoff=100;
            fobj.filt.FH2.lowPassCutoff=2000;
            fobj.filt.FH2.filterDesign='butter';
            fobj.filt.FH2=fobj.filt.FH2.designBandPass;
            fobj.filt.FH2.padding=true;
            
%             fobj.filt.FN =filterData(Fs);
%             fobj.filt.FN.filterDesign='cheby1';
%             fobj.filt.FN.padding=true;
%             fobj.filt.FN=fobj.filt.FN.designNotch;
            
            %%
            bufferedDeltaGammaRatio = [];
            bufferedDelta= [];
            bufferedGamma= [];
            allV_DS = [];
            
            for i = 1:nBatches-1
                
                if i == nBatches
                    thisData = data(tOn_samp(i):samples);
                else
                    thisData = data(tOn_samp(i):tOn_samp(i)+batchDuration_samp);
                end
                
                [V_uV_data_full,nshifts] = shiftdim(thisData',-1);
                thisSegData = V_uV_data_full(:,:,:);
                
              %  [DataSeg_Notch, ~] = fobj.filt.FN.getFilteredData(thisSegData); % t_DS is in ms
                [DataSeg_BP, ~] = fobj.filt.BP.getFilteredData(thisSegData); % t_DS is in ms
                [DataSeg_F, t_DS] = fobj.filt.F.getFilteredData(DataSeg_BP); % t_DS is in ms
                
                t_DS_s = t_DS/1000;
                
                %% Raw Data  - Parameters from data=getDelta2BetaRatio(obj,varargin)
                
                % This is all in ms
                %             addParameter(parseObj,'movLongWin',1000*60*30,@isnumeric); %max freq. to examine
                %             addParameter(parseObj,'movWin',10000,@isnumeric);
                %             addParameter(parseObj,'movOLWin',9000,@isnumeric);
                %             addParameter(parseObj,'segmentWelch',1000,@isnumeric);
                %             addParameter(parseObj,'dftPointsWelch',2^10,@isnumeric);
                %             addParameter(parseObj,'OLWelch',0.5);
                %
                %reductionFactor = 0.5; % No reduction
                %reductionFactor = 0.15; % No reduction
                %reductionFactor = 0.5; % No reduction
                reductionFactor = 1; % No reduction
                
                movWin_Var = 10*reductionFactor; % 10 s
                movOLWin_Var = 9*reductionFactor; % 9 s
                
                segmentWelch = 1*reductionFactor;
                OLWelch = 0.5*reductionFactor;
                
                dftPointsWelch =  2^10;
                
                segmentWelchSamples = round(segmentWelch*fobj.filt.FFs);
                samplesOLWelch = round(segmentWelchSamples*OLWelch);
                
                movWinSamples=round(movWin_Var*fobj.filt.FFs);%obj.filt.FFs in Hz, movWin in samples
                movOLWinSamples=round(movOLWin_Var*fobj.filt.FFs);
                
                % run welch once to get frequencies for every bin (f) determine frequency bands
                [~,f] = pwelch(randn(1,movWinSamples),segmentWelchSamples,samplesOLWelch,dftPointsWelch,fobj.filt.FFs);
                
                deltaBandLowCutoff = 1;
                deltaBandHighCutoff = 4;
                
                thetaBandLowCutoff  = 4;
                thetaBandHighCutoff  = 8;
                
                alphaBandLowCutoff  = 8;
                alphaBandHighCutoff  = 12;
                
                betaBandLowCutoff = 12;
                betaBandHighCutoff = 30;
                
                %gammaBandLowCutoff = 30;
                %gammaBandHighCutoff = 100;
                gammaBandLowCutoff = 25;
                gammaBandHighCutoff = 140;
                
                pfDeltaBand=find(f>=deltaBandLowCutoff & f<deltaBandHighCutoff);
                pfThetaBand=find(f>=thetaBandLowCutoff & f<thetaBandHighCutoff);
                pfAlphaBand=find(f>=alphaBandLowCutoff & f<alphaBandHighCutoff);
                pfBetaBand=find(f>=betaBandLowCutoff & f<betaBandHighCutoff);
                pfGammBand=find(f>=gammaBandLowCutoff & f<gammaBandHighCutoff);
                
                
                %%
                %%
                tmp_V_DS = buffer(DataSeg_F,movWinSamples,movOLWinSamples,'nodelay');
                pValid=all(~isnan(tmp_V_DS));
                
                [pxx,f] = pwelch(tmp_V_DS(:,pValid),segmentWelchSamples,samplesOLWelch,dftPointsWelch,fobj.filt.FFs);
                
                %% Ratios
                deltaBetaRatioAll=zeros(1,numel(pValid));
                deltaBetaRatioAll(pValid)=(mean(pxx(pfDeltaBand,:))./mean(pxx(pfBetaBand,:)))';
                
                deltaThetaRatioAll = zeros(1,numel(pValid));
                deltaThetaRatioAll(pValid)=(mean(pxx(pfDeltaBand,:))./mean(pxx(pfThetaBand,:)))';
                
                deltaAlphRatioAll = zeros(1,numel(pValid));
                deltaAlphRatioAll(pValid)=(mean(pxx(pfDeltaBand,:))./mean(pxx(pfAlphaBand,:)))';
                
                deltaGammaRatioAll = zeros(1,numel(pValid));
                deltaGammaRatioAll(pValid)=(mean(pxx(pfDeltaBand,:))./mean(pxx(pfGammBand,:)))';
                
                betaGammaRatioAll = zeros(1,numel(pValid));
                betaGammaRatioAll (pValid)=(mean(pxx(pfBetaBand,:))./mean(pxx(pfGammBand,:)))';
                
                thetaGammaRatioAll = zeros(1,numel(pValid));
                thetaGammaRatioAll (pValid)=(mean(pxx(pfThetaBand,:))./mean(pxx(pfGammBand,:)))';
                
                %% single elements
                deltaAll=zeros(1,numel(pValid));
                deltaAll(pValid)=mean(pxx(pfDeltaBand,:))';
                
                thetaAll=zeros(1,numel(pValid));
                thetaAll(pValid)=mean(pxx(pfThetaBand,:))';
                
                alphaAll=zeros(1,numel(pValid));
                alphaAll(pValid)=mean(pxx(pfAlphaBand,:))';
                
                betaAll=zeros(1,numel(pValid));
                betaAll(pValid)=mean(pxx(pfBetaBand,:))';
                
                gammaAll=zeros(1,numel(pValid));
                gammaAll(pValid)=mean(pxx(pfGammBand,:))';
                
                
                %%
                %bufferedDeltaBetaRatio(i,:)=deltaBetaRatioAll;
                %bufferedDeltaAlphaRatio(i,:)=deltaAlphRatioAll;
                %bufferedDeltaThetaRatio(i,:)=deltaThetaRatioAll;
                bufferedDeltaGammaRatio(i,:)=deltaGammaRatioAll;
                
                bufferedDelta(i,:)=deltaAll;
                %bufferedBeta(i,:)=betaAll;
                %bufferedTheta(i,:)=thetaAll;
                bufferedGamma(i,:)=gammaAll;
                %bufferedAlpha(i,:)=alphaAll;
                
                allV_DS{i} = squeeze(tmp_V_DS);
                
            end
            
            for o = 4
                
                switch o
                    
                    case 1
                        dataToPlot  = bufferedDeltaThetaRatio;
                        dbScale = 250;
                        titletxt = 'Delta/Theta Ratio';
                        savenametxt = 'DeltaTheta';
                        
                    case 2
                        dataToPlot  = bufferedDeltaAlphaRatio;
                        dbScale = 500;
                        titletxt = 'Delta/Alpha Ratio';
                        savenametxt = 'DeltaAlpha';
                        
                    case 3
                        dataToPlot  = bufferedDeltaBetaRatio;
                        dbScale = 5000;
                        titletxt = 'Delta/Beta Ratio';
                        savenametxt = 'DeltaBeta';
                        
                    case 4
                        dataToPlot  = bufferedDeltaGammaRatio;
                        dbScale = 50000;
                        titletxt = 'Delta/Gamma Ratio';
                        savenametxt = 'DeltaGamma';
                end
                
                %%
                fig500 = figure(500);clf
                
                imagesc(dataToPlot, [0 1200])
                %imagesc(dataToPlot, [0 300])
               % imagesc(dataToPlot(2:29, :), [0 1200])
                %imagesc(dataToPlot(2:29, :))
                
                if batchDuration_s == 1800
                    %xtics = get(gca, 'xtick');
                    xticks_s = 0:5*60:30*60;
                    xticks_min = xticks_s/60;
                    
                    xticklabs = xticks_min;
                    
                    ytics = get(gca, 'ytick');
                    ytics_Hr = ytics/2;
                    
                end
                xlabs = [];
                for j = 1:numel(xticklabs)
                    xlabs{j} = num2str(xticklabs(j));
                end
                
                ytics_Hr_round = [];
                for j = 1:numel(ytics_Hr)
                    %ytics_Hr_round{j} = num2str(round(ytics_Hr(j)));
                    ytics_Hr_round{j} = num2str(ytics_Hr(j));
                end
                
                set(gca, 'xtick', xticks_s)
                set(gca, 'xticklabel', xlabs)
                set(gca, 'yticklabel', ytics_Hr_round)
                
                xlabel('Time [min]')
                ylabel('Time [Hr]')
                title([params.DateTime ' | ' titletxt])
                colorbar
                %%
                plotpos = [0 0 25 15];
              
                if exist( params.plotDir, 'dir') == 0
                    mkdir( params.plotDir);
                    disp(['Created: '  PlotDir])
                end
                
                plot_filename = [ params.plotDir 'DBMatrix_' savenametxt '-' params.DateTime];
                print_in_A4(0, plot_filename, '-djpeg', 0, plotpos);
                print_in_A4(0, plot_filename, '-depsc', 0, plotpos);
            end
            
        end
        