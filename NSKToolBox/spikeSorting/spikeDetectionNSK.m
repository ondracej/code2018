function [OutPar]=spikeDetectionNSK(dataRecordingObj,chPar,fileNames,varargin)
%Todo:
%Add detection of multiple spikes
chunkOverlap=1; %ms

upSamplingFrequency=60000; %only for the channel on which spikes are detected - must be a multiple of sampling frequency

%for using a 16 bit signed integer to represent the spike shapes
maxSpikeAmp=1000;
nQuantizationBits=16;

gaussianityWindowMs=20;%ms
dataFileFolder=[];

preSpikeMs=2;%ms
postSpikeMs=3;%ms
spikeTimeShiftIntervalMs=1;%ms - the maximal interval on which the global spike minima is calculated
peakDetectionSmoothingTimeScale=0.3; %ms - the smoothing scale for detection of the exact spike occurance

kurtosisNoiseThreshold=3;
spikeDetectionThresholdStd=5;
maxChunkSize=2*60*1000; %[ms]
minimumDetectionIntervalMs=0.5;%ms
removeSpikesNotExtremalOnGrid=true; %removes all spike that have a stronger minimum on another channel surrounding the detection channel on the grid

highPassPassCutoff=200;
highPassStopCutoff=190;
lowPassPassCutoff=3000;
lowPassStopCutoff=3100;
attenuationInHighpass=4;
attenuationInLowpass=4;

%print out default arguments and values if no inputs are given
if nargin==0
    defaultArguments=who;
    for i=1:numel(defaultArguments)
        eval(['defaultArgumentValue=' defaultArguments{i} ';']);
        disp([defaultArguments{i} ' = ' num2str(defaultArgumentValue)]);
    end
    return;
end

%determine quantization
int2uV=maxSpikeAmp/2^(nQuantizationBits-1);

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



%Collects all options
for i=1:2:length(varargin)
    eval([varargin{i} '=' 'varargin{i+1};'])
end

%start spike detection
fprintf('\nRunning spike detection on %s...',dataRecordingObj.dataFileNames{1}); 

upSamplingFactor=upSamplingFrequency/Fs;
if upSamplingFactor~=round(upSamplingFactor) %check that upsampling factor is an integer
    upSamplingFactor=round(upSamplingFactor);
    disp(['upSampling factor was not an integer and was rounded to: ' num2str(upSamplingFactor)]);
end

gaussianityWindow=gaussianityWindowMs/1000*Fs;
testSamples=gaussianityWindow*1000;

preSpikeSamples=preSpikeMs/1000*Fs; %must be > spikePeakInterval
postSpikeSamples=postSpikeMs/1000*Fs; %must be > spikePeakInterval
spikeTimeShiftIntervalSamples=spikeTimeShiftIntervalMs/1000*Fs;
postSpikeSamplesInitial=postSpikeSamples+spikeTimeShiftIntervalSamples;

timeVec=-preSpikeSamples:postSpikeSamplesInitial;
intrpTimeVec=timeVec(1):(1/upSamplingFactor):timeVec(end);
pZeroTimeVec=find(intrpTimeVec>=0,1,'first');

preSpikeSamplesIntrp=preSpikeSamples*upSamplingFactor; %must be > spikePeakInterval
postSpikeSamplesIntrp=postSpikeSamples*upSamplingFactor; %must be > spikePeakInterval
spikeTimeShiftIntervalIntrp=spikeTimeShiftIntervalSamples*upSamplingFactor; %must be > spikePeakInterval

minimumDetectionIntervalSamplesIntrp=minimumDetectionIntervalMs/1000*Fs*upSamplingFactor;
peakDetectionSmoothingSamples=round(peakDetectionSmoothingTimeScale/1000*Fs*upSamplingFactor);
peakSmoothingKernel=fspecial('gaussian', [3*peakDetectionSmoothingSamples 1] ,peakDetectionSmoothingSamples);

%determine the chunck size
if maxChunkSize>dataRecordingObj.recordingDuration_ms
    startTimes=0;
    endTimes=dataRecordingObj.recordingDuration_ms;
else
    startTimes=0:maxChunkSize:dataRecordingObj.recordingDuration_ms;
    endTimes=[startTimes(2:end)-chunkOverlap dataRecordingObj.recordingDuration_ms];
end
nChunks=numel(startTimes);

nCh=numel(chPar.s2r);

matFileObj=cell(1,nCh);
if isempty(dataFileFolder) %if saving data is not required
    writeDataToFile=false;
    spikeShapesAll=cell(nCh,nChunks);
    spikeTimesAll=cell(nCh,nChunks);
else
    if nargout>0
        error('No output variables are allowed in save data to disk option')
    end
    writeDataToFile=true;
    for i=find(fileNames.spikeDetectionExist==0)
        matFileObj{i} = matfile(fileNames.spikeDetectionFile{i},'Writable',true);
        matFileObj{i}.spikeShapes=zeros(preSpikeSamplesIntrp+postSpikeSamplesIntrp,0,chPar.nValidChExt(i),'int16');
    end
end

%initiate arrays
Th=zeros(nCh,nChunks);nCumSpikes=zeros(1,nCh);
fprintf('\nExtracting spikes from chunks (total %d): ',nChunks);
for j=1:nChunks
    fprintf('%d ',j);
    %get data
    MAll=squeeze(FilterObj.getFilteredData(dataRecordingObj.getData(chPar.s2r(1:nCh),startTimes(j),endTimes(j)-startTimes(j))))';
    nSamples=size(MAll,1);
    for i=find(fileNames.spikeDetectionExist==0) %go over all channels that require rewriting
        %get local data
        Mlong=MAll(:,chPar.surChExtVec{i});
        
        %estimate channel noise
        tmpData=buffer(Mlong(1:min(testSamples,nSamples),chPar.pCenterCh(i)),gaussianityWindow,gaussianityWindow/2);
        noiseSamples=tmpData(:,kurtosis(tmpData,0)<kurtosisNoiseThreshold);
        noiseStd=std(noiseSamples(:));
        noiseMean=mean(noiseSamples(:));
        Th(i,j)=noiseMean-spikeDetectionThresholdStd*noiseStd;
       
        %find thershold crossings and extract spike windows
        thresholdCrossings=find(Mlong(1:end-1,chPar.pCenterCh(i))>Th(i,j) & Mlong(2:end,chPar.pCenterCh(i))<Th(i,j));
        thresholdCrossings=thresholdCrossings(thresholdCrossings>preSpikeSamples & thresholdCrossings<nSamples-postSpikeSamplesInitial);
        %plot(Mlong(:,chPar.pCenterCh(i)));hold on;line([0 size(Mlong,1)],[Th(i,j) Th(i,j)],'color','r');plot(thresholdCrossings+1,Mlong(thresholdCrossings+1,chPar.pCenterCh(i)),'og');
        
        %extract upsample and allign spikes
        startSamplesInM=[];startSamplesInIdx=[];
        if ~isempty(thresholdCrossings)
            %upsample
            startSamplesInM(1,1,:)=(0:nSamples:(nSamples*(chPar.nValidChExt(i)-1)));
            idx=bsxfun(@plus,bsxfun(@plus,thresholdCrossings',(-preSpikeSamples:postSpikeSamplesInitial)'), startSamplesInM );
            M=Mlong(idx);
            
            %upsample data
            M = interp1(timeVec, M, intrpTimeVec, 'spline');
            nSamplesShort=size(M,1);
            
            %allign spike windows to spike extrema
            Msmooth = convn(M((pZeroTimeVec+1):(pZeroTimeVec+spikeTimeShiftIntervalIntrp),:,chPar.pCenterCh(i)), peakSmoothingKernel, 'same');
            [spikeAmp,shift]=min(Msmooth);
            
            spikeTimesTmp=startTimes(j)+(thresholdCrossings'+shift/upSamplingFactor)/Fs*1000; %[ms]
            
            nSamplesPerCh=numel(spikeTimesTmp)*nSamplesShort;
            startSamplesInIdx(1,1,:)=(0:nSamplesPerCh:nSamplesPerCh*chPar.nValidChExt(i)-1);
            
            idx=bsxfun(@plus , bsxfun(@plus,pZeroTimeVec+shift+(0:nSamplesShort:(nSamplesPerCh-1)),(-preSpikeSamplesIntrp:(postSpikeSamplesIntrp-1))') , startSamplesInIdx);
            M=M(idx);
            %figure;plotShifted(reshape(permute(M,[1 3 2]),[size(M,1)*size(M,3) size(M,2)]),'verticalShift',30);line([(chPar.pCenterCh(i)-1)*size(M,1) chPar.pCenterCh(i)*size(M,1)],[0 0],'color','g','lineWidth',3); 
            %ii=2;h=axes;activityTracePhysicalSpacePlot(h,chPar.surChExtVec{i},squeeze(M(:,ii,:))',chPar.rEn);
            
            if removeSpikesNotExtremalOnGrid
                %check for a minimum (negative spike peak) over all channels to detect the channel with the strongest amplitude for each spike
                [maxV,maxP]=min(   min(    M((preSpikeSamplesIntrp-minimumDetectionIntervalSamplesIntrp):(preSpikeSamplesIntrp+minimumDetectionIntervalSamplesIntrp),:,:)   ,[],1)    ,[],3);
                p=(maxP==chPar.pCenterCh(i));
                M=M(:,p,:);
                spikeTimesTmp=spikeTimesTmp(p'); %the p' is important to create a 1-0 empty matrix (not 0-1) which cell2mat can handle
            end
            spikeTimesAll{i,j}=spikeTimesTmp;
            if writeDataToFile
                tmpSpikeCount=numel(spikeTimesTmp);
                if numel(spikeTimesTmp)>0
                    nCumSpikes(i)=nCumSpikes(i)+numel(spikeTimesTmp);
                    matFileObj{i}.spikeShapes(:,(nCumSpikes(i)-tmpSpikeCount+1):nCumSpikes(i),:)=int16(M./int2uV);
                end
            else
                spikeShapesAll{i,j}=int16(M./int2uV);
            end
        else
            spikeTimesAll{i,j}=[];
            if ~writeDataToFile
                spikeShapesAll{i,j}=[];
            end
        end
    end
end
clear MAll Mlong M;

if writeDataToFile %write files to disk
    for i=find(fileNames.spikeDetectionExist==0)
        matFileObj{i}.Th=Th(i,:);
        
        matFileObj{i}.spikeTimes=cell2mat(spikeTimesAll(i,:));
        matFileObj{i}.preSpikeSamplesIntrp=preSpikeSamplesIntrp;
        matFileObj{i}.postSpikeSamplesIntrp=postSpikeSamplesIntrp;
        matFileObj{i}.upSamplingFrequency=upSamplingFrequency;
        matFileObj{i}.minimumDetectionIntervalSamplesIntrp=minimumDetectionIntervalSamplesIntrp;
        matFileObj{i}.int2uV=int2uV;
    end
else %keep files in memory
    OutPar.spikeShapes=cell(1,nCh);
    OutPar.spikeTimes=cell(1,nCh);
    for i=find(fileNames.spikeDetectionExist>0)
        OutPar.spikeShapes{i}=cell2mat(spikeShapesAll(i,:));
        OutPar.spikeTimes{i}=cell2mat(spikeTimesAll(i,:));
    end
    OutPar.Th=Th;
    
    OutPar.preSpikeSamplesIntrp=preSpikeSamplesIntrp;
    OutPar.postSpikeSamplesIntrp=postSpikeSamplesIntrp;
    OutPar.minimumDetectionIntervalSamplesIntrp=minimumDetectionIntervalSamplesIntrp;
    OutPar.upSamplingFrequency=upSamplingFrequency;
    OutPar.int2uV=int2uV;
end