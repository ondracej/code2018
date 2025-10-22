
wavDir = 'X:\EEG-LFP-songLearning\songs\w042\Data\2022-01-14\';
dirD = '\';
filDir = [wavDir 'Fil' dirD];

spec_scale = 0.05;
searchString = '*.wav';

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
    
    [b1, a1] = butter(2, [300 5500]/(fs/2)); % for w024
    filWav = filtfilt(b1, a1, wav_file);
    %filWav = filter(b1, a1, wav_file);
    
    newWavName = [thisWavFile(1:end-4) '--fil' '.wav'];
    
    %wavwrite(YY,44100, [wav_file_dir newWavName])
    %filWav_resamp = resample(filWav, 44100, fs);
    
    %% Save filed to M Directory
    audiowrite([filDir newWavName], filWav,fs)
    
    
    %     figure(100); clf;
    %     subplot(2, 1, 1)
    %     specgram1((wav_file/spec_scale),512,fs,400,360);
    %     ylim([0 10000])
    %     subplot(2, 1, 2)
    %     specgram1((filWav/spec_scale),512,fs,400,360);
    %     ylim([0 10000])
end
toc