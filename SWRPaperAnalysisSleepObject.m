%SWRPaperAnalysisSleepObject
function [] = SWRPaperAnalysisSleepObject()

close all
clear all
dbstop if error

% Code dependencies
pathToCodeRepository = 'C:\Users\Janie\Documents\GitHub\code2018\';
pathToOpenEphysAnalysisTools = 'C:\Users\Janie\Documents\GitHub\analysis-tools\';
pathToNSKToolbox = 'C:\Users\Janie\Documents\GitHub\NeuralElectrophysilogyTools\';
pathToJRCLUST = 'C:\Users\Janie\Documents\GitHub\JRCLUST';

addpath(genpath(pathToCodeRepository)) 
addpath(genpath(pathToOpenEphysAnalysisTools)) 
addpath(genpath(pathToNSKToolbox)) 
addpath(genpath(pathToJRCLUST)) 

%% Data Dirs

%dataDir = 'D:\TUM\SWR-Project\ZF-71-76\Ephys\71-76_chronic_2019-09-15_20-01-48';
dataDir = 'D:\TUM\SWR-Project\ZF-71-76\Ephys\71-76_chronic_2019-09-16_18-05-58';

%%

%dataDir = 'D:\TUM\SWR-Project\ZF-72-81\Ephys\2019-05-16_21-26-59';
dataDir = 'D:\TUM\SWR-Project\ZF-72-81\Ephys\2019-05-16_23-21-04';

%% Data Object
dataRecordingObj = OERecordingMF(dataDir);
dataRecordingObj = getFileIdentifiers(dataRecordingObj); % creates dataRecordingObject
timeSeriesViewer(dataRecordingObj); % loads all the channels
%%
FreqBandDetectionSleepObject(dataRecordingObj)

%%
getDelta2BetaRatio(dataRecordingObj)

end



   

  function data=getDelta2BetaRatio(obj,varargin)
            obj.checkFileRecording;
            
            parseObj = inputParser;
            addParameter(parseObj,'ch',obj.recTable.defaulLFPCh(obj.currentPRec),@isnumeric);
            addParameter(parseObj,'movLongWin',1000*60*30,@isnumeric); %max freq. to examine
            addParameter(parseObj,'movWin',10000,@isnumeric);
            addParameter(parseObj,'movOLWin',9000,@isnumeric);
            addParameter(parseObj,'segmentWelch',1000,@isnumeric);
            addParameter(parseObj,'dftPointsWelch',2^10,@isnumeric);
            addParameter(parseObj,'OLWelch',0.5);
            addParameter(parseObj,'tStart',0,@isnumeric);
            addParameter(parseObj,'win',0,@isnumeric); %if 0 uses the whole recording duration
            addParameter(parseObj,'deltaBandCutoff',4,@isnumeric);
            addParameter(parseObj,'betaBandLowCutoff',10,@isnumeric);
            addParameter(parseObj,'betaBandHighCutoff',40,@isnumeric);
            addParameter(parseObj,'applyNotch',0,@isnumeric);
            addParameter(parseObj,'saveSpectralProfiles',0,@isnumeric);
            addParameter(parseObj,'maxVoltage',1500,@isnumeric);
            addParameter(parseObj,'overwrite',0,@isnumeric);
            addParameter(parseObj,'inputParams',false,@isnumeric);
            parseObj.parse(varargin{:});
            if parseObj.Results.inputParams
                disp(parseObj.Results);
                return;
            end
            
            %evaluate all input parameters in workspace
            for i=1:numel(parseObj.Parameters)
                eval([parseObj.Parameters{i} '=' 'parseObj.Results.(parseObj.Parameters{i});']);
            end
            
            %make parameter structure
            parDBRatio=parseObj.Results;
            
            if isnan(ch)
                disp('Error: no reference channel for Delta 2 Beta extraction');
                return;
            end
            %check if analysis was already done done
            obj.files.dbRatio=[obj.currentAnalysisFolder filesep 'dbRatio_ch' num2str(ch) '.mat'];
            if exist(obj.files.dbRatio,'file') & ~overwrite
                if nargout==1
                    data=load(obj.files.dbRatio);
                else
                    disp('DB analysis already exists for this recording');
                end
                return;
            end
            
            obj.getFilters;
            movWinSamples=movWin/1000*obj.filt.FFs;%obj.filt.FFs in Hz, movWin in samples
            movOLWinSamples=movOLWin/1000*obj.filt.FFs;
            timeBin=(movWin-movOLWin); %ms
            
            segmentWelchSamples = round(segmentWelch/1000*obj.filt.FFs);
            samplesOLWelch = round(segmentWelchSamples*OLWelch);
            
            %run welch once to get frequencies for every bin (f) determine frequency bands
            [~,f] = pwelch(randn(1,movWinSamples),segmentWelchSamples,samplesOLWelch,dftPointsWelch,obj.filt.FFs);
            pfLowBand=find(f<=deltaBandCutoff);
            pfHighBand=find(f>=betaBandLowCutoff & f<betaBandHighCutoff);
            
            %if obj.currentDataObj.recordingDuration_ms<movLongWin
            %    movLongWin=obj.currentDataObj.recordingDuration_ms;
            %end
            
            if win==0
                win=obj.currentDataObj.recordingDuration_ms-tStart;
                endTime=obj.currentDataObj.recordingDuration_ms;
            else
                endTime=min(win+tStart,obj.currentDataObj.recordingDuration_ms);
            end
            startTimes=tStart:(movLongWin-movOLWin):endTime;
            nChunks=numel(startTimes);
            deltaBetaRatioAll=cell(1,nChunks);
            t_ms=cell(1,nChunks);
            %deltaBetaRatioAllLow=cell(1,nChunks);;deltaBetaRatioAllHigh=cell(1,nChunks);
            
            if saveSpectralProfiles
                FMLongB = buffer(true(1,movLongWin/1000*obj.filt.FFs),movWinSamples,movOLWinSamples,'nodelay');
                fftInBuffer=size(FMLongB,2)
                allFreqProfiles=zeros(ceil(dftPointsWelch/2)+1,nChunks*fftInBuffer);
            else
                allFreqProfiles=[];
            end
            if applyNotch
                obj.filt.FN=filterData(obj.currentDataObj.samplingFrequency(1));
                obj.filt.FN.filterDesign='cheby1';
                obj.filt.FN.padding=true;
                obj.filt.FN=obj.filt.FN.designNotch;
            end
            
            fprintf('\nDelta2Beta extraction (%d chunks)-',nChunks);
            for i=1:nChunks
                fprintf('%d,',i);
                MLong=obj.currentDataObj.getData(ch,startTimes(i),movLongWin);
                if applyNotch
                    FMLong=obj.filt.FN.getFilteredData(MLong); %for 50Hz noise
                end
                FMLong=obj.filt.F.getFilteredData(FMLong);
                
                FMLong(FMLong<-maxVoltage | FMLong>maxVoltage)=nan; %remove high voltage movement artifacts
                
                FMLongB = buffer(FMLong,movWinSamples,movOLWinSamples,'nodelay');
                pValid=all(~isnan(FMLongB));
                
                [pxx,f] = pwelch(FMLongB(:,pValid),segmentWelchSamples,samplesOLWelch,dftPointsWelch,obj.filt.FFs);
                
                if saveSpectralProfiles
                    allFreqProfiles(:,(fftInBuffer*(i-1)+find(pValid)))=pxx;
                end
                deltaBetaRatioAll{i}=zeros(1,numel(pValid));
                deltaBetaRatioAll{i}(pValid)=(mean(pxx(pfLowBand,:))./mean(pxx(pfHighBand,:)))';
                
                deltaRatioAll{i}=zeros(1,numel(pValid));
                deltaRatioAll{i}(pValid)=mean(pxx(pfLowBand,:))';
                
                betaRatioAll{i}=zeros(1,numel(pValid));
                betaRatioAll{i}(pValid)=mean(pxx(pfHighBand,:))';
                
                t_ms{i}=startTimes(i)+((movWin/2):timeBin:(movLongWin-movWin/2));
            end
            fprintf('\n');
            deltaBetaRatioAll{end}(t_ms{end}>(endTime-movWin/2))=NaN; 
            deltaRatioAll{end}(t_ms{end}>(endTime-movWin/2))=NaN; 
            betaRatioAll{end}(t_ms{end}>(endTime-movWin/2))=NaN; 
            
            bufferedDelta2BetaRatio=cell2mat(deltaBetaRatioAll);bufferedDelta2BetaRatio=bufferedDelta2BetaRatio(:);
            bufferedDeltaRatio=cell2mat(deltaRatioAll);bufferedDeltaRatio=bufferedDeltaRatio(:);
            bufferedBetaRatio=cell2mat(betaRatioAll);bufferedBetaRatio=bufferedBetaRatio(:);
            
            t_ms=cell2mat(t_ms);
            
            save(obj.files.dbRatio,'t_ms','bufferedDelta2BetaRatio','parDBRatio','bufferedBetaRatio','bufferedDeltaRatio','allFreqProfiles');
        end
        


%%
 function [obj]=getFilters(obj,Fs)
            if nargin==1
                if isempty(obj.currentDataObj)
                    error('Sampling frequency is required as an input');
                else
                    Fs=obj.currentDataObj.samplingFrequency(1);
                    disp(['sampling frequency set to that of current recording:' num2str(Fs) '[Hz]']);
                end
            end
            
            obj.filt.F=filterData(Fs);
            obj.filt.F.downSamplingFactor=Fs/250;
            obj.filt.F=obj.filt.F.designDownSample;
            obj.filt.F.padding=true;
            obj.filt.FFs=obj.filt.F.filteredSamplingFrequency;
            
            obj.filt.DS4Hz=filterData(Fs);
            obj.filt.DS4Hz.downSamplingFactor=Fs/250;
            obj.filt.DS4Hz.lowPassCutoff=4;
            obj.filt.DS4Hz.padding=true;
            obj.filt.DS4Hz=obj.filt.DS4Hz.designDownSample;
            
            obj.filt.FH=filterData(Fs);
            obj.filt.FH.highPassPassCutoff=100;
            obj.filt.FH.highPassStopCutoff=80;
            obj.filt.FH.lowPassPassCutoff=1800;
            obj.filt.FH.lowPassStopCutoff=2000;
            obj.filt.FH.attenuationInLowpass=20;
            obj.filt.FH.attenuationInHighpass=20;
            obj.filt.FH=obj.filt.FH.designBandPass;
            obj.filt.FH.padding=true;

            obj.filt.FHR=filterData(Fs);
            obj.filt.FHR.highPassPassCutoff=60;
            obj.filt.FHR.highPassStopCutoff=50;
            obj.filt.FHR.lowPassPassCutoff=900;
            obj.filt.FHR.lowPassStopCutoff=1000;
            obj.filt.FHR.attenuationInLowpass=20;
            obj.filt.FHR.attenuationInHighpass=40;
            obj.filt.FHR=obj.filt.FHR.designBandPass;
            obj.filt.FHR.padding=true;
            
            obj.filt.FL=filterData(Fs);
            obj.filt.FL.lowPassPassCutoff=4.5;
            obj.filt.FL.lowPassStopCutoff=6;
            obj.filt.FL.attenuationInLowpass=20;
            obj.filt.FL=obj.filt.FL.designLowPass;
            obj.filt.FL.padding=true;
            
            obj.filt.FH2=filterData(Fs);
            obj.filt.FH2.highPassCutoff=100;
            obj.filt.FH2.lowPassCutoff=2000;
            obj.filt.FH2.filterDesign='butter';
            obj.filt.FH2=obj.filt.FH2.designBandPass;
            obj.filt.FH2.padding=true;
 end
        

 function [data]=FreqBandDetectionSleepObject(obj)
 
 Fs = obj.samplingFrequency;

 %% Filters
 fObj = filterData(Fs); 
 fobj.filt.F=filterData(Fs);
 fobj.filt.F.downSamplingFactor=120; % original is 128 for 32k
 fobj.filt.F=fobj.filt.F.designDownSample;
 fobj.filt.F.padding=true;
 fobj.filt.FFs=fobj.filt.F.filteredSamplingFrequency;
 
 fobj.filt.FL=filterData(Fs);
 fobj.filt.FL.lowPassPassCutoff=30;% this captures the LF pretty well for detection
 fobj.filt.FL.lowPassStopCutoff=40;
 fobj.filt.FL.attenuationInLowpass=20;
 fobj.filt.FL=fobj.filt.FL.designLowPass;
 fobj.filt.FL.padding=true;
 
 %fobj.filt.FL=filterData(Fs);
 %fobj.filt.FL.lowPassPassCutoff=4.5;
 %fobj.filt.FL.lowPassStopCutoff=6;
 %fobj.filt.FL.attenuationInLowpass=20;
 %fobj.filt.FL=fobj.filt.FL.designLowPass;
 %fobj.filt.FL.padding=true;
 
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
 
 %% Parameters
 win = 8*60*60*1000; %ms
 binDuration = 5000; %ms
 ch = 15;
 tStart = 3*60*60*1000;
 segmentLength = 1000; %ms
 WelchOL = 0.5;
 dftPoints = 2^10;
 remove50HzArtifcats =1;
 fMax = 35;
 maxDendroClusters = 2;
 
 %%
 win=floor(win/binDuration)*binDuration; %making win an integer number of segment length
 MLong=obj.getData(ch,tStart,win); % cecause of this, we have to us ms
 
 %filter data
 FMLong=fobj.filt.F.getFilteredData(MLong);
 if remove50HzArtifcats
     fobj.filt.notch=filterData(fobj.filt.F.filteredSamplingFrequency);
     fobj.filt.notch.filterDesign='cheby1';
     fobj.filt.notch=fobj.filt.notch.designNotch;
     fobj.filt.notch.padding=true;
     FMLong=fobj.filt.notch.getFilteredData(FMLong);
 end
 
 figure; plot(squeeze(FMLong(1:500)))
 times=(tStart+binDuration/2):binDuration:(tStart+win);
 
 %calculate initial parameters
 segmentSamples = round(segmentLength/1000*fobj.filt.FFs);
 samplesOL = round(segmentSamples*WelchOL);
 samplesBin = binDuration/1000*fobj.filt.FFs;
 
 nBins=numel(FMLong)/samplesBin;
 
 FMLongB=reshape(FMLong,[samplesBin,nBins]);
 
 if (numel(FMLong)/samplesBin)~=round(numel(FMLong)/samplesBin)
     nBins=nBins-1;
     FMLong=FMLong(1:(samplesBin*nBins));
     disp('Last bin in recording not included due to a missmatch between recording duration and binDuration');
 end
 
 [pxx,f] = pwelch(FMLongB,segmentSamples,samplesOL,dftPoints,fobj.filt.FFs);
 
 figure;
 plot(10*log10(pxx(1:100)))
 xlim([0 30])
 p=find(f<fMax);
 
 pp=find(sum(pxx(p,:))<0.4e6); %reject signals with very high amplitudes (probably noise)
 
 sPxx=pxx(p,pp);
 freqHz=f(p);
 normsPxx=bsxfun(@rdivide,sPxx,mean(sPxx,2));
 corrMat=corrcoef(normsPxx);
 times=times(pp);
 
 if maxDendroClusters==2
     
     [DC,order,clusters]=DendrogramMatrix(corrMat,'linkMetric','euclidean','linkMethod','ward','maxClusters',maxDendroClusters);
     
     S1=mean(normsPxx(:,clusters==1),2);
     S2=mean(normsPxx(:,clusters==2),2);
     if mean(S1(1:3))>mean(S2(1:3))
         crossFreq=freqHz(find(S2-S1>=0,1,'first'));
     else
         crossFreq=freqHz(find(S1-S2>=0,1,'first'));
     end
 else
     [DC,order,clusters]=DendrogramMatrix(corrMat,'linkMetric','euclidean','linkMethod','ward','maxClusters',maxDendroClusters);
     
     for i=1:maxDendroClusters
         S(:,i)=mean(normsPxx(:,clusters==i),2);
     end
     crossFreq=[];
 end
 
 %% Plotting
 
 if plotDendrogram
     % maxDendroClusters=parFreqBandDetection.maxDendroClusters;
     cLim = 0;
     hDendro = 0;
     
     if cLim==0
         cLim=[];
     end
     if hDendro==0
         hDendro=[];
     else
         savePlots=[];
     end
     [DC,order,clusters,h]=DendrogramMatrix(corrMat,'linkMetric','euclidean','linkMethod','ward','maxClusters',maxDendroClusters,...
         'toPlotBinaryTree',1,'cLim',cLim,'hDendro',hDendro,'plotOrderLabels',0);
     %h(3).Position=[0.9149    0.7595    0.0137    0.1667];
     ylabel(h(3),'Corr.');
     xlabel(h(2),'Segment');
     xlabel(h(1),'Distance');
 end
 
 
 if plotSpectralBands
     hSpectra = 0;
     
     if hSpectra==0
         fTmp=figure('position',[680   678   658   420]);
         hTmp=axes;
         h=[h hTmp];
     else
         axes(hSpectra);
         h=[h hSpectra];
         savePlots=0;
     end
     for i=1:maxDendroClusters
         PS=mean(normsPxx(:,clusters==i),2);
         plot(freqHz,PS,'lineWidth',2);hold on;
     end
     if ~isempty(crossFreq)
         plot(crossFreq,PS(crossFreq==freqHz),'ok','MarkerSize',8,'LineWidth',2);
         text(crossFreq+(diff(xlim))*0.15,PS(crossFreq==freqHz),'F_{trans.}');
     end
     xlabel('Frequency (Hz)');
     ylabel('nPSD');
     xlim([0 fMax]);
     
     %                 if savePlots
     %                     set(fTmp,'PaperPositionMode','auto');
     %                     fileName=[obj.currentPlotFolder filesep 'spectralBands_ch' num2str(parFreqBandDetection.ch) '_t' num2str(parFreqBandDetection.tStart) '_w' num2str(parFreqBandDetection.win)];
     %                     print(fileName,'-djpeg',['-r' num2str(obj.figResJPG)]);
     %                     if printLocalCopy
     %                         fileName=[cd filesep obj.recTable.Animal{obj.currentPRec} '_Rec' num2str(obj.currentPRec) '_spectralBands_ch' num2str(parFreqBandDetection.ch) '_t' num2str(parFreqBandDetection.tStart) '_w' num2str(parFreqBandDetection.win)];
     %                         print(fileName,'-djpeg',['-r' num2str(obj.figResJPG)]);
     %                     end
     %                 end
     
 end
 
 save(obj.files.spectralClustering,'times','corrMat','sPxx','normsPxx','freqHz','parFreqBandDetection','order','clusters','crossFreq');
 
 end
   