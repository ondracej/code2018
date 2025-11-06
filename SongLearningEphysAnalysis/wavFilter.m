function [] = wavFilter()

spec_scale = 0.02;
searchString = '*.wav';

Bandpass1 = 0;
Bandpass2 = 1;
Highpass = 1;
Amplify = 1;

wavDir = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w042\Data\2021-12-30\'; %   f_stop1a = 7990;  f_stop2b = 8050;   % 
%wavDir = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w042\Data\2021-12-30-Fil\';
dirD = '\';

bla = find(wavDir == dirD);
DirInd = bla(end-1);

DirUpOneLevel = wavDir(1: DirInd);
DirName = wavDir(DirInd+1:end-1);

filDir = [DirUpOneLevel DirName '-Fil' dirD];

if exist(filDir, 'dir') == 0
    mkdir(filDir);
    disp(['Created: '  filDir])
end

files = dir(fullfile(wavDir, searchString));
nFiles = numel(files);
fileNames = [];
for j = 1:nFiles
    fileNames{j} = files(j).name;
end

tic
for j = 1:nFiles
    
    even1000 = mod(j,1000);
    
    
    thisWavFile = [fileNames{j}];
    [wav_file,fs] = audioread([wavDir thisWavFile]);
    
    % Filter
    
    %https://de.mathworks.com/matlabcentral/answers/357022-can-you-help-remove-the-noise-from-this-audio-file
    %Fs = sample_rate;                                       % Sampling Frequency (Hz)
    %     Fn = fs/2;                                              % Nyquist Frequency (Hz)
    %     % Wp = 1000/Fn;                                           % Passband Frequency (Normalised)
    %     % Ws = 1010/Fn;                                           % Stopband Frequency (Normalised)
    %     Wp = 7980/Fn;                                           % Passband Frequency (Normalised)
    %     Ws = 8010/Fn;                                           % Stopband Frequency (Normalised)
    %     Rp =   1;                                               % Passband Ripple (dB)
    %     Rs = 150;                                               % Stopband Ripple (dB)
    %     [n,Ws] = cheb2ord(Wp,Ws,Rp,Rs);                         % Filter Order
    %     [z,p,k] = cheby2(n,Rs,Ws,'low');                        % Filter Design
    %     [soslp,glp] = zp2sos(z,p,k);                            % Convert To Second-Order-Section For Stability
    %   figure(3)
    %  freqz(soslp, 2^16, fs)                                  % Filter Bode Plot
    %filtered_sound = filtfilt(soslp, glp, wav_file);
    
    %% Peaks in FFT
    %{
        [Pxx, F] = periodogram(wav_file, [], length(wav_file), fs);
        plot(F, 10*log10(Pxx));
        xlim([0 10000])
    %}
    %% Eliptic filter
    %{
  Fs = fs; % Sampling Frequency (Hz)
  Fn = Fs/2; % Nyquist Frequency (Hz)
  
  
  % Define stopband frequencies relative to Nyquist
  Wp = [46 54]/Fn; % Passband (e.g., 4600 to 5400 Hz)
Ws = [49.5 50.5]/Fn
Rp = 1; % Passband ripple (dB)
  Rs = 50; % Stopband attenuation (dB)
  
  % Design the elliptic filter
  [n, Wn] = ellipord(Wp, Ws, Rp, Rs); % Calculate filter order
  [z, p, k] = ellip(n, Rp, Rs, Wn, 'stop'); % Design the filter
  [b, a] = zp2tf(z, p, k); % Convert to transfer function coefficients
  
  % To visualize the frequency response
  freqz(b, a, 2^16, Fs)
    %}
    
    filWav = wav_file;
    %% Bandpass 1
    
   %filWav=  audioBoosted;
    if Bandpass1 == 1
        
        f_stop1 = 5500;   % Lower cutoff frequency (Hz)
        f_stop2 = 5700;   % Upper cutoff frequency (Hz)
        
        % Normalize frequencies to Nyquist frequency
        Wn = [f_stop1 f_stop2] / (fs / 2);
        
        % === Design the bandstop filter ===
        % Using a 6th-order Butterworth filter (can be adjusted)
        [b, a] = butter(6, Wn, 'stop');
        
        % === Apply the filter ===
        filWav = filtfilt(b, a, filWav);
    end
    
    %% bandpass 2
    if Bandpass2 == 1
        
        f_stop1a = 7990;   % Lower cutoff frequency (Hz)
        f_stop2b = 8050;   % Upper cutoff frequency (Hz)
        
        % Normalize frequencies to Nyquist frequency
        Wn = [f_stop1a f_stop2b] / (fs / 2);
        
        % === Design the bandstop filter ===
        % Using a 6th-order Butterworth filter (can be adjusted)
        [b, a] = butter(6, Wn, 'stop');
        
        % filWava = filtfilt(b, a, filWav);
        filWav = filtfilt(b, a, filWav);
    end
    
    
    %% HighpassFilter

    if Highpass == 1
        f_cut = 300;             % Cutoff frequency (Hz)
        Wn = f_cut / (fs / 2);
        [b, a] = butter(6, Wn, 'high');
        filWav = filtfilt(b, a, filWav);
    end
    
    if BandBoost
        
        f_low  = 2000;   % Lower cutoff (Hz)
        f_high = 6000;   % Upper cutoff (Hz)
        Wn = [f_low f_high] / (fs/2);
        
        [b, a] = butter(6, Wn, 'bandpass');
        bandComponent = filtfilt(b, a, filWav);
        gain = 2;    % 2? boost (you can adjust to taste: 1.5, 3, etc.)
        
        audioBoosted = filWav + (gain - 1) * bandComponent;
       % audioBoosted = audioBoosted ./ max(abs(audioBoosted));
        
    end
            %% amplify sound
            if Amplify == 1
                
                filWav = filWav*10;
            end
            
            
    if even1000 == 0
        
        figure(102);clf
        
        subplot(3, 2, 1)
        [Pxx, F] = periodogram(wav_file, [], length(wav_file), fs);
        plot(F, 10*log10(Pxx));
        xlim([0 10000])
        title('Unfiltered')
        
        subplot(3, 2, 3)
        [Pxx, F] = periodogram(filWav, [], length(filWav), fs);
        plot(F, 10*log10(Pxx));
        xlim([0 10000])
        title('Filtered')
        
        subplot(3, 2, 2)
        specgram1((wav_file/spec_scale),512,fs,400,360);
        ylim([0 10000])
        title('Unfiltered')     
        
        subplot(3, 2, 4)
        specgram1((filWav/spec_scale),512,fs,400,360);
        ylim([100 10000])
        title('Filtered')
        
         subplot(3, 2, 5)
        [Pxx, F] = periodogram(audioBoosted, [], length(audioBoosted), fs);
        plot(F, 10*log10(Pxx));
        xlim([0 10000])
        title('Filtered')

          subplot(3, 2, 6)
        specgram1((audioBoosted/spec_scale),512,fs,400,360);
        ylim([100 10000])
        title('Filtered')
        
        
        
        
        plotpos = [0 0 15 10];
        
        saveName = [filDir thisWavFile(1:end-4)];
        
        
        print_in_A4(0, saveName, '-djpeg', 0, plotpos);
        print_in_A4(0, saveName, '-depsc', 0, plotpos);
        
    end
    %% plot a spectrogram
    %{
    
    subplot(2, 1, 1)
    specgram1((wav_file/spec_scale),512,fs,400,360);
    ylim([0 10000])
    subplot(2, 1, 2)
    specgram1((filWava/spec_scale),512,fs,400,360);
    ylim([0 10000])
    %}
    
    %disp('')
    
    %% Wavelet denoising (didnt work)
    
    %     xd = wdenoise(wav_file,2);
    %     plot(xd)
    
    %% Resampling (required for use with SAP)
    %wavwrite(YY,44100, [wav_file_dir newWavName])
    %filWav_resamp = resample(filWav, 44100, fs);
    
    %% Save filed to M Directory
    newWavName = [thisWavFile(1:end-4) '--filAAug' '.wav'];
    audiowrite([filDir newWavName], audioBoosted,fs)
    disp([num2str(j) '/' num2str(nFiles)])
    
end
toc
end
