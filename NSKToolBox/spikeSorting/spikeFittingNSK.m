function [t,ic]=spikeFittingNSK(chPar,fileNames,varargin)
%default variables
templateMethod=1;
maxLagMs=1.6;
lagIntervalSamples=3;

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
else
    if nargout>0
        error('No output variables are allowed in save data to disk option')
    end
    writeDataToFile=true;
end

fprintf('\nFitting spikes...');
load(fileNames.mergedAvgWaveformFile,'avgWF','ch','isNoise');

%Plots for testing
%{
p=cellfun(@(x) numel(x),avgWF);
pV=find(p>0);
nPlots=min(ceil(sqrt(sum(p))),7);
c=1;
for i=1:numel(pV)
    for j=1:p(pV(i))
        h=subaxis(nPlots,nPlots,c,'S',0.03,'M',0.03);
        activityTracePhysicalSpacePlot(h,ch{pV(i)}{j},0.03*squeeze(avgWF{pV(i)}{j})',chPar.rEn,'scaling','none');
        title([num2str(pV(i)) '-' num2str(j) ', noise=' num2str(isNoise{pV(i)}{j})]);
        c=c+1;
    end
end
%}

%get noise thresholds for all channels
for i=1:nCh %go over all channels in the recording
    load(fileNames.spikeDetectionFile{i},'Th');
    T(i)=mean(Th);
end
edges=[0.5:1:20.5];
centers=(edges(1:end-1)+edges(2:end))/2;
gauss=@(x,m,s) (1/s/sqrt(2*pi)).*exp(-(x-m).^2./2./s.^2);

maxCCLag=maxLagMs*upSamplingFrequency/1000;

lags=[fliplr(0:-lagIntervalSamples:-maxCCLag) lagIntervalSamples:lagIntervalSamples:maxCCLag];
lag=(numel(lags)-1)/2;
lagSamples=lags((lag+1):end);

tAll=cell(nCh,1);
fprintf('\nFitting data on Ch (total %d): ',nCh);
for i1=1:nCh %go over all channels in the recording
    fprintf('%d ',i1);
    tmpWFs=[];
    if ~exist(fileNames.spikeDetectionFile{i1},'file')
        warning(['No spike detection file was found for Channel ' num2str(i1) '. Fitting not performed!']);
        continue;
    else
        load(fileNames.spikeDetectionFile{i1},'spikeShapes','spikeTimes','int2uV');
        [nSamples,nSpikes,nChTmp]=size(spikeShapes);
        spikeShapes=double(spikeShapes)*int2uV;
    end
    
    noiseStd=std(spikeShapes([1:50 251:300],:,:),1);
    [stdHist]=histc(squeeze(noiseStd),edges);
    [~,pMax]=max(stdHist);
    noiseStd=centers(pMax);
    
    match=[];
    correspCh=[];
    for i2=[i1 chPar.surChExtVec{i1}(chPar.pSurChOverlap{i1})]
        for neu=1:numel(avgWF{i2})
            [commonCh,pComN1,pComN2]=intersect(chPar.surChExtVec{i1},ch{i2}{neu});
            %try and revise this criteria
            tmpWF=avgWF{i2}{neu}(:,pComN2);
            
            if templateMethod==1 %'minkowski' exp 2 + cross-corr
                tmpWF=reshape(tmpWF,[size(tmpWF,1),size(tmpWF,2),1]);
                spikes=permute(spikeShapes(:,:,pComN1),[1 3 2]);
                tmpMatch=zeros(lag*2+1,nSpikes);
                for l=0:lag
                    %spike is after the template
                    tmpMatch(lag+l+1,:)=(   nanmean(reshape( bsxfun(@minus,spikes((lagSamples(l+1)+1):end,:,:),tmpWF(1:end-lagSamples(l+1),:,:)).^2 , [(nSamples-lagSamples(l+1))*numel(commonCh) nSpikes] ))   ).^(1/2);
                    %spike is before the template
                    tmpMatch(lag-l+1,:)=(   nanmean(reshape( bsxfun(@minus,spikes(1:end-lagSamples(l+1),:,:),tmpWF((lagSamples(l+1)+1):end,:,:)).^2 , [(nSamples-lagSamples(l+1))*numel(commonCh) nSpikes] ))   ).^(1/2);
                end
                match=cat(3,match,tmpMatch);
                correspCh=[correspCh ; i2 neu];
                
            elseif templateMethod==2 %implement 'minkowski' distance with exponent 24
                tmpWF=reshape(tmpWF,[size(tmpWF,1),1,size(tmpWF,2)]);
                spikes=reshape(permute(spikeShapes(:,:,pComN1),[1 3 2]),[nSamples*numel(commonCh) nSpikes]);
                tmpMatch=bsxfun(@minus,spikes,tmpWF(:)).^2;
                tmpMatch=(nanmean(tmpMatch)).^(1/2);%./(nanstd(tmpMatch)+nanstd(tmpWF(:)));
                
                match=[match ; tmpMatch];
                correspCh=[correspCh ; i2 neu];
                
            elseif templateMethod==3
                tmpWF=reshape(tmpWF,[size(tmpWF,1),1,size(tmpWF,2)]);
                spikes=reshape(permute(spikeShapes(:,:,pComN1),[1 3 2]),[nSamples*numel(commonCh) nSpikes]);
                %noiseStd=mean(T)/5;
                noiseStd=mean(noiseStd);
                tmpMatch=bsxfun(@minus,spikes,tmpWF(:));
                tmpMatch=gauss(0,0,noiseStd)-gauss(tmpMatch,0,noiseStd);
                tmpMatch=mean(tmpMatch);
                
                match=[match ; tmpMatch];
                correspCh=[correspCh ; i2 neu];
            end
            
            %mS=mean(spikes(:));
            %sS=std(spikes(:));
            %spikes(spikes<mS+1*sS & spikes>mS-1*sS)=NaN;
            %tmpWF(tmpWF<mS+1*sS & tmpWF>mS-1*sS)=NaN;
            
            %{
            f=figure('position',[83         120        1699         852]);
            M=spikeShapes(:,:,pComN1);
            plotShifted(reshape(permute(M,[1 3 2]),[size(M,1)*size(M,3) size(M,2)]),'verticalShift',30);hold on;
            M=repmat(tmpWF,[1 nSpikes 1]);
            plotShifted(reshape(permute(M,[1 3 2]),[size(M,1)*size(M,3) size(M,2)]),'verticalShift',30,'color','k');set(gca,'YTickLabel',[]);
            text(zeros(nSpikes,1),0:30:(30*(nSpikes-1)),num2cell(tmpMatch),'HorizontalAlignment','right');
            pause;close(f);
            %}
            
        end
    end
    if ~isempty(match)
        if templateMethod==1
            [tmpMin,delay]=min(match,[],1);
            [~,idxOut]=min(tmpMin,[],3);
            delay=lags(delay(sub2ind(size(delay),ones(1,nSpikes),1:nSpikes,idxOut)));
            tAll{i1}=[correspCh(idxOut,[1 2]) (spikeTimes+delay/upSamplingFrequency*1000)'];
        else
            [~,idxOut]=min(match,[],1);
            tAll{i1}=[correspCh(idxOut,[1 2]) spikeTimes'];
        end
    else
        tAll{i1}=[];
    end
    %{
    f=figure('position',[83         120        1699         852]);
    [~,p]=sort(idxOut);
    n=min(numel(p),50);
    M=spikeShapes(:,p(1:n),:);
    plotShifted(reshape(permute(M,[1 3 2]),[size(M,1)*size(M,3) size(M,2)]),'verticalShift',30);hold on;
    text(zeros(n,1),0:30:(30*(n-1)),num2cell(idxOut(p(1:n))));
    pause;close(f);
%}
    %{
    M=spikeShapes;plotShifted(reshape(permute(M,[1 3 2]),[size(M,1)*size(M,3) size(M,2)]),'verticalShift',30);line([(pMin-1)*size(M,1) pMin*size(M,1)],[0 0],'color','g','lineWidth',3);
    f=figure;load layout_40_Hexa;En=flipud(En);
    for c=1:20
        h=subaxis(4,5,c,'S',0.03,'M',0.03);
        activityTracePhysicalSpacePlot(h,commonCh,0.03*squeeze(spikeShapes(:,c,pComN1))',En,'scaling','none');
        title(num2str(idxOut(c)));
    end
    %}
    
end
t=sortrows(cell2mat(tAll));

if ~isempty(t)
    icCh = unique(t(:,[1 2]),'rows');
    chTransitions=unique([find(diff(t(:,1))~=0);find(diff(t(:,2))~=0)]);
    
    ic([1 2],:)=icCh';
    ic(4,:)=[chTransitions' size(t,1)];
    ic(3,:)=[1 ic(4,1:end-1)+1];
    t=round((upSamplingFrequency/1000)*t(:,3)')/(upSamplingFrequency/1000); %make sure that the maximal resolution is in units of upSampling frequency
    
    nNeurons=size(icCh,1);
    
    %calculate matrix with all avg spike shapes
    allWaveforms=nan(nSamples,nNeurons,nCh);
    for i=1:nNeurons
        allWaveforms(:,i,ch{ic(1,i)}{ic(2,i)})=avgWF{ic(1,i)}{ic(2,i)};
        isNoiseAll(i)=isNoise{ic(1,i)}{ic(2,i)};
    end
    %{
f=figure;
[h,hParent]=spikeDensityPlotPhysicalSpace([],upSamplingFrequency,chPar.s2r,chPar.En,...
    'hParent',f,'avgSpikeWaveforms',allWaveforms,'logDensity',true);
    %}
    
    %move back to original channel numbers
    ic(1,:)=chPar.s2r(ic(1,:));
else
    ic=[];
    allWaveforms=[];
    isNoiseAll=[];
end
if writeDataToFile
    save(fileNames.fittingFile,'t','ic','allWaveforms','isNoiseAll');
end