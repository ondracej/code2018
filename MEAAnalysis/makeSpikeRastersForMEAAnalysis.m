function [] = makeSpikeRastersForMEAAnalysis()

dbstop if error
%%
prompt = 'How many channels have been sorted? ';

nChansToLoad = cell2mat(inputdlg(prompt));
nChansToLoad = str2double(nChansToLoad);

%nChansToLoad = input(prompt);

%str = input(prompt,'s');

%% Find files to load

for j = 1:nChansToLoad
    
    [file{j},path{j}] = uigetfile;
    
    disp('')
end

%% Find FileNames

ChanText = [];
for j = 1:nChansToLoad
    
    thisName = file{j};
    ChanName{j} = thisName(end-5:end-4);
    ChanText = [ChanText '-' thisName(end-5:end-4)];
end


%% Load files

timeBlock_s = 30;
spikeLimit = 60;

for j = 1:nChansToLoad
    
    d = load([path{j} file{j}]);
    
    fields = fieldnames(d);
    
    %eval(['dataLength = size(d.' cell2mat(fields) ',2)'])
    eval(['units = d.' cell2mat(fields) '(:,2);']);
    eval(['timestamps_s = d.' cell2mat(fields) '(:,3);']);
    eval(['spikeWaveforms = d.' cell2mat(fields) '(:,4:end);']);
    uniqueUnits = unique(units);
    nUnits = numel(uniqueUnits);
    
    allTimestamps_s  = [];
    for o = 1:nUnits
        thisUnit = uniqueUnits(o);
        allTimestamps_inds = find(units == thisUnit);
        allTimestamps_s{o} = timestamps_s(allTimestamps_inds);
        allSpikeWaveforms{o} = spikeWaveforms(allTimestamps_inds,:);
     %   meanWaveform{o} = nanmedian(spikeWaveforms(allTimestamps_inds,:), 1);
    end
    
    if j ==1
        maxTimestamp = max(timestamps_s);
        maxTime_s = ceil(maxTimestamp);
        TOn=0:timeBlock_s:maxTime_s;
    end
    
    TimestampsOverChans{j} = allTimestamps_s;
end


%%
cnt = 1;
TimestampsFinal = []; ChanNamesFinal = [];
for j = 1:nChansToLoad
    
    theseTimestamps = TimestampsOverChans{j};
    
    nSpikes = [];
    for k = 1: size(theseTimestamps, 2)
        timestamps = theseTimestamps{1,k};
        nSpikes = numel(timestamps);
        
        
        if nSpikes > spikeLimit
            TimestampsFinal{cnt} = timestamps;
            ChanNamesFinal{cnt} = ChanName{j};
            cnt = cnt+1;
        end
    end
    
end

p = numSubplots(numel(TimestampsFinal));
figH = figure(102); clf
figHH = figure(103); clf


for i=1:numel(TimestampsFinal)
    
    timestampsToPlot = TimestampsFinal{i};
    
    cnt = 1;
    figure(figH);
    subplot(p(1),p(2),i)
    hold on
    allSpksFR = [];
    for q = 1:size(TOn, 2)-1
        spks = timestampsToPlot(find(timestampsToPlot >= TOn(q) & timestampsToPlot <= TOn(q+1)))-TOn(q)';
        
        ypoints = ones(1, numel(spks))*cnt;
        hold on
        plot(spks, ypoints, 'k.', 'linestyle', 'none', 'MarkerFaceColor','k','MarkerEdgeColor','k')
        
        allSpksFR(q) = numel(spks)/timeBlock_s;
        
        cnt = cnt +1;
    end
    axis tight
    xlim([0 timeBlock_s]);
    set(gca, 'YDir','reverse')
    title(['Ch-' ChanNamesFinal{i} ' | n = ' num2str(numel(timestampsToPlot))])
    yticks = get(gca, 'ytick');
    yticklabs = yticks*timeBlock_s;
    ytickLabs = num2cell(yticklabs);
    %B=cellfun(@num2str,ytickLabs,'un',0);
    set(gca, 'Yticklabel',ytickLabs)
    xlabel('Time (s)')
    ylabel('Time (s)')
    
    %%
    figure(figHH);
    %subplot(1, 2, 1)
    hold on
    plot(smooth(allSpksFR), 'linewidth', 2)
    %subplot(1, 2, 2)
    %hold on
    %plot(smooth(meanWaveform{i}), 'linewidth', 2)
end
figure(figHH);
axis tight
xticks = get(gca, 'xtick');
xticklabs = xticks*timeBlock_s;
xtickLabs = num2cell(xticklabs);

set(gca, 'Xticklabel',xtickLabs)
xlabel('Time (s)')
ylabel('Firing rate (Hz)')
legend(ChanNamesFinal)
legend boxoff
title('Firing Rate')

%% Printing figures

ctext  ='C';
FileSearch = find(file{1}==ctext);
ExpDate = file{1}(1:FileSearch-2);

figure(figHH);
% Create textbox
annotation(figHH,'textbox',...
    [0.015 0.98 0.20 0.03],...
    'String',{ExpDate},...
    'LineStyle','none',...
    'FitBoxToText','off');

saveName = [path{1} ExpDate '_CH' ChanText '__FR'];
plotpos = [0 0 12 10];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);

figure(figH);
% Create textbox
annotation(figH,'textbox',...
    [0.015 0.98 0.20 0.03],...
    'String',{ExpDate},...
    'LineStyle','none',...
    'FitBoxToText','off');

saveName = [path{1} ExpDate '_CH' ChanText '__Raster'];
plotpos = [0 0 15 12];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);










end
