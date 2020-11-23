function [] = plotSpectrogramHRTFData()

wavFile1 = '/media/dlc/Data8TB/TUM/OT/OTProject/AllSignals/SignalsForDefs/az_-90__el_0.wav'; % Should be left
wavFile2 =  '/media/dlc/Data8TB/TUM/OT/OTProject/AllSignals/SignalsForDefs/az_90__el_0.wav'; % Should be right

wavFile3 =  '/media/dlc/Data8TB/TUM/OT/OTProject/AllSignals/SignalsForDefs/az_180__el_0.wav'; % Should be right
wavFile4 =  '/media/dlc/Data8TB/TUM/OT/OTProject/AllSignals/SignalsForDefs/az_-180__el_0.wav'; % Should be right

wavFile5 = '/media/dlc/Data8TB/TUM/OT/OTProject/AllSignals/SignalsForDefs/az_0__el_0.wav';

test = '/media/janie/300GBPassport/OTProject/AllSignals/Signals/2000.wav';

%%
spec_scale = 0.05;
[wavData1,Fs] = audioread(test); % for some reason, the HRTF signal is a bit longer than the 100 ms stim period

figure(100); clf
subplot(2, 2,1 )
specgram1(double(wavData1(:, 1))/spec_scale,512,Fs,400,360);
ylim([0 8000])
title('Chan 1')

  %Fs = Fs;                    % Sampling frequency
            T = 1/Fs;                     % Sample time
            L = numel(wavData1);
            %Y = fft(squeeze(longLF));
            NFFT = 2^nextpow2(L); % Next power of 2 from length of y
            Y = fft(squeeze(wavData1),NFFT)/L;
            f = Fs/2*linspace(0,1,NFFT/2+1);
            
            % Plot single-sided amplitude spectrum.
            
            bla = 2*abs(Y(1:NFFT/2+1));
            %plot(f,2*abs(Y(1:NFFT/2+1)))
            plot(f/1000,smooth(bla))
            xlim([0 7])
title('FFT')

%
% subplot(2, 2,2 )
% specgram1(double(wavData1(:, 2))/spec_scale,512,Fs,400,360);
% ylim([0 8000])
% title('Chan 2')
%
% [wavData2,Fs] = audioread(wavFile2); % for some reason, the HRTF signal is a bit longer than the 100 ms stim period
%
% subplot(2, 2,3 )
% specgram1(double(wavData2(:, 1))/spec_scale,512,Fs,400,360);
% ylim([0 8000])
% title('Chan 1')
%
% subplot(2, 2,4 )
% specgram1(double(wavData2(:, 2))/spec_scale,512,Fs,400,360);
% ylim([0 8000])
% title('Chan 2')
%% AZ -90
figH = figure(105);clf
[wavData1,Fs] = audioread(wavFile1); % for some reason, the HRTF signal is a bit longer than the 100 ms stim period

dataWin_s = 0.1;
dataWin_samp = dataWin_s*Fs;
Dt = 1/Fs;
LData =wavData1(1:dataWin_samp,1);
RData =wavData1(1:dataWin_samp,2);
t = 0:Dt:(numel(LData)*Dt)-Dt;

%[cfs,f] = cwt(LData,'bump',1/Dt,'VoicesPerOctave',48);
[cfs,f] = cwt(LData, 'bump', 1/Dt,'VoicesPerOctave',48);

subplot(3, 3, [1 4])
helperCWTTimeFreqPlot(cfs,t*1e3,f./1e3,'surf','-90 Az 0 El : L Channel','Time [ms]','Frequency [kHz]')
ylim([.5 8])

css = get(gca, 'clim');
caxis(css);
colorbar('off')
%colorbar('northoutside')
%subplot(3, 3, [1 4]); cla

[cfs,f] = cwt(RData, 'bump', 1/Dt,'VoicesPerOctave',48);

subplot(3, 3, [2 5])
helperCWTTimeFreqPlot(cfs,t*1e3,f./1e3,'surf','-90 Az 0 El : R Channel','Time [ms]','Frequency [kHz]')
ylim([.5 8])
caxis(css);
colorbar('off')
%colorbar('northoutside')
%subplot(3, 3, [2 5]); cla

WN1 = '/media/dlc/Data8TB/TUM/OT/OTProject/AllSignals/WNsignals/test1/WN-1.wav';
[WNData,Fs] = audioread(WN1); % for some reason, the HRTF signal is a bit longer than the 100 ms stim period

Dt = 1/Fs;
t = 0:Dt:(numel(WNData)*Dt)-Dt;

%[cfs,f] = cwt(LData,'bump',1/Dt,'VoicesPerOctave',48);
[cfs,f] = cwt(WNData, 'bump', 1/Dt,'VoicesPerOctave',48);

subplot(3, 3, [3 6])
helperCWTTimeFreqPlot(cfs,t*1e3,f./1e3,'surf','WN-1','Time [ms]','Frequency [kHz]')
ylim([.5 8])

% css = get(gca, 'clim');
% caxis(css);
colorbar('off')
%colorbar('northoutside')
%subplot(3, 3, [3 6]); cla
%%
smoothWin_ms = 1;
smoothWin_samps = round(smoothWin_ms/1000*Fs);

maxL = max(LData);
minL = min(LData);
maxR = max(RData);
minR = min(RData);

normL = (LData - minL) / (maxL-minL);
normR = (RData - minR) / (maxR-minR);

[yupperL,~] = envelope(normL);
[yupperR,~] = envelope(normR);

smooth_yupperL = smooth(yupperL, smoothWin_samps);
smooth_yupperR = smooth(yupperR, smoothWin_samps);

subplot(3, 3, [7])
xtimepoints =1:1:size(smooth_yupperR, 1);
xtimepoints_ms = xtimepoints/Fs*1000;

plot(xtimepoints_ms, smooth_yupperL, 'k');
ylim([.5 1])
subplot(3, 3, [7])
hold on
plot(xtimepoints_ms, smooth_yupperR, 'color', [.5 .5 .5]);

subplot(3, 3, [8])
plot(xtimepoints_ms, smooth_yupperR, 'k');
ylim([.5 1])
subplot(3, 3, [8])
hold on
plot(xtimepoints_ms, smooth_yupperL, 'color', [.5 .5 .5]);

subplot(3, 3, [9])
[yupperWN,~] = envelope(WNData);

smooth_yupperWN = smooth(yupperWN, smoothWin_samps);
plot(xtimepoints_ms, smooth_yupperWN, 'k');
ylim([0 .5])

FigSaveDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/';
saveName = [FigSaveDir 'StimFigure-2'];
plotpos = [0 0 30 12];

%plot2svg
%plot2svg(saveName, figH)

%print_in_A4(0, saveName, '-djpeg', 0, plotpos); % res type needs to be 1 or it takes forever
print_in_A4(0, saveName, '-depsc', 0, plotpos);

disp('')

%% WN
%{
WN1 = '/media/dlc/Data8TB/TUM/OT/OTProject/AllSignals/WNsignals/test1/WN-1.wav';
WN2 = '/media/dlc/Data8TB/TUM/OT/OTProject/AllSignals/WNsignals/test2/WN-2.wav';
WN3 = '/media/dlc/Data8TB/TUM/OT/OTProject/AllSignals/WNsignals/test1/WN-3.wav';
WN4 = '/media/dlc/Data8TB/TUM/OT/OTProject/AllSignals/WNsignals/test1/WN-4.wav';
WN5 = '/media/dlc/Data8TB/TUM/OT/OTProject/AllSignals/WNsignals/test1/WN-5.wav';


[WNData,Fs] = audioread(WN1); % for some reason, the HRTF signal is a bit longer than the 100 ms stim period

Dt = 1/Fs;
t = 0:Dt:(numel(WNData)*Dt)-Dt;

%[cfs,f] = cwt(LData,'bump',1/Dt,'VoicesPerOctave',48);
[cfs,f] = cwt(WNData, 'bump', 1/Dt,'VoicesPerOctave',48);

subplot(7, 1, 1)
helperCWTTimeFreqPlot(cfs,t*1e3,f./1e3,'surf','WN-1','Time [ms]','Frequency [kHz]')
ylim([.5 8])

css = get(gca, 'clim');
caxis(css);
colorbar 'off'

[WNData,Fs] = audioread(WN2); % for some reason, the HRTF signal is a bit longer than the 100 ms stim period
[cfs,f] = cwt(WNData, 'bump', 1/Dt,'VoicesPerOctave',48);
subplot(7, 1, 2)
helperCWTTimeFreqPlot(cfs,t*1e3,f./1e3,'surf','WN-1','Time [ms]','Frequency [kHz]')
ylim([.5 8])
caxis(css);
colorbar 'off'

[WNData,Fs] = audioread(WN3); % for some reason, the HRTF signal is a bit longer than the 100 ms stim period
[cfs,f] = cwt(WNData, 'bump', 1/Dt,'VoicesPerOctave',48);
subplot(7, 1, 3)
helperCWTTimeFreqPlot(cfs,t*1e3,f./1e3,'surf','WN-1','Time [ms]','Frequency [kHz]')
ylim([.5 8])
caxis(css);
colorbar 'off'

[WNData,Fs] = audioread(WN4); % for some reason, the HRTF signal is a bit longer than the 100 ms stim period
[cfs,f] = cwt(WNData, 'bump', 1/Dt,'VoicesPerOctave',48);
subplot(7, 1, 4)
helperCWTTimeFreqPlot(cfs,t*1e3,f./1e3,'surf','WN-1','Time [ms]','Frequency [kHz]')
ylim([.5 8])
caxis(css);
colorbar 'off'

[WNData,Fs] = audioread(WN5); % for some reason, the HRTF signal is a bit longer than the 100 ms stim period
[cfs,f] = cwt(WNData, 'bump', 1/Dt,'VoicesPerOctave',48);
subplot(7, 1, 5)
helperCWTTimeFreqPlot(cfs,t*1e3,f./1e3,'surf','WN-1','Time [ms]','Frequency [kHz]')
ylim([.5 8])
caxis(css);
colorbar 'off'

%%

% spec_scale = 1;
% subplot(2, 2, 3)
% specgram1(double(LData)/spec_scale,512,Fs,400,360);
% ylim([0 6000])

%% AZ 90
% [wavData2,Fs] = audioread(wavFile2); % for some reason, the HRTF signal is a bit longer than the 100 ms stim period
% 
% dataWin_s = 0.1;
% dataWin_samp = dataWin_s*Fs;
% Dt = 1/Fs;
% LData =wavData2(1:dataWin_samp,1);
% t = 0:Dt:(numel(LData)*Dt)-Dt;
% 
% [cfs,f] = cwt(LData,'bump',1/Dt,'VoicesPerOctave',48);
% subplot(2, 2, 2)
% helperCWTTimeFreqPlot(cfs,t*1e3,f./1e3,'surf',' HRTF STA','Time [ms]','Frequency [kHz]')
% ylim([.5 6])
% caxis(css);
% colorbar 'off'
% 
% spec_scale = 1;
% subplot(2, 2, 4)
% specgram1(double(LData)/spec_scale,512,Fs,400,360);
% ylim([0 6000])

%
%%

[wavData1,Fs] = audioread(wavFile1); % for some reason, the HRTF signal is a bit longer than the 100 ms stim period


figure(101); clf
yss = [-1.5 1.5];


subplot(5, 3,1 )
plot(wavData1(:, 1), 'k')
%ylim([0 8000])
title('Az -90 | Chan 1')
ylim(yss)
grid('on')

subplot(5, 3, 2 )
plot(wavData1(:, 2), 'r')
%ylim([0 8000])
title('Az -90 | Chan 2')
ylim(yss)
grid('on')

subplot(5, 3, 3 )
plot(mean(abs(wavData1(:, 1)), 2) , 'k')
hold on
plot(mean(abs(wavData1(:, 2)), 2), 'r')
plot(mean(abs(wavData1(:, 1)), 2) , 'k')
%ylim([0 8000])
title('Az -90 |')
ylim(yss)
grid('on')


% subplot(5, 3, 3 )
% [yupper1,~] = envelope(wavData1(:, 1));
% [yupper2,~] = envelope(wavData1(:, 2));
%
% diffEnv = yupper2-yupper1;
%
% plot(diffEnv)
% %ylim([0 8000])
% title('Az -90 | Chan 2')
% ylim(yss)
% grid('on')


[wavData2,~] = audioread(wavFile2); % for some reason, the HRTF signal is a bit longer than the 100 ms stim period

subplot(5, 3,4 )
plot(wavData2(:, 1), 'k')
%ylim([0 8000])
title('Az +90 | Chan 1')
ylim(yss)
grid('on')

subplot(5, 3,5 )
plot(wavData2(:, 2), 'r')
%ylim([0 8000])
title('Az +90 | Chan 2')
ylim(yss)
grid('on')

subplot(5, 3, 6 )
plot(mean(abs(wavData2(:, 1)), 2) , 'k')
hold on
plot(mean(abs(wavData2(:, 2)), 2), 'r')
plot(mean(abs(wavData2(:, 1)), 2) , 'k')
%ylim([0 8000])
title('Az +90 | Chan 1 & 2')
ylim(yss)
grid('on')


[wavData3,~] = audioread(wavFile3); % for some reason, the HRTF signal is a bit longer than the 100 ms stim period

subplot(5, 3,7 )
plot(wavData3(:, 1), 'k')
%ylim([0 8000])
title('Az +180 | Chan 1')
ylim(yss)
grid('on')

subplot(5, 3,8 )
plot(wavData3(:, 2), 'r')
%ylim([0 8000])
title('Az +180 | Chan 2')
ylim(yss)
grid('on')

subplot(5, 3, 9 )
plot(mean(abs(wavData3(:, 1)), 2) , 'k')
hold on
plot(mean(abs(wavData3(:, 2)), 2), 'r')
plot(mean(abs(wavData3(:, 1)), 2) , 'k')
%ylim([0 8000])
title('Az +180 | Chan 1 & 2')
ylim(yss)
grid('on')

[wavData4,~] = audioread(wavFile4); % for some reason, the HRTF signal is a bit longer than the 100 ms stim period

subplot(5, 3,10 )
plot(wavData4(:, 1), 'k')
%ylim([0 8000])
title('Az -180 | Chan 1')
ylim(yss)
grid('on')

subplot(5, 3,11)
plot(wavData4(:, 2), 'r')
%ylim([0 8000])
title('Az -180 | Chan 2')
ylim(yss)
grid('on')

subplot(5, 3, 12 )
plot(mean(abs(wavData4(:, 1)), 2) , 'k')
hold on
plot(mean(abs(wavData4(:, 2)), 2), 'r')
plot(mean(abs(wavData4(:, 1)), 2) , 'k')
%ylim([0 8000])
title('Az -180 | Chan 1 & 2')
ylim(yss)
grid('on')


[wavData5,~] = audioread(wavFile5); % for some reason, the HRTF signal is a bit longer than the 100 ms stim period

subplot(5, 3,13 )
plot(wavData5(:, 1), 'k')
%ylim([0 8000])
title('Az 0 | Chan 1')
ylim(yss)
grid('on')

subplot(5, 3,14 )
plot(wavData5(:, 2), 'r')
%ylim([0 8000])
title('Az 0 | Chan 2')
ylim(yss)
grid('on')
disp('')

subplot(5, 3, 15 )
plot(mean(abs(wavData5(:, 1)), 2) , 'k')
hold on
plot(mean(abs(wavData5(:, 2)), 2), 'r')
plot(mean(abs(wavData5(:, 1)), 2) , 'k')
%ylim([0 8000])
title('Az 0 | Chan 1 & 2')
ylim(yss)
grid('on')

disp('')
%}
end