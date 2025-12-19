function [] = waveFilter_V2()


wavDir = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w042\Data\2022-01-15\'; 

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

files = dir(fullfile(wavDir, '*.wav'));
nFiles = numel(files);

for i = 1:numel(files)
    [audio, fs] = audioread([wavDir files(i).name]);
    
    audio = mean(audio,2);
    
    
    bpFilt = designfilt('bandpassfir', ...
        'FilterOrder', 500, ...
        'CutoffFrequency1', 100, ...
        'CutoffFrequency2', 7000, ...
        'SampleRate', fs);
    %}
    
    %{
    bpFilt = designfilt('bandpassiir', ...
    'FilterOrder', 6, ...
    'HalfPowerFrequency1', 100, ...
    'HalfPowerFrequency2', 7000, ...
    'SampleRate', fs);
    %}
    
    audio_filt = filtfilt(bpFilt, audio);
    
    subplot(2, 1, 1)
    specgram1((audio/.02),512,fs,400,360);
    ylim([0 10000])
    title('Unfiltered')
    
    subplot(2, 1, 2)
    specgram1((audio_filt/.02),512,fs,400,360);
    ylim([100 10000])
    title('Filtered')
    %}
    
    newWavName = [files(i).name(1:end-4) '--filBP.wav'];
    %audiowrite(['bp_' files(i).name], audio_filt, fs);
    audiowrite([filDir newWavName], audio_filt,fs)
    disp([num2str(i) '/' num2str(nFiles)])
    
end

end