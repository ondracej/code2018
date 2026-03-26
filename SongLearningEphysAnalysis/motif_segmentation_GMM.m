function [] = motif_segmentation_GMM()


%% PARAMETERS

mainDir = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w025_50Songs\Data\';
dataDirs = {'2021-08-19-First100Songs-Motifs\', ...
    '2021-07-16-First100Songs-Motifs\', ...
    '2021-07-17-First100Songs-Motifs\', ...
    '2021-07-18-First100Songs-Motifs\', ...
    '2021-07-18-Last100Songs-Motifs\', ...
    '2021-07-20-Last100Songs-Motifs\', ...
    '2021-08-06-First100Songs-Motifs\'...
    '2021-08-06-Last100Songs-Motifs\'...
    '2021-08-05-Last100Songs-Motifs\'...
    '2021-08-04-Last100Songs-Motifs\'};


dataDirs  = {'2021-07-30-First100Songs-Motifs\'};

fsTarget = 44100;
winMs = 10;
overlap = 0.8;
nfft = 1024;

lowFreq = 200;
highFreq = 8000;

%% LOAD ALL FILES (MULTI-DAY TRAINING)
allFeatures = [];
for j = 1:numel(dataDirs)
    
files = dir(fullfile([mainDir dataDirs{j}],'*.wav'));



for k = 1:length(files)
    
    [x, fs] = audioread(fullfile(files(k).folder, files(k).name));
    x = mean(x,2);
    
    if fs ~= fsTarget
        x = resample(x, fsTarget, fs);
        fs = fsTarget;
    end
    
    feats = extractFeatures(x, fs, winMs, overlap, nfft, lowFreq, highFreq);
    flatness = exp(mean(log(Pband+eps),1)) ./ mean(Pband,1);
    allFeatures = [allFeatures; feats];
    
end
end
%% NORMALIZE FEATURES (CRITICAL for multi-day)
mu = mean(allFeatures);
sigma = std(allFeatures);
allFeatures = (allFeatures - mu) ./ sigma;

%%
numStates = 6;   % 4?6 works well for juveniles

gm = fitgmdist(allFeatures, numStates, ...
    'RegularizationValue',1e-5, ...
    'Replicates',5, ...
    'Options',statset('MaxIter',500));

save juvenile_gmm gm mu sigma

%%

load juvenile_gmm

testDataDir = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w025_50Songs\Data\2021-07-30-First100Songs-Motifs\';

testfiles = dir(fullfile(testDataDir,'*.wav'));

for k = 1:length(testfiles)
    
    [x, fs] = audioread(fullfile(testfiles(k).folder, testfiles(k).name));
    
    
    %[x, fs] = audioread('X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w025_50Songs\Data\2021-08-18-Last100Songs-Motifs\w25D-f01542--M.wav');
    x = mean(x,2);
    
    feats = extractFeatures(x, fs, winMs, overlap, nfft, lowFreq, highFreq);
    feats = (feats - mu) ./ sigma;
    
    states = cluster(gm, feats);
    
    stateMeans = gm.mu;
    
    logPowerMeans = stateMeans(:,1);
    entropyMeans  = stateMeans(:,2);
    
    % Composite score
    score = zscore(logPowerMeans) - zscore(entropyMeans);
    
    [~, order] = sort(score,'descend');
    syllableStates = order(1:ceil(numStates*0.6));
    
    
    %[~, order] = sort(logPowerMeans,'descend');
    %syllableStates = order(1:round(numStates/2));
    
    
    syllMask = ismember(states, syllableStates);
    
    % Remove very short fragments (<15 ms)
    frameDur = winMs/1000 * (1-overlap);
    minFrames = round(0.010 / frameDur); % or 0.015
    
    syllMask = enforceMinDuration(syllMask, minFrames);
    
    % Merge small gaps (<10 ms)
    gapFrames = round(0.005 / frameDur); % .01
    syllMask = mergeShortGaps(syllMask, gapFrames);
    
    edges = diff([0; syllMask; 0]);
    starts = find(edges==1);
    ends   = find(edges==-1)-1;
    
    syllableTimes = [starts ends] * frameDur;
    
    t = (1:length(x))/fs;
    
    figure(103);clf; subplot(2, 1, 1)
    plot(t, x);
    axis tight
    hold on
    yL = ylim;
    for i = 1:size(syllableTimes,1)
        patch([syllableTimes(i,1) syllableTimes(i,2) ...
            syllableTimes(i,2) syllableTimes(i,1)], ...
            [yL(1) yL(1) yL(2) yL(2)], ...
            'b', 'FaceAlpha',0.2, 'EdgeColor','none')
    end
    subplot(2, 1, 2)
    
    specgram1((x/.08),512,fs,400,360);
    ylim([100 8000])
    disp('')
    pause
    
end
end



function maskOut = enforceMinDuration(maskIn, minFrames)

maskOut = false(size(maskIn));
d = diff([0; maskIn; 0]);
s = find(d==1);
e = find(d==-1)-1;

for i = 1:length(s)
    if (e(i)-s(i)+1) >= minFrames
        maskOut(s(i):e(i)) = true;
    end
end
end


function maskOut = mergeShortGaps(maskIn, gapFrames)

maskOut = maskIn;
d = diff([0; maskIn; 0]);
s = find(d==1);
e = find(d==-1)-1;

for i = 1:length(e)-1
    if (s(i+1) - e(i)) <= gapFrames
        maskOut(e(i):s(i+1)) = true;
    end
end
end



%%
function feats = extractFeatures(x, fs, winMs, overlap, nfft, lowFreq, highFreq)

win = round(winMs/1000 * fs);
noverlap = round(win * overlap);

[S,F,T] = spectrogram(x, win, noverlap, nfft, fs);
P = abs(S).^2;

% Band selection
freqIdx = F >= lowFreq & F <= highFreq;
Pband = P(freqIdx,:);

% 1) Log power
logPower = log(mean(Pband,1) + eps);

% 2) Spectral entropy
Pnorm = Pband ./ sum(Pband,1);
entropy = -sum(Pnorm .* log(Pnorm + eps),1);

% 3) Spectral centroid
centroid = sum(F(freqIdx).*Pband,1) ./ sum(Pband,1);

feats = [logPower' entropy' centroid'];

end

