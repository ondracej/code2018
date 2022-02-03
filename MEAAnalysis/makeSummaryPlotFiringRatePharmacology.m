function [] = makeSummaryPlotFiringRatePharmacology()

dbstop if error

dataDir = 'Z:\JanieData\Alina-MeaData\20211129\Spikeoutput\new 16\';

%Channel = 87;

%chanSet = [14 16 24 25 27 35 37 43 45 47 62 67 77];
%chanSet = [24 55 56 36 75];
%chanSet = [45 54 67 68];
%chanSet = [37 41 53 68 77 86];
%chanSet = [36 53 77];

chanSet = [16];
 
nChans = numel(chanSet);

for q = 1:nChans
    
    Channel = chanSet(q);
    
    %SaveName = '20210816-5HT1A-Ch87';
    %SaveName = '20210817-5HT2C-Ch78';
    %SaveName = '20210819-5HT1D-Ch77';
    %SaveName = '20210820-5HT-Ch75';
    %SaveName = '20210824-ACh-Ch87';
    %SaveName = ['20210902-NE-Ch' num2str(Channel) '-2'];
    SaveName = ['20211129--Ch' num2str(Channel) '-NEW'];
    
    %baselineMatfile = '20210824-1123_CH-32-33-41-42-47-58-62-65-67-68-75-76-78-87-_SpikeData__87.mat';
    %drugMatfile = '20210824-1134-ACh_CH-32-33-41-42-48-58-62-65-66-75-76-78-87-_SpikeData__87.mat';
    %recoveryMatfile = '20210824-1145-recovery_CH-32-33-42-48-62-65-68-72-75-76-82-87-_SpikeData__87.mat';
    
      baselineMatfile = ['new20211129-1353_CH-16-26-32-36-37-38-41-42-45-46-47-77-84-87-_SpikeData__' num2str(Channel) '.mat'];
    drugMatfile = ['new20211129-1353drug_CH-16-26-32-36-37-38-41-42-45-46-47-77-84-87-_SpikeData__' num2str(Channel) '.mat'];
    recoveryMatfile = ['new20211129-1353rec_CH-16-26-32-36-37-38-41-42-45-46-47-77-84-87-_SpikeData__' num2str(Channel) '.mat'];

%        baselineMatfile = ['20210824-1542_CH-24-33-44-55-56-58-63-68-75-_SpikeData__' num2str(Channel) '.mat'];
%     drugMatfile = ['20210824-1553-ACh_CH-24-33-44-55-56-58-63-68-75-_SpikeData__' num2str(Channel) '.mat'];
%     recoveryMatfile = ['20210824-1604-recovery_CH-24-31-52-55-56-63-75-_SpikeData__' num2str(Channel) '.mat'];
%  
    %%
    
    bD = load([dataDir baselineMatfile]);
    dD = load([dataDir drugMatfile]);
      rD = load([dataDir recoveryMatfile]);
    
    bD_fields = fieldnames(bD);
    dD_fields = fieldnames(dD);
    rD_fields = fieldnames(rD);
    
    %%
    eval(['bD_units = bD.' cell2mat(bD_fields) '(:,2);']);
    eval(['bD_timestamps_s_all = bD.' cell2mat(bD_fields) '(:,3);']);
    eval(['bD_spikeWaveforms = bD.' cell2mat(bD_fields) '(:,4:end);']);
    
    eval(['dD_units = dD.' cell2mat(dD_fields) '(:,2);']);
    eval(['dD_timestamps_s_all = dD.' cell2mat(dD_fields) '(:,3);']);
    eval(['dD_spikeWaveforms = dD.' cell2mat(dD_fields) '(:,4:end);']);
    
    eval(['rD_units = rD.' cell2mat(rD_fields) '(:,2);']);
    eval(['rD_timestamps_s_all = rD.' cell2mat(rD_fields) '(:,3);']);
    eval(['rD_spikeWaveforms = rD.' cell2mat(rD_fields) '(:,4:end);']);
    
    %% Find the Inds that are the correct spike sorting
    
    bD_chans_present = unique(bD_units);
    dD_chans_present = unique(dD_units);
    rD_chans_present = unique(rD_units);
    
    %%
    
%     bD_chan1_inds = find(bD_units ==1);
%     dD_chan1_inds = find(dD_units ==1);
%     rD_chan1_inds = find(rD_units ==1);
    
    bD_chan1_inds = find(bD_units ==1);
    dD_chan1_inds = find(dD_units ==1);
    rD_chan1_inds = find(rD_units ==1);
    
    %bD_chan1_inds = 1:1:numel(bD_units);
    %dD_chan1_inds = 1:1:numel(dD_units);
    %rD_chan1_inds = 1:1:numel(rD_units);
    
    bD_timestamps_s = bD_timestamps_s_all(bD_chan1_inds);
    bD_spikeWaveforms = bD_spikeWaveforms(bD_chan1_inds,:);
    
    %figure; plot(bD_spikeWaveforms')
    
    dD_timestamps_s = dD_timestamps_s_all(dD_chan1_inds);
    dD_spikeWaveforms = dD_spikeWaveforms(dD_chan1_inds,:);
    
    rD_timestamps_s = rD_timestamps_s_all(rD_chan1_inds);
    rD_spikeWaveforms = rD_spikeWaveforms(rD_chan1_inds,:);
    
    %% Find max timestamps
    
    bD_timestamps_s_max = max(bD_timestamps_s_all);
    dD_timestamps_s_max = max(dD_timestamps_s_all);
    rD_timestamps_s_max = max(rD_timestamps_s_all);
    
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
    
    allFRMax = ceil(max(cell2mat(allFRs)));
    
    %% Plotting waveforms
    figH = figure(103); clf
    subplot(3, 6, [1 2])
    plot(bD_spikeWaveforms(1:end,:)', 'k');
    axis tight
    ylim([-5e4 5e4])
    title(['Baseline: Ch-' num2str(Channel)])
    xlabel('Samples')
    ylabel('Waveform')
    subplot(3, 6, [3 4])
    plot(dD_spikeWaveforms(1:end,:)', 'k');
    axis tight
    ylim([-5e4 5e4])
    title(['Drug: Ch-' num2str(Channel)])
    xlabel('Samples')
    ylabel('Waveform')
    subplot(3, 6, [5 6])
    plot(rD_spikeWaveforms(1:end,:)', 'k');
    axis tight
    ylim([-5e4 5e4])
    title(['Recovery: Ch-' num2str(Channel)])
    xlabel('Samples')
    ylabel('Waveform')
    %% PLotting firing rates
    
    subplot(3, 6, 7)
    plot(allFRs{1}, 'k.', 'linestyle', '-')
    axis tight
    ylim([0 allFRMax])
    xlim([0 11])
    xlabel('Time (min)')
    ylabel('Firing Rate (Hz)')
    line([5 5], [0 allFRMax], 'color', [0.5 0.5 0.5], 'linestyle', ':')
    title(['n = ' num2str(size(bD_spikeWaveforms,1)) ' spikes']);
    
    pre = allFRs{1}(1:5);
    post = allFRs{1}(6:end);
    subplot(3, 6, 8);
    toPlot = [mean(pre) ; mean(post)];
    errs = [std(pre) ; std(post)];
    bar(toPlot, 'FaceColor','k')
    hold on
    errorbar([1 2],toPlot,errs,'k','MarkerSize',5,'MarkerEdgeColor','k','MarkerFaceColor','k')
    set(gca, 'xticklabel', {'Pre', 'Post'})
    ylabel('Firing Rate (Hz)')
    ylim([0 allFRMax])
    %%
    subplot(3, 6, 9)
    plot(allFRs{2}, 'k.', 'linestyle', '-')
    axis tight
    ylim([0 allFRMax])
    xlim([0 11])
    xlabel('Time (min)')
    ylabel('Firing Rate (Hz)')
    line([5 5], [0 allFRMax], 'color', [0.5 0.5 0.5], 'linestyle', ':')
    title(['n = ' num2str(size(dD_spikeWaveforms, 1)) ' spikes']);
    
    pre = allFRs{2}(1:5);
    post = allFRs{2}(6:end);
    subplot(3, 6, 10);
    toPlot = [mean(pre) ; mean(post)];
    errs = [std(pre) ; std(post)];
    bar(toPlot, 'FaceColor',[0 .5 .5])
    hold on
    errorbar([1 2],toPlot,errs,'k','MarkerSize',5,'MarkerEdgeColor','k','MarkerFaceColor','k')
    set(gca, 'xticklabel', {'Pre', 'Post'})
    ylabel('Firing Rate (Hz)')
    ylim([0 allFRMax])
    %%
    subplot(3, 6, 11)
    plot(allFRs{3}, 'k.', 'linestyle', '-')
    axis tight
    ylim([0 allFRMax])
    xlim([0 11])
    xlabel('Time (min)')
    ylabel('Firing Rate (Hz)')
    line([5 5], [0 allFRMax], 'color', [0.5 0.5 0.5], 'linestyle', ':')
    title(['n = ' num2str(size(rD_spikeWaveforms, 1)) ' spikes']);
    
    pre = allFRs{3}(1:5);
    post = allFRs{3}(6:end);
    subplot(3, 6, 12);
    toPlot = [mean(pre) ; mean(post)];
    errs = [std(pre) ; std(post)];
    bar(toPlot, 'FaceColor','k')
    hold on
    errorbar([1 2],toPlot,errs,'k','MarkerSize',5,'MarkerEdgeColor','k','MarkerFaceColor','k')
    set(gca, 'xticklabel', {'Pre', 'Post'})
    ylabel('Firing Rate (Hz)')
    ylim([0 allFRMax])
    
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
    ylim([0 allFRMax])
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


end
