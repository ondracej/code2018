function [spikeFeaturesAll]=spikeFeatureExtractionNSK(chPar,fileNames,varargin)

%default variables
sortingDir=[];
nWaveletCoeff=30; %number of wavelet coeff to extract
dimensionReductionPCA=6;
reduceDimensionsWithPCA=true;
selectedWavelet='haar'; %the mother wavelet
WTdecompositionLevel=4; %the level of decomposition
featureExtractionMethod='wavelet'; %the method for extracting features
concatenateElectrodes=true; %concatenate all surrounding electrodes to 1 big voltage trace

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

if isempty(sortingDir)
    writeDataToFile=false;
    spikeFeaturesAll=cell(1,nCh);
else
    if nargout>0
        error('No output variables are allowed in save data to disk option')
    end
    writeDataToFile=true;
end

fprintf('\nExtracting spike features from channels (total %d): ',nCh);
for i=find(fileNames.featureExtractionExist==0)
    spikeFeatures=[];
    fprintf('%d ',i);
    
    if ~exist(fileNames.spikeDetectionFile{i},'file')
        warning(['No spike detection file was found for Channel ' num2str(i) '. Feature extraction not performed!']);
        continue;
    else
        load(fileNames.spikeDetectionFile{i});
    end
    
    if ~isempty(spikeShapes)
        %choose a random subset of the spikes for clustering
        nSurroundingChannels=numel(chPar.pSurCh{i});
        [nSamples,nSpikes,nLocalCh]=size(spikeShapes);
        
        nSpikes4Clustering=min(maxSpikesToCluster,nSpikes);
                
        sd=[];
        switch featureExtractionMethod
            case 'wavelet'
                spikeShapes=double(spikeShapes) .* int2uV;
                if concatenateElectrodes==1 %all waveforms are ordered channel by channel
                    spikeFeatures=wavedec(spikeShapes(:,1,chPar.pSurCh{i}),WTdecompositionLevel,selectedWavelet);
                    nCoeffs=numel(spikeFeatures);
                    spikeFeatures=zeros(nSpikes4Clustering,nCoeffs);
                    for j=1:nSpikes4Clustering
                        spikeFeatures(j,:)=wavedec(spikeShapes(:,j,chPar.pSurCh{i}),WTdecompositionLevel,selectedWavelet); %'haar','coif1'
                    end
                    
                    spikeFeatures2=zeros(nSpikes4Clustering,nCoeffs);
                    for j=1:nSpikes4Clustering
                        spikeFeatures2(j,:)=wavedec(permute(spikeShapes(:,j,chPar.pSurCh{i}),[3 2 1]),WTdecompositionLevel,selectedWavelet); %'haar','coif1'
                    end
                    spikeFeatures=[spikeFeatures spikeFeatures2];
                else
                    spikeFeatures=wavedec(spikeShapes(:,1,chPar.pSurCh{i}(1)),WTdecompositionLevel,selectedWavelet);
                    nCoeffs=numel(spikeFeatures);
                    spikeFeatures=zeros(nCoeffs,nSpikes4Clustering,nSurroundingChannels);
                    for j=1:nSpikes4Clustering
                        for k=1:nSurroundingChannels
                            spikeFeatures(:,j,k)=wavedec(spikeShapes(:,j,chPar.pSurCh{i}(k)),WTdecompositionLevel,selectedWavelet); %'haar','coif1'
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
                spikeFeatures=spikeFeatures(:,[tmp1(1:nWaveletCoeff/2) nCoeffs+tmp2(1:nWaveletCoeff/2)]);
                
                if reduceDimensionsWithPCA
                    [PCAsimMat,spikeFeatures] = princomp(spikeFeatures); %run PCA for visualization purposes
                    spikeFeatures=spikeFeatures(:,1:dimensionReductionPCA);
                end
                
            case 'PCA' %this option was tested and gives worse results than wavelets
                spikeShapes=double(spikeShapes(:,:,chPar.pSurCh{i})) .* int2uV;
                [~,spikeFeatures] = princomp(reshape(permute(spikeShapes,[1 3 2]),[nSamples*numel(chPar.pSurCh{i}) nSpikes]));
                spikeFeatures=spikeFeatures(1:dimensionReductionPCA,:)';
        end
    end
    if writeDataToFile
        save(fileNames.featureExtractionFile{i},'spikeFeatures','-v7.3');
    else
        spikeFeaturesAll{i}=spikeFeatures;
    end
end
