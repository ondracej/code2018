classdef MEA_Analysis_OBJ < handle
    
    
    properties (Access = public)
        
        PATH
        SWR_INFO
        ANALYSIS
    end
    
    methods
        
        
        function obj = getPathInfo(obj,analysisDir)
            
            if ispc
                dirD = '\';
            else
                dirD = '/';
            end
            
            %% adding code paths
            
            McsCodePath = 'C:\Users\dlc\Documents\GitHub\McsMatlabDataTools';
            code2018Path = 'C:\Users\dlc\Documents\GitHub\code2018';
            NETCode = 'C:\Users\dlc\Documents\GitHub\NeuralElectrophysilogyTools';
            
            if isfolder(McsCodePath)
                addpath(genpath('C:\Users\dlc\Documents\GitHub\McsMatlabDataTools'));
            else
                disp('Please check definition for MCS path in "getPathInfo"')
            end
            
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
            
            obj.PATH.mcdFiles = [analysisDir '_mcd_files' dirD];
            obj.PATH.h5Files = [analysisDir '_h5_files' dirD];
            obj.PATH.swrAnalysis = [analysisDir 'SWR_Analysis' dirD];
            obj.PATH.spikeAnalysis = [analysisDir 'Firing_Rate_Analysis' dirD];
            obj.PATH.dirD  = dirD ;
            
            if exist(obj.PATH.mcdFiles, 'dir') ==0
                mkdir(obj.PATH.mcdFiles );
                disp(['Created directory: ' obj.PATH.mcdFiles ])
            end
            
            if exist(obj.PATH.h5Files, 'dir') ==0
                mkdir(obj.PATH.h5Files );
                disp(['Created directory: ' obj.PATH.h5Files ])
            end
            
            if exist(obj.PATH.swrAnalysis, 'dir') ==0
                mkdir(obj.PATH.swrAnalysis );
                disp(['Created directory: ' obj.PATH.swrAnalysis ])
            end
            
            if exist(obj.PATH.spikeAnalysis, 'dir') ==0
                mkdir(obj.PATH.spikeAnalysis );
                disp(['Created directory: ' obj.PATH.spikeAnalysis ])
            end
            
            
        end
        
        function obj = addAnalysisInfoToObj(obj)
            % Look for h5 files
            h5FilesDir = obj.PATH.h5Files;
            files = dir(fullfile(h5FilesDir));
            nFiles = numel(files);
            
            for j = 1:nFiles
                fileNames{j} = files(j).name;
            end
            
            searchString = ['.h5']; % look for the .csv file
            
            matchInds = cellfun(@(x) strfind(x, searchString), fileNames, 'UniformOutput', 0);
            matchIndsPlace = cell2mat(matchInds);
            matchInds_nonempty = find(cellfun(@(x) ~isempty(x), matchInds)==1);
            
            varNames = fileNames(matchInds_nonempty);
            
            list = {varNames{1:end}};
            [indx,tf] = listdlg('PromptString','Choose h5 file to analyze objects:', 'ListString',list, 'SelectionMode','single');
            
            h5File = list{indx};
            
            %             nChoices = numel(indx);
            %             for j = 1:nChoices
            %                 allChoices{j} = list{indx(j)};
            %             end
            
            obj.ANALYSIS.h5_fileToLoad = [obj.PATH.h5Files h5File];
            disp(['H5 file loaded: ' h5File])
            %%
            
            dlgtitle = 'Please enter noisy channels:';
            answer = inputdlg('Enter space-separated numbers:', dlgtitle, [1 80]);
            
            obj.ANALYSIS.SWR_Analysis_noisy_channels = str2num(answer{1});
            disp(['Noisy channels: ' num2str(obj.ANALYSIS.SWR_Analysis_noisy_channels)])
            
            dlgtitle = 'Please enter channles with spikes:';
            answer = inputdlg('Enter space-separated numbers:', dlgtitle, [1 80]);
            
            obj.ANALYSIS.Firing_Rate_Analysis_channels_with_spikes = str2num(answer{1});
            disp(['Spiking channels: ' num2str(obj.ANALYSIS.Firing_Rate_Analysis_channels_with_spikes)])
            
        end
        
        
        function obj = load_MCS_data_detectSWRs(obj)
            
            dbstop if error
            doPlot = 0; % will pause the analysis
            
            fileToLoad = obj.ANALYSIS.h5_fileToLoad;
            
            data = McsHDF5.McsData(fileToLoad);
            [filepath,name,ext] = fileparts(fileToLoad);
            
            swrAnalysisDetections_plotDir = [obj.PATH.swrAnalysis name '_Plots' obj.PATH.dirD];
            swrAnalysisDetections_Dir = [obj.PATH.swrAnalysis name '_SWR_Detections' obj.PATH.dirD];
            
            obj.PATH.swrAnalysisDetections_plotDir = swrAnalysisDetections_plotDir;
            obj.PATH.swrAnalysisDetections_Dir = swrAnalysisDetections_Dir;
            
            if exist(swrAnalysisDetections_plotDir, 'dir') == 0
                mkdir(swrAnalysisDetections_plotDir);
                disp(['Created: '  swrAnalysisDetections_plotDir])
            end
            
            if exist(swrAnalysisDetections_Dir, 'dir') == 0
                mkdir(swrAnalysisDetections_Dir);
                disp(['Created: '  swrAnalysisDetections_Dir])
            end
            
            %check if ripple data already exists
            if isfile([swrAnalysisDetections_Dir name '_RippleData.mat'])
                
            else
                
                
                
                %% For getting the correct channel order
                
                cfg = [];
                cfg.channel = [1 60]; % channel index 5 to 15
                cfg.window = [0 1]; % time range 0 to 1 s
                
                dataTmp= data.Recording{1}.AnalogStream{1}.readPartialChannelData(cfg);
                
                %Original
                %plottingOrder = [21 31 41 51 61 71 12 22 32 42 52 62 72 82 13 23 33 43 53 63 73 83 14 24 34 44 54 64 74 84 15 25 35 45 55 65 75 85 16 26 36 46 56 66 76 86 17 27 37 47 57 67 77 87 28 38 48 58 68 78];
                
                %Not including ch 15 = reference
                plottingOrder = [21 31 41 51 61 71 12 22 32 42 52 62 72 82 13 23 33 43 53 63 73 83 14 24 34 44 54 64 74 84 25 35 45 55 65 75 85 16 26 36 46 56 66 76 86 17 27 37 47 57 67 77 87 28 38 48 58 68 78];
                
                ChanLabelInds = str2double(dataTmp.Info.Label(:));
                
                chanInds = [];
                for k = 1:numel(plottingOrder)
                    chanInds(k) = find(ChanLabelInds == plottingOrder(k));
                end
                
                %% Designing filters
                Fs = 32000;
                fObj = filterData(Fs);
                
                %             fobj.filt.F=filterData(Fs);
                %             fobj.filt.F.downSamplingFactor=128; % original is 128 for 32k; use 120 for 30k
                %             fobj.filt.F=fobj.filt.F.designDownSample;
                %             fobj.filt.F.padding=true;
                %             fobj.filt.FFs=fobj.filt.F.filteredSamplingFrequency;
                
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
                
                % fobj.filt.FN =filterData(Fs);
                % fobj.filt.FN.filterDesign='cheby1';
                % fobj.filt.FN.padding=true;
                % fobj.filt.FN=fobj.filt.FN.designNotch;
                
                
                %% Load full channel data
                
                recordingDuration_s = double(data.Recording{1,1}.Duration/1e6);
                
                cfg = [];
                cfg.window = [0 recordingDuration_s]; % time
                smoothWin = 0.10*Fs;
                
                DetChanInds = ~ismember(plottingOrder, obj.ANALYSIS.SWR_Analysis_noisy_channels);
                ChansForDetection = plottingOrder(DetChanInds);
                ChanIndsForDetection = chanInds(DetChanInds);
                
                for k = 1:numel(ChansForDetection)
                    
                    disp(['Processing chan ' num2str((k)) '/' num2str(numel(ChansForDetection))])
                    disp(['Chan: ' num2str(ChansForDetection(k))])
                    
                    thisChan = ChanIndsForDetection(k);
                    
                    cfg.channel = [thisChan thisChan]; % channel index 5 to 15
                    
                    chanDataParital= data.Recording{1}.AnalogStream{1}.readPartialChannelData(cfg);
                    ChanData = chanDataParital.ChannelData/1e6; %loads all data info
                    
                    timestamps = chanDataParital.ChannelDataTimeStamps;
                    time_samp = 1:1:numel(timestamps);
                    time_s = time_samp/Fs;
                    
                    %% Filter data
                    
                    [data_shift,nshifts] = shiftdim(ChanData',-2);
                    
                    % Sharp wave
                    data_BP = (fobj.filt.BP.getFilteredData(data_shift));% 1-2000 BP
                    data_FLBP = squeeze(fobj.filt.FL.getFilteredData(data_BP)); %30-40 LP
                    
                    data_rippleBP = squeeze(fobj.filt.Ripple.getFilteredData(data_BP)); %80-300 BP
                    data_rect_rippleBP = smooth(data_rippleBP.^2, smoothWin);
                    
                    %{
              figure; plot(time_s(1:Fs*10), data_rect_rippleBP(1:Fs*10))
              figure; plot(time_s(1:Fs*10), squeeze(data_BP(1:Fs*10)))
              figure; plot(time_s(1:Fs*10), -data_FLBP(1:Fs*10))
                    %}
                    
                    %% Get Samples for defining threshold
                    
                    rng(1);
                    segT_s= 5;
                    TOn=1:segT_s*Fs:(recordingDuration_s*Fs-segT_s*Fs);
                    %nTestSegments = round(numel(TOn)*.3);
                    nTestSegments = round(numel(TOn));
                    
                    nCycles = 20;
                    pCycle = randperm(nTestSegments-1);
                    if numel(pCycle) >= nCycles
                        
                        pCycle = sort(pCycle(1:nCycles));
                    else
                        pCycle = sort(pCycle(1:numel(pCycle)-1));
                    end
                    
                    Mtest_ripple=cell(nCycles,1);
                    Mtest_SW=cell(nCycles,1);
                    
                    for i=1:numel(pCycle)
                        
                        thisROI = TOn(pCycle(i)):TOn(pCycle(i)+1);
                        
                        Mtest_ripple{i} = data_rect_rippleBP(thisROI);
                        Mtest_SW{i} = -data_FLBP(thisROI);
                    end
                    
                    Mtest_ripple=cell2mat(Mtest_ripple);
                    Mtest_SW=cell2mat(Mtest_SW);
                    
                    sortedMtest_ripple=sort(Mtest_ripple);
                    sortedMtest_SW=sort(Mtest_SW);
                    
                    percentile4ScaleEstimation = 95;
                    
                    scaleEstimator_ripple=sortedMtest_ripple(round(percentile4ScaleEstimation/100*numel(sortedMtest_ripple)));
                    scaleEstimator_sw=sortedMtest_SW(round(percentile4ScaleEstimation/100*numel(sortedMtest_SW)));
                    
                    %  figure; plot(sortedMtest_ripple); axis tight
                    %  figure; plot(sortedMtest_SW); axis tight
                    
                    
                    %% Detect Ripples
                    
                    
                    interPeakDistance = 0.1*Fs;
                    minPeakWidth = 0.1*Fs;
                    minPeakHeight =scaleEstimator_ripple;
                    minPeakProm = 8;
                    %minPeakProm = 5;
                    
                    [peakH,peakTime_Fs, peakW, peakP]=findpeaks(data_rect_rippleBP,'MinPeakHeight',minPeakHeight, 'MinPeakWidth', minPeakWidth,'MinPeakDistance', interPeakDistance, 'WidthReference','halfprom', 'MinPeakProminence',minPeakProm); %For HF
                    
                    %{
        figure;
        dataP = data_rect_rippleBP(20*Fs:40*Fs);
        time_fs = 1:1:numel(dataP);
        time_s = time_fs/Fs;
        plot(time_s , dataP ); axis tight
                    %}
                    %[peakH,peakTime_Fs, peakW, peakP]=findpeaks(dataP,'MinPeakHeight',minPeakHeight, 'MinPeakWidth', minPeakWidth,'MinPeakDistance', interPeakDistance, 'WidthReference','halfprom', 'MinPeakProminence',minPeakProm); %For HF
                    
                    if isempty(peakH)
                        disp(['No ripples detected on ch ' num2str(plottingOrder(k))])
                    end
                    
                    peakTimes_s = peakTime_Fs/Fs;
                    
                    %% Collecting data Snippets and info
                    
                    WinSizeL = 1*Fs;
                    WinSizeR = 1*Fs;
                    
                    cnt = 1;
                    
                    chanDataROI = []; chanDataROI_T_s = [];
                    chan_peakTime_Fs = []; chan_peakTime_s = [];
                    chan_peakH = []; chan_peakW_Fs = []; chan_peakW_s = []; chan_peakP = [];
                    for q =1:numel(peakTime_Fs)
                        
                        winROI = peakTime_Fs(q)-WinSizeL:peakTime_Fs(q)+WinSizeR;
                        if winROI(1) <0 || winROI(end) > numel(data_rect_rippleBP)
                            continue
                        end
                        
                        test = max(diff(data_rect_rippleBP(winROI)));
                        
                        if test < 0.1 %derivative of the signal shoudl be small for normal data
                            
                            
                            chanDataROI{cnt} = ChanData(winROI);
                            chanDataROI_T_s{cnt} = time_s(winROI);
                            
                            chan_peakTime_Fs(cnt) = peakTime_Fs(q);
                            chan_peakTime_s(cnt) = peakTimes_s(q);
                            
                            chan_peakH(cnt) = peakH(q);
                            chan_peakW_Fs(cnt) = peakW(q);
                            chan_peakW_s(cnt) = peakW(q)/Fs;
                            chan_peakP(cnt) = peakP(q);
                            
                            if doPlot
                                figure(100);clf
                                subplot(3, 1, 1)
                                plot(time_s(winROI), data_rect_rippleBP(winROI));
                                axis tight
                                ylim([0 20])
                                
                                subplot(3, 1, 2)
                                % plot(time_s(winROI), ChanData_cond(winROI));
                                hold on
                                plot(time_s(winROI), ChanData(winROI), 'k');
                                axis tight
                                ylim([-50 50])
                                
                                subplot(3, 1, 3)
                                %   plot(time_s(winROI), ChanData_cond(winROI));
                                hold on
                                test = diff(data_rect_rippleBP(winROI));
                                
                                plot(time_s(winROI(1:end-1)), diff(data_rect_rippleBP(winROI)), 'k');
                                axis tight
                                ylim([-50 50])
                                pause
                            end
                            
                            cnt = cnt+1;
                        end
                        
                    end
                    
                    allChanDataROI{k} = chanDataROI;
                    allChanDataROI_T_s{k} = chanDataROI_T_s;
                    
                    allChan_peakTime_Fs{k} = chan_peakTime_Fs;
                    allChan_peakTime_s{k} = chan_peakTime_s;
                    
                    allChan_peakH{k} = chan_peakH;
                    allChan_peakW_Fs{k} = chan_peakW_Fs;
                    allChan_peakW_s{k} = chan_peakW_s;
                    allChan_peakP{k} = chan_peakP;
                    
                    allChanName{k} = ChansForDetection(k);
                    allChanInd{k} = ChanIndsForDetection(k);
                    
                end
                
                
                AllDetections = [];
                extrachannelDetections = [];
                for runs = 1:15
                    
                    if runs == 1
                        nonempty = cell2mat(cellfun(@(x) ~isempty(x),allChan_peakTime_Fs,'UniformOutput',false));
                        peakTimes_fs = allChan_peakTime_Fs(nonempty);
                        [detections] = cell2mat(cellfun(@(x) numel(x),peakTimes_fs,'UniformOutput',false));
                        %peakTimes_fs = detections;
                    else
                        if isempty(extrachannelDetections)
                            continue
                        end
                        nonempty = cell2mat(cellfun(@(x) ~isempty(x),extrachannelDetections,'UniformOutput',false));
                        peakTimes_fs  = extrachannelDetections(nonempty);
                        [detections] = cell2mat(cellfun(@(x) numel(x),peakTimes_fs,'UniformOutput',false));
                        extrachannelDetections = [];
                    end
                    
                    detSum = sum(detections);
                    
                    if detSum == 0
                        continue
                        keyboard
                    elseif detSum == 1
                        AllDetections{runs} = detChan_peakTimes_fs;
                        continue
                    else
                        
                        [maxval, minds] = max(detections);
                        
                        detChan_peakTimes_fs = peakTimes_fs{minds};
                        
                        %allRois = INFO.allChanDataROI{minds};
                        %allTimes = INFO.allChanDataROI_T_s{minds};
                        %{
for j = 1:maxval
figure(100);clf
    plot(allTimes{j}, allRois{j})
    pause
end
                        %}
                        %% Go over all the detections on other channels and see if this is within a 1 s range
                        WinSizeL = 1*Fs;
                        WinSizeR = 1*Fs;
                        
                        ROI_fs = [];
                        for o = 1:numel(detChan_peakTimes_fs)
                            thisDet = detChan_peakTimes_fs(o);
                            ROI_fs{o} = thisDet-WinSizeL:thisDet+WinSizeR;
                        end
                        
                        for q = 1:numel(peakTimes_fs)
                            thisChanDets = peakTimes_fs{q};
                            for o = 1:numel(thisChanDets)
                                thisChanDet = thisChanDets(o);
                                
                                match = [];
                                for oo = 1:numel(ROI_fs)
                                    
                                    match = [match ; double(ismember(thisChanDets, ROI_fs{oo}))];
                                    
                                end
                            end
                            testCase = sum(match, 1);
                            
                            if sum(testCase) == numel(thisChanDets)
                                
                                disp('All detected')
                                
                            else
                                
                                nonmatch = find(testCase == 0);
                                extrachannelDetections{q} = thisChanDets(nonmatch);
                                
                            end
                        end
                        
                        %% All Detections
                        AllDetections{runs} = detChan_peakTimes_fs;
                    end
                end
                AllUniqueDetections  = sort(cell2mat(AllDetections));
                
                SWR_INFO.AllUniqueDetections = AllUniqueDetections;
                
                SWR_INFO.allChanDataROI = allChanDataROI;
                SWR_INFO.allChanDataROI_T_s = allChanDataROI_T_s;
                
                SWR_INFO.allChan_peakTime_Fs = allChan_peakTime_Fs;
                SWR_INFO.allChan_peakTime_s = allChan_peakTime_s;
                
                SWR_INFO.allChan_peakH = allChan_peakH;
                SWR_INFO.allChan_peakW_Fs = allChan_peakW_Fs;
                SWR_INFO.allChan_peakW_s = allChan_peakW_s;
                SWR_INFO.allChan_peakP = allChan_peakP;
                SWR_INFO.Fs = Fs;
                SWR_INFO.plottingOrder = plottingOrder;
                SWR_INFO.fobj = fobj;
                
                save([swrAnalysisDetections_Dir name '_RippleData.mat'], 'SWR_INFO', '-v7.3')
                obj.ANALYSIS.SWR_INFO = SWR_INFO;
                disp(['Saved: ' [swrAnalysisDetections_Dir name '_RippleData.mat']])
                
                
            end
        end
        
        function obj = collectAllSWRDetections(obj)
            
            
            %% collect all SWR times for all channels:
            nUniqueDetections = numel(AllUniqueDetections);
            ROI_fs = [];
            for o = 1:nUniqueDetections
                thisDet = AllUniqueDetections(o);
                ROI_fs{o} = thisDet-WinSizeL:thisDet+WinSizeR;
            end
            
            AllSWRDataOnChans = [];
            SWR_Detection_fs = [];
            SWR_Detection_s = [];
            for k = 1:numel(plottingOrder)
                
                disp(['Collecting SWRs ' num2str((k)) '/' num2str(numel(plottingOrder))])
                thisChan = chanInds(k);
                cfg.channel = [thisChan thisChan]; % channel index 5 to 15
                
                chanDataParital= data.Recording{1}.AnalogStream{1}.readPartialChannelData(cfg);
                ChanData = chanDataParital.ChannelData/1e6; %loads all data info
                
                for j = 1:numel(ROI_fs)
                    thisROI = ROI_fs{j};
                    AllSWRDataOnChans{k,j} = ChanData(thisROI);
                    SWR_Detection_fs(k,j) = AllUniqueDetections(j);
                    SWR_Detection_s(k,j) = AllUniqueDetections(j)/Fs;
                end
            end
            
            timepoints_s = (1:1:WinSizeL*2+1)/Fs;
            xticks = 0:0.2:2;
            xticklabs = -1:0.2:1;
            
            D.AllSWRDataOnChans = AllSWRDataOnChans;
            D.SWR_Detection_fs = SWR_Detection_fs;
            D.SWR_Detection_s = SWR_Detection_s;
            D.plottingOrder = plottingOrder;
            D.channelsNotToInclude = ChannelsToNoTIncludeInDetections;
            D.Fs = Fs;
            D.timepoints_s = timepoints_s;
            
            save([saveDir name '-Detections.mat'], 'D', '-v7.3')
            
            xlabs = [];
            for j = 1:numel(xticklabs)
                xlabs{j} = num2str(xticklabs(j));
            end
            
            
            for j = 1: size(AllSWRDataOnChans, 2)
                
                offset = 0;
                offsetFil = 0;
                figH = figure (100);clf
                figHH = figure (200);clf
                hold on
                for k = 1:   size(AllSWRDataOnChans, 1)
                    
                    toPlot = AllSWRDataOnChans{k,j};
                    thisChan = plottingOrder(k);
                    match =  sum(ismember(ChannelsToNoTIncludeInDetections,thisChan));
                    
                    if match
                        col = [0.9 0.9 0.9];
                    else
                        col = [0 0 0];
                    end
                    
                    
                    figure(figH)
                    subplot(1, 3, 1)
                    hold on
                    plot(timepoints_s, toPlot+offset, 'color', col);
                    thisChan = num2str(plottingOrder(k));
                    text(0, toPlot(1)+offset, thisChan)
                    
                    %%
                    [data_shift,nshifts] = shiftdim(toPlot',-2);
                    
                    % Sharp wave
                    data_BP = (fobj.filt.BP.getFilteredData(data_shift));% 1-2000 BP
                    data_FLBP = squeeze(fobj.filt.FL.getFilteredData(data_BP)); %30-40 LP
                    
                    subplot(1, 3, 2)
                    hold on
                    plot(timepoints_s, data_FLBP+offsetFil, 'color', col);
                    % text(0, toPlot(1)+offset, thisChan)
                    
                    subplot(1, 3, 3)
                    hold on
                    data_rippleBP = squeeze(fobj.filt.Ripple.getFilteredData(data_BP)); %80-300 BP
                    
                    plot(timepoints_s, squeeze(data_rippleBP)+offsetFil, 'color', col);
                    
                    offset = offset+60;
                    offsetFil = offsetFil+30;
                    
                    %%
                    
                    figure(figHH)
                    
                    if k == 1
                        counter = 0;
                        scnt = 2;
                        
                    elseif k == 7
                        scnt = 9;
                        counter = 1;
                    elseif k == 31
                        scnt = 34;
                        counter = 2;
                    elseif k == 54
                        scnt = 58;
                        counter = 3;
                    else
                        scnt = k+1+counter;
                    end
                    %scnt
                    subplot(8, 8, scnt)
                    
                    %plot(timepoints_s, toPlot, 'k');
                    plot(timepoints_s, data_FLBP, 'color', col);
                    %plot(timepoints_s, squeeze(data_rippleBP), 'k');
                    
                    
                    thisChan = num2str(plottingOrder(k));
                    title(thisChan)
                    grid('on')
                    axis tight
                    ylim([-40 20])
                    %text(0, toPlot(1)+offset, thisChan)
                    
                    %   all_data_FLBP{k,j} = data_FLBP;
                    
                end
                
                figure(figH)
                subplot(1, 3, 1)
                title('Raw')
                axis tight
                set(gca, 'xtick', xticks)
                set(gca, 'xticklabel', xlabs)
                ylim([-50 3500])
                line([1 1], [-50 3500],  'color', 'k', 'linestyle', ':')
                xlabel('Time (s)')
                
                subplot(1, 3, 2)
                title('Low Pass: 30-40 Hz')
                axis tight
                set(gca, 'xtick', xticks)
                set(gca, 'xticklabel', xlabs)
                ylim([-30 1750])
                line([1 1], [-30 1750], 'color', 'k', 'linestyle', ':')
                xlabel('Time (s)')
                
                subplot(1, 3, 3)
                title('Ripple: 80-300 Hz')
                axis tight
                set(gca, 'xtick', xticks)
                set(gca, 'xticklabel', xlabs)
                ylim([-30 1750])
                line([1 1], [-30 1750], 'color', 'k', 'linestyle', ':')
                xlabel('Time (s)')
                
                textAnnotation = ['File: ' name ' | SWR Detection: ' num2str(round(SWR_Detection_s(k,j), 2)) 's' ];
                % Create textbox
                annotation(figH,'textbox', [0.01 0.95 0.36 0.03],'String',{textAnnotation}, 'LineStyle','none','FitBoxToText','off');
                
                saveName = [plotDir name '_SWR-stack' sprintf('%03d',j)];
                figure(figH)
                plotpos = [0 0 50 50];
                
                print_in_A4(0, saveName, '-djpeg', 0, plotpos);
                
                figure(figHH)
                
                textAnnotation = ['File: ' name ' | SWR Detection: ' num2str(round(SWR_Detection_s(k,j), 2)) 's' ];
                % Create textbox
                annotation(figHH,'textbox', [0.01 0.95 0.36 0.03],'String',{textAnnotation}, 'LineStyle','none','FitBoxToText','off');
                
                saveName = [plotDir name '_SWR-grid' sprintf('%03d',j)];
                figure(figHH)
                plotpos = [0 0 50 50];
                
                print_in_A4(0, saveName, '-djpeg', 0, plotpos);
                
            end
            
            %save([saveDir 'DetectionsToSort.mat'], 'all_data_FLBP', 'INFO', '-v7.3')
            
            close all
            %}
            
            
            
        end
        
        function obj = convertH5DataToPlexonMatlabFormat(obj)
            dbstop if error
            
            %%
            
            fileToLoad = obj.ANALYSIS.h5_fileToLoad;
            data = McsHDF5.McsData(fileToLoad);
            [filepath,name,ext] = fileparts(fileToLoad);
            
            
            %% For getting the correct channel order
            
            cfg = [];
            cfg.channel = [1 60]; % channel index 5 to 15
            cfg.window = [0 1]; % time range 0 to 1 s
            
            dataTmp= data.Recording{1}.AnalogStream{1}.readPartialChannelData(cfg);
            ChannelsToLoad = obj.ANALYSIS.Firing_Rate_Analysis_channels_with_spikes;
            
            %Original
            %plottingOrder = [21 31 41 51 61 71 12 22 32 42 52 62 72 82 13 23 33 43 53 63 73 83 14 24 34 44 54 64 74 84 15 25 35 45 55 65 75 85 16 26 36 46 56 66 76 86 17 27 37 47 57 67 77 87 28 38 48 58 68 78];
            
            ChanLabelInds = str2double(dataTmp.Info.Label(:));
            
            
            chanInds = [];
            chanTxt = [];
            for k = 1:numel(ChannelsToLoad)
                chanInds(k) = find(ChanLabelInds == ChannelsToLoad(k));
                chanTxt =  [chanTxt num2str(ChannelsToLoad(k)) '-'];
            end
            
            %%
            Fs = 32000;
            recordingDuration_s = double(data.Recording{1,1}.Duration/1e6);
            
            cfg = [];
            cfg.window = [0 recordingDuration_s]; % time
            
            for k = 1:numel(chanInds)
                SpikeData = [];
                
                disp(['Processing chan ' num2str((k)) '/' num2str(numel(chanInds))])
                disp(['Chan: ' num2str(ChannelsToLoad(k))])
                
                thisChan = chanInds(k);
                
                cfg.channel = [thisChan thisChan]; % channel index 5 to 15
                
                chanDataParital= data.Recording{1}.AnalogStream{1}.readPartialChannelData(cfg);
                ChanData = chanDataParital.ChannelData/1e6; %loads all data info
                
                timestamps = chanDataParital.ChannelDataTimeStamps;
                
                
                
                SpikeData  = int16(ChanData*(double(intmax('int16')) / max(abs(ChanData)) ));
                
                %  subplot(2, 1, 1)
                %  plot(ChanData(1:10000))
                %  axis tight
                %  subplot(2, 1, 2)
                %  plot(SpikeData(1:10000))
                %  axis tight
                
                DATA(k,:) = SpikeData;
                
            end
            
            INFO.Channels = ChannelsToLoad;
            INFO.File = fileToLoad;
            INFO.FileName = name;
            
            textName = [name '_CH-' chanTxt '_SpikeData.mat'];
            saveName = [obj.PATH.spikeAnalysis textName];
            save(saveName, 'DATA', 'INFO', '-v7.3')
            
        end
        
        
        function obj = FiringRateAnalysis_makeRasters(obj)
            
            dbstop if error
            %%
            
            [filepath,name,ext] = fileparts(obj.ANALYSIS.h5_fileToLoad);
            
            spikeAnalysis_plotDir = [obj.PATH.spikeAnalysis name '_Plots' obj.PATH.dirD];
            
            obj.PATH.spikeAnalysis_plotDir = spikeAnalysis_plotDir;
           
            
            spikeDir = obj.PATH.spikeAnalysis;
            files = dir(fullfile(spikeDir));
            nFiles = numel(files);
            
            for j = 1:nFiles
                fileNames{j} = files(j).name;
            end
            
            searchString = ['.mat']; % look for the .csv file
            
            matchInds = cellfun(@(x) strfind(x, searchString), fileNames, 'UniformOutput', 0);
            matchIndsPlace = cell2mat(matchInds);
            matchInds_nonempty = find(cellfun(@(x) ~isempty(x), matchInds)==1);
            
            varNames = fileNames(matchInds_nonempty);
            
            list = {varNames{1:end}};
            [indx,tf] = listdlg('PromptString','Choose the spike files to analyze:', 'ListString',list, 'ListSize', [360 100]);
            
            nChansToLoad = numel(indx);
            for j = 1:nChansToLoad
                allChoices{j} = list{indx(j)};
            end
            
         
            %% Load files
            
            timeBlock_s = 30;
            spikeLimit = 60;
            
            for j = 1:nChansToLoad
                
                d = load([spikeDir allChoices{j}]);
                
                fields = fieldnames(d);
                
                %eval(['dataLength = size(d.' cell2mat(fields) ',2)'])
                eval(['units = d.' cell2mat(fields) '(:,2);']);
                eval(['timestamps_s = d.' cell2mat(fields) '(:,3);']);
                eval(['spikeWaveforms = d.' cell2mat(fields) '(:,4:end);']);
                uniqueUnits = unique(units);
                nUnits = numel(uniqueUnits);
                
                allTimestamps_s  = [];
                for o = 1:nUnits
                    thisUnit = uniqueUnits(o);
                    allTimestamps_inds = find(units == thisUnit);
                    allTimestamps_s{o} = timestamps_s(allTimestamps_inds);
                    allSpikeWaveforms{o} = spikeWaveforms(allTimestamps_inds,:);
                    %   meanWaveform{o} = nanmedian(spikeWaveforms(allTimestamps_inds,:), 1);
                end
                
                if j ==1
                    maxTimestamp = max(timestamps_s);
                    maxTime_s = ceil(maxTimestamp);
                    TOn=0:timeBlock_s:maxTime_s;
                end
                
                TimestampsOverChans{j} = allTimestamps_s;
            end
            
            
            %%
            cnt = 1;
            TimestampsFinal = []; ChanNamesFinal = [];
            for j = 1:nChansToLoad
                
                theseTimestamps = TimestampsOverChans{j};
                
                nSpikes = [];
                for k = 1: size(theseTimestamps, 2)
                    timestamps = theseTimestamps{1,k};
                    nSpikes = numel(timestamps);
                    
                    
                    if nSpikes > spikeLimit
                        TimestampsFinal{cnt} = timestamps;
                        ChanNamesFinal{cnt} = ChanName{j};
                        cnt = cnt+1;
                    end
                end
                
            end
            
            p = numSubplots(numel(TimestampsFinal));
            figH = figure(102); clf
            figHH = figure(103); clf
            
            
            for i=1:numel(TimestampsFinal)
                
                timestampsToPlot = TimestampsFinal{i};
                
                cnt = 1;
                figure(figH);
                subplot(p(1),p(2),i)
                hold on
                allSpksFR = [];
                for q = 1:size(TOn, 2)-1
                    spks = timestampsToPlot(find(timestampsToPlot >= TOn(q) & timestampsToPlot <= TOn(q+1)))-TOn(q)';
                    
                    ypoints = ones(1, numel(spks))*cnt;
                    hold on
                    plot(spks, ypoints, 'k.', 'linestyle', 'none', 'MarkerFaceColor','k','MarkerEdgeColor','k')
                    
                    allSpksFR(q) = numel(spks)/timeBlock_s;
                    
                    cnt = cnt +1;
                end
                axis tight
                xlim([0 timeBlock_s]);
                set(gca, 'YDir','reverse')
                title(['Ch-' ChanNamesFinal{i} ' | n = ' num2str(numel(timestampsToPlot))])
                yticks = get(gca, 'ytick');
                yticklabs = yticks*timeBlock_s;
                ytickLabs = num2cell(yticklabs);
                %B=cellfun(@num2str,ytickLabs,'un',0);
                set(gca, 'Yticklabel',ytickLabs)
                xlabel('Time (s)')
                ylabel('Time (s)')
                
                %%
                figure(figHH);
                %subplot(1, 2, 1)
                hold on
                plot(smooth(allSpksFR), 'linewidth', 2)
                %subplot(1, 2, 2)
                %hold on
                %plot(smooth(meanWaveform{i}), 'linewidth', 2)
            end
            figure(figHH);
            axis tight
            xticks = get(gca, 'xtick');
            xticklabs = xticks*timeBlock_s;
            xtickLabs = num2cell(xticklabs);
            
            set(gca, 'Xticklabel',xtickLabs)
            xlabel('Time (s)')
            ylabel('Firing rate (Hz)')
            legend(ChanNamesFinal)
            legend boxoff
            title('Firing Rate')
            
            %% Printing figures
            
%             ctext  ='C';
%             FileSearch = find(file{1}==ctext);
%             ExpDate = file{1}(1:FileSearch-2);
            
            figure(figHH);
            % Create textbox
            annotation(figHH,'textbox',...
                [0.015 0.98 0.20 0.03],...
                'String',{ExpDate},...
                'LineStyle','none',...
                'FitBoxToText','off');
            
            saveName = [spikeAnalysis_plotDir '_CH' ChanText '__FR'];
            plotpos = [0 0 12 10];
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
            
            figure(figH);
            % Create textbox
            annotation(figH,'textbox',...
                [0.015 0.98 0.20 0.03],...
                'String',{ExpDate},...
                'LineStyle','none',...
                'FitBoxToText','off');
            
            saveName = [spikeAnalysis_plotDir '_CH' ChanText '__Raster'];
            plotpos = [0 0 15 12];
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
            
            
            
            
            
            
            
            
            
            
        end
        
        
        
    end
    
    %%
    
    methods (Hidden)
        %class constructor
        function obj = MEA_Analysis_OBJ(analysisDir)
            
            addpath(genpath(analysisDir))
            
            obj = getPathInfo(obj, analysisDir);
            
            
        end
    end
    
end


