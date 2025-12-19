function [] = removeLineNoise_w042()

%% ===================== PARAMETERS =====================
searchDir = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w042\Data\2022-01-16-Songs\';
params.fsTarget   = 32000;
params.winLength  = 512;
params.hopLength  = 128;
params.nfft       = 1024;
params.fRange = [2000 6000];

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
%specgram1((audio/.02),512,fs,400,360);

    %% -------- Spectrogram --------
    
    [S,f,t] = specgram1((audio/.02), 512,fs,400,360);

    

    %% -------- Feature Extraction --------
    % Spectral energy over time
    energy_t = mean(S, 1);
subplot(3, 1, 1)
    image(t,f,40*log10(abs(S)+10e-1));axis xy; colormap(jet)
subplot(3, 1, 2)
plot(real(energy_t))
axis tight
subplot(3, 1, 3)
plot(real(sparsity_t))    

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

end