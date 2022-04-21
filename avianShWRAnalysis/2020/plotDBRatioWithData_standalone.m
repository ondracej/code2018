function [] = plotDBRatioWithData_standalone()


ChanDataToLoad = 'G:\SWR\ZF-71-76_Final\20190920\18-37-00\Ephys\106_CH2.continuous';


addpath(genpath('C:\Users\Neuropix\Documents\GitHub\analysis-tools\'));

[filepath,name,ext] = fileparts(ChanDataToLoad);

PlottingDir = [filepath '\Plots\'];
slash = '\';
bla = find(filepath == slash);

RecName = filepath(bla(3)+1:bla(5)-1);
bla = find(RecName == slash);
RecName(bla) = '_';


if exist(PlottingDir, 'dir') == 0
    mkdir(PlottingDir);
    disp(['Created: '  PlottingDir])
end

[data, timestamps, info] = load_open_ephys_data(ChanDataToLoad);
thisSegData_s = timestamps(1:end) - timestamps(1);
Fs = info.header.sampleRate;


samples = size(data, 1);
recordingDuration_s  = samples/Fs;
totalTime = recordingDuration_s;
batchDuration_s = 1*60*5; % 30 min
batchDuration_samp = batchDuration_s*Fs;

tOn_s = 1:batchDuration_s:totalTime;
tOn_samp = tOn_s*Fs;
nBatches = numel(tOn_samp);


%% Filters
fObj = filterData(Fs);

fobj.filt.F=filterData(Fs);
%fobj.filt.F.downSamplingFactor=120; % original is 128 for 32k
fobj.filt.F.downSamplingFactor=100; % original is 128 for 32k
fobj.filt.F=fobj.filt.F.designDownSample;
fobj.filt.F.padding=true;
fobj.filt.FFs=fobj.filt.F.filteredSamplingFrequency;

%fobj.filt.FL=filterData(Fs);
%fobj.filt.FL.lowPassPassCutoff=4.5;
%fobj.filt.FL.lowPassStopCutoff=6;
%fobj.filt.FL.attenuationInLowpass=20;
%fobj.filt.FL=fobj.filt.FL.designLowPass;
%fobj.filt.FL.padding=true;

fobj.filt.FL=filterData(Fs);
fobj.filt.FL.lowPassPassCutoff=30;% this captures the LF pretty well for detection
fobj.filt.FL.lowPassStopCutoff=40;
fobj.filt.FL.attenuationInLowpass=20;
fobj.filt.FL=fobj.filt.FL.designLowPass;
fobj.filt.FL.padding=true;

fobj.filt.BP=filterData(Fs);
fobj.filt.BP.highPassCutoff=1;
fobj.filt.BP.lowPassCutoff=2000;
fobj.filt.BP.filterDesign='butter';
fobj.filt.BP=fobj.filt.BP.designBandPass;
fobj.filt.BP.padding=true;

fobj.filt.FH2=filterData(Fs);
fobj.filt.FH2.highPassCutoff=100;
fobj.filt.FH2.lowPassCutoff=2000;
fobj.filt.FH2.filterDesign='butter';
fobj.filt.FH2=fobj.filt.FH2.designBandPass;
fobj.filt.FH2.padding=true;

%             fobj.filt.FN =filterData(Fs);
%             fobj.filt.FN.filterDesign='cheby1';
%             fobj.filt.FN.padding=true;
%             fobj.filt.FN=fobj.filt.FN.designNotch;

%%
bufferedDeltaGammaRatio = [];
bufferedDelta= [];
bufferedGamma= [];
allV_DS = [];


%% Get Filtered Data

%i=99
for i = 99:nBatches-1
    
    if i == nBatches
        thisData = data(tOn_samp(i):samples);
    else
        thisData = data(tOn_samp(i):tOn_samp(i)+batchDuration_samp);
    end
    
    [V_uV_data_full,nshifts] = shiftdim(thisData',-1);
    thisSegData = V_uV_data_full(:,:,:);
    
    %  [DataSeg_Notch, ~] = fobj.filt.FN.getFilteredData(thisSegData); % t_DS is in ms
    [DataSeg_BP, ~] = fobj.filt.BP.getFilteredData(thisSegData); % t_DS is in ms
    [DataSeg_F, t_DS] = fobj.filt.F.getFilteredData(DataSeg_BP); % t_DS is in ms
     [DataSeg_FH, t_] = fobj.filt.FH2.getFilteredData(DataSeg_BP); % t_DS is in ms
    
    t_DS_s = t_DS/1000;
    
    %% Raw Data  - Parameters from data=getDelta2BetaRatio(obj,varargin)
    
    reductionFactor = 1; % No reduction
    
    movWin_Var = 10*reductionFactor; % 10 s
    movOLWin_Var = 9*reductionFactor; % 9 s
    
    segmentWelch = 1*reductionFactor;
    OLWelch = 0.5*reductionFactor;
    
    dftPointsWelch =  2^10;
    
    segmentWelchSamples = round(segmentWelch*fobj.filt.FFs);
    samplesOLWelch = round(segmentWelchSamples*OLWelch);
    
    movWinSamples=round(movWin_Var*fobj.filt.FFs);%obj.filt.FFs in Hz, movWin in samples
    movOLWinSamples=round(movOLWin_Var*fobj.filt.FFs);
    
    % run welch once to get frequencies for every bin (f) determine frequency bands
    [~,f] = pwelch(randn(1,movWinSamples),segmentWelchSamples,samplesOLWelch,dftPointsWelch,fobj.filt.FFs);
    
    
    deltaThetaLowCutoff = 1;
    deltaThetaHighCutoff = 8;
    
    gammaBandLowCutoff = 30;
    gammaBandHighCutoff = 80;
    
    pfDeltaThetaBand=find(f>=deltaThetaLowCutoff & f<deltaThetaHighCutoff);
    pfGammBand=find(f>=gammaBandLowCutoff & f<gammaBandHighCutoff);
    
    
    %%
    %%
    tmp_V_DS = buffer(DataSeg_F,movWinSamples,movOLWinSamples,'nodelay');
    pValid=all(~isnan(tmp_V_DS));
    
    [pxx,f] = pwelch(tmp_V_DS(:,pValid),segmentWelchSamples,samplesOLWelch,dftPointsWelch,fobj.filt.FFs);
    
    %% plot powerspectrum
    tmp_V_DS = buffer(DataSeg_F,movWinSamples,movOLWinSamples,'nodelay');
    pValid=all(~isnan(tmp_V_DS));
    
    [pxx,f] = pwelch(tmp_V_DS(:,pValid),segmentWelchSamples,samplesOLWelch,dftPointsWelch,fobj.filt.FFs);
    
    
    bla = randperm(size(pxx, 2));
    sel = bla(1:20);
    
    figure(103);clf
    subsampl = pxx(:, 1:20);
    plot(10*log10(subsampl), 'color', [.5 .5 .5])
    xlim([0 100])
    means = mean(subsampl, 2);
    hold on
    plot(10*log10(means), 'k', 'linewidth', 2)
    ylabel('dB')
    xlabel('Freq. (Hz)')
    
    plotpos = [0 0 10 8];
    
    % PlotDir = [obj.DIR.plotDir];
    
    % plot_filename = [PlotDir 'powerSpec_' sprintf('%02d',b)];
    % print_in_A4(0, plot_filename, '-djpeg', 0, plotpos);
    % print_in_A4(0, plot_filename, '-depsc', 0, plotpos);
    
    
    %% Ratios
    
    
    deltaThetaOGammeRatioAll = zeros(1,numel(pValid));
    deltaThetaOGammaRatioAll(pValid)=(mean(pxx(pfDeltaThetaBand,:))./mean(pxx(pfGammBand,:)))';
    
    
    %%
    
    bufferedDeltaThetaOGammaRatio(i,:)=deltaThetaOGammaRatioAll;
    bufferedDeltaThetaOGammaRatioCell{i} = deltaThetaOGammaRatioAll;
    
    allV_DS{i} = squeeze(tmp_V_DS);
    
    %%
    figh3 = figure(302); clf
    
    %% Raw Data
    subplot(4, 2, [1 2])
    plot(t_DS_s, squeeze(DataSeg_F), 'k')
    axis tight
    title('V_BP_DS')
    xlabel('Time [s]')
    axis tight
    ylim([-500 500])
    
    %% D/B Rato
    deltaThetaOGammeRatioAll_norm = deltaThetaOGammaRatioAll./max(max(deltaThetaOGammaRatioAll));
    subplot(4, 2, [3 4])
    title('i=99')
    axis tight
    hold on
    
    %plot(smooth(deltaThetaOGammeRatioAll_norm, 5), 'linewidth', 1)
    plot(smooth(deltaThetaOGammaRatioAll, 3), 'linewidth', 1)
    ylim([0 700])
    axis tight
    
    
    
    
    %%
    
    ax1 = subplot(4, 2, 5);
    plot(t_DS_s, squeeze(DataSeg_F), 'k');
    
    ylim([-500 500])
    
    ax2 = subplot(4, 2, 6);
    plot(t_DS_s, squeeze(DataSeg_F), 'k');
    
    ylim([-500 500])
    
    %% wavelets
    thisSegData_wav = DataSeg_F;
    % [thisSegData_wav,nshifts] = shiftdim(thisSegData_wav',-1);
    
    dsf = 20;
    
    [n_ch,n_tr,N] = size(thisSegData_wav);
    
    %[bb,aa] = butter(2,hcf/(Fs/2),'low');
    V_ds = reshape(permute(thisSegData_wav,[3 1 2]),[],n_ch*n_tr);
    % V_ds = downsample(filtfilt(bb,aa,V_ds),dsf);
    V_ds = reshape(V_ds,[],n_ch,n_tr);
    
    DS_Factor = 100;
    
    %
    [N,n_chs,n_trials] = size(V_ds);
    nfreqs = 60;
    min_freq = 1.5;
    max_freq = 800;
    
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
    
    tr=1;
    clims = [0 500];
    
    ax3 = subplot(4,2,7);
    pcolor((1:N)/Fsd,wfreqs,abs(squeeze(V_wave(:,:,tr))));shading flat
    % set(gca,'yscale','log');
    axis tight
    ylim([1 50])
    caxis(clims);
    colorbar('location', 'northoutside')
    
    ax4 = subplot(4,2,8);
    pcolor((1:N)/Fsd,wfreqs,abs(squeeze(V_wave(:,:,tr))));shading flat
    axis tight
    ylim([1 50])
    caxis(clims);
    colorbar('location', 'northoutside')
    
    linkaxes([ax1 ax3],'x')
    linkaxes([ax2 ax4],'x')
    
    axes(ax1)
    xlim([115 125])
    
    axes(ax2)
    xlim([225 235])
    
    %%
    %% PRinting raw data examples
    figure(102); clf
    ax2 = subplot(4,2,5);
     plot(t_/1000, squeeze(DataSeg_BP), 'k');
   %xlim([118 120])
     ax4 = subplot(4,2,7);
     plot(t_/1000, squeeze(DataSeg_FH), 'k');
    % xlim([11800 12000])
  
      linkaxes([ax2 ax4],'x')
    
end

%%
 figure(102); 
 plotpos = [0 0 15 12]; %Fig 2

plotDir = 'G:\SWR\ZF-71-76_Final\20190920\18-37-00\Plots\';

plot_filename = [plotDir 'DB_Ratio_seg_RawData' sprintf('%02d',i)];
print_in_A4(0, plot_filename, '-djpeg', 0, plotpos);
print_in_A4(0, plot_filename, '-depsc', 0, plotpos);











end
