function [] = openEphys_plotDBRatio()

dbstop if error
close all

addpath(genpath('/home/janie/Code/analysis-tools-master/'));
addpath(genpath('/home/janie/Code/MPI/NSKToolBox/'));    
dirD = '/';

%fileName = '/home/janie/Data/SleepChicken/chick2_2018-04-30_17-29-04/100_CH1.continuous';

%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_15-19-16/100_CH1.continuous';
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_15-41-19/100_CH1.continuous';
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_16-03-12/100_CH1.continuous';
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_16-30-56/100_CH1.continuous';
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-05-32/100_CH1.continuous';
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-05-32/100_CH1.continuous'; %good one
fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-29-04/100_CH1.continuous'; %good one
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-56-36/100_CH1.continuous';


[pathstr,name,ext] = fileparts(fileName);

bla = find(fileName == dirD);

dataName = fileName(bla(end-1)+1:bla(end)-1);

saveName = [pathstr dirD dataName '-fullData'];

[data, timestamps, info] = load_open_ephys_data(fileName);

Fs = info.header.sampleRate;

fObj = filterData(Fs);

obj = sleepAnalysis;
obj=obj.getFilters(Fs);

%fObj = designNotch(Fs);
%% Filters

fobj.filt.F=filterData(Fs);
fobj.filt.F.downSamplingFactor=120; % original is 128 for 32k
fobj.filt.F=fobj.filt.F.designDownSample;
fobj.filt.F.padding=true;
fobj.filt.FFs=fobj.filt.F.filteredSamplingFrequency;

fobj.filt.FL=filterData(Fs);
fobj.filt.FL.lowPassPassCutoff=4.5;
fobj.filt.FL.lowPassStopCutoff=6;
fobj.filt.FL.attenuationInLowpass=20;
fobj.filt.FL=fobj.filt.FL.designLowPass;
fobj.filt.FL.padding=true;

fobj.filt.FH2=filterData(Fs);
fobj.filt.FH2.highPassCutoff=100;
fobj.filt.FH2.lowPassCutoff=2000;
fobj.filt.FH2.filterDesign='butter';
fobj.filt.FH2=fobj.filt.FH2.designBandPass;
fobj.filt.FH2.padding=true;

fobj.filt.FN =filterData(Fs);
fobj.filt.FN.filterDesign='cheby1';
fobj.filt.FN.padding=true;
fobj.filt.FN=fobj.filt.FN.designNotch;
                    
%% Raw Data

[V_uV_data_full,nshifts] = shiftdim(data',-1);

thisSegData = V_uV_data_full(:,:,:);

%% Get Filtered Data

DataSeg_FN = fobj.filt.FN.getFilteredData(thisSegData);
DataSeg_FL = fobj.filt.FL.getFilteredData(thisSegData);
DataSeg_FH2 = fobj.filt.FH2.getFilteredData(thisSegData);
[DataSeg_F, t_DS] = fobj.filt.F.getFilteredData(thisSegData);

thisSegData_ms = timestamps(1:end) - timestamps(1);

%%

% HF of bandpass
tmp_V_H2 =obj.filt.FH2.getFilteredData(tmpV); %bandpassfilter
tmp_V_FL =obj.filt.FL.getFilteredData(tmpV); %bandpassfilter

[tmpV, t_ms] =dataRecordingObj.getData(csc,tON,WIN);
[tmp_V_BP_DS, t_DS] =obj.filt.F.getFilteredData(V_uV_data_full);


%%
%reductionFactor = 0.2;
reductionFactor = 1;
%
%movWin_Var = 5000*reductionFactor;
%movOLWin_Var = 4000*reductionFactor;

movWin_Var = 10000*reductionFactor;
movOLWin_Var = 9000*reductionFactor;

%segmentWelch = 1000*reductionFactor;
segmentWelch = 1000*reductionFactor;
OLWelch = 0.5*reductionFactor;

%
dftPointsWelch =  2^10;
segmentWelchSamples = round(segmentWelch/1000*obj.filt.FFs);
samplesOLWelch = round(segmentWelchSamples*OLWelch);

movWinSamples=round(movWin_Var/1000*obj.filt.FFs);%obj.filt.FFs in Hz, movWin in samples
movOLWinSamples=round(movOLWin_Var/1000*obj.filt.FFs);

% run welch once to get frequencies for every bin (f) determine frequency bands
[~,f] = pwelch(randn(1,movWinSamples),segmentWelchSamples,samplesOLWelch,dftPointsWelch,obj.filt.FFs);

deltaBandCutoff = 4;

betaBandLowCutoff = 15;
betaBandHighCutoff = 40;

%turtleSleep_DB(rfc).DB.D_CutoffFreq  = 4;
%turtleSleep_DB(rfc).DB.B_lowFreq  = 15;
%turtleSleep_DB(rfc).DB.B_hiFreq  = 40;
%turtleSleep_DB(rfc).DB.G_lowFreq  = 50;
%turtleSleep_DB(rfc).DB.G_hiFreq  = 80;

%gammaBandLowCutoff = DB.G_lowFreq;
%gammaBandHighCutoff = DB.G_hiFreq;

pfLowBand=find(f<=deltaBandCutoff);
pfHighBand=find(f>=betaBandLowCutoff & f<betaBandHighCutoff);
%pfgammaBand=find(f>=gammaBandLowCutoff & f<gammaBandHighCutoff);
%
%B_tmp_V_BP_DS = buffer(tmp_V_BP_DS,movWinSamples,movOLWinSamples,'nodelay');
B_tmp_V_BP_DS = buffer(DataSeg_F,movWinSamples,movOLWinSamples,'nodelay');
pValid=all(~isnan(B_tmp_V_BP_DS));

[pxx,f] = pwelch(B_tmp_V_BP_DS(:,pValid),segmentWelchSamples,samplesOLWelch,dftPointsWelch,obj.filt.FFs);

% Ratios
deltaBetaRatioAll=zeros(1,numel(pValid));
deltaBetaRatioAll(pValid)=(mean(pxx(pfLowBand,:))./mean(pxx(pfHighBand,:)))';

%deltaGammaRatioAll=zeros(1,numel(pValid));
%deltaGammaRatioAll(pValid)=(mean(pxx(pfLowBand,:))./mean(pxx(pfgammaBand,:)))';

% single elements
deltaAll=zeros(1,numel(pValid));
deltaAll(pValid)=mean(pxx(pfLowBand,:))';

betaAll=zeros(1,numel(pValid));
betaAll(pValid)=mean(pxx(pfHighBand,:))';

%gammaAll=zeros(1,numel(pValid));
%gammaAll(pValid)=mean(pxx(pfgammaBand,:))';

% Pool all data ratios

bufferedDeltaBetaRatio=deltaBetaRatioAll;
%bufferedDeltaGammaRatio(i,:)=deltaGammaRatioAll;

bufferedDelta=deltaAll;
bufferedBeta=betaAll;
%bufferedGamma(i,:)=gammaAll;

allV_BP_DS = squeeze(DataSeg_F);
%allV_BP_DS{i} = squeeze(tmpV);

%%
sizestr = ['movWin =' num2str(movWin_Var) 'ms; movOLWin = ' num2str(movOLWin_Var) ' ms'];
Betacolor = [150 50 0]/255;
Deltacolor = [0 50 150]/255;

figh3 = figure(300); clf
subplot(3, 1, 1)
plot(betaAll*30, 'color', Betacolor, 'linewidth', 2)
hold on
plot(deltaAll, 'color', Deltacolor, 'linewidth', 2)
%plot(gammaAll*500, 'color', 'k', 'linewidth', 2)
axis tight

%title(['Delta, Beta, Gamma' sizestr])
set(gca, 'xtick', [])
%legTxt = [{['Beta: ' num2str(betaBandLowCutoff) '-' num2str(betaBandHighCutoff) ' Hz']} , {['Delta: < ' num2str(deltaBandCutoff) ' Hz']}, {['Gamma: ' num2str(gammaBandLowCutoff) '-' num2str(gammaBandHighCutoff) ' Hz']} ];
legTxt = [{['Beta: ' num2str(betaBandLowCutoff) '-' num2str(betaBandHighCutoff) ' Hz']} , {['Delta: < ' num2str(deltaBandCutoff) ' Hz']} ];
legend(legTxt)
ylim([0 10000])% P48

subplot(3, 1, 2)
plot(t_DS/1000, squeeze(DataSeg_F), 'k')
axis tight
title('V_BP_DS')
xlabel('Time [s]')
axis tight
%ylim(Plotting.BP_V_Ylim)

%fV1_norm = fV1./(max(max(fV1)));

deltaBetaRatioAll_norm = deltaBetaRatioAll./(max(max(deltaBetaRatioAll)));
subplot(3, 1, 3)
%plot(deltaBetaRatioAll_norm, 'linewidth', 2)
axis tight
hold on
%plot(smooth(deltaBetaRatioAll_norm, 5), 'linewidth', 2, 'color', 'k')
plot(smooth(deltaBetaRatioAll_norm, 5), 'linewidth', 2)
%plot(DiffRatios, 'linewidth', 2)
title(['Delta/Beta Ratio | ' sizestr ])
set(gca, 'xtick', [])
axis tight
%ylim([0 10000])% P48
%
%         subplot(4, 1, 4)
%         plot(deltaGammaRatioAll, 'linewidth', 2)
%         axis tight
%         hold on
%         plot(smooth(deltaGammaRatioAll, 5), 'linewidth', 2, 'color', 'k')
%         title(['Delta/Gamma Ratio | ' sizestr ])
%         set(gca, 'xtick', [])
%         ylim([0 50000])% P48

%%
plotpos = [0 0 20 30];
export_to = set_export_file_format(1); % 2 = png, 1 = epsc
plot_filename = ['/home/janie/Dropbox/02_talks/May2018/newFigs/DB-' titl];
printFig(figh3, plot_filename, plotpos, export_to )


end

