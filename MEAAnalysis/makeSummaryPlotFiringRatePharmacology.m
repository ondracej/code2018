function [] = makeSummaryPlotFiringRatePharmacology()

dataDir = 'Z:\JanieData\JessicaMeaData\20210816\Spike_Output_new\Sorted_Spikes\';

Channel = 87;
SaveName = '20210816-5HT1A-Ch87';

baselineMatfile = '20210816-1441_CH-56-57-87-_SpikeData__87.mat';
drugMatfile = '20210816-1453-5HT1A_CH-56-57-71-87-_SpikeData__87.mat';
recoveryMatfile = '20210816-1507-recovery_CH-14-23-56-57-87-_SpikeData__87.mat';

%%

bD = load([dataDir baselineMatfile]);
dD = load([dataDir drugMatfile]);
rD = load([dataDir recoveryMatfile]);

bD_fields = fieldnames(bD);
dD_fields = fieldnames(dD);
rD_fields = fieldnames(rD);

%%
eval(['bD_units = bD.' cell2mat(bD_fields) '(:,2);']);
eval(['bD_timestamps_s = bD.' cell2mat(bD_fields) '(:,3);']);
eval(['bD_spikeWaveforms = bD.' cell2mat(bD_fields) '(:,4:end);']);
    
eval(['dD_units = dD.' cell2mat(dD_fields) '(:,2);']);
eval(['dD_timestamps_s = dD.' cell2mat(dD_fields) '(:,3);']);
eval(['dD_spikeWaveforms = dD.' cell2mat(dD_fields) '(:,4:end);']);

eval(['rD_units = rD.' cell2mat(rD_fields) '(:,2);']);
eval(['rD_timestamps_s = rD.' cell2mat(rD_fields) '(:,3);']);
eval(['rD_spikeWaveforms = rD.' cell2mat(rD_fields) '(:,4:end);']);

%% Find max timestamps

bD_timestamps_s_max = max(bD_timestamps_s);
dD_timestamps_s_max = max(dD_timestamps_s);
rD_timestamps_s_max = max(rD_timestamps_s);

minVal = min([ bD_timestamps_s_max dD_timestamps_s_max rD_timestamps_s_max]);

%%
timeWin_s = 60;
tOn = 1:timeWin_s:minVal;
allSpks = [];
allFRs = [];

for j = 1:3
    
    switch j
        case 1
            data = bD_timestamps_s;
        case 2
            data = dD_timestamps_s;
        case 3
            data = rD_timestamps_s;
    end
    
    spks = [];
    for k = 1:numel(tOn)-1
        
        roi_start = tOn(k);
        roi_stop = tOn(k)+timeWin_s-1;
        spks(k) = numel(find(data >= roi_start & data <=roi_stop));
        
    end
    
    allSpks{j} = spks;
    allFRs{j} = spks./timeWin_s;
end


%%
figH = figure(103); clf
subplot(3, 6, [1 2])
plot(bD_spikeWaveforms(1:100,:)', 'k');
axis tight
ylim([-5e4 5e4])
title(['Baseline: Ch-' num2str(Channel)])
xlabel('Samples')
ylabel('Waveform')
subplot(3, 6, [3 4])
plot(dD_spikeWaveforms(1:100,:)', 'k');
axis tight
ylim([-5e4 5e4])
title(['Drug: Ch-' num2str(Channel)])
xlabel('Samples')
ylabel('Waveform')
subplot(3, 6, [5 6])
plot(rD_spikeWaveforms(1:100,:)', 'k');
axis tight
ylim([-5e4 5e4])
title(['Recovery: Ch-' num2str(Channel)])
xlabel('Samples')
ylabel('Waveform')
%%

subplot(3, 6, 7)
plot(allFRs{1}, 'k.', 'linestyle', '-')
axis tight
ylim([0 5])
xlim([0 11])
xlabel('Time (min)')
ylabel('Firing Rate (Hz)')
line([5 5], [0 5], 'color', [0.5 0.5 0.5], 'linestyle', ':')

pre = allFRs{1}(1:5);
post = allFRs{1}(6:10);
subplot(3, 6, 8);
toPlot = [mean(pre) ; mean(post)];
errs = [std(pre) ; std(post)];
bar(toPlot, 'FaceColor','k')
hold on
errorbar([1 2],toPlot,errs,'k','MarkerSize',5,'MarkerEdgeColor','k','MarkerFaceColor','k')
set(gca, 'xticklabel', {'Pre', 'Post'})
ylabel('Firing Rate (Hz)')
ylim([0 5])
%%
subplot(3, 6, 9)
plot(allFRs{2}, 'k.', 'linestyle', '-')
axis tight
ylim([0 5])
xlim([0 11])
xlabel('Time (min)')
ylabel('Firing Rate (Hz)')
line([5 5], [0 5], 'color', [0.5 0.5 0.5], 'linestyle', ':')

pre = allFRs{2}(1:5);
post = allFRs{2}(6:10);
subplot(3, 6, 10);
toPlot = [mean(pre) ; mean(post)];
errs = [std(pre) ; std(post)];
bar(toPlot, 'FaceColor',[0 .5 .5])
hold on
errorbar([1 2],toPlot,errs,'k','MarkerSize',5,'MarkerEdgeColor','k','MarkerFaceColor','k')
set(gca, 'xticklabel', {'Pre', 'Post'})
ylabel('Firing Rate (Hz)')
ylim([0 5])
%%
subplot(3, 6, 11)
plot(allFRs{3}, 'k.', 'linestyle', '-')
axis tight
ylim([0 5])
xlim([0 11])
xlabel('Time (min)')
ylabel('Firing Rate (Hz)')
line([5 5], [0 5], 'color', [0.5 0.5 0.5], 'linestyle', ':')

pre = allFRs{3}(1:5);
post = allFRs{3}(6:10);
subplot(3, 6, 12);
toPlot = [mean(pre) ; mean(post)];
errs = [std(pre) ; std(post)];
bar(toPlot, 'FaceColor','k')
hold on
errorbar([1 2],toPlot,errs,'k','MarkerSize',5,'MarkerEdgeColor','k','MarkerFaceColor','k')
set(gca, 'xticklabel', {'Pre', 'Post'})
ylabel('Firing Rate (Hz)')
ylim([0 5])

%%
subplot(3, 6, [15 16])

xes_n = numel(allFRs{1}); 
xes = ones(1, xes_n);

toPlot  = [mean(allFRs{1}) ; mean(allFRs{2}) ; mean(allFRs{3})];
bar(toPlot)
hold on
plot(xes, allFRs{1}, 'k.')
hold on
plot(xes*2, allFRs{2}, 'r.')
plot(xes*3, allFRs{3}, 'k.')
set(gca, 'xtick', [1 2 3])
set(gca, 'xticklabel', {'Baseline', 'Drug', 'Recovery'})
xlim([0 4])
ylim([0 5])
title('Firing rate summary')
ylabel('Firing Rate (Hz)')
%%
[h1, p1] = ttest(allFRs{1},  allFRs{2});
[h2, p2] = ttest(allFRs{3},  allFRs{2});
[h3, p3] = ttest(allFRs{1},  allFRs{3});

Name = {'Baseline-Drug';'Recovery-Drug';'Baseline-Recovery'};
h = [h1;h2;h3];
p = [p1;p2;p3];
T = table(h,p,'RowNames',Name);


ha = subplot(3, 6, [17 18]);
pos = get(ha,'Position');
un = get(ha,'Units');
delete(ha)

ht = uitable('Data',T{:,:},'ColumnName',T.Properties.VariableNames,...
    'RowName',T.Properties.RowNames,'Units', un, 'Position',pos);
ha = subplot(3, 6, [17 18]);
title(['T-test statistics - ' SaveName])
axis off
%%

  saveName = [dataDir SaveName '_SummaryPlot'];
   
    plotpos = [0 0 40 15];
    
    print_in_A4(0, saveName, '-djpeg', 0, plotpos);



end