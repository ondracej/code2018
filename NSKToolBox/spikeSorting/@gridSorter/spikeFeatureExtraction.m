function [obj,spikeFeaturesAll]=spikeFeatureExtraction(obj)
%extract features from the detected spike waveforms
if isempty(obj.sortingDir)
    obj.runWithoutSaving2File=true;
    spikeFeaturesAll=cell(1,obj.nCh);
else
    obj.runWithoutSaving2File=false;
end

fprintf('\nExtracting spike features from channels (total %d): ',obj.nCh);
for i=find(obj.sortingFileNames.featureExtractionExist==0 | obj.overwriteFeatureExtraction)
    spikeFeatures=[];
    fprintf('%d ',i);
    
    if ~exist(obj.sortingFileNames.spikeDetectionFile{i},'file')
        warning(['No spike detection file was found for Channel ' num2str(i) '. Feature extraction not performed!']);
        continue;
    else
        load(obj.sortingFileNames.spikeDetectionFile{i});
    end
    
    if ~isempty(spikeShapes)
        %choose a random subset of the spikes for clustering
        nSurroundingChannels=numel(obj.chPar.pSurCh{i});
        [nSamples,nSpikes,nLocalCh]=size(spikeShapes);
        
        nSpikes4Clustering=min(obj.featuresMaxSpikesToCluster,nSpikes);
        
        sd=[];
        switch obj.featuresFeatureExtractionMethod
            case 'wavelet'
                spikeShapes=double(spikeShapes) .* detectionInt2uV;
                if obj.featuresConcatenateElectrodes==1 %all waveforms are ordered channel by channel
                    spikeFeatures=wavedec(spikeShapes(:,1,obj.chPar.pSurCh{i}),obj.featuresWTdecompositionLevel,obj.featuresSelectedWavelet);
                    nCoeffs=numel(spikeFeatures);
                    spikeFeatures=zeros(nSpikes4Clustering,nCoeffs);
                    for j=1:nSpikes4Clustering
                        spikeFeatures(j,:)=wavedec(spikeShapes(:,j,obj.chPar.pSurCh{i}),obj.featuresWTdecompositionLevel,obj.featuresSelectedWavelet); %'haar','coif1'
                    end
                    
                    spikeFeatures2=zeros(nSpikes4Clustering,nCoeffs);
                    for j=1:nSpikes4Clustering
                        spikeFeatures2(j,:)=wavedec(permute(spikeShapes(:,j,obj.chPar.pSurCh{i}),[3 2 1]),obj.featuresWTdecompositionLevel,obj.featuresSelectedWavelet); %'haar','coif1'
                    end
                    spikeFeatures=[spikeFeatures spikeFeatures2];
                else
                    spikeFeatures=wavedec(spikeShapes(:,1,obj.chPar.pSurCh{i}(1)),obj.featuresWTdecompositionLevel,obj.featuresSelectedWavelet);
                    nCoeffs=numel(spikeFeatures);
                    spikeFeatures=zeros(nCoeffs,nSpikes4Clustering,nSurroundingChannels);
                    for j=1:nSpikes4Clustering
                        for k=1:nSurroundingChannels
                            spikeFeatures(:,j,k)=wavedec(spikeShapes(:,j,obj.chPar.pSurCh{i}(k)),obj.featuresWTdecompositionLevel,obj.featuresSelectedWavelet); %'haar','coif1'
                        end
                    end
                    spikeFeatures=reshape(permute(spikeFeatures,[1 3 2]),[size(spikeFeatures,1)*size(spikeFeatures,3) size(spikeFeatures,2)])';
                    nCoeffs=nCoeffs*nSurroundingChannels;
                end
                for j=1:(nCoeffs*2)                               % KS test for coefficient selection
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
                [~,tmp1]=sort(sd(1:nCoeffs),'descend');
                [~,tmp2]=sort(sd(nCoeffs+1:end),'descend');
                spikeFeatures=spikeFeatures(:,[tmp1(1:obj.featuresNWaveletCoeff/2) nCoeffs+tmp2(1:obj.featuresNWaveletCoeff/2)]);
                
                if obj.featuresReduceDimensionsWithPCA
                    [PCAsimMat,spikeFeatures] = princomp(spikeFeatures); %run PCA for visualization purposes
                    spikeFeatures=spikeFeatures(:,1:obj.featuresDimensionReductionPCA);
                end
                
            case 'PCA' %this option was tested and gives worse results than wavelets
                spikeShapes=double(spikeShapes(:,:,obj.chPar.pSurCh{i})) .* detectionInt2uV;
                [~,spikeFeatures] = princomp(reshape(permute(spikeShapes,[1 3 2]),[nSamples*numel(obj.chPar.pSurCh{i}) nSpikes]));
                spikeFeatures=spikeFeatures(1:obj.featuresDimensionReductionPCA,:)';
        end
    end
    if ~obj.runWithoutSaving2File
        save(obj.sortingFileNames.featureExtractionFile{i},'spikeFeatures','-v7.3');
    else
        spikeFeaturesAll{i}=spikeFeatures;
    end
end
end