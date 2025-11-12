
songToLoad = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w044\Data\2021-12-31-First100Songs\w044D-f00159.wav'


[signal, fs] = audioread(songToLoad);


if size(signal, 2) > 1
    signal = mean(signal, 2);
end
 %[B,F,T] = SPECGRAM(A,NFFT,Fs,WINDOW,NOVERLAP) returns a column of 
%specgram1((filWav/spec_scale),512,fs,400,360);
% --- Compute spectrogram ---

% win = hamming(512);
% noverlap = 256;
% nfft = 1024;

% win = 400;
% noverlap = 360;
% nfft = 512;

win      = hamming(256);          % shorter window ? better time resolution
noverlap = round(0.90*length(win)); % high overlap for smooth structure
nfft     = 512;

S_mag  = abs(S);
S_db   = 20*log10( S_mag + eps );

% --- Compute frequency?axis derivative (i.e., dS/df) ---
dS_df   = diff(S_db, 1, 1);
F_mid   = (F(1:end-1) + F(2:end)) / 2;

% --- Contrast / clipping / scaling for ?high definition? look ---
% Set manual clip: e.g., bottom 95% of values mapped to near?black
vmin = prctile(dS_df(:), 5);
vmax = prctile(dS_df(:), 99);
dS_clipped = dS_df;
dS_clipped(dS_df < vmin) = vmin;
dS_clipped(dS_df > vmax) = vmax;

% Normalize to [0,1]
dS_norm = (dS_clipped - vmin) / (vmax - vmin);

% Invert mapping if you want edges white on dark
dS_display = 1 - dS_norm;

% --- Plot ---
figure('Position',[100 100 800 400]);
imagesc(T, F_mid/1000, dS_display);   % F_mid in kHz
axis xy;
colormap(gray);
colorbar('Ticks',[0 1], 'TickLabels',{'Low','High'});
xlabel('Time (s)');
ylabel('Frequency (kHz)');
title('Spectral derivative (dS/df) ? high-definition adult birdsong');
ylim([0 10])
% --- Adjust contrast / display range (to mimic high?definition) ---
caxis([min(dS_df_smooth(:)) + 0.5*(max(dS_df_smooth(:))-min(dS_df_smooth(:))), ...
       max(dS_df_smooth(:))]);   % clip lower end for better contrast
   
   
   %%
   
   
% --- Parameters for spectrogram (adjust as needed) ---
win  = hamming(512);    % window length
noverlap = round(0.75*length(win));  % 75% overlap
nfft = 1024;

% --- Compute spectrogram ---
[S, F, T] = spectrogram(signal, win, noverlap, nfft, fs);

% --- Convert to decibel scale ---
S_mag = abs(S);
S_dB = 20*log10( S_mag + eps );

% --- Compute spectral (frequency?axis) derivative: dS/df ---
dS_df = diff(S_dB, 1, 1);
F_mid = (F(1:end-1) + F(2:end)) / 2;

% --- Optional: smooth or filter the derivative for visual clarity ---
% e.g., using 2D smoothing:
dS_df_smooth = conv2(dS_df, ones(3)/9, 'same');  

% --- Plotting ---
figure;
imagesc(T, F_mid, dS_df_smooth);
axis xy;
colormap(jet);            % or 'parula', 'hot' etc.
colorbar;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('Spectral derivative (dS/df) of Birdsong');

% --- Adjust contrast / display range (to mimic high?definition) ---
caxis([min(dS_df_smooth(:)) + 0.1*(max(dS_df_smooth(:))-min(dS_df_smooth(:))), ...
       max(dS_df_smooth(:))]);   % clip lower end for better contrast
   %%
   
   
% --- Compute spectrogram ---
win = hamming(256);
noverlap = 200;
nfft = 512;

[S, F, T] = spectrogram(signal, win, noverlap, nfft, fs);
S_dB = 10*log10(abs(S) + eps);

% --- Compute frequency derivative (dS/df) ---
dS_df = diff(S_dB, 1, 1);
F_mid = (F(1:end-1) + F(2:end)) / 2;

% --- Enhance contrast ---
% Option 1: Normalize and stretch contrast
dS_df_norm = mat2gray(dS_df);          % normalize to [0,1]
dS_df_enhanced = imadjust(dS_df_norm, stretchlim(dS_df_norm, [0.01 0.99]), []);  

% Option 2: Apply local contrast enhancement (optional)
dS_df_enhanced = adapthisteq(dS_df_enhanced);  % adaptive histogram equalization

% --- Plot high-contrast frequency derivative ---
figure('Position',[100 100 700 500]);
imagesc(T, F_mid, dS_df_enhanced);
axis xy;
colormap('hot');  % high-contrast colormap options: 'gray', 'hot', 'turbo', etc.
colorbar;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('High-Contrast Frequency Derivative of Birdsong (dS/df)');

% --- Optional: emphasize edges for even higher contrast ---
hold on;
contour(T, F_mid, dS_df_enhanced, 5, 'LineColor', 'k', 'LineWidth', 0.5);
hold off;

   