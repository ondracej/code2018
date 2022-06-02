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
            
            
            code2018Path = 'C:\Users\dlc\Documents\GitHub\code2018';
            SpikeGLXTools = 'C:\Users\Neuropix\Documents\GitHub\SpikeGLX_Datafile_Tools';
            
            if isfolder(code2018Path)
                addpath(genpath(code2018Path));
            else
                disp('Please check definition for code2018 path in "getPathInfo"')
            end
            
            if isfolder(SpikeGLXTools)
                addpath(genpath(SpikeGLXTools));
            else
                disp('Please check definition for SpikeGLXTools path in "getPathInfo"')
            end
            
            % Ask user for binary file
            [lfp_binName, lfp_path] = uigetfile('*.bin', 'Select LFP .bin file');
            [ap_binName, ap_path] = uigetfile('*.bin', 'Select AP .bin file');
            [nidaq_binName, nidaq_path] = uigetfile('*.bin', 'Select Nidaq .bin file');
            [wavfile_Name, wavfile_path] = uigetfile('*.wav', 'Select stimulus .wav file');
            [soundfile_Name, soundfile_path] = uigetfile('*.mat', 'Select stimulus startstop .mat');
            
            %This mapping scheme is implemented as follows. A common 1 Hz square wave is
            %recorded in one channel of each data stream throughout the experiment. In offline
            %processing, the rising edges in this "sync wave" are paired across streams A & B.
            %Any event (T) occurring in B is no more than one second away from a nearest
            %(preceding) sync wave edge (Eb) in stream B. That edge has a simultaneously
            %occurring matching edge (Ea) in stream A. To map T in stream B to T' in stream A,
            %we simply calculate:
            
            %T' = T - Eb + Ea.
            
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
                
                %figure; plot(yRMS(1:100*Fs))
                WavChan_Thresh = 0.1;
                
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
                
                
                obj.ANALYSIS.StimOnsets_fs_nidaq = SS_nidaq.StimOnsets;
                obj.ANALYSIS.StimOffsets_fs_nidaq = SS_nidaq.StimOffsets;
                obj.ANALYSIS.allOnsets_fs_nidaq = SS_nidaq.allOnsets_fs_nidaq;
                obj.ANALYSIS.allOffsets_fs_nidaq = SS_nidaq.allOffsets_fs_nidaq;
                
            else
                
                doPlot = 0;
                
                Onsets_s = obj.ANALYSIS.STIM.Onsets_s;
                Offsets_s = obj.ANALYSIS.STIM.Offsets_s;
                %Durations_s = obj.ANALYSIS.STIM.Durations_s;
                
                soundfile_Name = obj.PATH.soundfile_Name;
                soundfile_path = obj.PATH.soundfile_path;
                
                sound = load([soundfile_path soundfile_Name]);
                %fs_sound = 44100;
                
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
                
                
                %             allStimsStart_s = allStims{1, 1}/fs_sound;
                %             allStimsStop_s = allStims{1, 2}/fs_sound;
                %
                
                allStims1 = sort(allStims{1,2}) - sort(allStims{1, 1}); % N1
                allStims2 = sort(allStims{1,4}) - sort(allStims{1, 3}); % BOS
                allStims3 = sort(allStims{1,6}) - sort(allStims{1, 5}); % CON
                allStims4 = sort(allStims{1,8}) - sort(allStims{1, 7}); % N2
                allStims5 = sort(allStims{1,10}) - sort(allStims{1, 9}); % REV
                
                %             allStims1_s = allStims1/fs_sound;
                %             allStims2_s = allStims2/fs_sound;
                %             allStims3_s = allStims3/fs_sound;
                %             allStims4_s = allStims4/fs_sound;
                %             allStims5_s = allStims5/fs_sound;
                %
                %             allDurations_fs = [ allStims1 allStims5 allStims3 allStims2 allStims4]; % N1 REV CON BOS N2
                %             allDurations_s = allDurations_fs/ fs_sound;
                
                %AllStimsCnt = cell2mat(allStims);
                
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
                %firstCrossing = WavCrossings_fs(1);
                
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
                    
                    for o = 1:nStims
                        
                        
                        eval(['StimOnsets.' stimName '(o) = Onsets_fs_nidaq(cnt) + data_offset;'])
                        eval(['StimOffsets.' stimName '(o) = Offsets_fs_nidaq(cnt) + data_offset;'])
                        
                        allOnsets_fs_nidaq(cnt) = Onsets_fs_nidaq(cnt) + data_offset;
                        allOffsets_fs_nidaq(cnt) = Offsets_fs_nidaq(cnt) + data_offset;
                        
                        cnt = cnt+1;
                    end
                    
                end
                
                obj.ANALYSIS.StimOnsets_fs_nidaq = StimOnsets;
                obj.ANALYSIS.StimOffsets_fs_nidaq = StimOffsets;
                obj.ANALYSIS.allOnsets_fs_nidaq = allOnsets_fs_nidaq;
                obj.ANALYSIS.allOffsets_fs_nidaq = allOffsets_fs_nidaq;
                
                SS_nidaq.StimOnsets = StimOnsets;
                SS_nidaq.StimOffsets = StimOffsets;
                SS_nidaq.allOnsets_fs_nidaq = allOnsets_fs_nidaq;
                SS_nidaq.allOffsets_fs_nidaq = allOffsets_fs_nidaq;
                SS_nidaq.fs_ni = fs_ni;
                
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
            
            
            if isfile([nidaq_path nidaq_binName(1:end-9)  '__NiDaqLFP_SquareSync.mat'])
                disp(['Loading previously saved square sync file: ' [obj.PATH.nidaq_path obj.PATH.nidaq_binName(1:end-9)  '__NiDaqLFP_SquareSync.mat']])
                
                load([obj.PATH.nidaq_path obj.PATH.nidaq_binName(1:end-9)  '__NiDaqLFP_SquareSync.mat'])
                
                obj.ANALYSIS.posSyncLocs_fsNidaq = SYNC.posSyncLocs_fsNidaq;
                obj.ANALYSIS.fsNidaq = SYNC.fsNidaq;
                obj.ANALYSIS.posLFPLocs_fsLFP = SYNC.posLFPLocs_fsLFP;
                obj.ANALYSIS.fsLFP = SYNC.fsLFP;
                
            else
                
                
                
                %% LFP Sync
                lfp_binName = obj.PATH.lfp_binName;
                lpf_path = obj.PATH.lfp_path;
                
                filename = [lpf_path lfp_binName];
                syncChanIndex = 385;
                numChans = 385;
                lfpSyncDat = extractSyncChannelFromFile(obj, filename, numChans, syncChanIndex);
                lfpSyncDiff = diff(lfpSyncDat);
                
                [lfp_meta] = ReadMeta(obj, lfp_binName, lpf_path);
                
                fs_lfp = str2double(lfp_meta.imSampRate);
                
                LFPSyncThresh_pos = 30;
                lfpSyncLocs = find(lfpSyncDiff >=LFPSyncThresh_pos);
                % allDiffsLfpSyncLocs = round(diff(lfpSyncLocs)/fs_lfp);
                
                figure(203); clf
                subplot(4, 1, 1)
                plot(lfpSyncDat(1:20*fs_lfp));
                axis tight
                ylim([0 100])
                subplot(4, 1, 2)
                plot(lfpSyncDiff(1:20*fs_lfp));
                
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
                
                [b1,a1] = butter(2,[1 100]/(fs_ni/2)); % ripple burst spectral range
                filSyncChanFilt=filtfilt(b1,a1,SyncChan);
                
                
                SyncChanF = filSyncChanFilt*-1; % NI sync channle is inverted compared to LFP
                
                disp('done...');
                syncDiff = diff(SyncChanF);
                
                nSamps = numel(SyncChanF);
                dataTime_s = round(nSamps/fs_ni);
                
                SyncThreshPos = 0.01;
                SyncThreshNeg = -10;
                
                %[posPks,posLocs] = findpeaks(syncDiff, 'MinPeakHeight', SyncThreshPos);
                
                Locs = find(syncDiff >=SyncThreshPos);
                if numel(Locs) ~= numel(lfpSyncLocs)
                    keyboard
                end
                
                %             allDifssPosLocs = round(diff(Locs)/fs_ni);
                %             bla = find(allDifssPosLocs < 1);
                %             minInds = bla+1;
                %             Locs(minInds) = [];
                %
                %             allDifssPosLocs = round(diff(Locs)/fs_ni);
                %             bla = find(allDifssPosLocs > 1.05);
                %             figure; plot(allDifssPosLocs);
                
                figure(203);
                subplot(4, 1, 3)
                plot(SyncChan(1:20*fs_ni));
                axis tight
                ylim([-5 20])
                subplot(4, 1, 4)
                plot(syncDiff(1:20*fs_ni));
                
                obj.ANALYSIS.posSyncLocs_fsNidaq = Locs;
                obj.ANALYSIS.fsNidaq = fs_ni;
                obj.ANALYSIS.posLFPLocs_fsLFP = lfpSyncLocs;
                obj.ANALYSIS.fsLFP = fs_lfp;
                
                SYNC.posSyncLocs_fsNidaq = Locs;
                SYNC.fsNidaq = fs_ni;
                SYNC.posLFPLocs_fsLFP = lfpSyncLocs;
                SYNC.fsLFP = fs_lfp;
                
                save([nidaq_path nidaq_binName(1:end-9)  '__NiDaqLFP_SquareSync'], 'SYNC');
                disp(['Saved NiDaq-LFP Square Sync File: ' [nidaq_path nidaq_binName(1:end-9)  '__NiDaqLFP_SquareSync']]);
                
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
        end % ReadMeta
        
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
        end % ReadBin
        
        
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
        
    end
    
    %%
    
    methods (Hidden)
        %class constructor
        function obj = NeuropixAnalysis_OBJ()
            
            obj = getPathInfo(obj);
            
        end
    end
    
end



