function [dy] = calculateDeltaGammaRatio(lf, windowSizeS, frange)

% Parameters
oldSamplingRate = 30000;
newSamplingRate = 500;
stepSize = newSamplingRate * windowSizeS;

%     if nargin==2
%         frange = [[1 4] ; [30,90]];
%     end
% Resample the LFP signal (assume it is sampled at 2.5kHz)
lfResampled = resample(lf, 1, oldSamplingRate/newSamplingRate);

%figure; plot(lfResampled);
%figure; plot(lf(1,:));

%% Multitaper settings
TW = 1.25;
nfft = 2^(nextpow2(stepSize));

numWindows = floor(length(lfResampled) / stepSize);

LH = nan(1, numWindows);
pxLow = LH;
pxHigh = LH;

lfReshaped = reshape(lfResampled(1:numWindows * stepSize), [stepSize, numWindows]);

for k = 1:numWindows
    [pxx, f] = pmtm(lfReshaped(:, k), TW, nfft, newSamplingRate);
    pxLow(k) = norm(pxx(f <= frange(1,2) & f >= frange(1,1)));  %% norm(pxx(f < 8 & f > 1.5));
    pxHigh(k) = norm(pxx(f <= frange(2,2) & f >= frange(2,1))); %% norm(pxx(f < 49 & f > 30));
    
    LH(k) = pxLow(k) / pxHigh(k);
end

time = (1:numWindows) * windowSizeS - windowSizeS/2;

%% Save info in structure

median_pxLow = median(pxLow(~isnan(pxLow)));
iqr_pxLow=iqr(pxLow(~isnan(pxLow)));
se_pxLow=std(pxLow(~isnan(pxLow)))/ sqrt(sum(~isnan(pxLow)));

median_pxHigh = median(pxHigh(~isnan(pxHigh)));
iqr_pxLow=iqr(pxHigh(~isnan(pxHigh)));
se_pxLow=std(pxHigh(~isnan(pxHigh)))/ sqrt(sum(~isnan(pxHigh)));

median_pxLH = median(LH(~isnan(LH)));
iqr_pxLH=iqr(LH(~isnan(LH)));
se_pxLH=std(LH(~isnan(LH)))/ sqrt(sum(~isnan(LH)));

dy.median_pxLow = median_pxLow;
dy.median_pxHigh = median_pxHigh;
dy.median_pxLH = median_pxLH;
dy.pxLow = pxLow;
dy.pxHigh = pxHigh;
dy.LH = LH;


end