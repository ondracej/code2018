
function []  = calc_delta_gamma_beta_standalone()
ephysData = 'X:\EEG-LFP-songLearning\JaniesAnalysis\ALL_PLOTS\w025\All_LFP_dy\chronic_2021-07-30_20-54-58_allLFP_dyData-7.mat';
filename = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w025\DATA_EPHYS\chronic_2021-07-30_20-54-58\150_CH10.continuous';

disp('Loading data...')
[data, timestamps, info] = load_open_ephys_data(filename);
%[data2, timestamps2, info2] = load_open_ephys_data_adv(fileName,1,1);
disp('Finished loading data...')

Fs = info.header.sampleRate;

samples = size(data, 1);
recordingDuration_s  = samples/Fs;
recordingDuration_ms   = recordingDuration_s*1000;
totalTime = recordingDuration_s;

%%
%addParameter(parseObj,'ch',obj.par.DVRLFPCh{obj.currentPRec},@isnumeric);
%             addParameter(parseObj,'movLongWin',1000*60*30,@isnumeric); %max freq. to examine
%             addParameter(parseObj,'movWin',10000,@isnumeric);
%             addParameter(parseObj,'movOLWin',9000,@isnumeric);
%             addParameter(parseObj,'segmentWelch',1000,@isnumeric);
%             addParameter(parseObj,'dftPointsWelch',2^10,@isnumeric);
%             addParameter(parseObj,'OLWelch',0.5);
%             addParameter(parseObj,'tStart',0,@isnumeric);
%             addParameter(parseObj,'win',0,@isnumeric); %if 0 uses the whole recording duration
%             addParameter(parseObj,'deltaBandCutoff',4,@isnumeric);
%             addParameter(parseObj,'betaBandLowCutoff',10,@isnumeric);
%             addParameter(parseObj,'betaBandHighCutoff',40,@isnumeric);
%             addParameter(parseObj,'applyNotch',0,@isnumeric);
%             addParameter(parseObj,'maxVoltage',1500,@isnumeric);

%movLongWin = 1000*60*30; %max freq. to examine
movLongWin = 1000*60*5; % in ms % 5 min %max freq. to examine
movWin = 10000; % in ms, 10s
movOLWin = 9000; % in ms, 9s
segmentWelch = 1000;
dftPointsWelch = 2^10;
OLWelch = 0.5;
tStart = 3*3600*1000; % in ms, 2 hours
win = 1; %if 0 uses the whole recording duration, if not 2 hours from the end
%deltaBandCutoff = 4;
%betaBandLowCutoff = 10;
%betaBandHighCutoff = 40;
applyNotch = 0;
maxVoltage = 1500;
%%

%% Filters

disp('Filtering data...')
fObj = filterData(Fs);

fobj.filt.F=filterData(Fs);
fobj.filt.F.downSamplingFactor=120; % original is 128 for 32k
%fobj.filt.F.downSamplingFactor=100; % original is 128 for 32k
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



movWinSamples=movWin/1000*fobj.filt.FFs;%obj.filt.FFs in Hz, movWin in samples
movOLWinSamples=movOLWin/1000*fobj.filt.FFs;
timeBin=(movWin-movOLWin); %ms

segmentWelchSamples = round(segmentWelch/1000*fobj.filt.FFs);
samplesOLWelch = round(segmentWelchSamples*OLWelch);

%run welch once to get frequencies for every bin (f) determine frequency bands
[~,f] = pwelch(randn(1,movWinSamples),segmentWelchSamples,samplesOLWelch,dftPointsWelch,fobj.filt.FFs);


deltaBandCutoff = 8; % 4;
betaBandLowCutoff = 10; % 10;
betaBandHighCutoff = 30; % 40;
pfLowBand=find(f<=deltaBandCutoff);
pfHighBand=find(f>=betaBandLowCutoff & f<betaBandHighCutoff);


if win==0
    win=recordingDuration_ms-tStart;
    endTime_ms=recordingDuration_ms;
else
    
    endTime = recordingDuration_s-(3*3600); % 2 hours from the end of the recording in ms
    endTime_ms = endTime*1000;
    %endTime=min(win+tStart,recordingDuration_ms);
end

%%
startTimes_ms=tStart:(movLongWin-movOLWin):endTime_ms;
startTimes_fs = round(startTimes_ms/1000*Fs);
movLongWin_fs = round(movLongWin/1000*Fs);

nChunks=numel(startTimes_ms);
deltaBetaRatioAll=cell(1,nChunks);
t_ms=cell(1,nChunks);
%deltaBetaRatioAllLow=cell(1,nChunks);;deltaBetaRatioAllHigh=cell(1,nChunks);
fprintf('\nDelta2Beta extraction (%d chunks)-',nChunks);

for i=1:nChunks-1
    
    
    
    MLong = data(startTimes_fs(i):startTimes_fs(i)+movLongWin_fs);
    
    %  [MLong, timestamps, info] = load_open_ephys_data_chunked(filename,startTimes(i), startTimes(i)+movLongWin);
    
    
    [MLong,nshifts] = shiftdim(MLong',-1);
    % thisSegData = MLong(:,:,:);
    
    %  [DataSeg_Notch, ~] = fobj.filt.FN.getFilteredData(thisSegData); % t_DS is in ms
    % [DataSeg_BP, ~] = fobj.filt.BP.getFilteredData(thisSegData); % t_DS is in ms
    
    
    if ~applyNotch
        FMLong=fobj.filt.F.getFilteredData(MLong);
    else
        fobj.filt.FN=filterData(Fs);
        fobj.filt.FN.filterDesign='cheby1';
        fobj.filt.FN.padding=true;
        fobj.filt.FN=obj.filt.FN.designNotch;
        
        FMLong=obj.filt.FN.getFilteredData(MLong); %for 50Hz noise
        FMLong=obj.filt.F.getFilteredData(FMLong);
    end
    
    FMLong(FMLong<-maxVoltage | FMLong>maxVoltage)=nan; %remove high voltage movement artifacts
    
    FMLongB = buffer(FMLong,movWinSamples,movOLWinSamples,'nodelay');
    pValid=all(~isnan(FMLongB));
    
    [pxx,f] = pwelch(FMLongB(:,pValid),segmentWelchSamples,samplesOLWelch,dftPointsWelch,fobj.filt.FFs);
    
    deltaBetaRatioAll{i}=zeros(1,numel(pValid));
    deltaBetaRatioAll{i}(pValid)=(mean(pxx(pfLowBand,:))./mean(pxx(pfHighBand,:)))';
    
    deltaRatioAll{i}=zeros(1,numel(pValid));
    deltaRatioAll{i}(pValid)=mean(pxx(pfLowBand,:))';
    
    betaRatioAll{i}=zeros(1,numel(pValid));
    betaRatioAll{i}(pValid)=mean(pxx(pfHighBand,:))';
    
    t_ms{i}=startTimes_ms(i)+((movWin/2):timeBin:(movLongWin-movWin/2));
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


deltaBetaRatioAll{end}(t_ms{end}>(endTime-movWin/2))=NaN;
deltaRatioAll{end}(t_ms{end}>(endTime-movWin/2))=NaN;
betaRatioAll{end}(t_ms{end}>(endTime-movWin/2))=NaN;

bufferedBetaRatio=cell2mat(deltaBetaRatioAll);bufferedBetaRatio=bufferedBetaRatio(:);
bufferedDeltaRatio=cell2mat(deltaRatioAll);bufferedDeltaRatio=bufferedDeltaRatio(:);
bufferedOnlyBetaRatio=cell2mat(betaRatioAll);bufferedOnlyBetaRatio=bufferedOnlyBetaRatio(:);

t_ms=cell2mat(t_ms);

analysisDir = ['X:\EEG-LFP-songLearning\JaniesAnalysis\ALL_PLOTS\w025\BetaAnalysis'];
save([analysisDir 'chronic_2021-07-30_20-54-58__beta'],'t_ms','bufferedBetaRatio','bufferedOnlyBetaRatio','bufferedDeltaRatio');



% 
% 
% batchDuration_s = 5*60; % 5 min
% batchDuration_samp = batchDuration_s*Fs;
% startTimes=tStart:(movLongWin-movOLWin):endTime;
% tOn_s = 1:batchDuration_s:totalTime;
% tOn_samp = tOn_s*Fs;
% nBatches = numel(tOn_samp);





%%

%addParameter(parseObj,'tStart',0,@isnumeric); %max freq. to examine
%addParameter(parseObj,'win',obj.currentDataObj.recordingDuration_ms,@isnumeric);
% addParameter(parseObj,'maxPeriodBand',20,@isnumeric);
% addParameter(parseObj,'movOLWin',4000,@isnumeric);
% addParameter(parseObj,'XCFLag',500000,@isnumeric);
% addParameter(parseObj,'movingAutoCorrWin',1000*1000,@isnumeric);
% addParameter(parseObj,'movingAutoCorrOL',900*1000,@isnumeric);
% addParameter(parseObj,'oscilDurationMovingWin',60*60*1000,@isnumeric);
% addParameter(parseObj,'smoothingDuration',1000*60*60,@isnumeric);
% addParameter(parseObj,'oscilDurationThresh',0.25,@isnumeric);
% addParameter(parseObj,'overwrite',0,@isnumeric);

maxPeriodBand = 20;
movOLWin = 4000; % % 4 s
XCFLag = 500000; 
movingAutoCorrWin = 1000*1000; % 1000 s
movingAutoCorrOL = 900*1000; % 900 s
oscilDurationMovingWin = 60*60*1000; % 1 hr
smoothingDuration=1000*60*60; % 1 hr
oscilDurationThresh = 0.25;
overwrite = 0;



%cross correlation analysis
%pOscillation=find(t_ms>tStart & t_ms<(tStart+win));
pOscillation=find(t_ms>tStart & t_ms<endTime_ms);

%timeBin=(parDBRatio.movWin-parDBRatio.movOLWin);
timeBin=(movWin-movOLWin);
XCFLagSamples=XCFLag/timeBin;
%XCFLagSamples=round(XCFLag/timeBin);
XCFLagSamples=200;

%XCFLagSamples = 50;

[xcf,xcf_lags,xcf_bounds]=crosscorr(bufferedBetaRatio(pOscillation),bufferedBetaRatio(pOscillation),XCFLagSamples);

xcf_lags=xcf_lags*1000;
%calculate periodicity

%find first vally and peak in the autocorrelation function

%[~,pPeak] = findpeaks(xcf(XCFLagSamples+1:end),'MinPeakProminence',0.1);
%[~,pVally] = findpeaks(-xcf(XCFLagSamples+1:end),'MinPeakProminence',0.1);

%[~,pPeak] = findpeaks(xcf(XCFLagSamples+1:end),'MinPeakProminence',0.05);
[~,pPeak] = findpeaks(xcf(XCFLagSamples+1:end),'MinPeakProminence',0.05);
[~,pVally] = findpeaks(-xcf(XCFLagSamples+1:end),'MinPeakProminence',0.05);
if isempty(pPeak) %if peak is weak, try a different value
    [~,pPeak] = findpeaks(xcf(XCFLagSamples+1:end),'MinPeakProminence',0.05);
    [~,pVally] = findpeaks(-xcf(XCFLagSamples+1:end),'MinPeakProminence',0.05);
    disp('Prominance for peak detection was reduced to 0.05 due to low periodicity values!!!');
end



if isempty(pPeak) | isempty(pVally)
    pPeriod=NaN;
    period=NaN;
    pVally=NaN;
    vallyPeriod=NaN;
    peak2VallyDiff=NaN;
else
    pPeriod=pPeak(1)+XCFLagSamples;
    period=xcf_lags(pPeriod);
    pAntiPeriod=pVally(1)+XCFLagSamples;
    vallyPeriod=xcf_lags(pAntiPeriod);
    peak2VallyDiff=xcf(pPeriod)-xcf(pAntiPeriod);
end

figure
  lineHandles = stem(xcf_lags/1000,real(xcf),'filled','r-o');
            set(lineHandles(1),'MarkerSize',4);
            grid('on');
            xlabel('Period [s]');
            ylabel('Auto corr.');
            hold('on');
            
            plot(period/1000,real(xcf(pPeriod)),'o','MarkerSize',5,'color','k');
            
            a = axis;
            plot([a(1) a(1); a(2) a(2)],[xcf_bounds([1 1]) xcf_bounds([2 2])],'-b');
            plot([a(1) a(2)],[0 0],'-k');
            hold('off');
           


%sliding autocorr analysis
%movingAutoCorrWinSamples=movingAutoCorrWin/timeBin;
movingAutoCorrWinSamples=round(movingAutoCorrWin/timeBin);
movingAutoCorrOLSamples=movingAutoCorrOL/timeBin;
autoCorrTimeBin=(movingAutoCorrWin-movingAutoCorrOL);

%BetaRatioForSlidingAutocorr = buffer(bufferedBetaRatio,movingAutoCorrWinSamples,movingAutoCorrOLSamples,'nodelay');

BetaRatioForSlidingAutocorr = buffer(bufferedBetaRatio,movingAutoCorrWinSamples,movingAutoCorrOLSamples,'nodelay');

tSlidingAC=(movingAutoCorrWin/2):(movingAutoCorrWin-movingAutoCorrOL):(t_ms(end)-movingAutoCorrWin/2+movingAutoCorrWin-movingAutoCorrOL);

%R=xcorrmat(BetaRatioForSlidingAutocorr,BetaRatioForSlidingAutocorr,autoCorrSamples);

acfSamples=floor(movingAutoCorrWinSamples/2);
%acf=zeros(size(BetaRatioForSlidingAutocorr,1)+1,size(BetaRatioForSlidingAutocorr,2));
peak2VallyDiff=zeros(1,size(BetaRatioForSlidingAutocorr,2));
for i=1:size(BetaRatioForSlidingAutocorr,2)
    
    [acf(:,i),autoCorrSamples] = crosscorr(BetaRatioForSlidingAutocorr(:,i),BetaRatioForSlidingAutocorr(:,i),acfSamples);
    %calculate peak2VallyDiff for different times
    
    %acf(:,i)=smooth(acf(:,i),10,'moving');
    
    [acfPeakAll(i),acfPeriodAll(i)]=max(acf((acfSamples+pPeak(1)-maxPeriodBand):(acfSamples+pPeak(1)+maxPeriodBand),i));
    [acfVallyAll(i),acfAntiPeriodAll(i)]=min(acf((acfSamples+pVally(1)-maxPeriodBand):(acfSamples+pVally(1)+maxPeriodBand),i));
    peak2VallyDiff(i)=acfPeakAll(i)-acfVallyAll(i);
    
    %{
                [~,pPeak] = findpeaks(acf(acfSamples+1:end,i),'MinPeakProminence',0.1);
                [~,pVally] = findpeaks(-acf(acfSamples+1:end,i),'MinPeakProminence',0.1);
                findpeaks(acf(acfSamples+1:end,i),'MinPeakProminence',0.1);
                disp([pPeak(1) pVally(1)])
                pause;
                
                if ~isempty(pPeak) & ~isempty(pVally)
                    pPeriodTmp=pPeak(1)+acfSamples;
                    pVally=pVally(1)+acfSamples;
                    peak2VallyDiff(i)=acf(pPeriodTmp,i)-acf(pVally,i);
                end
    %}
end

autocorrTimes=autoCorrSamples*timeBin;
acfPeriodAll=autocorrTimes((acfPeriodAll+acfSamples+pPeak(1)-maxPeriodBand-1));


 figure (103); clf
     imagesc(tSlidingAC/1000/60/60,autocorrTimes/1000,real(acf),[-0.5 0.5]);
            ylabel('Autocorr lag [s]');
            ylim(xcf_lags([1 end])/1000);%important for panel plots
            yl=ylim;
            xlim(tSlidingAC([1 end])/1000/60/60); %important for panel plots
            xl=xlim;
            set(h(1),'YDir','normal');
            set(h(1),'XTickLabel',[]);
            hold on;
                    
            


oscilDurationMovingSamples=oscilDurationMovingWin/autoCorrTimeBin;
tmpOscDuration=peak2VallyDiff>oscilDurationThresh;
filtOscilDuration = medfilt1(double(tmpOscDuration),oscilDurationMovingSamples);
pSleepSlidingAC=filtOscilDuration>=0.5;

tmpBin=movingAutoCorrWinSamples-movingAutoCorrOLSamples;
pSleepDBRatio=false(numel(bufferedBetaRatio),1);
for i=1:numel(pSleepSlidingAC)
    pSleepDBRatio(((i-1)*tmpBin+1):(i*tmpBin))=pSleepSlidingAC(i);
end

pStartSleep=find(pSleepDBRatio==1,1,'first');
if ~isempty(pStartSleep)
    tStartSleep=t_ms(pStartSleep);
    tEndSleep=t_ms(find(pSleepDBRatio(pStartSleep:end)==0,1,'first')+pStartSleep);
    
    pSleepSlidingAC=find(tSlidingAC>=tStartSleep & tSlidingAC<=tEndSleep & peak2VallyDiff>oscilDurationThresh);
    
    smoothingSamples=round(smoothingDuration/autoCorrTimeBin);
    filteredSlidingPeriod=smooth(tSlidingAC(pSleepSlidingAC),acfPeriodAll(pSleepSlidingAC),smoothingSamples,'moving');
    edgeSamples=tSlidingAC(pSleepSlidingAC)<=(tSlidingAC(pSleepSlidingAC(1))+smoothingDuration/2) | tSlidingAC(pSleepSlidingAC)>=(tSlidingAC(pSleepSlidingAC(end))-smoothingDuration/2);
    filteredSlidingPeriod(edgeSamples)=[];
    tFilteredSlidingPeriod=tSlidingAC(pSleepSlidingAC(~edgeSamples))';
else
    tStartSleep=[];
    tEndSleep=[];
    pSleepSlidingAC=[];
    filteredSlidingPeriod=[];
    edgeSamples=[];
    filteredSlidingPeriod=[];
    tFilteredSlidingPeriod=[];
end

 %save data
            save(obj.files.dbAutocorr,'parDbAutocorr','xcf','xcf_lags','xcf_bounds','BetaRatioForSlidingAutocorr','autoCorrTimeBin','autocorrTimes','timeBin',...
                'pPeriod','period','acf','vallyPeriod','peak2VallyDiff','pSleepDBRatio','pSleepSlidingAC','acfPeakAll','acfVallyAll','tSlidingAC','acfPeriodAll',...
                'tStartSleep','tEndSleep','filteredSlidingPeriod','tFilteredSlidingPeriod','pSleepSlidingAC');

            
            
    
            
            
            
            
            
%% plot of 30 hz power
%{
            pow_30hz_all_toPlot = double(inds_wake);
            zeroInds = find(pow_30hz_all_toPlot ==0);
            pow_30hz_all_toPlot(zeroInds) = nan;
            figure; plot(pow_30hz_all)
            hold on
            plot(pow_30hz_all_toPlot*1000, 'k*')
%}

%             %%
%             timepoints_wake_samp_cell = [];
%             for oo = 1:numel(timepoints_wake_inds)
%                 timepoints_wake_samp_cell{oo} = timepoints_wake_inds(oo)*size(deltaGammaRatioAll, 2)-size(deltaGammaRatioAll, 2)+1:timepoints_wake_inds(oo)*size(deltaGammaRatioAll, 2)+1;
%             end
%
%
%             timepoints_wake_samp = cell2mat(timepoints_wake_samp_cell);




INFO.Birdname = obj.INFO.birdName{:};
INFO.EphysRecName = obj.EPHYS.EphysRecName{thisEntry};
INFO.date = obj.INFO.date_txt_year(thisEntry,:);
INFO.EphysStartTime = obj.EPHYS.EphysStartTime{thisEntry};
INFO.LightsOff = obj.VIDEO.LightsOff{thisEntry};
INFO.LightsOn = obj.VIDEO.LightsOn{thisEntry};
INFO.dataType = dataInfo.dataType;

[totalDur_min_start_lightsOff] = calc_offset_alignment_time_min(obj, INFO.date, INFO.EphysStartTime, INFO.LightsOff);
[totalDur_min_start_lightsOn] = calc_offset_alignment_time_min(obj, INFO.date, INFO.EphysStartTime, INFO.LightsOn);

INFO.totalDur_min_start_lightsOff = totalDur_min_start_lightsOff;
INFO.totalDur_min_start_lightsOn = totalDur_min_start_lightsOn;


% use the dark period to calculate the threshold
pow_30hz_inthedark = pow_30hz(totalDur_min_start_lightsOff:totalDur_min_start_lightsOn);
pow_30hz_inthedark = cell2mat(pow_30hz_inthedark);
pow_30hz_all = cell2mat(pow_30hz);

move_artef_thresh=median(pow_30hz_inthedark)+5*iqr(pow_30hz_inthedark);
% artefact windows:
inds_wake=pow_30hz_all>move_artef_thresh;
timepoints_wake_inds = find(inds_wake ==1);

nWakedetections = numel(timepoints_wake_inds);
percentDataWDetection = nWakedetections/ numel(inds_wake)*100;

dyData.bufferedDeltaGammaRatioCell = bufferedDeltaGammaRatioCell;
dyData.bufferedDeltaCell = bufferedDeltaCell ;
dyData.bufferedGammaCell = bufferedGammaCell;
dyData.alldsData = alldsData;
dyData.Fs_ds = fobj.filt.FFs;
dyData.Fs = Fs;
dyData.pow_30hz = pow_30hz ;
dyData.move_artef_thresh = move_artef_thresh;
dyData.inds_wake = inds_wake;
dyData.nBatches = nBatches;
dyData.batchDuration_s = batchDuration_s;
dyData.dataFilename = dataInfo.filename;
dyData.percentDataWDetection = percentDataWDetection;
%%

saveDir = [obj.PATH.AllPlots  obj.INFO.birdName{:} obj.PATH.dirD 'EphysAnalysis' obj.PATH.dirD];

if exist(saveDir, 'dir') == 0
    mkdir(saveDir);
    disp(['Created: '  saveDir])
end

SaveName = [saveDir obj.INFO.birdName{:} '_' INFO.date '_' INFO.dataType '_dyData'];

save([SaveName '.mat'], 'dyData', 'INFO', '-v7.3')

%% Now make a plot

allBuffered_dy_Data  = cell2mat(bufferedDeltaGammaRatioCell); %%%%%% save this
allBuffered_d_Data  = cell2mat(bufferedDeltaCell); %%%%%% save this
allBuffered_y_Data  = cell2mat(bufferedGammaCell); %%%%%% save this

pow_30hz_all_toPlot = double(inds_wake);
zeroInds = find(pow_30hz_all_toPlot ==0);
pow_30hz_all_toPlot(zeroInds) = nan;

switch dataInfo.dataType
    
    case {'EEG_L_Ant', 'EEG_R_Ant', 'EEG_L_Post', 'EEG_R_Post'}
        ylim_30hz = [0 800];
        ylim_dy = [0 1000];
        ylim_d = [0 800];
        ylim_y = [0 20];
        
    case {'LFP_m', 'LFP_l'}
        ylim_30hz = [0 3000];
        ylim_dy = [0 800];
        ylim_d = [0 3000];
        ylim_y = [0 50];
end

%%
binSize = size(deltaMeanAll, 2);
smoothWindow = binSize*5; % 5 min
gray = [0.5 0.5 0.5];

figure(104); clf

subplot(4, 1, 1)
plot(pow_30hz_all, 'color', 'k')
hold on
plot(pow_30hz_all_toPlot*500, 'r*')
line([1, numel(pow_30hz_all)], [move_artef_thresh move_artef_thresh], 'color', 'r')
line([totalDur_min_start_lightsOff, totalDur_min_start_lightsOff], [ylim_30hz(1) ylim_30hz(2)], 'color', 'b')
line([totalDur_min_start_lightsOn, totalDur_min_start_lightsOn], [ylim_30hz(1) ylim_30hz(2)], 'color', 'b')

xticks = 0:60:numel(pow_30hz_all);
set(gca, 'xtick', xticks)
xticksNew_lab = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14'} ;
nxticks = numel(xticks);
xtickslabs = xticksNew_lab(1:nxticks);
set(gca, 'xticklabel', xtickslabs)
axis tight
ylim(ylim_30hz)
title([INFO.Birdname ' | ' INFO.date ' | ' dataInfo.dataType ' | 30 Hz noise, mvmt detections'], 'Interpreter', 'none')
xticks = 0:60*binSize:numel(allBuffered_dy_Data);
nxticks = numel(xticks);
xtickslabs = xticksNew_lab(1:nxticks);

%%
subplot(4, 1, 2) % d/y

plot(allBuffered_dy_Data, 'color', gray)
hold on
plot(smooth(allBuffered_dy_Data,smoothWindow), 'color', 'k', 'linewidth', 2)
axis tight
ylim(ylim_dy)

set(gca, 'xtick', xticks)
set(gca, 'xticklabel', xtickslabs)
title(['d/y ratio'])
%%
subplot(4, 1, 3) % d
plot(allBuffered_d_Data, 'color', gray)
hold on
plot(smooth(allBuffered_d_Data,smoothWindow), 'color', 'k', 'linewidth', 2)
axis tight
ylim(ylim_d)
set(gca, 'xtick', xticks)
set(gca, 'xticklabel', xtickslabs)
title(['delta: ' num2str(deltaBandLowCutoff) ':' num2str(deltaBandHighCutoff) ' Hz'])
%%

subplot(4, 1, 4) % y
plot(allBuffered_y_Data, 'color', gray)
hold on
plot(smooth(allBuffered_y_Data, smoothWindow), 'color', 'k', 'linewidth', 2)
axis tight
ylim(ylim_y)
set(gca, 'xtick', xticks)
set(gca, 'xticklabel', xtickslabs)
title(['gamma: ' num2str(gammaBandLowCutoff) ':' num2str(gammaBandHighCutoff) ' Hz'])
xlabel('Time (Hr)')
%%

plotpos = [0 0 25 15];

%plotDir =   'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\ALL_PLOTS\w038-12Hr_EEG\';


plot_filename = [SaveName];
print_in_A4(0, plot_filename, '-djpeg', 0, plotpos);
% print_in_A4(0, plot_filename, '-depsc', 0, plotpos);


%{
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
%}

%%



end
