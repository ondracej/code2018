%% ========================================================================
%  INFRASLOW OSCILLATION ANALYSIS VIA SLIDING AUTOCORRELATION
%  ========================================================================
%
%  Implements the pipeline described in the Methods:
%   1) Extract beta-band (10-30 Hz) power envelope from LFP/EEG
%   2) Z-score the beta power using a 3-min sliding window
%   3) Compute a sliding autocorrelation (1-s step, 300-s window,
%      max lag 300 s), normalized by the zero-lag value
%   4) Detect the first negative (half-period) and first positive peaks
%      of the (mean) autocorrelation function
%   5) Shuffle control: cut signal into 5-s segments, shuffle order,
%      repeat 100x, and recompute autocorrelation to show the infraslow
%      rhythm disappears
%   6) A separate routine for CBV/LFP autocorrelation from fUS
%      experiments (per-epoch, longer windows, 5-s step), averaged
%      across epochs
%
%  Author: generated pipeline based on user-provided Methods text
%  ========================================================================

%% ------------------------------------------------------------------
%  EXAMPLE USAGE (edit this section for your data)
%  ------------------------------------------------------------------
% signal      : raw LFP/EEG trace for one sleep bout, vector [1 x N]
% fs          : sampling rate (Hz)
%
% Example (synthetic data, replace with your own):
% fs = 500;
% t  = (0:1/fs:1200)';               % 20 min of data
% signal = randn(size(t));           % placeholder - use real LFP/EEG here
%
% results = run_infraslow_pipeline(signal, fs);
%
% Fields in `results`:
%   .beta_power        - raw beta (10-30Hz) power envelope
%   .beta_z            - z-scored beta power (3-min sliding window)
%   .acf_matrix         - [n_windows x n_lags] autocorrelation matrix
%   .lags_s             - lag axis in seconds
%   .win_centers_s       - time (s) of the center of each sliding window
%   .acf_mean            - mean autocorrelation function across windows
%   .neg_peak_val/.neg_peak_lag  - first negative peak (amplitude, lag)
%   .pos_peak_val/.pos_peak_lag  - first positive peak (amplitude, lag)
%   .shuffled_acf_mean   - mean autocorrelation of shuffled control
%
% See individual functions below for details.


%% ========================================================================
function results = run_infraslow_pipeline(signal, fs, varargin)
% RUN_INFRASLOW_PIPELINE  Full pipeline for one sleep bout (LFP/EEG data)
%
%   results = run_infraslow_pipeline(signal, fs)
%   results = run_infraslow_pipeline(signal, fs, 'Name', Value, ...)
%
% Optional Name-Value parameters (defaults match the Methods text):
%   'Band'          [10 30]   Hz, band used for power extraction
%   'ZscoreWinSec'  180       s, sliding window for z-scoring (3 min)
%   'AcfWinSec'     300       s, sliding autocorrelation window (300 s)
%   'AcfStepSec'    1         s, step size for sliding autocorrelation
%   'MaxLagSec'     300       s, maximum lag for autocorrelation
%   'MinProminence' 0.05      minimal peak prominence for peak detection
%   'DoShuffle'     true      whether to run the shuffle control
%   'ShuffleSegSec' 5         s, segment length for shuffling
%   'NShuffles'     100       number of shuffle repetitions

p = inputParser;
addParameter(p, 'Band',          [10 30]);
addParameter(p, 'ZscoreWinSec',  180);
addParameter(p, 'AcfWinSec',     300);
addParameter(p, 'AcfStepSec',    1);
addParameter(p, 'MaxLagSec',     300);
addParameter(p, 'MinProminence', 0.05);
addParameter(p, 'DoShuffle',     true);
addParameter(p, 'ShuffleSegSec', 5);
addParameter(p, 'NShuffles',     20);
parse(p, varargin{:});
opt = p.Results;

signal = signal(:); % column vector

disp('% ---- 1) Beta power envelope -------------------------------------------')
tic
% ---- 1) Beta power envelope -------------------------------------------
beta_power = extract_band_power(signal, fs, opt.Band);
toc


disp('% ---- 2) Z-score with 3-min sliding window -----------------------------')
tic
% ---- 2) Z-score with 3-min sliding window ------------------------------
beta_z = zscore_sliding(beta_power, fs, opt.ZscoreWinSec);
toc
disp('% ---- 3) Sliding autocorrelation ---------------------------------------')
tic
% ---- 3) Sliding autocorrelation ----------------------------------------
[acf_matrix, lags_s, win_centers_s] = sliding_autocorr( ...
    beta_z, fs, opt.AcfWinSec, opt.AcfStepSec, opt.MaxLagSec);
toc

disp('% ---- 4) Mean ACF and peak detection -------------------------------------')
tic
% ---- 4) Mean ACF and peak detection -------------------------------------
acf_mean = mean(acf_matrix, 1, 'omitnan');
[neg_val, neg_lag, pos_val, pos_lag] = extract_first_peaks( ...
    acf_mean, lags_s, opt.MinProminence);
toc

disp('% ---- 5) Shuffle control --------------------------------------------------')
tic
% ---- 5) Shuffle control --------------------------------------------------
shuffled_acf_mean = [];
if opt.DoShuffle
    shuffled_acf_mean = shuffle_control( ...
        signal, fs, opt.Band, opt.ZscoreWinSec, ...
        opt.AcfWinSec, opt.AcfStepSec, opt.MaxLagSec, ...
        opt.ShuffleSegSec, opt.NShuffles);
end
toc
% ---- Package results ------------------------------------------------------
results = struct();
results.beta_power        = beta_power;
results.beta_z             = beta_z;
results.acf_matrix          = acf_matrix;
results.lags_s              = lags_s;
results.win_centers_s        = win_centers_s;
results.acf_mean             = acf_mean;
results.neg_peak_val         = neg_val;
results.neg_peak_lag         = neg_lag;
results.pos_peak_val         = pos_val;
results.pos_peak_lag         = pos_lag;
results.shuffled_acf_mean     = shuffled_acf_mean;
results.params                = opt;

end


%% ========================================================================
function band_power = extract_band_power(signal, fs, band)
% EXTRACT_BAND_POWER  Bandpass filter + amplitude envelope (Hilbert)
%
%   band_power = extract_band_power(signal, fs, [10 30])
%
% Returns the instantaneous power (squared envelope) of the signal
% filtered in the specified band.

signal = signal(:);


[z,p,k] = butter(4, band/(fs/2), 'bandpass');
[sos,g] = zp2sos(z,p,k);

%betaEnv = abs(hilbert(LFP_beta));
%betaZ = (betaEnv - median(betaEnv))./mad(betaEnv,1);

%% APPLY ZERO-PHASE FILTER
filtered = filtfilt(sos, g, signal);



% Design a zero-phase bandpass filter (Butterworth, order 4, forward-backward)
% nyq = fs/2;
% Wn  = band ./ nyq;
% Wn  = min(max(Wn, 1e-6), 0.999); % keep within valid range
% [b, a] = butter(4, Wn, 'bandpass');
% 
% filtered = filtfilt(b, a, signal);

% Amplitude envelope via Hilbert transform, then power = envelope^2
analytic_signal = hilbert(filtered);
envelope = abs(analytic_signal);
band_power = envelope.^2;

end


%% ========================================================================
function z = zscore_sliding(x, fs, winSec)
% ZSCORE_SLIDING  Z-score a signal using a centered sliding window
%
%   z = zscore_sliding(x, fs, winSec)
%
% For each sample, compute local mean/std over a window of length
% winSec (seconds), centered on that sample, and z-score accordingly.
% Uses movmean/movstd for efficiency.

x = x(:);
winSamp = round(winSec * fs);
if mod(winSamp, 2) == 0
    winSamp = winSamp + 1; % make odd for a symmetric centered window
end

local_mean = movmean(x, winSamp, 'Endpoints', 'shrink');
local_std  = movstd(x,  winSamp, 'Endpoints', 'shrink');

local_std(local_std == 0) = eps; % avoid divide-by-zero

z = (x - local_mean) ./ local_std;

end


%% ========================================================================
function [acf_matrix, lags_s, win_centers_s] = sliding_autocorr( ...
    x, fs, winSec, stepSec, maxLagSec)
% SLIDING_AUTOCORR  Compute autocorrelation in sliding windows
%
%   [acf_matrix, lags_s, win_centers_s] = sliding_autocorr(x, fs, ...
%       winSec, stepSec, maxLagSec)
%
% x           : input signal (already z-scored), column vector
% fs          : sampling rate (Hz)
% winSec      : length of each analysis window (s)   e.g., 300
% stepSec     : step between successive windows (s)  e.g., 1
% maxLagSec   : maximum lag to compute (s)            e.g., 300
%
% Returns:
%   acf_matrix     : [n_windows x n_lags] matrix, each row is the
%                     autocorrelation of one window, normalized so
%                     that the zero-lag value = 1
%   lags_s          : [1 x n_lags] lag values in seconds (>=0)
%   win_centers_s    : [n_windows x 1] center time (s) of each window

x = x(:);
N = length(x);

winSamp    = round(winSec * fs);
stepSamp   = round(stepSec * fs);
maxLagSamp = round(maxLagSec * fs);

if winSamp > N
    error('sliding_autocorr:windowTooLong', ...
        'Analysis window (%.1f s) is longer than the signal (%.1f s).', ...
        winSec, N/fs);
end

starts = 1:stepSamp:(N - winSamp + 1);
n_windows = numel(starts);
n_lags = maxLagSamp + 1; % lags 0 .. maxLagSamp

acf_matrix    = nan(n_windows, n_lags);
win_centers_s = nan(n_windows, 1);

for i = 1:n_windows
    idx = starts(i):(starts(i) + winSamp - 1);
    seg = x(idx);
    seg = seg - mean(seg, 'omitnan'); % remove DC for autocorrelation

    % xcorr with 'coeff' would normalize by variance globally; here we
    % explicitly normalize by the zero-lag value of THIS window, per the
    % Methods ("normalized ... based on the value at zero lag").
    maxlag_this = min(maxLagSamp, winSamp - 1);
    [c, lagSamp] = xcorr(seg, maxlag_this, 'biased');

    % keep only non-negative lags
    posIdx = lagSamp >= 0;
    c_pos = c(posIdx);
    lag_pos = lagSamp(posIdx);

    zeroLagVal = c_pos(lag_pos == 0);
    if zeroLagVal == 0 || isnan(zeroLagVal)
        c_norm = nan(size(c_pos));
    else
        c_norm = c_pos ./ zeroLagVal;
    end

    % pad/truncate to consistent n_lags length
    tmp = nan(1, n_lags);
    nvals = min(numel(c_norm), n_lags);
    tmp(1:nvals) = c_norm(1:nvals);

    acf_matrix(i, :) = tmp;
    win_centers_s(i) = (starts(i) - 1 + winSamp/2) / fs;
end

lags_s = (0:n_lags-1) / fs;

end


%% ========================================================================
function [neg_val, neg_lag, pos_val, pos_lag] = extract_first_peaks( ...
    acf, lags_s, minProminence)
% EXTRACT_FIRST_PEAKS  Find first negative and first positive peak of ACF
%
%   [neg_val, neg_lag, pos_val, pos_lag] = extract_first_peaks( ...
%       acf, lags_s, minProminence)
%
% acf            : 1D autocorrelation function (e.g., mean across windows)
% lags_s         : corresponding lag values (s), must be >= 0
% minProminence  : minimal peak prominence (default from Methods: 0.05)
%
% "First negative (half period) peak" = the first (lowest-lag) local
% minimum with negative value and positive lag, satisfying the
% prominence criterion.
% "First positive peak" = the first (lowest-lag) local maximum with
% positive value and positive lag (following the negative peak),
% satisfying the prominence criterion.

acf = acf(:)';
lags_s = lags_s(:)';

% restrict to strictly positive lags (lag > 0), as specified
posLagMask = lags_s > 0;
acf_p  = acf(posLagMask);
lags_p = lags_s(posLagMask);

neg_val = NaN; neg_lag = NaN;
pos_val = NaN; pos_lag = NaN;

if all(isnan(acf_p))
    warning('extract_first_peaks:allNaN', 'ACF is all NaN; cannot detect peaks.');
    return;
end

% ---- Negative (half-period) peak: find peaks in -acf, keep negative-valued ones
[negPk, negLoc] = findpeaks(-acf_p, lags_p, 'MinPeakProminence', minProminence);
negPk = -negPk; % back to original sign
validNeg = negPk < 0;
negPk  = negPk(validNeg);
negLoc = negLoc(validNeg);
if ~isempty(negPk)
    [~, firstIdx] = min(negLoc); % first (smallest lag) negative peak
    neg_val = negPk(firstIdx);
    neg_lag = negLoc(firstIdx);
end

% ---- Positive peak: find peaks in acf directly, keep positive-valued ones,
%      and require lag to come after the negative peak (if found)
[posPk, posLoc] = findpeaks(acf_p, lags_p, 'MinPeakProminence', minProminence);
validPos = posPk > 0;
posPk  = posPk(validPos);
posLoc = posLoc(validPos);

if ~isnan(neg_lag)
    afterNeg = posLoc > neg_lag;
    posPk  = posPk(afterNeg);
    posLoc = posLoc(afterNeg);
end

if ~isempty(posPk)
    [~, firstIdx] = min(posLoc); % first (smallest lag) positive peak
    pos_val = posPk(firstIdx);
    pos_lag = posLoc(firstIdx);
end

end


function shuffled_acf_mean = shuffle_control(signal, fs, band, ...
    zscoreWinSec, acfWinSec, acfStepSec, maxLagSec, segSec, nShuffles)
% SHUFFLE_CONTROL  Shuffle signal in short segments and recompute ACF
%
%   shuffled_acf_mean = shuffle_control(signal, fs, band, ...
%       zscoreWinSec, acfWinSec, acfStepSec, maxLagSec, segSec, nShuffles)
%
% Cuts the raw signal into non-overlapping segments of length segSec
% (default 5 s), randomly permutes their order, repeats this nShuffles
% times (default 100), recomputes the full beta-power -> zscore ->
% sliding-autocorrelation pipeline each time, and returns the mean ACF
% across all shuffles and windows (used to confirm the infraslow rhythm
% is abolished, i.e., amplitude < 0.1 in lizards / < 0.15 in endotherms).
 
signal = signal(:);
N = length(signal);
segSamp = round(segSec * fs);
nSeg = floor(N / segSamp);
usableN = nSeg * segSamp;
 
% Determine n_lags once up front so we can preallocate instead of growing
% an array inside the loop (which is what caused the out-of-memory error:
% keeping every sliding-window ACF from every one of the 100 shuffles
% requires nShuffles x n_windows x n_lags doubles, which is enormous for
% a 300-s window / 1-s step / 300-s max-lag configuration).
n_lags = round(maxLagSec * fs) + 1;
per_shuffle_mean_acf = nan(nShuffles, n_lags);
lags_s = (0:n_lags-1) / fs;
 
for s = 1:nShuffles
    segMat = reshape(signal(1:usableN), segSamp, nSeg); % [segSamp x nSeg]
    order = randperm(nSeg);
    shuffled_signal = reshape(segMat(:, order), usableN, 1);
 
    beta_power_shuf = extract_band_power(shuffled_signal, fs, band);
    beta_z_shuf     = zscore_sliding(beta_power_shuf, fs, zscoreWinSec);
 
    % Compute sliding ACF for this shuffle, but immediately collapse it
    % to a single mean-across-windows ACF (1 x n_lags) before discarding
    % the full [n_windows x n_lags] matrix. This keeps memory bounded by
    % nShuffles x n_lags rather than nShuffles x n_windows x n_lags.
    [acf_mat_shuf, ~, ~] = sliding_autocorr( ...
        beta_z_shuf, fs, acfWinSec, acfStepSec, maxLagSec);
 
    per_shuffle_mean_acf(s, :) = mean(acf_mat_shuf, 1, 'omitnan');
    clear acf_mat_shuf beta_power_shuf beta_z_shuf shuffled_signal segMat
end
 
shuffled_acf_mean = mean(per_shuffle_mean_acf, 1, 'omitnan');
 
end
 

%{
%% ========================================================================
function shuffled_acf_mean = shuffle_control(signal, fs, band, ...
    zscoreWinSec, acfWinSec, acfStepSec, maxLagSec, segSec, nShuffles)
% SHUFFLE_CONTROL  Shuffle signal in short segments and recompute ACF
%
%   shuffled_acf_mean = shuffle_control(signal, fs, band, ...
%       zscoreWinSec, acfWinSec, acfStepSec, maxLagSec, segSec, nShuffles)
%
% Cuts the raw signal into non-overlapping segments of length segSec
% (default 5 s), randomly permutes their order, repeats this nShuffles
% times (default 100), recomputes the full beta-power -> zscore ->
% sliding-autocorrelation pipeline each time, and returns the mean ACF
% across all shuffles and windows (used to confirm the infraslow rhythm
% is abolished, i.e., amplitude < 0.1 in lizards / < 0.15 in endotherms).

signal = signal(:);
N = length(signal);
segSamp = round(segSec * fs);
nSeg = floor(N / segSamp);
usableN = nSeg * segSamp;

all_shuffled_acf = [];

for s = 1:nShuffles
    segMat = reshape(signal(1:usableN), segSamp, nSeg); % [segSamp x nSeg]
    order = randperm(nSeg);
    shuffled_signal = reshape(segMat(:, order), usableN, 1);

    beta_power_shuf = extract_band_power(shuffled_signal, fs, band);
    beta_z_shuf     = zscore_sliding(beta_power_shuf, fs, zscoreWinSec);

    [acf_mat_shuf, lags_s, ~] = sliding_autocorr( ...
        beta_z_shuf, fs, acfWinSec, acfStepSec, maxLagSec); %#ok<ASGLU>

    all_shuffled_acf = [all_shuffled_acf; acf_mat_shuf]; %#ok<AGROW>
end

shuffled_acf_mean = mean(all_shuffled_acf, 1, 'omitnan');

end
%}

%% ========================================================================
%  fUS (CBV / LFP) AUTOCORRELATION ANALYSIS - PER EPOCH, AVERAGED
%  ========================================================================
function out = fus_epoch_autocorr(signal, fs, epochs, species, varargin)
% FUS_EPOCH_AUTOCORR  Autocorrelation of CBV/LFP fUS signals per sleep/
%                      wake epoch, averaged across epochs of the same type.
%
%   out = fus_epoch_autocorr(signal, fs, epochs, species)
%
% signal   : z-scored, detrended CBV or LFP signal, column vector
% fs       : sampling rate (Hz)
% epochs   : struct array with fields:
%              .startSec, .endSec  - epoch boundaries (s)
%              .label              - 'NREM', 'REM', or 'Wake'
% species  : 'dragon' or 'mouse' - sets window/step/maxlag/min duration
%            per the Methods:
%              dragon: 5-min sliding window, 5-s step, 300-s max lag,
%                      min epoch duration 300 s
%              mouse : 2-min sliding window, 5-s step, 150-s max lag,
%                      min epoch duration 100 s
%
% Optional:
%   'MinProminence' (default 0.05) - passed to extract_first_peaks
%
% Returns `out`, a struct with one field per unique epoch label
% (e.g., out.NREM, out.REM, out.Wake), each containing:
%   .acf_mean        - mean autocorrelation function across that
%                       label's epochs
%   .lags_s           - lag axis (s)
%   .n_epochs_used     - number of epochs included
%   .neg_peak_val/.neg_peak_lag / .pos_peak_val/.pos_peak_lag
%   .per_epoch_acf      - {n_epochs x 1} cell of per-epoch mean ACFs
%                          (each epoch's own within-epoch sliding-window
%                          average)

p = inputParser;
addParameter(p, 'MinProminence', 0.05);
parse(p, varargin{:});
minProm = p.Results.MinProminence;

switch lower(species)
    case 'dragon'
        winSec    = 5*60;   % 5-min sliding window
        stepSec   = 5;      % 5-s step
        maxLagSec = 300;    % 300-s max lag
        minEpochDurSec = 300;
    case 'mouse'
        winSec    = 2*60;   % 2-min sliding window
        stepSec   = 5;      % 5-s step
        maxLagSec = 150;    % 150-s max lag
        minEpochDurSec = 100;
    otherwise
        error('fus_epoch_autocorr:badSpecies', ...
            'species must be ''dragon'' or ''mouse''.');
end

signal = signal(:);
labels = unique({epochs.label});
out = struct();

for L = 1:numel(labels)
    thisLabel = labels{L};
    epIdx = find(strcmp({epochs.label}, thisLabel));

    per_epoch_acf = {};
    lags_ref = [];

    for e = epIdx
        durSec = epochs(e).endSec - epochs(e).startSec;
        if durSec < minEpochDurSec
            continue; % skip epochs shorter than minimal duration
        end

        sIdx = max(1, round(epochs(e).startSec * fs) + 1);
        eIdx = min(length(signal), round(epochs(e).endSec * fs));
        seg = signal(sIdx:eIdx);

        if length(seg) < round(winSec * fs)
            continue; % not enough samples for even one window
        end

        [acf_mat, lags_s, ~] = sliding_autocorr( ...
            seg, fs, winSec, stepSec, maxLagSec);

        epoch_mean_acf = mean(acf_mat, 1, 'omitnan');
        per_epoch_acf{end+1} = epoch_mean_acf; %#ok<AGROW>
        lags_ref = lags_s; % same for all epochs of a given species
    end

    if isempty(per_epoch_acf)
        warning('fus_epoch_autocorr:noEpochs', ...
            'No usable epochs found for label "%s".', thisLabel);
        continue;
    end

    acf_stack = cell2mat(per_epoch_acf');   % [n_epochs x n_lags]
    acf_mean  = mean(acf_stack, 1, 'omitnan');

    [neg_val, neg_lag, pos_val, pos_lag] = extract_first_peaks( ...
        acf_mean, lags_ref, minProm);

    fieldSafeName = matlab.lang.makeValidName(thisLabel);
    out.(fieldSafeName) = struct( ...
        'acf_mean',      acf_mean, ...
        'lags_s',         lags_ref, ...
        'n_epochs_used',   numel(per_epoch_acf), ...
        'neg_peak_val',    neg_val, ...
        'neg_peak_lag',    neg_lag, ...
        'pos_peak_val',    pos_val, ...
        'pos_peak_lag',    pos_lag, ...
        'per_epoch_acf',    {per_epoch_acf});
end

end


%% ========================================================================
%  EXAMPLE PLOTTING HELPER (optional)
%  ========================================================================
function plot_infraslow_results(results)
% PLOT_INFRASLOW_RESULTS  Quick visualization of pipeline output

figure('Color', 'w');

subplot(2,1,1);
imagesc(results.win_centers_s, results.lags_s, results.acf_matrix');
axis xy;
xlabel('Window center (s)'); ylabel('Lag (s)');
title('Sliding autocorrelation (normalized)');
colorbar;

subplot(2,1,2);
plot(results.lags_s, results.acf_mean, 'k-', 'LineWidth', 1.5); hold on;
yline(0, 'k:');
if ~isempty(results.shuffled_acf_mean)
    plot(results.lags_s, results.shuffled_acf_mean, 'r-', 'LineWidth', 1);
end
if ~isnan(results.neg_peak_lag)
    plot(results.neg_peak_lag, results.neg_peak_val, 'bv', ...
        'MarkerFaceColor', 'b', 'MarkerSize', 8);
end
if ~isnan(results.pos_peak_lag)
    plot(results.pos_peak_lag, results.pos_peak_val, 'g^', ...
        'MarkerFaceColor', 'g', 'MarkerSize', 8);
end
xlabel('Lag (s)'); ylabel('Normalized autocorrelation');
legend({'Mean ACF', 'zero', 'Shuffled control', 'First neg. peak', 'First pos. peak'}, ...
    'Location', 'best');
title('Mean autocorrelation function');

end
