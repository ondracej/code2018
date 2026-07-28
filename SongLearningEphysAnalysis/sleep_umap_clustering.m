%% SLEEP_UMAP_CLUSTERING
% Pipeline: downsample raw wideband LFP -> segment into 50-ms snippets ->
% continuous wavelet transform (log-frequency scalogram, high resolution
% at low freq) -> UMAP embedding -> unsupervised clustering, to look for
% sleep micro-states beyond the standard NREM/REM dichotomy.
%
% Configured for: 30 kHz raw acquisition, multiple channels, no expert
% stage labels (purely unsupervised — everything downstream is
% self-validating via silhouette score and cluster fingerprints rather
% than comparison to ground truth).
%
% DEPENDENCIES (not bundled with base MATLAB):
%   - Wavelet Toolbox               (cwt)
%   - Signal Processing Toolbox     (filtfilt/resample for downsampling)
%   - Statistics and Machine Learning Toolbox (pca, kmeans, silhouette)
%   - UMAP for MATLAB by Connor Meehan et al. (function run_umap.m)
%       File Exchange: "UMAP" -> https://www.mathworks.com/matlabcentral/fileexchange/71902
%       Add its folder to your path before running this script.
%
% USAGE
%   Replace SECTION 1 with a load of your real raw data:
%     rawLfp: nSamples x nChannels double, sampled at 30000 Hz
%   Everything downstream operates on the downsampled, multi-channel
%   trace automatically.

clear; close all; clc;
rng(1); % reproducibility for synthetic data / clustering

%% ------------------------------------------------------------------
% SECTION 0: PARAMETERS
% ---------------------------------------------------------------------
p = struct();
p.fsRaw            = 30000;   % Hz, your acquisition rate
p.fsTarget         = 1000;    % Hz, working rate for LFP/spectral analysis. 1000 Hz gives Nyquist=500Hz, far more than needed for <120Hz sleep oscillations, with a comfortable anti-alias margin. Drop to 500 Hz if memory/runtime is tight.
p.segDur           = 0.050;   % s, snippet length (50 ms as requested)
p.segStep          = 0.050;   % s, step between snippet starts (0.050 = no overlap; use e.g. 0.010 for a sliding/overlapping window)
p.contextDur       = 2.0;     % s, real (non-reflected) data padded around each snippet before the CWT, so low-frequency wavelets aren't edge-corrupted. Must span several cycles of your lowest frequency of interest.
p.freqLimits       = [1 120]; % Hz, range of interest (delta through low-gamma; extend if you want higher gamma - just keep well under fsTarget/2)
p.voicesPerOctave  = 32;      % wavelet scale density; higher = finer frequency resolution, esp. at low freq
p.logPower         = true;    % log-transform power before feature construction (recommended, power spans orders of magnitude)
p.doPCApreUMAP     = true;    % PCA-reduce the flattened, concatenated (multi-channel) scalograms before UMAP (recommended: raw flattened features are high-D and noisy)
p.pcaVarExplained  = 95;      % percent variance to retain in PCA
p.umap_n_neighbors = 30;
p.umap_min_dist    = 0.1;
p.umap_metric      = 'correlation';
p.nClustersRange   = 2:12;    % candidate cluster counts to scan with silhouette

%% ------------------------------------------------------------------
% SECTION 1: LOAD DATA (replace with your real raw recording)
% ---------------------------------------------------------------------
% --- Replace this block with, e.g.: ---
%   S = load('my_sleep_recording.mat');   % expects S.rawLfp (nSamples x nChannels) at p.fsRaw
%   rawLfp = S.rawLfp;
% ----------------------------------------
rawLfp = simulate_raw_sleep_lfp(p.fsRaw, 120, 3); % DEMO ONLY: 120 s, 3 channels, at 30 kHz. Delete once you plug in real data.

nChannels = size(rawLfp, 2);
fprintf('Loaded raw data: %d samples x %d channels @ %d Hz.\n', size(rawLfp,1), nChannels, p.fsRaw);

% Downsample every channel to the working rate (anti-aliased, zero-phase)
lfp = zeros(ceil(size(rawLfp,1)*p.fsTarget/p.fsRaw), nChannels);
for ch = 1:nChannels
    lfp(:,ch) = downsample_lfp(rawLfp(:,ch), p.fsRaw, p.fsTarget);
end
p.fs = p.fsTarget;
fprintf('Downsampled to %d Hz: %d samples x %d channels.\n', p.fs, size(lfp,1), nChannels);
clear rawLfp % free the large raw array

%% ------------------------------------------------------------------
% SECTION 2: SEGMENT + WAVELET FEATURE EXTRACTION (all channels)
% ---------------------------------------------------------------------
[segStarts, segCenters] = get_segment_times(size(lfp,1), p.fs, p.segDur, p.segStep, p.contextDur);
nSeg = numel(segStarts);
fprintf('Extracting wavelet features for %d segments x %d channels...\n', nSeg, nChannels);

% Probe sizes from channel 1, segment 1
[scal0, freqVec] = segment_to_scalogram(lfp(:,1), segStarts(1), p, false);
nFreq = numel(freqVec);
nTimeInSeg = size(scal0, 2);

% allScalograms: freq x time x segment x channel (for later fingerprint plots)
allScalograms = zeros(nFreq, nTimeInSeg, nSeg, nChannels, 'single');
% featMat: segments x (freq*time*channels), channel blocks concatenated per segment
featPerChan = nFreq*nTimeInSeg;
featMat = zeros(nSeg, featPerChan*nChannels, 'single');

tic
for ch = 1:nChannels
    fprintf(' Channel %d/%d...\n', ch, nChannels);
    colOffset = (ch-1)*featPerChan;
    for k = 1:nSeg
        scal = segment_to_scalogram(lfp(:,ch), segStarts(k), p, p.logPower);
        allScalograms(:,:,k,ch) = single(scal);
        featMat(k, colOffset+1:colOffset+featPerChan) = single(scal(:)');
        if mod(k,1000)==0
            fprintf('   %d / %d segments (%.1f s elapsed)\n', k, nSeg, toc);
        end
    end
end
fprintf('Done extracting features in %.1f s.\n', toc);

%% ------------------------------------------------------------------
% SECTION 3: NORMALIZE FEATURES (+ optional PCA pre-reduction)
% ---------------------------------------------------------------------
% z-score each feature column (freq x time-bin x channel) across all
% segments, so high-power low frequencies and any one "loud" channel
% don't dominate the UMAP distance metric.
featMat = double(featMat);
featMu = mean(featMat, 1);
featSigma = std(featMat, [], 1);
featSigma(featSigma==0) = 1;
featZ = (featMat - featMu) ./ featSigma;

if p.doPCApreUMAP
    [~, score, ~, ~, explained] = pca(featZ);
    cumExp = cumsum(explained);
    nPC = find(cumExp >= p.pcaVarExplained, 1, 'first');
    nPC = max(nPC, 2);
    umapInput = score(:, 1:nPC);
    fprintf('PCA: retained %d components (%.1f%% variance) before UMAP.\n', nPC, cumExp(nPC));
else
    umapInput = featZ;
end

%% ------------------------------------------------------------------
% SECTION 4: UMAP EMBEDDING
% ---------------------------------------------------------------------
if exist('run_umap', 'file') ~= 2
    error(['run_umap not found. Install "UMAP" from the MATLAB File ' ...
           'Exchange (Connor Meehan et al.) and add it to your path.']);
end

fprintf('Running UMAP on %d segments (%d-D input)...\n', size(umapInput,1), size(umapInput,2));
[embedding, ~, ~] = run_umap(umapInput, ...
    'n_neighbors', p.umap_n_neighbors, ...
    'min_dist',    p.umap_min_dist, ...
    'metric',      p.umap_metric, ...
    'n_components', 2, ...
    'verbose', 'text');
% embedding is nSeg x 2

%% ------------------------------------------------------------------
% SECTION 5: CLUSTER THE EMBEDDING
% ---------------------------------------------------------------------
% Scan candidate cluster counts with silhouette score, then finalize
% with k-means on the 2-D embedding. This is your primary validation
% signal in the absence of expert labels - also sanity-check the
% chosen k against the fingerprint plots in Section 6 (do clusters look
% spectrally distinct, or just noise splits?). Swap in dbscan/HDBSCAN
% if you expect noise points / non-convex clusters rather than a clean
% partition into k groups.
sil = zeros(size(p.nClustersRange));
kmeansResults = cell(size(p.nClustersRange));
for i = 1:numel(p.nClustersRange)
    kk = p.nClustersRange(i);
    idx = kmeans(embedding, kk, 'Replicates', 10, 'Display', 'off');
    kmeansResults{i} = idx;
    s = silhouette(embedding, idx);
    sil(i) = mean(s);
end
[~, bestI] = max(sil);
bestK = p.nClustersRange(bestI);
clusterID = kmeansResults{bestI};
fprintf('Selected k = %d clusters (mean silhouette = %.3f).\n', bestK, sil(bestI));

%% ------------------------------------------------------------------
% SECTION 6: VISUALIZATION (unsupervised - no ground truth needed)
% ---------------------------------------------------------------------

% 6a. Silhouette vs. k, to check how confidently the data separates
figure('Name','Cluster count selection');
plot(p.nClustersRange, sil, '-o', 'LineWidth', 1.5);
xlabel('Number of clusters (k)'); ylabel('Mean silhouette score');
title('UMAP-space k selection'); grid on;

% 6b. UMAP embedding colored by discovered cluster
figure('Name','UMAP embedding');
gscatter(embedding(:,1), embedding(:,2), clusterID);
xlabel('UMAP 1'); ylabel('UMAP 2');
title(sprintf('Discovered clusters (k=%d)', bestK));
legend('Location','bestoutside');

% 6c. Sanity-check overlay: color the same embedding by a simple,
% interpretable continuous quantity (total broadband power) instead of
% cluster ID. If clusters track this trivially, that's worth knowing;
% if they cut across it, that's a sign UMAP is finding structure beyond
% simple amplitude.
segPower = squeeze(mean(mean(allScalograms,1),2)); % nSeg x nChannels
segPowerMean = mean(segPower, 2);
figure('Name','Embedding vs. broadband power');
scatter(embedding(:,1), embedding(:,2), 15, segPowerMean, 'filled');
colorbar; xlabel('UMAP 1'); ylabel('UMAP 2');
title('Colored by mean log-power across channels (sanity check)');

% 6d. Mean scalogram ("fingerprint") per discovered cluster, averaged
% across channels — this is the key plot for interpreting *why* the
% clusters differ spectrally/temporally within the 50-ms window.
figure('Name','Cluster-averaged scalograms');
tSeg = linspace(0, p.segDur*1000, nTimeInSeg); % ms
for c = 1:bestK
    subplot(ceil(bestK/3), 3, c);
    meanScal = mean(mean(allScalograms(:,:, clusterID==c, :), 3), 4);
    imagesc(tSeg, freqVec, meanScal);
    axis xy;
    set(gca,'YScale','log');
    xlabel('Time in segment (ms)'); ylabel('Freq (Hz)');
    title(sprintf('Cluster %d (n=%d)', c, sum(clusterID==c)));
    colorbar;
end
sgtitle('Mean log-power scalogram per discovered cluster (averaged across channels)');

% 6e. Optional: per-channel fingerprint for one cluster of interest, to
% check whether clusters are driven by a specific channel/region rather
% than being globally coherent. Set clusterOfInterest to inspect.
clusterOfInterest = 1;
figure('Name', sprintf('Cluster %d, per-channel scalograms', clusterOfInterest));
for ch = 1:nChannels
    subplot(1, nChannels, ch);
    meanScal = mean(allScalograms(:,:, clusterID==clusterOfInterest, ch), 3);
    imagesc(tSeg, freqVec, meanScal);
    axis xy; set(gca,'YScale','log');
    xlabel('Time (ms)'); ylabel('Freq (Hz)');
    title(sprintf('Channel %d', ch));
end
sgtitle(sprintf('Cluster %d fingerprint by channel', clusterOfInterest));

fprintf('\nPipeline complete. %d segments, %d channels, %d discovered clusters.\n', nSeg, nChannels, bestK);


%% ===================================================================
%  LOCAL FUNCTIONS
%  ===================================================================

function lfpOut = downsample_lfp(rawSignal, fsRaw, fsTarget)
% Anti-aliased downsampling from a high raw acquisition rate (e.g. 30 kHz)
% down to a working LFP rate. Uses a zero-phase lowpass (filtfilt) below
% the target Nyquist, then simple decimation, which avoids the phase
% distortion that plain decimate()'s IIR filter can introduce and is
% safer for the arbitrary integer/non-integer rate ratios you may have
% (e.g. 30000 -> 1000 is exact, but this generalizes if yours isn't).
    targetNyquist = fsTarget/2;
    cutoffHz = 0.9*targetNyquist; % a bit of margin below Nyquist
    [b, a] = butter(4, cutoffHz/(fsRaw/2), 'low');
    filtered = filtfilt(b, a, double(rawSignal));

    dsFactor = fsRaw/fsTarget;
    if mod(dsFactor,1) == 0
        lfpOut = filtered(1:dsFactor:end);
    else
        % non-integer ratio: resample with polyphase filtering
        [pNum, pDen] = rat(fsTarget/fsRaw);
        lfpOut = resample(filtered, pNum, pDen);
    end
end

function [segStarts, segCenters] = get_segment_times(nSamples, fs, segDur, segStep, contextDur)
% Compute sample indices for each snippet start, only keeping segments
% that have a full contextDur of real (non-reflected) data on both sides
% -- needed so low-frequency wavelet coefficients aren't edge artifacts.
    segDurSamp    = round(segDur*fs);
    segStepSamp   = round(segStep*fs);
    contextSamp   = round(contextDur/2*fs);

    firstStart = contextSamp + 1;
    lastStart  = nSamples - contextSamp - segDurSamp + 1;
    segStarts  = (firstStart:segStepSamp:lastStart)';
    segCenters = (segStarts + segDurSamp/2) / fs; % seconds
end

function [scal, freqVec] = segment_to_scalogram(lfpChan, segStart, p, applyLog)
% Extract a contextDur-wide window of REAL surrounding data centered on
% the requested 50-ms segment, run the CWT over the whole window (so low
% frequencies have legitimate support), then crop to just the columns
% (time samples) falling inside the 50-ms segment of interest.
    fs = p.fs;
    segDurSamp  = round(p.segDur*fs);
    contextSamp = round(p.contextDur/2*fs);

    winStart = segStart - contextSamp;
    winEnd   = segStart + segDurSamp - 1 + contextSamp;
    winStart = max(winStart, 1);
    winEnd   = min(winEnd, numel(lfpChan));
    x = lfpChan(winStart:winEnd);

    [cfs, freqVec] = cwt(x, 'amor', fs, ...
        'FrequencyLimits', p.freqLimits, ...
        'VoicesPerOctave', p.voicesPerOctave);
    cfs = flipud(cfs);          % low->high frequency row order
    freqVec = flipud(freqVec(:));

    pow = abs(cfs).^2;

    segOffsetInWin = segStart - winStart; % 0-based
    colStart = segOffsetInWin + 1;
    colEnd   = colStart + segDurSamp - 1;
    colEnd   = min(colEnd, size(pow,2));
    scal = pow(:, colStart:colEnd);

    if applyLog
        scal = log10(scal + eps);
    end
end

function rawLfp = simulate_raw_sleep_lfp(fsRaw, durationSec, nChannels)
% Generates synthetic MULTI-CHANNEL, 30 kHz-style wideband data purely so
% this script runs end-to-end without real data: alternates through
% Wake / NREM (delta + spindle bursts) / REM (theta-dominant) blocks,
% each internally non-stationary, plus per-channel gain/noise variation
% typical of raw acquisition. DELETE this function once real data is
% plugged in at SECTION 1.
    t = (0:1/fsRaw:durationSec-1/fsRaw)';
    rawLfp = zeros(numel(t), nChannels);

    blockDur = 30; % s per stage block, alternating pattern
    nBlocks = floor(durationSec/blockDur);
    stagesCycle = ["Wake","NREM","NREM","REM"];

    baseSig = zeros(numel(t),1);
    for b = 1:nBlocks
        idxStart = round((b-1)*blockDur*fsRaw)+1;
        idxEnd   = min(round(b*blockDur*fsRaw), numel(t));
        tb = t(idxStart:idxEnd);
        stage = stagesCycle(mod(b-1, numel(stagesCycle))+1);

        switch stage
            case "Wake"
                sig = 0.5*sin(2*pi*20*tb + 2*pi*rand);
            case "NREM"
                sig = 1.0*sin(2*pi*(1.5+0.5*sin(2*pi*0.05*tb)).*tb);
                nSpindles = randi([2 5]);
                for s = 1:nSpindles
                    cst = tb(1) + rand*(tb(end)-tb(1)-0.5);
                    env = exp(-((tb-cst).^2)/(2*0.15^2));
                    sig = sig + 0.6*env.*sin(2*pi*12*tb + 2*pi*rand);
                end
            case "REM"
                sig = 0.7*sin(2*pi*6*tb + 2*pi*rand);
        end
        baseSig(idxStart:idxEnd) = sig;
    end

    for ch = 1:nChannels
        gain = 0.7 + 0.6*rand;               % per-channel amplitude variation
        hfNoise = 0.05*randn(numel(t),1);    % broadband/high-freq noise (real 30kHz data has plenty)
        chanLag = randi([0, round(0.005*fsRaw)]); % small inter-channel lag, ms-scale
        shifted = [baseSig((chanLag+1):end); baseSig(1:chanLag)];
        rawLfp(:,ch) = gain*shifted + hfNoise;
    end
end
