function []=spikePostProcessingNSK(dataRecordingObj,chPar,fileNames,varargin)
%default variables
fastPrinting=false;
maxSpikes2Present=1000;
plotAllAvgSpikeTemplates=true;
extractFilteredWaveformsFromSpikeTimes=true;
extractRawLongWaveformsFromSpikeTimes=true;

filteredSNRStartEnd=[-1 1];
rawSNRStartEnd=[5 40];

plotFilteredWaveforms=true;
plotRawLongWaveforms=true;
plotSpikeReliability=true;

preFiltered=2;
windowFiltered=5;

preRaw=10;
windowRaw=90;

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

nCh=numel(chPar.s2r);

if isempty(sortingDir)
    writeDataToFile=false;
else
    if nargout>0
        error('No output variables are allowed in save data to disk option')
    end
    writeDataToFile=true;
end

if plotRawLongWaveforms || plotFilteredWaveforms %calculate figure aspect ration based on electrode layout
    [mElecs,nElecs]=size(dataRecordingObjEn);
    figurePosition=[100 50 min(1000,100*mElecs) min(900,100*nElecs)];
end
fprintf('\nPost processing spikes...');

highPassPassCutoff=200;
highPassStopCutoff=190;
lowPassPassCutoff=3000;
lowPassStopCutoff=3100;
attenuationInHighpass=4;
attenuationInLowpass=4;
%construct filtering object
Fs=dataRecordingObj.samplingFrequency;
FilterObj=filterData(Fs);
%FilterObj.highPassPassCutoff=highPassPassCutoff;
%FilterObj.highPassStopCutoff=highPassStopCutoff;
%FilterObj.lowPassPassCutoff=lowPassPassCutoff;
%FilterObj.lowPassStopCutoff=lowPassStopCutoff;
%FilterObj.attenuationInHighpass=attenuationInHighpass;
%FilterObj.attenuationInLowpass=attenuationInLowpass;

FilterObj.highPassCutoff=highPassPassCutoff;
FilterObj.lowPassCutoff=lowPassPassCutoff;
FilterObj.filterOrder=8;
FilterObj=FilterObj.designBandPass;

load(fileNames.fittingFile,'t','ic','allWaveforms','isNoiseAll');
[nSamples,nNeurons,nCh]=size(allWaveforms);

if ~isempty(ic)
    neuronNames=ic(1:2,:);
else
    neuronNames=[];
end

if extractRawLongWaveformsFromSpikeTimes
    avgLongWF=zeros(nNeurons,nCh,windowRaw*dataRecordingObj.samplingFrequency/1000);
    stdLongWF=zeros(nNeurons,nCh,windowRaw*dataRecordingObj.samplingFrequency/1000);
    PSDSNR=zeros(1,nNeurons);
else
    avgLongWF=[];stdLongWF=[];PSDSNR=[];
end
if extractFilteredWaveformsFromSpikeTimes
    avgFinalWF=zeros(nNeurons,nCh,windowFiltered*dataRecordingObj.samplingFrequency/1000);
    stdFinalWF=zeros(nNeurons,nCh,windowFiltered*dataRecordingObj.samplingFrequency/1000);
    spkSNR=zeros(1,nNeurons);
    nSpkTotal=zeros(1,nNeurons);
    spkMaxAmp=zeros(1,nNeurons);
else
    avgFinalWF=[];stdFinalWF=[];spkSNR=[];nSpkTotal=[];spkMaxAmp=[];
end
    
for i=1:nNeurons
    tTmp=t(ic(3,i):ic(4,i));
    nSpk=numel(tTmp);
    if extractRawLongWaveformsFromSpikeTimes
        [V_uV,T_ms]=dataRecordingObj.getData(dataRecordingObj.channelNumbers,tTmp(1:min(nSpk,maxSpikes2Present))-preRaw,windowRaw);
        
        %standard deviation
        stdLongWF(i,:,:)=squeeze(std(V_uV,[],2));
        
        %average substruction mean
        avgLongWF(i,:,:)=squeeze(median(V_uV,2));
        tmpMean=mean(avgLongWF(i,:,T_ms<(preRaw-1)),3); %calculate the baseline according to the average voltage before the spike (1ms before spike peak)
        V_uV=bsxfun(@minus,V_uV,tmpMean');
        avgLongWF(i,:,:)=bsxfun(@minus,avgLongWF(i,:,:),tmpMean);
        
        p=find(T_ms>rawSNRStartEnd(1) & T_ms<=rawSNRStartEnd(2)); %find relevant time points surrounding the spike
        tmpSNR=avgLongWF(i,chPar.surChExtVec{ic(1,i)},p)./stdLongWF(i,chPar.surChExtVec{ic(1,i)},p); %calculated at the position of the extended grid
        PSDSNR(i)=mean(abs(tmpSNR(:)));
        
        if plotRawLongWaveforms
            
            f=figure('position',figurePosition);
            neuronString=['Neu ' num2str(ic(1,i)) '-' num2str(ic(2,i))];
            infoStr={['nSpk=' num2str(nSpk)],neuronString,['noise=' num2str(isNoiseAll(i))]};
            
            [h,hParent]=spikeDensityPlotPhysicalSpace(permute(V_uV,[3 2 1]),dataRecordingObj.samplingFrequency,chPar.s2r,chPar.En,...
                'hParent',f,'avgSpikeWaveforms',permute(avgLongWF(i,:,:),[3 1 2]),'logDensity',true);
            
            annotation('textbox',[0.01 0.89 0.1 0.1],'FitHeightToText','on','String',infoStr);
            
            printFile=[sortingDir filesep 'neuron' neuronString '-spikeShapeRaw'];
            
            set(f,'PaperPositionMode','auto');
            print(printFile,'-djpeg','-r300');
            close(f);
        end
    end
    
    if extractFilteredWaveformsFromSpikeTimes
        if extractRawLongWaveformsFromSpikeTimes
            [V_uV,T_ms]=FilterObj.getFilteredData(V_uV( : , : , T_ms>=(preRaw-preFiltered) & T_ms<(preRaw-preFiltered+windowFiltered)));
        else
            [V_uV,T_ms]=FilterObj.getFilteredData(dataRecordingObj.getData(dataRecordingObj.channelNumbers,tTmp(1:min(nSpk,maxSpikes2Present))-preFiltered,windowFiltered));
        end
        
        avgFinalWF(i,:,:)=squeeze(median(V_uV,2));
        stdFinalWF(i,:,:)=squeeze(std(V_uV,[],2));
        
        p=find(T_ms>filteredSNRStartEnd(1) & T_ms<=filteredSNRStartEnd(2)); %find relevant time points surrounding the spike
        tmpSNR=avgFinalWF(i,chPar.surChExtVec{ic(1,i)}(chPar.pSurCh{ic(1,i)}),p)./stdFinalWF(i,chPar.surChExtVec{ic(1,i)}(chPar.pSurCh{ic(1,i)}),p); %calculated at the positions of the surrounding grid
        spkSNR(i)=abs(mean(tmpSNR(:)));
        
        spkMaxAmp(i)=max(max(abs(avgFinalWF(i,:,:)))); %the extremal spike amplitude
        nSpkTotal(i)=ic(4,i)-ic(3,i)+1;
        
        if plotFilteredWaveforms
            
            f=figure('position',figurePosition);
            neuronString=['Neu ' num2str(ic(1,i)) '-' num2str(ic(2,i))];
            infoStr={['nSpk=' num2str(nSpk)],neuronString,['noise=' num2str(isNoiseAll(i))]};
            
            [h,hParent]=spikeDensityPlotPhysicalSpace(permute(V_uV,[3 2 1]),dataRecordingObj.samplingFrequency,chPar.s2r,chPar.En,...
                'hParent',f,'avgSpikeWaveforms',permute(avgFinalWF(i,:,:),[3 1 2]),'logDensity',true);
            
            annotation('textbox',[0.01 0.89 0.1 0.1],'FitHeightToText','on','String',infoStr);
            
            %print to file
            printFile=[sortingDir filesep 'neuron' neuronString '-spikeShape'];
            set(f,'PaperPositionMode','auto');
            print(printFile,'-djpeg','-r300');
            close(f);
        end
    end
end %loop over all neurons
    
save(fileNames.postProcessignAnalysisFile,'avgFinalWF','stdFinalWF','avgLongWF','stdLongWF','neuronNames','preFiltered','windowFiltered','preRaw','windowRaw',...
        'spkMaxAmp','nSpkTotal','spkSNR','PSDSNR','-v7.3');
    
if plotAllAvgSpikeTemplates
    nPlotAxis=min(ceil(sqrt(nNeurons)),5);
    nPlotsPerFigure=nPlotAxis.^2;
    if nNeurons>0
        for i=1:(nNeurons+1)
            if mod((i-1),nPlotsPerFigure)==0 || i==(nNeurons+1)
                if i~=1
                    printFile=[sortingDir filesep 'avgSpikeShapes' num2str(ceil((i-1)/nPlotsPerFigure))];
                    if fastPrinting
                        imwrite(frame2im(getframe(f)),[printFile '.jpeg'],'Quality',90);
                    else
                        set(f,'PaperPositionMode','auto');
                        print(printFile,'-djpeg','-r300');
                    end
                    close(f);
                end
                if i~=(nNeurons+1)
                    f=figure('position',figurePosition);
                end
            end
            if i<nNeurons
                neuronString=['Neu ' num2str(ic(1,i)) '-' num2str(ic(2,i)),',N' num2str(isNoiseAll(i))];
                h=subaxis(f,nPlotAxis,nPlotAxis,mod(i,nPlotsPerFigure),'S',0.02,'M',0.02);
                activityTracePhysicalSpacePlot(h,chPar.s2r,0.03*squeeze(allWaveforms(:,i,:))',chPar.En,'scaling','none');
                text(0,0,neuronString);
            elseif i==nNeurons
                neuronString=['Neu ' num2str(ic(1,i)) '-' num2str(ic(2,i)),',N' num2str(isNoiseAll(i))];
                h=subaxis(f,nPlotAxis,nPlotAxis,nNeurons,'S',0.02,'M',0.02);
                activityTracePhysicalSpacePlot(h,chPar.s2r,0.03*squeeze(allWaveforms(:,i,:))',chPar.En,'scaling','none');
                text(0,0,neuronString);
            end
        end
    end
end

if plotSpikeReliability
    if nNeurons>0
        f=figure('position',[300 50 900 700]);
        mNSpkTotal=mean(nSpkTotal);
        %generate size legend
        plotSpikeSNR=[spkSNR (max(spkSNR)-(max(spkSNR)-min(spkSNR))*0.01)*ones(1,5)];
        plotPSDSNR=[PSDSNR [0.9 1 1.1 1.2 1.3]*((max(PSDSNR)+min(PSDSNR))/2)];
        legendSpikeNums=round([mNSpkTotal/6 mNSpkTotal/3 mNSpkTotal mNSpkTotal*3 mNSpkTotal*6]);
        plotnSpkTotal=[nSpkTotal legendSpikeNums];
        plotspkMaxAmp=[spkMaxAmp ones(1,5)*min(spkMaxAmp)];
        
        scatter(plotSpikeSNR,plotPSDSNR,(plotnSpkTotal/mNSpkTotal)*50+5,plotspkMaxAmp,'linewidth',2);
        text(plotSpikeSNR(end-4:end)*1.02,plotPSDSNR(end-4:end),num2str(legendSpikeNums'/(dataRecordingObj.recordingDuration_ms/1000),3),'FontSize',8)
        xlabel('$$\sqrt{SNR_{spike}}$$','Interpreter','latex','FontSize',14);ylabel('$$\sqrt{SNR_{PSD}}$$','Interpreter','latex','FontSize',14);
        cb=colorbar('position',[0.8511    0.6857    0.0100    0.2100]);ylabel(cb,'Max spk. amp.');
        
        printFile=[sortingDir filesep 'SNR_spikePSD'];
        set(f,'PaperPositionMode','auto');
        print(printFile,'-djpeg','-r300');
    end
end


%Plots for testing
%{

for i=1:numel(pV)
    for j=1:p(pV(i))
        h=subaxis(nPlots,nPlots,c,'S',0.03,'M',0.03);
        activityTracePhysicalSpacePlot(h,ch{pV(i)}{j},0.03*squeeze(avgWF{pV(i)}{j})',chPar.rEn,'scaling','none');
        title([num2str(pV(i)) '-' num2str(j)]);
        c=c+1;
    end
end
%}
