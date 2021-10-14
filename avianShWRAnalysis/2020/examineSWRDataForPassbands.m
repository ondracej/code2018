function [] = examineSWRDataForPassbands()


%SessionDir = 'G:\SWR\ZF-60-88\20190429\15-48-05\Ephys\'; % need dirdelim at end
%SessionDir = 'G:\SWR\ZF-72-96\20200108\14-03-08\Ephys\';
SessionDir = 'G:\SWR\ZF-71-76\20190916\18-05-58\Ephys\';

%chanMap = [7 10 2 15 3 14 4 13 1 16 5 12 6 11 8 9];
%chanMap = [13 1 16 5 12 6 11 8 9];

%chanMap = [5 4 6 3 9 16 8 1 11 14 12 13 10 15 7 2];
%rippleChans = [2 5 7 13 16];
%chanMap = [10 12 7 11 9 6 8 5 3 16 4 1 13 15 14 2];
%chanMap = [10 12 7 11 9 6 8 5 3 16 4 13 15 14 2];%remove chan 1 broken
ch = 7;

%%
[filepath,name,ext] = fileparts(SessionDir);

plotDir = [filepath '\Detections\'];

if exist(plotDir, 'dir') == 0
    mkdir(plotDir);
    disp(['Created: '  plotDir])
end

doPlot = 1;

%dataDir = obj.DIR.ephysDir;

dataRecordingObj = OERecordingMF(SessionDir);
dataRecordingObj = getFileIdentifiers(dataRecordingObj); % creates dataRecordingObject

Fs = dataRecordingObj.samplingFrequency;
recordingDur_ms = dataRecordingObj.recordingDuration_ms;
recordingDur_s = recordingDur_ms/1000;


bandPassFilter1 = [1 400];
DS_Factor = 20;

fObj = filterData(Fs);

%BandPass 1
fobj.filt.BP1=filterData(Fs);
fobj.filt.BP1.highPassCutoff=bandPassFilter1(1);
fobj.filt.BP1.lowPassCutoff=bandPassFilter1(2);
fobj.filt.BP1.filterDesign='butter';
fobj.filt.BP1=fobj.filt.BP1.designBandPass;
fobj.filt.BP1.padding=true;

fobj.filt.F2=filterData(Fs);
fobj.filt.F2.downSamplingFactor=DS_Factor; % original is 128 for 32k for sampling rate of 250
fobj.filt.F2=fobj.filt.F2.designDownSample;
fobj.filt.F2.padding=true;
fobj.filt.F2Fs=fobj.filt.F2.filteredSamplingFrequency;

% fobj.filt.FL=filterData(Fs);
% %fobj.filt.FL.lowPassPassCutoff=4.5;
% %fobj.filt.FL.lowPassPassCutoff=20;
% %fobj.filt.FL.lowPassStopCutoff=30;
% fobj.filt.FL.lowPassPassCutoff=30;% this captures the LF pretty well for detection
% fobj.filt.FL.lowPassStopCutoff=40;
% fobj.filt.FL.attenuationInLowpass=20;
% fobj.filt.FL=fobj.filt.FL.designLowPass;
% fobj.filt.FL.padding=true;
% 
% fobj.filt.FH2=filterData(Fs);
% fobj.filt.FH2.highPassCutoff=100;
% fobj.filt.FH2.lowPassCutoff=2000;
% fobj.filt.FH2.filterDesign='butter';
% fobj.filt.FH2=fobj.filt.FH2.designBandPass;
% fobj.filt.FH2.padding=true;

fobj.filt.FN =filterData(Fs);
fobj.filt.FN.filterDesign='cheby1';
fobj.filt.FN.padding=true;
fobj.filt.FN=fobj.filt.FN.designNotch;



seg_s= 20; % 2 second overlap
seg_ms= seg_s*1000;
TOn = 1:seg_s*1000:recordingDur_s*1000; % Needs to be in ms


% Random selection of time segments
nCycles = numel(TOn);

rng(1); % for reproducibiity
pCycle=randperm(nCycles);


for k=1:numel(TOn)-1
    
    
    [rawData,t_ms]=dataRecordingObj.getData(ch,TOn(pCycle(k)), seg_ms);
    
    DataSeg_BP = fobj.filt.BP1.getFilteredData(rawData);

    DataSeg_FN = fobj.filt.FN.getFilteredData(DataSeg_BP);
    
    DataSeg_FNds = fobj.filt.F2.getFilteredData(DataSeg_FN);
    
    
    %thisSegData_wav = Wavdata(1:6000);
    thisSegData_wav = DataSeg_FNds;
    % [thisSegData_wav,nshifts] = shiftdim(thisSegData_wav',-1);
    
    dsf = 20;
    Fsd = Fs/dsf;
    hcf = 400;
    [n_ch,n_tr,N] = size(thisSegData_wav);
    
    %[bb,aa] = butter(2,hcf/(Fs/2),'low');
    V_ds = reshape(permute(thisSegData_wav,[3 1 2]),[],n_ch*n_tr);
   % V_ds = downsample(filtfilt(bb,aa,V_ds),dsf);
    V_ds = reshape(V_ds,[],n_ch,n_tr);
    
    %
    [N,n_chs,n_trials] = size(V_ds);
    nfreqs = 60;
    min_freq = 1.5;
    max_freq = 800;
    %Fsd = Fs/dsf;
    %Fsd = Fs;
    Fsd = Fs/DS_Factor;
    min_scale = 1/max_freq*Fsd;
    max_scale = 1/min_freq*Fsd;
    wavetype = 'cmor1-1';
    scales = logspace(log10(min_scale),log10(max_scale),nfreqs);
    wfreqs = scal2frq(scales,wavetype,1/Fsd);
    
    use_ch = 1;
    cur_V = squeeze(V_ds(:,use_ch,:));
    V_wave = cwt(cur_V(:),scales,wavetype);
    V_wave = reshape(V_wave,nfreqs,[],n_trials);
    
    %% Mean PLot
    clims = [0 20];
    tr =1;
    
    figure(104); clf
    subplot(3,1,1);
    plot(squeeze(DataSeg_FN), 'k');
    axis tight
    
    title( ['SWR-Wavelet:'])
    
    subplot(3,1,2);
    pcolor((1:N)/Fsd,wfreqs,abs(squeeze(V_wave(:,:,tr))));shading flat
    % set(gca,'yscale','log');
    axis tight
    ylim([0 200])
    %caxis(clims);
    caxis([0 500]);
    
    subplot(3,1,3);
    pcolor((1:N)/Fsd,wfreqs,abs(squeeze(V_wave(:,:,tr))));shading flat
    % set(gca,'yscale','log');
    axis tight
    ylim([0 50])
    %caxis(clims);
    caxis([0 500]);
    
    xlabel('Time (s)')
    ylabel('Frequency [Hz]')
    
    pause
end

end

