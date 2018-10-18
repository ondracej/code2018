function [h,hParent,hScaleBar]=spikeDensityPlotPhysicalSpace(spikeShapes,Fs,ch,En,varargin)
% [h,hParent,hScaleBar]=spikeDensityPlotPhysicalSpace(spikeShapes,Fs,ch,En,varargin)
% [nSpikeSamples,nSpikes,nCh]
%default argumnets
avgSpikeWaveforms = [];
hParent = [];
lineWidth = 2;
lineColor=[0.85 0.325 0.098];
yl = [];
scaleBar = true;
plotChannelNumbers = true;
logDensity=true;
cmap=lines(64);

%% Output list of default variables
%print out default arguments and values if no inputs are given
if nargin==0
    defaultArguments=who;
    for i=1:numel(defaultArguments)
        eval(['defaultArgumentValue=' defaultArguments{i} ';']);
        if numel(defaultArgumentValue)==1
            disp([defaultArguments{i} ' = ' num2str(defaultArgumentValue)]);
        else
            fprintf([defaultArguments{i} ' = ']);
            disp(defaultArgumentValue);
        end
    end
    return;
end

%Collects all options
for i=1:2:length(varargin)
    eval([varargin{i} '=' 'varargin{i+1};'])
end

%calculate general variables
if ~isempty(spikeShapes)
    [nSpikeSamples,nSpikes,nCh]=size(spikeShapes);
else
    [nSpikeSamples,~,nCh]=size(avgSpikeWaveforms);
end
sampleTimes=((1:nSpikeSamples)/Fs*1000)';

%calculate the surrounding channel grid according to channel layout
En=flipud(En);
for i=1:numel(ch)
    [xCh(i),yCh(i)]=find(En==ch(i));
end
xCh=xCh-min(xCh)+1;
yCh=yCh-min(yCh)+1;
n=max(yCh);
m=max(xCh);

%check if first argument is a valid parent handle, else make one
if isempty(hParent)
    hParent=figure('position',[100 200 1000 800]);
end
%P = panel(hParent);
%P.pack(m,n);
%P.margin=0.005;

%calculate limits for plot
if isempty(yl)
    if ~isempty(avgSpikeWaveforms)
        yl=[min(avgSpikeWaveforms(:)-10) max(avgSpikeWaveforms(:)+10)];
    else
        yl=[min(spikeShapes(:)) max(spikeShapes(:))];
    end
end

%plot channels
for i=1:nCh
    %h(i)=P(yCh(i),xCh(i)).select();
    h(i)=subaxis(hParent,m,n,yCh(i),xCh(i),'S',0.002,'M',0.002);
    if ~isempty(spikeShapes)
        hist2(sampleTimes*ones(1,nSpikes),squeeze(spikeShapes(:,:,i)),'c1',sampleTimes,'n2',100,'h',h(i),'logColorScale',logDensity,'plotColorBar',0);
    end
    hold on;
    if ~isempty(avgSpikeWaveforms)
        plot(sampleTimes,squeeze(avgSpikeWaveforms(:,:,i)),'lineWidth',lineWidth);
    end
    if plotChannelNumbers
        text(sampleTimes(1)+(sampleTimes(end)-sampleTimes(1))*0.1,yl(1)+(yl(2)-yl(1))*0.13,num2str(ch(i)),'fontWeight','bold','fontSize',10);
    end
    ylim(yl);
    xlim(sampleTimes([1 end]));
    set(h(i),'YTickLabel',[]);
    set(h(i),'XTickLabel',[]);
    hold off;
end

%add scale bar to plot
if scaleBar
    [yCorder]=max(yCh(xCh==m));
    [~,pCh]=find(xCh==m & yCh==yCorder);
    if yCorder<n
        [hScaleBar]=addScaleBar(h(pCh),'scaleFac',8,'xShift',1);
    else
        [hScaleBar]=addScaleBar(h(pCh),'scaleFac',5);
    end
end