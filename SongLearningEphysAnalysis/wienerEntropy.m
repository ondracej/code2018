
% From fb_plugin_WienerEntropy

% obj.Name = 'Wiener entropy (500Hz-7kHz)';
% obj.Description = 'Wiener entropy in frequency range 500Hz - 7 kHz';
% obj.Author = 'Alexei Vyssotski';
% obj.plot_color = 'r';
% obj.buffersize = 512;
% obj.nonoverlap = 32;
% obj.samplestart = obj.buffersize;
% obj.b = fir1(320, [500 7000]/(obj.Scanrate/2));

% From f_hmm_zebrafinch
%data = calc_wEntropy(Data_t, samplestart, nonoverlap, buffersize, Scanrate)         


%%
motifDataDir = 'X:\EEG-LFP-songLearning\Artemis\w038_Analysis\Data\2021-09-20-First100Songs-Syllables\S2\';

fileNames = dir(fullfile(motifDataDir, '*.wav'));
fileNames = {fileNames.name}';
nFiles = numel(fileNames);

thisFile = fileNames{1};
thisFilePath = [motifDataDir thisFile];
[y,Fs] = audioread(thisFilePath);

                        %%
   Data_t = y';
   nonoverlap = 32;
   samplestart =1;
   buffersize = 512;
   
   
size_Data = size(Data_t, 2);
%data = zeros(1, ceil((size_Data-samplestart)/nonoverlap));
 %  data = zeros(1, 1+floor((size_Data-samplestart)/nonoverlap));
   
   data = zeros(1, floor((size_Data-buffersize)/nonoverlap));
   
   
   
nbr_buffers = size(data, 2);
Scanrate = Fs;

for i = 1: nbr_buffers
    
    start = 1 + (i-1)*nonoverlap;
    stop = start+buffersize;
    
    starts(i) = start;
    stops(i) = stop;
    
    % TEMPORARY FIX: make sure we don't try access samples
    % beyond Data's size
    if i == nbr_buffers
        stop = size_Data;
    end
    
    F = fft(Data_t(start:stop-1));    %the lowerst code is written in assumption of one channel
    F1 = F(1+(round(300/(Scanrate/buffersize)):round(8000/(Scanrate/buffersize))));
    %bottom frequency - about 500Hz, top frequency - 7kHz
    %1 is added because the first fft coefficient
    %corresponds to zero frequency
    P = abs(F1.*conj(F1));
    m_SumLog = sum(log(P+1e-8));    %epsilon - 1e-8
    m_LogSum = sum(P);
    if (m_LogSum==0)
        m_LogSum = size(P,2);
    end
    
    m_LogSum = log(m_LogSum/size(P,2));
    m_Entropy = m_SumLog/size(P,2)-m_LogSum;
    
    if (m_LogSum==0)
        m_Entropy = 0;
    end
    
    data(i) = m_Entropy;
    
end

mean_wEntropy = mean(data);
variance_wEntropy = var(data);

figure(103); clf
subplot(3, 1, 1)
  specgram1((y/.08),512,Fs,400,360);
    ylim ([0 8000]);
    axis off
subplot(3, 1, 2)
plot(y)
axis tight
    subplot(3, 1, 3)
    plot(data)
axis tight
