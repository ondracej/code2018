
function [] = scanFilesfor_w042_motif()


motifFile = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w042\Data\2022-01-16-Songs-Motifs\w042D-f21996--M.wav';
searchDir = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w042\Data\2022-01-16\';
%corrThreshold = 0.55;
corrThreshold = 0.25;

% Spectrogram parameters (tradeoff accuracy vs speed)
params.fsTarget   = 32000;   % Downsample for speed
params.winLength  = 512;
params.hopLength  = 128;
params.nfft       = 1024;

% Frequency band (Hz)
%params.fRange = [2000 8000];
params.fRange = [2000 6000];

%% ===================== LOAD & PREPROCESS MOTIF =====================
[motif, fs] = audioread(motifFile);
motif = mean(motif, 2);

% Resample if needed
if fs ~= params.fsTarget
    motif = resample(motif, params.fsTarget, fs);
end

% Spectrogram
[S_m, F, ~] = spectrogram(motif, ...
    params.winLength, ...
    params.winLength - params.hopLength, ...
    params.nfft, ...
    params.fsTarget);

% Frequency selection
freqIdx = F >= params.fRange(1) & F <= params.fRange(2);
S_m = abs(S_m(freqIdx, :));

% Log power + normalization
S_m = log10(S_m + eps);
S_m = (S_m - mean(S_m(:))) / std(S_m(:));

motifSize = size(S_m);

%% ===================== FILE LIST =====================
files = dir(fullfile(searchDir, '*.wav'));
nFiles = numel(files);

detectedFiles = {};
detectionInfo = struct();

fprintf('Searching %d files...\n', nFiles);

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

    % Resample if needed
    if fs ~= params.fsTarget
        audio = resample(audio, params.fsTarget, fs);
    end

    % Skip files shorter than motif
    if length(audio) < length(motif)
        continue
    end

    % Spectrogram
    [S, ~, T] = spectrogram(audio, ...
        params.winLength, ...
        params.winLength - params.hopLength, ...
        params.nfft, ...
        params.fsTarget);

    S = abs(S(freqIdx, :));
    S = log10(S + eps);

    % Normalize spectrogram
    S = (S - mean(S(:))) / std(S(:));

    % 2D normalized cross-correlation
    C = normxcorr2(S_m, S);

    maxCorr = max(C(:));

    % Detection decision
    if maxCorr >= corrThreshold
        detectedFiles{end+1} = files(i).name; %#ok<SAGROW>

        % Optional: estimate time of detection
        [~, idx] = max(C(:));
        [~, col] = ind2sub(size(C), idx);
        timeSec = T(max(1, col - motifSize(2)));

        detectionInfo(end+1).file = files(i).name; %#ok<SAGROW>
        detectionInfo(end).corr = maxCorr;
        detectionInfo(end).time = timeSec;

        fprintf('? %s (corr = %.2f at %.2fs)\n', ...
            files(i).name, maxCorr, timeSec);
    end
end

%% ===================== RESULTS =====================
fprintf('\nDetected motif in %d files:\n', numel(detectedFiles));
disp(detectedFiles);

end