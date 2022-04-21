
function [] = plotDBRatioMatrix_standalone(ChanDataToLoad)
dbstop if error

%% o3b7
%ChanDataToLoad = 'G:\SWR\ZF-o3b7\20200116\18-21-31\Ephys\114_CH9.continuous';
%ChanDataToLoad = 'G:\SWR\ZF-o3b7\20200115\18-24-27\Ephys\114_CH9.continuous';
%ChanDataToLoad = 'G:\SWR\ZF-o3b7\20200117\17-56-38\Ephys\114_CH9.continuous';
%ChanDataToLoad = 'G:\SWR\ZF-o3b7\20200118\19-50-48\Ephys\114_CH9.continuous';
%ChanDataToLoad = 'G:\SWR\ZF-o3b7\20200119\20-14-53\Ephys\114_CH9.continuous';
%ChanDataToLoad = 'G:\SWR\ZF-o3b7\20200121\20-02-13\Ephys\114_CH9.continuous';
%ChanDataToLoad = 'G:\SWR\ZF-o3b7\20200122\20-15-48\Ephys\114_CH9.continuous';
%ChanDataToLoad = 'G:\SWR\ZF-o3b7\20200125\18-01-36\Ephys\114_CH9.continuous';
%ChanDataToLoad = 'G:\SWR\ZF-o3b7\20200128\19-37-53\Ephys\114_CH9.continuous';
%ChanDataToLoad = 'G:\SWR\ZF-o3b7\20200203\18-41-49\Ephys\120_CH9.continuous';
%ChanDataToLoad = 'G:\SWR\ZF-o3b7\20200207\16-25-09\Ephys\120_CH9.continuous';
%ChanDataToLoad = 'G:\SWR\ZF-o3b7\20200208\20-02-19\Ephys\120_CH9.continuous';
%ChanDataToLoad = 'G:\SWR\ZF-o3b7\20200209\19-18-42\Ephys\120_CH9.continuous';
%ChanDataToLoad = 'G:\SWR\ZF-o3b7\20200210\19-10-58\Ephys\120_CH9.continuous';
%% 71-76

%ChanDataToLoad = 'G:\SWR\ZF-71-76_Final\20190915\20-01-48\Ephys\Ephys\106_CH2.continuous';
%ChanDataToLoad = 'G:\SWR\ZF-71-76_Final\20190916\18-05-58\Ephys\106_CH2.continuous';
%ChanDataToLoad = 'G:\SWR\ZF-71-76\20190917\16-05-11\Ephys\106_CH7.continuous';
%ChanDataToLoad = 'G:\SWR\ZF-71-76_Final\20190918\18-04-28\Ephys\106_CH2.continuous';
%ChanDataToLoad = 'G:\SWR\ZF-71-76_Final\20190919\17-51-46\Ephys\106_CH2.continuous';
%ChanDataToLoad = 'G:\SWR\ZF-71-76_Final\20190920\18-37-00\Ephys\106_CH2.continuous';
%ChanDataToLoad = 'G:\SWR\ZF-71-76_Final\20190923\18-21-42\Ephys\106_CH2.continuous';

%% w037
%ChanDataToLoad = 'H:\HamedsData\w038_w037\w037\chronic_2021-08-31_21-59-35\Ephys\150_CH16.continuous';
%ChanDataToLoad = 'H:\HamedsData\w038_w037\w037\chronic_2021-09-01_21-54-15\Ephys\150_CH16.continuous';
%ChanDataToLoad = 'H:\HamedsData\w038_w037\w037\chronic_2021-09-02_21-57-58\Ephys\150_CH16.continuous';
%ChanDataToLoad = 'H:\HamedsData\w038_w037\w037\chronic_2021-09-03_21-51-46\Ephys\150_CH16.continuous';
%ChanDataToLoad = 'H:\HamedsData\w038_w037\w037\chronic_2021-09-04_22-18-08\Ephys\150_CH16.continuous';
%ChanDataToLoad = 'H:\HamedsData\w038_w037\w037\chronic_2021-09-05_21-13-37\Ephys\150_CH16.continuous';
%ChanDataToLoad = 'H:\HamedsData\w038_w037\w037\chronic_2021-09-07_21-59-35\Ephys\150_CH16.continuous';

%ChanDataToLoad = 'H:\HamedsData\w038_w037\w037\chronic_2021-09-20_22-02-53\Ephys\150_CH16.continuous';
%ChanDataToLoad = 'H:\HamedsData\w038_w037\w037\chronic_2021-09-21_21-50-18\Ephys\150_CH16.continuous';
%ChanDataToLoad = 'H:\HamedsData\w038_w037\w037\chronic_2021-09-22_22-16-19\Ephys\150_CH16.continuous';

%% w038
%ChanDataToLoad = 'H:\HamedsData\w038_w037\w038\chronic_2021-09-19_22-10-06\Ephys\150_CH26.continuous';
%ChanDataToLoad = 'H:\HamedsData\w038_w037\w038\chronic_2021-09-18_21-59-46\Ephys\150_CH26.continuous';
%ChanDataToLoad = 'H:\HamedsData\w038_w037\w038\chronic_2021-09-16_21-28-13\Ephys\150_CH26.continuous';
%ChanDataToLoad = 'H:\HamedsData\w038_w037\w038\chronic_2021-09-15_22-08-48\Ephys\150_CH26.continuous';
%ChanDataToLoad = 'H:\HamedsData\w038_w037\w038\chronic_2021-09-13_22-18-08\Ephys\150_CH26.continuous';
%ChanDataToLoad = 'H:\HamedsData\w038_w037\w038\chronic_2021-09-12_20-26-52\Ephys\150_CH26.continuous';

%% w044

%ChanDataToLoad = 'H:\HamedsData\w042_w044\w044\chronic_2021-12-30_20-56-35\Ephys\150_CH10.continuous';
%ChanDataToLoad = 'H:\HamedsData\w042_w044\w044\chronic_2022-01-01_20-26-41\Ephys\150_CH10.continuous';
%ChanDataToLoad = 'H:\HamedsData\w042_w044\w044\chronic_2022-01-13_21-57-16\Ephys\150_CH10.continuous';
%ChanDataToLoad = 'H:\HamedsData\w042_w044\w044\chronic_2022-01-02_20-53-44\Ephys\150_CH10.continuous';

%% w042
%ChanDataToLoad = 'H:\HamedsData\w042_w044\w042\lchronic_2021-12-30_20-56-35\Ephys\150_CH32.continuous';
%ChanDataToLoad = 'H:\HamedsData\w042_w044\w042\chronic_2022-01-01_20-26-41\Ephys\150_CH32.continuous';
%ChanDataToLoad = 'H:\HamedsData\w042_w044\w042\chronic_2022-01-04_20-47-15 - trig ok\Ephys\150_CH32.continuous';
%ChanDataToLoad = 'H:\HamedsData\w042_w044\w042\chronic_2022-01-13_21-57-16\Ephys\150_CH32.continuous';
%ChanDataToLoad = 'H:\HamedsData\w042_w044\w042\chronic_2022-01-12_21-39-12\Ephys\150_CH32.continuous';
%% w025 - good copy of tutor song
%ChanDataToLoad = 'H:\HamedsData\w025_w027\w025\chronic_2021-08-18_21-57-57\Ephys\150_CH16.continuous';
%ChanDataToLoad = 'H:\HamedsData\w025_w027\w025\chronic_2021-08-17_21-47-03\Ephys\150_CH16.continuous';
%ChanDataToLoad = 'H:\HamedsData\w025_w027\w025\chronic_2021-07-15_20-28-44\Ephys\150_CH24.continuous';

%% W027 - poor copy of tutor song (but nice song)
%ChanDataToLoad = 'H:\HamedsData\w025_w027\w027\chronic_2021-07-23_22-43-29\Ephys\150_CH49.continuous';
%ChanDataToLoad = 'H:\HamedsData\w025_w027\w027\chronic_2021-07-24_22-37-34\Ephys\150_CH49.continuous';
%ChanDataToLoad = 'H:\HamedsData\w025_w027\w027\chronic_2021-07-25_23-03-55\Ephys\150_CH49.continuous';
%ChanDataToLoad = 'H:\HamedsData\w025_w027\w027\chronic_2021-07-26_21-35-23\Ephys\150_CH49.continuous';
%ChanDataToLoad = 'H:\HamedsData\w025_w027\w027\chronic_2021-07-27_21-49-20\Ephys\150_CH49.continuous';
%ChanDataToLoad = 'H:\HamedsData\w025_w027\w027\chronic_2021-07-28_21-51-11\Ephys\150_CH49.continuous';
%ChanDataToLoad = 'H:\HamedsData\w025_w027\w027\chronic_2021-07-29_21-47-09\Ephys\150_CH49.continuous';
%ChanDataToLoad = 'H:\HamedsData\w025_w027\w027\chronic_2021-07-30_20-54-58\Ephys\150_CH49.continuous';
%ChanDataToLoad = 'H:\HamedsData\w025_w027\w027\chronic_2021-07-31_21-50-14\Ephys\150_CH49.continuous';
%ChanDataToLoad = 'H:\HamedsData\w025_w027\w027\chronic_2021-08-01_22-20-35\Ephys\150_CH49.continuous';
%ChanDataToLoad = 'H:\HamedsData\w025_w027\w027\chronic_2021-08-02_21-26-05\Ephys\150_CH49.continuous';
%ChanDataToLoad = 'H:\HamedsData\w025_w027\w027\chronic_2021-08-04_22-02-26\Ephys\150_CH49.continuous';
%ChanDataToLoad = 'H:\HamedsData\w025_w027\w027\chronic_2021-08-05_22-06-10\Ephys\150_CH49.continuous';
%ChanDataToLoad = 'H:\HamedsData\w025_w027\w027\chronic_2021-08-06_20-57-20\Ephys\150_CH49.continuous';
%ChanDataToLoad = 'H:\HamedsData\w025_w027\w027\chronic_2021-08-08_21-11-29\Ephys\150_CH49.continuous';

%ChanDataToLoad = 'H:\HamedsData\w025_w027\w027\chronic_2021-08-18_21-57-57\Ephys\150_CH25.continuous';
%ChanDataToLoad = 'H:\HamedsData\w025_w027\w027\chronic_2021-08-17_21-47-03\Ephys\150_CH25.continuous';

%% Frog
%ChanDataToLoad = 'I:\Grass\FrogSleep\CubanTreeFrog1\20190626\20190626_09-00\Ephys\2019-06-26_09-00-01\106_CH15.continuous';

%%
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
batchDuration_s = 1*60*30; % 30 min
batchDuration_samp = batchDuration_s*Fs;

tOn_s = 1:batchDuration_s:totalTime;
tOn_samp = tOn_s*Fs;
nBatches = numel(tOn_samp);

%Plotting.titleTxt = [params.BirdName ' | ' params.DateTime];
%Plotting.saveTxt = [params.BirdName '_' params.DateTime];

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

for i = 1:nBatches-1
    
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
    
    t_DS_s = t_DS/1000;
    
    %% Raw Data  - Parameters from data=getDelta2BetaRatio(obj,varargin)
    
    % This is all in ms
    %             addParameter(parseObj,'movLongWin',1000*60*30,@isnumeric); %max freq. to examine
    %             addParameter(parseObj,'movWin',10000,@isnumeric);
    %             addParameter(parseObj,'movOLWin',9000,@isnumeric);
    %             addParameter(parseObj,'segmentWelch',1000,@isnumeric);
    %             addParameter(parseObj,'dftPointsWelch',2^10,@isnumeric);
    %             addParameter(parseObj,'OLWelch',0.5);
    %
    %reductionFactor = 0.5; % No reduction
    %reductionFactor = 0.15; % No reduction
    %reductionFactor = 0.5; % No reduction
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
    
    %                 deltaBandLowCutoff = 1;
    %                 deltaBandHighCutoff = 4;
    %
    %                 thetaBandLowCutoff  = 4;
    %                 thetaBandHighCutoff  = 8;
    
    %                 alphaBandLowCutoff  = 8;
    %                 alphaBandHighCutoff  = 12;
    
    deltaThetaLowCutoff = 1;
    deltaThetaHighCutoff = 8;
    
    %                 betaBandLowCutoff = 12;
    %                 betaBandHighCutoff = 30;
    
    %gammaBandLowCutoff = 30;
    %gammaBandHighCutoff = 100;
    
    %gammaBandLowCutoff = 25;
    %gammaBandHighCutoff = 140;
    gammaBandLowCutoff = 30;
    gammaBandHighCutoff = 80;
    
    %  pfDeltaBand=find(f>=deltaBandLowCutoff & f<deltaBandHighCutoff);
    %  pfThetaBand=find(f>=thetaBandLowCutoff & f<thetaBandHighCutoff);
    pfDeltaThetaBand=find(f>=deltaThetaLowCutoff & f<deltaThetaHighCutoff);
    %  pfAlphaBand=find(f>=alphaBandLowCutoff & f<alphaBandHighCutoff);
    %  pfBetaBand=find(f>=betaBandLowCutoff & f<betaBandHighCutoff);
    pfGammBand=find(f>=gammaBandLowCutoff & f<gammaBandHighCutoff);
    
    
    %%
    %%
    tmp_V_DS = buffer(DataSeg_F,movWinSamples,movOLWinSamples,'nodelay');
    pValid=all(~isnan(tmp_V_DS));
    
    [pxx,f] = pwelch(tmp_V_DS(:,pValid),segmentWelchSamples,samplesOLWelch,dftPointsWelch,fobj.filt.FFs);
    
    %% Ratios
    %                 deltaBetaRatioAll=zeros(1,numel(pValid));
    %                 deltaBetaRatioAll(pValid)=(mean(pxx(pfDeltaBand,:))./mean(pxx(pfBetaBand,:)))';
    %
    %                 deltaThetaRatioAll = zeros(1,numel(pValid));
    %                 deltaThetaRatioAll(pValid)=(mean(pxx(pfDeltaBand,:))./mean(pxx(pfThetaBand,:)))';
    
    deltaThetaOGammeRatioAll = zeros(1,numel(pValid));
    deltaThetaOGammaRatioAll(pValid)=(mean(pxx(pfDeltaThetaBand,:))./mean(pxx(pfGammBand,:)))';
    
    %                 deltaAlphRatioAll = zeros(1,numel(pValid));
    %                 deltaAlphRatioAll(pValid)=(mean(pxx(pfDeltaBand,:))./mean(pxx(pfAlphaBand,:)))';
    %
    %                 deltaGammaRatioAll = zeros(1,numel(pValid));
    %                 deltaGammaRatioAll(pValid)=(mean(pxx(pfDeltaBand,:))./mean(pxx(pfGammBand,:)))';
    %
    %                 betaGammaRatioAll = zeros(1,numel(pValid));
    %                 betaGammaRatioAll (pValid)=(mean(pxx(pfBetaBand,:))./mean(pxx(pfGammBand,:)))';
    %
    %                 thetaGammaRatioAll = zeros(1,numel(pValid));
    %                 thetaGammaRatioAll (pValid)=(mean(pxx(pfThetaBand,:))./mean(pxx(pfGammBand,:)))';
    
    %% single elements
    %                 deltaAll=zeros(1,numel(pValid));
    %                 deltaAll(pValid)=mean(pxx(pfDeltaBand,:))';
    %
    %                 thetaAll=zeros(1,numel(pValid));
    %                 thetaAll(pValid)=mean(pxx(pfThetaBand,:))';
    %
    %                 alphaAll=zeros(1,numel(pValid));
    %                 alphaAll(pValid)=mean(pxx(pfAlphaBand,:))';
    %
    %                 betaAll=zeros(1,numel(pValid));
    %                 betaAll(pValid)=mean(pxx(pfBetaBand,:))';
    %
    %                 gammaAll=zeros(1,numel(pValid));
    %                 gammaAll(pValid)=mean(pxx(pfGammBand,:))';
    %
    
    %%
    %bufferedDeltaBetaRatio(i,:)=deltaBetaRatioAll;
    %bufferedDeltaAlphaRatio(i,:)=deltaAlphRatioAll;
    %bufferedDeltaThetaRatio(i,:)=deltaThetaRatioAll;
    %bufferedDeltaGammaRatio(i,:)=deltaGammaRatioAll;
    bufferedDeltaThetaOGammaRatio(i,:)=deltaThetaOGammaRatioAll;
    bufferedDeltaThetaOGammaRatioCell{i} = deltaThetaOGammaRatioAll;
    
    %bufferedDelta(i,:)=deltaAll;
    %bufferedBeta(i,:)=betaAll;
    %bufferedTheta(i,:)=thetaAll;
    %bufferedGamma(i,:)=gammaAll;
    %bufferedAlpha(i,:)=alphaAll;
    
    allV_DS{i} = squeeze(tmp_V_DS);
    
end

allBufferedData  = cell2mat(bufferedDeltaThetaOGammaRatioCell);

figure(145);clf
subplot(1, 2, 1)
plot(smooth(allBufferedData, 300)) % 300  = 5 min smooth
hold on
%plot(smooth(allBufferedData, 1800)) % 300  = 5 min smooth
hold on
plot(smooth(allBufferedData, 3600), 'linewidth', 2) % 300  = 5 min smooth
%hold on
%plot(smooth(allBufferedData, 7200)) % 300  = 5 min smooth

axis tight
xticks_s = 0:size(tmp_V_DS,2)*2: size(allBufferedData, 2);
set(gca, 'xtick', xticks_s)
xlabs = [];
for j = 1:numel(xticks_s)
    xlabs{j} = num2str(j-1);
end

set(gca, 'xticklabel', xlabs)
ylim([0 1200])
xlabel('Time (hr)')

dataToPlot  = bufferedDeltaThetaOGammaRatio;
dbScale = 50000;


%%
subplot(1, 2, 2)

imagesc(dataToPlot, [0 1200])
%imagesc(dataToPlot, [0 300])
% imagesc(dataToPlot(2:29, :), [0 1200])
%imagesc(dataToPlot(2:29, :))

if batchDuration_s == 1800
    %xtics = get(gca, 'xtick');
    xticks_s = 0:5*60:30*60;
    xticks_min = xticks_s/60;
    
    xticklabs = xticks_min;
    
    ytics = get(gca, 'ytick');
    ytics_Hr = ytics/2;
    
end
xlabs = [];
for j = 1:numel(xticklabs)
    xlabs{j} = num2str(xticklabs(j));
end

ytics_Hr_round = [];
for j = 1:numel(ytics_Hr)
    %ytics_Hr_round{j} = num2str(round(ytics_Hr(j)));
    ytics_Hr_round{j} = num2str(ytics_Hr(j));
end

set(gca, 'xtick', xticks_s)
set(gca, 'xticklabel', xlabs)
set(gca, 'yticklabel', ytics_Hr_round)

xlabel('Time (min)')
ylabel('Time (hr)')
%title([params.DateTime ' | ' titletxt])
colorbar
%%
plotpos = [0 0 35 15];



plot_filename = [PlottingDir RecName '__DBMatrix'];
print_in_A4(0, plot_filename, '-djpeg', 0, plotpos);
print_in_A4(0, plot_filename, '-depsc', 0, plotpos);

D.bufferedDeltaThetaOGammaRatio = bufferedDeltaThetaOGammaRatio;
D.allBufferedData = allBufferedData;

save([PlottingDir RecName '__DeltaThetaRatio.mat'], 'D', '-v7.3')

end

