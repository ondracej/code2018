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



%% 
numStates = 5;   % 4?6 works well for juveniles

gm = fitgmdist(allFeatures, numStates, ...
    'RegularizationValue',1e-5, ...
    'Replicates',5, ...
    'Options',statset('MaxIter',500));

save juvenile_gmm gm mu sigma

%%

load juvenile_gmm

[x, fs] = audioread('X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w025_50Songs\Data\2021-08-18-Last100Songs-Motifs\w25D-f01542--M.wav');
x = mean(x,2);

feats = extractFeatures(x, fs, winMs, overlap, nfft, lowFreq, highFreq);
feats = (feats - mu) ./ sigma;

states = cluster(gm, feats);

stateMeans = gm.mu;

logPowerMeans = stateMeans(:,1);

[~, order] = sort(logPowerMeans,'descend');

syllableStates = order(1:round(numStates/2));


syllMask = ismember(states, syllableStates);

% Remove very short fragments (<15 ms)
frameDur = winMs/1000 * (1-overlap);
minFrames = round(0.015 / frameDur);

syllMask = enforceMinDuration(syllMask, minFrames);

% Merge small gaps (<10 ms)
gapFrames = round(0.01 / frameDur);
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




% 
% 
% 
% %% TRAIN GAUSSIAN HMM
% [trans, emis] = trainGaussianHMM(allFeatures, numStates);
% 
% save juvenile_hmm trans emis mu sigma
% 
% 








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

function [gamma, xi, loglik] = forwardBackward(X, A, B)

% X not used directly here (kept for compatibility)
% A = transition matrix (K x K)
% B = emission likelihoods (N x K)

[N, K] = size(B);

% Normalize rows of A
A = normalize(A,2);

% ---- Forward pass ----
alpha = zeros(N,K);
scale = zeros(N,1);

% Initial state probability = uniform
pi0 = ones(1,K) / K;

alpha(1,:) = pi0 .* B(1,:);
scale(1) = sum(alpha(1,:));
alpha(1,:) = alpha(1,:) / scale(1);

for t = 2:N
    alpha(t,:) = (alpha(t-1,:) * A) .* B(t,:);
    scale(t) = sum(alpha(t,:));
    alpha(t,:) = alpha(t,:) / scale(t);
end

% ---- Backward pass ----
beta = zeros(N,K);
beta(N,:) = ones(1,K) / scale(N);

for t = N-1:-1:1
    beta(t,:) = (beta(t+1,:) .* B(t+1,:)) * A';
    beta(t,:) = beta(t,:) / scale(t);
end

% ---- Compute gamma ----
gamma = alpha .* beta;
gamma = gamma ./ sum(gamma,2);

% ---- Compute xi ----
xi = zeros(K,K,N-1);

for t = 1:N-1
    denom = (alpha(t,:) * A) .* B(t+1,:) * beta(t+1,:)';
    for i = 1:K
        numer = alpha(t,i) * A(i,:) .* B(t+1,:) .* beta(t+1,:);
        xi(i,:,t) = numer / denom;
    end
end

% ---- Log-likelihood ----
loglik = sum(log(scale));

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



