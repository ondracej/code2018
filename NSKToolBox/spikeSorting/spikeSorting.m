function [t,ic,avgWaveform]=spikeSorting(dataRecordingObj,varargin)
saveFigures=1;
saveSpikeExtraction=1;
loadSpikeExtraction=1;
saveFeatureExtraction=1;
loadFeatureExtraction=1;
saveClassification=1;
loadClassification=1;
plotProjection=1;
plotClassification=1;
plotSilhoutte=1;
maxClusters=10;
upSamplingFactor=5;
selectedChannels=[];
Fs=dataRecordingObj.samplingFrequency; %get sampling frequency
maxNumberOutliers=50;

minimumChannelRate=0.01; %[Hz]
minSpikesCluster=10;
minSpikesTotal=50; %do not attempt to cluster channels with less spikes
maxSpikesToCluster=10000;

dimensionReductionPCA=5;
nWaveletCoeff=10; %number of wavelet coeff to extract
selectedWavelet='haar'; %the mother wavelet
featureExtractionMethod='wavelet'; %'PCA'/'wavelet'
WTdecompositionLevel=4; %the level of decomposition

clusteringMethod='kMeans_merge'; %'kMeans_sil'/'kMeans_merge'/'GMMEM'
maxIter=1000; %max itteration for clustering algorithm
replicates=50; %number of replicates in clustering algorithm
initialClusterCentersMethod='cluster'; %method for initial conditions in k-means algorithm
maxNumberOfPointsInSilhoutte=1000; %the maximal number of data points per cluster used for silloute quality estimation
mergeThreshold=0.18; %threshold for merging clusters %the higher the threshold the less cluster will merge
stdMergeFac=2; %the fraction of a gaussian to check from the crossing point on both sides (the higher the more clusters separate into groups)
rejectPCAStd=20; %the multiplicator in PCA space for determining a thershold for outlier rejection

templateMatching=1;

%construct filtering object
F=filterData(Fs);
F.highPassPassCutoff=200;
F.highPassStopCutoff=190;
F.lowPassPassCutoff=5000;
F.lowPassStopCutoff=10000;
F.attenuationInHighpass=4;
F.attenuationInLowpass=4;
F=F.designBandPass;

%Collects all options
for i=1:2:length(varargin)
    eval([varargin{i} '=' 'varargin{i+1};'])
end

%determine channels
if isempty(selectedChannels)
    selectedChannels=dataRecordingObj.channelNumbers; %take all channel in the recording
end
nSelectedChannels=numel(selectedChannels);

%make directory in recording folder with spike sorting data
[pathstr, name, ext] = fileparts(dataRecordingObj.recordingName{1});
sortingDir=[dataRecordingObj.recordingDir '\' name '_spikeSort'];
if saveSpikeExtraction || plotClassification || plotSilhoutte
    mkdir(sortingDir);
end
%sort spikes
t=[];
ic=[];
f1=[];
f2=[];
position=0;
avgWaveform=[];
for i=1:nSelectedChannels %go over all channels in the recording
    tic;disp(['Loading waveforms, channel' num2str(selectedChannels(i)) ' - ' num2str(i) '/' num2str(nSelectedChannels)]);
    spikeShapeFile=[sortingDir '\ch_' num2str(selectedChannels(i)) '_spikeShapes.mat'];
    if loadSpikeExtraction && exist(spikeShapeFile,'file');
        load(spikeShapeFile);
    else
        [spikeTimes,spikeShapes]=spikeDetectionNSK(dataRecordingObj,FilterObj,selectedChannels(i),upSamplingFactor);
        if saveSpikeExtraction
            save([sortingDir '\ch_' num2str(selectedChannels(i)) '_spikeShapes.mat'],...
                'spikeShapes','spikeTimes','Th','Fs','preSpikeSamples','postSpikeSamples');
        end
    end
    [nSpikeSamples,nSpikes]=size(spikeShapes);
    toc
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%  feature extraction  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if nSpikes<minSpikesTotal || nSpikes<(spikeTimes(end)-spikeTimes(1))/1000*minimumChannelRate
        continue;
    end
    tic;disp('feature extraction');
    featureExtractionFile=[sortingDir '\ch_' num2str(selectedChannels(i)) '_featureExtraction.mat'];
    if loadFeatureExtraction && exist(featureExtractionFile,'file');
        load(featureExtractionFile);
    else
        %choose a random subset of the spikes for clustering
        nSpikes4Clustering=min(maxSpikesToCluster,nSpikes);
        pSpikes4Clustering=randperm(nSpikes,nSpikes4Clustering);
        spikes4Clustering=spikeShapes(:,pSpikes4Clustering);
        
        switch featureExtractionMethod
            case 'wavelet'
                spikeFeatures=[];
                %spikeFeatures=zeros(nSpikes4Clustering,nSpikeSamples+2); %check the number of coeffs
                for j=1:nSpikes4Clustering
                    spikeFeatures(j,:)=wavedec(spikes4Clustering(:,j),WTdecompositionLevel,selectedWavelet); %'haar','coif1'
                end
                for j=1:nSpikeSamples                                  % KS test for coefficient selection
                    thr_dist = std(spikeFeatures(:,j)) * 3;
                    thr_dist_min = mean(spikeFeatures(:,j)) - thr_dist;
                    thr_dist_max = mean(spikeFeatures(:,j)) + thr_dist;
                    aux = spikeFeatures(spikeFeatures(:,j)>thr_dist_min & spikeFeatures(:,j)<thr_dist_max,j);
                    
                    if length(aux) > 10;
                        [ksstat]=test_ks(aux);
                        sd(j)=ksstat;
                    else
                        sd(j)=0;
                    end
                end
                [~,tmp]=sort(sd,'descend');
                spikeFeatures=spikeFeatures(:,tmp(1:nWaveletCoeff));
            case 'PCA'
                [PCAsimMat,spikeFeatures] = princomp(spikes4Clustering'); %run PCA for visualization purposes
                spikeFeatures=spikeFeatures(:,1:dimensionReductionPCA);
        end
        if saveFeatureExtraction
            save([sortingDir '\ch_' num2str(selectedChannels(i)) '_featureExtraction.mat'],...
                'spikeFeatures','nSpikes4Clustering','pSpikes4Clustering','spikes4Clustering','featureExtractionMethod');
        end
    end
    [PCAFeatureSimMat,PCAspikeFeatures] = princomp(spikeFeatures); %run PCA for visualization purposes
    %sPC1=std(PCAspikeFeatures(:,1));
    %sPC2=std(PCAspikeFeatures(:,2));
    sPC1=median(abs(  PCAspikeFeatures(:,1)-median(PCAspikeFeatures(:,1))  )) / 0.6745;
    sPC2=median(abs(  PCAspikeFeatures(:,2)-median(PCAspikeFeatures(:,2))  )) / 0.6745;
    pOutliers=find( PCAspikeFeatures(:,1)>rejectPCAStd*sPC1 | PCAspikeFeatures(:,1)<-rejectPCAStd*sPC1 | PCAspikeFeatures(:,2)>rejectPCAStd*sPC2 | PCAspikeFeatures(:,2)<-rejectPCAStd*sPC2);
    nOutliers=numel(pOutliers);
    if nOutliers<maxNumberOutliers
        disp([num2str(nOutliers) ' outliers removed']);
        PCAspikeFeatures(pOutliers,:)=[];
        spikeFeatures(pOutliers,:)=[];
        nSpikes4Clustering=nSpikes4Clustering-numel(pOutliers);
        pSpikes4Clustering(pOutliers)=[];
        spikes4Clustering(:,pOutliers)=[];
        [PCAFeatureSimMat,PCAspikeFeatures] = princomp(spikeFeatures); %run PCA for visualization purposes
    end
    %figure;plot(PCAspikeFeatures(:,1),PCAspikeFeatures(:,2),'.');
    toc
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  clustering  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    tic;disp('clustering');
    classificationFile=[sortingDir '\ch_' num2str(selectedChannels(i)) '_classification.mat'];
    if loadClassification && exist(classificationFile,'file');
        load(classificationFile);
    else
        if nSpikes4Clustering>=minSpikesTotal
            switch clusteringMethod
                case 'kMeans_merge'
                    % set options to k-Means
                    opts = statset('MaxIter',maxIter);
                    [initIdx,cent,~,distanceToCentroid] = kmeans(spikeFeatures,maxClusters,'options',opts,...
                        'emptyaction','singleton','distance','city','onlinephase','on','replicates',replicates,'start',initialClusterCentersMethod);
                    %scatter3(PCAspikeFeatures(:,1),PCAspikeFeatures(:,2),PCAspikeFeatures(:,3),2,idx);
                    %figure;scatter(PCAspikeFeatures(:,1),PCAspikeFeatures(:,2),2,idx);
                    %merge clusters that are too close apart
                    D=zeros(maxClusters);
                    groups=mat2cell(1:maxClusters,1,ones(1,maxClusters));
                    gc=1:maxClusters; % a group is assigned to every cluster
                    for k=2:maxClusters
                        for m=1:k-1
                            v=(cent(k,:)-cent(m,:));
                            p1=projectionND(v,spikeFeatures(initIdx==k,:));
                            p2=projectionND(v,spikeFeatures(initIdx==m,:));
                            
                            if numel(p1)<minSpikesCluster || numel(p2)<minSpikesCluster
                                D(k,m)=0;
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
                                D(k,m)=(sum(p2>(intersection-std_p2/stdMergeFac))+sum(p1<(intersection+std_p1/stdMergeFac)))/sum([n1 n2]);
                                
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
                        end
                    end
                    
                    if plotProjection
                        f1=figure('Position',[50 50 1400 900]);
                        %plot projection stats
                        for k=2:maxClusters
                            for m=1:k-1
                                v=(cent(k,:)-cent(m,:));
                                p1=projectionND(v,spikeFeatures(initIdx==k,:));
                                p2=projectionND(v,spikeFeatures(initIdx==m,:));
                                pCent=projectionND(v,[cent(k,:);cent(m,:)]);
                                
                                std_p1=nanmedian(abs(  p1-median(p1)  ),2) / 0.6745;
                                std_p2=nanmedian(abs(  p2-median(p2)  ),2) / 0.6745;
                                
                                %D(k,m)=(sqrt(sum(v.^2))/sqrt(std_p1^2 + std_p2.^2));
                                
                                subaxis(maxClusters,maxClusters,(m-1)*maxClusters+k,'Spacing', 0.001, 'Padding', 0.001, 'Margin', 0.001);
                                
                                edges=[min([p1 p2]):((max([p1 p2])-min([p1 p2]))/30):max([p1 p2])];
                                n1=hist(p1,edges);
                                n2=hist(p2,edges);
                                bar(edges,[n1;n2]',1,'stacked');
                                axis tight;
                                set(gca,'XTickLabel',[],'YTickLabel',[]);
                                
                                subaxis(maxClusters,maxClusters,(k-1)*maxClusters+m,'Spacing', 0.001, 'Padding', 0.001, 'Margin', 0.001);
                                strTxt={['F=' num2str(D(k,m))],['s1=' num2str(std_p1)],['s2=' num2str(std_p2)],['D=' num2str(sqrt(sum(v.^2)))]};
                                text(0,0.5,strTxt);
                                axis off;
                            end
                        end
                        if saveFigures
                            set(f1,'PaperPositionMode','auto');
                            print([sortingDir '\Ch_' num2str(selectedChannels(i)) 'projectionTest'],'-djpeg','-r300');
                        end
                    end
                    
                    uniqueClusters=unique(gc);
                    nClusters=numel(uniqueClusters);
                    idx=zeros(nSpikes4Clustering,1);
                    for k=1:nClusters
                        p=find(gc==uniqueClusters(k));
                        for j=1:numel(p)
                            idx(initIdx==p(j))=k;
                        end
                    end
                    
                case 'kMeans_sil'
                    % set options to k-Means
                    opts = statset('MaxIter',maxIter);
                    
                    mSil=zeros(1,maxClusters);
                    f1=figure('Position',[50 50 1200 900]);
                    for j=2:maxClusters %run over different cluter numbers and calculate clustering quality
                        [idx,cent,~,distanceToCentroid] = kmeans(spikeFeatures,j,'options',opts,...
                            'distance','sqEuclidean','onlinephase','on','replicates',replicates,'start',initialClusterCentersMethod);
                        
                        %examine qualitiy of cluster separation with silloute
                        p4Sil=[];
                        for k=1:j
                            dataPoints=find(idx==k);
                            nPointsInCluster=numel(dataPoints);
                            dataPointsSil=dataPoints(randperm(nPointsInCluster,min(maxNumberOfPointsInSilhoutte,nPointsInCluster)));
                            p4Sil=[p4Sil;dataPointsSil];
                        end
                        [sil] = silhouette(spikeFeatures(p4Sil,:),idx(p4Sil),'sqeuclid');
                        %for non even distribution of points for silloute use the following:
                        %p4Sil=randperm(nSpikes4Clustering,min(maxNumberOfPointsInSilloute*j,nPointsInCluster))
                        %[sil] = silhouette(spikeFeatures(p4Sil,:),idx(p4Sil),'sqeuclid');
                        mSil(j)=mean(sil);
                        if plotSilhoutte
                            %reduce dimensions for silhoutte plot
                            subplot(3,3,j-1);
                            scatter(PCAspikeFeatures(:,1),PCAspikeFeatures(:,2),2,idx);
                            title([num2str(j) ' clusters, <Sil> = ' num2str(mSil(j))]);
                        end
                    end
                    
                    D=zeros(j);
                    groups=mat2cell(1:j,1,ones(1,j));
                    gc=1:j; % a group is assigned to every cluster
                    for k=2:j
                        for m=1:k-1
                            v=(cent(k,:)-cent(m,:));
                            p1=projectionND(v,spikeFeatures(idx==k,:));
                            p2=projectionND(v,spikeFeatures(idx==m,:));
                            D(k,m)=(sqrt(sum(v.^2))/sqrt(std(p1)^2 + std(p2)^2));
                            if D(k,m)<mergeThreshold
                                %find in which group k is and add all is group to m
                                groupOfK=gc(k);
                                groupOfM=gc(m);
                                gc(gc==groupOfK)=groupOfM;
                            end
                        end
                    end
                    uniqueClusters=unique(gc);
                    nClusters=numel(uniqueClusters);
                    finalIdx=zeros(nSpikes4Clustering,1);
                    for k=1:nClusters
                        p=find(gc==uniqueClusters(k));
                        for j=1:numel(p)
                            finalIdx(idx==p(j))=k;
                        end
                    end
                    idx=finalIdx;
                    
                    if saveFigures
                        set(f,'PaperPositionMode','auto');
                        print([sortingDir '\Ch_' num2str(selectedChannels(i)) 'classQuality'],'-djpeg','-r300');
                    end
                    %calculate final clustering
                    [maxSilValue,nClusters]=max(mSil);
                    [idx,cent,~,distanceToCentroid] = kmeans(spikeFeatures,nClusters,'options',opts,...
                        'distance','sqEuclidean','onlinephase','on','replicates',replicates*2,'start',initialClusterCentersMethod);
                    
                case 'GMMEM'
                    %{
            % set options to k-Means
            opts = statset('MaxIter',maxIter);
            [idx,cent,~,distanceToCentroid] = kmeans(spikeFeatures,maxClusters,'options',opts,...
                'distance','cityblock','onlinephase','on','replicates',replicates,'start',initialClusterCentersMethod);
            
                    %}
                    options = statset('Display','final','TolFun',1e-6,'MaxIter',200);
                    %gm = gmdistribution.fit(S(:,1:dimensionReduction),5,'Replicates',1,'CovType','Diagonal','SharedCov',true,'Options',options,'Regularize',0.001);
                    
                    gm = gmdistribution.fit(PCAspikeFeatures(:,1:3),maxClusters,'Options',options,'CovType','Diagonal','Replicates',10);
                    cent=gm.mu;
                    idx = cluster(gm,PCAspikeFeatures(:,1:3));
                    %scatter3(PCAspikeFeatures(:,1),PCAspikeFeatures(:,2),PCAspikeFeatures(:,3),2,idx);hold on;
                    %text(cent(:,1),cent(:,2),cent(:,3),{'1','2','3','4','5','6','7'})
                    
                    D=zeros(maxClusters);
                    groups=mat2cell(1:maxClusters,1,ones(1,maxClusters));
                    gc=1:maxClusters; % a group is assigned to every cluster
                    for k=2:maxClusters
                        for m=1:k-1
                            v=(cent(k,:)-cent(m,:));
                            p1=projectionND(v,PCAspikeFeatures(idx==k,1:3));
                            p2=projectionND(v,PCAspikeFeatures(idx==m,1:3));
                            
                            std_p1=nanmedian(abs(  p1-median(p1)  ),2) / 0.6745;
                            std_p2=nanmedian(abs(  p2-median(p2)  ),2) / 0.6745;
                            
                            D(k,m)=(sqrt(sum(v.^2))/sqrt(std_p1^2 + std_p2^2));
                            if D(k,m)<mergeThreshold
                                %find in which group k is and add all is group to m
                                groupOfK=gc(k);
                                groupOfM=gc(m);
                                gc(gc==groupOfK)=groupOfM;
                            end
                        end
                    end
                    uniqueClusters=unique(gc);
                    nClusters=numel(uniqueClusters);
                    finalIdx=zeros(nSpikes4Clustering,1);
                    for k=1:nClusters
                        p=find(gc==uniqueClusters(k));
                        for j=1:numel(p)
                            finalIdx(idx==p(j))=k;
                        end
                    end
                    idx=finalIdx;
                    %scatter3(PCAspikeFeatures(:,1),PCAspikeFeatures(:,2),PCAspikeFeatures(:,3),2,idx);
                    %scatter(PCAspikeFeatures(:,1),PCAspikeFeatures(:,2),2,idx);
                    
                case 'Manual_GMMEM'
                    mf=figure;plot(PCAspikeFeatures(:,1),PCAspikeFeatures(:,2),'.');
                    [x,y,button]= ginput;
                    close(mf);
                    
                    dim=2;
                    nClusters=size(x,1);
                    RegV=0; %random noise to matrix
                    initPara.mu = [x y];
                    initPara.PComponents = ones(nClusters,1)/nClusters; % equal mixing proportions
                    initPara.Sigma = repmat(diag(var(PCAspikeFeatures(:,1:dim))) + RegV*eye(dim),[1,1,nClusters]);
                    options = statset('Display','final','TolFun',1e-6,'MaxIter',200);
                    gm = gmdistribution.fit(PCAspikeFeatures(:,1:2),nClusters,'Options',options,'Replicates',1,'Start',initPara);
                    idx = cluster(gm,PCAspikeFeatures(:,1:2));
            end
        else
            idx=ones(nSpikes4Clustering,1);
            initIdx=ones(nSpikes4Clustering,1);
            nClusters=0;
        end
        
        if saveClassification
            save(classificationFile,'idx','initIdx','nClusters')
        end
    end
    
    avgSpikeWaveforms=zeros(max(1,nClusters),nSpikeSamples);
    for j=1:nClusters
        avgSpikeWaveforms(j,:)=mean(spikes4Clustering(:,idx==j),2);
    end
    
    match=zeros(nClusters,nSpikes);
    if templateMatching & nClusters~=0 %the second condition was added to not get an error if data is too small - problem with k-means
        for j=1:nClusters
            match(j,:)=sum(bsxfun(@minus,spikeShapes,avgSpikeWaveforms(j,:)').^2);
        end
        [~,idxOut]=min(match,[],1);
        idx=idxOut(pSpikes4Clustering);
    else
        idxOut=idx;
    end
    
    
    %generate t,ic file
    avgWaveform{i}=[];
    if nargout>0
        for j=1:nClusters
            position=numel(t);
            t=[t spikeTimes(idxOut==j)];
            ic=[ic [selectedChannels(i);j;position+1;numel(t)]];
            avgWaveform{i}=[avgWaveform{i};avgSpikeWaveforms(j,:)];
        end
    end
    
    if plotClassification
        
        f2=figure('Position',[100 100 1300 400]);
        cmap=colormap('Lines');
        set(f2,'DefaultAxesColorOrder',cmap);
        h1=subplot(1,3,1);
        
        cent=[];
        for k=1:maxClusters
            cent(k,:)=mean(PCAspikeFeatures(initIdx==k,1:2),1);
        end
        h1s=scatter(PCAspikeFeatures(:,1),PCAspikeFeatures(:,2),2,cmap(initIdx,:));
        text(cent(:,1),cent(:,2),mat2cell(1:maxClusters,1,ones(1,maxClusters)),'FontWeight','Bold');
        xlabel('PCA 1');
        ylabel('PCA 2');
        freezeColors(h1s);
        
        h2=subplot(1,3,2);
        %recalculate centers
        cent=[NaN NaN];
        for k=1:nClusters
            cent(k,:)=mean(PCAspikeFeatures(idx==k,1:2));
        end
        
        h2s=scatter(PCAspikeFeatures(:,1),PCAspikeFeatures(:,2),2,cmap(idx,:));
        text(cent(:,1),cent(:,2),mat2cell(1:nClusters,1,ones(1,nClusters)),'FontWeight','Bold');
        xlabel('PCA 1');
        ylabel('PCA 2');
        freezeColors(h2s);
        
        removeEdgePlottingIssues=1; %not to plot spikes with large activity on edges
        if removeEdgePlottingIssues
            violation1=find(max(abs(spikes4Clustering([1:50 201:251],:)))>max(abs(spikes4Clustering(51:200,:))));
            spikes4Clustering(:,violation1)=[];
            nSpikes4Clustering=nSpikes4Clustering-numel(violation1);
        end
        
        h3=subplot(1,3,3);
        sampleTimes=(1000*(1:nSpikeSamples)/Fs/upSamplingFactor)';
        [D,h,cb]=hist2(sampleTimes*ones(1,nSpikes4Clustering),spikes4Clustering,'c1',sampleTimes,'n2',100,'h',h3);
        xlabel('Time [ms]');
        ylabel('Voltage [\muV]');
        hold on;
        plot(sampleTimes,avgSpikeWaveforms');
        
        Pos=get(h3,'position');
        set(cb,'Position',[0.915 Pos(2) 0.01 Pos(4)]);
        
        if saveFigures
            set(f2,'PaperPositionMode','auto');
            print([sortingDir '\Ch_' num2str(selectedChannels(i)) 'classification'],'-djpeg','-r300');
            
            if ishandle(f1)
                close(f1);
            end
            if ishandle(f2)
                close(f2);
            end
        end
    end
    toc
end

function p=projectionND(v,d)
%Calculate projection between a vector and a set of dots in multi dimensional space
%v = [1 x N] - vector
%d = [M X N] - M dot locations

%calculate the cos angle between vector and dots
cosAng=v*d'./(sqrt(sum(v.^2))*sqrt(sum(d'.^2)));
p=cosAng.*sqrt(sum(d'.^2));
