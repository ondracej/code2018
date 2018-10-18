function [idx,initIdx,nClusters,avgSpikeWaveforms,stdSpikeWaveforms]=spikeClusteringNSK(dataRecordingObj,chPar,fileNames,varargin)

%default variables
sortingDir=[];
clusteringMethod='meanShift';%'meanShift';%'kMeans';%,'kMeans_MSEdistance';%'kMeans_merge';%'kMeans_merge'; %'kMeans_sil'/'kMeans_merge'/'GMMEM'
mergingMethod='projectionMeanStd';%'projectionMeanStd';%'MSEdistance'
maxIter=1000; %max itteration for clustering algorithm
replicates=50; %number of replicates in clustering algorithm
initialClusterCentersMethod='cluster'; %method for initial conditions in k-means algorithm
maxNumberOfPointsInSilhoutte=1000; %the maximal number of data points per cluster used for silloute quality estimation
mergeThreshold=0.18; %threshold for merging clusters %the higher the threshold the less cluster will merge
stdMergeFac=2; %the fraction of a gaussian to check from the crossing point on both sides (the higher the more clusters separate into groups)
runSecondMerging=0;
maxClusters=12; %the maximum number of clusters for a specific channels

minimumChannelRate=0.01; %[Hz]
minSpikesCluster=10;
minSpikesTotal=50; %do not attempt to cluster channels with less spikes

saveFigures=1;
plotProjection=1;
plotClassification=1;
fastPrinting=0;

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
    eval([varargin{i} '=' 'varargin{i+1};'])
end

nCh=numel(chPar.s2r);
avgClusteredWaveforms=cell(1,nCh);
stdClusteredWaveforms=cell(1,nCh);

if isempty(sortingDir)
    writeDataToFile=false;
    idxAll=cell(1,nCh);
    initIdxAll=cell(1,nCh);
    nClustersAll=cell(1,nCh);
else
    if nargout>0
        error('No output variables are allowed in save data to disk option')
    end
    writeDataToFile=true;
end

fprintf('\nClustering on channel (total %d): ',nCh);
for i=find(fileNames.clusteringExist==0) %go over all channels in the recording
    fprintf('%d ',i);
    maxClustersTmp=maxClusters;
    
    if ~exist(fileNames.featureExtractionFile{i},'file')
        warning(['No feature extraction file was found for Channel ' num2str(i) '. Clustering not performed!']);
        continue;
    else
        load(fileNames.featureExtractionFile{i});
        load(fileNames.spikeDetectionFile{i},'spikeTimes');
    end
    
    [nSpikes,nFeatures]=size(spikeFeatures);
    
    if nSpikes >= minSpikesTotal && nSpikes >= (spikeTimes(end)-spikeTimes(1))/1000*minimumChannelRate
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%  Clustering %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        switch clusteringMethod
            case 'kMeans'
                % set options to k-Means
                opts = statset('MaxIter',maxIter);
                try
                    [initIdx] = kmeans(spikeFeatures,maxClusters,'options',opts,...
                        'emptyaction','singleton','distance','city','onlinephase','on','replicates',replicates,'start',initialClusterCentersMethod);
                catch %if the number of samples is too low, kmeans gives an error -> try kmeans with a lower number of clusters
                    maxClustersTmp=round(maxClusters/2);
                    [initIdx] = kmeans(spikeFeatures,maxClustersTmp,'options',opts,...
                        'emptyaction','singleton','distance','city','onlinephase','on','replicates',replicates,'start',initialClusterCentersMethod);
                end
            case 'meanShift'
                initIdx=zeros(nSpikes,1);
                out=MSAMSClustering(spikeFeatures');
                for j=1:numel(out)
                    initIdx(out{j})=j;
                end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%  Merging %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        switch mergingMethod
            case 'MSEdistance'
                %calculate templates
                load(fileNames.spikeDetectionFile{i},'spikeShapes');
                avgSpikeWaveforms=zeros(nSpikeSamples,max(1,maxClustersTmp),nSurroundingChannels);
                for j=1:maxClustersTmp
                    avgSpikeWaveforms(:,j,:)=median(spikes4Clustering(:,initIdx==j,:),2);
                end
                
                [gc,Merge]=SpikeTempDiffMerging(permute(spikes4Clustering,[2 1 3]),initIdx,permute(avgSpikeWaveforms,[3 1 2]));
                
                if saveFigures
                    f1=figure('Position',[50 50 1400 900]);
                    set(f1,'PaperPositionMode','auto');
                    if fastPrinting
                        imwrite(frame2im(getframe(f1)),[sortingDir filesep 'Ch_' num2str(chPar.s2r(i)) 'projectionTest.jpeg'],'Quality',90);
                    else
                        print([sortingDir filesep 'Ch_' num2str(chPar.s2r(i)) 'projectionTest'],'-djpeg','-r300');
                    end
                    close(f1);
                end
                
            case 'projectionMeanStd'
                [gc,f1]=projectionMerge(spikeFeatures,initIdx,'minSpikesCluster',minSpikesCluster,'stdMergeFac',stdMergeFac,'mergeThreshold',mergeThreshold,'plotProjection',plotProjection);
                
                if saveFigures && ~isempty(f1);
                    set(f1,'PaperPositionMode','auto');
                    if fastPrinting
                        imwrite(frame2im(getframe(f1)),[sortingDir filesep 'Ch_' num2str(chPar.s2r(i)) 'projectionTest.jpeg'],'Quality',90);
                    else
                        print([sortingDir filesep 'Ch_' num2str(chPar.s2r(i)) 'projectionTest'],'-djpeg','-r300');
                    end
                    close(f1);
                end
                
                if runSecondMerging
                    uniqueClusters=unique(gc);
                    nClusters=numel(uniqueClusters);
                    idx=zeros(nSpikes4Clustering,1);
                    for k=1:nClusters
                        p=find(gc==uniqueClusters(k));
                        for j=1:numel(p)
                            idx(initIdx==p(j))=k;
                        end
                    end
                    maxClustersTmp=nClusters;
                    initIdx=idx;
                    
                    [gc,f1]=projectionMerge(spikeFeatures,initIdx,'minSpikesCluster',minSpikesCluster,'stdMergeFac',stdMergeFac,'mergeThreshold',mergeThreshold,'plotProjection',plotProjection);
                    
                    if saveFigures
                        set(f1,'PaperPositionMode','auto');
                        if fastPrinting
                            imwrite(frame2im(getframe(f1)),[sortingDir '\Ch_' num2str(chPar.s2r(i)) 'projectionTest.jpeg'],'Quality',90);
                        else
                            print([sortingDir '\Ch_' num2str(chPar.s2r(i)) 'projectionTest'],'-djpeg','-r300');
                        end
                        close(f1);
                    end
                end
        end
        
        %reclassify clusters
        uniqueClusters=unique(gc);
        nClusters=numel(uniqueClusters);
        idx=zeros(nSpikes,1);
        for k=1:nClusters
            p=find(gc==uniqueClusters(k));
            for j=1:numel(p)
                idx(initIdx==p(j))=k;
            end
        end
        
        %calculate spikeShape statistics
        load(fileNames.spikeDetectionFile{i},'spikeShapes','int2uV');
        spikeShapes=double(spikeShapes) .* int2uV;
        
        [nSpikeSamples,nSpikes,nSurroundingChannels]=size(spikeShapes);
        if nSpikes>maxSpikesToCluster
            spikeShapes=spikeShapes(:,1:maxSpikesToCluster,:);
        end
        
        avgSpikeWaveforms=zeros(nSpikeSamples,max(1,nClusters),nSurroundingChannels);
        stdSpikeWaveforms=zeros(nSpikeSamples,max(1,nClusters),nSurroundingChannels);
        for j=1:nClusters
            pCluster=idx==j;
            avgSpikeWaveforms(:,j,:)=median(spikeShapes(:,pCluster,:),2);
            stdSpikeWaveforms(:,j,:)=1.4826*median(abs(spikeShapes(:,pCluster,:)- bsxfun(@times,avgSpikeWaveforms(:,j,:),ones(1,sum(pCluster),1)) ),2);
            nSpk(j)=numel(pCluster);
        end
    else
        fprintf('X '); %to note than no neurons were detected on this electrode
        
        idx=ones(nSpikes,1);
        initIdx=ones(nSpikes,1);
        avgSpikeWaveforms=[];
        stdSpikeWaveforms=[];
        nClusters=0;
        nSpk=0;
    end
    
    avgClusteredWaveforms{i}=avgSpikeWaveforms;
    stdClusteredWaveforms{i}=stdSpikeWaveforms;
    nAvgSpk{i}=nSpk;
    
    if writeDataToFile
        save(fileNames.clusteringFile{i},'idx','initIdx','nClusters','avgSpikeWaveforms','stdSpikeWaveforms');
    else
        idxAll{i}=idx;
        initIdxAll{i}=initIdx;
        nClustersAll{i}=nClusters;
    end    
    
    if plotClassification && nClusters>0
        
        cmap=lines;
        
        f2=figure('Position',[100 100 1200 800],'color','w');
        PCAfeaturesSpikeShapePlot(spikeFeatures,spikeShapes,upSamplingFrequency,initIdx,idx,chPar.En,chPar.s2r(chPar.surChExtVec{i}),'hFigure',f2,'cmap',cmap);
        
        f3=figure('Position',[100 100 1200 800],'color','w');
        featureSubSpacePlot(spikeFeatures,idx,'hFigure',f3,'cmap',cmap);
        
        if saveFigures
            figure(f2);
            set(f2,'PaperPositionMode','auto');
            if fastPrinting
                imwrite(frame2im(getframe(f2)),[sortingDir '\Ch_' num2str(chPar.s2r(i)) 'classification.jpeg'],'Quality',90);
            else
                print([sortingDir '\Ch_' num2str(chPar.s2r(i)) 'classification'],'-djpeg','-r300');
            end
            
            figure(f3);
            set(f3,'PaperPositionMode','auto');
            if fastPrinting
                imwrite(frame2im(getframe(f3)),[sortingDir '\Ch_' num2str(chPar.s2r(i)) 'featureSpace.jpeg'],'Quality',90);
            else
                print([sortingDir '\Ch_' num2str(chPar.s2r(i)) 'featureSpace'],'-djpeg','-r300');
            end
            if ishandle(f2)
                close(f2);
            end
            if ishandle(f3)
                close(f3);
            end
        end
    end %plot initial classification classification 
end %go over all channels

if writeDataToFile
    save(fileNames.avgWaveformFile,'avgClusteredWaveforms','stdClusteredWaveforms','nAvgSpk');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Additional functions  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function p=projectionND(v,d)
%Calculate projection between a vector and a set of dots in multi dimensional space
%v = [1 x N] - vector
%d = [M X N] - M dot locations

%calculate the cos angle between vector and dots
cosAng=v*d'./(sqrt(sum(v.^2))*sqrt(sum(d'.^2)));
p=cosAng.*sqrt(sum(d'.^2));

function [clusterMerged,Merge]=SpikeTempDiffMerging(spikeShapes,Clusters,Templates,crit)
%merge clusters in a group that have to be merge based on the residuals
%between spikes and templates.
%synthax : [clusterMerged,Merge]=SpikeTempDiffMerging(spikeShapes,Clusters,Templates,crit)
%input:
%           - spikeShapes : all the spikeShapes Nspikes-sizeSpike-NbChannels
%           - Clusters : vector containing the index of spikes in spikeShapes
%           - Templates : The templates corresponding to the clusters
%           nChannels-sizeTemplate-nTemplates
%           - crit : the value of the threshold to merge clusters(default value : 1.5)
%output :
%           - clusterMerged:vector of symbolic merging
%           - Merge : binary symmetric merging decision matrix
%           nclust-nclust.
if nargin<4
    crit=1.5;
end
numClust=size(Templates,3);
clusterMerged=1:numClust; % a group is assigned to every cluster
%build ajacent matrix of clusters
Merge=zeros(numClust,numClust);
for i=1:numClust
    for j=1:numClust
        if j~=i
            clSel=find(Clusters==i);
            cTmp1=Templates(:,:,i)';
            cTmp2=Templates(:,:,j)';
            diffSpikeTemp1=zeros(1,length(clSel));diffSpikeTemp2=zeros(1,length(clSel));
            for k=1:length(clSel)
                cSpike=reshape(spikeShapes(clSel(k),:,:),size(spikeShapes,2),size(spikeShapes,3));
                diffSpikeTemp1(k)=sum((cTmp1(:)-cSpike(:)).^2);
                diffSpikeTemp2(k)=sum((cTmp2(:)-cSpike(:)).^2);
            end
            Merge(i,j)=median(diffSpikeTemp2)/median(diffSpikeTemp1);
        end
    end
end

%Symetrize matrix
for k=1:numClust
    for m=k+1:numClust
        if Merge(k,m)<crit &&Merge(m,k)<crit
            Merge(k,m)=1;Merge(m,k)=1;
            clusterMerged(clusterMerged==k)=clusterMerged(m);
        else
            Merge(k,m)=0;Merge(m,k)=0;
        end
    end
end

function [gc,f]=projectionMerge(spikeFeatures,initIdx,varargin)
%merge clusters in a group that have to be merge based on the residuals
%between spikes and templates.
%synthax : [gc,f]=projectionMerge(spikeFeatures,initIdx,varargin)
%input:
%           - spikeFeatures : spike features ()
%           - initIdx : the clusters index of every spike
%               vararin - 'property','value'
%output :
%           - gc: a binary matrix with ones indicating a necessary merge
%           - f: a figure handle for the generated plot

%default variables
minSpikesCluster=10;
stdMergeFac=2;
mergeThreshold=0.18;
plotProjection=1;

%Collects all options
for i=1:2:length(varargin)
    eval([varargin{i} '=' 'varargin{i+1};'])
end

%find robust cluster centers
nClustersIn=numel(unique(initIdx));
for k=1:nClustersIn
    cent(k,:)=median(spikeFeatures(initIdx==k,:));
end

if  nClustersIn<=1
    gc=1;
    f=[];
    return;
end

if plotProjection
    f=figure('Position',[50 50 1400 900]);
else
    f=[];
end

D=zeros(nClustersIn);
groups=mat2cell(1:nClustersIn,1,ones(1,nClustersIn));
gc=1:nClustersIn; % a group is assigned to every cluster
for k=2:nClustersIn
    for m=1:k-1
        v=(cent(k,:)-cent(m,:));
        p1=projectionND(v,spikeFeatures(initIdx==k,:));
        p2=projectionND(v,spikeFeatures(initIdx==m,:));
        
        pCent=projectionND(v,[cent(k,:);cent(m,:)]);%for plotting purpuses
        
        if numel(p1)<minSpikesCluster || numel(p2)<minSpikesCluster
            D(k,m)=0;
            std_p1=[];
            std_p2=[];
            v=[];
        else
            
            mp1=median(p1);
            mp2=median(p2);
            
            std_p1=median(abs(  p1-mp1  ),2) / 0.6745;
            std_p2=median(abs(  p2-mp2  ),2) / 0.6745;
            
            %std_p1=std(p1);
            %std_p2=std(p1);
            nV=numel(p1)+numel(p2);
            
            s=sign(mp1-mp2);
            %edges=[(mp2-std_p2*s):(s*10/nV*abs(mp1-mp2)):(mp1+std_p1*s)];
            edges=(mp2-std_p2*s):(((mp1+std_p1*s)-(mp2-std_p2*s))/(round(log(nV))/10)/20):(mp1+std_p1*s);
            %eges must be divided in a way that preserve the extreme edges on both sides
            n1=histc(p1,edges);
            n2=histc(p2,edges);
            n=n2(1:end-1)-n1(1:end-1); %eliminate edges that sum over
            %edges=edges(1:end-1);
            
            firstCross=find(n(2:end)<=0 & n(1:end-1)>0,1,'first')+1;
            secondCross=find(n(1:end-1)>=0 & n(2:end)<0,1,'last');
            intersection=(edges(firstCross) + edges(secondCross))/2;
            %D(k,m)=max(sum(p2>(intersection-std_p2/stdMergeFac))/sum(n2),sum(p1<(intersection+std_p1/stdMergeFac))/sum(n1));
            %D(k,m)=sum([p1 p2]<(intersection+std_p2/stdMergeFac) & [p1 p2]>(intersection-std_p1/stdMergeFac))/sum([n1 n2]);
            if isempty(intersection) %one cluster is contained within the other
                D(k,m)=1;
            else
                D(k,m)=(  sum(p2>(intersection-std_p2/stdMergeFac))  +  sum(p1<(intersection+std_p1/stdMergeFac))   ) /sum([n1 n2] );
            end
            %figure;plot([p1 p2]);hold on;plot(ones(1,numel(edges)),edges,'or');line([1 sum([n1 n2])],[intersection intersection],'color','k','LineWidth',2);
        end
        %D(k,m)=(sqrt(sum(v.^2))/sqrt(std_p1^2 + std_p2.^2));
        %D(k,m)=(sqrt(sum(v.^2))/(std_p + std_p2);
        %D(k,m)=(1+skewness([p1 p2])^2)/(kurtosis([p1 p2])+3);
        %D(k,m) = kstest2(p1,p2,[],0.0.05);
        
        if D(k,m)>mergeThreshold
            %find in which group k is and add all is group to m
            groupOfK=gc(k);
            groupOfM=gc(m);
            gc(gc==groupOfK)=groupOfM;
        end
        
        if plotProjection
            
            subaxis(nClustersIn,nClustersIn,(m-1)*nClustersIn+k,'Spacing', 0.001, 'Padding', 0.001, 'Margin', 0.001);
            
            edges=[min([p1 p2]):((max([p1 p2])-min([p1 p2]))/30):max([p1 p2])]; %edges different from before
            n1=hist(p1,edges);
            n2=hist(p2,edges);
            bar(edges,[n1;n2]',1,'stacked');
            axis tight;
            set(gca,'XTickLabel',[],'YTickLabel',[]);
            
            subaxis(nClustersIn,nClustersIn,(k-1)*nClustersIn+m,'Spacing', 0.001, 'Padding', 0.001, 'Margin', 0.001);
            strTxt={['F=' num2str(D(k,m))],['s1=' num2str(std_p1)],['s2=' num2str(std_p2)],['D=' num2str(sqrt(sum(v.^2)))]};
            text(0,0.5,strTxt);
            axis off;
        end
        
    end
end