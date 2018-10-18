MCR=MCRackRecording('D:\PostDoc\Experiments\cortical slab\XX_060213\MCTX000002.mcd');
Fs=MCR.samplingFrequency;

F=filterData(Fs);
F.filterOrder=8;
F.lowPassCutoff=2000;
F.highPassCutoff=200;
F=F.designBandPass;

maxClusters=6;
maxChunkSize=5*60*1000; %[ms]
dimensionReduction=3;
upSamplingFactor=5;
nIterGMMEM=5;
spikePerVoxelMultiplier=10;
gaussianityWindow=20/1000*Fs*upSamplingFactor;
testSamples=gaussianityWindow*1000*upSamplingFactor;
preSpikeSamples=3/1000*Fs*upSamplingFactor; %must be > spikePeakInterval
postSpikeSamples=4/1000*Fs*upSamplingFactor; %must be > spikePeakInterval
spikePeakInterval=1/1000*Fs*upSamplingFactor;
minimumNeuronRate=0.01; %[Hz]
maxSpikesToCluster=30000;

if maxChunkSize>MCR.recordingDuration_ms
    startTimes=0;
    endTimes=MCR.recordingDuration_ms;
else
    startTimes=0:maxChunkSize:MCR.recordingDuration_ms;
    endTimes=[startTimes(2:end) MCR.recordingDuration_ms];
end
nChunks=numel(startTimes);

spikeShapes=[];
ch=MCR.channelNumbers;
%for i=1:numel(ch)
    %i=46;
    i=44
    spikeShapes=[];
    for j=1:nChunks
        
        M=MCR.getData(ch(i),startTimes(j),endTimes(j)-startTimes(j));
        M=F.getFilteredData(M);
        nSamples=numel(M);
        
        %upsample data
        M = spline(1:nSamples,M,(1:(nSamples*upSamplingFactor))/upSamplingFactor)'; %should be done only on spike segments!!! for speed
        nSamples=numel(M);

        %estimate channel noise
        tmpData=buffer(M(1:testSamples),gaussianityWindow,gaussianityWindow/2);
        noiseSamples=tmpData(:,kurtosis(tmpData,0)<3);
        noiseStd=std(noiseSamples(:));
        noiseMean=mean(noiseSamples(:));
        Th=noiseMean-4*noiseStd;

        %find thershold crossings and extract spike windows
        thresholdCrossings=find(M(1:end-1)>Th & M(2:end)<Th);
        thresholdCrossings=thresholdCrossings(thresholdCrossings>preSpikeSamples & thresholdCrossings<nSamples-postSpikeSamples);
        idx=bsxfun(@plus,thresholdCrossings',(-preSpikeSamples:postSpikeSamples)');
        spikeShapesTmp=M(idx);
        
        %allign spike windows to spike extrema
        [spikeAmp,shift]=min(spikeShapesTmp(preSpikeSamples:(spikePeakInterval+preSpikeSamples),:));
        idx=bsxfun(@plus,(thresholdCrossings'+shift),((-preSpikeSamples+spikePeakInterval):(postSpikeSamples-spikePeakInterval))');
        spikeShapes=[spikeShapes M(idx)];
    end
    [nSpikeSamples,nSpikes]=size(spikeShapes);
    
    pSpikes4Clustering=randperm(nSpikes,min(maxSpikesToCluster,nSpikes));
    spikes4Clustering=spikeShapes(:,pSpikes4Clustering);
    %%
    %[C,S] = princomp(spikeShapes');
    nCoeffs=120;
    nCoeffsToSPC=10;
    cc=[];
    for m=1:maxSpikesToCluster
        [c]=wavedec(spikes4Clustering(:,m),4,'haar'); %'haar','coif1'
        cc(m,1:nCoeffs)=c(1:nCoeffs);
    end
    for i=1:nCoeffs                                  % KS test for coefficient selection
        thr_dist = std(cc(:,i)) * 3;
        thr_dist_min = mean(cc(:,i)) - thr_dist;
        thr_dist_max = mean(cc(:,i)) + thr_dist;
        aux = cc(find(cc(:,i)>thr_dist_min & cc(:,i)<thr_dist_max),i);
        
        if length(aux) > 10;
            [ksstat]=test_ks(aux);
            sd(i)=ksstat;
        else
            sd(i)=0;
        end
    end
    [~,ind]=sort(sd,'descend');
    cc=cc(:,ind(1:nCoeffsToSPC));
    
    minClusterSize=MCR.recordingDuration_ms/1000*minimumNeuronRate;
    [idx,tree,clu]=superparamagenticClustering(cc,'min_clusSize',10);
    %[idx]=superparamagenticClustering(S(1:maxSpikesToCluster,1:4),'min_clusSize',minClusterSize);
    unique(idx)
    sampleTimes=(1000*(1:nSpikeSamples)/Fs/upSamplingFactor)';
    figure;
    [D,h]=hist2(sampleTimes*ones(1,maxSpikesToCluster),spikeShapes(:,pSpikes4Clustering),'c1',sampleTimes,'n2',100);
    hold on;
    plot(sampleTimes,mean(spikeShapes(:,idx==0),2),'k');
    plot(sampleTimes,mean(spikeShapes(:,idx==1),2),'r');
    plot(sampleTimes,mean(spikeShapes(:,idx==2),2),'g');
    plot(sampleTimes,mean(spikeShapes(:,idx==3),2),'b');
    plot(sampleTimes,mean(spikeShapes(:,idx==4),2),'m');
    plot(sampleTimes,mean(spikeShapes(:,idx==5),2),'c');
    plot(sampleTimes,mean(spikeShapes(:,idx==6),2),'y');
    
    [C,S] = princomp(cc);
    figure;scatter3(S(:,1),S(:,2),S(:,3),[],idx);
        
    %[~,Cent] = kmeans(S(:,1:dimensionReduction),j,'distance','sqeuclid');
    %[GM, W, MLE] = GMMEM(S(:,1:dimensionReduction)',Cent',j,1);
    %plot(spikeShapes)
    
    %[nSpikeSamples,nSpikes]=size(spikeShapes);
    %X1=(1000*(1:nSpikeSamples)/Fs/upSamplingFactor)'*ones(1,nSpikes);
    %[D,h]=hist2(X1,spikeShapes,'c1',1000*(1:nSpikeSamples)/Fs/upSamplingFactor,'n2',100);
    f=figure;
    for j=1:maxClusters
        idx = kmeans(S(:,1:dimensionReduction),j,'distance','sqeuclid');
        %figure;[s,h] = silhouette(S(:,1:dimensionReduction),idx,'sqeuclid');
        [sil] = silhouette(S(:,1:dimensionReduction),idx,'sqeuclid');
        disp([num2str(j) ' clusters, silhouette = ' num2str(mean(sil))]);
        subplot(2,3,j);
        scatter3(S(:,1),S(:,2),S(:,3),[],idx);
        title([num2str(j) ' clusters, <S> = ' num2str(mean(sil))]);
    end
    
    %GMMEM
    mSil=[];
    options = statset('Display','final','TolFun',1e-6,'MaxIter',200);
    for j=1:maxClusters
        for l=1:nIterGMMEM
            gm = gmdistribution.fit(S(:,1:dimensionReduction),j,'SharedCov',true,'Options',options,'Replicates',1);
            allGM{j,l}=gm;
            idx = cluster(gm,S(:,1:dimensionReduction));
            allIdx{j,l}=idx;
            
            p4Sil=[];
            for k=1:j
                tmp=find(allIdx{j,l}==k);
                tmp=tmp(randperm(numel(tmp)));
                p4Sil=[p4Sil;tmp(1:round(numel(tmp)*0.1))];
            end
            [sil] = silhouette(S(p4Sil,1:dimensionReduction),allIdx{j,l}(p4Sil),'sqeuclid');
            mSil(j,l)=mean(sil);
        end
    end
    
    [~,i]=max(mSil(:));
    [j,l]=ind2sub([maxClusters nIterGMMEM],i);
    idx=allIdx{j,l};
    gm=allGM{j,l};
    scatter(S(:,1),S(:,2),[],idx);
    
    
    dimensionReduction=2;j=4;
    RegV=0; %random noise to matrix
    initPara.mu = S(randsample(nSpikes,j),1:dimensionReduction);
    initPara.mu = [-300 50;-150 50;-60 -40;50 0];
    initPara.PComponents = ones(1,j)/j ;% equal mixing proportions
    initPara.Sigma = repmat(diag(var(S(:,1:dimensionReduction))) + RegV*eye(dimensionReduction),[1,1,j]);

    
    options = statset('Display','final','TolFun',1e-6,'MaxIter',200);
    %gm = gmdistribution.fit(S(:,1:dimensionReduction),5,'Replicates',1,'CovType','Diagonal','SharedCov',true,'Options',options);
    
    gm = gmdistribution.fit(S(:,1:dimensionReduction),4,'Options',options,'Replicates',50);
    idx = cluster(gm,S(:,1:dimensionReduction));
    
    gm = gmdistribution.fit(S(:,1:dimensionReduction),j,'Options',options,'Start',initPara);
    idx = cluster(gm,S(:,1:dimensionReduction));
    
    gm = gmdistribution.fit(cc,j,'CovType','Diagonal','Options',options);
    idx = cluster(gm,cc);
    
    p4Sil=[];
    for k=1:j
        tmp=find(idx==k);
        tmp=tmp(randperm(numel(tmp)));
        p4Sil=[p4Sil;tmp(1:round(numel(tmp)*0.1))];
    end
    [sil] = silhouette(S(p4Sil,1:dimensionReduction),idx(p4Sil),'sqeuclid');
    mean(sil)
        
    sampleTimes=(1000*(1:nSpikeSamples)/Fs/upSamplingFactor)';
    figure;
    [D,h]=hist2(sampleTimes*ones(1,nSpikes),spikeShapes,'c1',sampleTimes,'n2',100);
    hold on;
    plot(sampleTimes,mean(spikeShapes(:,pSpikes4Clustering(idx==1)),2),'r');
    plot(sampleTimes,mean(spikeShapes(:,pSpikes4Clustering(idx==2)),2),'g');
    plot(sampleTimes,mean(spikeShapes(:,pSpikes4Clustering(idx==3)),2),'b');
    plot(sampleTimes,mean(spikeShapes(:,pSpikes4Clustering(idx==4)),2),'m');
    plot(sampleTimes,mean(spikeShapes(:,pSpikes4Clustering(idx==5)),2),'c');
    plot(sampleTimes,mean(spikeShapes(:,pSpikes4Clustering(idx==6)),2),'y');
    figure;scatter3(S(:,1),S(:,2),S(:,3),[],idx);
    
    [idx,cent] = kmeans(cc,4,'options',opts,'distance','sqEuclidean','onlinephase','on','replicates',50,'start','cluster');
    gm = gmdistribution.fit(cc,4,'Options',options,'Replicates',50);
    idx = cluster(gm,cc);
    
    % initial 50 center clustering
    opts = statset('MaxIter',1000);
    [idx1,cent1] = kmeans(S(:,1:dimensionReduction),50,'options',opts);
    [idx2,cent2] = kmeans(cent1,j);
    [idx3,cent3] = kmeans(S(:,1:dimensionReduction),j,'start',cent2);
    scatter3(S(:,1),S(:,2),S(:,3),[],idx3);
    
    %reduction of number of points
    n1=100;n2=100;n3=100;
    [D]=hist3(S(:,1),S(:,2),S(:,3),'n1',n1,'n2',n2,'n3',n3);
    %nSpikes*(1/(n1*n2*n3)) = the average spikes per voxel
    detectionTh=nSpikes*(1/(n1*n2*n3))*spikePerVoxelMultiplier;
    [X1,X2,X3] = ind2sub([n1 n2 n3],find(D>detectionTh));
    
    [idxTmp,centTmp] = kmeans([X1,X2,X3],j);
    [idx,cent] = kmeans(S(:,1:dimensionReduction),j,'start',centTmp);
    scatter3(S(:,1),S(:,2),S(:,3),[],idx);
    
    [idx,cent] = kmeans([X1,X2,X3],j,'start',centTmp);
    scatter3(X1,X2,X3,[],idx);
    
    options = statset('Display','final','TolFun',1e-6,'MaxIter',200);
    %gm = gmdistribution.fit(S(:,1:dimensionReduction),5,'Replicates',1,'CovType','Diagonal','SharedCov',true,'Options',options);
    gm = gmdistribution.fit([X1,X2,X3],8,'Options',options);
    idx = cluster(gm,[X1,X2,X3]);
    scatter3(X1,X2,X3,[],idx);

    p1 = patch(isosurface(D,2),'FaceColor','blue','EdgeColor','none');
    isonormals(D,p1);
    axis vis3d tight
    camlight left;
    lighting phong;
    
    
    %    pause;
%    close(f);
    
%end
