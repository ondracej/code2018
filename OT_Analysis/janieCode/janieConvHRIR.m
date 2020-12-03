function [] = janieConvHRIR()

%convolve noise and IRs and resample
%clear all; close all;

load('/home/janie/code/ChickenCode_Jul2017/Hansa/Falten/Output/#H3_HRIR_HRTF.mat')

%{
fs=44100;
%%% Noise %%%
d=0.15;
ns=5000; % number of samples
t = (0:1/fs:d)';
y = randn(1,round(fs*0.15));
y = y / max(abs(y)); % -1 to 1 normalization


%%% filter the noise %%%
% set variables for filter
lf = 250;   % lowest frequency
hf = 5500;   % highest frequency
lp = lf * d; % ls point in frequency domain
hp = hf * d; % hf point in frequency domain

filter = zeros(1, ns);           % initializaiton by 0
filter(1, lp : hp) = 1;         % filter design in real number
filter(1, ns - hp : ns - lp) = 1; % filter design in imaginary number

% do filter
s = fft(y);                  % FFT
s = s.* filter;                 % filtering
s = ifft(s);                     % inverse FFT
s = real(s);

%}
%% Janie's

azn=30;
elen=1;
ear_n=1;

bla2 = HRIR(azn,elen,:,ear_n);

bla2 = HRIR(:,:,:,1);


%%
%allElels = [];
for azn=1:65
    n =azn;
    allMaxs = [];
    for elen=1:27
        for ear_n=1
            
            bla = HRIR(elen,azn,:,ear_n);
            allMaxs(elen,:) = max(bla);
            
            
            
            aztxt = num2str(allaz(azn));
            eltxt = num2str(allele(elen));
            
            figure(100);clf
            plot(squeeze(bla));
            axis tight
            title(['az = ' aztxt ' | el = ' eltxt])
            ylim([-.6 .6])
            pause(.1)
            
            
            
        end
    end
    allElels{:,n} = allMaxs;
    %n = n+1;
    pause(.5)
end


for k = 1:size(allElels, 2)
    
    figure(200)
    hold all
    plot(allElels{:,k})
    plot(allElels{:,k}, '*')
end
    
    
    
    


for azn=1:65
    for elen=1:27
        for ear_n=1:2
            
            %spatial(azn,elen,:,ear_n)=conv(n,HRIR(azn,elen,:,ear_n));%convolution not correct
            spatial(azn,elen,:,ear_n)=conv(n,HRIR(elen,azn,:,ear_n));%convolution
            %resample to 260 kHz
            %             HRIR(azn,elen,:,ear_n)=resample(squeeze(HRIR(azn,elen,:,ear_n)),fs_neu,250000);%(neu, alt)
            
            
            
        end
    end
end


fftpts=512;
f=linspace(0,fs,fftpts);
stim=squeeze(HRIR(33,13,:,1));
mags=20*log10(abs(fft(stim,fftpts)));
figure(3),plot(f/1e3,mags);
set(gca,'xlim',[0 6]);
xlabel('frequency [kHz]');
ylabel('magnitude [dB]');


save('D:\Hansa\HRIRconv','spatial','fs');
end
