function [] = janieSingleNoiseFiltHRIR()

dbstop if error

%% generates single white noise; compensates white noise for frequency response of microphone/coupler; resamples the chicken HRIR; and filters the compensated noise with the resampled HRIR

%load('D:\Hansa\Falten\Output\#H3_HRIR_HRTF'); %loads IR of chicken, with sampling rate of 44100!!
load('/home/janie/Dropbox/codetocopy/ChickenCode_Jul2017/Hansa/#H3_HRIR_HRTF.mat')

fs=48828; %sample rate for noise and resample rate for chicken IR!!!
%load('D:\Hansa\Falten\Output\IRcompphone.mat'); %loads compensation for coupler

%% Noise (unkompensiert)
d=0.15;
t = (0:1/fs:d-1/fs);
% sig=sin(2*pi*t*1000);
sig = randn(1,length(t));
sig = sig / max(abs(sig)); % -1 to 1 normalization

%plot(t, sig); % noise

%% Filter
% [b,a]=butter(3,[2*100/fs 2*6000/fs]);%Band-Pass 200-6000 Hz
% sig=filtfilt(b,a,sig);


for azn=1:65
    for elen=1:27
        %compsig1=filter(IR_comp1,1,sig); %compensates noise for coupler
        %compsig2=filter(IR_comp2,1,sig); %compensate noise for coupler
        %compsig1 = compsig1 / max(abs(compsig1)); % -1 to 1 normalization
        %compsig2 = compsig2 / max(abs(compsig2)); % -1 to 1 normalization
        
        %% Plot
        bla = HRIR(elen,azn,:,1);
        aztxt = num2str(allaz(azn));
        eltxt = num2str(allele(elen));
        
        figure(100);clf
        plot(squeeze(bla));
        axis tight
        title(['az = ' aztxt ' | el = ' eltxt])
        ylim([-.6 .6])
        hold on
        line([50 50], [-.6 .6], 'color', 'k')
        pause(.1)
        
        % Ear 1
        HRIRresamp(elen,azn,:,1)=resample(squeeze(HRIR(elen,azn,:,1)),fs,44100); %resample %(neu,alt)
        % Ear 2
        HRIRresamp(elen,azn,:,2)=resample(squeeze(HRIR(elen,azn,:,2)),fs,44100); %resample
        
        %% With microphone compensation
        %spatial(elen,azn,:,1)=filter(squeeze(HRIRresamp(elen,azn,:,1))',1,compsig1);%filter
        %spatial(elen,azn,:,2)=filter(squeeze(HRIRresamp(elen,azn,:,2))',1,compsig2);%filter
        
        %% No compensation
        spatial(elen,azn,:,1)=squeeze(HRIRresamp(elen,azn,:,1))';
        spatial(elen,azn,:,2)=squeeze(HRIRresamp(elen,azn,:,2))';
        
        %% Windowing?
        %spatial(elen,azn,:,1)=wind(fs,0.015,squeeze(spatial(elen,azn,:,1))');
        %spatial(elen,azn,:,2)=wind(fs,0.015,squeeze(spatial(elen,azn,:,2))');
    end
    pause(.5)
end


fftpts=size(spatial,3);
f=linspace(0,fs,fftpts);

stim=squeeze(spatial(1,1,:,2));
bla = fft(stim,fftpts);
%mags=20*log10(abs(fft(stim,fftpts)));
mags=20*log10(abs(fft(stim,fftpts)));

figure(3); clf 
plot(f/1e3,mags);
set(gca,'xlim',[0 10]);
% set(gca,'ylim',[-15 50]);
xlabel('frequency [kHz]');
ylabel('magnitude [dB]');


stim2=squeeze(HRIR(1,1,:,2));
mags2=20*log10(abs(fft(stim2,fftpts)));

figure(4),plot(f/1e3,mags2);
set(gca,'xlim',[0 10]);
set(gca,'ylim',[-15 20]);
xlabel('frequency [kHz]');
ylabel('magnitude [dB]');


%save('D:\Hansa\Falten\Output\HRIRconv','spatial','fs');

save('/home/janie/Dropbox/codetocopy/ChickenCode_Jul2017/janieHRIRconv.mat','spatial','fs');


% stim=[stim];
% stim=wind(fs,0.005,stim');

%hw=hann(length(stim));
stim=wind(fs,0.015,stim');
%stim=hw.*stim;
%wavplay(stim*0.5,fs)
audioplayer(stim*0.5,fs)
figure, plot(stim)

end

%%
function x=wind(fs,wds,x)
% fs in Hz, gate duration in s, vector.
npts=length(x);
f=1/(2*wds);
t=0:1/fs:2*wds-1/fs;
m=(1+sin(2*pi*t*f-pi/2))/2;
mpts=length(m);
if mpts>npts,
    error('window too long for this stimulus!');
end

x(1:floor(mpts/2))=x(1:floor(mpts/2)).*m(1:floor(mpts/2));
x(npts-ceil(mpts/2):npts)=x(npts-ceil(mpts/2):npts).*m(mpts-ceil(mpts/2):mpts);
end
