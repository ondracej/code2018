classdef avianSWRAnalysis_OBJ < handle
    
    
    properties (Access = public)
        
        HOST
        INFO
        Session
        DIR
        REC
        Plotting
        Vid
        SWR
        
        ops
        
    end
    
    methods
        
        
        function [obj] = getTriggers(obj)
            dbstop if error
            
            %%
            obj.Plotting.titleTxt = [obj.INFO.Name ' | ' obj.Session.time];
            obj.Plotting.saveTxt = [obj.INFO.Name '_' obj.Session.time];
            
            %% Defining Path to data
            
            SessionDir = obj.DIR.ephysDir;
            
            VidName = obj.Vid.Names;
            nVidFrames = obj.Vid.frames;
            %
            TriggerFile = obj.REC.triggerChan;
            extSearch = ['*' TriggerFile '*'];
            allOpenEphysFiles=dir(fullfile(SessionDir,extSearch));
            
            tic
            [data, timestamps, info] = load_open_ephys_data([SessionDir allOpenEphysFiles.name]);
            %thisSegData_s = timestamps(1:end) - timestamps(1);
            toc
            disp('Finished loading data')
            
            disp('Finding peaks...')
            [pks,locs,w,p] = findpeaks(data, 'MinPeakHeight', 1);
            
            nTrigs = numel(locs);
            
            %% Figure out how many triggers are present for each frame
            
            divider = round(nTrigs/nVidFrames);
            
            trigs = locs;
            trigs = trigs(1:2:end,:);
            
            save([obj.DIR.analysisDir 'TRIGS.mat'], 'Trigs');
            
        end
        
        
        %% Plotting Raw data
        function [obj] = batchPlotDataForOpenEphys_multiChannel(obj, doPlot, seg)
            dbstop if error
            if nargin <3
                doPlot = 1;
                seg = 40; % seconds
            end
            %%
            obj.Plotting.titleTxt = [obj.INFO.Name ' | ' obj.Session.time];
            obj.Plotting.saveTxt = [obj.INFO.Name '_' obj.Session.time];
            
            %% Defining Path to data
            
            SessionDir = obj.Session.SessionDir;
            
            if isempty(SessionDir)
                disp('There is a typo in the database')
                keyboard
            end
            
            PlotDir = [obj.DIR.birdDir 'Plots' obj.DIR.dirD obj.DIR.dirName '_plots' obj.DIR.dirD];
            if exist(PlotDir, 'dir') == 0
                mkdir(PlotDir);
                disp(['Created: '  PlotDir])
            end
            
            extSearch ='*.continuous*';
            allOpenEphysFiles=dir(fullfile(SessionDir,extSearch));
            nFiles=numel(allOpenEphysFiles);
            
            chanSet=obj.REC.allChs;
            recordingDuration_s=obj.Session.recordingDur_s;
            Fs=obj.Session.sampleRate;
            
            %% Define Filters
            
            fObj = filterData(Fs);
            
            fobj.filt.FL=filterData(Fs);
            %fobj.filt.FL.lowPassPassCutoff=4.5;
            %fobj.filt.FL.lowPassPassCutoff=20;
            %fobj.filt.FL.lowPassStopCutoff=30;
            fobj.filt.FL.lowPassPassCutoff=30;% this captures the LF pretty well for detection
            fobj.filt.FL.lowPassStopCutoff=40;
            fobj.filt.FL.attenuationInLowpass=20;
            fobj.filt.FL=fobj.filt.FL.designLowPass;
            fobj.filt.FL.padding=true;
            
            fobj.filt.FH2=filterData(Fs);
            fobj.filt.FH2.highPassCutoff=100;
            fobj.filt.FH2.lowPassCutoff=2000;
            fobj.filt.FH2.filterDesign='butter';
            fobj.filt.FH2=fobj.filt.FH2.designBandPass;
            fobj.filt.FH2.padding=true;
            
            fobj.filt.FN =filterData(Fs);
            fobj.filt.FN.filterDesign='cheby1';
            fobj.filt.FN.padding=true;
            fobj.filt.FN=fobj.filt.FN.designNotch;
            
            %% Define Segements
            
            TOn=1:seg*Fs:(recordingDuration_s*Fs-seg*Fs);
            overlapWin=2*Fs;
            nCycles=numel(TOn);
            chanCnt = 1;
            
            for i=1:nCycles-1
                %for i=1:nCycles-1
                
                %         if i ==1
                %             thisROI = TOn(i):TOn(i+1);
                %         else
                %             thisROI = TOn(i)-overlapWin:TOn(i+1)-overlapWin;
                %         end
                
                thisROI = TOn(i):TOn(i+1)-1;
                
                offsetLP = 0;
                offsetHP = 0;
                offsetHP_R = 0;
                
                CDC = [];
                CDC.AllData = NaN(numel(thisROI), numel(chanSet));
                
                %% start loop over channel selectiondbquit
                
                figure(100); clf %raw
                figure(101); clf % LF
                figure(102); clf % HP-R
                figure(103); clf % HP
                
                for s=chanSet
                    
                    
                    %% Loading Data
                    %s=1;
                    %eval(['fileAppend = ''100_CH' num2str(s) '.continuous'';'])
                    eval(['fileAppend = ''101_CH' num2str(s) '.continuous'';'])
                    fileName = [SessionDir fileAppend];
                    
                    [data, timestamps, info] = load_open_ephys_data(fileName);
                    thisSegData_s = timestamps(1:end) - timestamps(1);
                    
                    samples = size(data, 1);
                    sampleRate = info.header.sampleRate;
                    
                    %%
                    if samples ~= obj.Session.samples
                        disp('Sample count mismatch..');
                        keyboard
                    end
                    
                    %% Put it in an array for the filters
                    [V_uV_data_full,nshifts] = shiftdim(data',-1);
                    %thisSegData = V_uV_data_full(:,:,:);
                    
                    SegData = V_uV_data_full(:,:, thisROI);
                    SegData_s = thisSegData_s(thisROI);
                    
                    %DataSeg_FNotch = squeeze(fobj.filt.FN.getFilteredData(SegData));
                    DataSeg_LF = squeeze(fobj.filt.FL.getFilteredData(SegData));
                    DataSeg_HF = squeeze(fobj.filt.FH2.getFilteredData(SegData));
                    Data_SegData = squeeze(SegData);
                    
                    CDC.AllData(:,chanCnt) = Data_SegData;
                    CDC.SegData_s = SegData_s;
                    CDC.sampleRate = sampleRate;
                    CDC.maxSamples = samples;
                    
                    CDCSaveTxt = ['_' num2str(SegData_s(1)) '-' num2str(SegData_s(end)) 's'];
                    
                    chanCnt = chanCnt +1;
                    
                    %% Smooth for HP rect
                    
                    smoothWin = 0.10*Fs; % smoothing w 100 ms
                    %DataSeg_LF_neg = -DataSeg_LF;
                    DataSeg_rect_HF = smooth(DataSeg_HF.^2, smoothWin);
                    
                    %% Plotting
                    if doPlot
                        %% Prepare Figs and counters
                        
                        % Raw Data
                        FigHRaw = figure(100); hold on
                        plot(SegData_s, Data_SegData + offsetLP); %title( ['Raw Voltage']);
                        text(SegData_s(1), Data_SegData(1)+offsetLP, ['Ch-' num2str(s)])
                        axis tight
                        
                        % Low Frequency
                        FigHLD = figure(101); hold on
                        plot(SegData_s, DataSeg_LF + offsetLP);
                        text(SegData_s(1), DataSeg_LF(1)+offsetLP, ['Ch-' num2str(s)])
                        axis tight
                        
                        % High Pass Rectified
                        FigHHighRect = figure(102); hold on
                        plot(SegData_s, DataSeg_rect_HF + offsetHP_R);
                        %text(SegData_s(1), DataSeg_rect_HF(1)+offsetHP_R, ['Ch-' num2str(s)])
                        axis tight
                        
                        % High Pass
                        FigHHigh = figure(103); hold on
                        plot(SegData_s, DataSeg_HF + offsetHP);
                        text(SegData_s(1), DataSeg_HF(1)+offsetHP, ['Ch-' num2str(s)])
                        axis tight
                        
                        offsetLP  = offsetLP + obj.Plotting.rawOffset;
                        offsetHP  = offsetHP + obj.Plotting.hpOffset;
                        offsetHP_R  = offsetHP_R + obj.Plotting.hpRectOffset;
                        
                    end
                end
                
                %% Final Fig modifications
                if doPlot
                    
                    % Raw Data
                    figure(FigHRaw)
                    axis tight
                    ylim(obj.Plotting.rawYlim);
                    xlabel('Time [s]')
                    title(['Raw Voltage: '  obj.Plotting.titleTxt ' | ' sprintf('%03d', i)])
                    saveName = [PlotDir obj.Plotting.saveTxt '_Raw_' sprintf('%03d', i)];
                    plotpos = [0 0 30 15];
                    print_in_A4(0, saveName, '-djpeg', 0, plotpos);
                    %print_in_A4(0, saveName, '-depsc', 0, plotpos);
                    
                    % Low Frequency
                    figure(FigHLD)
                    axis tight
                    ylim(obj.Plotting.rawYlim);
                    title( ['LF:' obj.Plotting.titleTxt ' | ' sprintf('%03d', i)])
                    xlabel('Time [s]')
                    saveName = [PlotDir obj.Plotting.saveTxt '_LF_' sprintf('%03d', i)];
                    plotpos = [0 0 30 15];
                    print_in_A4(0, saveName, '-djpeg', 0, plotpos);
                    %print_in_A4(0, saveName, '-depsc', 0, plotpos);
                    
                    % High Pass Rectified
                    figure(FigHHighRect)
                    axis tight
                    ylim(obj.Plotting.hpRectYlim);
                    title( ['HF Rectified: ' obj.Plotting.titleTxt ' | ' sprintf('%03d', i)])
                    xlabel('Time [s]')
                    saveName = [PlotDir obj.Plotting.saveTxt '_HFR_' sprintf('%03d', i)];
                    plotpos = [0 0 30 15];
                    print_in_A4(0, saveName, '-djpeg', 0, plotpos);
                    %print_in_A4(0, saveName, '-depsc', 0, plotpos);
                    
                    % High Pass
                    figure(FigHHigh)
                    axis tight
                    ylim(obj.Plotting.hpYlim)
                    title( ['HF: ' obj.Plotting.titleTxt ' | ' sprintf('%03d', i)])
                    xlabel('Time [s]')
                    saveName = [PlotDir obj.Plotting.saveTxt '_HF_' sprintf('%03d', i)];
                    plotpos = [0 0 30 15];
                    print_in_A4(0, saveName, '-djpeg', 0, plotpos);
                    %print_in_A4(0, saveName, '-depsc', 0, plotpos);
                    
                end
                
                %% Saving Data
                saveName = [PlotDir obj.Plotting.saveTxt '_CSD_' sprintf('%03d', i) '_' CDCSaveTxt '.mat'];
                save(saveName, 'CDC', '-v7.3')
                disp(['Saved: ' saveName])
            end
            
        end
        
        function [obj] = batchPlotDataForOpenEphys_singleChannel(obj, doPlot, seg)
            dbstop if error
            if nargin <3
                doPlot = 1;
                seg = 40; % seconds
            end
            
            obj.Plotting.titleTxt = [obj.INFO.Name ' | ' obj.Session.time];
            obj.Plotting.saveTxt = [obj.INFO.Name '_' obj.Session.time];
            
            %% Defining Path to data
            
            SessionDir = obj.Session.SessionDir;
            
            if isempty(SessionDir)
                disp('There is a typo in the database')
                keyboard
            end
            
            PlotDir = [obj.DIR.birdDir 'Plots' obj.DIR.dirD obj.DIR.dirName '_plots' obj.DIR.dirD];
            if exist(PlotDir, 'dir') == 0
                mkdir(PlotDir);
                disp(['Created: '  PlotDir])
            end
            
            extSearch ='*.continuous*';
            allOpenEphysFiles=dir(fullfile(SessionDir,extSearch));
            nFiles=numel(allOpenEphysFiles);
            
            chanSet=obj.REC.allChs;
            recordingDuration_s=obj.Session.recordingDur_s;
            Fs=obj.Session.sampleRate;
            
            if numel(chanSet) > 1
                plotMulti = 1;
            else
                plotMulti = 0;
            end
            
            
            %% Define Filters
            
            
            
            %% Define Segements
            
            TOn=1:seg*Fs:(recordingDuration_s*Fs-seg*Fs);
            overlapWin=2*Fs;
            nCycles=numel(TOn);
            chanCnt = 1;
            
            %% start loop over channel selectiondbquit
            
            for s=chanSet
                
                %% Loading Data
                %s=1;
                eval(['fileAppend = ''100_CH' num2str(s) '.continuous'';'])
                fileName = [SessionDir fileAppend];
                
                [data, timestamps, info] = load_open_ephys_data(fileName);
                thisSegData_s = timestamps(1:end) - timestamps(1);
                
                samples = numel(data);
                sampleRate = info.header.sampleRate;
                
                %%
                if samples ~= obj.Session.samples
                    disp('Sample count mismatch..');
                    keyboard
                end
                
                for i=1:nCycles-1
                    
                    %         if i ==1
                    %             thisROI = TOn(i):TOn(i+1);
                    %         else
                    %             thisROI = TOn(i)-overlapWin:TOn(i+1)-overlapWin;
                    %         end
                    
                    thisROI = TOn(i):TOn(i+1)-1;
                    
                    offsetLP = 0;
                    offsetHP = 0;
                    offsetHP_R = 0;
                    
                    CDC = [];
                    CDC.AllData = NaN(numel(thisROI), numel(chanSet));
                    
                    %% Put it in an array for the filters
                    [V_uV_data_full,nshifts] = shiftdim(data',-1);
                    %thisSegData = V_uV_data_full(:,:,:);
                    
                    SegData = V_uV_data_full(:,:, thisROI);
                    SegData_s = thisSegData_s(thisROI);
                    
                    %DataSeg_FNotch = squeeze(fobj.filt.FN.getFilteredData(SegData));
                    DataSeg_LF = squeeze(fobj.filt.FL.getFilteredData(SegData));
                    DataSeg_HF = squeeze(fobj.filt.FH2.getFilteredData(SegData));
                    Data_SegData = squeeze(SegData);
                    
                    CDC.AllData(:,chanCnt) = Data_SegData;
                    CDC.SegData_s = SegData_s;
                    CDC.sampleRate = sampleRate;
                    CDC.maxSamples = samples;
                    
                    CDCSaveTxt = ['_' num2str(SegData_s(1)) '-' num2str(SegData_s(end)) 's'];
                    
                    chanCnt = chanCnt +1;
                    
                    %% Smooth for HP rect
                    
                    smoothWin = 0.10*Fs; % smoothing w 100 ms
                    %DataSeg_LF_neg = -DataSeg_LF;
                    DataSeg_rect_HF = smooth(DataSeg_HF.^2, smoothWin);
                    
                    %% Plotting
                    
                    if doPlot
                        %% Prepare Figs and counters
                        
                        % Raw Data
                        FigH = figure(300); clf;
                        subplot(2, 1, 1)
                        plot(SegData_s, Data_SegData + offsetLP, 'k'); %title( ['Raw Voltage']);
                        text(SegData_s(1), Data_SegData(1)+obj.Plotting.rawOffset/2, ['Ch-' num2str(s)])
                        grid 'on'
                        
                        % Low Frequency
                        %plot(SegData_s, DataSeg_LF - Plotting.rawOffset, 'b');
                        
                        % High Pass Rectified
                        subplot(2, 1, 2)
                        % High Pass
                        hold on
                        plot(SegData_s, DataSeg_HF + offsetHP);
                        plot(SegData_s, DataSeg_rect_HF - obj.Plotting.hpRectOffset, 'r');
                        grid 'on'
                        
                        
                        %% Final Fig modifications
                        
                        figure(FigH)
                        subplot(2, 1, 1)
                        axis tight
                        ylim(obj.Plotting.rawYlim);
                        title(['Raw Voltage: '  obj.Plotting.titleTxt ' | ' sprintf('%03d', i)])
                        
                        subplot(2, 1, 2)
                        axis tight
                        ylim(obj.Plotting.hpRectYlim);
                        title( ['HF Rectified: ' obj.Plotting.titleTxt])
                        xlabel('Time [s]')
                        
                        saveName = [PlotDir obj.Plotting.saveTxt '_Raw-HP-singleChan_' sprintf('%03d', i)];
                        plotpos = [0 0 30 15];
                        print_in_A4(0, saveName, '-djpeg', 0, plotpos);
                        
                        
                    end
                    %% Saving Data
                    saveName = [PlotDir obj.Plotting.saveTxt '_CSD_' sprintf('%03d', i) '_' CDCSaveTxt '.mat'];
                    save(saveName, 'CDC', '-v7.3')
                    disp(['Saved: ' saveName])
                end
            end
        end
        
        %% Preparation for Sebastians SWR detection
        function [obj] = prepareDataForShWRDetection_Python(obj, chanOverride, durCutoffOverride)
            dbstop if error
            if nargin <3
                chanOverride = obj.REC.bestChs(1);
                durCutoffOverride = 1800;
            end
            
            chanToUse = chanOverride;
            durCutoff_s = durCutoffOverride;
            Fs = obj.Session.sampleRate;
            samples = obj.Session.samples;
            
            if samples > 1800*Fs
                durCutoff_s = 1800;
            end
            
            SessionDir = obj.Session.SessionDir;
            
            obj.Session.SessionDir;
            
            TOn=1:durCutoff_s*Fs:samples;
            nCycles=numel(TOn);
            
            eval(['fileAppend = ''100_CH' num2str(chanToUse) '.continuous'';'])
            fileName = [SessionDir fileAppend];
            
            [data, timestamps, info] = load_open_ephys_data(fileName);
            thisSegData_s = timestamps(1:end) - timestamps(1);
            
            saveDir = [SessionDir 'SWR-Python' obj.DIR.dirD];
            
            if exist(saveDir, 'dir') == 0
                mkdir(saveDir);
                disp(['Created: '  saveDir])
            end
            
            INFO.dataDir = fileName;
            INFO.fs = Fs;
            INFO.samples = samples;
            
            for i=1:nCycles
                dataSegs_V_raw = []; data_t_s = [];
                
                if i == nCycles
                    thisROI = TOn(i): samples;
                else
                    thisROI = TOn(i):TOn(i+1)-1;
                end
                
                disp(['Cycle=' num2str(i) '/' num2str(nCycles)])
                
                dataSegs_V_raw = data(thisROI);
                data_t_s = thisSegData_s(thisROI);
                Fs = info.header.sampleRate;
                
                disp('Saving...')
                saveName = [saveDir obj.Session.time '-Ch-' num2str(chanToUse) '_' sprintf('%03d', i) '.mat'];
                save(saveName, 'dataSegs_V_raw', 'data_t_s', 'INFO', '-v7.3')
                disp(['Saving:' saveName])
                %}
            end
            
        end
        
        function [obj] = prepareDataForShWRDetection_FullFile_Python(obj, chanOverride)
            dbstop if error
            if nargin <2
                chanOverride = obj.REC.bestChs(1);
            end
            
            chanToUse = chanOverride;
            Fs = obj.Session.sampleRate;
            samples = obj.Session.samples;
            
            SessionDir = obj.Session.SessionDir;
            obj.Session.SessionDir;
            
            eval(['fileAppend = ''100_CH' num2str(chanToUse) '.continuous'';'])
            fileName = [SessionDir fileAppend];
            
            [data, timestamps, info] = load_open_ephys_data(fileName);
            thisSegData_s = timestamps(1:end) - timestamps(1);
            
            saveDir = [SessionDir 'SWR-Python' obj.DIR.dirD];
            
            if exist(saveDir, 'dir') == 0
                mkdir(saveDir);
                disp(['Created: '  saveDir])
            end
            
            INFO.dataDir = fileName;
            INFO.fs = Fs;
            INFO.samples = samples;
            
            
            dataSegs_V_raw = data;
            data_t_s = thisSegData_s;
            Fs = info.header.sampleRate;
            
            disp('Saving...')
            saveName = [saveDir obj.Session.time '-Ch-' num2str(chanToUse) '_py_fullFile.mat'];
            save(saveName, 'dataSegs_V_raw', 'data_t_s', 'INFO', '-v7.3')
            disp(['Saved: ' saveName])
            
        end
        
        %% SWR Analysis
        function [obj] = SWR_PythonDetections_shapeStatistics(obj, useNotch)
            if nargin <2
                useNotch = 0;
            end
            
            SWR_Python_Dir = [obj.Session.SessionDir 'SWR-Python' obj.DIR.dirD];
            obj.DIR.SWR_Python_Dir = SWR_Python_Dir;
            
            obj.Plotting.titleTxt = [obj.INFO.Name ' | ' obj.Session.time];
            obj.Plotting.saveTxt = [obj.INFO.Name '_' obj.Session.time];
            
            
            textSearch = '*export_ripples*'; % text search for ripple detection file
            SWR_DetectionsDir = dir(fullfile(SWR_Python_Dir,textSearch));
            
            textSearch = '*_data*'; % text search for data .mat file
            SWR_DataDir = dir(fullfile(SWR_Python_Dir,textSearch));
            
            rD = load([SWR_Python_Dir SWR_DetectionsDir.name]);
            rippleDetections = double(rD.data); % ins samples of the original data file
            rippleDetectionsx50 = rippleDetections*50; % we do this cuz the resolution of the python code is 50
            nRippleDetections = numel(rippleDetectionsx50);
            
            disp('Loading data...')
            sD = load([SWR_Python_Dir SWR_DataDir.name]);
            
            swrData =  sD.dataSegs_V_raw;
            Fs =  sD.INFO.fs;
            
            %% Defining Filters
            fObj = filterData(Fs);
            fobj.filt.FL=filterData(Fs);
            %fobj.filt.FL.lowPassPassCutoff=4.5;
            %fobj.filt.FL.lowPassPassCutoff=20;
            %fobj.filt.FL.lowPassStopCutoff=30;
            fobj.filt.FL.lowPassPassCutoff=30;% this captures the LF pretty well for detection
            fobj.filt.FL.lowPassStopCutoff=40;
            fobj.filt.FL.attenuationInLowpass=20;
            fobj.filt.FL=fobj.filt.FL.designLowPass;
            fobj.filt.FL.padding=true;
            
            fobj.filt.FH2=filterData(Fs);
            fobj.filt.FH2.highPassCutoff=100;
            fobj.filt.FH2.lowPassCutoff=2000;
            fobj.filt.FH2.filterDesign='butter';
            fobj.filt.FH2=fobj.filt.FH2.designBandPass;
            fobj.filt.FH2.padding=true;
            
            fobj.filt.FN =filterData(Fs);
            fobj.filt.FN.filterDesign='cheby1';
            fobj.filt.FN.padding=true;
            fobj.filt.FN=fobj.filt.FN.designNotch;
            
            
            %% Filtering Data
            
            [V_uV_data_full,nshifts] = shiftdim(swrData',-1);
            
            thisSegData = V_uV_data_full(:,:,:);
            thisSegData_s = sD.data_t_s;
            
            disp('Filtering...')
            DataSeg_FNotch = squeeze(fobj.filt.FN.getFilteredData(thisSegData));
            DataSeg_HF = squeeze(fobj.filt.FH2.getFilteredData(thisSegData));
            DataSeg_LF = squeeze(fobj.filt.FL.getFilteredData(thisSegData));
            
            win_s = 1;
            win_samp = win_s*Fs;
            timestamps_samp = -win_samp:1:win_samp;
            timestamps_ms = (timestamps_samp/Fs)*1000;
            
            for j = 1:nRippleDetections
                
                if rippleDetectionsx50(j) - win_samp > 0 && rippleDetectionsx50(j)+ win_samp <  sD.INFO.samples
                    
                    thisROI = rippleDetectionsx50(j)-win_samp:rippleDetectionsx50(j)+win_samp;
                    
                    allSWRs_raw(:,j) = swrData(thisROI);
                    allSWRs_raw_notch(:,j) = DataSeg_FNotch(thisROI);
                    allSWRs_HP(:,j) = DataSeg_HF(thisROI);
                    allSWRs_LF(:,j) = DataSeg_LF(thisROI);
                    
                end
            end
            
            meanRipple_raw = nanmean(allSWRs_raw, 2);
            medianRipple_raw = nanmedian(allSWRs_raw, 2);
            sem_raw = (std(allSWRs_raw'))/(sqrt(size(allSWRs_raw, 2)));
            
            meanRipple_rawNotch = nanmean(allSWRs_raw_notch, 2);
            medianRipple_rawNotch = nanmedian(allSWRs_raw_notch, 2);
            sem_rawNotch = (std(allSWRs_raw_notch'))/(sqrt(size(allSWRs_raw_notch, 2)));
            
            meanRipple_LF = nanmean(allSWRs_LF, 2);
            medianRipple_LF = nanmedian(allSWRs_LF, 2);
            sem_LF = (std(allSWRs_LF'))/(sqrt(size(allSWRs_LF, 2)));
            
            %meanRipple_HP = nanmean(abs(allSWRs_HP), 2);
            meanRipple_HP = nanmean(allSWRs_HP, 2);
            sumRipple_HP = sum(allSWRs_HP, 2);
            medianRipple_HP = nanmedian(allSWRs_HP, 2);
            sem_HP = (std(allSWRs_HP'))/(sqrt(size(allSWRs_HP, 2)));
            
            %%
            
            %% Package data
            SWR.Raw.raw = allSWRs_raw;
            SWR.Raw.mean = meanRipple_raw;
            SWR.Raw.median = medianRipple_raw;
            SWR.Raw.sem = sem_raw;
            
            SWR.Notch.raw = allSWRs_raw_notch;
            SWR.Notch.mean = meanRipple_rawNotch;
            SWR.Notch.median = medianRipple_rawNotch;
            SWR.Notch.sem = sem_rawNotch;
            
            SWR.LF.raw = allSWRs_LF;
            SWR.LF.mean = meanRipple_LF;
            SWR.LF.median = medianRipple_LF;
            SWR.LF.sem = sem_LF;
            
            SWR.HP.raw = allSWRs_HP;
            SWR.HP.mean = meanRipple_HP;
            SWR.HP.median = medianRipple_HP;
            SWR.HP.sem = sem_HP;
            
            SWR.detections_samps = rippleDetectionsx50;
            SWR.timestamps_ms = timestamps_ms;
            SWR.win_samp = win_samp;
            SWR.Fs = Fs;
            
            %% plot
            if useNotch
                data = SWR.Notch;
            else
                data = SWR.Raw;
            end
            
            figH = figure(100); clf
            subplot(5, 1, [1 2 3 4])
            jbfill(timestamps_ms,[data.mean'+ data.sem],[data.mean'-data.sem],[.5,0.5,.5],[.5,0.5,.5],[],.3);
            hold on
            plot(timestamps_ms, data.mean, 'k')
            
            jbfill(timestamps_ms,[meanRipple_LF'+sem_LF],[meanRipple_LF'-sem_LF],[.5,0.5,.5],[.5,0.5,.5],[],.3);
            hold on
            plot(timestamps_ms, meanRipple_LF, 'r')
            title( ['SWR: ' obj.Plotting.titleTxt ' | n = ' num2str(nRippleDetections) ' SWRs in ' num2str(round(obj.Session.recordingDur_hr, 2, 'decimals')) ' hrs'])
            
            subplot(5, 1, 5)
            jbfill(timestamps_ms,[meanRipple_HP'+sem_HP],[meanRipple_HP'-sem_HP],[.5,0.5,.5],[.5,0.5,.5],[],.3);
            hold on
            %jbfill(timestamps_ms,[sumRipple_HP'+sem_HP],[sumRipple_HP'-sem_HP],[.5,0.5,.5],[.5,0.5,.5],[],.3);
            plot(timestamps_ms, meanRipple_HP, 'k')
            axis tight
            ylim([-2 2])
            
            xlabel('Time [ms]')
            obj.Plotting.titleTxt = [obj.INFO.Name ' | ' obj.Session.time];
            obj.Plotting.saveTxt = [obj.INFO.Name '_' obj.Session.time];
            
            %%
            PlotDir = [obj.DIR.birdDir 'Plots' obj.DIR.dirD obj.DIR.dirName '_plots' obj.DIR.dirD];
            figure(figH)
            saveName = [PlotDir obj.Plotting.saveTxt '_SWR_shape'];
            plotpos = [0 0 10 20];
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
            
            %% Saving Data
            saveName = [SWR_Python_Dir 'SWR.mat'];
            save(saveName, 'SWR', '-v7.3')
            disp(['Saved: ' saveName])
            
        end
        
        function [obj] = SWR_wavelet(obj, waveletInd, useNotch)
            
            
            %% Load "SWR_data.mat"
            
            textSearch = '*SWR.mat*'; % text search for ripple detection file
            SWR_datafile = dir(fullfile(obj.DIR.SWR_Python_Dir,textSearch));
            PlotDir = [obj.DIR.birdDir 'Plots' obj.DIR.dirD obj.DIR.dirName '_plots' obj.DIR.dirD];
            
            disp('Loading...')
            sD = load([obj.DIR.SWR_Python_Dir SWR_datafile.name]);
            
            Fs = sD.SWR.Fs;
            
            if useNotch
                data =   sD.SWR.Notch;
            else
                data =   sD.SWR.Raw;
            end
            
            for j = 1:2
                
                %waveletInd = 5;
                
                if j ==1
                    RawData = data.mean;
                    Wavdata = sD.SWR.HP.mean;
                    figH = figure(100+j);clf
                    clims = [0 .5];
                    saveName = [PlotDir obj.Plotting.saveTxt '_SWR_wavelet_mean'];
                elseif j==2
                    RawData = data.raw(:,waveletInd );
                    Wavdata = sD.SWR.HP.raw(:,waveletInd );
                    saveName = [PlotDir obj.Plotting.saveTxt '_SWR_wavelet_single'];
                    clims = [0 20];
                    figH = figure(100+j);clf
                end
                
                %thisSegData_wav = Wavdata(1:6000);
                thisSegData_wav = Wavdata;
                [thisSegData_wav,nshifts] = shiftdim(thisSegData_wav',-1);
                
                dsf = 20;
                Fsd = Fs/dsf;
                hcf = 400;
                [n_ch,n_tr,N] = size(thisSegData_wav);
                
                [bb,aa] = butter(2,hcf/(Fs/2),'low');
                V_ds = reshape(permute(thisSegData_wav,[3 1 2]),[],n_ch*n_tr);
                V_ds = downsample(filtfilt(bb,aa,V_ds),dsf);
                V_ds = reshape(V_ds,[],n_ch,n_tr);
                
                %
                [N,n_chs,n_trials] = size(V_ds);
                nfreqs = 60;
                min_freq = 1.5;
                max_freq = 800;
                Fsd = Fs/dsf;
                min_scale = 1/max_freq*Fsd;
                max_scale = 1/min_freq*Fsd;
                wavetype = 'cmor1-1';
                scales = logspace(log10(min_scale),log10(max_scale),nfreqs);
                wfreqs = scal2frq(scales,wavetype,1/Fsd);
                
                use_ch = 1;
                cur_V = squeeze(V_ds(:,use_ch,:));
                V_wave = cwt(cur_V(:),scales,wavetype);
                V_wave = reshape(V_wave,nfreqs,[],n_trials);
                
                %% Mean PLot
                
                tr =1;
                ax1 = subplot(3,1,1);
                plot(sD.SWR.timestamps_ms,RawData, 'k');
                axis tight
                xlim([-300 300])
                title( ['SWR-Wavelet: ' obj.Plotting.titleTxt])
                
                ax2 = subplot(3,1,2);
                plot(sD.SWR.timestamps_ms,Wavdata, 'k');
                axis tight
                xlim([-300 300])
                
                %bla= 22:0.04:22.50;
                %set(gca, 'xtick', bla)
                
                ax3 = subplot(3,1,3);
                pcolor((1:N)/Fsd,wfreqs,abs(squeeze(V_wave(:,:,tr))));shading flat
                %set(gca,'yscale','log');
                axis tight
                ylim([0 800])
                %caxis(clims);
                caxis(clims);
                xlim([0.7 1.3])
                
                xlabel('Time [ms]')
                ylabel('Frequency [Hz]')
                
                %%
                figure(figH)
                plotpos = [0 0 10 20];
                print_in_A4(0, saveName, '-djpeg', 0, plotpos);
                
                disp('')
            end
            
        end
        
        function [obj] = SWR_raster(obj, binSize_s)
            
            if nargin <2
                binSize_s = 10;
            end
            
            %% Load "SWR_data.mat"
            
            textSearch = '*SWR.mat*'; % text search for ripple detection file
            SWR_datafile = dir(fullfile(obj.DIR.SWR_Python_Dir,textSearch));
            PlotDir = [obj.DIR.birdDir 'Plots' obj.DIR.dirD obj.DIR.dirName '_plots' obj.DIR.dirD];
            
            disp('Loading...')
            sD = load([obj.DIR.SWR_Python_Dir SWR_datafile.name]);
            
            Fs = sD.SWR.Fs;
            SWRDetections_samps = sD.SWR.detections_samps;
            
            figure(100); clf
            %binSize = 5; % s
            length_this_stim = binSize_s *Fs;
            TOns = 1:length_this_stim:SWRDetections_samps(end);
            nTOns = numel(TOns);
            
            allSpksFR = zeros(length_this_stim,1);
            
            spk_size_y = 0.005;
            y_offset_between_repetitions = 0.001;
            
            figH = figure(100); clf
            subplot(1, 5, [1 2 3 4])
            FreqPLot = [];
            
            for s = 1 : nTOns-1
                start_stim = TOns(s);
                stop_stim = TOns(s+1)-1;
                
                %must subtract start_stim to arrange spikes relative to onset
                
                these_spks_on_chan = SWRDetections_samps(SWRDetections_samps >= start_stim & SWRDetections_samps <= stop_stim)-start_stim;
                
                y_low =  (s * spk_size_y - spk_size_y);
                y_high = (s * spk_size_y - y_offset_between_repetitions);
                
                spk_vct = repmat(these_spks_on_chan, 2, 1); % this draws a straight vertical line
                this_run_spks = size(spk_vct, 2);
                ln_vct = repmat([y_high; y_low], 1, this_run_spks); % this defines the line height
                
                line(spk_vct, ln_vct, 'LineWidth', 0.5, 'Color', 'k');
                
                nbr_spks = size(these_spks_on_chan, 2);
                
                FreqPLot(s) = nbr_spks;
            end
            
            xtickss = 0:2*Fs:10*Fs;
            axis tight
            
            set(gca, 'xtick', xtickss)
            xtickabs = {'0', '2', '4', '6', '8', '10'};
            set(gca, 'xticklabel', xtickabs )
            xlabel('Time [s]')
            title( ['SWR-Raster: ' obj.Plotting.titleTxt])
            
            subplot(1, 5, 5); cla
            
            FreqPLot_Hz = FreqPLot/binSize_s;
            xes = 1:1:numel(FreqPLot_Hz);
            plot(smooth(FreqPLot_Hz), xes)
            axis tight
            xtickss = 0:0.5:2.5;
            set(gca, 'xtick', xtickss)
            xlim([0 1])
            title('SWR Rate')
            xlabel('Freq. [Hz]')
            
            saveName = [PlotDir obj.Plotting.saveTxt '_SWR_raster'];
            
            plotpos = [0 0 15 10];
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
            %print_in_A4(0, saveName, '-depsc', 0, plotpos);
            
            
            
        end
        
        %% Spike Sorting
        
        function [obj] = runKilosortFromConfigFile(obj, pathToConfigFile, nameOfConfigFile)
            
            run(fullfile(pathToConfigFile, nameOfConfigFile))
            
            obj.ops = ops;
            
            %% Chan Config
            %{
            Nchannels = 16;
            connected = true(Nchannels, 1);
            chanMap   = [2 7 15 10 13 12 14 11 1 8 16 9 3 6 4 5];
            %chanMap   = [1:Nchannels];
            chanMap0ind = chanMap - 1;
            xcoords   = ones(Nchannels,1);
            ycoords   = 50 * [1:16]; % 50 micron space,
            kcoords   = ones(Nchannels,1); % grouping of channels (i.e. tetrode groups)
            
            fs = 30000; % sampling frequency
            save('C:\Users\Administrator\Documents\code\GitHub\code2018\KiloSortProj\KiloSortConfigFiles\chanMap.mat', 'chanMap','connected', 'xcoords', 'ycoords', 'kcoords', 'chanMap0ind', 'fs')
            %}
            
            %             Nchannels = 2;
            %             connected = true(Nchannels, 1);
            %             %chanMap   = [6 11 3 14 1 16 2 15 5 12 4 13 7 10 8 9];
            %             chanMap   = [2 10];
            %             chanMap0ind = chanMap - 1;
            %             xcoords   = ones(Nchannels,1);
            %             ycoords   = ones(Nchannels,1);
            %             kcoords   = ones(Nchannels,1); % grouping of channels (i.e. tetrode groups)
            %
            %             fs = 30000; % sampling frequency
            %             save('F:\TUM\SWR-Project\KiloSortConfigFiles\testMap.mat', 'chanMap','connected', 'xcoords', 'ycoords', 'kcoords', 'chanMap0ind', 'fs')
            
            %
            %             Nchannels = 16;
            %             connected = true(Nchannels, 1);
            %             chanMap   = [1:16];
            %             chanMap0ind = chanMap - 1;
            %
            %             xcoords   = ones(Nchannels,1);
            %              ycoords   = ones(Nchannels,1);
            %              kcoords   = ones(Nchannels,1); % grouping of channels (i.e. tetrode groups)
            %
            %             fs = 30000; % sampling frequency
            %             save('C:\Users\Administrator\Documents\code\GitHub\code2018\KiloSortProj\KiloSortConfigFiles\chanMap16ChanSeq.mat', 'chanMap','connected', 'xcoords', 'ycoords', 'kcoords', 'chanMap0ind', 'fs')
            %
            
            
            %%
            tic; % start timer
            %
            if ops.GPU
                gpuDevice(1); % initialize GPU (will erase any existing GPU arrays)
            end
            
            if strcmp(ops.datatype , 'openEphys')
                disp('Converting openephys file...')
                ops = convertOpenEphysToRawBInary(ops);  % convert data, only for OpenEphys
            end
            disp('Finished...')
            %
            %%
            disp('Pre-processing...')
            [rez, DATA, uproj] = preprocessData(ops); % preprocess data and extract spikes for initialization
            disp('Fitting templates...')
            rez                = fitTemplates(rez, DATA, uproj);  % fit templates iteratively
            disp('Extracting final spike times...')
            rez                = fullMPMU(rez, DATA);% extract final spike times (overlapping extraction)
            
            % AutoMerge. rez2Phy will use for clusters the new 5th column of st3 if you run this)
            %     rez = merge_posthoc2(rez);
            
            % save matlab results file
            save(fullfile(ops.root,  'rez.mat'), 'rez', '-v7.3');
            
            % save python results file for Phy
            rezToPhy(rez, ops.root);
            
            % remove temporary file
            delete(ops.fproc);
            
            disp('Finished')
            
            %%s
            
        end
        
        
        function [] = runKilosort2fromConfigFile(obj, pathToConfigFile, nameOfConfigFile)
            
            %% you need to change most of the paths in this block
            
            %addpath(genpath('D:\GitHub\KiloSort2')) % path to kilosort folder
            %addpath('D:\GitHub\npy-matlab')
            
            pathToYourConfigFile = pathToConfigFile; % take from Github folder and put it somewhere else (together with the master_file)
            run(fullfile(pathToYourConfigFile, nameOfConfigFile))
            
            
            rootH = ops.root;
            
            datFiles = dir(fullfile(rootH, '*.dat'));
            if numel(datFiles) >=2
                disp('.dat file found..')
            else
                if strcmp(ops.datatype , 'openEphys')
                    disp('Converting openephys file...')
                    ops = convertOpenEphysToRawBInary(ops);  % convert data, only for OpenEphys
                end
            end
            
            
            ops.fproc       = fullfile(rootH, 'temp_wh.dat'); % proc file on a fast SSD
            %ops.chanMap = chanMap;
            
            ops.trange = [0 Inf]; % time range to sort
            ops.NchanTOT    = 16; % total number of channels in your recording
            
            % the binary file is in this folder
            rootZ = ops.root;
            
            %% this block runs all the steps of the algorithm
            fprintf('Looking for data inside %s \n', rootZ)
            
            % is there a channel map file in this folder?
            %             fs = dir(fullfile(rootZ, 'chan*.mat'));
            %             if ~isempty(fs)
            %                 ops.chanMap = fullfile(rootZ, fs(1).name);
            %                 ops.chanMap = fullfile(rootZ, fs(1).name);
            %             end
            
            if ops.GPU
                gpuDevice(1); % initialize GPU (will erase any existing GPU arrays)
            end
            
            % find the binary file
            fs          = [dir(fullfile(rootZ, '*.bin')) dir(fullfile(rootZ, '*.dat'))];
            ops.fbinary = fullfile(rootZ, fs(1).name);
            
            % preprocess data to create temp_wh.dat
            rez = preprocessDataSub(ops);
            
            % time-reordering as a function of drift
            rez = clusterSingleBatches(rez);
            save(fullfile(rootZ, 'rez.mat'), 'rez', '-v7.3');
            
            % main tracking and template matching algorithm
            rez = learnAndSolve8b(rez);
            
            % final merges
            rez = find_merges(rez, 1);
            
            % final splits by SVD
            rez = splitAllClusters(rez, 1);
            
            % final splits by amplitudes
            rez = splitAllClusters(rez, 0);
            
            % decide on cutoff
            rez = set_cutoff(rez);
            
            fprintf('found %d good units \n', sum(rez.good>0))
            
            % write to Phy
            fprintf('Saving results to Phy  \n')
            rezToPhy(rez, rootZ);
            
            %% if you want to save the results to a Matlab file...
            
            % discard features in final rez file (too slow to save)
            rez.cProj = [];
            rez.cProjPC = [];
            
            % save final results as rez2
            fprintf('Saving final results in rez2  \n')
            fname = fullfile(rootZ, 'rez2.mat');
            save(fname, 'rez', '-v7.3');
            
        end
        
        function [obj] = importPhyClusterSpikeTimes(obj, clustType)
            
            %clustType
            % - 0 = noise
            % - 1 = mua
            % - 2 = good
            % - 3 = unsorted
            
            dataDir = obj.Session.SessionDir;
            
            %% load some spikes and compute some basic things
            
            % clu is a length nSpikes vector with the cluster identities of every spike
            clu = readNPY(fullfile(dataDir,  'spike_clusters.npy')); %cluster IDs
            
            % ss is a length nSpikes vector with the spike time of every spike (in samples)
            ss = readNPY(fullfile(dataDir,  'spike_times.npy'));
            
            % [cids, cgs] = readClusterGroupsCSV(fullfile(folderNames{f},  'cluster_groups.csv'));
            [cids, cgs] = readClusterGroupsCSV(fullfile(dataDir,  'cluster_group.tsv'));
            
            % cids is length nClusters, the cluster ID numbers
            % cgs is length nClusters, the "cluster group":
            % - 0 = noise
            % - 1 = mua
            % - 2 = good
            % - 3 = unsorted
            
            ClustersInds = find(cgs==clustType);
            ClusterIDs = cids(ClustersInds);
            
            spikeTimes_samps = [];
            for j = 1:numel(ClusterIDs)
                
                spikeTimesInds = find(clu == ClusterIDs(j));
                spikeTimes_samps{j} = double(ss(spikeTimesInds));
            end
            
            clust.clustType = clustType;
            clust.ClusterIDs = ClusterIDs;
            clust.spikeTimes_samps = spikeTimes_samps;
            clust.dataDir = dataDir;
            clust.cids = cids;
            clust.cgs = cgs;
            clust.cgs = cgs;
            clust.ss = ss;
            clust.clu = clu;
            
            %% Saving
            SWR_Python_Dir = [obj.Session.SessionDir 'SWR-Python' obj.DIR.dirD];
            obj.DIR.SWR_Python_Dir  = SWR_Python_Dir;
            
            saveName = [obj.DIR.SWR_Python_Dir 'ClustType-' num2str(clustType) '.mat'];
            
            save(saveName, 'clust', '-v7.3')
            disp(['Saved: ' saveName])
            
            
        end
        
        function [obj]  = loadClustTypesAndMakeSpikePlots(obj, clustType)
            dbstop if error
            
            SWR_Python_Dir = [obj.Session.SessionDir 'SWR-Python' obj.DIR.dirD];
            PlotDir = [obj.DIR.birdDir 'Plots' obj.DIR.dirD obj.DIR.dirName '_plots' obj.DIR.dirD];
            obj.Plotting.titleTxt = [obj.INFO.Name ' | ' obj.Session.time];
            obj.Plotting.saveTxt = [obj.INFO.Name '_' obj.Session.time];
            
            if clustType == 2
                clustChanPairing = obj.REC.GoodClust_2;
                clustFile = 'ClustType-2.mat';
                saveTag = 'GoodChan';
                Yss = [-300 200];
            elseif clustType == 1
                clustChanPairing = obj.REC.MUAClust_1;
                clustFile = 'ClustType-1.mat';
                saveTag = 'muaChan';
                Yss = [-300 200];
            end
            
            ChansToLoad = clustChanPairing(:,2);
            Clusts = clustChanPairing(:,1);
            
            cl = load([SWR_Python_Dir clustFile]);
            
            ClusterIDs = cl.clust.ClusterIDs;
            nClusterIDs = numel(ClusterIDs);
            spikeTimes_samps = cl.clust.spikeTimes_samps;
            
            % Make sure the clusters match
            if sum(ismember(Clusts, ClusterIDs)) ~= nClusterIDs
                disp('Cluster mismatch')
                keyboard
            end
            
            %% Load ephys file and make some plots
            
            for j = 1:nClusterIDs
                
                thisChan = ChansToLoad(j);
                thisClustSpikeTimes = spikeTimes_samps{j};
                
                eval(['fileAppend = ''100_CH' num2str(thisChan) '.continuous'';'])
                fileName = [obj.Session.SessionDir fileAppend];
                
                [data, timestamps, info] = load_open_ephys_data(fileName);
                
                Fs = info.header.sampleRate;
                win_samp = 0.010*Fs;
                timepoints_ms = (-win_samp:1:win_samp)/Fs*1000;
                
                allSpks = [];
                for sp = 1:numel(thisClustSpikeTimes)
                    
                    if thisClustSpikeTimes(sp) - win_samp > 0 && thisClustSpikeTimes(sp) + win_samp < obj.Session.samples
                        roi = thisClustSpikeTimes(sp) - win_samp : thisClustSpikeTimes(sp) + win_samp;
                        
                        %figure(100); clf;
                        %hold on
                        allSpks(:,sp) = data(roi);
                        %plot(timpoints, data(roi));
                        %ylim([-300 300])
                        %pause
                    end
                end
                
                %% Plotting
                
                figH = figure(100+j); clf
                
                meanSpk = nanmean(allSpks, 2);
                medianSpk = nanmedian(allSpks, 2);
                semSpk = (std(allSpks'))/(sqrt(size(allSpks, 2)));
                jbfill(timepoints_ms,[meanSpk'+semSpk],[meanSpk'-semSpk],[.5,0.5,.5],[.5,0.5,.5],[],.3);
                hold on
                %jbfill(timepoints_ms,[medianSpk'+semSpk],[medianSpk'-semSpk],[.5,0.5,.5],[.5,0.5,.5],[],.3);
                plot(timepoints_ms, meanSpk, 'k')
                %plot(timepoints_ms, medianSpk, 'b')
                axis tight
                ylim(Yss)
                title([obj.Plotting.titleTxt ': Channel ' num2str(thisChan) ', n = ' num2str(numel(thisClustSpikeTimes)) ' spks' ])
                xlabel('Time [ms]')
                ylabel('uV')
                
                saveName = [PlotDir obj.Plotting.saveTxt '_Spikes_Chan-' num2str(thisChan) '-' saveTag];
                
                plotpos = [0 0 15 10];
                print_in_A4(0, saveName, '-djpeg', 0, plotpos);
                disp('')
                
            end
            
        end
        
        function [obj]  = loadClustTypesAndAlignToSWR_Raster_ClustType(obj, clustType)
            %if nargin < 2
            %    chansToUse = obj.REC.GoodClust_2(:, 2);
            %end
            
            SWR_Python_Dir = [obj.Session.SessionDir 'SWR-Python' obj.DIR.dirD];
            PlotDir = [obj.DIR.birdDir 'Plots' obj.DIR.dirD obj.DIR.dirName '_plots' obj.DIR.dirD];
            obj.Plotting.titleTxt = [obj.INFO.Name ' | ' obj.Session.time];
            obj.Plotting.saveTxt = [obj.INFO.Name '_' obj.Session.time];
            
            if clustType == 2
                clustChanPairing = obj.REC.GoodClust_2;
                clustFile = 'ClustType-2.mat';
                saveTag = 'GoodChan';
                Yss = [-300 200];
            elseif clustType == 1
                clustChanPairing = obj.REC.MUAClust_1;
                clustFile = 'ClustType-1.mat';
                saveTag = 'muaChan';
                Yss = [-300 200];
            end
            
            ChansToLoad = clustChanPairing(:,2);
            
            cl= load([SWR_Python_Dir clustFile]);
            
            ClusterIDs = cl.clust.ClusterIDs;
            nClusterIDs = numel(ClusterIDs);
            spikeTimes_samps = cl.clust.spikeTimes_samps;
            
            
            depthOrder = obj.REC.allChs; % first is deepest
            
            for o = 1:numel(spikeTimes_samps)
                thisOrderInd(o) = find(depthOrder == ChansToLoad(o)); % this is the order of the available chans from lowest to highest
            end
            
            [B, sortInds] = sort(thisOrderInd, 'ascend');
            
            %% Load SWR detection File
            textSearch = '*export_ripples.mat*'; % text search for ripple detection file
            shWDetectionsFile = dir(fullfile(SWR_Python_Dir,textSearch));
            
            rD = load([SWR_Python_Dir shWDetectionsFile.name]);
            rippleDetections = double(rD.data); % ins samples of the original data file
            rippleDetectionsx50 = rippleDetections*50; % we do this cuz the resolution of the python code is 50
            nRippleDetections = numel(rippleDetectionsx50);
            
            %% Now align the spikes to these events;
            
            Fs = obj.Session.sampleRate;
            spikeWin_s = 0.05; % 50 ms
            %spikeWin_s = 0.1; % 50 ms
            spikeWin_samp = spikeWin_s* Fs;
            thisMaxLength = -spikeWin_samp:spikeWin_samp;
            thisMaxLength_ms = thisMaxLength/Fs*1000;
            
            FROverChans = [];
            spikesOverChans = [];
            for q = 1:numel(spikeTimes_samps)
                
                intFR  = zeros(1,numel(thisMaxLength)); % we define a vector for integrated FR
                thisInd = sortInds(q);
                
                theseSpikeTimes = spikeTimes_samps{thisInd};
                
                allSpikes = [];
                
                for o = 1: nRippleDetections
                    thisRipple = rippleDetectionsx50(o);
                    
                    spikeWinOn = thisRipple - spikeWin_samp;
                    spikeWinOff = thisRipple + spikeWin_samp;
                    
                    these_spks_on_chan = theseSpikeTimes(theseSpikeTimes >= spikeWinOn & theseSpikeTimes <= spikeWinOff)-spikeWinOn; % Need it to be relative here
                    allSpikes{o} = these_spks_on_chan;
                    
                    nSpks = numel(these_spks_on_chan);
                    
                    % add a 1 to the FR vector for every spike
                    for ind = 1 : nSpks
                        if these_spks_on_chan(ind) ~= 0
                            intFR(these_spks_on_chan(ind)) = intFR(these_spks_on_chan(ind)) +1;
                        end
                    end
                    
                end
                
                spikesOverChans{q} = allSpikes;
                FROverChans{q} = intFR;
                
            end
            %%
            cols = {[0.2 0.3 0.6],  [0.2 0.3 0.3],  [0.2 0.3 0.01], [0.1 0.1 0.3], [0.5 0.5 0.6], [0.2 0.8 0.8]...
                [0.3 0.3 0.6],  [0.8 0.2 0.3],  [0.2 0.4 0.9], [0.5 0.8 0.6], [0.2 0.3 0.2], [0.1 0.3 0.2]...
                [0.5 0.3 0.6],  [0.3 0.5 0.3],  [0.8 0.5 0.6], [0.8 0.4 0.2], [0.2 0.8 0.2], [0.8 0.8 0.2]...
                [0.8 0.3 0.6],    [0.1 0.3 0.4], [0.5 0.5 0.8], [0.8 0.3 0.8], [0.2 0.8 0.2], [0.8 0.3 0.2]};
            
            %    cols = {[0.2 0.3 0.0], [0.2 0.3 0.6],  [0.2 0.3 0.3],  [0.1 0.1 0.3], [0.5 0.5 0.6], [0.7 0.2 0.2]};
            
            %cols = {'k', 'b', 'r', 'm', 'g'
            
            
            %%
            figH = figure(104);  clf
            subplot(5, 1, [2 3 4]); cla
            cnt = 1;
            for q = 1:numel(spikeTimes_samps)
                
                thisInd = sortInds(q);
                thisChanLabel = ChansToLoad(thisInd);
                
                allSpikes = spikesOverChans{thisInd};
                
                for o = 1: nRippleDetections
                    theseSpikes = allSpikes{o};
                    xpoints = ones(numel(theseSpikes))*cnt;
                    
                    if o ==1
                        text(0, cnt+300, ['Chan- ' num2str(thisChanLabel)])
                    end
                    
                    hold on
                    plot(theseSpikes, xpoints, '.', 'color', cols{q}, 'linestyle', 'none', 'MarkerFaceColor',cols{q},'MarkerEdgeColor',cols{q})
                    
                    cnt = cnt +1;
                    
                end
            end
            
            set(gca,'xtick',[]);
            set(gca,'ytick',[]);
            %%
            axis tight
            xlim([0 numel(thisMaxLength)])
            
            subplot(5, 1, 5); cla
            hold on
            for q = 1:numel(spikeTimes_samps)
                
                plot(thisMaxLength_ms, smooth(FROverChans{q}, 0.01*Fs), 'color', cols{q}, 'linewidth', 2)
                %plot(thisMaxLength_ms, FROverChans{q}, 'color', cols{q}, 'linewidth', 2)
                
            end
            axis tight
            xlim([-spikeWin_s*1000 +spikeWin_s*1000])
            xlabel('Time [ms]')
            %%
            textSearch = '*_data.mat*'; % text search for ripple detection file
            shWDataFile = dir(fullfile(SWR_Python_Dir,textSearch));
            disp('Loading data...')
            sD = load([SWR_Python_Dir shWDataFile(1).name]);
            
            swrData =  sD.dataSegs_V_raw;
            Fs =  sD.INFO.fs;
            
            %%
            RipplePlot = [];
            thisRipple = rippleDetectionsx50(obj.REC.waveletInd);
            roi = thisRipple - spikeWin_samp: thisRipple + spikeWin_samp;
            RipplePlot(:,1) = swrData(roi);
            
            subplot(5, 1, 1); cla
            plot(thisMaxLength_ms, RipplePlot, 'color', 'k')
            title([obj.Plotting.titleTxt ': SWR-Aligned spikes - ' clustFile(1:end-4)])
            
            %%
            
            
            saveName = [PlotDir obj.Plotting.saveTxt '_SWR-AlignedSpikes-' saveTag];
            
            plotpos = [0 0 10 20];
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
            
            
            
        end
        
        
        
        function [] = calcCSD(obj, dataRecordingObj)
            
            Fs = obj.Session.sampleRate;
            recordingDuration_s = obj.Session.recordingDur_s;
            
            %SessionDir = obj.Session.SessionDir;
            %obj.Session.SessionDir;
            obj.Plotting.titleTxt = [obj.INFO.Name ' | ' obj.Session.time];
            obj.Plotting.saveTxt = [obj.INFO.Name '_' obj.Session.time];
            PlotDir = [obj.DIR.birdDir 'Plots' obj.DIR.dirD obj.DIR.dirName '_plots' obj.DIR.dirD];
            
            
            fObj = filterData(Fs);
            
            fobj.filt.DS4Hz=filterData(Fs);
            fobj.filt.DS4Hz.downSamplingFactor=240; % 125 samples
            %fobj.filt.DS4Hz.lowPassCutoff=4;
            fobj.filt.DS4Hz.lowPassCutoff=35;
            fobj.filt.DS4Hz.padding=true;
            fobj.filt.DS4Hz=fobj.filt.DS4Hz.designDownSample;
            tmpFs=fobj.filt.DS4Hz.filteredSamplingFrequency;
            
            fobj.filt.FN =filterData(Fs);
            fobj.filt.FN.filterDesign='cheby1';
            fobj.filt.FN.padding=true;
            fobj.filt.FN=fobj.filt.FN.designNotch;
            
            %             fobj.filt.FL=filterData(Fs);
            %             fobj.filt.FL.lowPassPassCutoff=4.5;
            %             fobj.filt.FL.lowPassStopCutoff=6;
            %             fobj.filt.FL.attenuationInLowpass=20;
            %             fobj.filt.FL=fobj.filt.FL.designLowPass;
            %             fobj.filt.FL.padding=true;
            %             tmpFs=fobj.filt.FL.filteredSamplingFrequency;
            
            %seg_ms = 10000;
            seg_ms = 10000;
            
            TOn=1:seg_ms:recordingDuration_s*1000-seg_ms;
            nCycles = numel(TOn);
            
            %chanSelection = [2 7 15 10 13 12 14 11 1 8 16 9 3 6 4 5];
            chanSelection = [5 4 6 3 9 16 8 1 11 14 12 13 10 15 7 2]; %lowest
            
            nChans = numel(chanSelection);
            
            xticks = 0:tmpFs:seg_ms/1000*tmpFs;
            xlabs = [];
            for o = 1:numel(xticks)
                xlabs{o} = num2str(xticks(o)/tmpFs*1000);
            end
            
            for i = 1:nCycles
                allCDS = [];
                disp([num2str(i) '/' num2str(nCycles)])
                
                for j = 1:nChans
                    thisChan = chanSelection(j);
                    [MTmp, traw ] =dataRecordingObj.getData(thisChan,TOn(i),seg_ms);
                    [M_notch,t_notch]=fobj.filt.FN.getFilteredData(MTmp);
                    [Mtest,tTest]=fobj.filt.DS4Hz.getFilteredData(MTmp);
                    %[Mtest,tTest]=fobj.filt.FL.getFilteredData(MTmp);
                    
                    allCDS(:,j) = squeeze(Mtest);
                    allCDS_raw(:,j) = squeeze(M_notch);
                    
                end
                
                [CSDoutput, unitsCurrent, unitsLength]  = CSD(allCDS./1000,tmpFs,1E-4,'inverse',4E-4);
                %[CSDoutput]  = CSD(allCDS,tmpFs,1E-4);
                
                allCSDOutput{i} = CSDoutput;
                %%
                figure(100); clf
                
                pos = [0.05 0.70 0.9 0.25];
                axes('position',pos );cla
                invertChanSelection = 16:-1:1;
                chanSelectionInvert = fliplr(chanSelection);
                
                %subplot(3, 1, 1)
                offset = 0;
                for s = 1:nChans
                    thisChan = invertChanSelection(s);
                    hold on
                    plot((traw +TOn(i))/1000, allCDS_raw(:,thisChan)+offset, 'k')
                    offset = offset+150;
                end
                axis tight
                ylim([-400 2700]);
                
                %subplot(3, 1, 2)
                pos = [0.05 0.43 0.9 0.25];
                axes('position',pos );cla
                offset = 0;
                for s = 1:nChans
                    thisChan = invertChanSelection(s);
                    hold on
                    plot((tTest +TOn(i))/1000, allCDS(:,thisChan)+offset, 'k')
                    text((tTest(1) +TOn(i))/1000, allCDS(1,thisChan)+offset(1), [num2str(chanSelectionInvert(s))])
                    offset = offset+150;
                end
                axis tight
                %yss = ylim;
                ylim([-400 2700]);
                
                %subplot(3, 1, 3)
                pos = [0.05 0.05 0.9 0.35];
                axes('position',pos );cla
                
                imagesc(CSDoutput', [-5000 5000])
                colormap(flipud(jet)); % blue = source; red = sink
                cb = colorbar('SouthOutside');
                cb.Label.String = [unitsCurrent '/' unitsLength '^{3}'];
                set(gca,'Ytick',[1:1:size(allCDS,2)]);
                %set(gca, 'YTickLabel',[1:1:size(allCDS,2)]); % electrode number
                set(gca, 'YTickLabel',[chanSelection]); % electrode number
                
                set(gca, 'xtick', xticks)
                set(gca, 'xticklabel', xlabs)
                ylabel('Electrode');
                xlabel('Time [s]');
                %%
                saveName = [PlotDir obj.Plotting.saveTxt '_CSD_' sprintf('%03d', i)];
                plotpos = [0 0 20 30];
                print_in_A4(0, saveName, '-djpeg', 0, plotpos);
                
            end
            saveName = [PlotDir obj.Plotting.saveTxt '_AllCSD.mat'];
            save(saveName, 'allCSDOutput', 'chanSelection', 'tmpFs')
            
            
        end
        
        function [obj] = detectSWRs_SleepAnalysisObj(chan , obj, dataRecordingObj)
            
            %             addParameter(parseObj,'ch',obj.par.DVRLFPCh{obj.currentPRec},@isnumeric);
            %             addParameter(parseObj,'nTestSegments',20,@isnumeric);
            %             addParameter(parseObj,'minPeakWidth',200,@isnumeric);
            %             addParameter(parseObj,'minPeakInterval',1000,@isnumeric);
            %             addParameter(parseObj,'detectOnlyDuringSWS',true);
            %             addParameter(parseObj,'preTemplate',400,@isnumeric);
            %             addParameter(parseObj,'winTemplate',1500,@isnumeric);
            %             addParameter(parseObj,'resultsFileName',[],@isstr);
            %             addParameter(parseObj,'percentile4ScaleEstimation',5,@isnumeric);
            %             addParameter(parseObj,'overwrite',0,@isnumeric);
            %             addParameter(parseObj,'inputParams',false,@isnumeric);
            
            
            %% chekc if detected files exist
            obj.Plotting.titleTxt = [obj.INFO.Name ' | ' obj.Session.time];
            obj.Plotting.saveTxt = [obj.INFO.Name '_' obj.Session.time];
            SWRDir = [obj.DIR.birdDir 'SWR' obj.DIR.dirD obj.DIR.dirName '_swrs' obj.DIR.dirD];
            savePath = [SWRDir  obj.Plotting.saveTxt '_SWR.mat'];
            %
            %             if   exist(savePath, 'file') ~= 0
            %
            %                 disp('SWR file already exists...')
            %
            %                 load(savePath)
            %
            %                 obj.SWR = SWR;
            %                 obj.SWR.parSharpWaves = parSharpWaves;
            %
            %             else
            
            
            %%
            
            
            Fs = obj.Session.sampleRate;
            recordingDuration_s = obj.Session.recordingDur_s;
            
            fObj = filterData(Fs);
            
            %% Filters
            %
            %             fobj.filt.FL=filterData(Fs);
            %             %fobj.filt.FL.lowPassPassCutoff=4.5;
            %             %fobj.filt.FL.lowPassPassCutoff=20;
            %             %fobj.filt.FL.lowPassStopCutoff=30;
            %             fobj.filt.FL.lowPassPassCutoff=30;% this captures the LF pretty well for detection
            %             fobj.filt.FL.lowPassStopCutoff=40;
            %             fobj.filt.FL.attenuationInLowpass=20;
            %             fobj.filt.FL=fobj.filt.FL.designLowPass;
            %             fobj.filt.FL.padding=true;
            %
            %             fobj.filt.FH2=filterData(Fs);
            %             fobj.filt.FH2.highPassCutoff=80;
            %             fobj.filt.FH2.lowPassCutoff=400;
            %             fobj.filt.FH2.filterDesign='butter';
            %             fobj.filt.FH2=fobj.filt.FH2.designBandPass;
            %             fobj.filt.FH2.padding=true;
            %
            %             fobj.filt.FN =filterData(Fs);
            %             fobj.filt.FN.filterDesign='cheby1';
            %             fobj.filt.FN.padding=true;
            %             fobj.filt.FN=fobj.filt.FN.designNotch;
            
            fobj.filt.BP=filterData(Fs);
            fobj.filt.BP.highPassCutoff=1;
            fobj.filt.BP.lowPassCutoff=2000;
            fobj.filt.BP.filterDesign='butter';
            fobj.filt.BP=fobj.filt.BP.designBandPass;
            fobj.filt.BP.padding=true;
            
            fobj.filt.DS4Hz=filterData(Fs);
            fobj.filt.DS4Hz.downSamplingFactor=240; % 125 samples
            %fobj.filt.DS4Hz.lowPassCutoff=4;
            fobj.filt.DS4Hz.lowPassCutoff=55;
            fobj.filt.DS4Hz.padding=true;
            fobj.filt.DS4Hz=fobj.filt.DS4Hz.designDownSample;
            
            %% Define template
            nTestSegments = 15;
            percentile4ScaleEstimation = 5;
            
            rng(1);
            
            seg_ms=20000;
            TOn=1:seg_ms:recordingDuration_s*1000-seg_ms;
            nCycles = numel(TOn);
            
            [tmpV, t_ms] =dataRecordingObj.getData(2,TOn(1),seg_ms);
            
            %pCycle=sort(randperm(nCycles,nTestSegments));
            pCycle=[4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 267, 274, 281];
            %pCycle=sort(nCycles,nTestSegments);
            ch = chan;
            Mtest=cell(nTestSegments,1);
            tTest=cell(nTestSegments,1);
            for i=1:numel(pCycle)
                %    for i=13:nCycles
                MTmp=dataRecordingObj.getData(ch,TOn(pCycle(i)),seg_ms);
                MTmpBP=fobj.filt.BP.getFilteredData(MTmp);
                %MTmp=dataRecordingObj.getData(ch,TOn(i),seg_ms);
                %plot(squeeze(MTmp))
                %i
                %pause
                [Mtest{i},tTest{i}]=fobj.filt.DS4Hz.getFilteredData(MTmpBP);
                tTest{i}=tTest{i}'+TOn(pCycle(i));
                Mtest{i}=squeeze(Mtest{i});
            end
            Mtest=cell2mat(Mtest);
            tTest=cell2mat(tTest);
            sortedMtest=sort(Mtest);
            scaleEstimator=sortedMtest(round(percentile4ScaleEstimation/100*numel(sortedMtest)));
            
            tmpFs=fobj.filt.DS4Hz.filteredSamplingFrequency;
            
            %%
            
            % addParameter(parseObj,'minPeakWidth',200,@isnumeric);
            % addParameter(parseObj,'minPeakInterval',1000,@isnumeric);
            % addParameter(parseObj,'detectOnlyDuringSWS',true);
            % addParameter(parseObj,'preTemplate',400,@isnumeric);
            % addParameter(parseObj,'winTemplate',1500,@isnumeric);
            
            % minPeakWidth = 200;
            % minPeakInterval = 1000;
            % preTemplate = 400;
            % winTemplate = 1500;
            
            %in ms ZF
            %minPeakWidth = 20;
            %maxPeakWidth = 130;
            %minPeakInterval = 200;
            %preTemplate = 200;
            %winTemplate = 600;
            
            minPeakWidth = 20;
            maxPeakWidth = 300;
            minPeakInterval = 50;
            
            preTemplate = 200;
            winTemplate = 200;
            
            [peakVal,peakTime,peakWidth,peakProminance]=findpeaks(-Mtest,'MinPeakHeight',-scaleEstimator,'MinPeakDistance',minPeakInterval/1000*tmpFs,'MinPeakProminence',-scaleEstimator/2,'MinPeakWidth',minPeakWidth/1000*tmpFs, 'MaxPeakWidth', maxPeakWidth/1000*tmpFs,'WidthReference','halfprom');
            
            %{
            widthTimes = peakWidth/tmpFs*1000;
            figure
            hist(widthTimes, 0:1:maxPeakWidth)
            
            figure(100);clf
            plot(Mtest)
            hold on
            plot(peakTime, 50, 'rv')
            %}
            %%
            [allSW,tSW]=dataRecordingObj.getData(ch,tTest(peakTime)-preTemplate,winTemplate*2);
            [FLallSW,tFLallSW]=fobj.filt.DS4Hz.getFilteredData(allSW);
            
            template=squeeze(median(FLallSW,2));
            nTemplate=numel(template);
            ccEdge=floor(nTemplate/2);
            [~,pTemplatePeak]=min(template);
            %{
                allSWRs = squeeze(allSW);
                for j = 1:numel(peakTime)
                    
                    figure(302);clf
                    plot(tSW, allSWRs(j,:))
                    pause
                end
            %}
            
            
            %{
            figure(100); clf
            plot(tFLallSW, template)
            %}
            
            %%
            seg=20000;
            TOn=0:seg:recordingDuration_s*1000-seg;
            TWin=seg*ones(1,numel(TOn));
            nCycles=numel(TOn);
            
            
            
            C_Height = 0.1;
            C_Prom = 0.05;
            
            
            absolutePeakTimes=cell(nCycles,1);
            for i=1:nCycles
                [tmpM,tmpT]=dataRecordingObj.getData(ch,TOn(i),TWin(i));
                [tmpBP,~]=fobj.filt.BP.getFilteredData(tmpM);
                
                [tmpFM,tmpFT]=fobj.filt.DS4Hz.getFilteredData(tmpBP);
                
                [C]=xcorrmat(squeeze(tmpFM),template);
                C=C(numel(tmpFM)-ccEdge:end-ccEdge);
                
                %{
                                figure(103); clf
                               subplot(2, 1, 1 )
                                plot(C); axis tight
                %}
                %C=xcorr(squeeze(tmpFM),template,'coeff');
                
                %[~,peakTime]=findpeaks(C,'MinPeakHeight',0.1,'MinPeakProminence',0.2,'WidthReference','halfprom');
                [~,peakTime]=findpeaks(C,'MinPeakHeight',C_Height ,'MinPeakProminence',C_Prom,'WidthReference','halfprom');
                
                %{
                                hold on
                                plot(peakTime, 0.1, 'rv')
                
                                subplot(2, 1, 2)
                                hold on;
                                %plot(tmpT, squeeze(tmpBP))
                                plot(tmpFT, squeeze(tmpFM))
                                %plot(relPeakTime, 100, 'rv')
                   
                                %linkaxes(h,'x');
                    
                %}
                
                peakTime(peakTime<=pTemplatePeak)=[]; %remove peaks at the edges where templates is not complete
                %relPeakTime = tmpFT(peakTime-round(pTemplatePeak/2))';
                relPeakTime = tmpFT(peakTime+pTemplatePeak)';
                %relPeakTime = tmpFT(peakTime-pTemplatePeak)';
                absolutePeakTimes{i}=tmpFT(peakTime-round(pTemplatePeak/2))'+TOn(i);
                %absolutePeakTimes{i}=tmpFT(peakTime)'+TOn(i);
                
                
                %h(1)=subplot(2,1,1);plot(squeeze(tmpFM));h(2)=subplot(2,1,2);plot((1:numel(C))-pTemplatePeak,C);linkaxes(h,'x');
            end
            
            
            
            
            %                 [allSW,tSW]=dataRecordingObj.getData(ch,(tSW),winTemplate);
            %
            %                 allSWRs = squeeze(allSW);
            
            %{
            figure (105); clf
            for j =1:100
                plot(tSW, allSWRs(j,:))
                %ylim([-600 200])
                j
                pause
            end
            %}
            
            tSW=cell2mat(absolutePeakTimes);
            
            
            SWR.tSWR_samps = tSW;
            SWR.template_V = FLallSW;
            SWR.template_T = tFLallSW;
            SWR.mediantemplate = template;
            SWR.pTemplatePeak = pTemplatePeak;
            SWR.ch= ch;
            
            parSharpWaves.minPeakWidth = minPeakWidth;
            parSharpWaves.minPeakInterval = minPeakInterval;
            parSharpWaves.preTemplate = preTemplate;
            parSharpWaves.winTemplate = winTemplate;
            parSharpWaves.C_MinPeakHeight = C_Height;
            parSharpWaves.C_MinPeakProminence = C_Prom;
            parSharpWaves.tmpFs = tmpFs;
            
            SessionDir = obj.Session.SessionDir;
            
            obj.Plotting.titleTxt = [obj.INFO.Name ' | ' obj.Session.time];
            obj.Plotting.saveTxt = [obj.INFO.Name '_' obj.Session.time];
            SWRDir = [obj.DIR.birdDir 'SWR' obj.DIR.dirD obj.DIR.dirName '_swrs' obj.DIR.dirD];
            
            if exist(SWRDir, 'dir') == 0
                mkdir(SWRDir);
                disp(['Created: '  SWRDir])
            end
            savePath = [SWRDir  obj.Plotting.saveTxt '_SWR.mat'];
            
            save(savePath,'SWR','parSharpWaves');
            disp(['Saved:' savePath])
            obj.SWR = SWR;
            obj.SWR.parSharpWaves = parSharpWaves;
            
            
        end
        %         end
        
        
        
        function [] = plotConsecutiveSWRs(obj, dataRecordingObj)
            
            SWRs_ms = obj.SWR.tSWR_samps;
            nSWRs = numel(SWRs_ms);
            
            template_v = obj.SWR.mediantemplate;
            template_T = obj.SWR.template_T;
            template_peak = obj.SWR.pTemplatePeak;
            
            
            ch = obj.SWR.ch;
            Fs = obj.Session.sampleRate;
            
            preTemplate = obj.SWR.parSharpWaves.preTemplate;
            winTemplate = obj.SWR.parSharpWaves.winTemplate;
            %figure;
            %plot(template_T, template_v)
            %obj.Session.recordingDur_s
            
            %% Get SWRs in ms,
            %allSW = [];
            
            %[allSW,tSW]=dataRecordingObj.getData(ch,(SWRs_ms),winTemplate);
            %[allSW,tSW]=dataRecordingObj.getData(ch,(SWRs_ms),winTemplate+preTemplate);
            [allSW,tSW]=dataRecordingObj.getData(ch,(SWRs_ms-preTemplate),winTemplate);
            
            allSWRs = squeeze(allSW);
            
            %{
            figure (105); clf
            for j =1:nSWRs
                plot(tSW, allSWRs(j,:))
                %ylim([-600 200])
                j
                pause
            end
            %}
            
            %% Filters
            fObj = filterData(Fs);
            
            fobj.filt.FH2=filterData(Fs);
            fobj.filt.FH2.highPassCutoff=100;
            fobj.filt.FH2.lowPassCutoff=2000;
            fobj.filt.FH2.filterDesign='butter';
            fobj.filt.FH2=fobj.filt.FH2.designBandPass;
            fobj.filt.FH2.padding=true;
            
            fobj.filt.FJLB=filterData(Fs);
            fobj.filt.FJLB.highPassCutoff=.1;
            fobj.filt.FJLB.lowPassCutoff=4;
            fobj.filt.FJLB.filterDesign='butter';
            fobj.filt.FJLB=fobj.filt.FJLB.designBandPass;
            fobj.filt.FJLB.padding=true;
            
            fobj.filt.FL=filterData(Fs);
            %fobj.filt.FL.lowPassPassCutoff=4.5;
            %fobj.filt.FL.lowPassStopCutoff=6;
            %fobj.filt.FL.lowPassPassCutoff=15;
            %fobj.filt.FL.lowPassStopCutoff=40;
            fobj.filt.FL.lowPassPassCutoff=35;
            fobj.filt.FL.lowPassStopCutoff=40;
            fobj.filt.FL.attenuationInLowpass=20;
            fobj.filt.FL=fobj.filt.FL.designLowPass;
            fobj.filt.FL.padding=true;
            
            fobj.filt.FLL=filterData(Fs);
            %fobj.filt.FL.lowPassPassCutoff=4.5;
            %fobj.filt.FL.lowPassStopCutoff=6;
            %fobj.filt.FL.lowPassPassCutoff=15;
            %fobj.filt.FL.lowPassStopCutoff=40;
            fobj.filt.FLL.lowPassPassCutoff=1;
            fobj.filt.FLL.lowPassStopCutoff=4;
            fobj.filt.FLL.attenuationInLowpass=10;
            fobj.filt.FLL=fobj.filt.FLL.designLowPass;
            fobj.filt.FLL.padding=true;
            
            
            %%
            %For recsession 67
            %exSWR_ind =  15;
            
            % For recsession 58
            exSWR_ind =  84;
            %exSWR_ind =  15;
            
            exSWR = allSW(:,exSWR_ind ,:);
            exSWRs_ms = SWRs_ms(exSWR_ind);
            %%
            figH = figure(200); clf
            
            % raw SWR example
            subplot(8, 1, [2])
            plot(tSW, squeeze(exSWR), 'k')
            hold on
            plot(template_T, template_v, 'r', 'linewidth', 1)
            axis tight
            %subplot(9, 1, [3])
            %plot(template_T, template_v, 'r', 'linewidth', 1)
            
            % LF SWR example
            %[exLF,t_ms] =  fobj.filt.FL.getFilteredData(exSWR);
            %hold on
            %plot(t_ms, squeeze(exLF), 'r', 'linewidth', 1)
            
            %ylim([-700 150]) % ZF
            %ylim([-1200 300])
            set(gca,'XMinorTick','on','YMinorTick','on')
            % HF SWR example
            [exHF,tmpHFT] =  fobj.filt.FH2.getFilteredData(exSWR);
            
            subplot(8, 1, [3])
            plot(tmpHFT, squeeze(exHF), 'k')
            axis tight
            %ylim([-70 70]) % ZF
            %ylim([-150 150])
            set(gca,'XMinorTick','on','YMinorTick','on')
            % larger raw data centered on example SWR
            %
            TimeWinB_ms = 60*1000;
            WinBStart_ms  = exSWRs_ms-15*1000; %ZF
            %WinBStart_ms  = exSWRs_ms-25*1000;
            
            [rawLongEx,longTms]=dataRecordingObj.getData(ch,(WinBStart_ms),TimeWinB_ms);
            %[longLF,LongLFtms] =  fobj.filt.FLL.getFilteredData(rawLongEx);
            [longLF,LongLFtms] =  fobj.filt.FL.getFilteredData(rawLongEx);
            
            
            % Fourier transfom
            %{
            %Fs = Fs;                    % Sampling frequency
            T = 1/Fs;                     % Sample time
            L = numel(LongLFtms);
            %Y = fft(squeeze(longLF));
            NFFT = 2^nextpow2(L); % Next power of 2 from length of y
            Y = fft(squeeze(longLF),NFFT)/L;
            f = Fs/2*linspace(0,1,NFFT/2+1);
            
            % Plot single-sided amplitude spectrum.
            figure
            plot(f,2*abs(Y(1:NFFT/2+1)))
            xlim([0 10])
            %}
            %%
            
            subplot(8, 1, [1])
            plot(longTms+WinBStart_ms, squeeze(rawLongEx), 'k');
            hold on
            %plot(longTms+WinBStart_ms, squeeze(longLF), 'r');
            axis tight
            %ylim([-800 200]) % ZF
            %ylim([-1500 500]) % chikc
            
            starttime = longTms(1)+WinBStart_ms;
            endtime = longTms(end)+WinBStart_ms;
            
            SWRTimes = SWRs_ms(SWRs_ms >starttime & SWRs_ms < endtime);
            
            hold on
            %plot(SWRTimes+180, 50, 'rv')
            plot(exSWRs_ms+150, -800, 'r*')
            xtics = get(gca, 'xtick');
            xticks_s = xtics/1000;
            set(gca, 'xticklabel', xticks_s)
            set(gca,'XMinorTick','on','YMinorTick','on')
            
            title([obj.INFO.Name ' | ' obj.DIR.dirName])
            
            %numel(spks_ms(spks_ms >= (tOn(o)-1) & spks_ms < (tOn(o)+spkWin_ms-1)));
            
            %             TimeWinB_ms = 1*60*1000; % 1 min
            %             WinBStart_ms =  250000+WinAStart_ms; % make sure to add the ref point
            %
            %              WinAStart_ms = 100;
            %             [rawLFP_A,LFPtime_A]=dataRecordingObj.getData(ch,WinAStart_ms,TimeWinA_ms);
            %             [rawLFP_A_fn,LFPtime_A_fn]=fobj.filt.FN.getFilteredData(rawLFP_A);
            %             WinBStop_ms =  WinBStart_ms+TimeWinB_ms;
            %             hold on
            %             line([WinBStart_ms WinBStop_ms], [0 0], 'color', 'r')
            %             axis tight
            %             ylim([-400 200])
            %
            
            nSWRsToPlot = 850;
            
            %% Collect SWR HFI
            
            [tmpHFV,tmpHFT] =  fobj.filt.FH2.getFilteredData(allSW);
            allSWs = squeeze(allSW);
            meanLFP = mean(allSWs(1:nSWRsToPlot,:), 1);
            
            tmpHFV_V = squeeze(tmpHFV);
            
            %figure; plot(tmpHFT, tmpHFV_V)
            
            binsSize_ms = 2;
            binsSize_samps = binsSize_ms/1000*Fs;
            HFI = [];
            for j = 1:nSWRsToPlot
                bla = buffer(tmpHFV_V(j,:), binsSize_samps);
                absBla = abs(bla);
                HFI(:,j) = sum(absBla, 1)/binsSize_samps;
            end
            
            %% Plot
            subplot(8, 1, [4 5 6])
            %imagesc(HFI', [0 2500]) %chick
            %imagesc(HFI', [0 40])
            imagesc(HFI', [0 80])
            %imagesc(HFI')
            cb = colorbar('NorthOutside');
            
            subplot(8, 1, 7)
            plot(tmpHFT, meanLFP, 'r', 'linewidth', 1.5)
            legend('mean LFP', 'Location', 'southeast')
            legend('boxoff')
            
            %ylim([-1000 200])
            %ylim([-600 50])
            axis tight
            set(gca,'XMinorTick','on','YMinorTick','on')
            
            meanHPI = mean(HFI, 2);
            
            subplot(8, 1, 8)
            plot(meanHPI, 'k', 'linewidth', 1.5)
            %ylim([200 1200]) % ZF
            %ylim([0 50]) % chick
            axis tight
            legend('mean HPI', 'Location', 'southeast')
            legend('boxoff')
            
            
            xlabel('Time (ms)')
            set(gca,'XMinorTick','on','YMinorTick','on')
            %%
            %             xtics = get(gca, 'xtick');
            %             xlabs = [];
            %             for j = 1:numel(xtics)
            %                 xlabs{j} = num2str(xtics(j)*60/Fs*1000);
            %             end
            
            %set(gca, 'xtick', xticks_s)
            %set(gca, 'xticklabel', xlabs)
            %set(gca, 'yticklabel', ytics_Hr_round)
            
            
            %%
            
            plotpos = [0 0 20 40];
            PlotDir = [obj.DIR.birdDir 'Plots' obj.DIR.dirD obj.DIR.dirName '_plots' obj.DIR.dirD];
            
            plot_filename = [PlotDir 'SWR_Detections'];
            print_in_A4(0, plot_filename, '-djpeg', 0, plotpos);
            print_in_A4(0, plot_filename, '-depsc', 0, plotpos);
            
            
            %% Wavelet
            
            %{
              thisSegData_wav = rawLFP_D_fn;
               
                
                dsf = 20;
                Fsd = Fs/dsf;
                hcf = 400;
                [n_ch,n_tr,N] = size(thisSegData_wav);
                
                [bb,aa] = butter(2,hcf/(Fs/2),'low');
                V_ds = reshape(permute(thisSegData_wav,[3 1 2]),[],n_ch*n_tr);
                V_ds = downsample(filtfilt(bb,aa,V_ds),dsf);
                V_ds = reshape(V_ds,[],n_ch,n_tr);
                
                %
                [N,n_chs,n_trials] = size(V_ds);
                nfreqs = 60;
                min_freq = 1.5;
                max_freq = 400;
                Fsd = Fs/dsf;
                min_scale = 1/max_freq*Fsd;
                max_scale = 1/min_freq*Fsd;
                wavetype = 'cmor1-1';
                scales = logspace(log10(min_scale),log10(max_scale),nfreqs);
                wfreqs = scal2frq(scales,wavetype,1/Fsd);
                
                use_ch = 1;
                cur_V = squeeze(V_ds(:,use_ch,:));
                V_wave = cwt(cur_V(:),scales,wavetype);
                V_wave = reshape(V_wave,nfreqs,[],n_trials);
                
                %% Mean PLot
                
             tr=1;
             clims = [0 20];
                ax3 = subplot(8,2,8);
                pcolor((1:N)/Fsd,wfreqs,abs(squeeze(V_wave(:,:,tr))));shading flat
                %set(gca,'yscale','log');
                axis tight
                ylim([0 400])
                
                caxis(clims);
                
             tr=1;
             clims = [0 20];
                ax3 = subplot(8,2,8);
                pcolor((1:N)/Fsd,wfreqs,abs(squeeze(V_wave(:,:,tr))));shading flat
                set(gca,'yscale','log');
                axis tight
                ylim([0 400])
                
                caxis(clims);
                
            %}
            
            
            
        end
        
        
        function [obj] = detectSWRsOld(obj, dataRecordingObj)
            
            %%
            doPlot = 1;
            
            chanToUse = obj.REC.bestChs(2);
            SessionDir = obj.Session.SessionDir;
            
            eval(['fileAppend = ''106_CH' num2str(chanToUse) '.continuous'';'])
            fileName = [SessionDir fileAppend];
            
            [data, timestamps, info] = load_open_ephys_data(fileName);
            Fs = info.header.sampleRate;
            
            [V_uV_data_full,nshifts] = shiftdim(data',-1);
            
            thisSegData = V_uV_data_full(:,:,:);
            thisSegData_s = timestamps(1:end) - timestamps(1);
            recordingDuration_s = thisSegData_s(end);
            
            
            %%
            fObj = filterData(Fs);
            
            fobj.filt.F=filterData(Fs);
            %fobj.filt.F.downSamplingFactor=120; % original is 128 for 32k
            fobj.filt.F.downSamplingFactor=120; % original is 128 for 32k
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
            
            fobj.filt.Ripple=filterData(Fs);
            fobj.filt.Ripple.highPassCutoff=80;
            fobj.filt.Ripple.lowPassCutoff=300;
            fobj.filt.Ripple.filterDesign='butter';
            fobj.filt.Ripple=fobj.filt.Ripple.designBandPass;
            fobj.filt.Ripple.padding=true;
            
            fobj.filt.SW=filterData(Fs);
            fobj.filt.SW.highPassCutoff=8;
            fobj.filt.SW.lowPassCutoff=40;
            fobj.filt.SW.filterDesign='butter';
            fobj.filt.SW=fobj.filt.SW.designBandPass;
            fobj.filt.SW.padding=true;
            
            fobj.filt.FN =filterData(Fs);
            fobj.filt.FN.filterDesign='cheby1';
            fobj.filt.FN.padding=true;
            fobj.filt.FN=fobj.filt.FN.designNotch;
            
            %% For estiamting scale
            nTestSegments = 40;
            percentile4ScaleEstimation = 20;
            
            rng(1);
            
            seg_s= 20;
            TOn=1:seg_s*Fs:(recordingDuration_s*Fs-seg_s*Fs);
            nCycles = numel(TOn);
            
            pCycle=sort(randperm(nCycles,nTestSegments));
            Mtest=cell(nTestSegments,1);
            tTest=cell(nTestSegments,1);
            for i=1:numel(pCycle)
                
                
                thisROI = TOn(pCycle(i)):TOn(pCycle(i)+1);
                SegData = V_uV_data_full(:,:, thisROI);
                
                DataSeg_BP = fobj.filt.BP.getFilteredData(SegData);
                DataSeg_HF = squeeze(fobj.filt.FH2.getFilteredData(DataSeg_BP));
                %%
                smoothWin = 0.10*Fs;
                DataSeg_rect_HF = smooth(DataSeg_HF.^2, smoothWin);
                
                Mtest{i} = DataSeg_rect_HF;
                
            end
            Mtest=cell2mat(Mtest);
            
            sortedMtest=sort(Mtest);
            peakHeight_iqr = 3*iqr(sortedMtest);
            
            clear('Mtest', 'sortedMtest')
            
            %%
            seg_s=40;
            TOn=1:seg_s*Fs:(recordingDuration_s*Fs-seg_s*Fs);
            overlapWin = 2*Fs;
            
            nCycles = numel(TOn);
            
            cnt = 1;
            cnnt = 1;
            
            templatePeaks = [];
            ripplePeaks = [];
            
            for i=1:nCycles-1
                figure(300); clf
                if i ==1
                    thisROI = TOn(i):TOn(i+1);
                else
                    thisROI = TOn(i)-overlapWin:TOn(i+1);
                end
                
                SegData = V_uV_data_full(:,:, thisROI);
                SegData_s = thisSegData_s(thisROI);
                
                DataSeg_BP = fobj.filt.BP.getFilteredData(SegData);
                DataSeg_FNotch = squeeze(fobj.filt.FN.getFilteredData(DataSeg_BP));
                DataSeg_LF = squeeze(fobj.filt.FL.getFilteredData(DataSeg_BP));
                DataSeg_HF = squeeze(fobj.filt.FH2.getFilteredData(DataSeg_BP));
                Data_SegData = squeeze(SegData);
                %%
                smoothWin = 0.10*Fs;
                DataSeg_LF_neg = -DataSeg_LF;
                %figure; plot(DataSeg_LF_neg)
                DataSeg_rect_HF = smooth(DataSeg_HF.^2, smoothWin);
                %baseline = mean(DataSeg_rect_HF)*2;
                
                %figure; plot(SegData_s, DataSeg_rect_HF); axis tight
                
                %% Find Peaks
                interPeakDistance = 0.2*Fs;
                minPeakWidth = 0.05*Fs;
                %minPeakHeight = 200;
                minPeakHeight = peakHeight_iqr;
                minPeakProminence = 30;
                
                [peakH,peakTime_Fs, peakW, peakP]=findpeaks(DataSeg_rect_HF,'MinPeakHeight',minPeakHeight, 'MinPeakWidth', minPeakWidth, 'MinPeakProminence',minPeakProminence, 'MinPeakDistance', interPeakDistance, 'WidthReference','halfprom'); %For HF
                
                %%
                
                absPeakTime_s =  SegData_s(peakTime_Fs);
                asPeakTime_fs = peakTime_Fs+thisROI(1)-1;
                % relPeakTime_s  = peakTime_Fs;
                
                %%
                if doPlot
                    %{
                                        figure(100);clf;
                    
                                        subplot(3,1,1)
                                        plot(SegData_s, DataSeg_FNotch, 'k'); title( ['Raw']);
                                        axis tight
                                        ylim([-300 300])
                    
                                        subplot(3, 1, 2)
                                        plot(SegData_s, DataSeg_HF, 'k'); title( ['Ripple']);
                                        axis tight
                                        ylim([-80 80])
                    
                                        subplot(3, 1, 3)
                                        plot(SegData_s, smooth(DataSeg_rect_HF, .05*Fs), 'k'); title( ['Ripple Rectified']);
                                        axis tight
                                        ylim([0 400])
                                        hold on
                                        plot(SegData_s(peakTime_Fs), 200, 'rv')
                    %}
                    
                    figure(300);
                    
                    subplot(5, 1, 1)
                    plot(SegData_s, Data_SegData); title( ['Raw Voltage']);
                    hold on
                    %plot(SegData_s(peakTime_Fs(q)), 0, 'r*')
                    axis tight
                    
                    subplot(5, 1, 2)
                    plot(SegData_s, DataSeg_FNotch); title( ['Notch Filter']);
                    hold on
                    %plot(SegData_s(peakTime_Fs(q)), 0, 'r*')
                    axis tight
                    
                    subplot(5, 1, 3)
                    plot(SegData_s, DataSeg_LF); title( ['LF']);
                    axis tight
                    
                    subplot(5, 1,4)
                    plot(SegData_s, DataSeg_rect_HF); title( ['HF Rectified']);
                    hold on;
                    %plot(SegData_s(peakTime_Fs(q)), DataSeg_rect_HF(peakTime_Fs(q)), 'r*');
                    axis tight
                    ylim([0 500])
                    
                    subplot(5,1, 5)
                    plot(SegData_s, DataSeg_HF); title( ['HF Rectified']);
                    hold on;
                    %plot(SegData_s(peakTime_Fs(q)), DataSeg_HF(peakTime_Fs(q)), 'rv');
                    axis tight
                    
                end
                
                WinSizeL = 0.15*Fs;
                WinSizeR = 0.15*Fs;
                
                for q =1:numel(peakTime_Fs)
                    
                    if doPlot
                        figure(300);
                        
                        subplot(5, 1, 1)
                        %plot(SegData_s, Data_SegData); title( ['Raw Voltage']);
                        hold on
                        plot(SegData_s(peakTime_Fs(q)), 0, 'r*')
                        axis tight
                        
                        subplot(5, 1, 2)
                        %plot(SegData_s, DataSeg_FNotch); title( ['Notch Filter']);
                        hold on
                        plot(SegData_s(peakTime_Fs(q)), 0, 'r*')
                        axis tight
                        
                        subplot(5, 1, 3)
                        plot(SegData_s, DataSeg_LF); title( ['LF']);
                        axis tight
                        
                        subplot(5, 1,4)
                        %plot(SegData_s, DataSeg_rect_HF); title( ['HF Rectified']);
                        hold on;
                        plot(SegData_s(peakTime_Fs(q)), DataSeg_rect_HF(peakTime_Fs(q)), 'r*');
                        axis tight
                        ylim([0 500])
                        
                        subplot(5,1, 5)
                        %plot(SegData_s, DataSeg_HF); title( ['HF Rectified']);
                        hold on;
                        plot(SegData_s(peakTime_Fs(q)), DataSeg_HF(peakTime_Fs(q)), 'rv');
                        axis tight
                        
                        
                    end
                    
                    winROI = peakTime_Fs(q)-WinSizeL:peakTime_Fs(q)+WinSizeR;
                    
                    if winROI(end) > size(SegData_s, 1) || winROI(1) <0
                        disp('Win is too big/small')
                        continue
                    else
                        
                        LFWin = -DataSeg_LF(winROI);
                        
                        minPeakWidth_LF = 0.030*Fs;
                        %minPeakHeight_LF = 150;
                        %minPeakProminence = 195;
                        minPeakHeight_LF = 20;
                        minPeakProminence = 100;
                        
                        [peakH_LF,peakTime_Fs_LF, peakW_LF, peakP_LF]=findpeaks(LFWin,'MinPeakHeight',minPeakHeight_LF, 'MinPeakProminence',minPeakProminence, 'MinPeakWidth', minPeakWidth_LF, 'WidthReference','halfprom'); %For HF
                        % prominence is realted to window size
                        
                        %% Test
                        %{
                            figure(104);clf
                            winROI_s = SegData_s(winROI);
                            plot(winROI_s, LFWin); axis tight
                            hold on
                            plot(winROI_s(peakTime_Fs_LF), LFWin(peakTime_Fs_LF), '*')
                        %}
                        %%
                        disp('')
                        
                        if numel(peakTime_Fs_LF) == 1
                            
                            templatePeaks.peakH(cnt) = peakH(q);
                            templatePeaks.asPeakTime_fs(cnt) = asPeakTime_fs(q);
                            templatePeaks.absPeakTime_s(cnt) = absPeakTime_s(q);
                            templatePeaks.peakW(cnt) = peakW(q);
                            templatePeaks.peakP(cnt) = peakP(q);
                            
                            absPeakTime_Fs_LF = (peakTime_Fs_LF + peakTime_Fs(q)-WinSizeL) +thisROI(1)-1; % this is realtive to both the LF window and the larger ROI
                            
                            templatePeaks.peakH_LF(cnt) = peakH_LF;
                            templatePeaks.absPeakTime_Fs_LF(cnt) = absPeakTime_Fs_LF;
                            templatePeaks.peakW_LF(cnt) = peakW_LF;
                            templatePeaks.peakP_LF(cnt) = peakP_LF;
                            
                            cnt = cnt+1;
                            
                            
                            %% Test
                            % testROI = asPeakTime_fs(q)-0.2*Fs:asPeakTime_fs(q)+0.2*Fs;% THis is the HF, it will be offset from the peak of the SHW
                            % figure; plot(SegData_s(testROI), DataSeg_rect_HF(testROI)); axis tight
                            % figure; plot(SegData_s(testROI), DataSeg_FNotch(testROI)); axis tight
                            %line([ thisSegData_s(asPeakTime_fs(q)) thisSegData_s(asPeakTime_fs(q))], [-1000 500]);
                            
                            %testROI = absPeakTime_Fs_LF-(0.2*Fs):absPeakTime_Fs_LF+(0.2*Fs);
                            %figure(200); plot(SegData_s(testROI),  DataSeg_LF(testROI), 'k'); axis tight
                            %hold on; plot(SegData_s(testROI), DataSeg_FNotch(testROI)); axis tight
                            %line([ thisSegData_s(absPeakTime_Fs_LF(q)) thisSegData_s(absPeakTime_Fs_LF(q))], [-1000 500]);
                            
                            
                        elseif isempty(peakTime_Fs_LF)
                            if doPlot
                                figure(300);
                                
                                subplot(5,1, 5)
                                hold on;
                                plot(SegData_s(peakTime_Fs(q)), DataSeg_HF(peakTime_Fs(q)), 'kv');
                                
                                subplot(5, 1,4)
                                hold on;
                                plot(SegData_s(peakTime_Fs(q)), DataSeg_rect_HF(peakTime_Fs(q)), 'k*');
                                
                                subplot(5, 1, 1)
                                hold on
                                plot(SegData_s(peakTime_Fs(q)), 0, 'k*')
                                
                                subplot(5, 1, 2)
                                hold on
                                plot(SegData_s(peakTime_Fs(q)), 0, 'k*')
                            end
                            
                            ripplePeaks.peakH(cnnt) = peakH(q);
                            ripplePeaks.asPeakTime_fs(cnnt) = asPeakTime_fs(q);
                            ripplePeaks.absPeakTime_s(cnnt) = absPeakTime_s(q);
                            ripplePeaks.peakW(cnnt) = peakW(q);
                            ripplePeaks.peakP(cnnt) = peakP(q);
                            
                            cnnt = cnnt+1;
                            
                            continue
                        else % two detections
                            
                            templatePeaks.peakH(cnt) = peakH(q);
                            templatePeaks.asPeakTime_fs(cnt) = asPeakTime_fs(q);
                            templatePeaks.absPeakTime_s(cnt) = absPeakTime_s(q);
                            templatePeaks.peakW(cnt) = peakW(q);
                            templatePeaks.peakP(cnt) = peakP(q);
                            
                            %choose HighestPeak
                            [pmax, maxInd] = max(peakH_LF);
                            
                            absPeakTime_Fs_LF = (peakTime_Fs_LF(maxInd) + peakTime_Fs(q)-WinSizeL) +thisROI(1)-1; % this is realtive to both the LF window and the larger ROI
                            
                            relPeakTime_Fs_LF = (peakTime_Fs_LF(maxInd) + peakTime_Fs(q)-WinSizeL); % for plotting
                            
                            templatePeaks.peakH_LF(cnt) = peakH_LF(maxInd);
                            templatePeaks.absPeakTime_Fs_LF(cnt) = absPeakTime_Fs_LF;
                            templatePeaks.peakW_LF(cnt) = peakW_LF(maxInd);
                            templatePeaks.peakP_LF(cnt) = peakP_LF(maxInd);
                            
                            cnt = cnt+1;
                            
                            if doPlot
                                figure(300);
                                
                                subplot(5,1, 5)
                                hold on;
                                plot(SegData_s(relPeakTime_Fs_LF), DataSeg_HF(peakTime_Fs(q)), 'bv');
                                
                                subplot(5, 1,4)
                                hold on;
                                plot(SegData_s(relPeakTime_Fs_LF), DataSeg_rect_HF(peakTime_Fs(q)), 'b*');
                                
                                subplot(5, 1, 1)
                                hold on
                                plot(SegData_s(relPeakTime_Fs_LF), 0, 'b*')
                                
                                subplot(5, 1, 2)
                                hold on
                                plot(SegData_s(relPeakTime_Fs_LF), 0, 'b*')
                            end
                            continue
                            
                        end
                    end
                    
                end
                
                PlotDir = [obj.DIR.birdDir 'Plots' obj.DIR.dirD obj.DIR.dirName '_plots' obj.DIR.dirD];
                if exist(PlotDir, 'dir') == 0
                    mkdir(PlotDir);
                    disp(['Created: '  PlotDir])
                end
                plot_filename = [PlotDir 'SWR_Detections-Plots' sprintf('%03d', i)];
                
                plotpos = [0 0 25 15];
                figure(300);
                print_in_A4(0, plot_filename, '-djpeg', 0, plotpos);
                
                
                
            end
            
            DetectionSaveName = [PlotDir '-Detections'];
            save(DetectionSaveName, 'templatePeaks', 'ripplePeaks');
            
            disp(['Saved:' DetectionSaveName ])
            
        end
        
        
        
        function [obj = validateSWRs(obj)
        
            
            doPlot = 1;
            
            chanToUse = obj.REC.bestChs(1);
            SessionDir = obj.Session.SessionDir;
            
            eval(['fileAppend = ''106_CH' num2str(chanToUse) '.continuous'';'])
            fileName = [SessionDir fileAppend];
            
            [data, timestamps, info] = load_open_ephys_data(fileName);
            Fs = info.header.sampleRate;
            
            [V_uV_data_full,nshifts] = shiftdim(data',-1);
            
            thisSegData = V_uV_data_full(:,:,:);
            thisSegData_s = timestamps(1:end) - timestamps(1);
            recordingDuration_s = thisSegData_s(end);
            
            
            
%% Acute

%% Chronic
% pathToSWRDetections = 'D:\TUM\SWR-Project\ZF-71-76\20190917\09-00-29\Analysis\09-00-29__SWR-Detections';
% fileName = 'D:\TUM\SWR-Project\ZF-71-76\20190917\09-00-29\Ephys\106_CH15.continuous';
% plotDir =  'D:\TUM\SWR-Project\ZF-71-76\20190917\09-00-29\Plots\';
% saveDir = 'D:\TUM\SWR-Project\ZF-71-76\20190917\09-00-29\Analysis\';

% pathToSWRDetections = 'D:\TUM\SWR-Project\ZF-71-76\20190918\18-04-28\Analysis\18-04-28__SWR-Detections';
% fileName = 'D:\TUM\SWR-Project\ZF-71-76\20190918\18-04-28\Ephys\106_CH15.continuous';
% plotDir =  'D:\TUM\SWR-Project\ZF-71-76\20190918\18-04-28\Plots\';
% saveDir = 'D:\TUM\SWR-Project\ZF-71-76\20190918\18-04-28\Analysis\';

% pathToSWRDetections = 'D:\TUM\SWR-Project\ZF-71-76\20190923\18-21-42\Analysis\18-21-42__SWR-Detections';
% fileName = 'D:\TUM\SWR-Project\ZF-71-76\20190923\18-21-42\Ephys\106_CH15.continuous';
% plotDir =  'D:\TUM\SWR-Project\ZF-71-76\20190923\18-21-42\Plots\';
% saveDir = 'D:\TUM\SWR-Project\ZF-71-76\20190923\18-21-42\Analysis\';

% pathToSWRDetections = 'D:\TUM\SWR-Project\ZF-71-76\20190920\18-37-00\Analysis\18-37-00__SWR-Detections';
% fileName = 'D:\TUM\SWR-Project\ZF-71-76\20190920\18-37-00\Ephys\106_CH15.continuous';
% plotDir =  'D:\TUM\SWR-Project\ZF-71-76\20190920\18-37-00\Plots\';
% saveDir = 'D:\TUM\SWR-Project\ZF-71-76\20190920\18-37-00\Analysis\';

% pathToSWRDetections = 'D:\TUM\SWR-Project\ZF-71-76\20190916\18-05-58\Analysis\18-05-58__SWR-Detections';
% fileName = 'D:\TUM\SWR-Project\ZF-71-76\20190916\18-05-58\Ephys\106_CH15.continuous';
% plotDir =  'D:\TUM\SWR-Project\ZF-71-76\20190916\18-05-58\Plots\';
% saveDir = 'D:\TUM\SWR-Project\ZF-71-76\20190916\18-05-58\Analysis\';

% pathToSWRDetections = 'D:\TUM\SWR-Project\ZF-71-76\20190919\17-51-46\Analysis\17-51-46__SWR-Detections';
% fileName = 'D:\TUM\SWR-Project\ZF-71-76\20190919\17-51-46\Ephys\106_CH15.continuous';
% plotDir =  'D:\TUM\SWR-Project\ZF-71-76\20190919\17-51-46\Plots\';
% saveDir = 'D:\TUM\SWR-Project\ZF-71-76\20190919\17-51-46\Analysis\';

% pathToSWRDetections = 'D:\TUM\SWR-Project\ZF-71-76\20190917\16-05-11\Analysis\16-05-11__SWR-Detections.mat';
% fileName = 'D:\TUM\SWR-Project\ZF-71-76\20190917\16-05-11\Ephys\106_CH15.continuous';
% plotDir =  'D:\TUM\SWR-Project\ZF-71-76\20190917\16-05-11\Plots\';
% saveDir = 'D:\TUM\SWR-Project\ZF-71-76\20190917\16-05-11\Analysis\';

dirD = '\';


s = load(pathToSWRDetections);

Ripple = s.Ripple;
SW = s.SW;


[pathstr,name,ext] = fileparts(fileName);
bla = find(fileName == dirD);
dataName = fileName(bla(end-1)+1:bla(end)-1);
%saveName = [pathstr dirD dataName '-fullData'];
[data, timestamps, info] = load_open_ephys_data(fileName);
Fs = info.header.sampleRate;
disp('Fininshed loading...')
fObj = filterData(Fs);
thisSegData_s = timestamps(1:end) - timestamps(1);

timeRangeOn = round(1.9*3600*Fs);
timeRangeOff = round(2.5*3600*Fs);

dataRange = data(timeRangeOn:timeRangeOff);
dataSeg_S = thisSegData_s(timeRangeOn:timeRangeOff);
figure; plot(dataSeg_S, dataRange)
axis tight

%% Filters

% fobj.filt.FL=filterData(Fs);
% %fobj.filt.FL.lowPassPassCutoff=4.5;
% fobj.filt.FL.lowPassPassCutoff=8;
% fobj.filt.FL.lowPassStopCutoff=10;
% fobj.filt.FL.attenuationInLowpass=20;
% fobj.filt.FL=fobj.filt.FL.designLowPass;
% fobj.filt.FL.padding=true;

fobj.filt.FH2=filterData(Fs);
fobj.filt.FH2.highPassCutoff=100;
fobj.filt.FH2.lowPassCutoff=2000;
fobj.filt.FH2.filterDesign='butter';
fobj.filt.FH2=fobj.filt.FH2.designBandPass;
fobj.filt.FH2.padding=true;

fobj.filt.BP=filterData(Fs);
fobj.filt.BP.highPassCutoff=1;
fobj.filt.BP.lowPassCutoff=2000;
fobj.filt.BP.filterDesign='butter';
fobj.filt.BP=fobj.filt.BP.designBandPass;
fobj.filt.BP.padding=true;

fobj.filt.FN =filterData(Fs);
fobj.filt.FN.filterDesign='cheby1';
fobj.filt.FN.padding=true;
fobj.filt.FN=fobj.filt.FN.designNotch;

%%

%% SWs

sw_peakH_1 = SW.peakSW_H;
sw_peakTime_fs_1 = SW.absPeakTime_SW_fs; % first detection
sw_peakW_fs_1 = SW.peakSW_W; % at half prominence

% Use the verified 2nd detections
sw_peakTime_fs_2 = SW.absPeakTime_Fs_LF; % second detection
sw_peakH_2 = SW.peakH_SWcheck; % second detection
sw_peakW_2 = SW.peakW_SWcheck; % at half width

[C,UInds,ic] = unique(sw_peakTime_fs_2); % since we have an overlap, we have to get rid of all the double detections

sw_peakW = sw_peakW_2(UInds);
sw_peakH = sw_peakH_2(UInds);
sw_peakTime_fs = sw_peakTime_fs_2(UInds);

Fs = 30000;

%% Ripples

Rip_peakH_1 = Ripple.peakH;
Rip_peakTime_fs_1 = Ripple.asPeakTime_fs; % first detection
Rip_peakW_fs_1 = Ripple.peakW; % at half prominence

% Use the verified 2nd detections
rip_peakH_2 = Ripple.peakH_ripcheck; % second detection
rip_peakTime_fs_2 = Ripple.absPeakTime_Fs_LF; % second detection
rip_peakW_2 = Ripple.peakW_ripcheck; % at half width

[C,UInds,ic] = unique(rip_peakTime_fs_2); % since we have an overlap, we have to get rid of all the double detections

rip_peakW = rip_peakW_2(UInds);
rip_peakH = rip_peakH_2(UInds);
rip_peakTime_fs = rip_peakTime_fs_2(UInds);

%% Get rid of 10 ms overlaps ripples
FsWin = 10/1000 *Fs;

peakDiffs = diff(rip_peakTime_fs);
smallDiffs = find(peakDiffs <= FsWin);

rip_peakW_nDD  = rip_peakW;
rip_peakH_nDD  = rip_peakH;
rip_peakfs_nDD  = rip_peakTime_fs;

rip_peakW_nDD(smallDiffs+1) = [];
rip_peakH_nDD(smallDiffs+1) = [];
rip_peakfs_nDD(smallDiffs+1) = [];

%% Get rid of very large ripple peaks and small 


outliers_h_ind = find(rip_peakH_nDD >1500);

rip_peakH_nDD(outliers_h_ind) = [];
rip_peakW_nDD(outliers_h_ind) = [];
rip_peakfs_nDD(outliers_h_ind) = [];

outliers_h_ind = find(rip_peakH_nDD <115);

rip_peakH_nDD(outliers_h_ind) = [];
rip_peakW_nDD(outliers_h_ind) = [];
rip_peakfs_nDD(outliers_h_ind) = [];


%%


figure(102);clf

subplot(3, 1, 1); plot(rip_peakfs_nDD/Fs/3600, rip_peakH_nDD, 'k.'); axis tight; title('Ripple height')
subplot(3, 1, 2); plot(rip_peakfs_nDD/Fs/3600, rip_peakW_nDD/Fs*1000, 'k.'); axis tight; title('Ripple width')
subplot(3, 1, 3); plot(rip_peakH_nDD, rip_peakW_nDD/Fs*1000, 'k.'); axis tight; title('Ripple height vs width') 

%% Find all peaks that are within 10 ms of eachother;
FsWin = 10/1000 *Fs;

peakDiffs = diff(sw_peakTime_fs);
smallDiffs = find(peakDiffs <= FsWin);
    
    
    sw_peakW_nDD  = sw_peakW;
    sw_peakH_nDD  = sw_peakH;
    sw_peakfs_nDD  = sw_peakTime_fs;
    
    sw_peakW_nDD(smallDiffs+1) = [];
    sw_peakH_nDD(smallDiffs+1) = [];
    sw_peakfs_nDD(smallDiffs+1) = [];
    
   %% test for normal distribution

   [h, p] = kstest(sw_peakH);
   [h, p] = kstest(sw_peakW);
   
%% Find height and width outliers

outliers_h_ind = find(sw_peakH_nDD >430);

sw_peakH_nDD(outliers_h_ind) = [];
sw_peakW_nDD(outliers_h_ind) = [];
sw_peakfs_nDD(outliers_h_ind) = [];


outliers_h_ind = find(sw_peakH_nDD <85);

sw_peakH_nDD(outliers_h_ind) = [];
sw_peakW_nDD(outliers_h_ind) = [];
sw_peakfs_nDD(outliers_h_ind) = [];


%% Also look for SHWs smaller than 80 uV

outliers_w_ind = find(sw_peakW_nDD >= 0.120*Fs);
sw_peakH_nDD(outliers_w_ind) = [];
sw_peakW_nDD(outliers_w_ind) = [];
sw_peakfs_nDD(outliers_w_ind) = [];

%% Outliers
outliers_H_m = find(isoutlier(sw_peakH_nDD, 'median', 'ThresholdFactor', 6));
outliers_H_fs = sw_peakfs_nDD(outliers_H_m);
outliers_H_vals = sw_peakH_nDD(outliers_H_m);
outliers_H_Wvals = sw_peakW_nDD(outliers_H_m);

figure; plot(outliers_H_Wvals, outliers_H_vals, 'k*');

outliers_W_m = find(isoutlier(sw_peakW_nDD, 'median', 'ThresholdFactor', 5));
outliers_W_fs = sw_peakfs_nDD(outliers_W_m);
outliers_W_vals = sw_peakW_nDD(outliers_W_m);
outliers_W_Hvals = sw_peakH_nDD(outliers_W_m);

figure; plot(outliers_W_vals, outliers_W_Hvals, 'k*');

medianH = median(sw_peakH);
medianW_ms = median(sw_peakW/Fs)*1000;
stdH = std(sw_peakH)*6;
stdW = std((sw_peakW/Fs)*1000)*6;

%%

finalPeakTimes_fs = sw_peakfs_nDD;
finalPeakH = sw_peakH_nDD;
finalPeakW_fs = sw_peakW_nDD;

rip_peakTime_fs = rip_peakfs_nDD;


%% Go over all Shs and look for ripples

peakWinL = 0.03*Fs;
peakWinR = 0.03*Fs;

allSW_fs = []; allSWR_H = []; allSWR_W_fs = [];
allSWR_fs = []; allSW_H = []; allSW_W_fs = [];
allSWR_rips_fs = []; allSWR_rips_H = []; allSWR_rips_W = [];
cnt = 1;
cnnt = 1;

for j = 1:numel(finalPeakTimes_fs)
    
    sw_thisPeak_fs = finalPeakTimes_fs(j);
    
    checkL = sw_thisPeak_fs-peakWinL;
    checkR = sw_thisPeak_fs+peakWinR;
    
    match = numel(rip_peakTime_fs(rip_peakTime_fs >= checkL & rip_peakTime_fs <= checkR));
    if match == 1
        thisRipple_fs = rip_peakTime_fs(rip_peakTime_fs >= checkL & rip_peakTime_fs <= checkR);
        rippleInd = find(rip_peakTime_fs == thisRipple_fs(1));
    end
    if match == 1 % 1 SW, 1 ripple
        
        allSWR_fs(cnt) = sw_thisPeak_fs;
        allSWR_H(cnt) = finalPeakH(j);
        allSWR_W_fs(cnt) = finalPeakW_fs(j);
        
        allSWR_rips_fs(cnt) = thisRipple_fs;
        allSWR_rips_H(cnt) = rip_peakH_nDD(rippleInd);
        allSWR_rips_W(cnt) = rip_peakW_nDD(rippleInd);
        cnt = cnt+1;
        
    elseif match > 1
        times_fs = rip_peakTime_fs(rip_peakTime_fs >= checkL & rip_peakTime_fs <= checkR);
        diffTimes_ms= (diff(times_fs)/Fs)*1000;
        
        if diffTimes_ms <50 % take the first time
            peakTodelete =times_fs(2);
            bla = find(rip_peakTime_fs ==peakTodelete);
            rip_peakTime_fs(bla) = [];

            allSWR_fs(cnt) = sw_thisPeak_fs;
            allSWR_H(cnt) = finalPeakH(j);
            allSWR_W_fs(cnt) = finalPeakW_fs(j);
            
            allSWR_rips_fs(cnt) = thisRipple_fs;
            allSWR_rips_H(cnt) = rip_peakH_nDD(rippleInd);
            allSWR_rips_W(cnt) = rip_peakW_nDD(rippleInd);
            cnt = cnt+1;
            
        else
            
            disp('')
            
        end
        
        %{
        %roi = times_fs(1)-.1*Fs: times_fs(2)+.1*Fs;
        roi = sw_thisPeak_fs(1)-.1*Fs: sw_thisPeak_fs(1)+.1*Fs;
        
        thisData = data(roi);
        [V_uV_data_full,nshifts] = shiftdim(thisData',-1);
        DataSeg_BP = fobj.filt.BP.getFilteredData(V_uV_data_full);
        DataSeg_FNotch = squeeze(fobj.filt.FN.getFilteredData(DataSeg_BP));
        DataSeg_HF = squeeze(fobj.filt.FH2.getFilteredData(V_uV_data_full));

        figure(403); clf
        plot(DataSeg_HF);
        hold on
        %plot(times_fs-roi(1), 0, 'rv')
        plot(sw_thisPeak_fs-roi(1), 0, 'rv')
        plot(DataSeg_FNotch);
        axis tight
       
        %}
        disp('')
    elseif match == 0
        
        allSW_fs(cnnt) = sw_thisPeak_fs;
        allSW_H(cnnt) = finalPeakH(j);
        allSW_W_fs(cnnt) = finalPeakW_fs(j);
        cnnt = cnnt+1;
        
    end
    
end


allSWR.allSWR_fs = allSWR_fs;
allSWR.allSWR_H = allSWR_H;
allSWR.allSWR_W_fs = allSWR_W_fs;

allSWR_rips.allSWR_rips_fs = allSWR_rips_fs;
allSWR_rips.allSWR_rips_H = allSWR_rips_H;
allSWR_rips.allSWR_rips_W = allSWR_rips_W;

allSW.allSW_fs = allSW_fs;
allSW.allSW_H = allSW_H;
allSW.allSW_W_fs = allSW_W_fs;

saveName = 'vDetections.mat';
save([saveDir saveName], 'allSWR', 'allSWR_rips', 'allSW')
    
%% Plot of SWR over time

figure(103);clf

subplot(7, 1, [2 3] ); plot(allSWR_fs/Fs/3600, allSWR_H, 'k.'); axis tight; xlabel('Time (hr)'); ylabel('SWR amplitude (uV)')
ylim([80 450])
subplot(7, 1, [5 6]); plot(allSWR_fs/Fs/3600, allSWR_W_fs/Fs*1000, 'k.'); axis tight; xlabel('Time (hr)'); ylabel('SWR width (ms)')
ylim([1 150])

%subplot(13, 1, [8 9] ); plot(allSWR_rips_fs/Fs/3600, allSWR_rips_H, 'k.'); axis tight; xlabel('Time (hr)'); ylabel('Ripple amplitude (uV)')
%subplot(13, 1, [11 12]); plot(allSWR_rips_fs/Fs/3600, allSWR_rips_W/Fs*1000, 'k.'); axis tight; xlabel('Time (hr)'); ylabel('SWR width (ms)')

% Histograms
% Height
%{
maxH = max(allSWR_H);
minH = min(allSWR_H);

binsC_H = minH:5:maxH;

subplot(13, 1, [5 6])
histogram(allSWR_H, binsC_H, 'FaceColor', 'k', 'EdgeColor', 'k');
meanH = mean(allSWR_H);
medianH = median(allSWR_H);
hold on
plot(medianH, 0, 'rv')
plot(meanH, 0, 'bv')
title('SWR amplitude(uV)')

subplot(7, 5, [15 20]); 
[cx,cy]=hist(allSWR_H,binsC_H);
bla = cumsum(cx) ./ sum(cx);
hold on
plot(cy, (bla), 'linewidth', 2)
clear('cx','cy');

% Width
peakW_ms = (allSWR_W_fs/Fs)*1000;

maxH = max(peakW_ms);
minH = min(peakW_ms);

binsC_W = minH:2:maxH;
subplot(7, 5, [24 29]); 
histogram(peakW_ms, binsC_W, 'FaceColor', 'k', 'EdgeColor', 'k');
meanW = mean(peakW_ms);
medianW = median(peakW_ms);
hold on
plot(medianW, 0, 'rv')
plot(meanW, 0, 'bv')
title('SWR width (ms)')

subplot(7, 5, [25 30]); 
[cx,cy]=hist(peakW_ms,binsC_W);
bla = cumsum(cx) ./ sum(cx);
hold on
plot(cy, (bla), 'linewidth', 2)
clear('cx','cy');
%}

%% Plots of means over time

binSize_s = 1*60;
binSize_Fs = binSize_s*Fs;

TOns = 1:binSize_Fs:numel(data);
for j = 1:numel(TOns)-1
    theseV_inds =  find(allSWR_fs >= TOns(j) & allSWR_fs < TOns(j)+binSize_Fs);    
    theseV_vals = allSWR_H(theseV_inds);
    theseW_vals = allSWR_W_fs(theseV_inds);
    ShWMeanAmp(j) = mean(theseV_vals);
    ShWMeanWidth(j) = mean(theseW_vals)/Fs*1000;
    nWRs(j) = numel(theseV_inds);
end

SWR_rate = nWRs/binSize_s;

smoothWin = 5;
subplot(7, 1, [1] );
plot(smooth(ShWMeanAmp, smoothWin));
%plot(ShWMeanAmp);
axis tight

subplot(7, 1, [4] );
plot(smooth(ShWMeanWidth, smoothWin));
axis tight

subplot(7, 1, [7] );
plot(smooth(SWR_rate));
axis tight



%% plotting lines for the awake vs sleep

TimeROi_awake_fs = [1 1*3600*Fs];
%TimeROi_sleep_s = [6*3600 7*3600];
TimeROi_sleep_s = [3*3600 4*3600];
TimeROi_sleep_fs = TimeROi_sleep_s*Fs;

subplot(7, 1, [2 3] ); 
hold on
yss = ylim;
line([TimeROi_awake_fs(1)/Fs/3600 TimeROi_awake_fs(1)/Fs/3600], [yss(1) yss(2)], 'color', 'r')
line([TimeROi_awake_fs(2)/Fs/3600 TimeROi_awake_fs(2)/Fs/3600], [yss(1) yss(2)], 'color', 'r')
line([TimeROi_sleep_fs(2)/Fs/3600 TimeROi_sleep_fs(2)/Fs/3600], [yss(1) yss(2)], 'color', 'r')
line([TimeROi_sleep_fs(1)/Fs/3600 TimeROi_sleep_fs(1)/Fs/3600], [yss(1) yss(2)], 'color', 'r')

subplot(7, 1, [5 6]);
yss = ylim;
line([TimeROi_awake_fs(1)/Fs/3600 TimeROi_awake_fs(1)/Fs/3600], [yss(1) yss(2)], 'color', 'r')
line([TimeROi_awake_fs(2)/Fs/3600 TimeROi_awake_fs(2)/Fs/3600], [yss(1) yss(2)], 'color', 'r')
line([TimeROi_sleep_fs(2)/Fs/3600 TimeROi_sleep_fs(2)/Fs/3600], [yss(1) yss(2)], 'color', 'r')
line([TimeROi_sleep_fs(1)/Fs/3600 TimeROi_sleep_fs(1)/Fs/3600], [yss(1) yss(2)], 'color', 'r')

%% Print plot

saveName = [plotDir  'SWRAmplWidthScatterTimePLots'];
plotpos = [0 0 40 20];

print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);


%% Collecting awake vs Sleep data
  theseV_awake_inds =  find(allSWR_fs >= TimeROi_awake_fs(1) & allSWR_fs < TimeROi_awake_fs(2)); 
  theseV_sleep_inds =  find(allSWR_fs >= TimeROi_sleep_fs(1) & allSWR_fs < TimeROi_sleep_fs(2));

  awakeVs = allSWR_H(theseV_awake_inds);
 awakeWs = allSWR_W_fs(theseV_awake_inds);

 sleepVs = allSWR_H(theseV_sleep_inds);
 sleepWs = allSWR_W_fs(theseV_sleep_inds);
 
  

%% Scatter Hist plots all data

figure(310);clf; 

% subplot(2, 1, 1)
% plot(allSWR_H, allSWR_W_fs/Fs*1000, 'k.'); axis tight; xlabel('SWR amplitude (uV)');ylabel('SWR width (ms)')
% ylim([0 150])
% xlim([80 450])

scatterhist(allSWR_H,allSWR_W_fs/Fs*1000,'Kernel','on', 'Location','SouthEast',...
    'Direction','out', 'LineStyle',{'-','-'}, 'Marker','..')

saveName = [plotDir  'SWRAmplWidthScatterPLots'];

plotpos = [0 0 12 10];

print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);

%% Scatter Hist plots awake sleep data

figure(311);clf; 

group1 = ones(1, numel(awakeVs))*1;
group2 = ones(1, numel(sleepVs))*2;

groups = [group1 group2];
xes = [awakeVs sleepVs];
yes = [awakeWs/Fs*1000 sleepWs/Fs*1000];
scatterhist(xes,yes,'Group',groups,'Kernel','on', 'Location','SouthEast',...
    'Direction','out', 'LineStyle',{'-','-'}, 'Marker','..')

saveName = [plotDir  'SWRAmplWidthScatterPLots_AwakeSleep'];

plotpos = [0 0 12 10];

print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);

%% Statistics

  [h, p] = ttest2(awakeVs, sleepVs);
    [pp, hh] = ranksum(awakeVs, sleepVs);
  
  subplot(6, 5, [9 14]); 
     boxplot(awakeVs, 'whisker', 0, 'symbol', 'k.', 'outliersize', 2,  'jitter', 0.3, 'colors', [0 0 0], 'labels', 'Awake Amplitude')
  ylim([80 450])  
  title(['n=' num2str(numel(awakeVs))])
  subplot(6, 5, [10 15]); 
     boxplot(sleepVs, 'whisker', 0, 'symbol', 'k.', 'outliersize', 2,  'jitter', 0.3, 'colors', [0 0 0], 'labels', 'sleep Amplitude')
  title(['n=' num2str(numel(sleepVs))])
     ylim([80 450])
  
  
    [h, p] = ttest2(awakeWs, sleepWs);
    [pp, hh] = ranksum(awakeWs, sleepWs);
  
    subplot(6, 5, [24 29]); 
     boxplot(awakeWs, 'whisker', 0, 'symbol', 'k.', 'outliersize', 2,  'jitter', 0.3, 'colors', [0 0 0], 'labels', 'Awake Width')
 % ylim([80 450])  
  title(['n=' num2str(numel(awakeVs))])
  subplot(6, 5, [25 30]); 
     boxplot(sleepWs, 'whisker', 0, 'symbol', 'k.', 'outliersize', 2,  'jitter', 0.3, 'colors', [0 0 0], 'labels', 'sleep Width')
  title(['n=' num2str(numel(sleepVs))])
   %  ylim([80 450])


  %%
%   plot(awakeVs, awakeWs/Fs*1000, 'r.');
%   hold on
%   plot(-sleepVs, sleepWs/Fs*1000, 'b.');
%   hold on
%   
  
  
%% Histograms
% Height
  figure(310);clf; 

maxH = max(awakeVs);
minH = min(awakeVs);

binsC_H = minH:5:maxH;

subplot(2, 2, [1]); 
histogram(awakeVs, binsC_H, 'FaceColor', 'k', 'EdgeColor', 'k');
meanH = mean(awakeVs);
medianH = median(awakeVs);
hold on
plot(medianH, 0, 'rv')
plot(meanH, 0, 'bv')
title('SWR amplitude(uV)')

subplot(2, 2, [3]); 
histogram(sleepVs, binsC_H, 'FaceColor', 'k', 'EdgeColor', 'k');
meanH = mean(sleepVs);
medianH = median(sleepVs);
hold on
plot(medianH, 0, 'rv')
plot(meanH, 0, 'bv')


[cx,cy]=hist(allSWR_H,binsC_H);
bla = cumsum(cx) ./ sum(cx);
hold on
plot(cy, (bla), 'linewidth', 2)
clear('cx','cy');

% Width
peakW_ms = (allSWR_W_fs/Fs)*1000;

maxH = max(peakW_ms);
minH = min(peakW_ms);

binsC_W = minH:2:maxH;
subplot(7, 5, [24 29]); 
histogram(peakW_ms, binsC_W, 'FaceColor', 'k', 'EdgeColor', 'k');
meanW = mean(peakW_ms);
medianW = median(peakW_ms);
hold on
plot(medianW, 0, 'rv')
plot(meanW, 0, 'bv')
title('SWR width (ms)')

subplot(7, 5, [25 30]); 
[cx,cy]=hist(peakW_ms,binsC_W);
bla = cumsum(cx) ./ sum(cx);
hold on
plot(cy, (bla), 'linewidth', 2)
clear('cx','cy');


%% Checcking outliers

outlierToCheck_fs = outliers_W_fs;
valsToUse = outliers_W_vals/Fs*1000;

for j = 1:numel(outlierToCheck_fs)
    
    
    peakWinL = 0.1*Fs;
    peakWinR = 0.1*Fs;
    
    %currentPeakInd = TF(j);
    
    currentPeak = outlierToCheck_fs(j);
    
    %roi = peaks(currentPeakInd)-peakWinL:peaks(currentPeakInd)+peakWinR;
    roi = currentPeak-peakWinL:currentPeak+peakWinR;
    roi_s = thisSegData_s(roi);
    thisData = data(roi);
    [V_uV_data_full,nshifts] = shiftdim(thisData',-1);
    DataSeg_BP = fobj.filt.BP.getFilteredData(V_uV_data_full);
    DataSeg_FNotch = squeeze(fobj.filt.FN.getFilteredData(DataSeg_BP));
    DataSeg_HF = squeeze(fobj.filt.FH2.getFilteredData(V_uV_data_full));
    
    
    figH = figure(300);
    figure(figH); clf;
    
    subplot(1, 3, 1)
    plot(roi_s, DataSeg_FNotch)
    hold on;
    plot(roi_s, DataSeg_HF, 'k')
    
    %line([ thisSegData_s(peaks(currentPeakInd)) thisSegData_s(peaks(currentPeakInd))], [-300 100])
    line([ thisSegData_s(currentPeak) thisSegData_s(currentPeak)], [-500 500], 'color', 'r')
    %text(roi_s(4000), 80, num2str(currentPeakInd), 'color', 'r')
    axis tight
    
    %allPeakInds = getappdata(figH, 'allPeakInds');
    %currentPeakInd = getappdata(figH, 'currentPeakInd');
    
    %if ismember(currentPeakInd,  allPeakInds)
    %    title('Saved')
    %else
    %    title('Not Saved')
    %end
    
    LongRoi =currentPeak-10*peakWinL:currentPeak+10*peakWinR;
    
    roi_s = thisSegData_s(LongRoi);
    thisData = data(LongRoi);
    [V_uV_data_full,nshifts] = shiftdim(thisData',-1);
    DataSeg_BP = fobj.filt.BP.getFilteredData(V_uV_data_full);
    DataSeg_FNotch = squeeze(fobj.filt.FN.getFilteredData(DataSeg_BP));
    DataSeg_HF = squeeze(fobj.filt.FH2.getFilteredData(V_uV_data_full));
    
    
    if LongRoi(1) >0
        %         FNotch_LongRoi = DataSeg_FNotch(LongRoi);
        %         HF_LongRoi = DataSeg_HF(LongRoi);
        %         roi_LongRoi_s = thisSegData_s(LongRoi);
        
        subplot(1, 3, [2 3])
        plot(roi_s, DataSeg_FNotch)
        hold on;
        plot(roi_s, DataSeg_HF, 'k')
        
        line([ thisSegData_s(currentPeak) thisSegData_s(currentPeak)], [-500 500], 'color', 'r')
        axis tight
        title(['Val = ' num2str(valsToUse(j))])
    else
        subplot(1, 3, [2 3])
    end
    
    pause
end



end




        
        
        function [obj] = detectSWRs_ripple_SW_Band(obj)
            
            %%
            doPlot = 0;
            dbstop if error
            
            chanToUse = obj.REC.bestChs(1);
            SessionDir = obj.DIR.ephysDir;
            
            search = ['*CH' num2str(chanToUse) '*'];
            matchFile = dir(fullfile(SessionDir, search));
            fileName = [SessionDir matchFile(1).name];
            
            [data, timestamps, info] = load_open_ephys_data(fileName);
            Fs = info.header.sampleRate;
            
            [V_uV_data_full,nshifts] = shiftdim(data',-1);
            
            thisSegData = V_uV_data_full(:,:,:);
            thisSegData_s = timestamps(1:end) - timestamps(1);
            recordingDuration_s = thisSegData_s(end);
            
            
            %%
            fObj = filterData(Fs);
            
            fobj.filt.F=filterData(Fs);
            fobj.filt.F.downSamplingFactor=120; % original is 128 for 32k
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
            
            fobj.filt.Ripple=filterData(Fs);
            fobj.filt.Ripple.highPassCutoff=80;
            fobj.filt.Ripple.lowPassCutoff=300;
            fobj.filt.Ripple.filterDesign='butter';
            fobj.filt.Ripple=fobj.filt.Ripple.designBandPass;
            fobj.filt.Ripple.padding=true;
            
            fobj.filt.SW=filterData(Fs);
            fobj.filt.SW.highPassCutoff=8;
            fobj.filt.SW.lowPassCutoff=40;
            fobj.filt.SW.filterDesign='butter';
            fobj.filt.SW=fobj.filt.SW.designBandPass;
            fobj.filt.SW.padding=true;
            
            fobj.filt.FN =filterData(Fs);
            fobj.filt.FN.filterDesign='cheby1';
            fobj.filt.FN.padding=true;
            fobj.filt.FN=fobj.filt.FN.designNotch;
            
            %% For estimating scale
            
            rng(1);
            
            seg_s= 40;
            TOn=1:seg_s*Fs:(recordingDuration_s*Fs-seg_s*Fs);
            nTestSegments = round(numel(TOn)*.3);
            
            nCycles = numel(TOn);
            if nCycles >100
                nTestSegments  = 40;
            end
            
            pCycle=sort(randperm(nCycles,nTestSegments));
            %pCycle=TOn(1:nTestSegments);
            Mtest_ripple=cell(nTestSegments,1);
            Mtest_SW=cell(nTestSegments,1);
            smoothWin = 0.10*Fs;
            for i=1:numel(pCycle)
                
                
                thisROI = TOn(pCycle(i)):TOn(pCycle(i)+1);
                %thisROI = TOn((i)):TOn((i)+1);
                SegData = V_uV_data_full(:,:, thisROI);
                
                %DataSeg_HF = squeeze(fobj.filt.FH2.getFilteredData(DataSeg_BP));
                DataSeg_BP = fobj.filt.BP.getFilteredData(SegData);
                DataSeg_BPFL = fobj.filt.FL.getFilteredData(DataSeg_BP);
                
                DataSeg_ripple = squeeze(fobj.filt.Ripple.getFilteredData(SegData));
                DataSeg_SW = fobj.filt.SW.getFilteredData(DataSeg_BPFL);
                DataSeg_BPFL = squeeze(DataSeg_BPFL);
                %%
                %smoothWin = 0.05*Fs;
                %DataSeg_rect_HF = smooth(DataSeg_HF.^2, smoothWin);
                DataSeg_ripple_rms = rms(DataSeg_ripple, 2);
                DataSeg_ripple_rms_smooth =  smooth(DataSeg_ripple_rms, smoothWin);
                
                DataSeg_rect_ripple = smooth(DataSeg_ripple.^2, smoothWin);
                
                DataSeg_SW_rms = rms(squeeze(DataSeg_SW), 2);
                %DataSeg_SW_sq = squeeze(DataSeg_SW).^2;
                
                %DataSeg_BPLF = squeeze(DataSeg_BPFL);
                %DataSeg_SW_rms_smooth =  smooth(DataSeg_SW_rms, smoothWin);
                
                %Mtest_ripple{i} = DataSeg_ripple_rms_smooth;
                Mtest_ripple{i} = DataSeg_rect_ripple;
                
                Mtest_SW{i} = -DataSeg_BPFL;
                
                %{
                figure(80);clf
                subplot(6, 1, 1)
                plot(squeeze(SegData)); title('raw data')
                axis tight
                grid on
                
                subplot(6, 1, 2)
                plot(squeeze(DataSeg_ripple)); title('ripple')
                axis tight
                grid on
                
                subplot(6, 1, 3)
                plot(smooth(DataSeg_ripple_rms, smoothWin)); title('smooth ripple rms')
                hold on
                plot(DataSeg_rect_ripple); title('rectified ripple')
                  
                axis tight
                grid on
                
                std_ripple = std(smooth(DataSeg_ripple_rms, smoothWin));
                subplot(6, 1, 3)
                hold on
                line([0 numel(DataSeg_ripple_rms)], [std_ripple*3 std_ripple*3], 'color', 'r')
                line([0 numel(DataSeg_ripple_rms)], [std_ripple*4 std_ripple*4], 'color', 'b')
               
               subplot(6, 1, 4)
                plot(-DataSeg_BPFL) ; title('neg Bp LF')
                hold on
                std_bplf = std(DataSeg_BPFL)*2;
                th_bplf = median(DataSeg_BPFL)+iqr(DataSeg_BPFL)*2;
                %thr=median(DataSeg_SW_rms_smooth)+1*iqr(DataSeg_SW_rms_smooth);
                line([0 numel(DataSeg_ripple_rms)], [std_bplf std_bplf], 'color', 'r')
                line([0 numel(DataSeg_ripple_rms)], [150 150], 'color', 'b')
                axis tight
                
                grid on
                
                subplot(6, 1, 5)
                plot(DataSeg_SW_rms); title('SW rms')
                axis tight
                grid on
                %std_SW = std(smooth(DataSeg_SW_rms, smoothWin))*3;
                
%                 subplot(6, 1, 6)
%                 hold on
%                 %plot(-DataSeg_LF)
%                 plot(smooth(DataSeg_SW_rms_smooth, smoothWin))
%                 axis tight
%                 std_Swrms = std(DataSeg_SW_rms_smooth)*3;
%                 %thr=median(DataSeg_SW_rms_smooth)+1*iqr(DataSeg_SW_rms_smooth);
%                 line([0 numel(DataSeg_ripple_rms)], [std_Swrms std_Swrms], 'color', 'r')
%                 grid on
                  
                %pause
                %}
            end
            
            
            Mtest_ripple=cell2mat(Mtest_ripple);
            Mtest_SW=cell2mat(Mtest_SW);
            
            sortedMtest_ripple=sort(Mtest_ripple);
            sortedMtest_SW=sort(Mtest_SW);
            
            percentile4ScaleEstimation = 90;
            scaleEstimator_ripple=sortedMtest_ripple(round(percentile4ScaleEstimation/100*numel(sortedMtest_ripple)));
            
            scaleEstimator_sw=sortedMtest_SW(round(percentile4ScaleEstimation/100*numel(sortedMtest_SW)));
            
            figure; plot(sortedMtest_ripple); axis tight
            figure; plot(sortedMtest_SW); axis tight
            
            peakHeight_iqr = iqr(Mtest_ripple);
            
            
            ripple_Std = std(Mtest_ripple);
            means = mean(Mtest_ripple);
            medians = median(Mtest_ripple);
            
            thresh = means +3*ripple_Std;
            thresh = medians+2*ripple_Std;
            
            %%
            seg_s=20;
            TOn=1:seg_s*Fs:(recordingDuration_s*Fs-seg_s*Fs);
            overlapWin = 2*Fs;
            
            nCycles = numel(TOn);
            
            rcnt = 1;
            scnt = 1;
            
            templatePeaks = [];
            ripplePeaks = [];
            
            for i=1:nCycles-1
                
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
        
        function [obj] = detectSWRsOld_LF_first(obj, dataRecordingObj)
            
            %%
            doPlot = 1;
            
            chanToUse = obj.REC.bestChs(2);
            SessionDir = obj.Session.SessionDir;
            
            eval(['fileAppend = ''106_CH' num2str(chanToUse) '.continuous'';'])
            fileName = [SessionDir fileAppend];
            
            [data, timestamps, info] = load_open_ephys_data(fileName);
            Fs = info.header.sampleRate;
            
            [V_uV_data_full,nshifts] = shiftdim(data',-1);
            
            thisSegData = V_uV_data_full(:,:,:);
            thisSegData_s = timestamps(1:end) - timestamps(1);
            recordingDuration_s = thisSegData_s(end);
            
            
            %%
            fObj = filterData(Fs);
            
            fobj.filt.F=filterData(Fs);
            %fobj.filt.F.downSamplingFactor=120; % original is 128 for 32k
            fobj.filt.F.downSamplingFactor=120; % original is 128 for 32k
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
            
            fobj.filt.FN =filterData(Fs);
            fobj.filt.FN.filterDesign='cheby1';
            fobj.filt.FN.padding=true;
            fobj.filt.FN=fobj.filt.FN.designNotch;
            
            %% For estiamting scale
            nTestSegments = 40;
            percentile4ScaleEstimation = 20;
            
            rng(1);
            
            seg_s= 20;
            TOn=1:seg_s*Fs:(recordingDuration_s*Fs-seg_s*Fs);
            nCycles = numel(TOn);
            
            pCycle=sort(randperm(nCycles,nTestSegments));
            Mtest=cell(nTestSegments,1);
            tTest=cell(nTestSegments,1);
            for i=1:numel(pCycle)
                
                
                thisROI = TOn(pCycle(i)):TOn(pCycle(i)+1);
                SegData = V_uV_data_full(:,:, thisROI);
                
                DataSeg_BP = fobj.filt.BP.getFilteredData(SegData);
                DataSeg_HF = squeeze(fobj.filt.FH2.getFilteredData(DataSeg_BP));
                %%
                smoothWin = 0.10*Fs;
                DataSeg_rect_HF = smooth(DataSeg_HF.^2, smoothWin);
                
                Mtest{i} = DataSeg_rect_HF;
                
            end
            Mtest=cell2mat(Mtest);
            
            sortedMtest=sort(Mtest);
            peakHeight_iqr = 3*iqr(sortedMtest);
            
            clear('Mtest', 'sortedMtest')
            
            %%
            seg_s=40;
            TOn=1:seg_s*Fs:(recordingDuration_s*Fs-seg_s*Fs);
            overlapWin = 2*Fs;
            
            nCycles = numel(TOn);
            
            cnt = 1;
            cnnt = 1;
            
            templatePeaks = [];
            ripplePeaks = [];
            
            for i=1:nCycles-1
                figure(300); clf
                if i ==1
                    thisROI = TOn(i):TOn(i+1);
                else
                    thisROI = TOn(i)-overlapWin:TOn(i+1);
                end
                
                SegData = V_uV_data_full(:,:, thisROI);
                SegData_s = thisSegData_s(thisROI);
                
                DataSeg_BP = fobj.filt.BP.getFilteredData(SegData);
                DataSeg_FNotch = squeeze(fobj.filt.FN.getFilteredData(DataSeg_BP));
                DataSeg_LF = squeeze(fobj.filt.FL.getFilteredData(DataSeg_BP));
                DataSeg_HF = squeeze(fobj.filt.FH2.getFilteredData(DataSeg_BP));
                Data_SegData = squeeze(SegData);
                %%
                smoothWin = 0.10*Fs;
                DataSeg_LF_neg = -DataSeg_LF;
                %figure; plot(DataSeg_LF_neg)
                DataSeg_rect_HF = smooth(DataSeg_HF.^2, smoothWin);
                %baseline = mean(DataSeg_rect_HF)*2;
                
                %figure; plot(SegData_s, DataSeg_rect_HF); axis tight
                
                %% Find Peaks
                interPeakDistance = 0.2*Fs;
                minPeakWidth = 0.05*Fs;
                minPeakHeight = 100;
                %minPeakHeight = peakHeight_iqr;
                minPeakProminence = 30;
                
                %[peakH,peakTime_Fs, peakW, peakP]=findpeaks(DataSeg_rect_HF,'MinPeakHeight',minPeakHeight, 'MinPeakWidth', minPeakWidth, 'MinPeakProminence',minPeakProminence, 'MinPeakDistance', interPeakDistance, 'WidthReference','halfprom'); %For HF
                [peakH,peakTime_Fs, peakW, peakP]=findpeaks(DataSeg_LF_neg,'MinPeakHeight',minPeakHeight, 'MinPeakWidth', minPeakWidth, 'MinPeakProminence',minPeakProminence, 'MinPeakDistance', interPeakDistance, 'WidthReference','halfprom'); %For HF
                
                %%
                
                absPeakTime_s =  SegData_s(peakTime_Fs);
                asPeakTime_fs = peakTime_Fs+thisROI(1)-1;
                % relPeakTime_s  = peakTime_Fs;
                
                %%
                if doPlot
                    %{
                                        figure(100);clf;
                    
                                        subplot(3,1,1)
                                        plot(SegData_s, DataSeg_FNotch, 'k'); title( ['Raw']);
                                        axis tight
                                        ylim([-300 300])
                    
                                        subplot(3, 1, 2)
                                        plot(SegData_s, DataSeg_HF, 'k'); title( ['Ripple']);
                                        axis tight
                                        ylim([-80 80])
                    
                                        subplot(3, 1, 3)
                                        plot(SegData_s, smooth(DataSeg_rect_HF, .05*Fs), 'k'); title( ['Ripple Rectified']);
                                        axis tight
                                        ylim([0 400])
                                        hold on
                                        plot(SegData_s(peakTime_Fs), 200, 'rv')
                    %}
                    
                    figure(300);
                    
                    subplot(5, 1, 1)
                    plot(SegData_s, Data_SegData); title( ['Raw Voltage']);
                    hold on
                    %plot(SegData_s(peakTime_Fs(q)), 0, 'r*')
                    axis tight
                    
                    subplot(5, 1, 2)
                    plot(SegData_s, DataSeg_FNotch); title( ['Notch Filter']);
                    hold on
                    %plot(SegData_s(peakTime_Fs(q)), 0, 'r*')
                    axis tight
                    
                    subplot(5, 1, 3)
                    plot(SegData_s, DataSeg_LF); title( ['LF']);
                    axis tight
                    
                    subplot(5, 1,4)
                    plot(SegData_s, DataSeg_rect_HF); title( ['HF Rectified']);
                    hold on;
                    %plot(SegData_s(peakTime_Fs(q)), DataSeg_rect_HF(peakTime_Fs(q)), 'r*');
                    axis tight
                    ylim([0 500])
                    
                    subplot(5,1, 5)
                    plot(SegData_s, DataSeg_HF); title( ['HF Rectified']);
                    hold on;
                    %plot(SegData_s(peakTime_Fs(q)), DataSeg_HF(peakTime_Fs(q)), 'rv');
                    axis tight
                    
                end
                
                WinSizeL = 0.15*Fs;
                WinSizeR = 0.15*Fs;
                
                for q =1:numel(peakTime_Fs)
                    
                    if doPlot
                        figure(300);
                        
                        subplot(5, 1, 1)
                        %plot(SegData_s, Data_SegData); title( ['Raw Voltage']);
                        hold on
                        plot(SegData_s(peakTime_Fs(q)), 0, 'r*')
                        axis tight
                        
                        subplot(5, 1, 2)
                        %plot(SegData_s, DataSeg_FNotch); title( ['Notch Filter']);
                        hold on
                        plot(SegData_s(peakTime_Fs(q)), 0, 'r*')
                        axis tight
                        
                        subplot(5, 1, 3)
                        plot(SegData_s, DataSeg_LF); title( ['LF']);
                        axis tight
                        
                        subplot(5, 1,4)
                        %plot(SegData_s, DataSeg_rect_HF); title( ['HF Rectified']);
                        hold on;
                        plot(SegData_s(peakTime_Fs(q)), DataSeg_rect_HF(peakTime_Fs(q)), 'r*');
                        axis tight
                        ylim([0 500])
                        
                        subplot(5,1, 5)
                        %plot(SegData_s, DataSeg_HF); title( ['HF Rectified']);
                        hold on;
                        plot(SegData_s(peakTime_Fs(q)), DataSeg_HF(peakTime_Fs(q)), 'rv');
                        axis tight
                        
                        
                    end
                    
                    winROI = peakTime_Fs(q)-WinSizeL:peakTime_Fs(q)+WinSizeR;
                    
                    if winROI(end) > size(SegData_s, 1) || winROI(1) <0
                        disp('Win is too big/small')
                        continue
                    else
                        
                        %LFWin = -DataSeg_LF(winROI);
                        LFWin = DataSeg_rect_HF(winROI);
                        
                        minPeakWidth_LF = 0.030*Fs;
                        %minPeakHeight_LF = 150;
                        %minPeakProminence = 195;
                        minPeakHeight_LF = 20;
                        minPeakProminence = 100;
                        
                        [peakH_LF,peakTime_Fs_LF, peakW_LF, peakP_LF]=findpeaks(LFWin,'MinPeakHeight',minPeakHeight_LF, 'MinPeakProminence',minPeakProminence, 'MinPeakWidth', minPeakWidth_LF, 'WidthReference','halfprom'); %For HF
                        % prominence is realted to window size
                        
                        %% Test
                        %{
                            figure(104);clf
                            winROI_s = SegData_s(winROI);
                            plot(winROI_s, smooth(LFWin)); axis tight
                            hold on
                            plot(winROI_s(peakTime_Fs_LF), LFWin(peakTime_Fs_LF), '*')
                        %}
                        %%
                        disp('')
                        
                        if numel(peakTime_Fs_LF) == 1
                            
                            templatePeaks.peakH(cnt) = peakH(q);
                            templatePeaks.asPeakTime_fs(cnt) = asPeakTime_fs(q);
                            templatePeaks.absPeakTime_s(cnt) = absPeakTime_s(q);
                            templatePeaks.peakW(cnt) = peakW(q);
                            templatePeaks.peakP(cnt) = peakP(q);
                            
                            absPeakTime_Fs_LF = (peakTime_Fs_LF + peakTime_Fs(q)-WinSizeL) +thisROI(1)-1; % this is realtive to both the LF window and the larger ROI
                            
                            templatePeaks.peakH_LF(cnt) = peakH_LF;
                            templatePeaks.absPeakTime_Fs_LF(cnt) = absPeakTime_Fs_LF;
                            templatePeaks.peakW_LF(cnt) = peakW_LF;
                            templatePeaks.peakP_LF(cnt) = peakP_LF;
                            
                            cnt = cnt+1;
                            
                            
                            %% Test
                            % testROI = asPeakTime_fs(q)-0.2*Fs:asPeakTime_fs(q)+0.2*Fs;% THis is the HF, it will be offset from the peak of the SHW
                            % figure; plot(SegData_s(testROI), DataSeg_rect_HF(testROI)); axis tight
                            % figure; plot(SegData_s(testROI), DataSeg_FNotch(testROI)); axis tight
                            %line([ thisSegData_s(asPeakTime_fs(q)) thisSegData_s(asPeakTime_fs(q))], [-1000 500]);
                            
                            %testROI = absPeakTime_Fs_LF-(0.2*Fs):absPeakTime_Fs_LF+(0.2*Fs);
                            %figure(200); plot(SegData_s(testROI),  DataSeg_LF(testROI), 'k'); axis tight
                            %hold on; plot(SegData_s(testROI), DataSeg_FNotch(testROI)); axis tight
                            %line([ thisSegData_s(absPeakTime_Fs_LF(q)) thisSegData_s(absPeakTime_Fs_LF(q))], [-1000 500]);
                            
                            
                        elseif isempty(peakTime_Fs_LF)
                            if doPlot
                                figure(300);
                                
                                subplot(5,1, 5)
                                hold on;
                                plot(SegData_s(peakTime_Fs(q)), DataSeg_HF(peakTime_Fs(q)), 'kv');
                                
                                subplot(5, 1,4)
                                hold on;
                                plot(SegData_s(peakTime_Fs(q)), DataSeg_rect_HF(peakTime_Fs(q)), 'k*');
                                
                                subplot(5, 1, 1)
                                hold on
                                plot(SegData_s(peakTime_Fs(q)), 0, 'k*')
                                
                                subplot(5, 1, 2)
                                hold on
                                plot(SegData_s(peakTime_Fs(q)), 0, 'k*')
                            end
                            
                            ripplePeaks.peakH(cnnt) = peakH(q);
                            ripplePeaks.asPeakTime_fs(cnnt) = asPeakTime_fs(q);
                            ripplePeaks.absPeakTime_s(cnnt) = absPeakTime_s(q);
                            ripplePeaks.peakW(cnnt) = peakW(q);
                            ripplePeaks.peakP(cnnt) = peakP(q);
                            
                            cnnt = cnnt+1;
                            
                            continue
                        else % two detections
                            
                            templatePeaks.peakH(cnt) = peakH(q);
                            templatePeaks.asPeakTime_fs(cnt) = asPeakTime_fs(q);
                            templatePeaks.absPeakTime_s(cnt) = absPeakTime_s(q);
                            templatePeaks.peakW(cnt) = peakW(q);
                            templatePeaks.peakP(cnt) = peakP(q);
                            
                            %choose HighestPeak
                            [pmax, maxInd] = max(peakH_LF);
                            
                            absPeakTime_Fs_LF = (peakTime_Fs_LF(maxInd) + peakTime_Fs(q)-WinSizeL) +thisROI(1)-1; % this is realtive to both the LF window and the larger ROI
                            
                            relPeakTime_Fs_LF = (peakTime_Fs_LF(maxInd) + peakTime_Fs(q)-WinSizeL); % for plotting
                            
                            templatePeaks.peakH_LF(cnt) = peakH_LF(maxInd);
                            templatePeaks.absPeakTime_Fs_LF(cnt) = absPeakTime_Fs_LF;
                            templatePeaks.peakW_LF(cnt) = peakW_LF(maxInd);
                            templatePeaks.peakP_LF(cnt) = peakP_LF(maxInd);
                            
                            cnt = cnt+1;
                            
                            if doPlot
                                figure(300);
                                
                                subplot(5,1, 5)
                                hold on;
                                plot(SegData_s(relPeakTime_Fs_LF), DataSeg_HF(peakTime_Fs(q)), 'bv');
                                
                                subplot(5, 1,4)
                                hold on;
                                plot(SegData_s(relPeakTime_Fs_LF), DataSeg_rect_HF(peakTime_Fs(q)), 'b*');
                                
                                subplot(5, 1, 1)
                                hold on
                                plot(SegData_s(relPeakTime_Fs_LF), 0, 'b*')
                                
                                subplot(5, 1, 2)
                                hold on
                                plot(SegData_s(relPeakTime_Fs_LF), 0, 'b*')
                            end
                            continue
                            
                        end
                    end
                    
                end
                
                PlotDir = [obj.DIR.birdDir 'Plots' obj.DIR.dirD obj.DIR.dirName '_plots' obj.DIR.dirD];
                if exist(PlotDir, 'dir') == 0
                    mkdir(PlotDir);
                    disp(['Created: '  PlotDir])
                end
                plot_filename = [PlotDir 'SWR_Detections-Plots' sprintf('%03d', i)];
                
                plotpos = [0 0 25 15];
                figure(300);
                print_in_A4(0, plot_filename, '-djpeg', 0, plotpos);
                
                
                
            end
            
            DetectionSaveName = [PlotDir '-Detections'];
            save(DetectionSaveName, 'templatePeaks', 'ripplePeaks');
            
            disp(['Saved:' DetectionSaveName ])
            
        end
        
        function [] = plotPowerSpectrum(obj)
         chanToUse = obj.REC.bestChs(1);
            SessionDir = obj.DIR.ephysDir;
            
            search = ['*CH' num2str(chanToUse) '*'];
            matchFile = dir(fullfile(SessionDir, search));
            fileName = [SessionDir matchFile.name];
            
            [data, timestamps, info] = load_open_ephys_data(fileName);
            
            %%
            Fs = info.header.sampleRate;
            samples = numel(data);
            totalTime = samples/Fs;
            
            batchDuration_s = 30; % 3 mi
            batchDuration_samp = batchDuration_s*Fs;
            
            tOn_s = 1:batchDuration_s:totalTime;
            tOn_samp = tOn_s*Fs;
            nBatches = numel(tOn_samp);
            
            obj.Plotting.titleTxt = [obj.INFO.Name ' | ' obj.Session.time];
            obj.Plotting.saveTxt = [obj.INFO.Name '_' obj.Session.time];
            
            
            %% Filters
            
            fObj = filterData(Fs);
            
            fobj.filt.F=filterData(Fs);
            %fobj.filt.F.downSamplingFactor=120; % original is 128 for 32k
            fobj.filt.F.downSamplingFactor=120; % original is 128 for 32k
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
            
            fobj.filt.FN =filterData(Fs);
            fobj.filt.FN.filterDesign='cheby1';
            fobj.filt.FN.padding=true;
            fobj.filt.FN=fobj.filt.FN.designNotch;
            
            %% Raw Data
            
            
            
            %% Get Filtered Data
            
            %DataSeg_FN = fobj.filt.FN.getFilteredData(thisSegData);
            %DataSeg_FL = fobj.filt.FL.getFilteredData(thisSegData);
            %DataSeg_FH2 = fobj.filt.FH2.getFilteredData(thisSegData);
            inds = find(tOn_samp > 1.5*3600*Fs);
            for b = inds
                b
                if b == nBatches
                    thisData = data(tOn_samp(b):samples);
                else
                    thisData = data(tOn_samp(b):tOn_samp(b)+batchDuration_samp);
                end
                
                [V_uV_data_full,nshifts] = shiftdim(thisData',-1);
                
                thisSegData = V_uV_data_full(:,:,:);
                
                [DataSeg_Notch, ~] = fobj.filt.FN.getFilteredData(thisSegData); % t_DS is in ms
                [DataSeg_BP, ~] = fobj.filt.BP.getFilteredData(thisSegData); % t_DS is in ms
                [DataSeg_F, t_DS] = fobj.filt.F.getFilteredData(DataSeg_BP); % t_DS is in ms
                
                t_DS_s = t_DS/1000;
                
                
                %%
                
                %% Raw Data  - Parameters from data=getDelta2BetaRatio(obj,varargin)
                
                % This is all in ms
                %             addParameter(parseObj,'movLongWin',1000*60*30,@isnumeric); %max freq. to examine
                %             addParameter(parseObj,'movWin',10000,@isnumeric);
                %             addParameter(parseObj,'movOLWin',9000,@isnumeric);
                %             addParameter(parseObj,'segmentWelch',1000,@isnumeric);
                %             addParameter(parseObj,'dftPointsWelch',2^10,@isnumeric);
                %             addParameter(parseObj,'OLWelch',0.5);
                %
                
                movWin_Var = 10; % 10 s
                movOLWin_Var = 9; % 9 s
                segmentWelch = 1;
                OLWelch = 0.5;
                dftPointsWelch =  2^10;
                
                segmentWelchSamples = round(segmentWelch*fobj.filt.FFs);
                samplesOLWelch = round(segmentWelchSamples*OLWelch);
                
                movWinSamples=round(movWin_Var*fobj.filt.FFs);%obj.filt.FFs in Hz, movWin in samples
                movOLWinSamples=round(movOLWin_Var*fobj.filt.FFs);
                
                % run welch once to get frequencies for every bin (f) determine frequency bands
                [~,f] = pwelch(randn(1,movWinSamples),segmentWelchSamples,samplesOLWelch,dftPointsWelch,fobj.filt.FFs);
                
                %%
                tmp_V_DS = buffer(DataSeg_F,movWinSamples,movOLWinSamples,'nodelay');
                pValid=all(~isnan(tmp_V_DS));
                
                [pxx,f] = pwelch(tmp_V_DS(:,pValid),segmentWelchSamples,samplesOLWelch,dftPointsWelch,fobj.filt.FFs);
                figure(342);clf
                subplot(2, 1, 1)
                plot(t_DS, squeeze(DataSeg_F))
                axis tight
                
                subplot(2, 1, 2)
                plot(10*log10(pxx))
                xlim([0 200])
                pause
            end
        end
        
        function [obj] = plotDBRatioWithData(obj)
            
            
            chanToUse = obj.REC.bestChs(1);
            SessionDir = obj.DIR.ephysDir;
            
            search = ['*CH' num2str(chanToUse) '*'];
            matchFile = dir(fullfile(SessionDir, search));
            fileName = [SessionDir matchFile.name];
            
            [data, timestamps, info] = load_open_ephys_data(fileName);
            
            %%
            Fs = info.header.sampleRate;
            samples = numel(data);
            totalTime = samples/Fs;
            
            batchDuration_s = 300; % 3 mi
            batchDuration_samp = batchDuration_s*Fs;
            
            tOn_s = 1:batchDuration_s:totalTime;
            tOn_samp = tOn_s*Fs;
            nBatches = numel(tOn_samp);
            
            obj.Plotting.titleTxt = [obj.INFO.Name ' | ' obj.Session.time];
            obj.Plotting.saveTxt = [obj.INFO.Name '_' obj.Session.time];
            
            
            %% Filters
            
            fObj = filterData(Fs);
            
            fobj.filt.F=filterData(Fs);
            %fobj.filt.F.downSamplingFactor=120; % original is 128 for 32k
            fobj.filt.F.downSamplingFactor=120; % original is 128 for 32k
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
            
            fobj.filt.FN =filterData(Fs);
            fobj.filt.FN.filterDesign='cheby1';
            fobj.filt.FN.padding=true;
            fobj.filt.FN=fobj.filt.FN.designNotch;
            
            %% Raw Data
            
            
            
            %% Get Filtered Data
            
            %DataSeg_FN = fobj.filt.FN.getFilteredData(thisSegData);
            %DataSeg_FL = fobj.filt.FL.getFilteredData(thisSegData);
            %DataSeg_FH2 = fobj.filt.FH2.getFilteredData(thisSegData);
            inds = find(tOn_samp > 2.5*3600*Fs);
            for b = 57:154
                b
                if b == nBatches
                    thisData = data(tOn_samp(b):samples);
                else
                    thisData = data(tOn_samp(b):tOn_samp(b)+batchDuration_samp);
                end
                
                [V_uV_data_full,nshifts] = shiftdim(thisData',-1);
                
                d.V_uV_data_full = V_uV_data_full;
                d.tOn = tOn_samp(b);
                d.batchDuration_samp = batchDuration_samp;
                PlotDir = [obj.DIR.plotDir]; 
                plot_filename = [PlotDir 'data' sprintf('%02d',b) '.mat'];
                save(plot_filename, 'd')
                
                thisSegData = V_uV_data_full(:,:,:);
                
                [DataSeg_Notch, ~] = fobj.filt.FN.getFilteredData(thisSegData); % t_DS is in ms
                [DataSeg_BP, ~] = fobj.filt.BP.getFilteredData(thisSegData); % t_DS is in ms
                [DataSeg_F, t_DS] = fobj.filt.F.getFilteredData(DataSeg_BP); % t_DS is in ms
                
                t_DS_s = t_DS/1000;
                
                
                %%
                
                %% Raw Data  - Parameters from data=getDelta2BetaRatio(obj,varargin)
                
                % This is all in ms
                %             addParameter(parseObj,'movLongWin',1000*60*30,@isnumeric); %max freq. to examine
                %             addParameter(parseObj,'movWin',10000,@isnumeric);
                %             addParameter(parseObj,'movOLWin',9000,@isnumeric);
                %             addParameter(parseObj,'segmentWelch',1000,@isnumeric);
                %             addParameter(parseObj,'dftPointsWelch',2^10,@isnumeric);
                %             addParameter(parseObj,'OLWelch',0.5);
                %
                %reductionFactor = .15; % No reduction
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
                
                %                  feats_(n, 1    :c  ) = bandpower(x,fs,[.5 4])./bandp; % delta
                %     feats_(n, c+1  :2*c) = bandpower(x,fs,[4 8])./bandp; % theta
                %     feats_(n, 2*c+1:3*c) = bandpower(x,fs,[8 12])./bandp; % alpha
                %     feats_(n, 3*c+1:4*c) = bandpower(x,fs,[12 30])./bandp; % beta
                %     feats_(n, 4*c+1:5*c) = bandpower(x,fs,[30 100])./bandp; % gamma
                %
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
                
                highBandLowCutoff = 25;
                highBandHighCutoff = 180;
                
                lowBandLowCutoff = 1;
                lowBandHighCutoff = 25;
                
                pfDeltaBand=find(f>=deltaBandLowCutoff & f<deltaBandHighCutoff);
                pfThetaBand=find(f>=thetaBandLowCutoff & f<thetaBandHighCutoff);
                pfAlphaBand=find(f>=alphaBandLowCutoff & f<alphaBandHighCutoff);
                pfBetaBand=find(f>=betaBandLowCutoff & f<betaBandHighCutoff);
                pfGammBand=find(f>=gammaBandLowCutoff & f<gammaBandHighCutoff);
                
                pfLowBand=find(f>=lowBandLowCutoff & f<lowBandHighCutoff);
                pfHighBand=find(f>=highBandLowCutoff & f<highBandHighCutoff);
                
                %pfLowBand=find(f<=deltaBandCutoff);
                %pfHighBand=find(f>=betaBandLowCutoff & f<betaBandHighCutoff);
                %pfHighBand_alpha=find(f>=alphaThetaBandLowCutoff & f<alphaThetaBandHighCutoff);
                
                %%
                tmp_V_DS = buffer(DataSeg_F,movWinSamples,movOLWinSamples,'nodelay');
                pValid=all(~isnan(tmp_V_DS));
                
                [pxx,f] = pwelch(tmp_V_DS(:,pValid),segmentWelchSamples,samplesOLWelch,dftPointsWelch,fobj.filt.FFs);
                
                
                bla = randperm(size(pxx, 2));
                sel = bla(1:20);
                
                figure(103);clf
                subsampl = pxx(:, 1:20);
                plot(10*log10(subsampl), 'color', [.5 .5 .5])
                xlim([0 200])
                means = mean(subsampl, 2);
                hold on
                plot(10*log10(means), 'k', 'linewidth', 2)
                ylabel('dB')
                xlabel('Freq. (Hz)')
                
                plotpos = [0 0 10 8];
                
                PlotDir = [obj.DIR.plotDir];
                
                plot_filename = [PlotDir 'powerSpec_' sprintf('%02d',b)];
                print_in_A4(0, plot_filename, '-djpeg', 0, plotpos);
                print_in_A4(0, plot_filename, '-depsc', 0, plotpos);
                
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
                
                lowHighRatioAll = zeros(1,numel(pValid));
                lowHighRatioAll (pValid)=(mean(pxx(pfLowBand,:))./mean(pxx(pfHighBand,:)))';
                
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
                
                lowAll=zeros(1,numel(pValid));
                lowAll(pValid)=mean(pxx(pfLowBand,:))';
                
                highAll=zeros(1,numel(pValid));
                highAll(pValid)=mean(pxx(pfHighBand,:))';
                
                % Pool all data ratios
                bufferedDeltaBetaRatio=deltaBetaRatioAll;
                
                bufferedDelta=deltaAll;
                bufferedBeta=betaAll;
                
                allV_DS = squeeze(DataSeg_F);
                
                %%
                sizestr = ['movWin =' num2str(movWin_Var) 's; movOLWin = ' num2str(movOLWin_Var) ' s'];
                Deltacolor = [0 50 150]/255;
                Thetacolor = [0 200 150]/255;
                Alphacolor = [0 150 150]/255;
                Betacolor = [150 50 0]/255;
                Gammacolor = [100 150 150]/255;
                
                deltaAll_norm = deltaAll./(max(deltaAll));
                thetaAll_norm = thetaAll./(max(thetaAll));
                alphaAll_norm = alphaAll./(max(alphaAll));
                betaAll_norm = betaAll./(max(betaAll));
                gammaAll_norm = gammaAll./(max(gammaAll));
                
                lowAll_norm = lowAll./(max(lowAll));
                highAll_norm = highAll./(max(highAll));
                %%
                figh3 = figure(302); clf
                subplot(3, 1, 1)
                plot(smooth(deltaAll_norm), 'color', 'r', 'linewidth', 1)
                hold on
                %plot(smooth(thetaAll_norm), 'color', Thetacolor, 'linewidth', 1)
                %plot(smooth(alphaAll_norm), 'color', Alphacolor, 'linewidth', 1)
                %plot(smooth(betaAll_norm), 'color', Betacolor, 'linewidth', 1)
                plot(smooth(gammaAll_norm), 'color', 'b', 'linewidth', 1)
                plot(smooth(lowAll_norm), 'color', 'k', 'linewidth', 1)
                 plot(smooth(highAll_norm), 'color', Alphacolor, 'linewidth', 1)
                
                axis tight
                %                 legTxt = [{['Delta: ' num2str(deltaBandLowCutoff) '-' num2str(deltaBandHighCutoff) ' Hz']},...
                %                             {['Theta: ' num2str(thetaBandLowCutoff) '-' num2str(thetaBandHighCutoff) ' Hz']},...
                %                             {['Alpha: ' num2str(alphaBandLowCutoff) '-' num2str(alphaBandHighCutoff) ' Hz']},...
                %                             {['Beta: ' num2str(betaBandLowCutoff) '-' num2str(betaBandHighCutoff) ' Hz']},...
                %                             {['Gamma: ' num2str(gammaBandLowCutoff) '-' num2str(gammaBandHighCutoff) ' Hz']}];
                %
                legTxt = [{['Delta: ' num2str(deltaBandLowCutoff) '-' num2str(deltaBandHighCutoff) ' Hz']},...
                    {['Gamma: ' num2str(gammaBandLowCutoff) '-' num2str(gammaBandHighCutoff) ' Hz']},...
                {['Low: ' num2str(lowBandLowCutoff) '-' num2str(lowBandHighCutoff) ' Hz']},...
                {['High: ' num2str(highBandLowCutoff) '-' num2str(highBandHighCutoff) ' Hz']}];
                
                legend(legTxt)
                
                subplot(3, 1, 2)
                plot(t_DS_s, squeeze(DataSeg_F), 'k')
                axis tight
                title('V_BP_DS')
                xlabel('Time [s]')
                axis tight
                ylim([-500 500])
                
                deltaThetaRatioAll_norm = deltaThetaRatioAll./(max(max(deltaThetaRatioAll)));
                deltaAlphaRatioAll_norm = deltaAlphRatioAll./(max(max(deltaAlphRatioAll)));
                deltaBetaRatioAll_norm = deltaBetaRatioAll./(max(max(deltaBetaRatioAll)));
                deltaGammaRatioAll_norm = deltaGammaRatioAll./(max(max(deltaGammaRatioAll)));
                betaGammaRatioAll_norm = betaGammaRatioAll./(max(max(betaGammaRatioAll)));
                thetaGammaRatioAll_norm = thetaGammaRatioAll./(max(max(thetaGammaRatioAll)));
                lowHighRatioAll_norm = lowHighRatioAll./(max(max(lowHighRatioAll)));
                
                subplot(3, 1, 3)
                axis tight
                hold on
                % plot(smooth(deltaThetaRatioAll_norm, 5), 'linewidth', 1)
                % plot(smooth(deltaAlphaRatioAll_norm, 5), 'linewidth', 1)
                %plot(smooth(deltaBetaRatioAll_norm, 5), 'linewidth', 1)
                plot(smooth(deltaGammaRatioAll_norm, 5), 'linewidth', 1)
                plot(smooth(lowHighRatioAll_norm, 5), 'linewidth', 1)
                %plot(smooth(betaGammaRatioAll_norm, 5), 'linewidth', 1)
                %plot(smooth(thetaGammaRatioAll_norm, 5), 'linewidth', 1)
                title(['Freq Ratios | ' sizestr ])
                %                 legTxt = [{'Delta/Theta Ratio'},...
                %                           {'Delta/Alpha Ratio'},...
                %                           {'Delta/Beta Ratio'},...
                %                           {'Delta/Gamma Ratio'},...
                %                          {'Beta/Gamma Ratio'},...
                %                      {'Theta/Gamma Ratio'}];
                
                legTxt = [{'Delta/Gamma Ratio'}, {'Low/High Ratio'}];
                legend(legTxt)
                
                %set(gca, 'xtick', [])
                axis tight
                % xlim([0 2500])
                disp('')
                pause
            end
            
            %%
            plotpos = [0 0 30 15];
            
            PlotDir = [obj.DIR.plotDir];
            
            plot_filename = [PlotDir 'DB_Ratio_seg_' sprintf('%02d',b)];
            print_in_A4(0, plot_filename, '-djpeg', 0, plotpos);
            print_in_A4(0, plot_filename, '-depsc', 0, plotpos);
            
            
            
            
            
            
            
            
            
            
            
            %%
            
            
            figh4 = figure(400); clf
            subplot(2, 1, 1)
            
            plot(t_DS_s, squeeze(DataSeg_F), 'k')
            axis tight
            title('V_BP_DS')
            xlabel('Time [s]')
            axis tight
            ylim([-4000 4000])
            %xlim([0 125000])
            
            subplot(2, 1, 2)
            deltaBetaRatioAll_norm = deltaBetaRatioAll./(max(max(deltaBetaRatioAll)));
            deltaalphaRatioAll_norm = deltaAlphRatioAll./(max(max(deltaAlphRatioAll)));
            axis tight
            hold on
            %plot(smooth(deltaBetaRatioAll_norm, 5), 'linewidth', 1)
            hold on
            plot(smooth(deltaalphaRatioAll_norm, 5), 'linewidth', 1)
            title(['Delta/Beta Ratio | ' sizestr ])
            %legTxt = [{'Delta/Beta Ratio'}, {'Delta/AlphaTheta Ratio'}];
            %legend(legTxt{2})
            
            
            plotpos = [0 0 30 15];
            PlotDir = [obj.DIR.plotDir];
            
            plot_filename = [PlotDir 'DB_Ratio_seg_Large' sprintf('%02d',b)];
            print_in_A4(0, plot_filename, '-depsc', 0, plotpos);
            print_in_A4(0, plot_filename, '-djpeg', 0, plotpos);
            
            
            
        end
        
        
        function [obj] = plotDBRatioMatrix(obj)
            
            
            chanToUse = obj.REC.bestChs(1);
            SessionDir = obj.DIR.ephysDir;
            
            eval(['fileAppend = ''106_CH' num2str(chanToUse) '.continuous'';'])
            %eval(['fileAppend = ''100_CH' num2str(chanToUse) '.continuous'';'])
            fileName = [SessionDir fileAppend];
            
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
            
            obj.Plotting.titleTxt = [obj.INFO.Name ' | ' obj.Session.time];
            obj.Plotting.saveTxt = [obj.INFO.Name '_' obj.Session.time];
            
            %% Filters
            fObj = filterData(Fs);
            
            fobj.filt.F=filterData(Fs);
            %fobj.filt.F.downSamplingFactor=120; % original is 128 for 32k
            fobj.filt.F.downSamplingFactor=120; % original is 128 for 32k
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
            
            fobj.filt.FN =filterData(Fs);
            fobj.filt.FN.filterDesign='cheby1';
            fobj.filt.FN.padding=true;
            fobj.filt.FN=fobj.filt.FN.designNotch;
            
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
                
                [DataSeg_Notch, ~] = fobj.filt.FN.getFilteredData(thisSegData); % t_DS is in ms
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
                %imagesc(dataToPlot(2:29, :), [0 1200])
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
                title([obj.Session.time ' | ' titletxt])
                colorbar
                %%
                plotpos = [0 0 25 15];
                PlotDir = [obj.DIR.plotDir];
                if exist(PlotDir, 'dir') == 0
                    mkdir(PlotDir);
                    disp(['Created: '  PlotDir])
                end
                
                plot_filename = [PlotDir 'DBMatrix_' savenametxt '-' obj.Session.Date '-' obj.Session.time];
                print_in_A4(0, plot_filename, '-djpeg', 0, plotpos);
                print_in_A4(0, plot_filename, '-depsc', 0, plotpos);
            end
            
        end
        
        function [] = detectSWR_w_NEO(obj)
            
            
            chanToUse = obj.REC.bestChs(1);
            SessionDir = obj.Session.SessionDir;
            
            eval(['fileAppend = ''106_CH' num2str(chanToUse) '.continuous'';'])
            fileName = [SessionDir fileAppend];
            
            [data, timestamps, info] = load_open_ephys_data(fileName);
            Fs = info.header.sampleRate;
            %
            %             chnl_order=[5     4     6     3     9    16    8    1    11    14    12    13    10    15     7     2];  %%%%%%%%%%%%% recording channels with their actual location in order
            %             % this is the mapping of channels: [5     4     6     3     9    16     8  1    11    14    12    13    10    15     7     2], ...
            %             % from most superficial to deepest
            %             save_dir='D:\Janie\ZF-60-88\zf-60-88-CSD_SPWtimes_plots';  % directory to save results
            %             fs=30000; %%%%%%%%%%%%%%%% sampling rate
            %
            %             % loading EEG channels
            %             kk=1; % loop variable for loading channels
            %             for chn = chnl_order
            %                 filename =[selpath '\' '100_CH' num2str(chn) '.continuous'];
            %                 [eeg(:,kk),~, ~] = load_open_ephys_data(filename);     kk=kk+1;
            %             end
            % for time stamp
            %[~,time, ~] = load_open_ephys_data(filename);
            time=timestamps-timestamps(1);
            %disp(['Data len: ' num2str(max(time/60)) ' min' ])
            fparts=split(fileName,'\'); % extracting file name from full path name
            %N=length(chnl_order); % number of electrode for further frequent use
            
            %% downsampling for SW and Ripples detection, fromm 30000 to 3000
            signal_raw=downsample(data,10);
            t_signal=downsample(time,10);
            fs_=Fs/10;
            
            % filtering for SWR and figures
            % filtering for sharp wave:
            ShFilt = designfilt('bandpassiir','FilterOrder',2, 'HalfPowerFrequency1',1,'HalfPowerFrequency2',40, 'SampleRate',fs_);
            spwsig=filtfilt(ShFilt,signal_raw);
            % for ripples
            RippFilt = designfilt('bandpassiir','FilterOrder',2, 'HalfPowerFrequency1',40,'HalfPowerFrequency2',300, 'SampleRate',fs_);
            RippSig=filtfilt(RippFilt,signal_raw);
            
            %% LFP (<100Hz) plot of all channels
            % preparation for plot
            %set(0,'units','pixels');
            %Obtains this pixel information
            %pixls = get(0,'screensize');
            %figure('Position', pixls);
            
            t0=1; % 18160;
            plot_time=[0 30.01];
            tlim=t0+plot_time;
            t_lim=tlim(1)*fs_:tlim(2)*fs_;
            tt=time(t_lim);
            %for chnl=1:N
            figure(100); clf
            N=1;
            for chnl=1
                x=spwsig(t_lim,chnl);
                %plot(t_signal(t_lim),x-500*(chnl-1),'color',[160 chnl*255/N 255-chnl*255/N]/255); % color coded based on channel
                plot(t_signal(t_lim),x-500*(chnl-1),'color','k') % color coded based on channel
                hold on;
                %title([fparts{end}  ', chnl: ' num2str(chnl) ',  Time ref: ' num2str(t0)]);
            end
            %ylabel('channels'); yticks((-N+1:1:0)*500);  yticklabels(num2cell(fliplr(chnl_order)));
            xlabel('Time (sec)');
            % since yticks are going upwards, the ytick labels also shall start from
            % buttom to up so they are flipped
            axis tight
            ylim([-400 400])
            %print([save_dir '\' [fparts{end} '-RAW']],'-dpng')
            
            %% spw detection by TEO
            % Fig 1. Raw and SWR for channel 1
            figure(200); clf
            plot_time=1+[0 30.01]; %%%%%%%%%
            subplot(4,1,1);
            o1=plot(t_signal,signal_raw(:,1));
            %title(['Raw signal  ' fparts{end}  '  Time ref: ' num2str(t0) ' sec'])
            title(['Raw signal'])
            ylabel('(\muV)'); xlim(plot_time); ylim([-400 400])
            % Fig 1 (SW & R)
            subplot(4,1,2);
            plot(t_signal,spwsig(:,1),'k');
            axis tight
            %title('Filtered 1-100Hz (SPW)' ); ylabel('(\muV)'); xlim(plot_time); ylim([-400 270])
            title('Filtered 1-100Hz (SPW)' ); ylabel('(\muV)'); xlim(plot_time); ylim([-400 400])
            subplot(4,1,3);
            o3=plot(t_signal,RippSig(:,1),'r');
            axis tight
            %title('Filtered 40-300Hz (Ripples)' ); ylabel('(\muV)');
            title('Filtered 40-300Hz (Ripples)' ); ylabel('(\muV)');
            xlim(plot_time);
            % Fig 3 ( ShR )
            % here we extract a threshold for spw detection using Teager enery
            subplot(4,1,4);
            tig=teager(spwsig,[fs_/20]);
            [~,k]=max(var(spwsig)); % channel to show TEO and spw detection for  %%%%%%%%%%%%%
            plot(t_signal,tig(:,k),'b'); title('TEO ' ); ylabel('(\muV^2)'); xlabel('Time (Sec)'); xlim(plot_time);
            thr=median(tig)+8*iqr(tig); % threshold for detection of spw
            % plotting distribution of TEO values and the threshold for spw detection
            figure % distribution of TEO values for channel k  %%%%%%%%%%%%%%%
            hist(tig(:,k),300); y=ylim;  hold on; line([thr(k) thr(k)],y,'LineStyle','--')
            
            % plot for raw data + spw detection threshold
            figure(204); clf
            subplot(2,1,1);
            plot(t_signal,spwsig(:,k));
            %title(['LFP (1-100 Hz)  ' fparts{end}  '  Time ref: ' num2str(t0) ' sec']);  ylabel('(\muV)');
            title(['LFP (1-100 Hz)']);
            ylabel('(\muV)');
            xlim(plot_time)
            subplot(2,1,2);cla
            plot(t_signal,tig(:,k),'b'); hold on;
            line(plot_time,[thr(k) thr(k)],'LineStyle','--', 'color', 'r');  title('TEO ' );
            ylabel('(\muV^2)'); xlabel('Time (Sec)'); xlim(plot_time); axis tight
            
            %% making template of spws based on spw detection
            up_tresh=tig.*(tig>thr);
            [~,spw_indices1] = findpeaks(up_tresh(fs_+1:end-Fs,k)); % Finding peaks in the channel with max variance, omitting the 1st and last sec ...
            
            % Now we remove concecutive detected peaks with less than .1 sec interval
            spw_interval=[1; diff(spw_indices1)]; % assigning the inter-SPW interval to the very next SPW. If it is longer than a specific time, that SPW is accepted.
            % of course the first SPW is alway accepted so w assign a long enough
            % interval to it (1).
            spw_indices=spw_indices1(spw_interval>.3*fs_);
            
            spw_indices=spw_indices+fs_; % shifting 1 sec to the right place for the corresponding time (removal of 1st second is compensared)
            spw1=zeros(2*fs_/5+1,N,length(spw_indices)); % initialization: empty spw matrix, length of spw templates is considered as 500ms
            n=1;
            while n <= length(spw_indices)
                spw1(:,:,n)=spwsig(spw_indices(n)-fs_/5 : spw_indices(n)+fs_/5,:); n=n+1;  % spw in the 1st channel
            end
            
            % removing upward detected-events
            indx=spw1(round(size(spw1,1)/2),k,:)<mean(spw1([1 end],k,:),1); % for valid spw, middle point shall occur below the line connecting the two sides
            spw_=spw1(:,:,indx);
            spw_indx1=spw_indices(indx); % selected set of indices of SPWs that are downward
            % correcting SPW times, all detected events will be aligned to their
            % minimum:
            [~,min_point]=min(spw_(:,k,:),[],1); % extracting index of the minimum point for any detected event
            align_err1=min_point-ceil(size(spw_,1)/2); % Error = min_point - mid_point
            align_err=reshape(align_err1,size(spw_indx1));
            spw_indx=spw_indx1+align_err; % these indices are time-corrected
            save([save_dir '\' [fparts{end} '-spw_indx']],'spw_indx');
            
            
            
            %%
            nSWRs = numel(spw_indx);
            win_ms = 200;
            win_samp = win_ms/1000*Fs;
            for j = 1:nSWRs
                thisStart =spw_indx(j)-win_samp;
                thisStop = spw_indx(j)+win_samp;
                thisROI = data(thisStart:thisStop);
                
                figure(100); clf
                plot(thisROI);
                axis tight
                pause
            end
            
            
            spw_indx
            
            
            
            
            
            
            % repicking SPW events after time alignment
            spw=zeros(2*fs_/5+1,N,length(spw_indx)); % initialization: empty spw matrix, length of spw templates is considered as 500ms
            n=1;
            while n <= length(spw_indx)
                spw(:,:,n)=spwsig(spw_indx(n)-fs_/5 : spw_indx(n)+fs_/5,:); n=n+1;  % spw in the 1st channel
            end
            save([save_dir '\' [fparts{end} '-spw']],'spw');
            
            % plotting all spws and the average shape, for channel k which is the one
            % with maximum variance
            figure('Position', [460 100 600 600]);
            subplot(1,2,1)
            for i=1:size(spw,3)
                plot((-fs_/5:fs_/5)/fs_*1000,spw(:,k,i)); hold on
            end; axis tight; xlabel('Time (ms)'); ylabel('Amplitude (\muV)')
            axis([-200 200 -750 150]);
            title('SPWs in max variance chnl')
            
            % plot of average SPWs across channels
            subplot(1,2,2)
            hold on
            for chnl=1:N
                plot((-fs_/5:fs_/5)/fs_*1000,mean(spw(:,chnl,:),3), ...
                    'color',[220 chnl*255/N 255-chnl*255/N]/255); % color coded based on channel
            end
            axis([-200 200 -400 50]); xlabel('Time (ms)');
            title({'mean SPW accross chnls'; ['rate: ' num2str( round(size(spw,3) / max(time)*60 ,1)) '/min  ' fparts{end}]}); ylabel('Amplitude (\muV)')
            print([save_dir '\' [fparts{end} '-SPW']],'-dpng')
            
            figure;
            subplot(2,1,1);
            plotredu(@plot,t_signal,signal_raw(:,1)); title('Raw signal ' );  ylabel('(\muV)');
            hold on; plot(t_signal(spw_indx),signal_raw(spw_indx),'+r');  xlim(plot_time)
            subplot(2,1,2);
            plotredu(@plot,t_signal,tig(:,k),'b'); hold on; line(plot_time,[thr(k) thr(k)],'LineStyle','--');  title('TEO ' );
            ylabel('(\muV^2)'); xlabel('Time (Sec)'); xlim(plot_time); axis tight
            
            % garbage cleaning
            clear spw_times up_tresh spw1 align_err align_err1
            %% Current Sourse Density Analysis
            avg_spw=mean(spw,3)*10^-6; % for further use in ''SCD'' analysis, data turns to Volts instead of uV
            spacing=100*10^-6; %%%%%%%%%%% spacing between neiboring electrodes
            CSDoutput = CSD(avg_spw,fs_,spacing,'inverse',5*spacing)';
            figure;
            
            subplot(1,3,1) % CSD
            t_peri=(-fs_/5:fs_/5)./fs_*1000; % peri-SPW time
            y_peri=(1-.5:N-.5)'; % y values for CSD plot, basically electrode channels , we centered the y cvalues so ...
            % they will be natural numbers + .5
            imagesc(t_peri,y_peri,CSDoutput, [-8 7]); yticks(.5:1:N-.5);  yticklabels(num2cell(chnl_order));
            ylabel(' ventral <--                    Electrode                    --> dorsal');  colormap(flipud(jet)); % blue = sink; red = sourse
            xlabel('peri-SPW time (ms)');      title('CSD (\color{red}sink, \color{blue}source\color{black})');
            
            subplot(1,3,2) % smoothed CSD (spline), we interpolate CSD values in a finer grid
            t_grid=repmat(t_peri,length(y_peri)+2,1); % grid for current t values, to extra rows for beginning (zero), and the last natural full number, just ...
            % greater than last row which includes a .5 portion
            y_grid=repmat([0 ; y_peri ; N] , 1,length(t_peri)); % grid for current y values
            t_grid_ext=repmat(t_peri,10*N,1); % new fine t grid
            y_grid_ext=repmat((.1:.1:N)',1,size(t_grid,2)); % new fine y grid
            [csd_smoo]=interp2( t_grid , y_grid ,[CSDoutput(1,:) ; CSDoutput ; CSDoutput(end,:)],t_grid_ext,y_grid_ext, 'spline'); % interpolation of CSD in a finer grid
            imagesc((-fs_/5:fs_/5)./fs_*1000,(.1:.1:N)',csd_smoo,  [-8 7]); % fixing the color range for comparing different data
            yticks(.5:1:N-.5);  yticklabels(num2cell(chnl_order));
            ylabel('Electrode');  colormap(flipud(jet)); % blue = source; red = sink
            xlabel('peri-SPW time (ms)');      title('smoothed CSD (\color{red}sink, \color{blue}source\color{black})');
            
            subplot(1,3,3) % LFP
            s=imagesc((-fs_/5:fs_/5)./fs_*1000,1:N,flipud(avg_spw)', [-60 6]*1e-5); yticks(1:1:N); yticklabels(num2cell(fliplr(chnl_order)));
            ylabel('Electrode');  colormap(flipud(jet));
            xlabel('peri-SPW time (ms)');   title(['LFP' fparts{end}])
            print(['C:\Users\Spike Sorting\Desktop\Chicken\' [fparts{end} '-CSD']],'-dpng'); % save the plot
            print([save_dir '\' [fparts{end} '-CSD']],'-dpng')
            
            % save CSD matrix for further analysis
            save([save_dir '\' [fparts{end} '-CSD']],'CSDoutput');
            
            % %% analysisng spw peri-event times
        end
        
        
        
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% ~~~~~Functions called by constructor
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function obj = getSessionInfo(obj,rfc)
            
            disp('Getting session info...')
            
            [avianSWR_DB] = avian_SWR_database(); % This is the database
            
            obj.HOST = gethostname;
            obj.INFO = avianSWR_DB(rfc).INFO;
            obj.Session = avianSWR_DB(rfc).Session;
            obj.DIR = avianSWR_DB(rfc).DIR;
            obj.REC = avianSWR_DB(rfc).REC;
            obj.Vid = avianSWR_DB(rfc).Vid;
            obj.Plotting = avianSWR_DB(rfc).Plotting;
            
            %% Make directories
            plotDir = [obj.DIR.plotDir];
            analysisDir = [obj.DIR.analysisDir];
            
            if exist(plotDir, 'dir') == 0
                mkdir(plotDir);
                disp(['Created: '  plotDir])
            end
            
            if exist(analysisDir, 'dir') == 0
                mkdir(analysisDir);
                disp(['Created: '  analysisDir])
            end
            
            
        end
        
        function [obj] = findSessionDir(obj)
            
            %             birdDir=[obj.DIR.dataDir obj.INFO.Name obj.DIR.dirD];
            %
            %             FileSearch=obj.Session.time;
            %             %allDataFiles = dir(fullfile(dataDir,textSearch));
            %
            %             allDataDirs=dir([birdDir 'Ephys' obj.DIR.dirD]);
            %             if isempty(allDataDirs)
            %                 disp('Did not find any directory, check the file path...')
            %                 keyboard
            %             end
            %
            %             nDataDirs=numel(allDataDirs);
            %             for j = 1:nDataDirs
            %                 dirName=allDataDirs(j).name;
            %                 %match = strcmpi(dirName, FileSearch);
            %                 match=strfind(dirName, FileSearch);
            %                 if match
            %                     SessionDir=[birdDir 'Ephys' obj.DIR.dirD dirName obj.DIR.dirD];
            %                     disp(['Search: ' FileSearch ' matches ' dirName ])
            %                     break
            %                 end
            %             end
            
            obj.Session.SessionDir = SessionDir;
            obj.DIR.birdDir = birdDir;
            obj.DIR.dirName = dirName;
        end
        
    end
    
    methods (Hidden)
        %class constructor
        function obj = avianSWRAnalysis_OBJ(rfc)
            
            obj = getSessionInfo(obj, rfc);
            %obj = findSessionDir(obj);
            
        end
    end
    
end
