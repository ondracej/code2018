function []=postProcessingNSK(dataRecordingObj,selectedChannels,fileNames,varargin)
%default variables
plotSortedFilteredSpikes=1;
preFilteredSpike=2;
windowFilteredSpike=5;

plotSortedRawSpikes=1;
preRawSpike=10;
windowRawSpike=90;

%print out default arguments and values if no inputs are given
if nargin==0
    defaultArguments=who;
    for i=1:numel(defaultArguments)
        eval(['defaultArgumentValue=' defaultArguments{i} ';']);
        disp([defaultArguments{i} ' = ' num2str(defaultArgumentValue)]);
    end
    return;
end

%Collects all options
for i=1:2:length(varargin)
    eval([varargin{i} '=' 'varargin{i+1};']);
end

nSelectedChannels=numel(selectedChannels);

if isempty(sortingDir)
    writeDataToFile=false;
else
    if nargout>0
        error('No output variables are allowed in save data to disk option')
    end
    writeDataToFile=true;
end

fprintf('\nPost processing spikes...');
load(fileNames.mergedAvgWaveformFile,'avgWF','stdWF','ch','mergedNeurons');

nNeurons=numel(mergedNeurons);

En=dataRecordingObj.chLayoutNumbers;
[nSamples]=size(avgWF{1},1);

allWaveforms=nan(nSamples,nNeurons,nSelectedChannels);
counter=1;
for i=1:nSelectedChannels
    nTmpNeurons=size(avgWF{i},2);
    allWaveforms(:,counter:(counter+nTmpNeurons-1),ch{i})=avgWF{i};
    counter=counter+nTmpNeurons;
end
f=figure;
[h,hParent]=spikeDensityPlotPhysicalSpace([],upSamplingFrequency,selectedChannels,En,...
    'hParent',f,'avgSpikeWaveforms',allWaveforms,'logDensity',true);


highPassPassCutoff=200;
highPassStopCutoff=190;
lowPassPassCutoff=5000;
lowPassStopCutoff=5100;
attenuationInHighpass=4;
attenuationInLowpass=4;
%construct filtering object
Fs=dataRecordingObj.samplingFrequency;
FilterObj=filterData(Fs);
FilterObj.highPassPassCutoff=highPassPassCutoff;
FilterObj.highPassStopCutoff=highPassStopCutoff;
FilterObj.lowPassPassCutoff=lowPassPassCutoff;
FilterObj.lowPassStopCutoff=lowPassStopCutoff;
FilterObj.attenuationInHighpass=attenuationInHighpass;
FilterObj.attenuationInLowpass=attenuationInLowpass;
FilterObj=FilterObj.designBandPass;

load(fileNames.fittingFile,'t','ic');

if plotSortedRawSpikes
    for i=1:nNeurons
        f=figure;
        tTmp=t(ic(3,i):ic(4,i));
        [V_uV,T_ms]=dataRecordingObj.getData(dataRecordingObj.channelNumbers,tTmp(1:80)-preRawSpike,windowRawSpike);
        
        [h,hParent]=spikeDensityPlotPhysicalSpace(permute(V_uV,[3 2 1]),dataRecordingObj.samplingFrequency,selectedChannels,En,...
            'hParent',f,'avgSpikeWaveforms',allWaveforms(2:3:end,i,:),'logDensity',true);
    end
end

if plotSortedFilteredSpikes
    for i=1:nNeurons
        f=figure;
        tTmp=t(ic(3,i):ic(4,i));
        [V_uV,T_ms]=FilterObj.getFilteredData(dataRecordingObj.getData(dataRecordingObj.channelNumbers,tTmp(1:80)-preFilteredSpike,windowFilteredSpike));
        
        [h,hParent]=spikeDensityPlotPhysicalSpace(permute(V_uV,[3 2 1]),dataRecordingObj.samplingFrequency,selectedChannels,En,...
            'hParent',f,'avgSpikeWaveforms',allWaveforms(2:3:end,i,:),'logDensity',true);
    end
end









%Plots for testing
%{
load layout_40_Hexa;En=flipud(En);
p=cellfun(@(x) size(x,2),avgWF);
pV=find(p>0);
nPlots=ceil(sqrt(sum(p)));
c=1;
for i=1:numel(pV)
    for j=1:p(pV(i))
        h=subaxis(nPlots,nPlots,c,'S',0.03,'M',0.03);
        activityTracePhysicalSpacePlot(h,ch{pV(i)},0.03*squeeze(avgWF{pV(i)}(:,j,:))',En,'scaling','none');
        title([num2str(pV(i)) '-' num2str(j)]);
        c=c+1;
    end
end
%}
