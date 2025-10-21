classdef MEA_Analysis_OBJ < handle
    
    
    properties (Access = public)
        
        PATH
        ANALYSIS
        VALID
    end
    
    methods
        
        
        function obj = getPathInfo(obj,analysisDir, hostname)
            
            if ispc
                dirD = '\';
            else
                dirD = '/';
            end
            
            %% adding code paths
            switch hostname
                
                case 'DLC'
                    McsCodePath = 'C:\Users\dlc\Documents\GitHub\McsMatlabDataTools';
                    code2018Path = 'C:\Users\dlc\Documents\GitHub\code2018\';
                    NETCode = 'C:\Users\dlc\Documents\GitHub\NeuralElectrophysilogyTools';
                    
                case 'CSIGA'
                    
                    McsCodePath = '/home/janie/Documents/code/McsMatlabDataTools-master/';
                    code2018Path = '/home/janie/Documents/code/code2018/';
                    NETCode = '/home/janie/Documents/code/NeuralElectrophysilogyTools/';
                    
                    
                case 'TUWZU5Y-2021-5'
                    McsCodePath = 'D:\Github\MCSTools\';
                    code2018Path = 'D:\Github\code2018\';
                    NETCode = 'D:\Github\code2018\NSKToolBox\';
                    
                    
                    
                case 'DESKTOP-PBLRH65' %Zalamander
                    McsCodePath = 'G:\code\Github\McsMatlabDataTools\';
                    code2018Path = 'G:\code\Github\code2018\';
                    NETCode = 'G:\code\Github\code2018\NSKToolBox\';
                    
                otherwise
                    
                    McsCodePath = 'C:\Users\SWR-Analysis\Documents\GitHub\McsMatlabDataTools';
                    code2018Path = 'C:\Users\SWR-Analysis\Documents\GitHub\code2018';
                    NETCode = 'C:\Users\SWR-Analysis\Documents\GitHub\NeuralElectrophysilogyTools';
            end
            
            
            if isfolder(McsCodePath)
                addpath(genpath(McsCodePath));
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
            obj.PATH.analysisDir = analysisDir;
            obj.PATH.mcdFiles = [analysisDir '_mcd_files' dirD];
            obj.PATH.h5Files = [analysisDir '_h5_files' dirD];
            obj.PATH.swrAnalysis = [analysisDir 'SWR_Analysis' dirD];
            obj.PATH.spikeAnalysis = [analysisDir 'Firing_Rate_Analysis' dirD];
            obj.PATH.objSaveDir = [analysisDir 'AnalysisObjects' dirD];
            
            obj.PATH.dirD  = dirD ;
            obj.PATH.hostname  = hostname ;
            
            if exist(obj.PATH.mcdFiles, 'dir') ==0
                mkdir(obj.PATH.mcdFiles );
                disp(['Created directory: ' obj.PATH.mcdFiles ])
            end
            
            if exist(obj.PATH.h5Files, 'dir') ==0
                mkdir(obj.PATH.h5Files );
                disp(['Created directory: ' obj.PATH.h5Files ])
            end
            
%             if exist(obj.PATH.swrAnalysis, 'dir') ==0
%                 mkdir(obj.PATH.swrAnalysis );
%                 disp(['Created directory: ' obj.PATH.swrAnalysis ])
%             end
            
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
            
            
            [filepath,ExpName,ext] = fileparts(h5File);
            
            swrAnalysisDetections_plotDir = [obj.PATH.swrAnalysis ExpName '_Plots' obj.PATH.dirD];
            swrAnalysisDetections_Dir = [obj.PATH.swrAnalysis ExpName '_SWR_Detections' obj.PATH.dirD];
            
            obj.PATH.swrAnalysisDetections_plotDir = swrAnalysisDetections_plotDir;
            obj.PATH.swrAnalysisDetections_Dir = swrAnalysisDetections_Dir;
            
            if exist(swrAnalysisDetections_plotDir, 'dir') ==0
                mkdir(swrAnalysisDetections_plotDir);
                disp(['Created directory: ' swrAnalysisDetections_plotDir])
            end
            
            if exist(swrAnalysisDetections_Dir, 'dir') ==0
                mkdir(swrAnalysisDetections_Dir);
                disp(['Created directory: ' swrAnalysisDetections_Dir])
            end
            
            obj.ANALYSIS.ExpName = ExpName;
            
            
            spikeAnalysis_plotDir = [obj.PATH.spikeAnalysis ExpName '_Plots' obj.PATH.dirD];
            obj.PATH.spikeAnalysis_plotDir = spikeAnalysis_plotDir;
            
            
            if exist(spikeAnalysis_plotDir, 'dir') ==0
                mkdir(spikeAnalysis_plotDir);
                disp(['Created directory: ' spikeAnalysis_plotDir])
            end
            
            
            %%
            
            dlgtitle = 'Please enter noisy channels:';
            answer = inputdlg('Enter space-separated numbers:', dlgtitle, [1 80]);
            
            obj.ANALYSIS.SWR_Analysis_noisy_channels = str2num(answer{1});
            disp(['Noisy channels: ' num2str(obj.ANALYSIS.SWR_Analysis_noisy_channels)])
            
            dlgtitle = 'Please enter 5 channels with SWRs:';
            answer = inputdlg('Enter space-separated numbers:', dlgtitle, [1 80]);
            
            obj.ANALYSIS.SWR_Analysis_SWR_chans = str2num(answer{1});
            disp(['SWR channels: ' num2str(obj.ANALYSIS.SWR_Analysis_SWR_chans)])
            
            dlgtitle = 'Please enter channels with spikes:';
            answer = inputdlg('Enter space-separated numbers:', dlgtitle, [1 80]);
            
            obj.ANALYSIS.Firing_Rate_Analysis_channels_with_spikes = str2num(answer{1});
            disp(['Spiking channels: ' num2str(obj.ANALYSIS.Firing_Rate_Analysis_channels_with_spikes)])
            
        end
        
        
        function obj = addAnalysisInfoToObj_noSWR(obj)
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
            
            
            [filepath,ExpName,ext] = fileparts(h5File);
            
            swrAnalysisDetections_plotDir = [obj.PATH.swrAnalysis ExpName '_Plots' obj.PATH.dirD];
            %swrAnalysisDetections_Dir = [obj.PATH.swrAnalysis ExpName '_SWR_Detections' obj.PATH.dirD];
            
            %obj.PATH.swrAnalysisDetections_plotDir = swrAnalysisDetections_plotDir;
            %obj.PATH.swrAnalysisDetections_Dir = swrAnalysisDetections_Dir;
            
            %             if exist(swrAnalysisDetections_plotDir, 'dir') ==0
            %                 mkdir(swrAnalysisDetections_plotDir);
            %                 disp(['Created directory: ' swrAnalysisDetections_plotDir])
            %             end
            
            %             if exist(swrAnalysisDetections_Dir, 'dir') ==0
            %                 mkdir(swrAnalysisDetections_Dir);
            %                 disp(['Created directory: ' swrAnalysisDetections_Dir])
            %             end
            
            obj.ANALYSIS.ExpName = ExpName;
            
            spikeAnalysis_plotDir = [obj.PATH.spikeAnalysis ExpName '_Plots' obj.PATH.dirD];
            obj.PATH.spikeAnalysis_plotDir = spikeAnalysis_plotDir;
            
            
            if exist(spikeAnalysis_plotDir, 'dir') ==0
                mkdir(spikeAnalysis_plotDir);
                disp(['Created directory: ' spikeAnalysis_plotDir])
            end
            
            
            %%
            
            %             dlgtitle = 'Please enter noisy channels:';
            %             answer = inputdlg('Enter space-separated numbers:', dlgtitle, [1 80]);
            %
            %             obj.ANALYSIS.SWR_Analysis_noisy_channels = str2num(answer{1});
            %             disp(['Noisy channels: ' num2str(obj.ANALYSIS.SWR_Analysis_noisy_channels)])
            %
            %             dlgtitle = 'Please enter 5 channels with SWRs:';
            %             answer = inputdlg('Enter space-separated numbers:', dlgtitle, [1 80]);
            %
            %             obj.ANALYSIS.SWR_Analysis_SWR_chans = str2num(answer{1});
            %             disp(['SWR channels: ' num2str(obj.ANALYSIS.SWR_Analysis_SWR_chans)])
            
            dlgtitle = 'Please enter channels with spikes:';
            answer = inputdlg('Enter space-separated numbers:', dlgtitle, [1 80]);
            
            obj.ANALYSIS.Firing_Rate_Analysis_channels_with_spikes = str2num(answer{1});
            disp(['Spiking channels: ' num2str(obj.ANALYSIS.Firing_Rate_Analysis_channels_with_spikes)])
            
        end
        
        function obj = load_MCS_data_detectSWRs_rippleDetection(obj)
            
            disp('Loading data and detecting SWRs....')
            
            dbstop if error
            doPlot = 1; % will pause the analysis
            
            fileToLoad = obj.ANALYSIS.h5_fileToLoad;
            
            data = McsHDF5.McsData(fileToLoad);
            
            name = obj.ANALYSIS.ExpName;
            
            %swrAnalysisDetections_plotDir = obj.PATH.swrAnalysisDetections_plotDir;
            swrAnalysisDetections_Dir = obj.PATH.swrAnalysisDetections_Dir;
            
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
                        
                        %test = max(diff(smooth(data_rect_rippleBP(winROI))));
                        %test = max(diff(ChanData(winROI)));
                        %                         figure; plot(diff(data_rect_rippleBP(winROI)))
                        %                         figure; plot(data_rect_rippleBP(winROI))
                        %    if test < 0.1 %derivative of the signal should be small for normal data
                        
                        
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
                            plot(time_s(winROI), smooth(data_rect_rippleBP(winROI)));
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
                        %   end
                        
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
                    
                    disp(['Found ' num2str((numel(chanDataROI))) ' SWRs on channel']);
                    
                end
                
                
                AllDetections = [];
                extrachannelDetections = [];
                for runs = 1:15
                    runs
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
                SWR_INFO.chanInds = chanInds;
                
                SWR_INFO.fobj = fobj;
                
                SWR_INFO.WinSizeL = WinSizeL;
                SWR_INFO.WinSizeR = WinSizeR;
                
                disp('Saving.......')
                save([swrAnalysisDetections_Dir name '_RippleData.mat'], 'SWR_INFO', '-v7.3')
                obj.ANALYSIS.SWR_INFO = SWR_INFO;
                disp(['Saved: ' [swrAnalysisDetections_Dir name '_RippleData.mat']])
                
                
            end
        end
        
        function obj = load_MCS_data_detectSWRs_zscore_detection(obj)
            
            disp('Loading data and detecting SWRs....')
            
            dbstop if error
            doPlot = 0; % will pause the analysis
            
            fileToLoad = obj.ANALYSIS.h5_fileToLoad;
            
            data = McsHDF5.McsData(fileToLoad);
            
            name = obj.ANALYSIS.ExpName;
            
            %swrAnalysisDetections_plotDir = obj.PATH.swrAnalysisDetections_plotDir;
            swrAnalysisDetections_Dir = obj.PATH.swrAnalysisDetections_Dir;
            
            %check if ripple data already exists
            if isfile([swrAnalysisDetections_Dir name '_RippleData.mat'])
                
            else
                
                %% For getting the correct channel order
                
                cfg = [];
                cfg.channel = [1 60]; % channel index 5 to 15
                cfg.window = [0 1]; % time range 0 to 1 s
                
                dataTmp= data.Recording{1}.AnalogStream{1}.readPartialChannelData(cfg);
                
                % Original plotting Order
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
                DS_Factor = 20;
                bandPassFilter1 = [1 400];
                Ripple = [6 150];
                
                fObj = filterData(Fs);
                
                fobj.filt.F2=filterData(Fs);
                fobj.filt.F2.downSamplingFactor=DS_Factor; % original is 128 for 32k for sampling rate of 250
                fobj.filt.F2=fobj.filt.F2.designDownSample;
                fobj.filt.F2.padding=true;
                fobj.filt.F2Fs=fobj.filt.F2.filteredSamplingFrequency;
                
                Fss = fobj.filt.F2Fs;
                
                %BandPass 1
                fobj.filt.BP1=filterData(Fss);
                fobj.filt.BP1.highPassCutoff=bandPassFilter1(1);
                fobj.filt.BP1.lowPassCutoff=bandPassFilter1(2);
                fobj.filt.BP1.filterDesign='butter';
                fobj.filt.BP1=fobj.filt.BP1.designBandPass;
                fobj.filt.BP1.padding=true;
                
                %BandPass 1
                fobj.filt.Rip1=filterData(Fss);
                fobj.filt.Rip1.highPassCutoff=Ripple(1);
                fobj.filt.Rip1.lowPassCutoff=Ripple(2);
                fobj.filt.Rip1.filterDesign='butter';
                fobj.filt.Rip1=fobj.filt.Rip1.designBandPass;
                fobj.filt.Rip1.padding=true;
                
                % fobj.filt.SW1=filterData(Fss);
                % fobj.filt.SW1.highPassCutoff=SWFil(1);
                % fobj.filt.SW1.lowPassCutoff=SWFil(2);
                % fobj.filt.SW1.filterDesign='butter';
                % fobj.filt.SW1=fobj.filt.SW1.designBandPass;
                % fobj.filt.SW1.padding=true;
                
                % Original SW filter
                fobj.filt.SW2=filterData(Fss);
                fobj.filt.SW2.lowPassPassCutoff=30;% this captures the LF pretty well for detection
                fobj.filt.SW2.lowPassStopCutoff=40;
                fobj.filt.SW2.attenuationInLowpass=20;
                fobj.filt.SW2=fobj.filt.SW2.designLowPass;
                fobj.filt.SW2.padding=true;
                %
                % fobj.filt.FN =filterData(Fss);
                % fobj.filt.FN.filterDesign='cheby1';
                % fobj.filt.FN.padding=true;
                % fobj.filt.FN=fobj.filt.FN.designNotch;
                
                
                %% Load full channel data
                
                smoothWin_ms = 15;
                smoothWin_sampls = round((smoothWin_ms/1000)*Fss);
                
                recordingDuration_s = double(data.Recording{1,1}.Duration/1e6);
                
                cfg = [];
                cfg.window = [0 recordingDuration_s]; % time
                smoothWin = 0.10*Fs;
                
                DetChanInds = ~ismember(plottingOrder, obj.ANALYSIS.SWR_Analysis_noisy_channels);
                ChansForDetection = plottingOrder(DetChanInds);
                ChanIndsForDetection = chanInds(DetChanInds);
                
                SWR_Analysis_SWR_chans = obj.ANALYSIS.SWR_Analysis_SWR_chans;
                nSWRChans = numel(SWR_Analysis_SWR_chans);
                
                %% Ccomment this out!!
                
                chans_w_SWRs_set = [];
                for k = 1:nSWRChans
                    chans_w_SWRs_set(k) = find(plottingOrder == SWR_Analysis_SWR_chans(k));
                end
                
                ChanData_for_zscore = []; ChanData_for_SW_zscore = [];
                for k = 1:numel(chans_w_SWRs_set)
                    
                    thisChan = chans_w_SWRs_set(k);
                    
                    cfg.channel = [thisChan thisChan]; % channel index 5 to 15
                    
                    chanDataParital= data.Recording{1}.AnalogStream{1}.readPartialChannelData(cfg);
                    ChanData = chanDataParital.ChannelData/1e6; %loads all data info
                    
                    
                    [data_shift_zscore,nshifts] = shiftdim(ChanData,-1);
                    
                    DataSeg_DS = fobj.filt.F2.getFilteredData(data_shift_zscore); % raw data --> downsampled data
                    DataSeg_BP = fobj.filt.BP1.getFilteredData(DataSeg_DS); % downsampled data --> band passed data
                    DataSeg_Ripp = fobj.filt.Rip1.getFilteredData(DataSeg_BP); % notch filted data --> ripple filter
                    
                    ChanData_for_zscore{k} = squeeze(DataSeg_Ripp); %loads all data info
                    
                    %ChanData_for_SW_zscore{k} = squeeze(fobj.filt.SW2.getFilteredData(DataSeg_BP));
                    
                end
                
                allData_zcore = cell2mat(ChanData_for_zscore);
                
                squared_rip = allData_zcore.^2;
                summed_rip = sum(squared_rip, 2);
                smoothedSums2 = smoothdata(summed_rip, 'gaussian', smoothWin_sampls);
                powerTrace_rip = sqrt(smoothedSums2);
                
                
                [Z_sample_rip,mean_sample_rip,std_sample_rip]= zscore(powerTrace_rip);
                mean_zscore_powerTrace_sample = mean(Z_sample_rip);
                
                %% SW
                
                %                 allCHans = cell2mat(ChanData_for_SW_zscore);
                %                 squaredAllSW = allCHans.^2;
                %                 sqrtAllSW = sqrt(squaredAllSW);
                %                 [maxVal, ~] = max(sqrtAllSW, [], 1);
                %                 [maxVal2, SW_ind] = max(maxVal, [], 2);
                %
                %                 sqrt_SW = sqrtAllSW(:,SW_ind);
                %
                %                 [Z_sample_sw,mean_sample_sw,std_sample_sw]= zscore(sqrt_SW);
                %                 mean_zscore_sw_sample = mean(Z_sample_sw);
                %
                
                
                for k = 1:numel(ChansForDetection)
                    %for k = 18
                    
                    
                    disp(['Processing chan ' num2str((k)) '/' num2str(numel(ChansForDetection))])
                    disp(['Chan: ' num2str(ChansForDetection(k))])
                    
                    thisChan = ChanIndsForDetection(k);
                    
                    cfg.channel = [thisChan thisChan]; % channel index 5 to 15
                    
                    chanDataParital= data.Recording{1}.AnalogStream{1}.readPartialChannelData(cfg);
                    ChanData = chanDataParital.ChannelData/1e6; %loads all data info
                    
                    timestamps = chanDataParital.ChannelDataTimeStamps;
                    time_samp = 1:1:numel(timestamps);
                    time_s = time_samp/Fss;
                    
                    %% Filter data
                    
                    [data_shift,nshifts] = shiftdim(ChanData',-2);
                    
                    % Sharp wave
                    [DataSeg_DS, t_s] = fobj.filt.F2.getFilteredData(data_shift_zscore); % raw data --> downsampled data
                    DataSeg_BP = fobj.filt.BP1.getFilteredData(DataSeg_DS); % downsampled data --> band passed data
                    DataSeg_Ripp = fobj.filt.Rip1.getFilteredData(DataSeg_BP); % notch filted data --> ripple filter
                    
                    squared_rip = squeeze(DataSeg_Ripp).^2;
                    smoothedSums2 = smoothdata(squared_rip, 'gaussian', smoothWin_sampls);
                    powerTrace_rip = sqrt(smoothedSums2);
                    zscore_rip = (powerTrace_rip - mean_sample_rip) ./ std_sample_rip;
                    
                    %%
                    
                    minWidth_ms = 10;
                    midWidth_samples = round(minWidth_ms/1000*Fss);
                    thresh = 8;
                    
                    peakDistance_ms = 100;
                    peakDistance_sample = round(peakDistance_ms/1000*Fss);
                    
                    [peakH,peakTime_Fs, peakW, peakP] = findpeaks(zscore_rip, 'MinPeakHeight', thresh, 'MinPeakWidth',  midWidth_samples, 'MinPeakDistance', peakDistance_sample );
                    
                    
                    %% Detect Ripples
                    
                    if isempty(peakH)
                        disp(['No ripples detected on ch ' num2str(plottingOrder(k))])
                    end
                    
                    peakTimes_s = peakTime_Fs/Fss;
                    
                    %% Collecting data Snippets and info
                    
                    WinSizeL = 1*Fss;
                    WinSizeR = 1*Fss;
                    
                    cnt = 1;
                    
                    chanDataROI = []; chanDataROI_T_s = [];
                    chan_peakTime_Fs = []; chan_peakTime_s = [];
                    chan_peakH = []; chan_peakW_Fs = []; chan_peakW_s = []; chan_peakP = [];
                    for q =1:numel(peakTime_Fs)
                        
                        winROI = peakTime_Fs(q)-WinSizeL:peakTime_Fs(q)+WinSizeR;
                        if winROI(1) <0 || winROI(end) > numel(zscore_rip)
                            continue
                        end
                        
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
                            subplot(2, 1, 1)
                            plot(t_s(winROI), squeeze(DataSeg_BP(winROI)));
                            axis tight
                            title('Raw data')
                            % ylim([0 20])
                            
                            subplot(2, 1, 2)
                            % plot(time_s(winROI), ChanData_cond(winROI));
                            hold on
                            plot(t_s(winROI), zscore_rip(winROI), 'k');
                            axis tight
                            title('Z-scored data')
                            ylim([-10 20])
                            
                            pause
                        end
                        
                        cnt = cnt+1;
                        
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
                    
                    disp(['Found ' num2str((numel(chanDataROI))) ' SWRs on channel']);
                    
                end
                
                
                AllDetections = [];
                extrachannelDetections = [];
                for runs = 1:15
                    runs
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
                
                SWR_INFO.plottingOrder = plottingOrder;
                SWR_INFO.chanInds = chanInds;
                
                SWR_INFO.fobj = fobj;
                SWR_INFO.DS_Factor = DS_Factor;
                SWR_INFO.Fs = Fs;
                SWR_INFO.Fss = Fss;
                
                SWR_INFO.WinSizeL = WinSizeL;
                SWR_INFO.WinSizeR = WinSizeR;
                
                disp('Saving.......')
                save([swrAnalysisDetections_Dir name '_RippleData.mat'], 'SWR_INFO', '-v7.3')
                obj.ANALYSIS.SWR_INFO = SWR_INFO;
                disp(['Saved: ' [swrAnalysisDetections_Dir name '_RippleData.mat']])
                
                
            end
        end
        
        function obj = collectAllSWRDetections(obj)
            
            disp('Collecting SWR detections...')
            
            swrAnalysisDetections_Dir = obj.PATH.swrAnalysisDetections_Dir;
            name = obj.ANALYSIS.ExpName;
            
            if isfile([swrAnalysisDetections_Dir name '_RippleData.mat'])
                load([swrAnalysisDetections_Dir name '_RippleData.mat'])
                disp(['Loaded previously saved file: ' [swrAnalysisDetections_Dir name '_RippleData.mat']])
            else
                disp('Please run "load_MCS_data_detectSWRs" first')
                return
            end
            
            if isfile([swrAnalysisDetections_Dir name '-Detections.mat'])
                
                load([swrAnalysisDetections_Dir name '-Detections.mat'])
                disp(['Loaded previously saved file: ' [swrAnalysisDetections_Dir name '-Detections.mat']])
                
                obj.ANALYSIS.SWR_INFO = SWR_INFO;
                obj.ANALYSIS.Detections = D;
                
            else
                
                
                %% load the data
                
                fileToLoad = obj.ANALYSIS.h5_fileToLoad;
                
                data = McsHDF5.McsData(fileToLoad);
                recordingDuration_s = double(data.Recording{1,1}.Duration/1e6);
                
                cfg = [];
                cfg.window = [0 recordingDuration_s]; % time
                
                dataTmp= data.Recording{1}.AnalogStream{1}.readPartialChannelData(cfg);
                
                %% collect all SWR times for all channels:
                AllUniqueDetections = SWR_INFO.AllUniqueDetections;
                nUniqueDetections = numel(AllUniqueDetections);
                
                Fs = SWR_INFO.Fs;
                
                WinSizeL = SWR_INFO.WinSizeL;
                WinSizeR = SWR_INFO.WinSizeR;
                
                ROI_fs = [];
                for o = 1:nUniqueDetections
                    %thisDet = AllUniqueDetections(o);
                    thisDet_dss = AllUniqueDetections(o) * 20;
                    %ROI_fs{o} = thisDet-WinSizeL:thisDet+WinSizeR;
                    ROI_fss{o} = thisDet_dss-WinSizeL:thisDet_dss+WinSizeR;
                end
                
                plottingOrder = SWR_INFO.plottingOrder;
                chanInds = SWR_INFO.chanInds;
                
                AllSWRDataOnChans = [];
                SWR_Detection_fs = [];
                SWR_Detection_s = [];
                
                for k = 1:numel(plottingOrder)
                    
                    disp(['Collecting SWRs ' num2str((k)) '/' num2str(numel(plottingOrder))])
                    thisChan = chanInds(k);
                    cfg.channel = [thisChan thisChan]; % channel index 5 to 15
                    
                    chanDataParital= data.Recording{1}.AnalogStream{1}.readPartialChannelData(cfg);
                    ChanData = chanDataParital.ChannelData/1e6; %loads all data info
                    
                    for j = 1:numel(ROI_fss)
                        thisROI = ROI_fss{j};
                        AllSWRDataOnChans{k,j} = ChanData(thisROI);
                        SWR_Detection_fs(k,j) = AllUniqueDetections(j);
                        SWR_Detection_s(k,j) = AllUniqueDetections(j)/Fs;
                    end
                end
                
                D.AllSWRDataOnChans = AllSWRDataOnChans;
                D.SWR_Detection_fs = SWR_Detection_fs;
                D.SWR_Detection_s = SWR_Detection_s;
                D.plottingOrder = plottingOrder;
                D.channelsNotToInclude = obj.ANALYSIS.SWR_Analysis_noisy_channels;
                D.Fs = Fs;
                %D.timepoints_s = timepoints_s;
                disp('Saving detections...')
                save([swrAnalysisDetections_Dir name '-Detections.mat'], 'D', '-v7.3')
                disp('Saving completed...')
                
                obj.ANALYSIS.SWR_INFO = SWR_INFO;
                obj.ANALYSIS.Detections = D;
            end
        end
        %% Printing figures
        
        function obj =  plotSWRDetection(obj)
            
            Fs = obj.ANALYSIS.SWR_INFO.Fs;
            WinSizeL = obj.ANALYSIS.SWR_INFO.WinSizeL;
            
            timepoints_s = (1:1:WinSizeL*2+1)/Fs;
            xticks = 0:0.2:2;
            xticklabs = -1:0.2:1;
            
            xlabs = [];
            for j = 1:numel(xticklabs)
                xlabs{j} = num2str(xticklabs(j));
            end
            
            AllSWRDataOnChans = obj.ANALYSIS.Detections.AllSWRDataOnChans;
            plottingOrder = obj.ANALYSIS.SWR_INFO.plottingOrder;
            ChannelsToNoTIncludeInDetections = obj.ANALYSIS.SWR_Analysis_noisy_channels;
            
            fObj = obj.ANALYSIS.SWR_INFO.fobj;
            
            
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
            
            name = obj.ANALYSIS.ExpName;
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
                    text(0, toPlot(1)+offsetFil, thisChan)
                    
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
                
                textAnnotation = ['File: ' name ' | SWR Detection: ' num2str(j) ];
                % Create textbox
                annotation(figH,'textbox', [0.01 0.95 0.36 0.03],'String',{textAnnotation}, 'LineStyle','none','FitBoxToText','off');
                
                saveName = [obj.PATH.swrAnalysisDetections_plotDir name '_SWR-stack_' sprintf('%03d',j)];
                figure(figH)
                plotpos = [0 0 25 25];
                print_in_A4(0, saveName, '-djpeg', 0, plotpos);
                
                %%
                figure(figHH)
                textAnnotation = ['File: ' name ' | SWR Detection: '  num2str(j)];
                % Create textbox
                annotation(figHH,'textbox', [0.01 0.95 0.36 0.03],'String',{textAnnotation}, 'LineStyle','none','FitBoxToText','off');
                
                saveName = [obj.PATH.swrAnalysisDetections_plotDir name '_SWR-grid_' sprintf('%03d',j)];
                figure(figHH)
                plotpos = [0 0 25 25];
                
                print_in_A4(0, saveName, '-djpeg', 0, plotpos);
                
            end
            
            close all
            
        end
        
        function obj = validateSWRDetections(obj)
            
            if ~isfield(obj.ANALYSIS.Detections, 'AllSWRDataOnChans')
                if isfile([obj.PATH.swrAnalysisDetections_Dir obj.ANALYSIS.ExpName '-Detections.mat'])
                    load([obj.PATH.swrAnalysisDetections_Dir obj.ANALYSIS.ExpName '-Detections.mat'])
                else
                    disp(['Could not find Detections file: ' [obj.PATH.swrAnalysisDetections_Dir obj.ANALYSIS.ExpName '-Detections.mat']])
                end
            end
            
            D = obj.ANALYSIS.Detections;
            
            Fs = D.Fs;
            WinSizeL = 1*Fs;
            
            AllSWRDataOnChans = D.AllSWRDataOnChans;
            SWR_Detection_s = D.SWR_Detection_s;
            SWR_Detection_fs = D.SWR_Detection_fs;
            
            nDetections = size(AllSWRDataOnChans, 2);
            timepoints_s = (1:1:WinSizeL*2+1)/Fs;
            plottingOrder = D.plottingOrder;
            nInds = size(AllSWRDataOnChans, 2);
            
            
            %%
            spc = figure (200);clf %grid
            
            %% Key Press Function
            set(spc, 'KeyPressFcn', {@SWRValidation_key_press_obj, spc});
            %%
            
            detectionInd = 1;
            allSavedDetectionInds = [];
            setappdata(spc, 'detectionInd', detectionInd);
            setappdata(spc, 'nDetections', nDetections);
            setappdata(spc, 'plottingOrder', plottingOrder);
            setappdata(spc, 'nInds', nInds);
            setappdata(spc, 'Fs', Fs);
            setappdata(spc, 'SWR_Detection_s', SWR_Detection_s);
            setappdata(spc, 'Detection_fs', SWR_Detection_fs);
            
            
            setappdata(spc, 'timepoints_s', timepoints_s);
            setappdata(spc, 'AllSWRDataOnChans', AllSWRDataOnChans);
            
            setappdata(spc, 'allSavedDetectionInds', allSavedDetectionInds);
            setappdata(spc, 'SWRDetectionDir', obj.PATH.swrAnalysisDetections_Dir);
            
            updateGridPlotMEA_OBJ(obj, spc);
            
            
        end
        
        function [] = updateGridPlotMEA_OBJ(obj, spc)
            
            AllSWRDataOnChans = getappdata(spc, 'AllSWRDataOnChans');
            
            timepoints_s = getappdata(spc, 'timepoints_s');
            plottingOrder = getappdata(spc, 'plottingOrder');
            detectionInd = getappdata(spc, 'detectionInd');
            nInds = getappdata(spc, 'nInds');
            Fs = getappdata(spc, 'Fs');
            
            figure(spc); clf
            disp('Updating plot....')
            
            DS_Factor = 20;
            
            fObj = filterData(Fs);
            
            fobj.filt.F2=filterData(Fs);
            fobj.filt.F2.downSamplingFactor=DS_Factor; % original is 128 for 32k for sampling rate of 250
            fobj.filt.F2=fobj.filt.F2.designDownSample;
            fobj.filt.F2.padding=true;
            fobj.filt.F2fs=fobj.filt.F2.filteredSamplingFrequency;
            for k = 1:   size(AllSWRDataOnChans, 1)
                
                toPlot = AllSWRDataOnChans{k,detectionInd};
                
                [data_shift,nshifts] = shiftdim(toPlot',-2);
                [data_F2, t_s] = (fobj.filt.F2.getFilteredData(data_shift));% 1-2000 BP
                data_F2 = squeeze(data_F2);
                
                %% Grid pattern
                
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
                
                plot(t_s, data_F2, 'k');
                
                thisChan = num2str(plottingOrder(k));
                title(thisChan)
                grid('on')
                axis tight
                ylim([-40 20])
                
            end
            allSavedDetectionInds = getappdata(spc, 'allSavedDetectionInds');
            
            if ismember(detectionInd, allSavedDetectionInds)
                textAnnotation = ['SWR Detection: ' num2str(detectionInd) '/' num2str(nInds) '-- Detected'];
            else
                textAnnotation = ['SWR Detection: ' num2str(detectionInd) '/' num2str(nInds)];
            end
            % Create textbox
            annotation(spc,'textbox', [0.5 0.95 0.36 0.03],'String',{textAnnotation}, 'LineStyle','none','FitBoxToText','off');
            
            disp('Finished....')
        end
        
        function obj = calculateDelaysfromValidSWRs_makePlots(obj)
            
            
            validSWRSFile = [obj.PATH.swrAnalysisDetections_Dir 'Validated_SWRs.mat'];
            load(validSWRSFile);
            
            
            figSaveDir = [obj.PATH.swrAnalysisDetections_plotDir];
            
            SWRs=allValidatedSWRS;
            %chansNotToPlot = obj.ANALYSIS.SWR_Analysis_noisy_channels;
            chansNotToPlot = [];
            plottingOrder = obj.ANALYSIS.SWR_INFO.plottingOrder;
            NoDetChanInds = ismember(plottingOrder, chansNotToPlot);
            
            %% reorganizing the data in matrices and SWR trough detection
            
            % designing a filter for extraction of low frequenc ? component of each
            % SWR, the sharp wave (e.g. 20-40 Hz)
            
            [b1,a1] = butter(2,[150 400]/(Fs/2)); % ripple burst spectral range
            [b2,a2] = butter(2,[.2 20]/(Fs/2)); % sharp wave range
            
            %%
            
            nSWRCounts = size(SWRs, 2);
            
            for j = 1:nSWRCounts
                % reading from the cell, filtering, and rearranging in a 3D matrix
                swr_count=j;
                
                for chnl=1:size(SWRs,1)
                    SWR(:,chnl)=SWRs{chnl,swr_count};
                end
                
                % we filter the data to just extract the low-frequency component,
                % the Sharp Wave, and to detect the trough based on it
                ripple=filtfilt(b1,a1,SWR);
                sharp_wave=filtfilt(b2,a2,SWR);
                
                ripples_mat(:,:,swr_count)=ripple;
                sharp_wave_mat(:,:,swr_count)=sharp_wave;
                
                
                %% plotting one SWR for all channels
                dist=10; % distance between channels for the plottring %???????????????????
                
                col_g = [0 .4 .2];
                col_r = [1 .5 .6];
                col_gr = [.9 .9 .9];
                
                FigH = figure(100); clf
                
                for chnl=1:size(SWRs,1)
                    
                    match =  NoDetChanInds(chnl);
                    
                    subplot(1,2,1) % first subplot Sharp Wave
                    hold on
                    if match
                        
                        plot((1:length(sharp_wave_mat(:,:,swr_count)))/Fs,sharp_wave_mat(:,chnl,swr_count)-dist*chnl,...
                            'color', col_gr);
                        
                        thisChan = num2str(plottingOrder(chnl));
                        text(0.5, sharp_wave_mat(chnl,swr_count)-dist*chnl, thisChan)
                        
                        % continue
                        disp('')
                    else
                        
                        plot((1:length(sharp_wave_mat(:,:,swr_count)))/Fs,sharp_wave_mat(:,chnl,swr_count)-dist*chnl,...
                            'color', col_g);
                        
                        thisChan = num2str(plottingOrder(chnl));
                        text(0.5, sharp_wave_mat(chnl,swr_count)-dist*chnl, thisChan)
                        
                    end
                    
                    
                    subplot(1,2,2) % second subplot Sharp wave and Ripples
                    hold on
                    if match
                        
                        
                        plot((1:length(ripples_mat(:,:,swr_count)))/Fs,.5*ripples_mat(:,chnl,swr_count)-dist*chnl,...
                            'color',col_gr);
                        plot((1:length(sharp_wave_mat(:,:,swr_count)))/Fs,sharp_wave_mat(:,chnl,swr_count)-dist*chnl,...
                            'color',col_gr );
                    else
                        plot((1:length(ripples_mat(:,:,swr_count)))/Fs,.5*ripples_mat(:,chnl,swr_count)-dist*chnl,...
                            'color',col_r);
                        plot((1:length(sharp_wave_mat(:,:,swr_count)))/Fs,sharp_wave_mat(:,chnl,swr_count)-dist*chnl,...
                            'color',col_g );
                    end
                    
                    
                    hold on
                    
                    
                end
                figure(FigH)
                subplot(1,2,1)
                axis tight
                %yticks(dist*(-chnl:4:-1));
                % yticklabels(num2cell(1:4:chnl));
                yticklabels([]);
                xlim([.5 1.5])
                ylim([-600 0])
                ylabel('channels')
                xlabel('Time (sec)');
                title(['Raw Data: ' obj.ANALYSIS.ExpName ' SWR: ' num2str(swr_count) ]);
                
                subplot(1,2,2)
                % yticks(dist*(-chnl:4:-1));
                %yticklabels({});
                yticklabels([]);
                xlim([.5 1.5])
                ylim([-600 0])
                xlabel('Time (sec)');
                
                %%
                
                %
                % saveName = [figSaveDir 'RawData__' sprintf('%03d', j)];
                % plotpos = [0 0 12 18];
                % print_in_A4(0, saveName, '-djpeg', 0, plotpos);
                
                
                %% extracting the ripple envelope, plotting 1 SWR along channels
                % extracting the trough times across channels
                t_trough_ind = [];
                for chnl=1:size(sharp_wave_mat,2)
                    %[~,t_trough_ind(chnl)]=min(sharp_wave_mat(:,chnl,swr_count),[],'all','linear');
                    match =  NoDetChanInds(chnl); % we do not look for the mins in the noisy channels
                    if ~match
                        [~,t_trough_ind(chnl)]=min(sharp_wave_mat(:,chnl,swr_count));
                    else
                        
                        t_trough_ind(chnl)=nan;
                    end
                end
                %t_trough=(t_trough_ind-min(t_trough_ind,[],'all'))/fs;
                t_trough=(t_trough_ind-min(t_trough_ind))/Fs;
                
                % ripple envelope and plot with sharp waves
                win_len=round(Fs/20) ; % sliding window for the RMS envelope
                [up,lo] = envelope(ripples_mat(:,:,swr_count),win_len,'rms');
                
                % plotting one SW and ripple envelopes for all channels
                dist=20; % distance between channels for the plottring %???????????????????
                samps=1:1:length(SWR);
                t_plot=samps/(Fs/1)-1;
                
                %%
                figure(103); clf
                chnls=1:59; % channels to plot
                %for chnl=chnls %size(SWRs,1)
                for chnl=1:59 %size(SWRs,1)
                    
                    subplot(1,4,2); % for the sharp wave and ripples envelope
                    
                    thisChan = num2str(plottingOrder(chnl));
                    match =  NoDetChanInds(chnl); % we do not look for the mins in the noisy channels
                    
                    if ~match
                        plot(t_plot,ripples_mat(samps,chnl,swr_count)-dist*chnl,'color',col_r);     hold on
                        plot(t_plot,up(samps,chnl)-dist*chnl,t_plot,lo(samps,chnl)-dist*chnl,'color',[.5 0 0]);
                        text(-0.5, sharp_wave_mat(chnl,swr_count)-dist*chnl, thisChan)
                    else
                        plot(t_plot,ripples_mat(samps,chnl,swr_count)-dist*chnl,'color',col_gr);     hold on
                        plot(t_plot,up(samps,chnl)-dist*chnl,t_plot,lo(samps,chnl)-dist*chnl,'color',col_gr);
                        text(-0.5, sharp_wave_mat(chnl,swr_count)-dist*chnl, thisChan)
                    end
                    
                    
                    subplot(1,4,1) % for the sharp wave and the ripples
                    if ~match
                        plot(t_plot,ripples_mat(samps,chnl,swr_count)-dist*chnl,'color',col_r);     hold on
                        plot(t_plot,sharp_wave_mat(samps,chnl,swr_count)-dist*chnl,'color',col_g);
                        text(-0.5, sharp_wave_mat(chnl,swr_count)-dist*chnl, thisChan)
                    else
                        plot(t_plot,ripples_mat(samps,chnl,swr_count)-dist*chnl,'color',col_gr);     hold on
                        plot(t_plot,sharp_wave_mat(samps,chnl,swr_count)-dist*chnl,'color',col_gr);
                        text(-0.5, sharp_wave_mat(chnl,swr_count)-dist*chnl, thisChan)
                    end
                    
                end
                
                subplot(1,4,1)
                % yticks(dist*(chnls(1):4:chnls(end)));
                % yticklabels(num2cell(chnls(1):4:chnls(end)));
                ylabel('channels')
                yticklabels([]);
                xlim([-.5 .5])
                % ylim(dist*[chnls(1)-1 chnls(end)+1])
                ylim([-1200 0])
                xlabel('Time (sec)');
                title(['Raw Data: ' obj.ANALYSIS.ExpName  ' SWR: ' num2str(swr_count) ]);
                
                
                subplot(1,4,2);
                yticks([]);
                xlim([-.5 .5])
                %ylim(dist*[chnls(1)-1 chnls(end)+1])
                ylim([-1200 0])
                xlabel('Time (sec)');
                
                
                %%
                
                % threshold for ripple detection
                %tr=median(up)+3.0*iqr(up);
                
                tr=median(up)+2*iqr(up);
                t0=ones(1,length(chnls));
                
                hold on
                % adding the threshold to the subplot 1
                %for chnl=chnls
                %searchROI = 25500:40000; % -.25s to +.25 s
                searchROI = 30000:40000; % -.25s to +.25 s
                
                for chnl=1:59
                    
                    thisChan = num2str(plottingOrder(chnl));
                    match =  NoDetChanInds(chnl); % we do not look for th
                    
                    
                    t_0=find(up(searchROI,chnl)>tr(chnl),1) +searchROI(1); % time index of the first supra threshold detection
                    %t_0=find(up(:,chnl)>tr(chnl),1); % time index of the first supra threshold detection
                    if ~isempty(t_0)
                        if t_0>.7*Fs && t_0<1.2*Fs
                            t0(chnl-chnls(1)+1)=t_0;  % fist supra-threshold sample for each channel
                        end
                        subplot(1,4,1)
                        plot(t_plot(t0(chnl-chnls(1)+1)),up(t0(chnl-chnls(1)+1),chnl)-dist*chnl,'color',[.4 .0 .4],'marker','s','markersize',5);
                        
                        subplot(1,4,2)
                        plot(t_plot(t0(chnl-chnls(1)+1)),up(t0(chnl-chnls(1)+1),chnl)-dist*chnl,'color',[.4 .0 .4],'marker','s','markersize',5);
                        
                    end
                    if match
                        t0(chnl-chnls(1)+1) = nan;
                    end
                end
                
                title('Ripple Onset Detection');
                
                t00=t0/Fs; % in s
                
                %%
                %     saveName = [figSaveDir 'Detections__' sprintf('%03d', j)];
                %     plotpos = [0 0 15 18];
                %     print_in_A4(0, saveName, '-djpeg', 0, plotpos);
                
                %figure; plot(up(searchROI,chnl))
                %% delay map visualization
                
                % the time when the SWR has been detected in a channel first, is the reference time, or zero
                % delay, and we consider the time of observation of the SWR in the other
                % channels as the daly of the spread of the SWR, so we subtract the t_min
                % from all the t_delays
                sorted_t00=unique(sort(t00));
                %t00_min=sorted_t00(3); % after sorting the delay times, the first one is 0 (or 1/Fs) which is associated ...
                t00_min=sorted_t00(2);
                
                medianTime = nanmedian(sorted_t00(1:end));
                % diffT = medianTime-t00_min;
                
                AllDiffsFromMedian = medianTime - sorted_t00;
                
                %TInd = find(AllDiffsFromMedian < 0.17); % look for the first ind where the diff between median is < 110 ms
                TInd = find(AllDiffsFromMedian < 0.15); % look for the first ind where the diff between median is < 110 ms
                
                t00_min=sorted_t00(TInd(1));
                
                
                %%
                
                whichInd = find(t00 == t00_min);
                firstChan = plottingOrder(whichInd);
                
                % with the channels with no detected SWR.
                t0=t00-t00_min;
                
                allzeros = find(t0 < 0); % chans with no detections
                
                
                t0NoZeros = t0;
                t0NoZeros(allzeros) = nan;
                % constructing the grid of coordinates based on the paddings of our
                % recording micro array electorde
                % z matrix, regarding the fact that some of the entries in the 8x8 array
                % are not active electrodes, we can assign any random value, i.e. random delay, to those places, just to be able to
                % make a complete matrix. To keep the continuity, we assign a neighboring values to those entries.
                % At the end we do not consider those places on the final plot
                
                toT0 = t0NoZeros;
                %  toT0 = t0;
                zz = [];
                %zz=[t0(5) t0(1:3) t0(3) t0(4:5) t0(5) t0(6:53) t0(54) t0(54:59) t0(59)];
                zz=[ nan toT0(1:6) nan toT0(7:30) nan toT0(31:53) nan toT0(54:59) nan ];
                z=reshape(zz,8,8)';
                
                
                zX=[ nan plottingOrder(1:6) nan plottingOrder(7:30) nan plottingOrder(31:53) nan plottingOrder(54:59) nan ];
                zZ=reshape(zX,8,8)';
                
                %max_val=max(z,[],'all');
                %min_val=min(z,[],'all');
                %max_val=max(max(z));
                %min_val=min(min(z));
                %imagesc([0 7*spacing],[0 7*spacing],z,clim); colormap(cmap); axis equal
                %%
                %figure0=figure(301); clf
                subplot(1, 4, [3 4])
                %cmap=summer;
                %cmap=flipud(pink);
                cmap=flipud(copper);
                colormap(cmap)
                
                clims = [0 .35];
                
                
                zToPlot = flipud(z);
                [row, col] = find(zToPlot == 0);
                %zToPlot = z;
                [nr,nc] = size(zToPlot);
                pcolor([zToPlot nan(nr,1); nan(1,nc+1)]);
                %shading flat;
                colorbar
                hold on
                plot(col+.5, row+.5, 'k*')
                caxis(clims);
                
                % Label the names
                
                cnt =1;
                for rows = [8 7 6 5 4 3 2 1]
                    for cols  = [1 2 3 4 5 6 7 8]
                        
                        if rows == 8 && cols == 1
                            
                        elseif rows == 8 && cols ==8
                            
                        elseif rows == 8 && cols ==8
                            
                        elseif rows == 4 && cols ==1
                            
                        elseif rows == 1 && cols ==1
                            
                        elseif rows == 1 && cols ==8
                            
                        else
                            text(cols+.3, rows+.8, num2str(plottingOrder(cnt)))
                            cnt = cnt +1;
                        end
                    end
                end
                
                
                title([obj.ANALYSIS.ExpName ' SWR ' num2str(swr_count) ': Delay map']);
                %xlabel('x (\mu m)','fontweight','bold')
                %ylabel('y (\mu m)','fontweight','bold')
                a = colorbar;
                a.Label.String = 'delay (sec)';
                axis off
                
                saveName = [figSaveDir 'DataDelayMap__' sprintf('%03d', swr_count)];
                plotpos = [0 0 30 15];
                print_in_A4(0, saveName, '-djpeg', 0, plotpos);
                % print_in_A4(0, saveName, '-depsc', 0, plotpos);
                
                %% Detection Info To Save
                
                Det.ripples_mat = ripples_mat;
                Det.sharp_wave_mat = sharp_wave_mat;
                Det.up = up;
                Det.lo = lo;
                Det.tr = tr;
                Det.plottingOrder = plottingOrder;
                Det.chansNotToPlot = chansNotToPlot;
                Det.t_plot = t_plot;
                Det.firstChan = firstChan;
                Det.medianTime = medianTime;
                Det.t00 = t00;
                Det.t00_min = t00_min;
                Det.t0 = t0;
                Det.t0NoZeros = t0NoZeros;
                Det.z = z;
                Det.zToPlot = zToPlot;
                
                save([obj.PATH.swrAnalysisDetections_Dir '_DelayMap_' sprintf('%03d', swr_count) '.mat'], 'Det', '-v7.3')
                
            end
        end
        
        
        
        function obj = load_MCS_data_getLEDStims(obj)
            
            disp('Loading data....')
            
            dbstop if error
            doPlot = 0; % will pause the analysis
            
            fileToLoad = obj.ANALYSIS.h5_fileToLoad;
            
            data = McsHDF5.McsData(fileToLoad);
            
            name = obj.ANALYSIS.ExpName;
            
            %swrAnalysisDetections_plotDir = obj.PATH.swrAnalysisDetections_plotDir;
            swrAnalysisDetections_Dir = obj.PATH.swrAnalysisDetections_Dir;
            
            
            
            %% For getting the correct channel order
            
            cfg = [];
            cfg.channel = [1 60]; % channel index 5 to 15
            cfg.window = [0 1]; % time range 0 to 1 s
            
            dataTmp= data.Recording{1}.AnalogStream{1}.readPartialChannelData(cfg);
            
            cfg = [];
            cfg.window = [0 10]; % time range 0 to 1 s
            cfg.channel = [1 2]; % channel index 5 to 15
            dataTmp2= data.Recording{2}.AnalogStream{1}.readPartialChannelData(cfg);
            % Original plotting Order
            %plottingOrder = [21 31 41 51 61 71 12 22 32 42 52 62 72 82 13 23 33 43 53 63 73 83 14 24 34 44 54 64 74 84 15 25 35 45 55 65 75 85 16 26 36 46 56 66 76 86 17 27 37 47 57 67 77 87 28 38 48 58 68 78];
            
            %Not including ch 15 = reference
            plottingOrder = [21 31 41 51 61 71 12 22 32 42 52 62 72 82 13 23 33 43 53 63 73 83 14 24 34 44 54 64 74 84 25 35 45 55 65 75 85 16 26 36 46 56 66 76 86 17 27 37 47 57 67 77 87 28 38 48 58 68 78];
            
            ChanLabelInds = str2double(dataTmp.Info.Label(:));
            
            chanInds = [];
            for k = 1:numel(plottingOrder)
                chanInds(k) = find(ChanLabelInds == plottingOrder(k));
            end
            
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Firing Rate analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function obj = convertH5DataToPlexonMatlabFormat(obj)
            dbstop if error
            
            %             if doOverride
            %
            %                 dlgtitle = 'Please enter channles with spikes:';
            %                 answer = inputdlg('Enter space-separated numbers:', dlgtitle, [1 80]);
            %
            %                 obj.ANALYSIS.Firing_Rate_Analysis_channels_with_spikes = str2num(answer{1});
            %                 disp(['Spiking channels: ' num2str(obj.ANALYSIS.Firing_Rate_Analysis_channels_with_spikes)])
            %                 ChannelsToLoad =  obj.ANALYSIS.Firing_Rate_Analysis_channels_with_spikes;
            %             else
            %                 ChannelsToLoad = obj.ANALYSIS.Firing_Rate_Analysis_channels_with_spikes;
            %             end
            
            ChannelsToLoad = obj.ANALYSIS.Firing_Rate_Analysis_channels_with_spikes;
            %%
            
            fileToLoad = obj.ANALYSIS.h5_fileToLoad;
            
            data = McsHDF5.McsData(fileToLoad);
            [filepath,name,ext] = fileparts(fileToLoad);
            
            
            %% For getting the correct channel order
            
            cfg = [];
            cfg.channel = [1 60]; % channel index 5 to 15
            cfg.window = [0 1]; % time range 0 to 1 s
            
            dataTmp= data.Recording{1}.AnalogStream{1}.readPartialChannelData(cfg);
            
            
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
            disp(['Saved spike file: ' saveName]);
            
        end
        
        function obj = doAnalysis_Base_Drug_Rec_Comparison(spikeDir, UnitsToAnalyze, obj)
            
            cd(spikeDir);
            
            title_bas = 'Please select baseline file:';
            title_exp = 'Please select experiment file:';
            title_rec = 'Please select recovery file:';
            
            
            [file_bas,path_bas] = uigetfile('*.mat', title_bas);
            [file_exp,path_exp] = uigetfile('*.mat', title_exp);
            [file_rec,path_rec] = uigetfile('*.mat', title_rec);
            
            
                
            %% Find which channel is selected for each file
            
            underscore = '_';
            dot = '.';
            bla = find(file_bas == underscore); % last one will be the channel number
            bladot = find(file_bas == dot);
            basChan = str2double(file_bas(bla(end)+1:bladot-1));
            baseFileName = file_bas(1:bla(1)-1);
            
            bla = find(file_exp == underscore); % last one will be the channel number
            bladot = find(file_exp == dot);
            expChan = str2double(file_exp(bla(end)+1:bladot-1));
            
            bla = find(file_rec == underscore); % last one will be the channel number
            bladot = find(file_rec == dot);
            recChan = str2double(file_rec(bla(end)+1:bladot-1));
            
             PlotDirName = [baseFileName '__BaseDrugRecCommparison_NewPlots'];
                PlotDir = [spikeDir PlotDirName '\'];
                
            
            if ~isequal(basChan,expChan,recChan)
                disp('You did not select the same channels to compare...!')
                keyboard
            else
                thisChannel = basChan;
                
                SaveName = [baseFileName '-CH-' num2str(basChan) '-PharmaSummary' ];
                
                baselineMatfile = file_bas;
                drugMatfile = file_exp;
                recoveryMatfile = file_rec;
                
                %%
                
                bD = load([spikeDir baselineMatfile]);
                dD = load([spikeDir drugMatfile]);
                rD = load([spikeDir recoveryMatfile]);
                
                bD_fields = fieldnames(bD);
                dD_fields = fieldnames(dD);
                rD_fields = fieldnames(rD);
                
                %%
                eval(['bD_units = bD.' cell2mat(bD_fields) '(:,2);']);
                eval(['bD_timestamps_s_all = bD.' cell2mat(bD_fields) '(:,3);']);
                eval(['bD_spikeWaveforms = bD.' cell2mat(bD_fields) '(:,7:end);']);
                
                eval(['dD_units = dD.' cell2mat(dD_fields) '(:,2);']);
                eval(['dD_timestamps_s_all = dD.' cell2mat(dD_fields) '(:,3);']);
                eval(['dD_spikeWaveforms = dD.' cell2mat(dD_fields) '(:,7:end);']);
                
                eval(['rD_units = rD.' cell2mat(rD_fields) '(:,2);']);
                eval(['rD_timestamps_s_all = rD.' cell2mat(rD_fields) '(:,3);']);
                eval(['rD_spikeWaveforms = rD.' cell2mat(rD_fields) '(:,7:end);']);
                
                %% Find the Inds that are the correct spike sorting
                
                bD_chans_present = unique(bD_units);
                dD_chans_present = unique(dD_units);
                rD_chans_present = unique(rD_units);
                
                %% Change this to reflect which units we should actally use
                
                %     bD_chan1_inds = find(bD_units ==1);
                %     dD_chan1_inds = find(dD_units ==1);
                %     rD_chan1_inds = find(rD_units ==1);
                
                bD_chan1_inds = find(ismember(bD_units,UnitsToAnalyze(1)));
                dD_chan1_inds = find(ismember(dD_units,UnitsToAnalyze(2)));
                rD_chan1_inds = find(ismember(rD_units,UnitsToAnalyze(3)));
                
                %bD_chan1_inds = 1:1:numel(bD_units);
                %dD_chan1_inds = 1:1:numel(dD_units);
                %rD_chan1_inds = 1:1:numel(rD_units);
                
                bD_timestamps_s = bD_timestamps_s_all(bD_chan1_inds);
                bD_spikeWaveforms = bD_spikeWaveforms(bD_chan1_inds,:);
                
                %figure; plot(bD_spikeWaveforms')
                
                dD_timestamps_s = dD_timestamps_s_all(dD_chan1_inds);
                dD_spikeWaveforms = dD_spikeWaveforms(dD_chan1_inds,:);
                
                rD_timestamps_s = rD_timestamps_s_all(rD_chan1_inds);
                rD_spikeWaveforms = rD_spikeWaveforms(rD_chan1_inds,:);
                
                %% Find max timestamps
                
                bD_timestamps_s_max = max(bD_timestamps_s_all);
                dD_timestamps_s_max = max(dD_timestamps_s_all);
                rD_timestamps_s_max = max(rD_timestamps_s_all);
                
                minVal = min([ bD_timestamps_s_max dD_timestamps_s_max rD_timestamps_s_max]);
                
                
                
                %%
                timeWin_s = 60;
                tOn = 1:timeWin_s:minVal;
                allSpks = [];
                allFRs = [];
                
                for j = 1:3
                    
                    switch j
                        case 1
                            data = bD_timestamps_s;
                        case 2
                            data = dD_timestamps_s;
                        case 3
                            data = rD_timestamps_s;
                    end
                    
                    spks = [];
                    for k = 1:numel(tOn)-1
                        
                        roi_start = tOn(k);
                        roi_stop = tOn(k)+timeWin_s-1;
                        spks(k) = numel(find(data >= roi_start & data <=roi_stop));
                        
                    end
                    
                    allSpks{j} = spks;
                    allFRs{j} = spks./timeWin_s;
                end
                
                allFRMax = ceil(max(cell2mat(allFRs)));
                datapointsToCompare = size(spks, 2);
                %% Firing Rates per channel max time
                 
                timeWin_s = 60;
                 allFRs_max = [];
                    allSpks_max = [];
                    
                for j = 1:3
                    switch j
                        case 1
                            data = bD_timestamps_s;
                            maxT = bD_timestamps_s_max;
                        case 2
                            data = dD_timestamps_s;
                            maxT = dD_timestamps_s_max;
                        case 3
                            data = rD_timestamps_s;
                            maxT = rD_timestamps_s_max;
                    end
                    
                    
                    tOn = 1:timeWin_s:maxT;
                   
                   
                   spks_max = [];
                    for k = 1:numel(tOn)-1
                        
                        roi_start = tOn(k);
                        roi_stop = tOn(k)+timeWin_s-1;
                        spks_max(k) = numel(find(data >= roi_start & data <=roi_stop));
                        
                    end
                    
                    allSpks_max{j} = spks_max;
                    allFRs_max{j} = spks_max./timeWin_s;
                    
                    allFRMaxMax(j) = max(allFRs_max{j});
                    allMaxTimes(j) = maxT;
                end
                
               FRMaxMax = ceil(max(allFRMaxMax));
                
                
                %% Plotting waveforms
                figH = figure(103); clf
                subplot(3, 6, [1])
                spikeaxis_samp = 1:1:size(bD_spikeWaveforms, 2);
                spikeaxis_ms = spikeaxis_samp/30000*1000;
                
                plot(spikeaxis_ms, bD_spikeWaveforms(1:end,:)', 'k');
                
                
                axis tight
                ylim([-4e4 4e4])
                title(['Baseline: Ch-' num2str(thisChannel) ' ID: ' num2str(UnitsToAnalyze(1))])
                xlabel('Time (ms)')
                ylabel('Waveform')
                legend(['n = ' num2str(size(bD_spikeWaveforms, 1))])
                legend('boxoff')
                
                subplot(3, 6, [7])
                plot(spikeaxis_ms, dD_spikeWaveforms(1:end,:)', 'color',  [0 .5 .5]);
                axis tight
                ylim([-4e4 4e4]) 
                    title(['Drug: Ch-' num2str(thisChannel) ' ID: ' num2str(UnitsToAnalyze(2))])
                xlabel('Time (ms)')
                ylabel('Waveform')
                legend(['n = ' num2str(size(dD_spikeWaveforms, 1))])
                legend('boxoff')
                
                subplot(3, 6, [13])
                plot(spikeaxis_ms, rD_spikeWaveforms(1:end,:)', 'k');
                axis tight
                ylim([-4e4 4e4])
                title(['Recovery: Ch-' num2str(thisChannel) ' ID: ' num2str(UnitsToAnalyze(3))])
                xlabel('Time (ms)')
                ylabel('Waveform')
                legend(['n = ' num2str(size(rD_spikeWaveforms, 1))])
                legend('boxoff')
                
                %% plotting ISI
                
                binEdges = 0:10:500;
                binCenters = binEdges(1:end-1) + diff(binEdges)/2;
                
                subplot(3, 6, [2]) 
                isi_bD = diff(bD_timestamps_s_all);
                isi_bD_ms = isi_bD*1000;
                [counts_bD, ~] = histcounts(isi_bD_ms, binEdges);
                bar(binCenters, counts_bD, 'FaceAlpha', 0.9, 'FaceColor', 'k');
                xlabel('Duration(ms)')
                ylabel('Count')
               title(['Baseline: Ch-' num2str(thisChannel) ' ID: ' num2str(UnitsToAnalyze(1))])
                
                subplot(3, 6, [8]) 
                isi_dD = diff(dD_timestamps_s_all);
                isi_dD_ms = isi_dD*1000;
                [counts_dD, ~] = histcounts(isi_dD_ms, binEdges);
                bar(binCenters, counts_dD, 'FaceAlpha', 0.9, 'FaceColor', [0 .5 .5]);
                xlabel('Duration(ms)')
                ylabel('Count')
                 title(['Drug: Ch-' num2str(thisChannel) ' ID: ' num2str(UnitsToAnalyze(2))])
                
                subplot(3, 6, [14]) 
                isi_rD = diff(rD_timestamps_s_all);
                isi_rD_ms = isi_rD*1000;
                [counts_rD, ~] = histcounts(isi_rD_ms, binEdges);
                bar(binCenters, counts_rD, 'FaceAlpha', 0.9, 'FaceColor', 'k');
                xlabel('Duration(ms)')
                ylabel('Count')
               title(['Recovery: Ch-' num2str(thisChannel) ' ID: ' num2str(UnitsToAnalyze(3))])
                %% PLotting firing rates - Old
              
                %{
                subplot(3, 6, 2)
                plot(allFRs{1}, 'k.', 'linestyle', '-')
                
                axis tight
                ylim([0 allFRMax])
                xlim([0 11])
                xlabel('Time (min)')
                ylabel('Firing Rate (Hz)')
                line([5 5], [0 allFRMax], 'color', [0.5 0.5 0.5], 'linestyle', ':')
                title(['n = ' num2str(size(bD_spikeWaveforms,1)) ' spikes']);
                
                pre = allFRs{1}(1:5);
                post = allFRs{1}(6:end);
                subplot(3, 6, 3);
                toPlot = [mean(pre) ; mean(post)];
                errs = [std(pre) ; std(post)];
                bar(toPlot, 'FaceColor','k')
                hold on
                errorbar([1 2],toPlot,errs,'k','MarkerSize',5,'MarkerEdgeColor','k','MarkerFaceColor','k')
                set(gca, 'xticklabel', {'1st half', '2nd half'})
                ylabel('Firing Rate (Hz)')
                ylim([0 allFRMax])
                %%
                subplot(3, 6, 8)
                plot(allFRs{2}, 'k.', 'linestyle', '-')
                axis tight
                ylim([0 allFRMax])
                xlim([0 11])
                xlabel('Time (min)')
                ylabel('Firing Rate (Hz)')
                line([5 5], [0 allFRMax], 'color', [0.5 0.5 0.5], 'linestyle', ':')
                title(['n = ' num2str(size(dD_spikeWaveforms, 1)) ' spikes']);
                
                pre = allFRs{2}(1:5);
                post = allFRs{2}(6:end);
                subplot(3, 6, 9);
                toPlot = [mean(pre) ; mean(post)];
                errs = [std(pre) ; std(post)];
                bar(toPlot, 'FaceColor',[0 .5 .5])
                hold on
                errorbar([1 2],toPlot,errs,'k','MarkerSize',5,'MarkerEdgeColor','k','MarkerFaceColor','k')
                set(gca, 'xticklabel', {'1st half', '2nd half'})
                ylabel('Firing Rate (Hz)')
                ylim([0 allFRMax])
                %%
                subplot(3, 6, 14)
                plot(allFRs{3}, 'k.', 'linestyle', '-')
                axis tight
                ylim([0 allFRMax])
                xlim([0 11])
                xlabel('Time (min)')
                ylabel('Firing Rate (Hz)')
                line([5 5], [0 allFRMax], 'color', [0.5 0.5 0.5], 'linestyle', ':')
                title(['n = ' num2str(size(rD_spikeWaveforms, 1)) ' spikes']);
                
                pre = allFRs{3}(1:5);
                post = allFRs{3}(6:end);
                subplot(3, 6, 15);
                toPlot = [mean(pre) ; mean(post)];
                errs = [std(pre) ; std(post)];
                bar(toPlot, 'FaceColor','k')
                hold on
                errorbar([1 2],toPlot,errs,'k','MarkerSize',5,'MarkerEdgeColor','k','MarkerFaceColor','k')
                set(gca, 'xticklabel', {'1st half', '2nd half'})
                ylabel('Firing Rate (Hz)')
                ylim([0 allFRMax])
                
                %}
                %%
                
                %% PLotting firing rates - NEW
                subplot(3, 6, 3)
                
                plot(allFRs_max{1}, 'k.', 'linestyle', '-')
                
                axis tight
                ylim([0 FRMaxMax])
                xlim([0 11])
                xlabel('Time (min)')
                ylabel('Firing Rate (Hz)')
                line([datapointsToCompare datapointsToCompare], [0 allFRMax], 'color', [0.5 0.5 0.5], 'linestyle', ':')
                title(['Recording Time = ' num2str(round(allMaxTimes(1))) 's']);
                
                %%
                subplot(3, 6, 9)
                plot(allFRs_max{2}, 'k.', 'linestyle', '-')
                axis tight
                ylim([0 FRMaxMax])
                xlim([0 11])
                xlabel('Time (min)')
                ylabel('Firing Rate (Hz)')
                line([datapointsToCompare datapointsToCompare], [0 allFRMax], 'color', [0.5 0.5 0.5], 'linestyle', ':')
                title(['Recording Time = ' num2str(round(allMaxTimes(2))) 's']);
                
                %%
                subplot(3, 6, 15)
                plot(allFRs_max{3}, 'k.', 'linestyle', '-')
                axis tight
                ylim([0 FRMaxMax])
                xlim([0 11])
                xlabel('Time (min)')
                ylabel('Firing Rate (Hz)')
                line([datapointsToCompare datapointsToCompare], [0 allFRMax], 'color', [0.5 0.5 0.5], 'linestyle', ':')
                title(['Recording Time = ' num2str(round(allMaxTimes(3))) ' s']);
               
                
                %%
                subplot(3, 6, [4 5 6])
                
                xes_n = numel(allFRs{1});
                xes = ones(1, xes_n);
                
                toPlot  = [mean(allFRs{1}) ; mean(allFRs{2}) ; mean(allFRs{3})];
                bar(toPlot)
                hold on
                plot(xes, allFRs{1}, 'k.')
                hold on
                plot(xes*2, allFRs{2}, 'r.')
                plot(xes*3, allFRs{3}, 'k.')
                set(gca, 'xtick', [1 2 3])
                
                    set(gca, 'xticklabel', {'Baseline', 'Drug', 'Recovery'})
                
                xlim([0 4])
                ylim([0 allFRMax])
                title('Firing rate summary')
                ylabel('Firing Rate (Hz)')
                %%
                [h1, p1] = ttest(allFRs{1},  allFRs{2});
                [h2, p2] = ttest(allFRs{3},  allFRs{2});
                [h3, p3] = ttest(allFRs{1},  allFRs{3});
                
                    Name = {'Baseline-Drug';'Recovery-Drug';'Baseline-Recovery'};
                
                h = [h1;h2;h3];
                p = [p1;p2;p3];
                T = table(h,p,'RowNames',Name);
                
                
                ha = subplot(3, 6, [10 11 12 16 17 18]);
                pos = get(ha,'Position');
                un = get(ha,'Units');
                delete(ha)
                
                ht = uitable('Data',T{:,:},'ColumnName',T.Properties.VariableNames,...
                    'RowName',T.Properties.RowNames,'Units', un, 'Position',pos);
                ha = subplot(3, 6, [17 18]);
                title(['T-test statistics - ' SaveName])
                axis off
                %%
                
                plotsaveName = [PlotDir SaveName];
                
                plotpos = [0 0 40 25];
                
                print_in_A4(0, plotsaveName, '-djpeg', 0, plotpos);
            end
            
        end
        
        
        
        
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Saving objects
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        function obj = saveCurrentAnalysis(obj, analysisDir)
            
            objSaveDir = [analysisDir 'AnalysisObjects' obj.PATH.dirD];
            
            if exist(objSaveDir, 'dir') ==0
                mkdir(objSaveDir);
                disp(['Created directory: ' objSaveDir])
            end
            
            obj.PATH.objSaveDir = objSaveDir;
            
            filename = [objSaveDir obj.ANALYSIS.ExpName '__OBJ.mat'];
            
            save(filename, 'obj', '-v7.3');
            disp(['Saved analysis object: ' filename]);
            
        end
        
        function obj = loadAnalysisObject(obj, analysisDir)
            
            ObjFiles = dir(fullfile(obj.PATH.objSaveDir, '*.mat'));
            nFiles = numel(ObjFiles);
            fileNames = [];
            for j = 1:nFiles
                fileNames{j} = ObjFiles(j).name;
            end
            
            list = {fileNames{1:end}};
            
            
            prompt = 'Please choose an analysis object:';
            [indx,tf] = listdlg('PromptString',prompt, 'ListString',list, 'SelectionMode','single', 'ListSize', [400 200]);
            
            SelectedObj = list{indx};
            
            load([obj.PATH.objSaveDir SelectedObj])
            disp(['Loaded analysis object: ' [obj.PATH.objSaveDir SelectedObj]])
        end
        
        
        function obj = FiringRateAnalysis_makeRasters(spikeDir, obj)
            
            dbstop if error
            %%
            
            %             [filepath,name,ext] = fileparts(obj.ANALYSIS.h5_fileToLoad);
            %
            %             spikeAnalysis_plotDir = [obj.PATH.spikeAnalysis name '_Plots' obj.PATH.dirD];
            %
            %             obj.PATH.spikeAnalysis_plotDir = spikeAnalysis_plotDir;
            %
            
            %spikeDir = obj.PATH.spikeAnalysis;
            
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
            
            ChanText = [];
            for j = 1:nChansToLoad
                
                thisName = allChoices{j};
                ChanName{j} = thisName(end-5:end-4);
                ChanText = [ChanText '-' thisName(end-5:end-4)];
            end
            
            %% Load files
            
            timeBlock_s = 30;
            spikeLimit = 0;
            
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
                meanWaveform = [];
                allWaveforms = [];
                for o = 1:nUnits
                    thisUnit = uniqueUnits(o);
                    allTimestamps_inds = find(units == thisUnit);
                    allTimestamps_s{o} = timestamps_s(allTimestamps_inds);
                    allSpikeWaveforms{o} = spikeWaveforms(allTimestamps_inds,:);
                    allWaveforms{o} = spikeWaveforms(allTimestamps_inds,:);
                     %bD_spikeWaveforms = bD_spikeWaveforms(bD_chan1_inds,:);

                     %meanWaveform{o} = nanmedian(spikeWaveforms(allTimestamps_inds,:), 1);
                end
                
                if j ==1
                    maxTimestamp = max(timestamps_s);
                    maxTime_s = ceil(maxTimestamp);
                    TOn=0:timeBlock_s:maxTime_s;
                end
                
                TimestampsOverChans{j} = allTimestamps_s;
                allWaveformsOverChans{j} = allWaveforms; 
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
            figHHC = figure(104); clf;
            
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
                legText{i} = ['Ch-' ChanNamesFinal{i} ' | n = ' num2str(numel(timestampsToPlot))];
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
                colorOrder = get(gca, 'ColorOrder');
                
                hold on
                plot(smooth(allSpksFR), 'linewidth', 2)
                
                figure(figHHC)
                subplot(1, size(allWaveforms,2), i)
                hold on
                plot(allWaveforms{i}', 'color', colorOrder(i,:))
                axis tight   
                ylim([-5e4 5e4])
                 legend(legText{i})
                   legend boxoff
                  xlabel('Samples')
    ylabel('Waveform Amplitue (AU)')
      
            
            title('Waveform')
            end
            
            figure(figHH);
             
            axis tight
            xticks = get(gca, 'xtick');
            xticklabs = xticks*timeBlock_s;
            xtickLabs = num2cell(xticklabs);
            
            set(gca, 'Xticklabel',xtickLabs)
            xlabel('Time (s)')
            ylabel('Firing rate (Hz)')
            legend(legText)
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
                'String',{obj.ANALYSIS.ExpName},...
                'LineStyle','none',...
                'FitBoxToText','off');
            
            saveName = [obj.PATH.spikeAnalysis_plotDir '_CH' ChanText '__FR'];
            plotpos = [0 0 12 6];
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
            
            figure(figH);
            % Create textbox
            annotation(figH,'textbox',...
                [0.015 0.98 0.20 0.03],...
                'String',{obj.ANALYSIS.ExpName},...
                'LineStyle','none',...
                'FitBoxToText','off');
            
            saveName = [obj.PATH.spikeAnalysis_plotDir '_CH' ChanText '__Raster'];
            plotpos = [0 0 15 6];
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
            
             figure(figHHC);
            % Create textbox
            annotation(figH,'textbox',...
                [0.015 0.98 0.20 0.03],...
                'String',{obj.ANALYSIS.ExpName},...
                'LineStyle','none',...
                'FitBoxToText','off');
            
            saveName = [obj.PATH.spikeAnalysis_plotDir '_CH' ChanText '__Waveforms'];
            plotpos = [0 0 15 10];
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
            
            
            
        end
    
    
        function obj = FiringRateAnalysis_singleChannel(spikeDir, obj)
            
            dbstop if error
            %%
            
            %             [filepath,name,ext] = fileparts(obj.ANALYSIS.h5_fileToLoad);
            %
            %             spikeAnalysis_plotDir = [obj.PATH.spikeAnalysis name '_Plots' obj.PATH.dirD];
            %
            %             obj.PATH.spikeAnalysis_plotDir = spikeAnalysis_plotDir;
            %
            
            %spikeDir = obj.PATH.spikeAnalysis;
            
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
            
            ChanText = [];
            for j = 1:nChansToLoad
                
                thisName = allChoices{j};
                ChanName{j} = thisName(end-5:end-4);
                ChanText = [ChanText '-' thisName(end-5:end-4)];
            end
            
            
            PlotDirName = [thisName(1:end-4) '_NewPlots'];
            PlotDir = [spikeDir PlotDirName '\'];
            
             if exist(PlotDir, 'dir') ==0
                mkdir(PlotDir);
                disp(['Created directory: ' PlotDir])
            end
            
            
            %% Load files
            
            timeBlock_s = 30;
            spikeLimit = 0;
            
            for j = 1:nChansToLoad
                
                d = load([spikeDir allChoices{j}]);
                
                fields = fieldnames(d);
                
                %eval(['dataLength = size(d.' cell2mat(fields) ',2)'])
                eval(['units = d.' cell2mat(fields) '(:,2);']);
                eval(['timestamps_s = d.' cell2mat(fields) '(:,3);']);
                eval(['spikeWaveforms = d.' cell2mat(fields) '(:,7:end);']);
                uniqueUnits = unique(units);
                nUnits = numel(uniqueUnits);
                
                allTimestamps_s  = [];
                meanWaveform = [];
                allWaveforms = [];
                for o = 1:nUnits
                    thisUnit = uniqueUnits(o);
                    allTimestamps_inds = find(units == thisUnit);
                    allTimestamps_s{o} = timestamps_s(allTimestamps_inds);
                    allSpikeWaveforms{o} = spikeWaveforms(allTimestamps_inds,:);
                    allWaveforms{o} = spikeWaveforms(allTimestamps_inds,:);
                     %bD_spikeWaveforms = bD_spikeWaveforms(bD_chan1_inds,:);

                     %meanWaveform{o} = nanmedian(spikeWaveforms(allTimestamps_inds,:), 1);
                end
                
                if j ==1
                    maxTimestamp = max(timestamps_s);
                    maxTime_s = ceil(maxTimestamp);
                    TOn=0:timeBlock_s:maxTime_s;
                end
                
                TimestampsOverChans{j} = allTimestamps_s;
                allWaveformsOverChans{j} = allWaveforms; 
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
            
            colorOrder = get(gca, 'ColorOrder');
            offset = 0;
            legText = [];
            for i=1:numel(TimestampsFinal)
                
                subplot(2, 4, [1 3])
                
                timestampsToPlot = TimestampsFinal{i};
                cnt = 1;
                
                %figure(figH);
                
                
                % subplot(p(1),p(2),i)
                hold on
                allSpksFR = [];
                col =  colorOrder(i,:);
                for q = 1:size(TOn, 2)-1
                    spks = timestampsToPlot(find(timestampsToPlot >= TOn(q) & timestampsToPlot <= TOn(q+1)))-TOn(q)';
                    ypoints = ones(1, numel(spks))*cnt;
                    hold on
                    plot(spks, ypoints, 'k.', 'linestyle', 'none', 'MarkerFaceColor',col,'MarkerEdgeColor',col)
                    
                    allSpksFR(q) = numel(spks)/timeBlock_s;
                    
                    cnt = cnt +1;
                end
                
                legText{i} = ['Ch-' ChanNamesFinal{i} ' | n = ' num2str(numel(timestampsToPlot))];
                
                if i == numel(TimestampsFinal)
                    
                    axis tight
                    xlim([0 timeBlock_s]);
                    set(gca, 'YDir','reverse')
                    % title(['Ch-' ChanNamesFinal{i} ' | n = ' num2str(numel(timestampsToPlot))])
                    
                    
                    yticks = get(gca, 'ytick');
                    yticklabs = yticks*timeBlock_s;
                    ytickLabs = num2cell(yticklabs);
                    %B=cellfun(@num2str,ytickLabs,'un',0);
                    set(gca, 'Yticklabel',ytickLabs)
                    xlabel('Time (s)')
                    ylabel('Time (s)')
                    title('Spiking raster')
                    %  legend(legText)
                end
                
                %%
                %figure(figHH);
                subplot(2, 4, [5 6])
                %colorOrder = get(gca, 'ColorOrder');
                
                hold on
                plot(smooth(allSpksFR), 'linewidth', 2, 'color', col)
                
                if i == numel(TimestampsFinal)
                    legend(legText)
                    axis tight
                    xticks = get(gca, 'xtick');
                    xticklabs = xticks*timeBlock_s;
                    xtickLabs = num2cell(xticklabs);
                    
                    set(gca, 'Xticklabel',xtickLabs)
                    xlabel('Time (s)')
                    ylabel('Firing rate (Hz)')
                    legend(legText)
                    legend boxoff
                    title('Firing Rate')
                end
                %%
                %figure(figHHC)
                subplot(2, 4, [4])
                %subplot(1, size(allWaveforms,2), i)
                hold on
                plot(allWaveforms{i}' +offset, 'color', col)
                %axis tight
                %ylim([-5e4 5e4])
                %legend(legText{i})
                %legend boxoff
                
                text(5, offset, ['n = ' num2str(numel(timestampsToPlot))])
                offset = offset +25000;
                
                if i == numel(TimestampsFinal)
                    axis tight
                    xlabel('Samples')
                    ylabel('Waveform Amplitue (AU)')
                    title('Spike Waveforms')
                    %      legend(legText)
                end
                
                %%
                binEdges = 0:10:1000;
                binCenters = binEdges(1:end-1) + diff(binEdges)/2;
                
                subplot(2, 4, [7 8]);
                isi = diff(TimestampsFinal{i});
                isi_ms = isi*1000;
                [counts, ~] = histcounts(isi_ms, binEdges);
                
                hold on
                bar(binCenters, counts, 'FaceAlpha', 0.9, 'FaceColor', col);
                
                if i == numel(TimestampsFinal)
                    legend(legText)
                    title('Inter-spike Interval')
                    ylabel('Count')
                    xlabel('Duration (ms)')
                end
                
            end
            
         
            % Create textbox
            annotation(figH,'textbox',...
                [0.015 0.95 0.20 0.03],...
                'String',{thisName},...
                'LineStyle','none',...
                'FitBoxToText','off');
            
            saveName = [PlotDir 'CH' ChanText '_ChanStats'];
            plotpos = [0 0 20 25];
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
            
          
            
        end  
        
        function obj = combineSpikesInFile_PlotNewFiringRateAnalysis(spikeDir, fileToCombineSpikes, Spike_Counts_To_Combine, obj)
            
            dbstop if error
            %%
            
            fileToLoad = [spikeDir fileToCombineSpikes];
            
            
            PlotDirName = [fileToCombineSpikes(1:end-4) '_CombinedNewPlots'];
            PlotDir = [spikeDir PlotDirName '\'];
            
            if exist(PlotDir, 'dir') ==0
                mkdir(PlotDir);
                disp(['Created directory: ' PlotDir])
            end
            
            
            %% Load files
            
            timeBlock_s = 30;
            spikeLimit = 0;
            
            
            d = load(fileToLoad);
            
            fields = fieldnames(d);
            
            %eval(['dataLength = size(d.' cell2mat(fields) ',2)'])
            eval(['units = d.' cell2mat(fields) '(:,2);']);
            eval(['timestamps_s = d.' cell2mat(fields) '(:,3);']);
            eval(['spikeWaveforms = d.' cell2mat(fields) '(:,7:end);']);
            uniqueUnits = unique(units);
            nUnits = numel(uniqueUnits);
            
            
            UnitsToUse = [];
            cnt= 1;
            for o = 1:nUnits
                thisUnit = uniqueUnits(o);
                allTimestamps_inds = find(units == thisUnit);
                nSpikes = numel(allTimestamps_inds);
                match = ismember(nSpikes, Spike_Counts_To_Combine);
                
                if match == 1
                    
                    UnitsToUse(cnt) = thisUnit;
                     cnt = cnt+1;
                end
                
               
            end
            
            
            %% combine all data;
            
            allTimestamps_inds_new = find(ismember(units, UnitsToUse));
            
            allTimestamps_s = timestamps_s(allTimestamps_inds_new);
            allSpikeWaveforms = spikeWaveforms(allTimestamps_inds_new,:);
            allWaveforms = spikeWaveforms(allTimestamps_inds_new,:);
            
            
            
            
            maxTimestamp = max(timestamps_s);
            maxTime_s = ceil(maxTimestamp);
            TOn=0:timeBlock_s:maxTime_s;
            
            
            TimestampsOverChans = {allTimestamps_s};
            allWaveformsOverChans = {allWaveforms};
            
            nChansToLoad = 1;
            
            %%
            
            figH = figure(102); clf
            
            colorOrder = get(gca, 'ColorOrder');
            offset = 0;
            legText = [];
            for i=1:numel(TimestampsOverChans)
                
                subplot(2, 4, [1 3])
                
                timestampsToPlot = TimestampsOverChans{i};
                cnt = 1;
                
                %figure(figH);
                
                
                % subplot(p(1),p(2),i)
                hold on
                allSpksFR = [];
                col =  colorOrder(i,:);
                for q = 1:size(TOn, 2)-1
                    spks = timestampsToPlot(find(timestampsToPlot >= TOn(q) & timestampsToPlot <= TOn(q+1)))-TOn(q)';
                    ypoints = ones(1, numel(spks))*cnt;
                    hold on
                    plot(spks, ypoints, 'k.', 'linestyle', 'none', 'MarkerFaceColor',col,'MarkerEdgeColor',col)
                    
                    allSpksFR(q) = numel(spks)/timeBlock_s;
                    
                    cnt = cnt +1;
                end
                
                %  legText{i} = ['Ch-' ChanNamesFinal{i} ' | n = ' num2str(numel(timestampsToPlot))];
                
                if i == numel(TimestampsOverChans)
                    
                    axis tight
                    xlim([0 timeBlock_s]);
                    set(gca, 'YDir','reverse')
                    % title(['Ch-' ChanNamesFinal{i} ' | n = ' num2str(numel(timestampsToPlot))])
                    
                    
                    yticks = get(gca, 'ytick');
                    yticklabs = yticks*timeBlock_s;
                    ytickLabs = num2cell(yticklabs);
                    %B=cellfun(@num2str,ytickLabs,'un',0);
                    set(gca, 'Yticklabel',ytickLabs)
                    xlabel('Time (s)')
                    ylabel('Time (s)')
                    title('Spiking raster')
                    %  legend(legText)
                end
                
                %%
                %figure(figHH);
                subplot(2, 4, [5 6])
                %colorOrder = get(gca, 'ColorOrder');
                
                hold on
                plot(smooth(allSpksFR), 'linewidth', 2, 'color', col)
                
                if i == numel(TimestampsOverChans)
                    legend(legText)
                    axis tight
                    xticks = get(gca, 'xtick');
                    xticklabs = xticks*timeBlock_s;
                    xtickLabs = num2cell(xticklabs);
                    
                    set(gca, 'Xticklabel',xtickLabs)
                    xlabel('Time (s)')
                    ylabel('Firing rate (Hz)')
                    %  legend(legText)
                    %  legend boxoff
                    title('Firing Rate')
                end
                %%
                %figure(figHHC)
                subplot(2, 4, [4])
                %subplot(1, size(allWaveforms,2), i)
                hold on
                plot(allWaveforms(:,:)' +offset, 'color', col)
                %axis tight
                %ylim([-5e4 5e4])
                %legend(legText{i})
                %legend boxoff
                
                text(5, offset, ['n = ' num2str(numel(timestampsToPlot))])
                offset = offset +25000;
                
                if i == numel(TimestampsOverChans)
                    axis tight
                    xlabel('Samples')
                    ylabel('Waveform Amplitue (AU)')
                    title('Spike Waveforms')
                    %      legend(legText)
                end
                
                %%
                binEdges = 0:10:1000;
                binCenters = binEdges(1:end-1) + diff(binEdges)/2;
                
                subplot(2, 4, [7 8]);
                isi = diff(TimestampsOverChans{i});
                isi_ms = isi*1000;
                [counts, ~] = histcounts(isi_ms, binEdges);
                
                hold on
                bar(binCenters, counts, 'FaceAlpha', 0.9, 'FaceColor', col);
                
                if i == numel(TimestampsOverChans)
                    % legend(legText)
                    title('Inter-spike Interval')
                    ylabel('Count')
                    xlabel('Duration (ms)')
                end
                
            end
            
            thisName = ['CombinedSpikes-' fileToCombineSpikes(1:end-4)];
            % Create textbox
            annotation(figH,'textbox',...
                [0.015 0.95 0.20 0.03],...
                'String',{thisName},...
                'LineStyle','none',...
                'FitBoxToText','off');
            
            saveName = [PlotDir thisName '_ChanStats'];
            plotpos = [0 0 20 25];
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
            
            
            
            %% Save new spike data
            D = [];
            
            newUnitNumber = (ones(1, numel(allTimestamps_s))*5)';
            
            %eval(['D.' fields{:} '(:,1)= d.' fields{:} '(:,1);'])
            %eval(['D.' fields{:} '(:,2)=newUnitNumber'])
            %eval(['D.' fields{:} '(:,3)=allTimestamps_s'])
            %eval(['D.' fields{:} '(:,4:86)=allWaveforms'])
            
            eval(['CSpikes (:,1)= d.' fields{:} '(:,1);'])
            eval('CSpikes(:,2)=newUnitNumber;')
            eval('CSpikes(:,3)=allTimestamps_s;')
            eval('CSpikes(:,4:86)=allWaveforms;')
            
            underscore = '_';
            dot = '.';
            bla = find(fileToCombineSpikes == underscore); % last one will be the channel number
            bladot = find(fileToCombineSpikes == dot);
            basChan = str2double(fileToCombineSpikes(bla(end)+1:bladot-1));
            
            savename = [fileToCombineSpikes(1:bla(3)) 'NewCombined__' num2str(basChan) '.mat'];
            save([spikeDir savename], 'CSpikes', '-v7.3');
            
            
            
        end
        
        
        
    
        function obj = FiringRateAnalysis_singleChannel_Base_Drug_Rec(spikeDir, obj)
            
            
            dbstop if error
            
            title_bas = 'Please select baseline file:';
            title_exp = 'Please select drug file:';
            title_rec = 'Please select recovery file:';
            
            
            [file_bas,path_bas] = uigetfile('*.mat', title_bas);
            [file_exp,path_exp] = uigetfile('*.mat', title_exp);
            [file_rec,path_rec] = uigetfile('*.mat', title_rec);
            
            %% Find which channel is selected for each file
            
            underscore = '_';
            dot = '.';
            bla = find(file_bas == underscore); % last one will be the channel number
            bladot = find(file_bas == dot);
            basChan = str2double(file_bas(bla(end)+1:bladot-1));
            baseFileName = file_bas(1:bla(1)-1);
            
            bla = find(file_exp == underscore); % last one will be the channel number
            bladot = find(file_exp == dot);
            expChan = str2double(file_exp(bla(end)+1:bladot-1));
            
            bla = find(file_rec == underscore); % last one will be the channel number
            bladot = find(file_rec == dot);
            recChan = str2double(file_rec(bla(end)+1:bladot-1));
            
            %%
            
            if ~isequal(basChan,expChan,recChan)
                disp('You did not select the same channels to compare...!')
                keyboard
            else
               
                PlotDirName = [baseFileName '__BaseDrugRecCommparison_NewPlots'];
                PlotDir = [spikeDir PlotDirName '\'];
                
                if exist(PlotDir, 'dir') ==0
                    mkdir(PlotDir);
                    disp(['Created directory: ' PlotDir])
                end
                
                
                %% Load files
                
                allChoices = {file_bas file_exp file_rec};
                nChansToLoad = numel(allChoices);
                 
                timeBlock_s = 30;
                spikeLimit = 0;
                chanNames = [basChan expChan recChan];
                for a = 1:nChansToLoad
                    
                    d = load([spikeDir allChoices{a}]);
                    
                    fields = fieldnames(d);
                    
                    %eval(['dataLength = size(d.' cell2mat(fields) ',2)'])
                    eval(['units = d.' cell2mat(fields) '(:,2);']);
                    eval(['timestamps_s = d.' cell2mat(fields) '(:,3);']);
                    eval(['spikeWaveforms = d.' cell2mat(fields) '(:,7:end);']);
                    uniqueUnits = unique(units);
                    nUnits = numel(uniqueUnits);
                    allUniqueUnits{a} = uniqueUnits;
                    
                    allTimestamps_s  = [];
                    meanWaveform = [];
                    allWaveforms = [];
                    for o = 1:nUnits
                        thisUnit = uniqueUnits(o);
                        allTimestamps_inds = find(units == thisUnit);
                        allTimestamps_s{o} = timestamps_s(allTimestamps_inds);
                        allSpikeWaveforms{o} = spikeWaveforms(allTimestamps_inds,:);
                        allWaveforms{o} = spikeWaveforms(allTimestamps_inds,:);
                        %bD_spikeWaveforms = bD_spikeWaveforms(bD_chan1_inds,:);
                        
                        %meanWaveform{o} = nanmedian(spikeWaveforms(allTimestamps_inds,:), 1);
                    end
                    
                    if a ==1
                        maxTimestamp = max(timestamps_s);
                        maxTime_s = ceil(maxTimestamp);
                        TOn=0:timeBlock_s:maxTime_s;
                    end
                    
                    TimestampsOverChans{a} = allTimestamps_s;
                    allWaveformsOverChans{a} = allWaveforms;
                    
                end
                
                %%
                %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                for j = 1:nChansToLoad
                    cnt = 1;
                    TimestampsFinal = [];
                    
                    theseTimestamps = TimestampsOverChans{j};
                    
                    nSpikes = [];
                    for k = 1: size(theseTimestamps, 2)
                        timestamps = theseTimestamps{1,k};
                        nSpikes = numel(timestamps);
                        
                        
                        if nSpikes > spikeLimit
                            TimestampsFinal{cnt} = timestamps;
                            %  ChanNamesFinal{cnt} = ChanName{j};
                            cnt = cnt+1;
                        end
                    end
                    
                    figH = figure(100+j); clf
                    
                    colorOrder = get(gca, 'ColorOrder');
                    offset = 0;
                    legText = [];
                    
                    for i=1:numel(TimestampsFinal)
                        
                        chanUnitIDs = allUniqueUnits{j};
                        thisUnitID = chanUnitIDs(i,:);
                        subplot(2, 4, [1 3])
                        
                        timestampsToPlot = TimestampsFinal{1, i};
                        cnt = 1;
                        
                        %figure(figH);
                        
                        
                        % subplot(p(1),p(2),i)
                        hold on
                        allSpksFR = [];
                        col =  colorOrder(i,:);
                        for q = 1:size(TOn, 2)-1
                            spks = timestampsToPlot(find(timestampsToPlot >= TOn(q) & timestampsToPlot <= TOn(q+1)))-TOn(q)';
                            ypoints = ones(1, numel(spks))*cnt;
                            hold on
                            plot(spks, ypoints, 'k.', 'linestyle', 'none', 'MarkerFaceColor',col,'MarkerEdgeColor',col)
                            
                            allSpksFR(q) = numel(spks)/timeBlock_s;
                            
                            cnt = cnt +1;
                        end
                        
                        legText{i} = ['Ch-' num2str(chanNames(i)) ' | n = ' num2str(numel(timestampsToPlot)) '| ID = ' num2str(thisUnitID) ];
                        
                        if i == numel(TimestampsFinal)
                            
                            axis tight
                            xlim([0 timeBlock_s]);
                            set(gca, 'YDir','reverse')
                            % title(['Ch-' ChanNamesFinal{i} ' | n = ' num2str(numel(timestampsToPlot))])
                            
                            
                            yticks = get(gca, 'ytick');
                            yticklabs = yticks*timeBlock_s;
                            ytickLabs = num2cell(yticklabs);
                            %B=cellfun(@num2str,ytickLabs,'un',0);
                            set(gca, 'Yticklabel',ytickLabs)
                            xlabel('Time (s)')
                            ylabel('Time (s)')
                            title('Spiking raster')
                            %  legend(legText)
                        end
                        
                        %%
                        %figure(figHH);
                        subplot(2, 4, [5 6])
                        %colorOrder = get(gca, 'ColorOrder');
                        
                        hold on
                        plot(smooth(allSpksFR), 'linewidth', 2, 'color', col)
                        
                        if i == numel(TimestampsFinal)
                            legend(legText)
                            axis tight
                            xticks = get(gca, 'xtick');
                            xticklabs = xticks*timeBlock_s;
                            xtickLabs = num2cell(xticklabs);
                            
                            set(gca, 'Xticklabel',xtickLabs)
                            xlabel('Time (s)')
                            ylabel('Firing rate (Hz)')
                            legend(legText)
                            legend boxoff
                            title('Firing Rate')
                        end
                        %%
                        %figure(figHHC)
                        subplot(2, 4, [4])
                        %subplot(1, size(allWaveforms,2), i)
                        hold on
                        theseWaveforms = allWaveformsOverChans{j};
                        
                        theseWaveformsToPlot = theseWaveforms{1,i};
                        plot(theseWaveformsToPlot' +offset, 'color', col)
                        %axis tight
                        %ylim([-5e4 5e4])
                        %legend(legText{i})
                        %legend boxoff
                        
                        text(5, offset, ['n = ' num2str(numel(timestampsToPlot))])
                        offset = offset+15000;
                        
                        if i == numel(TimestampsFinal)
                            axis tight
                            ylim([-30000 40000])
                            xlabel('Samples')
                            ylabel('Waveform Amplitue (AU)')
                            title('Spike Waveforms')
                            %      legend(legText)
                        end
                        
                        %%
                        binEdges = 0:10:1000;
                        binCenters = binEdges(1:end-1) + diff(binEdges)/2;
                        
                        subplot(2, 4, [7 8]);
                        isi = diff(TimestampsFinal{i});
                        isi_ms = isi*1000;
                        [counts, ~] = histcounts(isi_ms, binEdges);
                        
                        hold on
                        bar(binCenters, counts, 'FaceAlpha', 0.9, 'FaceColor', col);
                        
                        if i == numel(TimestampsFinal)
                            legend(legText)
                            title('Inter-spike Interval')
                            ylabel('Count')
                            xlabel('Duration (ms)')
                        end
                        
                    end
                    
                    switch j
                        case 1
                            thisName = ['Baseline: ' allChoices{j}];
                            
                            desc = 'Baseline';
                        case 2
                            thisName = ['Drug: ' allChoices{j}];
                            desc = 'Drug';
                            
                        case 3
                            thisName = ['Recovery: ' allChoices{j}];
                            desc = 'Rec';
                    end
                    
                    saveNametxt = allChoices{j}(1:end-4);
                    
                    % Create textbox
                    annotation(figH,'textbox',...
                        [0.015 0.95 0.20 0.03],...
                        'String',{thisName},...
                        'LineStyle','none',...
                        'FitBoxToText','off');
                    
                    saveName = [PlotDir saveNametxt '_ChanStats-' desc];
                    plotpos = [0 0 20 25];
                    print_in_A4(0, saveName, '-djpeg', 0, plotpos);
                    
                    
                    
                end
            end
            
        end
        
    end
    
    
    
    
    %%
    
    methods (Hidden)
        %class constructor
        function obj = MEA_Analysis_OBJ(analysisDir)
            
            addpath(genpath(analysisDir))
            
            hostname = gethostname;
            
            obj = getPathInfo(obj, analysisDir, hostname);
            
            
        end
    end
    
end


