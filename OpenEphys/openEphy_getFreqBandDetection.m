function [] = openEphy_getFreqBandDetection()
dbstop if error
close all

addpath(genpath('/home/janie/Code/analysis-tools-master/'));
addpath(genpath('/home/janie/Code/MPI/NSKToolBox/'));
dirD = '/';

%fileName = '/home/janie/Data/SleepChicken/chick2_2018-04-30_17-29-04/100_CH1.continuous';

%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_15-19-16/100_CH1.continuous';
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_15-41-19/100_CH1.continuous';
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_16-03-12/100_CH1.continuous';
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_16-30-56/100_CH1.continuous'; %long, 1800s
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-05-32/100_CH1.continuous';
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-05-32/100_CH1.continuous'; %good one, 1200
fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-29-04/100_CH1.continuous'; %good one, 1200 s
%fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-56-36/100_CH1.continuous';% 1200s


[pathstr,name,ext] = fileparts(fileName);

bla = find(fileName == dirD);

dataName = fileName(bla(end-1)+1:bla(end)-1);
saveName = [pathstr dirD dataName '-freqSpec'];

[data, timestamps, info] = load_open_ephys_data(fileName);

%%

Fs = info.header.sampleRate;

fObj = filterData(Fs);

%obj = sleepAnalysis;
%obj=obj.getFilters(Fs);

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

%function [data]=getFreqBandDetection(obj,varargin)
%obj.checkFileRecording;

%parseObj = inputParser;
%addParameter(parseObj,'ch',obj.par.DVRLFPCh{obj.currentPRec},@isnumeric);
%addParameter(parseObj,'fMax',30,@isnumeric); %max freq. to examine
fMax = 30;
%addParameter(parseObj,'dftPoints',2^10,@isnumeric);
dftPoints = 2^10';
%addParameter(parseObj,'tStart',0,@isnumeric);
tStart = 0;
%addParameter(parseObj,'win',1000*60*60,@isnumeric);
win = 1000*60*60;
%addParameter(parseObj,'maxDendroClusters',2,@isnumeric);
maxDendroClusters = 2;

%addParameter(parseObj,'saveFile',[]);
%addParameter(parseObj,'overwrite',0,@isnumeric);
%addParameter(parseObj,'segmentLength',1000);
segmentLength = 1000;
%addParameter(parseObj,'WelchOL',0.5);
WelchOL = 0.5;
%addParameter(parseObj,'binDuration',10000);
binDuration = 10000;


 %addParameter(parseObj,'cLim',0);
 cLim = 0;
 hDendro = 0;
 hSpectra = 0;
 
 %           addParameter(parseObj,'hDendro',0);
 %           addParameter(parseObj,'hSpectra',0);
            
            
%addParameter(parseObj,'inputParams',false,@isnumeric);
%parseObj.parse(varargin{:});
%if parseObj.Results.inputParams
%    disp(parseObj.Results);
%    return;
%end

%evaluate all input parameters in workspace
%for i=1:numel(parseObj.Parameters)
%    eval([parseObj.Parameters{i} '=' 'parseObj.Results.(parseObj.Parameters{i});']);
%end

%make parameter structure
%parFreqBandDetection=parseObj.Results;

%check if analysis was already done done
%if isempty(saveFile)
%    obj.files.spectralClustering=[obj.currentAnalysisFolder filesep 'spectalClustering_ch' num2str(ch) '.mat'];
%else
%    obj.files.spectralClustering=[saveFile '.mat'];
%end

%if exist(obj.files.spectralClustering,'file') & ~overwrite
%    if nargout==1
%        data=load(obj.files.spectralClustering);
%    else
%        disp('Spectral clustering analysis already exists for this recording');
%    end
%    return;
%end

%MLong=obj.currentDataObj.getData(ch,tStart,win);
%MLong=obj.filt.FJLB.getFilteredData(MLong); % JO bandpassFilter
FMLong=fobj.filt.F.getFilteredData(thisSegData );


%calculate initial parameters
segmentSamples = round(segmentLength/1000*fobj.filt.FFs);
samplesOL = round(segmentSamples*WelchOL);
samplesBin = round(binDuration/1000*fobj.filt.FFs);

nBins=floor(numel(FMLong)/samplesBin);

if (numel(FMLong)/samplesBin)~=round(numel(FMLong)/samplesBin)
    nBins=nBins-1;
    FMLong=FMLong(1:(samplesBin*nBins));
    disp('Last bin in recording not included due to a missmatch between recording duration and binDuration');
end

FMLongB=reshape(FMLong,[samplesBin,nBins]);

[pxx,f] = pwelch(FMLongB,segmentSamples,samplesOL,dftPoints,fobj.filt.FFs);
%plot(10*log10(pxx))
p=find(f<fMax);
pp=find(sum(pxx(p,:))<0.4e6);

sPxx=pxx(p,pp);
freqHz=f(p);
normsPxx=bsxfun(@rdivide,sPxx,mean(sPxx,2));
corrMat=corrcoef(normsPxx);

if maxDendroClusters==2
    
    [DC,order,clusters]=DendrogramMatrix(corrMat,'linkMetric','euclidean','linkMethod','ward','maxClusters',maxDendroClusters);
    
    S1=mean(normsPxx(:,clusters==1),2);
    S2=mean(normsPxx(:,clusters==2),2);
    if mean(S1(1:3))>mean(S2(1:3))
        crossFreq=freqHz(find(S2-S1>=0,1,'first'))
    else
        crossFreq=freqHz(find(S1-S2>=0,1,'first'))
        %crossFreq=freqHz(find(S2-S1>=0,1,'first'));
    end
else
    crossFreq=[];order=[];clusters=[];
end

plotDendrogram =1;

if plotDendrogram
    maxDendroClusters=2;
    
    if cLim==0
        cLim=[];
    end
    
    if hDendro==0
        hDendro=[];
    else
        savePlots=[];
    end
    figh3 = figure(100); clf
    
    [DC,order,clusters,h]=DendrogramMatrix(corrMat,'linkMetric','euclidean','linkMethod','ward','maxClusters',maxDendroClusters,...
        'toPlotBinaryTree',1,'cLim',cLim,'hDendro',hDendro,'plotOrderLabels',0);
    %h(3).Position=[0.9149    0.7595    0.0137    0.1667];
    ylabel(h(3),'Corr.');
    xlabel(h(2),'Segment');
    xlabel(h(1),'Distance');
    
    
%     if savePlots
%         set(gcf,'PaperPositionMode','auto');
%         %fileName=[obj.currentPlotFolder filesep 'dendrogram_ch' num2str(parFreqBandDetection.ch) '_t' num2str(parFreqBandDetection.tStart) '_w' num2str(parFreqBandDetection.win)];
%         fileName=[obj.currentPlotFolder filesep 'dendrogram_ch' num2str(parFreqBandDetection.ch) '_t' num2str(round(parFreqBandDetection.tStart)) '_w' num2str(round(parFreqBandDetection.win))];
%         print(fileName,'-djpeg',['-r' num2str(obj.figResJPG)]);
%         print(fileName,'-depsc',['-r' num2str(obj.figResEPS)]);
%         if printLocalCopy
%             fileName=[cd filesep obj.par.Animal{obj.currentPRec} '_Rec' num2str(obj.currentPRec) '_dendrogram_ch' num2str(parFreqBandDetection.ch) '_t' num2str(parFreqBandDetection.tStart) '_w' num2str(parFreqBandDetection.win)];
%             print(fileName,'-djpeg',['-r' num2str(obj.figResJPG)]);
%             print(fileName,'-depsc',['-r' num2str(obj.figResEPS)]);
%         end
%     end


plotpos = [0 0 25 15];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);


end


            
end
