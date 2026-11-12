function [] = avian_sleep_state_pipeline(data)

%% AVIAN SLEEP STATE SEGMENTATION + ARTIFACT REJECTION PIPELINE
% -------------------------------------------------------------------------
% Purpose: given ~9 hours of continuous EEG (4 ch) + LFP (4-8 ch) data,
% (1) reject artifact-contaminated segments, (2) extract short-window
% (fine time-resolution) features that track NREM/REM/wake-like state,
% (3) cluster + temporally smooth those features into a continuous state
% trace, (4) detect abrupt state-transition times, and (5) map all of
% this onto your existing 20-second coherence bins so you can flag bins
% that are "mixed" (span a transition) vs. clean/single-state.
%
% This does NOT replace your coherence/R computation - it produces a
% parallel, independent state/quality trace at finer time resolution that
% you merge with your existing 20s coherence output.
%
% Requires: Signal Processing Toolbox, Statistics and Machine Learning Toolbox
% -------------------------------------------------------------------------

clear; clc;

%% ===================== 1. USER PARAMETERS - EDIT THESE =====================

fs          = 250;     % <-- SET: sampling rate in Hz
nEEG        = 4;       % number of EEG channels
nLFP        = 8;       % number of LFP channels (use however many you actually have, 4-8)
lineNoiseHz = 50;       % mains frequency at your recording site (50 or 60). Set to [] to skip notch.

% --- Load your data here ---
% data must be [nSamples x nChannels], channel order = [EEG(1:nEEG), LFP(1:nLFP)]
% e.g.: data = load('night1_raw.mat').data;
data = [];              % <-- REPLACE with your actual data load
assert(~isempty(data), 'Load your data into the "data" variable before running.');

nChan = size(data,2);
eegIdx = 1:nEEG;
lfpIdx = (nEEG+1):(nEEG+nLFP);

% Interhemispheric EEG pairs used for the state-detection coherence feature.
% EDIT to match your actual electrode montage (e.g. left-frontal vs right-frontal, etc.)
interHemiPairs = [1 2; 3 4];   % row = [chanA chanB] indices into eegIdx

% --- Bands ---
deltaBand = [0.5 4.5];   % NREM slow-wave band
emgBand   = [20 55];     % high-frequency "movement/EMG-like" band, avoid line noise harmonics

% --- Short-window feature extraction ---
winSec  = 4;    % short analysis window (s) - long enough for a few delta cycles
stepSec = 2;    % step size (s) -> 50% overlap
winLen  = round(winSec*fs);
stepLen = round(stepSec*fs);

% --- Coherence bin (your existing analysis bins) ---
bigBinSec = 20;

% --- Artifact thresholds (tune to your data after a first look at the histograms) ---
artifact.zAmpThresh     = 6;     % robust z-score amplitude threshold (MAD-based)
artifact.kurtThresh     = 6;     % kurtosis threshold (spiky/transient artifacts)
artifact.emgRatioZ      = 4;     % z-score threshold on EMG-band/broadband power ratio
artifact.flatlineStdTol = 1e-6;  % near-zero std -> flatline/disconnected channel
artifact.clipTolFrac    = 0.001; % fraction of window at/near min or max ADC value -> clipping
artifact.maxBadChanFrac = 0.5;   % if more than this fraction of channels are bad, window is globally bad

% --- HMM / state model ---
nStates = 3;   % e.g. NREM-like / REM-wake-like / intermediate. Adjust after inspecting features.
selfTransitionBias = 0.90; % prior belief in state persistence between adjacent short windows

fprintf('Params set. nChan=%d (EEG=%d, LFP=%d), fs=%d Hz, feature window=%gs step=%gs\n', ...
    nChan, nEEG, nLFP, fs, winSec, stepSec);

%% ===================== 2. BASIC PREPROCESSING =====================

if ~isempty(lineNoiseHz)
    for h = 1:2  % notch fundamental + 1st harmonic
        f0 = lineNoiseHz*h;
        if f0 < fs/2
            wo = f0/(fs/2);
            bw = wo/35;
            [bn,an] = iirnotch(wo, bw);
            data = filtfilt(bn, an, data);
        end
    end
end

% Broad bandpass to remove slow drift and very high-frequency junk
[bhp, ahp] = butter(4, 0.3/(fs/2), 'high');
[blp, alp] = butter(4, min(100,fs/2-1)/(fs/2), 'low');
data = filtfilt(bhp, ahp, data);
data = filtfilt(blp, alp, data);

nSamples = size(data,1);
fprintf('Loaded %.2f hours of data (%d samples).\n', nSamples/fs/3600, nSamples);

%% ===================== 3. WINDOWING =====================

winStarts = 1:stepLen:(nSamples-winLen+1);
nWin = numel(winStarts);
winCenterSec = (winStarts + winLen/2 - 1)/fs;
fprintf('%d short (%gs) analysis windows.\n', nWin, winSec);

%% ===================== 4. ARTIFACT REJECTION =====================

[chanBadMask, winBadGlobal, artifactInfo] = detect_artifacts(data, winStarts, winLen, fs, emgBand, artifact);
fprintf('Flagged %d/%d windows (%.1f%%) as globally artifact-contaminated.\n', ...
    sum(winBadGlobal), nWin, 100*mean(winBadGlobal));

%% ===================== 5. FEATURE EXTRACTION =====================

feats = extract_state_features(data, winStarts, winLen, fs, deltaBand, emgBand, ...
    eegIdx, lfpIdx, interHemiPairs, chanBadMask);

featNames = feats.names;
X = feats.matrix;   % nWin x nFeat

fprintf('Extracted %d features per window: %s\n', size(X,2), strjoin(featNames, ', '));

%% ===================== 6. STATE CLUSTERING (GMM) ON CLEAN WINDOWS =====================

cleanIdx = ~winBadGlobal & all(isfinite(X),2);
Xz = nan(size(X));
mu = mean(X(cleanIdx,:), 1, 'omitnan');
sigma = std(X(cleanIdx,:), 0, 1, 'omitnan');
sigma(sigma==0) = 1;
Xz(cleanIdx,:) = (X(cleanIdx,:) - mu) ./ sigma;

rng(1); % reproducibility
gmModel = fitgmdist(Xz(cleanIdx,:), nStates, 'RegularizationValue', 1e-3, ...
    'Replicates', 5, 'Options', statset('MaxIter', 500));

% Posterior state probabilities for ALL windows (NaN rows -> NaN posteriors)
postProb = nan(nWin, nStates);
postProb(cleanIdx,:) = posterior(gmModel, Xz(cleanIdx,:));

% Order states by mean delta-power feature so state labels are consistent
deltaFeatCol = find(strcmp(featNames, 'meanDeltaRelPower_EEG'));
[~, stateOrder] = sort(gmModel.mu(:,deltaFeatCol), 'descend'); % highest delta first
% remap: stateOrder(1) -> label 1 (most NREM-like) ... stateOrder(end) -> label nStates (most wake/REM-like)
remap = zeros(nStates,1);
remap(stateOrder) = 1:nStates;
postProb(cleanIdx,:) = postProb(cleanIdx, stateOrder);

%% ===================== 7. TEMPORAL SMOOTHING (VITERBI OVER GAUSSIAN STATES) =====================

% Build emission means/covariances in the reordered state numbering
muOrdered = gmModel.mu(stateOrder,:);
sigmaOrdered = gmModel.Sigma(:,:,stateOrder);
if size(sigmaOrdered,3) ~= nStates % shared-covariance case
    sigmaOrdered = repmat(gmModel.Sigma, 1,1,nStates);
end

% Transition matrix: strong self-transition prior, uniform elsewhere
A = ones(nStates)*(1-selfTransitionBias)/(nStates-1);
A(1:nStates+1:end) = selfTransitionBias;

stateSeq = nan(nWin,1);
validRuns = find_valid_runs(cleanIdx); % contiguous runs of clean windows
for r = 1:size(validRuns,1)
    idxRange = validRuns(r,1):validRuns(r,2);
    if numel(idxRange) < 2
        [~, stateSeq(idxRange)] = max(postProb(idxRange,:), [], 2);
        continue;
    end
    obs = Xz(idxRange,:);
    stateSeq(idxRange) = viterbi_gaussian(obs, A, muOrdered, sigmaOrdered);
end

%% ===================== 8. CHANGE-POINT DETECTION (INDEPENDENT CROSS-CHECK) =====================

% Use relative delta power (broadband-normalized, most physiologically direct
% single feature) as the primary signal for abrupt transition detection.
deltaTrace = X(:, deltaFeatCol);
deltaTrace(~cleanIdx) = nan;
deltaTraceFilled = fillmissing(deltaTrace, 'linear', 'EndValues','nearest');

% findchangepts detects points where mean/variance shift abruptly
try
    cpIdx = findchangepts(deltaTraceFilled, 'Statistic','mean', ...
        'MinDistance', round(5/stepSec)); % ignore changes closer than ~5s apart
catch
    cpIdx = [];
    warning('findchangepts unavailable or failed; skipping change-point cross-check.');
end
changePointMask = false(nWin,1);
changePointMask(cpIdx) = true;

fprintf('Detected %d change-points in the delta-power trace.\n', numel(cpIdx));

%% ===================== 9. MAP ONTO YOUR EXISTING 20s COHERENCE BINS =====================

bigBinEdgesSec = 0:bigBinSec:(nSamples/fs);
nBigBins = numel(bigBinEdgesSec)-1;

binReport = table((1:nBigBins)', nan(nBigBins,1), nan(nBigBins,1), nan(nBigBins,1), false(nBigBins,1), ...
    'VariableNames', {'binIndex','dominantState','dominantStateFraction','artifactFraction','hasChangePoint'});

for b = 1:nBigBins
    t0 = bigBinEdgesSec(b); t1 = bigBinEdgesSec(b+1);
    inBin = winCenterSec >= t0 & winCenterSec < t1;
    if ~any(inBin)
        continue;
    end
    statesInBin = stateSeq(inBin);
    statesInBin = statesInBin(~isnan(statesInBin));
    if isempty(statesInBin)
        binReport.artifactFraction(b) = 1;
        continue;
    end
    counts = histcounts(statesInBin, 0.5:1:(nStates+0.5));
    [maxCount, domState] = max(counts);
    binReport.dominantState(b) = domState;
    binReport.dominantStateFraction(b) = maxCount / numel(statesInBin);
    binReport.artifactFraction(b) = mean(winBadGlobal(inBin));
    binReport.hasChangePoint(b) = any(changePointMask(inBin));
end

% Practical flag: exclude/treat with caution any bin that is either
% majority-artifact, or doesn't have a clearly dominant state (<80%), or
% contains a detected change-point.
binReport.flagForExclusion = binReport.artifactFraction > 0.25 | ...
    binReport.dominantStateFraction < 0.8 | binReport.hasChangePoint;

fprintf('\n%d / %d (%.1f%%) of your 20s bins are flagged as mixed/artifact-contaminated.\n', ...
    sum(binReport.flagForExclusion), nBigBins, 100*mean(binReport.flagForExclusion));

%% ===================== 10. SAVE OUTPUTS =====================

save('sleep_state_pipeline_output.mat', 'binReport', 'stateSeq', 'postProb', 'X', 'featNames', ...
    'winCenterSec', 'winBadGlobal', 'changePointMask', 'gmModel', 'stateOrder');

% Quick visualization
figure('Color','w','Position',[100 100 1100 500]);
subplot(3,1,1);
plot(winCenterSec/3600, X(:,deltaFeatCol)); hold on;
plot(winCenterSec(winBadGlobal)/3600, X(winBadGlobal,deltaFeatCol), 'r.');
ylabel('Rel. delta power'); title('Delta power trace (red = artifact-flagged windows)');
xlim([0 nSamples/fs/3600]);

subplot(3,1,2);
stairs(winCenterSec/3600, stateSeq, 'LineWidth',1.2); hold on;
plot(winCenterSec(changePointMask)/3600, stateSeq(changePointMask), 'kv','MarkerFaceColor','k');
ylabel('State'); ylim([0.5 nStates+0.5]); yticks(1:nStates);
title('Smoothed state sequence (triangles = detected change-points)');
xlim([0 nSamples/3600/fs*fs]); xlim([0 nSamples/fs/3600]);

subplot(3,1,3);
stem(binReport.binIndex*bigBinSec/3600, binReport.flagForExclusion, 'filled', 'MarkerSize',3);
ylabel('Flag'); xlabel('Time (hours)'); ylim([-0.2 1.2]);
title('20s bins flagged as mixed/artifact-contaminated');

fprintf('\nDone. Merge sleep_state_pipeline_output.mat''s "binReport" with your coherence table on binIndex.\n');


%% ===================== LOCAL FUNCTIONS =====================
end

function [chanBadMask, winBadGlobal, info] = detect_artifacts(data, winStarts, winLen, fs, emgBand, p)
nWin = numel(winStarts);
nChan = size(data,2);
chanBadMask = false(nWin, nChan);

% Robust per-channel scale (MAD) computed over the WHOLE recording,
% used for the amplitude z-score criterion.
chanMed = median(data,1);
chanMAD = mad(data,1,1); chanMAD(chanMAD==0) = eps;

globalMin = min(data,[],1); globalMax = max(data,[],1);

emgRatioAll = nan(nWin, nChan);

for w = 1:nWin
    idx = winStarts(w):(winStarts(w)+winLen-1);
    seg = data(idx,:);
    
    % --- flatline ---
    flat = std(seg,0,1) < p.flatlineStdTol;
    
    % --- clipping: fraction of samples at/near recording min or max ---
    tolRange = 0.001*(globalMax-globalMin);
    nearMax = abs(seg - globalMax) < max(tolRange, eps);
    nearMin = abs(seg - globalMin) < max(tolRange, eps);
    clipFrac = mean(nearMax | nearMin, 1);
    clipped = clipFrac > p.clipTolFrac;
    
    % --- robust amplitude z-score (peak-to-peak based) ---
    segRange = range(seg,1);
    ampZ = abs(segRange - median(range(seg,1))) ./ (1.4826*chanMAD + eps);
    ampBad = ((max(abs(seg),[],1) - chanMed) ./ (1.4826*chanMAD+eps)) > p.zAmpThresh;
    
    % --- kurtosis ---
    kurtBad = kurtosis(seg,1,1) > p.kurtThresh;
    
    % --- EMG/high-frequency power ratio (computed per-window, z-scored later across the night) ---
    for c = 1:nChan
        pxx_broad = bandpower(seg(:,c), fs, [0.5 min(100,fs/2-1)]);
        pxx_emg   = bandpower(seg(:,c), fs, emgBand);
        emgRatioAll(w,c) = pxx_emg / (pxx_broad + eps);
    end
    
    chanBadMask(w,:) = flat | clipped | ampBad | kurtBad;
end

% z-score the EMG ratio across the night per channel, flag outliers (movement bursts)
emgZ = (emgRatioAll - mean(emgRatioAll,1,'omitnan')) ./ (std(emgRatioAll,0,1,'omitnan')+eps);
emgBad = emgZ > p.emgRatioZ;
chanBadMask = chanBadMask | emgBad;

winBadGlobal = mean(chanBadMask,2) > p.maxBadChanFrac;

info.emgRatioAll = emgRatioAll;
info.emgZ = emgZ;
end


function feats = extract_state_features(data, winStarts, winLen, fs, deltaBand, emgBand, eegIdx, lfpIdx, interHemiPairs, chanBadMask)
nWin = numel(winStarts);
names = {};
cols = {};

relDeltaEEG = nan(nWin,1);
relDeltaLFP = nan(nWin,1);
emgPowEEG   = nan(nWin,1);
sef95EEG    = nan(nWin,1);
cohDelta    = nan(nWin, size(interHemiPairs,1));

% sub-segment length for coherence estimation within each short window
subWinLen = min(winLen, round(1.0*fs));      % 1s sub-segments
subOverlap = round(subWinLen*0.5);

for w = 1:nWin
    idx = winStarts(w):(winStarts(w)+winLen-1);
    seg = data(idx,:);
    badChan = chanBadMask(w,:);
    
    goodEEG = eegIdx(~badChan(eegIdx));
    goodLFP = lfpIdx(~badChan(lfpIdx));
    
    if ~isempty(goodEEG)
        rd = nan(1,numel(goodEEG));
        for k = 1:numel(goodEEG)
            c = goodEEG(k);
            pB = bandpower(seg(:,c), fs, [0.5 min(100,fs/2-1)]);
            pD = bandpower(seg(:,c), fs, deltaBand);
            rd(k) = pD/(pB+eps);
        end
        relDeltaEEG(w) = mean(rd);
        
        ep = nan(1,numel(goodEEG));
        sef = nan(1,numel(goodEEG));
        for k = 1:numel(goodEEG)
            c = goodEEG(k);
            ep(k) = bandpower(seg(:,c), fs, emgBand);
            [pw,f] = pwelch(seg(:,c), min(winLen,fs), [], [], fs);
            cumPow = cumsum(pw)/sum(pw);
            idx95 = find(cumPow >= 0.95, 1, 'first');
            sef(k) = f(idx95);
        end
        emgPowEEG(w) = mean(ep);
        sef95EEG(w) = mean(sef);
    end
    
    if ~isempty(goodLFP)
        rd2 = nan(1,numel(goodLFP));
        for k = 1:numel(goodLFP)
            c = goodLFP(k);
            pB = bandpower(seg(:,c), fs, [0.5 min(100,fs/2-1)]);
            pD = bandpower(seg(:,c), fs, deltaBand);
            rd2(k) = pD/(pB+eps);
        end
        relDeltaLFP(w) = mean(rd2);
    end
    
    for pIdx = 1:size(interHemiPairs,1)
        a = interHemiPairs(pIdx,1); b = interHemiPairs(pIdx,2);
        if badChan(a) || badChan(b)
            continue;
        end
        [Cxy,f] = mscohere(seg(:,a), seg(:,b), hamming(subWinLen), subOverlap, [], fs);
        inBand = f >= deltaBand(1) & f <= deltaBand(2);
        cohDelta(w,pIdx) = mean(Cxy(inBand));
    end
end

names = [names, {'meanDeltaRelPower_EEG','meanDeltaRelPower_LFP','meanEMGPower_EEG','meanSEF95_EEG'}];
cols = [cols, {relDeltaEEG, relDeltaLFP, emgPowEEG, sef95EEG}];
for pIdx = 1:size(interHemiPairs,1)
    names{end+1} = sprintf('interHemiDeltaCoh_pair%d', pIdx); %#ok<AGROW>
    cols{end+1} = cohDelta(:,pIdx); %#ok<AGROW>
end

feats.names = names;
feats.matrix = cat(2, cols{:});
end


function runs = find_valid_runs(mask)
% Returns [startIdx endIdx] for each contiguous run of true values in mask
d = diff([0; mask(:); 0]);
starts = find(d==1);
ends = find(d==-1)-1;
runs = [starts, ends];
end


function stateSeq = viterbi_gaussian(obs, A, mu, sigma)
% Minimal Viterbi decoder for multivariate-Gaussian-emission HMM.
% obs: T x D, A: nStates x nStates, mu: nStates x D, sigma: D x D x nStates
[T, ~] = size(obs);
nStates = size(A,1);
logA = log(A + eps);

logB = nan(T, nStates);
for s = 1:nStates
    try
        logB(:,s) = log(mvnpdf(obs, mu(s,:), sigma(:,:,s)) + eps);
    catch
        % fallback if covariance is near-singular
        logB(:,s) = log(mvnpdf(obs, mu(s,:), sigma(:,:,s) + 1e-3*eye(size(sigma,1))) + eps);
    end
end

logDelta = nan(T, nStates);
psi = zeros(T, nStates);
logDelta(1,:) = log(1/nStates) + logB(1,:);

for t = 2:T
    for s = 1:nStates
        [maxVal, maxIdx] = max(logDelta(t-1,:) + logA(:,s)');
        logDelta(t,s) = maxVal + logB(t,s);
        psi(t,s) = maxIdx;
    end
end

stateSeq = zeros(T,1);
[~, stateSeq(T)] = max(logDelta(T,:));
for t = (T-1):-1:1
    stateSeq(t) = psi(t+1, stateSeq(t+1));
end
end
