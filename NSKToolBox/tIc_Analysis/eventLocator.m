%[BS,BP,BE,BI,BCM]=eventLocator(I,t,ic,minSBWnd,minSBInterval,varargin)
% Function purpose : Removes single spikes from CAI data by removing isolated spikes with low activity around them
%
% Function recives :    I - activity intensity file
%                       t [ms] - firing times
%                       ic - index channel
%                       minSBWnd - the window length on which activity is examined [ms]
%                       minSBInterval - collapses SB with intervals less than minSBInterval into one SB
%                       	varargin: 'property name',property value (see list of properties in default values)
%                           sigma=5; %gaussian width in convolution
%                           smoothFuncNBins=61; %number of samples in the gaussian function for convolution
%                           res=10; % resolution of SB detection
%                           stdThresh=2; %the threshold for rejecting noise in the floating median filter
%                           medianWindow=10000; %[ms] the window for floating median
%                           plotResults=0; %whether to plot the results of event detection
%                           mergeAccordingToEventCenter=0; %whether to merge events according to distances between event centers of event edges
%
% Function give back :  BS [ms] - the start times of SBs
%                       BP [ms] - the peak times of SBs
%                       BE [ms] - the end times of SBs
%                       BI [input votage units] - the total intensity of the SB
%                       BCM [ms] - the time of the event center of mass
%
% Last updated : 29/01/14
function [BS,BP,BE,BI,BCM,Act,mAct]=eventLocator(I,t,ic,minSBWnd,minSBInterval,varargin)
%default variables
sigma=5; %gaussian width in convolution
smoothFuncNBins=61; %number of samples in the gaussian function for convolution
res=10; % resolution of SB detection
addToSides=500; %[ms] widening of burst period in ms.
stdThresh=2; %the threshold for rejecting noise in the floating median filter
medianWindow=10000; %[ms] the window for floating median
plotResults=0; %whether to plot the results of event detection
mergeAccordingToEventCenter=0; %whether to merge events according to distances between event centers of event edges

%sanity checks
BP=[];BS=[];BE=[];BI=[];
if isempty(t) || isempty(I) || isempty(ic)
    BP=[];BS=[];BE=[];BI=[];
    disp('One of the input vectors is empty');
    return;
end
if any(isnan(t)) || any(isnan(I))
    BP=[];BS=[];BE=[];
    disp('Input arrays have NaNs');
    return;
end

%Collects all options
for i=1:2:length(varargin)
    eval([varargin{i} '=' 'varargin{i+1};'])
end

addToSidesRes=round(addToSides/res);
medianWindowRes=round(medianWindow/res);

SmoothFunc=fspecial('gaussian', [1 smoothFuncNBins], sigma);
LSmoothFunc=length(SmoothFunc);
SmoothFuncOffset=ceil(LSmoothFunc/2);

NChannels=size(ic,2);

LKern=round(minSBWnd/res);
if LKern/2==round(LKern/2)   %make sure that the kernel is odd in length
    LKern=1+round(minSBWnd/res);
end

MaxT=max(t);

[t,p]=sort(t);
I=I(p);
ic=[1;1;1;numel(t)];
clear p;

Act=squeeze(BuildBurstMatrixA(ic,round(t/res),I,0,round(MaxT/res)))';
Act=convn(Act,SmoothFunc,'same');
mAct = median_filter(Act,medianWindowRes);
sAct = median_filter(abs(mAct),medianWindowRes) / 0.6745;
nSamples=numel(Act);

ActBinary=Act>(mAct+stdThresh*sAct);
ActBinary([1:(medianWindowRes/2) end+1-(medianWindowRes/2):end])=false;

BS=find(diff([0 ActBinary])>0);%SB beginnings
BE=find(diff([ActBinary 0])<0);%SB endings
BM=(BS+BE)/2;%SB middles

if isempty(BS) || isempty(BE),
    fprintf('\nChannel %d %d has only single spikes and consequently was not analyzed',ic(1:2,i));
    BI=[];
    BP=[];
else
    %Collapse SBs with intervals less than minSBInterval into one SB (decision is made according to distances between peaks)
    %decision can also be diverted to distances between endings and beginnings
    M=round(minSBInterval/res);
    if mergeAccordingToEventCenter
        Changes=diff(BM);
    else %merges according to start and end points
        Changes=BS(2:end)-BE(1:end-1);
    end
    Back=[2*M Changes(1:end)];
    Forward=[Changes(1:end) 2*M];
    BBeginners=(Back>=M & Forward<M);
    BEnders=(Back<M & Forward>=M);
    %BMiddles=(Back<M & Forward<M);
    BRegular=(Back>=M & Forward>=M);
    
    BS=BS((BRegular | BBeginners)>0); % Marks the beginning  of a SBE sequence
    BE=BE((BRegular | BEnders)>0); % Marks the end of the SBE sequence
    NSBs=length(BS);
    
    %separate the first and last events to prevent checking limit cases
    for j=1:NSBs
        pBS=(BS(j)-addToSidesRes):BS(j);
        pBS(pBS<=0)=1;
        pBE=BE(j):(BE(j)+addToSidesRes);
        pBE(pBE>nSamples)=nSamples;
        
        BS(j)=BS(j)-addToSidesRes+find([0 Act(pBS)]<=[1 mAct(pBS)],1,'last');
        BE(j)=BE(j)+find([Act(pBE) 0]<=[mAct(pBE) 1],1,'first');
        
        pTmp=BS(j):BE(j);
        tmpEvent=Act(pTmp);
        BI(j)=sum(tmpEvent);
        BCM(j)=round(sum(tmpEvent.*pTmp)/sum(tmpEvent)); %calculate center of mass
        [~,pPeak]=max(tmpEvent); %calculate center of mass
        BP(j)=pTmp(pPeak);
    end
    BS(BS<=0)=1;
    BE(BE>=nSamples)=nSamples;
    
    if plotResults
        figure('position',[50 100 1800 800]);
        subplot(2,2,1:2);
        plot((1:numel(Act))*res/1000,Act);hold on;
        plot((1:numel(Act))*res/1000,mAct,'c');
        plot((1:numel(Act))*res/1000,mAct+stdThresh*sAct,'m');
        plot(BS*res/1000,Act(BS),'og','linewidth',2);
        plot(BP*res/1000,Act(BP),'ok','linewidth',2);
        plot(BE*res/1000,Act(BE),'or','linewidth',2);
        xlabel('Time [s]');
        ylabel('Activity intensity');
        l=legend('AI','median','MAD','start','CM','end');
        set(l,'box','off');
       
        binsInHist=max(10,numel(BS)/30);
        subplot(2,2,3);
        hist(BI,binsInHist);
        xlabel('Event intensity');
        ylabel('number of events');
        
        subplot(2,2,4);
        hist((BE-BS)*res,binsInHist);
        xlabel('Event duration [ms]');
        ylabel('number of events');
    end
    BS=BS*res-res/2;
    BE=BE*res+res/2;
    BP=BP*res-res/2;
end
