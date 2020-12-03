function [] = janie_chicken_convolveHRTFWithNoise()

dbstop if error

singlePrecision = 1;

%load('D:\Janie\AudioSpike_v_10202017\#H3_HRIR_HRTF.mat') % Loads HRIR, HRTF, allele, allaz
load('/home/janie/Dropbox/codetocopy/#H3_HRIR_HRTF.mat') % Loads HRIR, HRTF, allele, allaz

saveDir = '/home/janie/Dropbox/codetocopy/';

%% Noise Filter
lf = 100;   % lowest frequency
hf = 5000;   % highest frequency

stimDur_s = 0.100;     % duration
stim_Dur_ms = stimDur_s *1000;

saveStr = ['HRIRconv_' num2str(lf) 'hz-' num2str(hf) 'hz_Dur-' num2str(stim_Dur_ms) 'ms'];

disp('')

HRIR_fs = 48828;
target_fs = 44100;

doPlot = 1;
%% Create Noise Stimulus
%http://www.h6.dion.ne.jp/~fff/old/technique/auditory/matlab.html#cramp

% set general variables
sf = 44100;  % sample frequency
nf = sf / 2; % nyquist frequency

n = sf * stimDur_s;  % number of samples
nh = n / 2;  % half number of samples

% =========================================================================
% set variables for filter
lp = lf * stimDur_s; % ls point in frequency domain
hp = hf * stimDur_s; % hf point in frequency domain

% design filter
a = ['BANDPASS'];
filter = zeros(1, n);           % initializaiton by 0
filter(1, lp : hp) = 1;         % filter design in real number
filter(1, n - hp : n - lp) = 1; % filter design in imaginary number

% =========================================================================
% make noise
rand('state',sum(100 * clock));  % initialize random seed
noise = randn(1, n);             % Gausian noise
noise = noise / max(abs(noise)); % -1 to 1 normalization

% do filter
filNoise = fft(noise);                  % FFT
filNoise = filNoise .* filter;                 % filtering
filNoise = ifft(filNoise);                     % inverse FFT
filNoise = real(filNoise);

%% Do ramp Onset and Offset
rampDur_s = 0.005;
% prepare ramp
nr = floor(target_fs * rampDur_s);
ramp = sin(linspace(0, pi/2, nr));
ramp = [ramp, ones(1, n - nr * 2), fliplr(ramp)];

filNoise_ramp = filNoise .* ramp;

% =========================================================================

% play noise
%disp('WHITE noise');
%sound(noise, sf);                % playing sound
%pause(stimDur_s + 0.5);                  % waiting for sound end

% play filtered noise
%clc;
%disp([a, ' noise']);
%sound(s, sf);              % playing sound
%pause(stimDur_s + 0.5);                  % waiting for sound end

% =========================================================================
% plot sound
if doPlot
    figure(199);clf
    x = linspace(0, stimDur_s, n);
    subplot(2,2,1); plot(x, noise); xlabel('time (s)'); title('sound: noise'); axis tight; xlim([0 .05])
    subplot(2,2,2); plot(x, filNoise_ramp); xlabel('time (s)'); title('sound: filtered noise'); axis tight; xlim([0 .05])
    
    % plot Fourier spectrum
    x = linspace(0, nf, nh);
    t = fft(noise);
    t = t .* conj(t);
    subplot(2,2,3); semilogy(x, t(1,1:nh) ./ max(t));  xlabel('frequency (Hz)'); title('spectrum: noise'); axis tight
    xlim([0 10000])
    t = fft(filNoise_ramp);
    t = t .* conj(t);
    subplot(2,2,4); semilogy(x, t(1,1:nh) ./ max(t));  xlabel('frequency (Hz)');  title('spectrum: filtered noise'); axis tight
    xlim([0 10000])
end


%% Convolve w w Noise
sig = filNoise_ramp;


nEle = 27; % -73.125 to 73.125
nAz = 65; % -180 to 180;

degStep = 5.625;
elevRange = -73.125:degStep:73.125;
azRange = -180:degStep:180;

for elen = 1:nEle
    for azn = 1:nAz
        %compsig1=filter(IR_comp1,1,sig); %compensates noise for coupler
        %compsig2=filter(IR_comp2,1,sig); %compensate noise for coupler
        %compsig1 = compsig1 / max(abs(compsig1)); % -1 to 1 normalization
        %compsig2 = compsig2 / max(abs(compsig2)); % -1 to 1 normalization
        
        HRIRresamp(elen,azn,:,1) = resample(squeeze(HRIR(elen,azn,:,1)),HRIR_fs,target_fs); %resample %(neu,alt)
        HRIRresamp(elen,azn,:,2) = resample(squeeze(HRIR(elen,azn,:,2)),HRIR_fs,target_fs); %resample
        
        spatial(elen,azn,:,1)=conv(squeeze(HRIRresamp(elen,azn,:,1))',sig);%filter
        spatial(elen,azn,:,2)=conv(squeeze(HRIRresamp(elen,azn,:,2))',sig);%filter
        
        disp('')
        %spatial(elen,azn,:,1)=filter(squeeze(HRIRresamp(elen,azn,:,1))',1,compsig1);%filter
        %spatial(elen,azn,:,2)=filter(squeeze(HRIRresamp(elen,azn,:,2))',1,compsig2);%filter
        %spatial(elen,azn,:,1)=wind(fs,0.015,squeeze(spatial(elen,azn,:,1))');
        %spatial(elen,azn,:,2)=wind(fs,0.015,squeeze(spatial(elen,azn,:,2))');
    end
end

if doPlot
    figure(203); clf
    f = linspace(0, nf, nh);
    stim=squeeze(spatial(10,10,:,1));
    %stim=squeeze(spatial_single(10,10,:,1));
    t = fft(stim)';
    t = t .* conj(t);
    subplot(2, 1, 1)
    semilogy(f, t(1,1:nh) ./ max(t));  xlabel('frequency (Hz)');  title('spectrum: filtered noise'); axis tight
    xlim([0 10000])
    subplot(2, 1, 2)
    plot(stim); axis tight
end

INFO.lf = lf;
INFO.hf = hf;
INFO.stimDur_s = stimDur_s;
INFO.rampDur_s = rampDur_s;
INFO.HRIR_fs = HRIR_fs;
INFO.target_fs = target_fs;
INFO.degStep = degStep;
INFO.elevRange = elevRange;
INFO.azRange = azRange;
INFO.singlePrecision  = singlePrecision ;

savePath = [saveDir saveStr];

if singlePrecision
    spatial = single(spatial);
    disp('Converting to single precision...')
    
    savePath = [savePath '_single'];
end

save(savePath,'spatial','INFO');
disp(savePath);

end

