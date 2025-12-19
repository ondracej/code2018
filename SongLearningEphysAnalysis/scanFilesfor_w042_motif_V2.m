function [] = scanFilesfor_w042_motif_V2()             
searchDir = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w042\Data\2022-01-16-Songs\';

params.fsTarget   = 32000;
params.winLength  = 512;
params.hopLength  = 128;
params.nfft       = 1024;

% Birdsong frequency band
params.fRange = [2000 9000];

% Detection thresholds (tune for your data)
params.energyThresh     = 1.5;   % z-score of spectral energy
params.sparsityThresh  = 0.6;   % how peaky the spectrum is
params.minSongDuration = 0.25;  % seconds of detected activity

%% ===================== FILE LIST =====================
files = dir(fullfile(searchDir, '*.wav'));
nFiles = numel(files);

detectedFiles = {};
detectionInfo = struct();

fprintf('Scanning %d files for birdsong...\n', nFiles);

%% ===================== MAIN LOOP =====================
for i = 1:nFiles
    filePath = fullfile(files(i).folder, files(i).name);

    try
        [audio, fs] = audioread(filePath);
    catch
        warning('Could not read %s', files(i).name);
        continue
    end

    audio = mean(audio, 2);

    % Resample
    if fs ~= params.fsTarget
        audio = resample(audio, params.fsTarget, fs);
    end

    % Skip very quiet files
    if rms(audio) < 0.005
        continue
    end

    %% -------- Spectrogram --------
    [S, F, T] = spectrogram(audio, ...
        params.winLength, ...
        params.winLength - params.hopLength, ...
        params.nfft, ...
        params.fsTarget);

    freqIdx = F >= params.fRange(1) & F <= params.fRange(2);
    S = abs(S(freqIdx, :));
    F = F(freqIdx);

    % Log magnitude
    S = log10(S + eps);

    %% -------- Remove Narrowband Line Noise --------
    % Line noise = frequency bins with very low temporal variance
    freqVar = std(S, 0, 2);
    lineIdx = freqVar < prctile(freqVar, 10);  % bottom 10%
    S(lineIdx, :) = 0;

    %% -------- Normalize --------
    S = (S - mean(S(:))) / std(S(:));

    %% -------- Feature Extraction --------
    % Spectral energy over time
    energy_t = mean(S, 1);

    % Spectral sparsity (birdsong is peaky, noise is flat)
    sparsity_t = 1 - (mean(exp(S), 1).^2 ./ mean(exp(2*S), 1));

    %% -------- Birdsong Decision Per Time Bin --------
    songBins = (energy_t > params.energyThresh) & ...
               (sparsity_t > params.sparsityThresh);

    %% -------- Merge Consecutive Detections --------
    songTime = sum(songBins) * (params.hopLength / params.fsTarget);

    if songTime >= params.minSongDuration
        detectedFiles{end+1} = files(i).name; %#ok<SAGROW>

        detectionInfo(end+1).file = files(i).name; %#ok<SAGROW>
        detectionInfo(end).songDuration = songTime;
        detectionInfo(end).songFraction = mean(songBins);

        fprintf('? %s (%.2f s birdsong)\n', ...
            files(i).name, songTime);
    end
end

%% ===================== RESULTS =====================
fprintf('\nBirdsong detected in %d files\n', numel(detectedFiles));
disp(detectedFiles);