function [] = segmentZFMotifsIntoSyllables()


%% PARAMETERS
dataDir = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w025_50Songs\Data\2021-08-18-Last100Songs-Motifs\';   % directory with ~50 wav files
nSyllables = 3;                    % FIXED number of syllables per motif
fsTarget = 44100;                  % resample if needed

lowFreq  = 300;                    % bandpass for finch song
highFreq = 8000;
envSmoothMs = 15;                   % envelope smoothing (ms)

%% GET FILE LIST
files = dir(fullfile(dataDir,'*.wav'));
nFiles = numel(files);

results = struct();

%% LOOP THROUGH FILES
for k = 1:nFiles
    
    %% LOAD AUDIO
    [x, fs] = audioread(fullfile(files(k).folder, files(k).name));
    x = mean(x,2); % mono
    
    if fs ~= fsTarget
        x = resample(x, fsTarget, fs);
        fs = fsTarget;
    end
    
    %% BANDPASS FILTER
    bp = designfilt('bandpassiir', ...
        'FilterOrder',4, ...
        'HalfPowerFrequency1',lowFreq, ...
        'HalfPowerFrequency2',highFreq, ...
        'SampleRate',fs);
    
    xFilt = filtfilt(bp, x);
    
    %% AMPLITUDE ENVELOPE
    env = abs(hilbert(xFilt));
    
    win = round(envSmoothMs/1000 * fs);
    envSmooth = movmean(env, win);
    
    envSmooth = envSmooth / max(envSmooth); % normalize
    figure (204); clf
    subplot(2, 1, 1)
    specgram1((x/.08),512,fs,400,360);
    ylim([0 8000])
    subplot(2, 1, 2)
    plot(envSmooth)
    %% FIND PEAKS (syllable centers)
    minPeakDist = round(length(envSmooth) / (nSyllables+1));
    
    [pks, locs] = findpeaks(envSmooth, ...
        'MinPeakDistance', minPeakDist, ...
        'MinPeakHeight', 0.2);
    
    %% ENFORCE FIXED NUMBER OF SYLLABLES
    if numel(locs) < nSyllables
        warning('%s: Too few syllables detected', files(k).name);
        continue
    end
    
    % Keep strongest peaks
    [~, idx] = sort(pks, 'descend');
    locs = sort(locs(idx(1:nSyllables)));
    
    %% DEFINE SYLLABLE BOUNDARIES
    edges = [1; round((locs(1:end-1) + locs(2:end))/2); length(x)];
    
    syllableTimes = [edges(1:end-1), edges(2:end)] / fs;
    
    %% STORE RESULTS
    results(k).file = files(k).name;
    results(k).syllableTimes = syllableTimes;
    
    %% OPTIONAL PLOT
    figure(1); clf; hold on
    t = (1:length(x))/fs;
    plot(t, envSmooth)
    plot(locs/fs, envSmooth(locs), 'ro')
    for s = 1:size(syllableTimes,1)
        xline(syllableTimes(s,1),'k--')
        xline(syllableTimes(s,2),'k--')
    end
    title(files(k).name)
    drawnow
end

end