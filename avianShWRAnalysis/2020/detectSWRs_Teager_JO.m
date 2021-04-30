function [] = detectSWRs_Teager_JO()

close all

%% Add open ephys to path
pathToOpenEphys = 'C:\Users\Janie\Documents\GitHub\analysis-tools\';
addpath(genpath(pathToOpenEphys))

%% Load single channel with Open Ephys

%spw_det_coeff = 7;

chanSet = 5;

EphysDir = 'D:\TUM\SWR-Project\ZF-59-15\20190428\19-34-00\Ephys\';
saveDir  = 'D:\TUM\SWR-Project\ZF-59-15\20190428\19-34-00\swrT\19-34-00-SWR_tig.mat';

extSearch ='*.continuous*';
allOpenEphysFiles=dir(fullfile(EphysDir,extSearch));
nFiles=numel(allOpenEphysFiles);

for s=chanSet
    
    eval(['fileAppend = ''100_CH' num2str(s) '.continuous'';'])
    fileName = [EphysDir fileAppend];    
    [data, timestamps, info] = load_open_ephys_data(fileName);
    
end

fs = info.header.sampleRate;

dataTime_s = timestamps - timestamps(1);
recordingDuration_s = dataTime_s(end);

%% Notch Filter

fObj = filterData(fs);

fobj.filt.FN =filterData(fs);
fobj.filt.FN.filterDesign='cheby1';
fobj.filt.FN.padding=true;
fobj.filt.FN=fobj.filt.FN.designNotch;

[data_shift,nshifts] = shiftdim(data',-1);
data_FNotch = squeeze(fobj.filt.FN.getFilteredData(data_shift));

%% Change var names to Match Hamed's code

eeg = data_FNotch;     % This is notch filtered
time = dataTime_s;
k=1; % channel index, we only have 1 channel
%% Downsample the signal

downsampleBy = 10;

signal_raw=downsample(eeg,downsampleBy);
t_signal=downsample(time,downsampleBy);
fs_=fs/downsampleBy;

%%

SWR_fil = [0.1 100];
rip_fil = [100 300];

% SWR_fil = [1 40]; % Hamed's orignal code
% rip_fil = [80 300]; % Hamed's orignal code

% filtering for SWR and figures
% for sharp wave:
%ShFilt = designfilt('bandpassiir','FilterOrder',4, 'HalfPowerFrequency1',1,'HalfPowerFrequency2',40, 'SampleRate',fs_);
ShFilt = designfilt('bandpassiir','FilterOrder',4, 'HalfPowerFrequency1',SWR_fil(1),'HalfPowerFrequency2',SWR_fil(2), 'SampleRate',fs_);
spwsig=filtfilt(ShFilt,signal_raw);
% for ripples:
%RippFilt = designfilt('bandpassiir','FilterOrder',4, 'HalfPowerFrequency1',80,'HalfPowerFrequency2',300, 'SampleRate',fs_);
RippFilt = designfilt('bandpassiir','FilterOrder',4, 'HalfPowerFrequency1',(rip_fil(1)),'HalfPowerFrequency2',rip_fil(2), 'SampleRate',fs_);
RippSig=filtfilt(RippFilt,signal_raw);

%% Data and filter plots

figure (100);clf

%raw data
ax1 = subplot(5,1,1); plot(t_signal,signal_raw(:,k)); %title(['Raw signal  ' fname  '  Time ref: ' num2str(t0) ' sec'])
ylabel('(\muV)'); axis tight

% SWR
ax2 = subplot(5,1,2); plot(t_signal,spwsig(:,1),'k');
title(['SW Fil: ' num2str(SWR_fil(1)) '-' num2str(SWR_fil(2)) 'Hz (SPW)']); ylabel('(\muV)'); 
axis tight

% HF Ripple
ax4 = subplot(5,1,4); plot(t_signal,RippSig(:,1),'r');
title(['Rip Fil: ' num2str(rip_fil(1)) '-' num2str(rip_fil(2)) 'Hz (Ripples)']); ylabel('(\muV)');
axis tight

%% Teager analysis

shifts_ms = 50;
shifts_samp = shifts_ms/1000*fs_;

tig_SWR = teager(spwsig(:,k),shifts_samp);
tig_HF = teager(RippSig(:,k),shifts_samp);

percentile4ScaleEstimation = 95;
%thr=median(tig)+spw_det_coeff*median(abs(tig))/.67; % threshold for detection of spw

sortedTig_SWR = sort(tig_SWR);
scaleEstimator_Tig_SWR=sortedTig_SWR(round(percentile4ScaleEstimation/100*numel(sortedTig_SWR)));

sortedTig_HF = sort(tig_HF);
scaleEstimator_Tig_HF=sortedTig_HF(round(percentile4ScaleEstimation/100*numel(sortedTig_HF)));

thr_SWR = scaleEstimator_Tig_SWR;
thr_HF = scaleEstimator_Tig_HF;

%%
ax3 = subplot(5,1,3);
plot(t_signal,tig_SWR,'b'); title('TEO -SWR' ); ylabel('(\muV^2)'); xlabel('Time (Sec)'); 
hold on
line([t_signal(1) t_signal(end)], [thr_SWR thr_SWR], 'color', 'r')
axis tight

ax5 = subplot(5,1,5);
plot(t_signal,tig_HF,'b'); title('TEO -SWR' ); ylabel('(\muV^2)'); xlabel('Time (Sec)'); 
hold on
line([t_signal(1) t_signal(end)], [thr_HF thr_HF], 'color', 'r')
%% define the threhsold

linkaxes([ax1, ax2, ax3, ax4, ax5], 'x')

xlim([0 30])
% plotting distribution of TEO values and the threshold for spw detection
%figure % distribution of TEO values for channel k  %%%%%%%%%%%%%%%
%hist(tig,300); y=ylim;  hold on; line([thr thr],y,'LineStyle','--')
%%
%{
% plot for raw data + spw detection threshold
figure (200); clf
subplot(2,1,1);
plot(t_signal,spwsig(:,k)); %title(['LFP (1-100 Hz)  ' fname  '  Time ref: ' num2str(t0) ' sec']);  
ylabel('(\muV)');
%xlim(plot_time)
subplot(2,1,2);
plot(t_signal,tig,'b'); hold on; line(plot_time,[thr thr],'LineStyle','--');  title('TEO -SWR' );
ylabel('(\muV^2)'); xlabel('Time (Sec)'); xlim(plot_time); axis tight
%}
%%
N=1; % only have 1 channel

up_tresh=tig_SWR.*(tig_SWR>thr_SWR);
[~,spw_indices] = findpeaks(up_tresh(fs_+1:end-fs),'MinPeakDistance',fs_/10); % Finding peaks in the channel with max variance, omitting the 1st and last sec ...

spw_indices=spw_indices+fs_; % shifting 1 sec to the right place for the corresponding time (removal of 1st second is compensared)
spw1=zeros(2*fs_/5+1,N,length(spw_indices)); % initialization: empty spw matrix, length of spw templates is considered as 400ms
n=1;
while n <= length(spw_indices)
    spw1(:,:,n)=spwsig(spw_indices(n)-fs_/5 : spw_indices(n)+fs_/5,:); n=n+1;  % spw in the 1st channel
end

% removing upward detected-events
indx=spw1(round(size(spw1,1)/2),k,:)<mean(spw1([1 end],k,:),1); % for valid spw, middle point shall occur below the line connecting the two sides
spw_=spw1(:,:,indx);
spw_indx1=spw_indices(indx); % selected set of indices of SPWs that are downward

% correcting SPW times, all detected events will be aligned to their minimum:
[~,min_point]=min(spw_(:,k,:),[],1); % extracting index of the minimum point for any detected event
align_err1=min_point-ceil(size(spw_,1)/2); % Error = min_point - mid_point
align_err=reshape(align_err1,size(spw_indx1));
spw_indx=spw_indx1+align_err; % these indices are time-corrected
spwT=t_signal(spw_indx);

%% find double detection

allDiffs = diff(spw_indx);
zeroDiffs =find(allDiffs == 0);
spw_indx(zeroDiffs) = [];

%% 

timeWin_ms = 100;
timeWin_samp = timeWin_ms/1000*fs_;

% repicking SPW events after time alignment
spws=zeros(2*timeWin_samp+1,N,length(spw_indx)); % initialization: empty spw matrix, length of spw templates is considered as 200ms
eegSW=zeros(2*timeWin_samp+1,N,length(spw_indx)); % initialization: empty spw matrix, length of spw templates is considered as 200ms
n=1;
while n <= length(spw_indx)
    spws(:,:,n)=spwsig(spw_indx(n)-timeWin_samp : spw_indx(n)+timeWin_samp,:); %n=n+1;  % spw in the 1st channel
    eegSW(:,:,n)=signal_raw(spw_indx(n)-timeWin_samp : spw_indx(n)+timeWin_samp,:); 
    
    n=n+1;  % spw in the 1st channel
end

%%
%{
movingwin=[0.05 0.01]; % in s set the moving window dimensions
 
params.Fs=fs_;%: sampling frequency (slightly different interpretation for spike times
%params.tapers=[3 5];%: controls the number of tapers
params.tapers=[1 2];%: controls the number of tapers
%params.tapers=[3 5];%: controls the number of tapers
params.pad  = 1; %: controls the padding
params.fpass=[SWR_fil]; %: frequency range of interest
params.err=0; %: controls error computation
params.trialave=0; %: controls whether or not to average over trials
%}
%%
 %[N,n_chs,n_trials] = size(V_ds);
 
 nfreqs = 60;
 min_freq = 0.1;
 max_freq = 100;
 %min_freq = SWR_fil(1);
 %max_freq = SWR_fil(2);
 
 %Fsd = Fs/dsf;
 Fsd = fs_;
 
 min_scale = 1/max_freq*Fsd;
 max_scale = 1/min_freq*Fsd;
 wavetype = 'cmor1-1';
 scales = logspace(log10(min_scale),log10(max_scale),nfreqs);
 wfreqs = scal2frq(scales,wavetype,1/Fsd);
 n_trials =1;
 
 
 %%

figure(300); clf
cnt = 1;

for i=1:size(spws,3)
    
    subplot(3, 1, 1); cla
    %plot((-fs_/5:fs_/5)/fs_*1000,spws(:,k,i)); hold on
    plot((-timeWin_samp:timeWin_samp)/fs_*1000,eegSW(:,k,i)); hold on
    hold on
    subplot(3, 1, 1)
    plot((-timeWin_samp:timeWin_samp)/fs_*1000,spws(:,k,i), 'r');
    
    
    %dataSeg = spws(:,k,i);
    dataSeg = eegSW(:,k,i);
    
    alldataSegs{cnt} = dataSeg;
    
    cur_V = dataSeg;
    V_wave = cwt(cur_V(:),scales,wavetype);
    V_wave = reshape(V_wave,nfreqs,[],n_trials);
    [Nn] = size(cur_V, 1);
    tr = 1;
    
    subplot(3, 1, 2)
    
    vWave_sq = abs(squeeze(V_wave(:,:,tr)));
    
    pcolor((1:Nn)/Fsd,wfreqs,vWave_sq);shading flat
    %set(gca,'yscale','log');
    %ylim([0 100])
    axis tight
    caxis([0 200]);
    
    allVwav{cnt} = vWave_sq;
    
    
    subplot(3, 1, 3); cla
    hold on
    [pxx,f] = pmtm(dataSeg,2,length(dataSeg),fs_);
    
    %pmtm(dataSeg,3,length(dataSeg),fs_)
    plot(f, 10*log10(pxx))
    xlim([0 300])

    
    allPx{cnt} = pxx;
    
    cnt = cnt+1;
    
    
%     [S,t,f]=mtspecgramc(dataSeg ,movingwin,params); % compute spectrogram
%     X=10*log10(S);
%     plot(f,X, 'color', [0.5 0.5 0.5]); hold on
%     meanX = mean(X);
%     plot(f,meanX , 'color', 'r', 'linewidth', 2);
%     %plot_matrix(S,t,f); xlabel([]); % plot spectrogram
%     axis tight
%     pause
end

% 
% axis tight; xlabel('Time (ms)'); ylabel('Amplitude (\muV)')
% axis([-200 200 -750 150]);
% title('SPWs in max variance chnl')

    
%%
% % plot of average SPWs across channels
% subplot(1,2,2)
% hold on
% for chnl=1:N
%     plot((-fs_/5:fs_/5)/fs_*1000,mean(spws(:,chnl,:),3), ...
%         'color',[220 chnl*255/N 255-chnl*255/N]/255); % color coded based on channel
% end
% axis([-200 200 -400 50]); xlabel('Time (ms)');
% title({'mean SPW accross chnls'; ['rate: ' num2str( round(size(spws,3) / max(time)*60 ,1)) '/min  ' fname]}); ylabel('Amplitude (\muV)')

figure(400); clf
ax2a = subplot(2,1,1);
plot(t_signal,signal_raw(:,k)); title('Raw signal ' );  ylabel('(\muV)');
hold on; plot(t_signal(spw_indx),signal_raw(spw_indx),'+r'); axis tight

ax2b = subplot(2,1,2);
plot(t_signal,tig_SWR,'b'); hold on;
line([t_signal(1) t_signal(end)],[thr_SWR thr_SWR],'LineStyle','--');  title('TEO ' );
plot(t_signal(spw_indx),tig_SWR(spw_indx),'+r')
ylabel('(\muV^2)'); xlabel('Time (Sec)'); 
%xlim(plot_time); 
axis tight

linkaxes([ax2a, ax2b], 'x')

xlim([0 30]);

%% Save this

SWR.EphysDir = EphysDir;
SWR.chanSet = chanSet; 
SWR.spw_indx = spw_indx;
SWR.alldataSegs  = alldataSegs;
SWR.allVwav  = allVwav;
SWR.allPx  = allPx;

save(saveDir, 'SWR', '-v7.3')







end

