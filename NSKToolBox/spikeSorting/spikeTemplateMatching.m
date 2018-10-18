function [t,ic]=spikeTemplateMatching(dataRecordingObj,spikeTemplates,varargin)
%parameters
saveFigures=1;
plotClassification=1;

upSamplingFactor=5;
selectedChannels=[];
Fs=dataRecordingObj.samplingFrequency; %get sampling frequency

%Collects all options
for i=1:2:length(varargin)
    eval([varargin{i} '=' 'varargin{i+1};'])
end
tic;

%determine channels
if isempty(selectedChannels)
    selectedChannels=dataRecordingObj.channelNumbers; %take all channel in the recording
end
%make directory in recording folder with spike sorting data
[pathstr, name, ext] = fileparts(dataRecordingObj.recordingName);
sortingDir=[dataRecordingObj.recordingDir '\' name '_spikeSort'];
if  plotClassification
    mkdir(sortingDir);
end
%sort spikes
t=[];
ic=[];
for i=1:numel(selectedChannels) %go over all channels in the recording
    disp(['ch' num2str(selectedChannels(i))]);
    spikeShapeFile=[sortingDir '\ch_' num2str(selectedChannels(i)) '_spikeShapes.mat'];
    load(spikeShapeFile);
    
    [nSpikeSamples,nSpikes]=size(spikeShapes);
    nClusters=size(spikeTemplates{i},1);
    
    match=zeros(nClusters,nSpikes);
    for j=1:nClusters
        match(j,:)=sum(bsxfun(@minus,spikeShapes,spikeTemplates{i}(j,:)').^2);
    end
    [~,idxOut]=min(match,[],1);
    
    %generate t,ic file
    if nargout>0
        for j=1:nClusters
            position=numel(t);
            t=[t spikeTimes(idxOut==j)];
            ic=[ic [selectedChannels(i);j;position+1;numel(t)]];
        end
    end

    if plotClassification
        
        featureExtractionFile=[sortingDir '\ch_' num2str(selectedChannels(i)) '_featureExtraction.mat'];
        load(featureExtractionFile);
        [PCAFeatureSimMat,PCAspikeFeatures] = princomp(spikeFeatures); %run PCA for visualization purposes
        
        %recalculate centers
        cent=[];
        for k=1:nClusters
            cent(k,:)=mean(PCAspikeFeatures(idxOut(pSpikes4Clustering)==k,1:2));
        end
        
        f=figure('Position',[100 100 1000 400]);
        cmap=colormap('Lines');
        set(f,'DefaultAxesColorOrder',cmap);
        
        h1=subplot(1,2,1);
        
        h1s=scatter(PCAspikeFeatures(:,1),PCAspikeFeatures(:,2),2,cmap(idxOut(pSpikes4Clustering),:));
        text(cent(:,1),cent(:,2),mat2cell(1:nClusters,1,ones(1,nClusters)),'FontWeight','Bold');
        xlabel('PCA 1');
        ylabel('PCA 2');
        freezeColors(h1s);
        
        h2=subplot(1,2,2);
        sampleTimes=(1000*(1:nSpikeSamples)/Fs/upSamplingFactor)';
        [D,h,cb]=hist2(sampleTimes*ones(1,nSpikes),spikeShapes,'c1',sampleTimes,'n2',100,'h',h2);
        xlabel('Time [ms]');
        ylabel('Voltage [\muV]');
        hold on;
        
        plot(sampleTimes,spikeTemplates{i}');
        
        Pos=get(h2,'position');
        set(cb,'Position',[0.915 Pos(2) 0.01 Pos(4)]);
        
        if saveFigures
            set(f,'PaperPositionMode','auto');
            print([sortingDir '\Ch_' num2str(selectedChannels(i)) 'classification'],'-djpeg','-r300');
            close(f);
        end
    end
end
toc