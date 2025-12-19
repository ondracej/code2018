function [] = scanFilesfor_w042_motif_V3()             
audioDir = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w042\Data\2021-12-31\';  % directory containing WAV files
destNo  = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w042\Data\2021-12-31-ToDiscard\';


birdBand = [2000 6000];     % Hz
%energyThreshold_dB = -25;   % relative to noise floor
energyThreshold_dB = -3;   % relative to noise floor
minActiveFrames = 20;       % frames required for detection

%% Spectrogram parameters
window = hamming(1024);
noverlap = 768;
nfft = 2048;

%% Get WAV files
files = dir(fullfile(audioDir, '*.wav'));

if isempty(files)
    error('No WAV files found in directory.');
end

%% Results storage
results = struct('filename', {}, 'detected', {}, ...
                 'activeFrames', {}, 'noiseFloor_dB', {});

%% Process each file
for k = 1:length(files)

    filename = files(k).name;
    filepath = fullfile(audioDir, filename);

    %% Load audio
    [x, fs] = audioread(filepath);
    x = mean(x, 2);   % convert to mono

    %% Compute spectrogram
    [S, F, T] = spectrogram(x, window, noverlap, nfft, fs);
  
   
    %% Power spectrogram (dB)
    P_dB = 10*log10(abs(S).^2 + eps);

    %% Select frequency band
    bandIdx = F >= birdBand(1) & F <= birdBand(2);

    if ~any(bandIdx)
        warning('No frequencies in bird band for %s', filename);
        continue
    end

    %% Average band energy over frequency
    bandEnergy_dB = mean(P_dB(bandIdx, :), 1);
  %{
    figure(100); clf
    subplot(2, 1, 1)
     specgram1((x/.02),512,fs,400,360);
     ylim([2000 10001]);
     subplot(2, 1, 2)
plot(bandEnergy_dB)
axis tight
%}
    %% Estimate noise floor
    noiseFloor = median(bandEnergy_dB);

    %% Detect active frames
    %activeFrames = bandEnergy_dB > (noiseFloor + abs(energyThreshold_dB));
    activeFrames = bandEnergy_dB > -34;
    numActiveFrames = sum(activeFrames);

    %% Decision
    birdsongDetected = numActiveFrames >= minActiveFrames;



% Ensure destination folders exist

if ~exist(destNo, 'dir')
    mkdir(destNo);
end

if birdsongDetected == 0
    [~, name, ext] = fileparts(filepath);

    movefile(filepath, fullfile(destNo, [name ext]));
end
    
    
    %% Store results
    results(k).filename = filename;
    results(k).detected = birdsongDetected;
    results(k).activeFrames = numActiveFrames;
    results(k).noiseFloor_dB = noiseFloor;

    %% Console output
    fprintf('%s : %s (%d active frames)\n', ...
        filename, ...
        ternary(birdsongDetected, 'BIRDSONG', 'no birds'), ...
        numActiveFrames);
end

%% Summary
numDetected = sum([results.detected]);
fprintf('\nDetected birdsong in %d of %d files.\n', ...
    numDetected, length(results));

end

function out = ternary(cond, a, b)
    if cond
        out = a;
    else
        out = b;
    end
end