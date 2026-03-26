function [] = motif_segmentation_HMM()

%HMM model for zebra finch segmeentation


%% PARAMETERS
fsTarget = 44100;
dataDir = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w025_50Songs\Data\2021-08-19-First100Songs-Motifs\';

winMs = 10;
overlap = 0.8;
nfft = 1024;

lowFreq = 500;
highFreq = 8000;

numStates = 4;      % 2?6 works well for juveniles

%% LOAD ALL FILES (MULTI-DAY TRAINING)
files = dir(fullfile(dataDir,'*.wav'));

allFeatures = [];

for k = 1:length(files)

    [x, fs] = audioread(fullfile(files(k).folder, files(k).name));
    x = mean(x,2);

    if fs ~= fsTarget
        x = resample(x, fsTarget, fs);
        fs = fsTarget;
    end

    feats = extractFeatures(x, fs, winMs, overlap, nfft, lowFreq, highFreq);
    allFeatures = [allFeatures; feats];

end

%% NORMALIZE FEATURES (CRITICAL for multi-day)
mu = mean(allFeatures);
sigma = std(allFeatures);
allFeatures = (allFeatures - mu) ./ sigma;

%% TRAIN GAUSSIAN HMM
[trans, emis] = trainGaussianHMM(allFeatures, numStates);

save juvenile_hmm trans emis mu sigma

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


function [trans, emis] = trainGaussianHMM(X, K)

% Initialize with k-means
[idx, C] = kmeans(X, K, 'Replicates',5);

trans = normalize(rand(K),2);
emis.mu = C;
emis.Sigma = repmat(cov(X), [1 1 K]);

% EM training
options = statset('MaxIter',200);

[trans, emis] = hmmtrainGaussian(X, trans, emis, options);

end

function [trans, emis] = hmmtrainGaussian(X, trans, emis, options)

K = size(trans,1);
N = size(X,1);
D = size(X,2);

for iter = 1:options.MaxIter

    % E-step
    B = zeros(N,K);

    for k = 1:K
        B(:,k) = mvnpdf(X, emis.mu(k,:), emis.Sigma(:,:,k));
    end

    [gamma, xi, loglik] = forwardBackward(X, trans, B);

    % M-step
    trans = sum(xi,3);
    trans = normalize(trans,2);

    for k = 1:K
        weight = gamma(:,k);
        emis.mu(k,:) = sum(weight .* X) / sum(weight);
        diff = X - emis.mu(k,:);
        emis.Sigma(:,:,k) = (diff' * (diff .* weight)) / sum(weight);
        emis.Sigma(:,:,k) = emis.Sigma(:,:,k) + eye(D)*1e-6;
    end
end

end

function [] = testHMM
%% 
load juvenile_hmm

[x, fs] = audioread('new_day.wav');
x = mean(x,2);

feats = extractFeatures(x, fs, winMs, overlap, nfft, lowFreq, highFreq);
feats = (feats - mu) ./ sigma;

states = hmmviterbiGaussian(feats, trans, emis);

% Identify which states correspond to syllables
% Usually high logPower + low entropy states
stateMeans = emis.mu;

[~, syllableStates] = sort(stateMeans(:,1),'descend');
syllableStates = syllableStates(1:round(numStates/2));

syllMask = ismember(states, syllableStates);

% Convert to time boundaries
frameDur = winMs/1000 * (1-overlap);
edges = diff([0; syllMask; 0]);

starts = find(edges==1);
ends = find(edges==-1)-1;

syllableTimes = [starts ends] * frameDur;

end



