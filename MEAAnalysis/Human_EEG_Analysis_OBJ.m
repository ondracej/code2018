classdef Human_EEG_Analysis_OBJ < handle
    
    
    properties (Access = public)
        
        PATH
        ANALYSIS
        VALID
    end
    
    methods
        
        
        function obj = getPathInfo(obj,analysisDir)
            
            if ispc
                dirD = '\';
            else
                dirD = '/';
            end
            
            %% adding code paths
            
            
            code2018Path = 'C:\Users\dlc\Documents\GitHub\code2018';
            NETCode = 'C:\Users\dlc\Documents\GitHub\NeuralElectrophysilogyTools';
            
            if isfolder(code2018Path)
                addpath(genpath(code2018Path));
            else
                disp('Please check definition for code2018 path in "getPathInfo"')
            end
            
            if isfolder(NETCode)
                addpath(genpath(NETCode));
            else
                disp('Please check definition for NETCode path in "getPathInfo"')
            end
            
            %% Define folder structure
            
            obj.PATH.dataDir = [analysisDir];
            obj.PATH.Plots = [analysisDir 'Plots' dirD];
            obj.PATH.dirD  = dirD ;
            
            
            if exist(obj.PATH.Plots, 'dir') ==0
                mkdir(obj.PATH.Plots );
                disp(['Created directory: ' obj.PATH.Plots ])
            end
            
            %% Get list of csv files
            csvfiles = dir(fullfile(analysisDir, '*.csv'));
            nFiles = numel(csvfiles);
            fileNames = [];
            for j = 1:nFiles
                fileNames{j} = csvfiles(j).name;
            end
            
            obj.ANALYSIS.dataFilenames = fileNames;
            
            
        end
        
        function obj = loadCSVfile(obj, filename)
            dbstop if error
            
            filenameToLoad = [obj.PATH.dataDir filename];
            obj.PATH.currentFilenamePath = filenameToLoad;
            obj.PATH.currentFilename = filename;
            
            delimiter = ',';
            startRow = 2;
            
            %% Format for each line of text:
            %   column1: text (%q)
            %	column2: categorical (%C)
            %   column3: double (%f)
            %	column4: double (%f)
            %   column5: double (%f)
            % For more information, see the TEXTSCAN documentation.
            formatSpec = '%q%C%f%f%f%[^\n\r]';
            
            %% Open the text file.
            fileID = fopen(filenameToLoad,'r');
            
            %% Read columns of data according to the format.
            % This call is based on the structure of the file used to generate this
            % code. If an error occurs for a different file, try regenerating the code
            % from the Import Tool.
            dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
            
            
            %% Close the text file.
            fclose(fileID);
            
            %%
            RawValue = dataArray{:,3};
            
            startTimeDate = dataArray{1, 1}(1:1);
            endTimeDate = dataArray{1, 1}(end:end);
            fs = 513;
            nDataPoints = numel(RawValue);
            obj.ANALYSIS.RawValue = RawValue;
            obj.ANALYSIS.fs = fs;
            obj.ANALYSIS.startTimeDate = startTimeDate;
            obj.ANALYSIS.endTimeDate = endTimeDate;
            obj.ANALYSIS.nDataPoints = nDataPoints;
            
            disp(['Done loading file: ' filenameToLoad])
        end
        
        
        function [obj] = findArtifactsPreprocessData(obj, visualize)
            
            nDatapoints = obj.ANALYSIS.nDataPoints;
            fs = obj.ANALYSIS.fs;
            RawValue = obj.ANALYSIS.RawValue;
            recordingDur_s = nDatapoints/fs;
            recordingDur_hr = recordingDur_s/3600;
            
            seg_s= 30;
            seg_fs = seg_s*fs;
            TOn_fs=1:seg_fs:nDatapoints;
            nSegments = numel(TOn_fs);
            timepoints_fs = 1:1:nDatapoints;
            timepoints_s = timepoints_fs/fs;
            
            %% find very larger artifacts
            artifactsLim = [-150 150];
            
            posArtifactInds = find(RawValue >= artifactsLim(2));
            negArtifactInds = find(RawValue <= artifactsLim(1));
            
            thisData_Art1 = RawValue;
            thisData_Art1(posArtifactInds) = 1e-50;
            thisData_Art1(negArtifactInds) = 1e-50;
            
            %% find all the vertical artifacts
            
            smoothwin_s = 0.03;
            smoothwin_fs = smoothwin_s*fs;
            
            if visualize
                for j = 1:nSegments
                    
                    thisData_smooth = smooth(thisData_Art1(TOn_fs(j):TOn_fs(j)+seg_fs), smoothwin_fs);
                    thisData = thisData_Art1(TOn_fs(j):TOn_fs(j)+seg_fs);
                    thisRaw = RawValue(TOn_fs(j):TOn_fs(j)+seg_fs);
                    thistimepoints = timepoints_s(TOn_fs(j):TOn_fs(j)+seg_fs);
                    
                    figure(103); clf
                    hold on
                    
                    plot(thistimepoints, thisRaw+1000, 'k');
                    plot(thistimepoints, thisData+500, 'color', [0.4 0.4 0.4]);
                    plot(thistimepoints, thisData_smooth*3-1000, 'b');
                    axis tight
                    ylim([-2000 2000])
                    xlabel('Time (s)')
                    legTxt = {'Raw data'; 'No Artifacts'; 'Smoothed'};
                    legend(legTxt);
                    title([obj.PATH.currentFilename])
                    
                    pause
                end
            end
            
            obj.ANALYSIS.smoothwin_s = smoothwin_s;
            obj.ANALYSIS.smoothwin_fs = smoothwin_fs;
            obj.ANALYSIS.thisData_noArtifacts= thisData_Art1;
            %obj.ANALYSIS.smoothedData = thisData_smooth;
            
        end
        
        function obj = filterAndBinData_PlotMatrix(obj)
            
            nSamples = obj.ANALYSIS.nDataPoints;
            Fs = obj.ANALYSIS.fs;
            recordingDuration_s  = nSamples/Fs;
            recordingDuration_hr = recordingDuration_s/3600;
            
            batchDuration_s = 1*30*60; % 30 min
            
            batchDuration_samp = batchDuration_s*Fs;
            
            tOn_s = 1:batchDuration_s:recordingDuration_s;
            tOn_samp = tOn_s*Fs;
            nBatches = numel(tOn_samp);
            
            %data = obj.ANALYSIS.RawValue;
            data = obj.ANALYSIS.thisData_noArtifacts;
            %data = obj.ANALYSIS.thisData_noArtifacts;
            smoothWin_fs = obj.ANALYSIS.smoothwin_fs;
            
            %% Filter defintitons
            
            deltaBandLowCutoff = 0.5;
            deltaBandHighCutoff = 4;
            
            thetaBandLowCutoff  = 4;
            thetaBandHighCutoff  = 8;
            
            alphaBandLowCutoff  = 8;
            alphaBandHighCutoff  = 12;
            
            spindleLowCutoff = 12;
            spindleHighCutoff = 16;
            
            betaBandLowCutoff = 16;
            betaBandHighCutoff = 32;
            
            gammaBandLowCutoff = 25;
            gammaBandHighCutoff = 100;
            
            %% Pwelch defintitions
            reductionFactor = 1; % No reduction
            
            movWin_Var = 10*reductionFactor; % 10 s
            movOLWin_Var = 9*reductionFactor; % 9 s
            
            segmentWelch = 1*reductionFactor;
            OLWelch = 0.5*reductionFactor;
            
            dftPointsWelch =  2^10;
            
            
            %%
            bufferedDeltaGammaRatio = [];
            bufferedDeltaBetaRatio = [];
           
            if nBatches == 1
                i =1;
                
                %thisData = data(tOn_samp():nSamples);
                thisData = smooth(data(tOn_samp(i):nSamples), smoothWin_fs);
                
                figHH = figure(350); clf
                timepoints_fs = tOn_samp(i):1:nSamples;
                timepoints_s = timepoints_fs/Fs;
                plot(timepoints_s, thisData, 'k')
                axis tight
                xlabel('Time (s)')
                annotation(figHH ,'textbox',[0.1 0.96 0.46 0.028],'String',[obj.PATH.currentFilename],'LineStyle','none','FitBoxToText','off', 'fontsize', 12);
                
                
                [V_uV_data_full,nshifts] = shiftdim(thisData',-1);
                thisSegData = V_uV_data_full(:,:,:);
                
                segmentWelchSamples = round(segmentWelch*Fs);
                samplesOLWelch = round(segmentWelchSamples*OLWelch);
                
                movWinSamples=round(movWin_Var*Fs);%obj.filt.FFs in Hz, movWin in samples
                movOLWinSamples=round(movOLWin_Var*Fs);
                
                % run welch once to get frequencies for every bin (f) determine frequency bands
                [~,f] = pwelch(randn(1,movWinSamples),segmentWelchSamples,samplesOLWelch,dftPointsWelch,Fs);
                
                pfDeltaBand=find(f>=deltaBandLowCutoff & f<deltaBandHighCutoff);
                pfThetaBand=find(f>=thetaBandLowCutoff & f<thetaBandHighCutoff);
                pfDeltaThetaBand=find(f>=spindleLowCutoff & f<spindleHighCutoff);
                %    pfDeltaThetaBand=find(f>=deltaThetaLowCutoff & f<deltaThetaHighCutoff);
                pfAlphaBand=find(f>=alphaBandLowCutoff & f<alphaBandHighCutoff);
                pfBetaBand=find(f>=betaBandLowCutoff & f<betaBandHighCutoff);
                pfGammBand=find(f>=gammaBandLowCutoff & f<gammaBandHighCutoff);
                
                
                %%
                %%
                %tmp_V_DS = buffer(DataSeg_F,movWinSamples,movOLWinSamples,'nodelay');
                tmp_V_DS = buffer(thisSegData,movWinSamples,movOLWinSamples,'nodelay');
                
                pValid=all(~isnan(tmp_V_DS));
                
                [pxx,f] = pwelch(tmp_V_DS(:,pValid),segmentWelchSamples,samplesOLWelch,dftPointsWelch,Fs);
                
                %% Ratios
                deltaBetaRatioAll=zeros(1,numel(pValid));
                deltaBetaRatioAll(pValid)=(mean(pxx(pfDeltaBand,:))./mean(pxx(pfBetaBand,:)))';
                %
                deltaThetaRatioAll = zeros(1,numel(pValid));
                deltaThetaRatioAll(pValid)=(mean(pxx(pfDeltaBand,:))./mean(pxx(pfThetaBand,:)))';
                
                %     deltaThetaOGammeRatioAll = zeros(1,numel(pValid));
                %     deltaThetaOGammaRatioAll(pValid)=(mean(pxx(pfDeltaThetaBand,:))./mean(pxx(pfGammBand,:)))';
                
                %                 deltaAlphRatioAll = zeros(1,numel(pValid));
                %                 deltaAlphRatioAll(pValid)=(mean(pxx(pfDeltaBand,:))./mean(pxx(pfAlphaBand,:)))';
                %
                deltaGammaRatioAll = zeros(1,numel(pValid));
                deltaGammaRatioAll(pValid)=(mean(pxx(pfDeltaBand,:))./mean(pxx(pfGammBand,:)))';
                %
                %                 betaGammaRatioAll = zeros(1,numel(pValid));
                %                 betaGammaRatioAll (pValid)=(mean(pxx(pfBetaBand,:))./mean(pxx(pfGammBand,:)))';
                %
                %                 thetaGammaRatioAll = zeros(1,numel(pValid));
                %                 thetaGammaRatioAll (pValid)=(mean(pxx(pfThetaBand,:))./mean(pxx(pfGammBand,:)))';
                
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
                %
                
                %%
              
                bufferedDeltaBetaRatio(i,:)=deltaBetaRatioAll;
                %bufferedDeltaAlphaRatio(i,:)=deltaAlphRatioAll;
                bufferedDeltaThetaRatio(i,:)=deltaThetaRatioAll;
                bufferedDeltaGammaRatio(i,:)=deltaGammaRatioAll;
                %bufferedDeltaThetaOGammaRatio(i,:)=deltaThetaOGammaRatioAll;
                %bufferedDeltaThetaOGammaRatioCell{i} = deltaThetaOGammaRatioAll;
                
            else
                
               dataOffset = 0;
               
               figure(350); clf
                for i = 1:nBatches-1
                    
                    thisData = smooth(data(tOn_samp(i):tOn_samp(i)+batchDuration_samp), smoothWin_fs);
                    
                      figHH = figure(350); 
                      hold on
                timepoints_fs = tOn_samp(i):1:tOn_samp(i)+batchDuration_samp;
                timepoints_s = timepoints_fs/Fs;
                timepoints_s = timepoints_s - timepoints_s(1);
                plot(timepoints_s, thisData -dataOffset, 'k')
                %plot(thisData -dataOffset, 'k')
                axis tight
                xlabel('Time (s)')
                  annotation(figHH ,'textbox',[0.1 0.96 0.46 0.028],'String',[obj.PATH.currentFilename],'LineStyle','none','FitBoxToText','off', 'fontsize', 12);
                  
                  
                dataOffset = dataOffset+300;
                
                    [V_uV_data_full,nshifts] = shiftdim(thisData',-1);
                    thisSegData = V_uV_data_full(:,:,:);
                 
                    %segmentWelchSamples = round(segmentWelch*fobj.filt.FFs);
                    segmentWelchSamples = round(segmentWelch*Fs);
                    samplesOLWelch = round(segmentWelchSamples*OLWelch);
                    
                    %movWinSamples=round(movWin_Var*fobj.filt.FFs);%obj.filt.FFs in Hz, movWin in samples
                    %movOLWinSamples=round(movOLWin_Var*fobj.filt.FFs);
                    movWinSamples=round(movWin_Var*Fs);%obj.filt.FFs in Hz, movWin in samples
                    movOLWinSamples=round(movOLWin_Var*Fs);
                    
                    % run welch once to get frequencies for every bin (f) determine frequency bands
                    %[~,f] = pwelch(randn(1,movWinSamples),segmentWelchSamples,samplesOLWelch,dftPointsWelch,fobj.filt.FFs);
                    [~,f] = pwelch(randn(1,movWinSamples),segmentWelchSamples,samplesOLWelch,dftPointsWelch,Fs);
                 
                    
                    pfDeltaBand=find(f>=deltaBandLowCutoff & f<deltaBandHighCutoff);
                    pfThetaBand=find(f>=thetaBandLowCutoff & f<thetaBandHighCutoff);
                    pfDeltaThetaBand=find(f>=spindleLowCutoff & f<spindleHighCutoff);
                    %    pfDeltaThetaBand=find(f>=deltaThetaLowCutoff & f<deltaThetaHighCutoff);
                    pfAlphaBand=find(f>=alphaBandLowCutoff & f<alphaBandHighCutoff);
                    pfBetaBand=find(f>=betaBandLowCutoff & f<betaBandHighCutoff);
                    pfGammBand=find(f>=gammaBandLowCutoff & f<gammaBandHighCutoff);
                    
                    
                    %%
                    %%
                    %tmp_V_DS = buffer(DataSeg_F,movWinSamples,movOLWinSamples,'nodelay');
                    tmp_V_DS = buffer(thisSegData,movWinSamples,movOLWinSamples,'nodelay');
                    
                    pValid=all(~isnan(tmp_V_DS));
                    
                    [pxx,f] = pwelch(tmp_V_DS(:,pValid),segmentWelchSamples,samplesOLWelch,dftPointsWelch,Fs);
                    
                    %% Ratios
                    deltaBetaRatioAll=zeros(1,numel(pValid));
                    deltaBetaRatioAll(pValid)=(mean(pxx(pfDeltaBand,:))./mean(pxx(pfBetaBand,:)))';
                    %
                    deltaThetaRatioAll = zeros(1,numel(pValid));
                    deltaThetaRatioAll(pValid)=(mean(pxx(pfDeltaBand,:))./mean(pxx(pfThetaBand,:)))';
                    
                    %     deltaThetaOGammeRatioAll = zeros(1,numel(pValid));
                    %     deltaThetaOGammaRatioAll(pValid)=(mean(pxx(pfDeltaThetaBand,:))./mean(pxx(pfGammBand,:)))';
                    
                    %                 deltaAlphRatioAll = zeros(1,numel(pValid));
                    %                 deltaAlphRatioAll(pValid)=(mean(pxx(pfDeltaBand,:))./mean(pxx(pfAlphaBand,:)))';
                    %
                    deltaGammaRatioAll = zeros(1,numel(pValid));
                    deltaGammaRatioAll(pValid)=(mean(pxx(pfDeltaBand,:))./mean(pxx(pfGammBand,:)))';
                    %
                    %                 betaGammaRatioAll = zeros(1,numel(pValid));
                    %                 betaGammaRatioAll (pValid)=(mean(pxx(pfBetaBand,:))./mean(pxx(pfGammBand,:)))';
                    %
                    %                 thetaGammaRatioAll = zeros(1,numel(pValid));
                    %                 thetaGammaRatioAll (pValid)=(mean(pxx(pfThetaBand,:))./mean(pxx(pfGammBand,:)))';
                    
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
                    %
                    
                    %%
                    
                 
                    bufferedDeltaBetaRatio(i,:)=deltaBetaRatioAll;
                    %bufferedDeltaAlphaRatio(i,:)=deltaAlphRatioAll;
                    bufferedDeltaThetaRatio(i,:)=deltaThetaRatioAll;
                    bufferedDeltaGammaRatio(i,:)=deltaGammaRatioAll;
                    %bufferedDeltaThetaOGammaRatio(i,:)=deltaThetaOGammaRatioAll;
                    %bufferedDeltaThetaOGammaRatioCell{i} = deltaThetaOGammaRatioAll;
                    
                    %bufferedDelta(i,:)=deltaAll;
                    %bufferedBeta(i,:)=betaAll;
                    %bufferedTheta(i,:)=thetaAll;
                    %bufferedGamma(i,:)=gammaAll;
                    %bufferedAlpha(i,:)=alphaAll;
                    
                    %allV_DS{i} = squeeze(tmp_V_DS);
                    
                end
            end
            %%
            figH = figure(145);clf
            
              
              
               offsetDT = 0;   
            subplot(3, 2, 1)
            for o = 1:size(bufferedDeltaThetaRatio, 1)
                hold on
                plot(bufferedDeltaThetaRatio(o,:) - offsetDT)
                offsetDT = offsetDT+10;
            end
            axis tight
            title('Delta-to-Theta Ratio')
            
            subplot(3, 2, 2)
            imagesc(bufferedDeltaThetaRatio, [0 500])

            ytics = get(gca, 'ytick');
            ytics_Hr = ytics/2;
            ytics_Hr_round = [];
            for j = 1:numel(ytics_Hr)
                %ytics_Hr_round{j} = num2str(round(ytics_Hr(j)));
                ytics_Hr_round{j} = num2str(ytics_Hr(j));
            end
            set(gca, 'yticklabel', ytics_Hr_round)
            ylabel('Time [hr]')
            title('Delta-to-Theta Ratio')
            colorbar
            
              offsetDB = 0;
            subplot(3, 2, 3)
            for o = 1:size(bufferedDeltaBetaRatio, 1)
                hold on
            plot(bufferedDeltaBetaRatio(o,:) - offsetDB)
            offsetDB = offsetDB+100;
            end
            axis tight
            title('Delta-to-Beta Ratio')
            
            subplot(3, 2, 4)
            imagesc(bufferedDeltaBetaRatio, [0 1500])
            ytics = get(gca, 'ytick');
            ytics_Hr = ytics/2;
            ytics_Hr_round = [];
            for j = 1:numel(ytics_Hr)
                %ytics_Hr_round{j} = num2str(round(ytics_Hr(j)));
                ytics_Hr_round{j} = num2str(ytics_Hr(j));
            end
            set(gca, 'yticklabel', ytics_Hr_round)
            ylabel('Time [hr]')
            title('Delta-to-Beta Ratio')
            colorbar
             
            offsetDG = 0;
            subplot(3, 2, 5)
            for o = 1:size(bufferedDeltaBetaRatio, 1)
                hold on
            plot(bufferedDeltaGammaRatio(o,:) - offsetDG)
            offsetDG = offsetDG+500;
            end
            
            title('Delta-to-Gamma Ratio')
            xlabel('Time (s)')
            axis tight
            
            subplot(3, 2, 6)
            imagesc(bufferedDeltaGammaRatio, [0 30000])
            ytics = get(gca, 'ytick');
            ytics_Hr = ytics/2;
            ytics_Hr_round = [];
            for j = 1:numel(ytics_Hr)
                %ytics_Hr_round{j} = num2str(round(ytics_Hr(j)));
                ytics_Hr_round{j} = num2str(ytics_Hr(j));
            end
            set(gca, 'yticklabel', ytics_Hr_round)
            ylabel('Time [hr]')
            title('Delta-to-Gamma Ratio')
            colorbar
            xlabel('Time (s)')
            
            annotation(figH,'textbox',[0.1 0.96 0.46 0.028],'String',[obj.PATH.currentFilename],'LineStyle','none','FitBoxToText','off', 'fontsize', 12);
            
            %%
            plotpos = [0 0 35 15];
            
            dot = '.';
            
            thisFilename = obj.PATH.currentFilename(1:end-4);
            bla = find(thisFilename == dot);
            thisFilename(bla) = '-';
            
            plot_filename = [obj.PATH.Plots thisFilename '__DBMatrix'];
            print_in_A4(0, plot_filename, '-djpeg', 0, plotpos);
            %print_in_A4(0, plot_filename, '-depsc', 0, plotpos);
            
            figure(350)
            plot_filename = [obj.PATH.Plots thisFilename '__RawData'];
            print_in_A4(0, plot_filename, '-djpeg', 0, plotpos);
            
            
        end
        
        function obj = filterAndBinData_PlotMeans(obj)
            
            nSamples = obj.ANALYSIS.nDataPoints;
            Fs = obj.ANALYSIS.fs;
            recordingDuration_s  = nSamples/Fs;
            recordingDuration_hr = recordingDuration_s/3600;
            
            batchDuration_s = 1*20; % 20 s
            
            batchDuration_samp = batchDuration_s*Fs;
            
            tOn_s = 1:batchDuration_s:recordingDuration_s;
            tOn_samp = tOn_s*Fs;
            nBatches = numel(tOn_samp);
            
            %data = obj.ANALYSIS.RawValue;
            data = obj.ANALYSIS.thisData_noArtifacts;
            %data = obj.ANALYSIS.thisData_noArtifacts;
            smoothWin_fs = obj.ANALYSIS.smoothwin_fs;
            
            %% Filter defintitons
            
            deltaBandLowCutoff = 0.5;
            deltaBandHighCutoff = 4;
            
            thetaBandLowCutoff  = 4;
            thetaBandHighCutoff  = 8;
            
            alphaBandLowCutoff  = 8;
            alphaBandHighCutoff  = 12;
            
            spindleLowCutoff = 12;
            spindleHighCutoff = 16;
            
            betaBandLowCutoff = 16;
            betaBandHighCutoff = 32;
            
            gammaBandLowCutoff = 25;
            gammaBandHighCutoff = 100;
            
            %% Pwelch defintitions
            reductionFactor = 1; % No reduction
            
            movWin_Var = 10*reductionFactor; % 10 s
            movOLWin_Var = 9*reductionFactor; % 9 s
            
            segmentWelch = 1*reductionFactor;
            OLWelch = 0.5*reductionFactor;
            
            dftPointsWelch =  2^10;
            
            
            %%
            bufferedDeltaGammaRatio = [];
            bufferedDeltaBetaRatio = [];
           
               dataOffset = 0;
               
               figure(350); clf
                for i = 1:nBatches-1
                    
                    thisData = smooth(data(tOn_samp(i):tOn_samp(i)+batchDuration_samp), smoothWin_fs);
%                     
%                       figHH = figure(350); 
%                       hold on
%                 timepoints_fs = tOn_samp(i):1:tOn_samp(i)+batchDuration_samp;
%                 timepoints_s = timepoints_fs/Fs;
%                 timepoints_s = timepoints_s - timepoints_s(1);
%                 plot(timepoints_s, thisData -dataOffset, 'k')
%                 %plot(thisData -dataOffset, 'k')
%                 axis tight
%                 xlabel('Time (s)')
%                   annotation(figHH ,'textbox',[0.1 0.96 0.46 0.028],'String',[obj.PATH.currentFilename],'LineStyle','none','FitBoxToText','off', 'fontsize', 12);
%                   
                  
                dataOffset = dataOffset+300;
                
                    [V_uV_data_full,nshifts] = shiftdim(thisData',-1);
                    thisSegData = V_uV_data_full(:,:,:);
                 
                    %segmentWelchSamples = round(segmentWelch*fobj.filt.FFs);
                    segmentWelchSamples = round(segmentWelch*Fs);
                    samplesOLWelch = round(segmentWelchSamples*OLWelch);
                    
                    %movWinSamples=round(movWin_Var*fobj.filt.FFs);%obj.filt.FFs in Hz, movWin in samples
                    %movOLWinSamples=round(movOLWin_Var*fobj.filt.FFs);
                    movWinSamples=round(movWin_Var*Fs);%obj.filt.FFs in Hz, movWin in samples
                    movOLWinSamples=round(movOLWin_Var*Fs);
                    
                    % run welch once to get frequencies for every bin (f) determine frequency bands
                    %[~,f] = pwelch(randn(1,movWinSamples),segmentWelchSamples,samplesOLWelch,dftPointsWelch,fobj.filt.FFs);
                    [~,f] = pwelch(randn(1,movWinSamples),segmentWelchSamples,samplesOLWelch,dftPointsWelch,Fs);
                 
                    
                    pfDeltaBand=find(f>=deltaBandLowCutoff & f<deltaBandHighCutoff);
                    pfThetaBand=find(f>=thetaBandLowCutoff & f<thetaBandHighCutoff);
                    pfDeltaThetaBand=find(f>=spindleLowCutoff & f<spindleHighCutoff);
                    %    pfDeltaThetaBand=find(f>=deltaThetaLowCutoff & f<deltaThetaHighCutoff);
                    pfAlphaBand=find(f>=alphaBandLowCutoff & f<alphaBandHighCutoff);
                    pfBetaBand=find(f>=betaBandLowCutoff & f<betaBandHighCutoff);
                    pfGammBand=find(f>=gammaBandLowCutoff & f<gammaBandHighCutoff);
                    
                    
                    %%
                    %%
                    %tmp_V_DS = buffer(DataSeg_F,movWinSamples,movOLWinSamples,'nodelay');
                    tmp_V_DS = buffer(thisSegData,movWinSamples,movOLWinSamples,'nodelay');
                    
                    pValid=all(~isnan(tmp_V_DS));
                    
                    [pxx,f] = pwelch(tmp_V_DS(:,pValid),segmentWelchSamples,samplesOLWelch,dftPointsWelch,Fs);
                    
                    %% Ratios
                    deltaBetaRatioAll=zeros(1,numel(pValid));
                    deltaBetaRatioAll(pValid)=(mean(pxx(pfDeltaBand,:))./mean(pxx(pfBetaBand,:)))';
                    %
                    deltaThetaRatioAll = zeros(1,numel(pValid));
                    deltaThetaRatioAll(pValid)=(mean(pxx(pfDeltaBand,:))./mean(pxx(pfThetaBand,:)))';
                    
                    %     deltaThetaOGammeRatioAll = zeros(1,numel(pValid));
                    %     deltaThetaOGammaRatioAll(pValid)=(mean(pxx(pfDeltaThetaBand,:))./mean(pxx(pfGammBand,:)))';
                    
                    %                 deltaAlphRatioAll = zeros(1,numel(pValid));
                    %                 deltaAlphRatioAll(pValid)=(mean(pxx(pfDeltaBand,:))./mean(pxx(pfAlphaBand,:)))';
                    %
                    deltaGammaRatioAll = zeros(1,numel(pValid));
                    deltaGammaRatioAll(pValid)=(mean(pxx(pfDeltaBand,:))./mean(pxx(pfGammBand,:)))';
                    %
                    %                 betaGammaRatioAll = zeros(1,numel(pValid));
                    %                 betaGammaRatioAll (pValid)=(mean(pxx(pfBetaBand,:))./mean(pxx(pfGammBand,:)))';
                    %
                    %                 thetaGammaRatioAll = zeros(1,numel(pValid));
                    %                 thetaGammaRatioAll (pValid)=(mean(pxx(pfThetaBand,:))./mean(pxx(pfGammBand,:)))';
                    
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
                    %
                    
                    %%
                    
                 
                    bufferedDeltaBetaRatio(i,:)=deltaBetaRatioAll;
                    %bufferedDeltaAlphaRatio(i,:)=deltaAlphRatioAll;
                    bufferedDeltaThetaRatio(i,:)=deltaThetaRatioAll;
                    bufferedDeltaGammaRatio(i,:)=deltaGammaRatioAll;
                    %bufferedDeltaThetaOGammaRatio(i,:)=deltaThetaOGammaRatioAll;
                    %bufferedDeltaThetaOGammaRatioCell{i} = deltaThetaOGammaRatioAll;
                    
                    bufferedGamma(i,:)=gammaAll;
                    bufferedDelta(i,:)=deltaAll;
                    
                    
                    
                    %bufferedDelta(i,:)=deltaAll;
                    %bufferedBeta(i,:)=betaAll;
                    %bufferedTheta(i,:)=thetaAll;
                    %bufferedGamma(i,:)=gammaAll;
                    %bufferedAlpha(i,:)=alphaAll;
                    
                    %allV_DS{i} = squeeze(tmp_V_DS);
                    
                end
           
            %%
            
            
            mediansDG = nanmedian(bufferedDeltaGammaRatio, 2);
            concatDG = bufferedDeltaGammaRatio';
            concatDG = concatDG(:); 
            [idx,C] = kmeans(mediansDG, 2);

            [minVal, I] = min(C);
            [maxVal, II] = max(C);
            
            Rems_ind = find(idx == I);
            SWSs_ind = find(idx == II);
            
            idxInvert = idx;
            idxInvert(Rems_ind) = 2; 
            idxInvert(SWSs_ind) = -2; 
            
            Rems = numel(Rems_ind);
            SWSs = numel(SWSs_ind);
            
            TimeRems_s = Rems* batchDuration_s;
            TimeSWSs_s = SWSs * batchDuration_s;
            
          figH=  figure(144); clf 
            subplot(2, 3, [1 2])
            
            
            plot(idxInvert, 'k', 'linewidth', 2)
            axis tight
          %  ylim([0 3])
            ylim([-3 3])
            text(5, 2.5, 'REM')
            text(5, -2.5, 'SWS')
            set(gca,'ytick',[])
            
              xtics = get(gca, 'xtick');
            xtics_s = xtics*batchDuration_s;
            xtics_stxt = [];
            for j = 1:numel(xtics_s)
                xtics_stxt{j} = num2str(xtics_s(j));
            end
            set(gca, 'xticklabel', xtics_stxt)
            xlabel('Time (s)')
            titletxt = ['REM-SWS Hypnogram'];
            title(titletxt)
            
            REM_k = (floor(minVal)) ;
            SWS_k = (floor(maxVal)) ;
            
            REM_t = (Rems*batchDuration_s);
            SWS_t = (SWSs*batchDuration_s);
            
            totalTime_s = REM_t+SWS_t;
            
            REM_percent = REM_t/totalTime_s*100;
            SWS_percent = SWS_t/totalTime_s*100;
            
            
            subplot(2, 3, [4 5])
            imagesc(concatDG', [0 30000])
            colormap('parula')
            axis off
            title('Delta-Beta Ratio')
            
            %colorbar
            subplot(2, 3, 3)
            toPlot = [TimeRems_s TimeSWSs_s];
            leg = {'REM', 'SWS'};
            pie(toPlot)
            legend(leg)
            legend('location', 'northeastoutside')
          %colormap('bone')
          
          
          subplot(2, 3, 6)
          
          
%           Name = {'Baseline-Drug';'Recovery-Drug';'Baseline-Recovery'};
%           h = [h1;h2;h3];
%           p = [p1;p2;p3];
%           T = table(h,p,'RowNames',Name);
%           
          
            Name = {'Kmeans';'Time (s)'; 'Percents'};
    REM_stats = [REM_k; REM_t; REM_percent];
    SWS_stats = [SWS_k; SWS_t; SWS_percent];
    T = table(REM_stats,SWS_stats,'RowNames',Name);
    
    
    ha =       subplot(2, 3, 6);
    pos = get(ha,'Position');
    un = get(ha,'Units');
    delete(ha)
    
    ht = uitable('Data',T{:,:},'ColumnName',T.Properties.VariableNames,...
        'RowName',T.Properties.RowNames,'Units', un, 'Position',pos);
    ha =       subplot(2, 3, 6);
    title(['Sleep statistics - Total time: '  num2str(totalTime_s) 's'])
    
    annottxt = [obj.PATH.currentFilename ' | Start Time: ' obj.ANALYSIS.startTimeDate{1}(2:end-7) ' |  End Time: ' obj.ANALYSIS.endTimeDate{1}(2:end-7)];
           annotation(figH,'textbox',[0.1 0.96 0.46 0.028],'String',annottxt,'LineStyle','none','FitBoxToText','off', 'fontsize', 12);
            
           
%             
%             
%             concatGamma = bufferedGamma(:);
%             stdGamma = std(concatGamma);
%             normGamma = bufferedGamma./stdGamma;
%             
%             concatDelta = bufferedDelta(:);
%             stdDelta = std(concatDelta);
%             normDelta = bufferedDelta./stdDelta;
%             
%             DeltaMedians = nanmedian(normDelta, 2);
%             GammaMedians = nanmedian(normGamma, 2);
%             
%             
%             figH = figure(145);clf
%             subplot(2, 1, 1);
%             boxplot(normDelta', 'plotstyle', 'compact', 'colors', 'k', 'whisker', 10)
%             hold on
%             plot(DeltaMedians, 'k')
%           
%             
%             subplot(2, 1, 2)
%             boxplot(normGamma', 'plotstyle', 'compact', 'colors', 'k', 'whisker', 50)
%             hold on
%             plot(GammaMedians, 'k')
%             
%           
%             figure; 
%             boxplot(normDelta', 'plotstyle', 'compact', 'colors', 'k', 'whisker', 10)
%             hold on
%             boxplot(normGamma', 'plotstyle', 'compact', 'colors', 'k', 'whisker', 50)
%             
%                offsetDT = 0;   
%             subplot(3, 2, 1)
%             for o = 1:size(bufferedGamma, 1)
%                 hold on
%                 plot(bufferedDeltaThetaRatio(o,:) - offsetDT)
%                 offsetDT = offsetDT+10;
%             end
%             axis tight
%             title('Delta-to-Theta Ratio')
%             
%             subplot(3, 2, 2)
%             imagesc(bufferedDeltaThetaRatio, [0 500])
% 
%             ytics = get(gca, 'ytick');
%             ytics_Hr = ytics/2;
%             ytics_Hr_round = [];
%             for j = 1:numel(ytics_Hr)
%                 %ytics_Hr_round{j} = num2str(round(ytics_Hr(j)));
%                 ytics_Hr_round{j} = num2str(ytics_Hr(j));
%             end
%             set(gca, 'yticklabel', ytics_Hr_round)
%             ylabel('Time [hr]')
%             title('Delta-to-Theta Ratio')
%             colorbar
%             
%               offsetDB = 0;
%             subplot(3, 2, 3)
%             for o = 1:size(bufferedDeltaBetaRatio, 1)
%                 hold on
%             plot(bufferedDeltaBetaRatio(o,:) - offsetDB)
%             offsetDB = offsetDB+100;
%             end
%             axis tight
%             title('Delta-to-Beta Ratio')
%             
%             subplot(3, 2, 4)
%             imagesc(bufferedDeltaBetaRatio, [0 1500])
%             ytics = get(gca, 'ytick');
%             ytics_Hr = ytics/2;
%             ytics_Hr_round = [];
%             for j = 1:numel(ytics_Hr)
%                 %ytics_Hr_round{j} = num2str(round(ytics_Hr(j)));
%                 ytics_Hr_round{j} = num2str(ytics_Hr(j));
%             end
%             set(gca, 'yticklabel', ytics_Hr_round)
%             ylabel('Time [hr]')
%             title('Delta-to-Beta Ratio')
%             colorbar
%              
%             offsetDG = 0;
%             subplot(3, 2, 5)
%             for o = 1:size(bufferedDeltaBetaRatio, 1)
%                 hold on
%             plot(bufferedDeltaGammaRatio(o,:) - offsetDG)
%             offsetDG = offsetDG+500;
%             end
%             
%             title('Delta-to-Gamma Ratio')
%             xlabel('Time (s)')
%             axis tight
%             
%             subplot(3, 2, 6)
%             imagesc(bufferedDeltaGammaRatio, [0 30000])
%             ytics = get(gca, 'ytick');
%             ytics_Hr = ytics/2;
%             ytics_Hr_round = [];
%             for j = 1:numel(ytics_Hr)
%                 %ytics_Hr_round{j} = num2str(round(ytics_Hr(j)));
%                 ytics_Hr_round{j} = num2str(ytics_Hr(j));
%             end
%             set(gca, 'yticklabel', ytics_Hr_round)
%             ylabel('Time [hr]')
%             title('Delta-to-Gamma Ratio')
%             colorbar
%             xlabel('Time (s)')
%             
           
            %%
            plotpos = [0 0 35 20];
            
            dot = '.';
            
            thisFilename = obj.PATH.currentFilename(1:end-4);
            bla = find(thisFilename == dot);
            thisFilename(bla) = '-';
            
            plot_filename = [obj.PATH.Plots thisFilename '__DB-Times'];
            print_in_A4(0, plot_filename, '-djpeg', 0, plotpos);
            %print_in_A4(0, plot_filename, '-depsc', 0, plotpos);
            
        end
        
        
    end
    
    %%
    
    methods (Hidden)
        %class constructor
        function obj = Human_EEG_Analysis_OBJ(analysisDir)
            
            addpath(genpath(analysisDir))
            
            obj = getPathInfo(obj, analysisDir);
            
            
        end
    end
    
end


