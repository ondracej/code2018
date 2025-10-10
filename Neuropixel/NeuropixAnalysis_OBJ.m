classdef NeuropixAnalysis_OBJ < handle
    
    
    properties (Access = public)
        
        PATH
        ANALYSIS
        VALID
    end
    
    methods
        
        
        function obj = getPathInfo(obj)
            
            if ispc
                dirD = '\';
            else
                dirD = '/';
            end
            
            %% adding code paths
            
            
            code2018Path = 'C:\Users\Neuropix\Documents\GitHub\code2018';
            %SpikeGLXTools = 'C:\Users\Neuropix\Documents\GitHub\SpikeGLX_Datafile_Tools';
            npymatlab = 'C:\Users\Neuropix\Documents\code\Github\npy-matlab-master';
            
            
            if isfolder(code2018Path)
                addpath(genpath(code2018Path));
            else
                disp('Please check definition for code2018 path in "getPathInfo"')
            end
            
            %             if isfolder(SpikeGLXTools)
            %                 addpath(genpath(SpikeGLXTools));
            %             else
            %                 disp('Please check definition for SpikeGLXTools path in "getPathInfo"')
            %             end
            
            if isfolder(npymatlab)
                addpath(genpath(npymatlab));
            else
                disp('Please check definition for npymatlab path in "getPathInfo"')
            end
            
            
            % Ask user for binary file
            [lfp_binName, lfp_path] = uigetfile('*.bin', 'Select LFP .bin file');
            [ap_binName, ap_path] = uigetfile('*.bin', 'Select AP .bin file');
            [nidaq_binName, nidaq_path] = uigetfile('*.bin', 'Select Nidaq .bin file');
            [wavfile_Name, wavfile_path] = uigetfile('*.wav', 'Select stimulus .wav file');
            [soundfile_Name, soundfile_path] = uigetfile('*.mat', 'Select stimulus startstop .mat');
            
            
            obj.PATH.lfp_binName = lfp_binName;
            obj.PATH.lfp_path = lfp_path;
            obj.PATH.ap_binName = ap_binName;
            obj.PATH.ap_path = ap_path;
            obj.PATH.nidaq_binName = nidaq_binName;
            obj.PATH.nidaq_path = nidaq_path;
            obj.PATH.soundfile_Name = soundfile_Name;
            obj.PATH.soundfile_path = soundfile_path;
            obj.PATH.wavfile_Name = wavfile_Name;
            obj.PATH.wavfile_path = wavfile_path;
            
            
            obj.PATH.dirD  = dirD ;
            
        end
        
        function [obj] = getStimDurationsFromWavFile(obj)
            
            dbstop if error
            %% Check to wav syn file file already exists
            
            doPlot = 0;
            wavFile = [obj.PATH.wavfile_path obj.PATH.wavfile_Name];
            [filepath,name,ext] = fileparts(wavFile);
            
            saveDir = [filepath obj.PATH.dirD];
            
            
            if isfile([saveDir name '__StartstopsWavFile.mat'])
                disp(['Loading previously saved wav sync file: ' [saveDir name '__StartstopsWavFile.mat']])
                
                load([saveDir name '__StartstopsWavFile.mat'])
                
                obj.ANALYSIS.STIM.Onsets = SS.Onsets;
                obj.ANALYSIS.STIM.Offsets = SS.Offsets;
                obj.ANALYSIS.STIM.Onsets_s = SS.Onsets_s;
                obj.ANALYSIS.STIM.Offsets_s = SS.Offsets_s;
                obj.ANALYSIS.STIM.Durations_s = SS.Durations_s;
                obj.ANALYSIS.STIM.fs_wav = SS.fs_wav;
                
            else
                
                [y,Fs] = audioread(wavFile);
                
                yRMS = rms(y, 2);
                
                %figure; plot(yRMS(60*Fs:60*Fs+100*Fs))
                WavChan_Thresh = 0.1; % might have to change this
                
                WavCrossings_fs = find(yRMS >= WavChan_Thresh);
                WavCrossings_s = WavCrossings_fs/Fs;
                
                WavCrossings_diff_s = diff(WavCrossings_s);
                largeDiffs_inds = find(WavCrossings_diff_s > 1.9);
                %largeWavCrossings_s  = WavCrossings_diff_s(largeDiffs_inds);
                %largeWavCrossings_fs = WavCrossings_fs(largeDiffs_inds);% these are the offsets
                
                thisOnset = []; thisOffset = [];
                cnt = 1;
                
                for j = 1: numel(largeDiffs_inds)
                    
                    if j == 1
                        offsetInd = largeDiffs_inds(j);
                        thisOnset(cnt) = WavCrossings_fs(1);
                        thisOffset(cnt) = WavCrossings_fs(offsetInd);
                    else
                        offsetInd = largeDiffs_inds(j);
                        onsetInd = largeDiffs_inds(j-1) +1;
                        
                        thisOnset(cnt) = WavCrossings_fs(onsetInd);
                        thisOffset(cnt) = WavCrossings_fs(offsetInd);
                        
                    end
                    cnt = cnt+1;
                end
                
                % Adding the last stimulus
                thisOffset(cnt) = WavCrossings_fs(end);
                onsetInd = largeDiffs_inds(end) +1;
                thisOnset(cnt) = WavCrossings_fs(onsetInd);
                
                disp([num2str(numel(thisOnset)) ' onsets found.'])
                disp([num2str(numel(thisOffset)) ' offsets found.'])
                %%
                if doPlot
                    timepoints_fs = 1:1:numel(y);
                    timepoints_s = timepoints_fs / Fs;
                    
                    
                    nSamp = numel(yRMS);
                    seg_s = 55;
                    seg_samp = seg_s*Fs;
                    
                    seg_s_long = 60;
                    seg_samp_long = seg_s_long*Fs;
                    
                    tOn = 1:seg_samp:nSamp;
                    nTon = numel(tOn);
                    
                    for j = 1:nTon
                        if j == nTon
                            ROI = tOn(j): nSamp;
                        else
                            ROI = tOn(j): tOn(j)+seg_samp_long;
                        end
                        
                        allOnsets_inds = find(thisOnset <= ROI(end) & thisOnset >= ROI(1)) ;
                        thisOnset_s = thisOnset ./ Fs;
                        theseOnsets = thisOnset_s(allOnsets_inds);
                        
                        allOffsets_inds = find(thisOffset <= ROI(end) & thisOffset >= ROI(1)) ;
                        thisOffset_s = thisOffset ./ Fs;
                        theseOffsets = thisOffset_s(allOffsets_inds);
                        
                        figure(104); clf
                        subplot(2, 1, 1)
                        plot(timepoints_s(ROI), yRMS(ROI));
                        
                        
                        subplot(2, 1, 2)
                        specgram1((y(ROI)*1.5),513,Fs,400,360);
                        ylim([0 10000])
                        
                        subplot(2, 1, 1)
                        hold on
                        plot(theseOnsets, .2, 'rv')
                        plot(theseOffsets, .2, 'kv')
                        axis tight
                        %
                        pause
                    end
                end
                
                %%
                allDurs = thisOffset - thisOnset;
                allDurs_s = allDurs/Fs;
                
                obj.ANALYSIS.STIM.Onsets = thisOnset;
                obj.ANALYSIS.STIM.Offsets = thisOffset;
                obj.ANALYSIS.STIM.Onsets_s = thisOnset/Fs;
                obj.ANALYSIS.STIM.Offsets_s = thisOffset/Fs;
                obj.ANALYSIS.STIM.Durations_s = allDurs_s;
                obj.ANALYSIS.STIM.fs_wav = Fs;
                
                SS.wavFilename = name;
                SS.Onsets = thisOnset;
                SS.Offsets = thisOffset;
                SS.Onsets_s = thisOnset/Fs;
                SS.Offsets_s = thisOffset/Fs;
                SS.Durations_s = allDurs_s;
                SS.fs_wav = Fs;
                SS.wavThresh = WavChan_Thresh;
                
                save([saveDir name '__StartstopsWavFile'], 'SS')
            end
        end
        
        
        function obj = loadNidaqFindStimEdges(obj)
            
            if isfile([obj.PATH.nidaq_path obj.PATH.nidaq_binName(1:end-9)  '__NiDaqStimSync.mat'])
                disp(['Loading previously saved nidaq sync file: ' [obj.PATH.nidaq_path obj.PATH.nidaq_binName(1:end-9)  '__NiDaqStimSync']])
                
                load([obj.PATH.nidaq_path obj.PATH.nidaq_binName(1:end-9)  '__NiDaqStimSync.mat'])
                
                
                %obj.ANALYSIS.StimOnsets_fs_nidaq = SS_nidaq.StimOnsets;
                %obj.ANALYSIS.StimOffsets_fs_nidaq = SS_nidaq.StimOffsets;
                obj.ANALYSIS.allOnsets_fs_nidaq = SS_nidaq.allOnsets_fs_nidaq;
                obj.ANALYSIS.allOffsets_fs_nidaq = SS_nidaq.allOffsets_fs_nidaq;
                obj.ANALYSIS.StimNames = SS_nidaq.Stimnames;
            else
                
                doPlot = 0;
                
                Onsets_s = obj.ANALYSIS.STIM.Onsets_s;
                Offsets_s = obj.ANALYSIS.STIM.Offsets_s;
                
                soundfile_Name = obj.PATH.soundfile_Name;
                soundfile_path = obj.PATH.soundfile_path;
                
                sound = load([soundfile_path soundfile_Name]);
                
                names = fieldnames(sound);
                nNames = numel(names);
                allStims = [];
                cnt = 1;
                for o = 1:nNames-1
                    
                    eval(['stim = sound.' names{o}])
                    
                    if ~isempty(stim)
                        allStims{cnt} = cell2mat(stim);
                        cnt = cnt+1;
                    end
                end
                
                allStims1 = sort(allStims{1,2}) - sort(allStims{1, 1}); % N1
                allStims2 = sort(allStims{1,4}) - sort(allStims{1, 3}); % BOS
                allStims3 = sort(allStims{1,6}) - sort(allStims{1, 5}); % CON
                allStims4 = sort(allStims{1,8}) - sort(allStims{1, 7}); % N2
                allStims5 = sort(allStims{1,10}) - sort(allStims{1, 9}); % REV
                
                %%
                nidaq_binName = obj.PATH.nidaq_binName;
                nidaq_path = obj.PATH.nidaq_path;
                
                [nidaq_meta] = ReadMeta(obj, nidaq_binName, nidaq_path);
                
                fs_ni = str2double(nidaq_meta.niSampRate);
                nSamp = floor(str2num(nidaq_meta.fileTimeSecs) * fs_ni);
                nidaq_dataArray = ReadBin(obj, 1, nSamp, nidaq_meta, nidaq_binName, nidaq_path);
                
                WavChan = nidaq_dataArray(1,:);
                
                %%
                
                %figure; plot(WavChan(1*fs_ni:50*fs_ni))
                
                WavChan_Thresh = 15;
                
                WavCrossings_fs = find(WavChan(1:60*fs_ni) >= WavChan_Thresh); % Check in the first minute
                
                Onsets_fs_nidaq = Onsets_s*fs_ni;
                Offsets_fs_nidaq = Offsets_s*fs_ni;
                
                data_offset = WavCrossings_fs(1) - Onsets_fs_nidaq(1);
                
                nStims = 5;
                cnt = 1;
                StimOnsets = []; allOnsets_fs_nidaq = [];
                StimOffsets = []; allOffsets_fs_nidaq = [];
                for j = 1:nStims
                    
                    switch j
                        case 1
                            stimName = 'WNBOF';
                            nStims = numel(allStims1);
                        case 2
                            stimName = 'REV';
                            nStims = numel(allStims5);
                        case 3
                            stimName = 'CON';
                            nStims = numel(allStims3);
                            
                        case 4
                            stimName = 'BOS';
                            nStims = numel(allStims2);
                            
                        case 5
                            stimName = 'WNEOF';
                            nStims = numel(allStims4);
                            
                    end
                    
                    StimNames{j} = stimName;
                    for o = 1:nStims
                        
                        
                        %   eval(['StimOnsets.' stimName '(o) = Onsets_fs_nidaq(cnt) + data_offset;'])
                        %   eval(['StimOffsets.' stimName '(o) = Offsets_fs_nidaq(cnt) + data_offset;'])
                        
                        allOnsets_fs_nidaq(cnt) = Onsets_fs_nidaq(cnt) + data_offset;
                        allOffsets_fs_nidaq(cnt) = Offsets_fs_nidaq(cnt) + data_offset;
                        
                        cnt = cnt+1;
                    end
                    
                end
                
                %obj.ANALYSIS.StimOnsets_fs_nidaq = StimOnsets;
                %obj.ANALYSIS.StimOffsets_fs_nidaq = StimOffsets;
                obj.ANALYSIS.allOnsets_fs_nidaq = allOnsets_fs_nidaq;
                obj.ANALYSIS.allOffsets_fs_nidaq = allOffsets_fs_nidaq;
                obj.ANALYSIS.StimNames = StimNames;
                
                %SS_nidaq.StimOnsets = StimOnsets;
                %SS_nidaq.StimOffsets = StimOffsets;
                SS_nidaq.allOnsets_fs_nidaq = allOnsets_fs_nidaq;
                SS_nidaq.allOffsets_fs_nidaq = allOffsets_fs_nidaq;
                SS_nidaq.fs_ni = fs_ni;
                SS_nidaq.StimNames = StimNames;
                
                save([nidaq_path nidaq_binName(1:end-9)  '__NiDaqStimSync'], 'SS_nidaq');
                disp(['Saved NiDaqStimSync File: ' [nidaq_path nidaq_binName(1:end-9)  '__NiDaqStimSync']]);
                
                %%
                if doPlot == 1
                    timepoints_fs = 1:1:numel(WavChan);
                    timepoints_s = timepoints_fs / fs_ni;
                    
                    seg_s = 55;
                    seg_samp = seg_s*fs_ni;
                    
                    seg_s_long = 60;
                    seg_samp_long = seg_s_long*fs_ni;
                    
                    tOn = 1:seg_samp:nSamp;
                    nTon = numel(tOn);
                    
                    for j = 1:nTon
                        if j == nTon
                            ROI = tOn(j): nSamp;
                        else
                            ROI = tOn(j): tOn(j)+seg_samp_long;
                        end
                        
                        allOnsets_inds = find(allOnsets_fs_nidaq <= ROI(end) & allOnsets_fs_nidaq >= ROI(1)) ;
                        thisOnset_s = allOnsets_fs_nidaq ./ fs_ni;
                        theseOnsets = thisOnset_s(allOnsets_inds);
                        
                        allOffsets_inds = find(allOffsets_fs_nidaq <= ROI(end) & allOffsets_fs_nidaq >= ROI(1)) ;
                        thisOffset_s = allOffsets_fs_nidaq ./ fs_ni;
                        theseOffsets = thisOffset_s(allOffsets_inds);
                        
                        figure(104); clf
                        subplot(2, 1, 1)
                        plot(timepoints_s(ROI), WavChan(ROI));
                        
                        subplot(2, 1, 2)
                        specgram1((WavChan(ROI)./100),513,fs_ni,400,360);
                        ylim([0 10000])
                        
                        subplot(2, 1, 1)
                        hold on
                        plot(theseOnsets, 15, 'rv')
                        plot(theseOffsets, 15, 'kv')
                        axis tight
                        ylim([-50 50])
                        pause
                    end
                    
                end
            end
        end
        
        function obj = syncSquareWave(obj)
            
            loadFile = 0;
            
            if isfile([obj.PATH.nidaq_path obj.PATH.nidaq_binName(1:end-9)  '__NiDaqImec_SquareSync.mat'])  && loadFile
                disp(['Loading previously saved square sync file: ' [obj.PATH.nidaq_path obj.PATH.nidaq_binName(1:end-9)  '__NiDaqLFP_SquareSync.mat']])
                
                load([obj.PATH.nidaq_path obj.PATH.nidaq_binName(1:end-9)  '__NiDaqImec_SquareSync.mat'])
                
                obj.ANALYSIS.posSyncLocs_fsNidaq = SYNC.posSyncLocs_fsNidaq;
                obj.ANALYSIS.fsNidaq = SYNC.fsNidaq;
                obj.ANALYSIS.posLFPLocs_fsLFP = SYNC.posLFPLocs_fsLFP;
                obj.ANALYSIS.fsLFP = SYNC.fsLFP;
                
            else
                
                
                
                %% APSync
                
                %lfp_binName = obj.PATH.lfp_binName;
                %lfp_path = obj.PATH.lfp_path;
                
                % Use the AP bin file so that the onsets are w the same
                % sampling rate as the spikes
                imec_binName = obj.PATH.ap_binName;
                imec_path = obj.PATH.ap_path;
                
                filename = [imec_path imec_binName];
                syncChanIndex = 385;
                numChans = 385;
                imecSyncDat = extractSyncChannelFromFile(obj, filename, numChans, syncChanIndex);
                imecSyncDat_dbl = double(imecSyncDat);
                
                imecSyncDiff = diff(imecSyncDat_dbl);
                figure; plot(imecSyncDiff(1:10000))
                [imec_meta] = ReadMeta(obj, imec_binName, imec_path);
                
                fs_imec = str2double(imec_meta.imSampRate);
                
                imecSyncThresh_pos = 55;
                
                [pks,imecSyncLocs] = findpeaks(imecSyncDiff, 'MinPeakHeight', imecSyncThresh_pos, 'MinPeakDistance', 0.5*fs_imec);
                
                %imecSyncLocs = find(imecSyncDiff >=imecSyncThresh_pos);
                allDiffsImecSyncLocs = round(diff(imecSyncLocs)/fs_imec);
                bla = find(allDiffsImecSyncLocs ~= 1);
                minInds = bla+1;
                allDiffsImecSyncLocs(minInds) = [];
                
                %figure; plot(allDiffsImecSyncLocs );
                
                figure(203); clf
                subplot(4, 1, 1)
                plot(imecSyncDat_dbl(1:20*fs_imec));
                axis tight
                ylim([0 100])
                subplot(4, 1, 2)
                plot(imecSyncDiff(1:20*fs_imec));
                
                %% NiDaq
                
                nidaq_binName = obj.PATH.nidaq_binName;
                nidaq_path = obj.PATH.nidaq_path;
                
                [nidaq_meta] = ReadMeta(obj, nidaq_binName, nidaq_path);
                
                fs_ni = str2double(nidaq_meta.niSampRate);
                nSamp = floor(str2num(nidaq_meta.fileTimeSecs) * fs_ni);
                disp('Reading in NiDaq data...');
                nidaq_dataArray = ReadBin(obj, 1, nSamp, nidaq_meta, nidaq_binName, nidaq_path);
                
                %% Sync Channel
                
                SyncChan = nidaq_dataArray(3,:);
                
                [b1,a1] = butter(2,[1 100]/(fs_ni/2));
                filSyncChanFilt=filtfilt(b1,a1,SyncChan);
                
                SyncChanF = filSyncChanFilt*-1; % NI sync channle is inverted compared to LFP
                
                disp('done...');
                syncDiff = diff(SyncChanF);
                
                nSamps = numel(SyncChanF);
                dataTime_s = round(nSamps/fs_ni);
                
                SyncThreshPos = 0.01;
                SyncThreshNeg = -10;
                
                [pks,Locs] = findpeaks(syncDiff, 'MinPeakHeight', SyncThreshPos, 'MinPeakDistance', 0.5*fs_ni);
                 
               %Locs = find(syncDiff > SyncThreshPos);
                allDifssPosLocs = round(diff(Locs)/fs_ni);
                bla = find(allDifssPosLocs < 1);
                minInds = bla+1;
                Locs(minInds) = [];
                
                
                if numel(Locs) ~= numel(imecSyncLocs)
                    keyboard
                end
                
                figure(203);
                subplot(4, 1, 3)
                plot(SyncChan(1:20*fs_ni));
                axis tight
                ylim([-5 20])
                subplot(4, 1, 4)
                plot(syncDiff(1:20*fs_ni));
                
                obj.ANALYSIS.posSyncLocs_fsNidaq = Locs;
                obj.ANALYSIS.fsNidaq = fs_ni;
                obj.ANALYSIS.posImecLocs_fsImec = imecSyncLocs;
                obj.ANALYSIS.fsImec = fs_imec;
                
                SYNC.posSyncLocs_fsNidaq = Locs;
                SYNC.fsNidaq = fs_ni;
                SYNC.posImecLocs_fsImec = imecSyncLocs;
                SYNC.fsImec = fs_imec;
                
                save([nidaq_path nidaq_binName(1:end-9)  '__NiDaqImec_SquareSync'], 'SYNC');
                disp(['Saved NiDaq-Imec Square Sync File: ' [nidaq_path nidaq_binName(1:end-9)  '__NiDaqImec_SquareSync']]);
                
            end
        end
        
        %%
        
        function [meta] = ReadMeta(obj, binName, path)
            
            % Create the matching metafile name
            [dumPath,name,dumExt] = fileparts(binName);
            metaName = strcat(name, '.meta');
            
            % Parse ini file into cell entries C{1}{i} = C{2}{i}
            fid = fopen(fullfile(path, metaName), 'r');
            % -------------------------------------------------------------
            %    Need 'BufSize' adjustment for MATLAB earlier than 2014
            %    C = textscan(fid, '%[^=] = %[^\r\n]', 'BufSize', 32768);
            C = textscan(fid, '%[^=] = %[^\r\n]');
            % -------------------------------------------------------------
            fclose(fid);
            
            % New empty struct
            meta = struct();
            
            % Convert each cell entry into a struct entry
            for i = 1:length(C{1})
                tag = C{1}{i};
                if tag(1) == '~'
                    % remake tag excluding first character
                    tag = sprintf('%s', tag(2:end));
                end
                meta = setfield(meta, tag, C{2}{i});
            end
        end
        
        %
        function dataArray = ReadBin(obj, samp0, nSamp, meta, binName, path)
            
            nChan = str2double(meta.nSavedChans);
            
            nFileSamp = str2double(meta.fileSizeBytes) / (2 * nChan);
            samp0 = max(samp0, 0);
            nSamp = min(nSamp, nFileSamp - samp0);
            
            sizeA = [nChan, nSamp];
            
            fid = fopen(fullfile(path, binName), 'rb');
            fseek(fid, samp0 * 2 * nChan, 'bof');
            dataArray = fread(fid, sizeA, 'int16=>double');
            fclose(fid);
        end
        
        
        function syncDat = extractSyncChannelFromFile(obj, filename, numChans, syncChanIndex)
            % extraChanIndices are 1-indexed
            
            maxReadSize = 1e9;
            
            d = dir(filename);
            [folder,fn] = fileparts(filename);
            syncFname =  fullfile(folder, [fn '_sync.dat']);
            fidOut = fopen(syncFname, 'w');
            
            fprintf(1,' loading %s\n', filename);
            
            fid = fopen(filename, 'r');
            
            % skip over the first samples of the other channels
            q = fread(fid, (syncChanIndex-1), 'int16=>int16');
            
            nSamp = d.bytes/2/numChans;
            
            if nargout>0
                syncDat = zeros(1, nSamp, 'int16');
            end
            
            nBatch = floor(nSamp/maxReadSize);
            for b = 1:nBatch
                dat = fread(fid, [1, maxReadSize], 'int16=>int16', (numChans-1)*2); % skipping other channels
                fwrite(fidOut, dat, 'int16');
                if nargout>0
                    syncDat((b-1)*maxReadSize+1:b*maxReadSize) = dat;
                end
            end
            
            % all the other samples
            dat = fread(fid, [1, Inf], 'int16=>int16', (numChans-1)*2); % skipping other channels
            fwrite(fidOut, dat, 'int16');
            if nargout>0
                syncDat(nBatch*maxReadSize+1:end) = dat;
            end
            
            fclose(fid);
            fclose(fidOut);
            
            disp(' done.')
        end
        
        function obj = remapNiStimsToImecStream(obj)
            
            fsImec = obj.ANALYSIS.fsImec;
            fsNidaq = obj.ANALYSIS.fsNidaq;
            
            %Stims Onsets and Offsets
            %StimOnsets_fs_nidaq = obj.ANALYSIS.StimOnsets_fs_nidaq;
            %StimOffsets_fs_nidaq = obj.ANALYSIS.StimOffsets_fs_nidaq;
            
            StimNames = obj.ANALYSIS.StimNames;
            nStims = numel(StimNames);
            
            % Square waves sync
            Imec_SqareSync = obj.ANALYSIS.posImecLocs_fsImec;
            NiDaq_SqareSync = obj.ANALYSIS.posSyncLocs_fsNidaq;
            
            Imec_SquareSync_s = Imec_SqareSync./fsImec;
            NiDaq_SquareSync_s = NiDaq_SqareSync./fsNidaq;
            
            allOnsets_fs_nidaq_s = obj.ANALYSIS.allOnsets_fs_nidaq./fsNidaq;
            allOffsets_fs_nidaq_s = obj.ANALYSIS.allOffsets_fs_nidaq./fsNidaq;
            
            nOnsets = numel(allOnsets_fs_nidaq_s);
            
            %%
            %This mapping scheme is implemented as follows. A common 1 Hz square wave is
            %recorded in one channel of each data stream throughout the experiment. In offline
            %processing, the rising edges in this "sync wave" are paired across streams A & B.
            %Any event (T) occurring in B is no more than one second away from a nearest
            %(preceding) sync wave edge (Eb) in stream B. That edge has a simultaneously
            %occurring matching edge (Ea) in stream A. To map T in stream B to T' in stream A,
            %we simply calculate:
            
            %T' = T - Eb + Ea.
            
            T_On = []; T_Off = [];
            for o = 1:nOnsets
                
                ThisOnset = allOnsets_fs_nidaq_s(o);
                
                NiSyncEdgeInds = find(NiDaq_SquareSync_s < ThisOnset);
                NiSyncEdge_onset = NiDaq_SquareSync_s(NiSyncEdgeInds(end));
                
                ImecSyncEdgeInds = find(Imec_SquareSync_s < ThisOnset);
                ImecSyncEdge_onset = Imec_SquareSync_s(ImecSyncEdgeInds(end));
                
                T_On(o) = ThisOnset - NiSyncEdge_onset + ImecSyncEdge_onset;
                
                %%
                ThisOffset = allOffsets_fs_nidaq_s(o);
                
                NiSyncEdgeInds = find(NiDaq_SquareSync_s < ThisOffset);
                NiSyncEdge_offset = NiDaq_SquareSync_s(NiSyncEdgeInds(end));
                
                ImecSyncEdgeInds = find(Imec_SquareSync_s < ThisOffset);
                ImecSyncEdge_offset = Imec_SquareSync_s(ImecSyncEdgeInds(end));
                
                T_Off(o) = ThisOffset - NiSyncEdge_offset + ImecSyncEdge_offset;
            end
            
            
            soundfile_Name = obj.PATH.soundfile_Name;
            soundfile_path = obj.PATH.soundfile_path;
            
            sound = load([soundfile_path soundfile_Name]);
            
            names = fieldnames(sound);
            nNames = numel(names);
            allStims = [];
            cnt = 1;
            for o = 1:nNames-1
                
                eval(['stim = sound.' names{o}])
                
                if ~isempty(stim)
                    allStims{cnt} = cell2mat(stim);
                    cnt = cnt+1;
                end
            end
            
            allStims1 = sort(allStims{1,2}) - sort(allStims{1, 1}); % N1
            allStims2 = sort(allStims{1,4}) - sort(allStims{1, 3}); % BOS
            allStims3 = sort(allStims{1,6}) - sort(allStims{1, 5}); % CON
            allStims4 = sort(allStims{1,8}) - sort(allStims{1, 7}); % N2
            allStims5 = sort(allStims{1,10}) - sort(allStims{1, 9}); % REV
            
            nStims = 5;
            cnt = 1;
            StimOnsets_imecStream_s = [];
            StimOffsets_imecStream_s = [];
            for j = 1:nStims
                
                switch j
                    case 1
                        stimName = 'WNBOF';
                        nStims = numel(allStims1);
                    case 2
                        stimName = 'REV';
                        nStims = numel(allStims5);
                    case 3
                        stimName = 'CON';
                        nStims = numel(allStims3);
                        
                    case 4
                        stimName = 'BOS';
                        nStims = numel(allStims2);
                        
                    case 5
                        stimName = 'WNEOF';
                        nStims = numel(allStims4);
                        
                end
                
                StimNames{j} = stimName;
                nRepsPerStim(j) = nStims;
                for o = 1:nStims
                    eval(['StimOnsets_imecStream_s.' stimName '(o) = T_On(cnt);'])
                    eval(['StimOffsets_imecStream_s.' stimName '(o) = T_Off(cnt);'])
                    
                    cnt = cnt+1;
                end
                
            end
            
            obj.ANALYSIS.STIM.StimOnsets_imecStream_s = StimOnsets_imecStream_s;
            obj.ANALYSIS.STIM.StimOffsets_imecStream_s = StimOffsets_imecStream_s;
            
            obj.ANALYSIS.STIM.T_On_imec_s = T_On;
            obj.ANALYSIS.STIM.T_Off_imec_s = T_Off;
            
            obj.ANALYSIS.STIM.StimNames = StimNames;
            obj.ANALYSIS.STIM.nRepsPerStim = nRepsPerStim;
            
            
            StimSync_imec.StimNames = obj.ANALYSIS.STIM.StimNames;
            StimSync_imec.nRepsPerStim = obj.ANALYSIS.STIM.nRepsPerStim;
            StimSync_imec.StimOnsets_imecStream_s =  obj.ANALYSIS.STIM.StimOnsets_imecStream_s;
            StimSync_imec.StimOffsets_imecStream_s =  obj.ANALYSIS.STIM.StimOffsets_imecStream_s;
            StimSync_imec.T_On_imec_s =   obj.ANALYSIS.STIM.T_On_imec_s;
            StimSync_imec.T_Off_imec_s =   obj.ANALYSIS.STIM.T_Off_imec_s;
            
            
             save([obj.PATH.nidaq_path obj.PATH.nidaq_binName(1:end-9)  '__Imec_StimSync'], 'StimSync_imec');
                disp(['Saved Imec Stimulus Sync File: ' [obj.PATH.nidaq_path obj.PATH.nidaq_binName(1:end-9) '__StimSync_imec']]);
                
            
        end
        
        function [obj] = loadSpikes(obj)
            
            spk_dir = obj.PATH.ap_path;
            
            % spike times coming from the ap file
            spk_times = readNPY(fullfile(spk_dir, 'spike_times.npy'));  % in indices of spike glx
            
            % corresponding spike sorting cluster
            spk_clust = readNPY(fullfile(spk_dir, 'spike_clusters.npy'));
            
            % cluster information
            cluster_info = tdfread(fullfile(spk_dir, 'cluster_info.tsv'), '\t');
            
            
            if ~isfield(cluster_info, 'id')
                cluster_info.id = cluster_info.cluster_id;
            end
            
            %%% INCLUSION
            % include only units that fire with higher than 1 Hz spike rate
            fr_incl = cluster_info.fr > 0.5 ;
            
            % spike times and cluster for multiunits and good units only
            %c_incl = ~contains(cellstr(cluster_info.group), 'noise');
            c_incl = contains(cellstr(cluster_info.group), 'good');
            
            if size(fr_incl, 1) ~= size(c_incl, 1)
                fr_incl= fr_incl';
            end
            
            %%% FILTER
            sel_units.id = cluster_info.id(c_incl & fr_incl);
            sel_units.chan = cluster_info.ch(c_incl & fr_incl);
            sel_units.depth = cluster_info.depth(c_incl & fr_incl);
            sel_units.fr= cluster_info.fr(c_incl & fr_incl);
            
            cnt = 1; all_units = [];
            for i = 1:numel(sel_units.chan)
                
                %all_units(i).t = double(spk_times( idx_incl )) ./ 30000;
                id = sel_units.id(i);
                chan = sel_units.chan(i);
                depth = sel_units.depth(i);
                fr = sel_units.fr(i);
                
                idx_incl = ismember(spk_clust, id);
                
                t = double(spk_times( idx_incl )) ./ 30000;
                t_clust = spk_clust( idx_incl );
                
                if ~isempty(t)
                    
                    all_units(cnt).id = sel_units.id(i);
                    all_units(cnt).chan = sel_units.chan(i);
                    all_units(cnt).depth = sel_units.depth(i);
                    all_units(cnt).fr = sel_units.fr(i);
                    
                    idx_incl_F = ismember(spk_clust, all_units(cnt).id);
                    
                    all_units(cnt).t = double(spk_times( idx_incl )) ./ 30000;
                    all_units(cnt).t_clust = spk_clust( idx_incl );
                    
                    ClusterIDs(cnt) = sel_units.id(i);
                    ClustChans(cnt) = sel_units.chan(i);
                    ClustDepths(cnt) = sel_units.depth(i);
                    
                    cnt = cnt+1;
                end
                
            end
            
            obj.ANALYSIS.SPKS.all_units = all_units;
            
            %end
            
            dataDir = obj.PATH.ap_path;
            sp = loadKSdir(dataDir);
            
            disp('Loading waveforms...')
            tic
            for o = 1:numel(ClusterIDs)
                
                thisClustID = ClusterIDs(o);
                thisChan = ClustChans(o);
                thisDepth = ClustDepths(o);
                
                gwfparams.dataDir = dataDir;    % KiloSort/Phy output folder
                apD = dir(fullfile(dataDir, '*ap*.bin')); % AP band file from spikeGLX specifically
                gwfparams.fileName = apD(1).name;         % .dat file containing the raw
                gwfparams.dataType = 'int16';            % Data type of .dat file (this should be BP filtered)
                gwfparams.nCh = 385;                      % Number of channels that were streamed to disk in .dat file
                gwfparams.wfWin = [-40 41];              % Number of samples before and after spiketime to include in waveform
                gwfparams.nWf = 2000;                    % Number of waveforms per unit to pull out
                gwfparams.spikeTimes = ceil(sp.st(sp.clu==thisClustID)*30000); % Vector of cluster spike times (in samples) same length as .spikeClusters
                gwfparams.spikeClusters = sp.clu(sp.clu==thisClustID);
                %gwfparams.spikeTimes = spikeTimes_samps; % Vector of cluster spike times (in samples) same length as .spikeClusters
                %gwfparams.spikeClusters = ClusterIDs;
                
                
                wf = getWaveForms(gwfparams);
                
                allWaveforms = squeeze(wf.waveFormsMean);
                
                
                chInd = thisChan+1;
                thisWave = allWaveforms(chInd, :);
                allWaves = squeeze(wf.waveForms(1,:,:,:));
                thisNeuronAllWaves{o} = allWaves(:,chInd,:);
                
                
            end
            toc
            obj.ANALYSIS.SPKS.AllSpkWaves = thisNeuronAllWaves;
            
            disp('')
        end
        
        function obj = alignSpikesToStims(obj)
            
            %Stims Onsets and Offsets
            StimOnsets_imecStream_s = obj.ANALYSIS.STIM.StimOnsets_imecStream_s;
            StimOffsets_imecStream_s = obj.ANALYSIS.STIM.StimOffsets_imecStream_s;
            
            StimNames = obj.ANALYSIS.STIM.StimNames;
            nStims = numel(StimNames);
            
            %% SpikeTimes are in s
            all_units = obj.ANALYSIS.SPKS.all_units;
            
            nUnits = numel(all_units);
            
            for j = 1:nStims
                
                thisStim = StimNames{j};
                
                eval(['thisStimOnsets_s = StimOnsets_imecStream_s.' thisStim ';'])
                eval(['thisStimOffsets_s = StimOffsets_imecStream_s.' thisStim ';'])
                
                allStimDursReps_s = thisStimOffsets_s - thisStimOnsets_s;
                
                nReps = numel(thisStimOnsets_s);
                allFR = [];
                for k = 1:nUnits
                    thisUnit = all_units(k);
                    spikeTimes_s = thisUnit.t;
                    
                    allStimsReps_s = [];
                    nSpikesReps = [];
                    
                    for o = 1:nReps
                        
                        ThisStimRep_onset_s = thisStimOnsets_s(o);
                        ThisStimRep_offset_s = thisStimOffsets_s(o);
                        
                        these_spks_on_chan = spikeTimes_s(spikeTimes_s >= ThisStimRep_onset_s & spikeTimes_s <= ThisStimRep_offset_s)-ThisStimRep_onset_s;
                        allStimsReps_s{k, o} = these_spks_on_chan;
                        nSpikesReps(k,o) = numel(these_spks_on_chan);
                    end
                    allFR(k,:) = nSpikesReps(k,:)./allStimDursReps_s;
                end
                
                spikeTimesOverReps{j} = allStimsReps_s;
                nSpikesOverReps{j} = nSpikesReps;
                FRsOverReps{j} = allFR;
                allDursReps{j} = allStimDursReps_s;
            end
            
            obj.ANALYSIS.SPK.spikeTimesOverReps = spikeTimesOverReps;
            obj.ANALYSIS.SPK.nSpikesOverReps = nSpikesOverReps;
            obj.ANALYSIS.SPK.FRsOverReps = FRsOverReps;
            obj.ANALYSIS.SPK.allDursReps = allDursReps;
            
        end
        
        
        function obj = alignSpikesToStims_spont(obj)
            
            %Stims Onsets and Offsets
            StimOnsets_imecStream_s = obj.ANALYSIS.STIM.StimOnsets_imecStream_s;
            StimOffsets_imecStream_s = obj.ANALYSIS.STIM.StimOffsets_imecStream_s;
            
            StimNames = obj.ANALYSIS.STIM.StimNames;
            nStims = numel(StimNames);
            
            %% SpikeTimes are in s
            all_units = obj.ANALYSIS.SPKS.all_units;
            
            nUnits = numel(all_units);
            
            spontDur_s = 1;
            
            for j = 1:nStims
                
                thisStim = StimNames{j};
                
                eval(['thisStimOnsets_s = StimOnsets_imecStream_s.' thisStim ';'])
                eval(['thisStimOffsets_s = StimOffsets_imecStream_s.' thisStim ';'])
                
                thisSpontOnset_s = thisStimOnsets_s - 1.5; % 1 s centered before the stim onset
                thisSpontOffset_s = thisSpontOnset_s+ spontDur_s;
                
                
                allSpontDursReps_s = thisSpontOffset_s - thisSpontOnset_s;
                
                nReps = numel(thisSpontOnset_s);
                allFR_Spont = [];
                for k = 1:nUnits
                    thisUnit = all_units(k);
                    spikeTimes_s = thisUnit.t;
                    
                    allSpontReps_s = [];
                    nSpontSpikesReps = [];
                    
                    for o = 1:nReps
                        
                        ThisSpontRep_onset_s = thisSpontOnset_s(o);
                        ThisSpontRep_offset_s = thisSpontOffset_s(o);
                        
                        these_spks_on_chan = spikeTimes_s(spikeTimes_s >= ThisSpontRep_onset_s & spikeTimes_s <= ThisSpontRep_offset_s)-ThisSpontRep_onset_s;
                        allSpontReps_s{k, o} = these_spks_on_chan;
                        nSpontSpikesReps(k,o) = numel(these_spks_on_chan);
                    end
                    allFR_Spont(k,:) = nSpontSpikesReps(k,:)./allSpontDursReps_s;
                end
                
                spikeTimesOverReps_spont{j} = allSpontReps_s;
                nSpikesOverReps_spont{j} = nSpontSpikesReps;
                FRsOverReps_spont{j} = allFR_Spont;
                allDursReps_spont{j} = allSpontDursReps_s;
            end
            
            obj.ANALYSIS.SPK.spikeTimesOverReps_spont = spikeTimesOverReps_spont;
            obj.ANALYSIS.SPK.nSpikesOverReps_spont = nSpikesOverReps_spont;
            obj.ANALYSIS.SPK.FRsOverReps_spont = FRsOverReps_spont;
            obj.ANALYSIS.SPK.allDursReps_spont = allDursReps_spont;
            
        end
        
        
        function obj = calcDPrimeSelectivity_FRstats(obj)
            disp('')
            
            spikeTimesOverReps = obj.ANALYSIS.SPK.spikeTimesOverReps;
            nSpikesOverReps = obj.ANALYSIS.SPK.nSpikesOverReps;
            FRsOverReps = obj.ANALYSIS.SPK.FRsOverReps;
            
            %%
            nStims = numel(spikeTimesOverReps);
            this_d_prime = [];
            
            nNeurons= size(nSpikesOverReps{1,1}, 1);
            
            for j = 1:nNeurons
                
                for s = 1: nStims
                    
                    thisNeuronStim1_FR = FRsOverReps{1, s}(j,:);
                    mean_this_stim1 = mean(thisNeuronStim1_FR);
                    this_std1 = std(thisNeuronStim1_FR);
                    
                    for v = 1: nStims
                        
                        thisNeuronStim2_FR = FRsOverReps{1, v}(j,:);
                        mean_this_stim2 = mean(thisNeuronStim2_FR);
                        this_std2 = std(thisNeuronStim2_FR);
                        
                        this_d_prime(s,v) = roundn(2 * (mean_this_stim1 - mean_this_stim2) / sqrt(this_std1^2 + this_std2^2), -2);
                        
                        [p, h] = ranksum(thisNeuronStim1_FR, thisNeuronStim2_FR);
                        ranksum_p(s, v) = p;
                        ranksum_h(s, v) = h;
                        
                    end
                end
                
                allDPrimes{j} = this_d_prime;
                FR_allRanksum_p{j} = ranksum_p;
                FR_allRanksum_h{j} = ranksum_h;
            end
            
            obj.ANALYSIS.allDPrimes = allDPrimes;
            obj.ANALYSIS.FR_allRanksum_p = FR_allRanksum_p;
            obj.ANALYSIS.FR_allRanksum_h = FR_allRanksum_h;
            
            allMeans = []; allstd = []; allsems = [];
            for j = 1:nNeurons
                
                for s = 1: nStims
                    
                    thisNeuronStim1_FR = FRsOverReps{1, s}(j,:);
                    mean_this_stim1 = mean(thisNeuronStim1_FR);
                    this_std1 = std(thisNeuronStim1_FR);
                    this_sem = this_std1/(sqrt(numel(thisNeuronStim1_FR)));
                    
                    allMeans(j, s) = mean_this_stim1;
                    allstd(j, s) = this_std1;
                    allsems(j, s) = this_sem;
                end
            end
            
            obj.ANALYSIS.FR_allMeans = allMeans;
            obj.ANALYSIS.FR_allstd = allstd;
            obj.ANALYSIS.FR_allsem = allsems;
            
            %% Spont
            FRsOverReps_spont = obj.ANALYSIS.SPK.FRsOverReps_spont;
            %obj.ANALYSIS.SPK.allDursReps_spont = allDursReps_spont;
            %allMeans_spont = []; allstd_spont = [];
            for j = 1:nNeurons
                
                for s = 1: nStims
                    
                    thisNeuronSpont_FR = FRsOverReps_spont{1, s}(j,:);
                    mean_this_Spont = mean(thisNeuronSpont_FR);
                    this_std_Spont = std(thisNeuronSpont_FR);
                    this_sem_spont = this_std_Spont/(sqrt(numel(thisNeuronSpont_FR)));
                    
                    
                    allMeans_spont(j, s) = mean_this_Spont;
                    allstd_spont(j, s) = this_std_Spont;
                    allsem_spont(j, s) = this_sem_spont;
                end
            end
            
            obj.ANALYSIS.FR_allMeans_spont = allMeans_spont;
            obj.ANALYSIS.FR_allstd_spont = allstd_spont;
            obj.ANALYSIS.FR_allsem_spont = allsem_spont;
            
        end
        
        function obj = makeSummaryPlotsForNeurons(obj)
            
            % Fr summary
            % D prime
            % Spike waveform
            %WN raster
            % Statistics
            
            disp('')
            
            spikeTimesOverReps = obj.ANALYSIS.SPK.spikeTimesOverReps;
            nSpikesOverReps = obj.ANALYSIS.SPK.nSpikesOverReps;
            FRsOverReps = obj.ANALYSIS.SPK.FRsOverReps;
            allDursReps = obj.ANALYSIS.SPK.allDursReps;
            
            %%
            allDPrimes = obj.ANALYSIS.allDPrimes;
            FR_allRanksum_p = obj.ANALYSIS.FR_allRanksum_p;
            FR_allRanksum_h = obj.ANALYSIS.FR_allRanksum_h;
            
            FR_allMeans = obj.ANALYSIS.FR_allMeans;
            FR_allstd = obj.ANALYSIS.FR_allstd;
            FR_allsem = obj.ANALYSIS.FR_allsem;
            
            %%
            spikeTimesOverReps_spont = obj.ANALYSIS.SPK.spikeTimesOverReps_spont;
            nSpikesOverReps_spont = obj.ANALYSIS.SPK.nSpikesOverReps_spont;
            FRsOverReps_spont = obj.ANALYSIS.SPK.FRsOverReps_spont;
            allDursReps_spont = obj.ANALYSIS.SPK.allDursReps_spont;
            
            FR_allMeans_spont = obj.ANALYSIS.FR_allMeans_spont;
            FR_allstd_spont = obj.ANALYSIS.FR_allstd_spont;
            FR_allsem_spont = obj.ANALYSIS.FR_allsem_spont;
            
            all_units = obj.ANALYSIS.SPKS.all_units;
            %               all_units(i).id = sel_units.id(i);
            %                 all_units(i).chan = sel_units.chan(i);
            %                 all_units(i).depth = sel_units.depth(i);
            %                 all_units(i).fr = sel_units.fr(i);
            
            %%
            nNeurons= size(nSpikesOverReps{1,1}, 1);
            
            
            %% get total length of recording s
            
            imec_binName = obj.PATH.ap_binName;
            imec_path = obj.PATH.ap_path;
            
            filename = [imec_path imec_binName];
            %                 syncChanIndex = 385;
            %                 numChans = 385;
            %                 imecSyncDat = extractSyncChannelFromFile(obj, filename, numChans, syncChanIndex);
            %                 imecSyncDiff = diff(imecSyncDat);
            %
            [imec_meta] = ReadMeta(obj, imec_binName, imec_path);
            fileTime_s = str2double(imec_meta.fileTimeSecs);
            
            %%
            
            allStats_p = obj.ANALYSIS.FR_allRanksum_p;
            all_units = obj.ANALYSIS.SPKS.all_units;
              groupNames = {'WN-BOF', 'REV', 'CON', 'BOS', 'WN-EOF'};
              
            for j = 1:nNeurons
                
                
                thisNeuronID = all_units(j).id;
                thisNeuronChan = all_units(j).chan;
                thisNeuronDepth = all_units(j).depth;
                
                thisNeuron_AllMeans = FR_allMeans(j,:);
                thisNeuron_AllSEM = FR_allsem(j,:);
                thisNeuron_AllStd = FR_allstd(j,:);
                
                thisNeuron_AllMeans_spont = FR_allMeans_spont(j,:);
                thisNeuron_AllSEM_spont = FR_allsem_spont(j,:);
                thisNeuron_AllStd_spont = FR_allstd_spont(j,:);
                
                toPlot_means = [thisNeuron_AllMeans_spont ; thisNeuron_AllMeans ];
                toPlot_sem = [thisNeuron_AllSEM_spont ; thisNeuron_AllSEM ];
                
                %%
                figure (205) ; clf
                
                 %% spikewaveforms
                subplot(2, 4, 1);
                
                allSpkWaveforms = obj.ANALYSIS.SPKS.AllSpkWaves;
                thisChanAllaWaves = allSpkWaveforms{1, j};
                thisChanAllaWaves = squeeze(thisChanAllaWaves);
                %thisWave = mean(thisChanAllaWaves, 1);
                %thisChanAllaWaves_meansub = thisChanAllaWaves-thisWave;
                
                
                plot(thisChanAllaWaves(1:500,:)', 'color', [.5 .5 .5])
                thisWave = nanmean(thisChanAllaWaves, 1);
                hold on;
                plot(thisWave, 'linewidth', 2, 'color', 'k');
                axis tight
                title(['Neuron ID: ' num2str(thisNeuronID) ' | Chan: ' num2str(thisNeuronChan) ' | Depth: ' num2str(thisNeuronDepth)])
                
                %% Spiketimes
                
                subplot(2, 4, 2);
                
                allSpkTimes = all_units(j).t;
                %ys= ones(1, numel(allSpkTimes));
                ys = rand(1, numel(allSpkTimes));
                plot(allSpkTimes, ys, 'k.')
                xlim([0 round(fileTime_s)])
                title('Spike Times')
                
                %% Statistics
                 
                thisNeuron_P = allStats_p{j};
                Name = groupNames;
                T = table(thisNeuron_P,'RowNames',Name);
                
                ha =  subplot(2, 4, [3 4]);
                %title(['Ranksum statistics'])
                pos = get(ha,'Position');
                un = get(ha,'Units');
                delete(ha)
                
                ht = uitable('Data',T{:,:},'ColumnName',groupNames,...
                    'RowName',T.Properties.RowNames,'Units', un, 'Position',pos);
                
                %title(['Ranksum statistics'])
                %axis off
                
                
                %% Firing rates
                subplot(2, 4, 5)
                
              
                barweb(toPlot_means', toPlot_sem', 1, groupNames)
                legTxt = {'Spont', 'Stim'};
                legend(legTxt)
                legend('boxoff')
                ylabel( 'Firing rate (hz)')
                
                
                %% Z score
                subplot(2, 4, [6]); cla
                
                %mean_stim = mean(stimulated_neurons);
                %mean_base = mean(baseline_neurons);
                %std_stim = std(stimulated_neurons);
                %std_base = std(baseline_neurons);
                
                %median_stim = median(stimulated_neurons);
                %median_base = median(baseline_neurons);
                
                %covar = cov(stimulated_neurons, baseline_neurons);
                
                %z_score_cov = (thisNeuron_AllMeans - thisNeuron_AllMeans_spont) / sqrt((thisNeuron_AllStd^2 + thisNeuron_AllStd_spont^2) - 2*covar(1, 2));
                z_score = (thisNeuron_AllMeans - thisNeuron_AllMeans_spont) ./ sqrt(thisNeuron_AllStd.^2 + thisNeuron_AllStd_spont.^2);
                %zscres = reshape(z_score, 5, 1);
                %ers = reshape(zeros(1, 5), 5, 1);
                
                barweb(z_score, zeros(1, 5), .85)
                ylim([-2 2])
                %xlim([-0.95 1.05])
                hold on
                line([-0.95 2], [1 1], 'color', 'k', 'linestyle', ':')
                line([-0.95 2], [-1 -1], 'color', 'k', 'linestyle', ':')
                
                legend(groupNames, 'location', 'northeastoutside')
                legend('boxoff')
                ylabel('Z-score')
                set(gca, 'xtick', [])
                
                %% D prime
                
                thisNeuronDprime= obj.ANALYSIS.allDPrimes{j};
                
                subplot(2, 4, [7 8]);
                imagesc(thisNeuronDprime, [-2 2])
                colormap('jet')
                colorbar
                % offset = 0.5;
                
                stim_size = 5;
                % xlim([1,stim_size + 1]);
                % ylim([1,stim_size + 1]);
                [ix, iy] = meshgrid(1:stim_size, 1:stim_size);
                
                offset = 0;
                for i = 1 : stim_size
                    for jj = 1 : stim_size
                        
                        % replace 'NaN' text with ''
                        if isnan(thisNeuronDprime(i, jj))
                            this_string = '';
                        else
                            this_string = num2str(thisNeuronDprime(i, jj));
                        end
                        
                        text(ix(ix == jj & iy == i) + offset, iy(ix == jj & iy == i) + offset, this_string, 'HorizontalAlignment', 'center', 'FontSize', 14, 'Color', 'k', 'FontWeight', 'bold');%, 'BackgroundColor', grey_color);
                        
                    end
                end
                
                set(gca, 'XTick', (1:1:stim_size) + offset)
                set(gca, 'YTick', (1:1:stim_size) + offset)
                
                set(gca, 'XtickLabel', char(groupNames{1:stim_size}));
                % using char() instead of {} will center all labels on the same
                % point.
                set(gca, 'YtickLabel', char(groupNames{1:stim_size}));
                title('D-Prime Selectivity Score')
                
               
             
                %%
                
                
               
                %%
                
                
                plotDir = [obj.PATH.nidaq_path 'SummaryPlots' obj.PATH.dirD];
                
                if exist(plotDir, 'dir') ==0
                    mkdir(plotDir);
                    disp(['Created directory: ' plotDir])
                end
                
                
                saveName = [plotDir 'ClustID-' num2str(thisNeuronID) '_summary'];
                plotpos = [0 0 50 15];
                print_in_A4(0, saveName, '-djpeg', 0, plotpos);
                
                
                
                
            end
            
            
            
            
            
            
        end
    end
    
    %%
    
    methods (Hidden)
        %class constructor
        function obj = NeuropixAnalysis_OBJ()
            
            obj = getPathInfo(obj);
            
        end
    end
    
end



