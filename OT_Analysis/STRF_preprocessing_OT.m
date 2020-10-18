function [] = STRF_preprocessing_OT(experiment, recSession, NeuronName)

if nargin <3
    
    experiment = 1;
    recSession = 3;
    NeuronName = 'N-03';
end

dirD = '/';

C_OBJ = chicken_OT_analysis_OBJ(experiment, recSession);

%%
allStims = C_OBJ.RS_INFO.StimProtocol_name;
tf = find(strcmpi(allStims,'HRTF'));

audSelInd = tf(1); % SpikesThis is the index, spikesnot the stim number!!!
Stim = C_OBJ.RS_INFO.StimProtocol_name{audSelInd};
disp(Stim);

%% Stimulus Protocol
% Stim Protocol: (1) HRTF; (2) Tuning; (3) IID; (4) ITD; (5) WN

selection = C_OBJ.RS_INFO.ResultDirName{audSelInd};
disp(selection)

%% RE Loading Object 0 ONLY USE IF analyzed before!!!
%%

disp('Loading Saved Object...')

audStimDir = C_OBJ.RS_INFO.ResultDirName{audSelInd};
objFile = 'C_OBJ.mat';
objPath = [C_OBJ.PATHS.OT_Data_Path C_OBJ.INFO.expDir C_OBJ.PATHS.dirD audStimDir C_OBJ.PATHS.dirD '__Spikes' C_OBJ.PATHS.dirD objFile];
load(objPath);
disp(['Loaded: ' objPath])

SignalDir = '/media/dlc/Data8TB/TUM/OT/Signals/';

sigFormat = '*.wav';

sigNames = dir(fullfile(SignalDir,sigFormat));
%imageNames(1) = [];
%imageNames(1) = [];
sigNames = {sigNames.name}';

nSigs = numel(sigNames);

%% Create Directories

STRF_Dir = '/media/dlc/Data8TB/TUM/OT/STRF_Analysis/';

NeuronDir = [STRF_Dir NeuronName dirD];

if exist(NeuronDir , 'dir') == 0
    mkdir(NeuronDir );
end

STRF_Stim_L_Dir = [NeuronDir 'Stims-L' dirD];
STRF_Stim_R_Dir = [NeuronDir 'Stims-R' dirD];
STRF_Spks = [NeuronDir 'Spks' dirD];

if exist(STRF_Stim_L_Dir , 'dir') == 0
    mkdir(STRF_Stim_L_Dir );
end

if exist(STRF_Stim_R_Dir , 'dir') == 0
    mkdir(STRF_Stim_R_Dir );
end

if exist(STRF_Spks , 'dir') == 0
    mkdir(STRF_Spks );
end




%%

SamplingRate = C_OBJ.SETTINGS.SampleRate;
PreStimStartTime_s = 0; % 0-100  ms
StimStartTime_s = 0.1; % 100  - 200 ms
PostStimStartTime_s = 0.2; % 200 - 300 ms

PreStimStartTime_samp = PreStimStartTime_s* SamplingRate;
StimStartTime_samp = StimStartTime_s* SamplingRate;
PostStimStartTime_samp = PostStimStartTime_s* SamplingRate;

%%

stimNames = C_OBJ.S_SPKS.SORT.allSpksStimNames;
SpkResponses = C_OBJ.S_SPKS.SORT.allSpksMatrix;

nRows = size(stimNames, 1);
nCols = size(stimNames, 2);
cnnt = 1;

smoothWin_ms = 2;

cnnt = 1;

figure(406); clf

cnt = 1;

for j = 1:nRows
    for k = 1:nCols
        
        thisSpkResp = SpkResponses{j,k};
        
        nReps = numel(thisSpkResp);
        
        %% Wav Files
        thisSigName = stimNames{j, k};
        
        [thisSigData,Fs] = audioread([SignalDir thisSigName '.wav']); % for some reason, the HRTF signal is a bit longer than the 100 ms stim period
        
        cutSigData = thisSigData(1: StimStartTime_samp,:);
        
        loudness = 0.0005;
        
        norm_data_L = cutSigData(:,1)*sqrt(loudness/mean(cutSigData(:,1).^2));
        norm_data_R = cutSigData(:,2)*sqrt(loudness/mean(cutSigData(:,2).^2));
        
        
        for ss = 1:nReps
            
            these_spks_on_Chan = thisSpkResp{ss};
            
            validSpksInds = find(these_spks_on_Chan >= StimStartTime_samp & these_spks_on_Chan <= PostStimStartTime_samp); % need to add a buffer at the start
            validSpks = these_spks_on_Chan(validSpksInds);
            
            relValidSpks = validSpks - StimStartTime_samp; % relative to the onset of the stim
            
            nbr_spks = size(relValidSpks, 2);
            
            these_spks_in_ms = round(relValidSpks/Fs*1000);
            
            SpkName = [STRF_Spks Stim '_' sprintf('%03d', cnt) '-' num2str(ss) '.txt'];
            
            % For some reason, strfpak only seems to like spike times in text files...
            save(SpkName, 'these_spks_in_ms', '-ASCII')
            
            %% Wavwrite
            
            wav_name_L = [STRF_Stim_L_Dir Stim '-L_' sprintf('%03d', cnt) '-' num2str(ss) '.wav'];
            wav_name_R = [STRF_Stim_R_Dir Stim '-R_' sprintf('%03d', cnt) '-' num2str(ss) '.wav'];
            
            
            % make sure that the sampling rate matches that of the data file,
            % otherwise the spikes will be misaligned in the STRFpak program
            %wavwrite(norm_data_L, Fs, 16, wav_name_L);
            %wavwrite(this_normalized_data_wav, scanrate_labview, 16, wav_filename);
            %audiowrite(filename,y,Fs,varargin)
            
            audiowrite(wav_name_L, norm_data_L, Fs, 'BitsPerSample',16);
            audiowrite(wav_name_R, norm_data_R, Fs, 'BitsPerSample',16);
            
            
        end
        
        cnt = cnt+1;
        
    end
end
disp('')
end
