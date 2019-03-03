function [] = runJaniesAnalysis_batchProcess_JanieFinalAnalysis()

%close all;
dbstop if error
%%

doPrint = 1;

%%

switch gethostname
    case {'DEADPOOL'}
        
        dataDir = '/home/janie/Data/TUM/OTAnalysis/CombinedDataSets_JanieFeb/Data/';
        saveDir = '/home/janie/Data/TUM/OTAnalysis/CombinedDataSets_JanieFeb/Data/Figs/';
        
    case {'TURTLE'}
        dataDir = ['/home/janie/Dropbox/00_Conferences/2018_FENS/HansaData/DataToUse/passt/'];
        saveDir = '/home/janie/Data/TUM/OT/OTData/FigsHansaFeb2019/';
end

trialSeach = ['*.mat*'];

trialNamesStruct = dir(fullfile(dataDir, trialSeach));
nTrials = numel(trialNamesStruct);
for j = 1:nTrials
    trialNames{j} = trialNamesStruct(j).name;
end

%%

for s =9:nTrials
    
    filToLoad = trialNames{s};
    saveName = filToLoad(1:23);
    D.INFO.saveName{s} = saveName;
    data=load([dataDir filToLoad]);
    
    %%
    combinedSPKS = data.combinedSPKS;
    
    stimNames = data.OBJS.dataSet1.C_OBJ.S_SPKS.SORT.allSpksStimNames;
    
    stimNamesFlip = flipud(stimNames);
    
    %%
    n_elev = size(combinedSPKS, 1);
    n_azim = size(combinedSPKS, 2);
    
    n_stims = n_elev*n_azim;  % Number of stims minus the silent stim (199) %gibt die Stimulusanzahl an. Bei (data,2) ist die Anzahl der Stimuli hinterlegt: (9 Elevation* 22 Azimuth) + den Nullstimulus
    n_reps = numel(combinedSPKS{1}); % 11th positions gives number of repetitions
    sweepLengths_ms = 1000* data.OBJS.dataSet1.C_OBJ.SETTINGS.EpocheLength;
    fs = data.OBJS.dataSet1.C_OBJ.SETTINGS.SampleRate;
    
    D.INFO.saveName{s} = saveName;
    D.INFO.n_stims(s) = n_stims;
    D.INFO.n_reps(s) = n_reps;
    D.INFO.sweepLengths_ms(s) = sweepLengths_ms;
    D.INFO.n_elev(s) = n_elev;
    D.INFO.n_azim(s) = n_azim;
    
    %% HardCoded Response Windows for Hansa's data
    
    spkWin_ms = 50;
    
    tOn = 1:spkWin_ms:sweepLengths_ms;
    nSkpWins = numel(tOn);
    
    D.INFO.spkWin_ms(s) = spkWin_ms;
    
    
    
    %% aSRFs
    
    
    allSpks = flipud(combinedSPKS); % We do this to make sure negative elevation is on the bottom
    
    spkCnt_stims = [];
    perWin_stims_mean = [];
    perWin_stims_sum = [];
    perWin_stims_std = [];
    
    for elev = 1:n_elev
        for azim = 1:n_azim
            theseSpks = allSpks{elev, azim};
            
            for r = 1:n_reps
                
                spks_samps = theseSpks{r};
                spks_ms = (spks_samps/fs)*1000;
                
                for o = 1:nSkpWins
                    
                    spkCnt_reps(o) = numel(spks_ms(spks_ms >= (tOn(o)-1) & spks_ms < (tOn(o)+spkWin_ms-1)));
                end
                
                spkWinsOverReps(r,:) = spkCnt_reps;
                
            end
            
            
            spkCnt_stims{elev, azim} = spkWinsOverReps;
            perWin_stims_mean{elev, azim} = nanmean(spkWinsOverReps, 1);
            perWin_stims_sum{elev, azim} = sum(spkWinsOverReps, 1);
            perWin_stims_std{elev, azim} = nanstd(spkWinsOverReps);
            
            %SpkWinSums{azim, elev} = perWin_stims_sum{ct}(o);
            %ct = ct+1;
            
        end
        
    end
    
    D.DATA.spkCnt_stims{s} = spkCnt_stims;
    D.DATA.perWin_stims_mean{s} = perWin_stims_mean;
    D.DATA.perWin_stims_sum{s} = perWin_stims_sum;
    D.DATA.perWin_stims_std{s} = perWin_stims_std;
    
    %%
    allSpkWinSums_raw = [];
    allSpkWinSums_rot_Smooth = [];
    for o = 1:nSkpWins
        SpkWinSums = [];
        for elev = 1:n_elev
            for azim = 1:n_azim
                
                SpkWinSums(elev,azim) =  perWin_stims_sum{elev, azim}(o);
                
            end
        end
        
        allSpkWinSums_raw{o} = SpkWinSums;
        
        %bla_smooth = rot90(moving_average2(SpkWinSums(:,:),1,1));
        %bla = (rot90(SpkWinSums));
        
        bla_smooth = moving_average2(SpkWinSums(:,:),1,1);
        bla = SpkWinSums;
        
        minVal_raw(o) = min(min(bla));
        maxVal_raw(o) = max(max(bla));
        
        minVal_smooth(o) = min(min(bla_smooth));
        maxVal_smooth(o) = max(max(bla_smooth));
        
        %allSpkWinSums_rot{o} = rot90(SpkWinSums);
        allSpkWinSums_rot{o} = (SpkWinSums);
        %allSpkWinSums_rot_Smooth{o} = rot90(moving_average2(SpkWinSums(:,:),1,1));
        allSpkWinSums_rot_Smooth{o} = moving_average2(SpkWinSums(:,:),1,1);
        
        
    end
    
    
    D.DATA.allSpkWinSums_raw{s} = allSpkWinSums_raw;
    D.DATA.allSpkWinSums_rot{s} = allSpkWinSums_rot;
    D.DATA.allSpkWinSums_rot_Smooth{s} = allSpkWinSums_rot_Smooth;
    
    %These are the max/mion values over all the time windows
    
    MIN_smooth = min(minVal_smooth);
    MAX_smooth = max(maxVal_smooth);
    
    MIN_raw = min(minVal_raw);
    MAX_raw = max(maxVal_raw);
    
    D.DATA.MIN_smooth(s) = MIN_smooth;
    D.DATA.MAX_smooth(s) = MAX_smooth;
    D.DATA.MIN_raw(s) = MIN_raw;
    D.DATA.MAX_raw(s) = MAX_raw;
    
    clims = [0 1];
    
    figH = figure(100);clf
    for o = 1:nSkpWins
        
        
        subplot(nSkpWins, 1, o)
        
        
        dataToPlot_smooth =  allSpkWinSums_rot_Smooth{o};
        dataToPlot_smooth_norm = (dataToPlot_smooth-MIN_smooth) / (MAX_smooth - MIN_smooth);
        
        
        max(dataToPlot_smooth_norm);
        surf(dataToPlot_smooth_norm);
        shading interp
        view([ 0 90])
        axis tight
        caxis(clims)
        
        set(gca,'ytick',[])
        set(gca,'xtick',[])
        xlabel('Azimuth')
        ylabel('Elevation')
        
        colorbar
        if o ==1
            title(saveName)
        end
        
        
    end
    
    %%
    if doPrint
        
        disp('Printing Plot')
        set(0, 'CurrentFigure', figH)
        
        dropBoxSavePath = [saveDir saveName '-vertASRFs'];
        
        plotpos = [0 0 12 40];
        print_in_A4(0, dropBoxSavePath , '-djpeg', 0, plotpos);
        
        disp('')
        
    end
    
    %%
    
    stimInds = [3 4];
    spontInds = [1 2 5 6];
    
    
    azPlots = n_azim;
    elPlots = n_elev;
    
    buff_size = .005;
    
    button_width = .80/azPlots;
    button_height = .85/elPlots;
    
    top_button_height = .88;
    left_button_start = .02;
    
    %%
    figH1 = figure(124);clf
    
    StimWinSpikesSums = allSpkWinSums_rot{stimInds(1)};
    
    for azim = 1:n_azim
        for elev = 1:n_elev
            
            %% starting from top left
            
            if elev ==1
                y_start = top_button_height;
            else
                %y_start = 1-(TopBuff+row*plot_height+(row-1)*spacer_buffer);
                y_start = (top_button_height-(elev-1)*button_height) - (elev-1)*buff_size; % minus becuse values decreasing
                %y_start = top_button_height-(elev-1)*button_height;
            end
            
            if azim ==1
                x_start = left_button_start;
            else
                %x_start = left_button_start+((azim-1)*button_width);
                x_start = (left_button_start+(azim-1)*button_width) + (azim-1)*buff_size; % plus becuse values increasing
            end
            
            pos = [x_start y_start button_width button_height];
            axes('position',pos );
            
            %%
            nSpksdots = StimWinSpikesSums(elev, azim);
            
            x=rand(1,nSpksdots);
            y=rand(1,nSpksdots);
            scatter(x,y, 'k.')
            %axis off
            set(gca, 'Yticklabel', '')
            set(gca, 'Xticklabel', '')
            
            if azim ==1 && elev == 13
                xlabel('-180 az')
            end
            
            if azim ==33 && elev == 13
                xlabel('+180 az')
            end
            
            if azim ==1 && elev == 1
                ylabel('+67.5 el')
            end
            
            if azim ==1 && elev == 13
                ylabel('-67.5 el')
            end
            
            if azim ==17 && elev == 13
                xlabel('0 az')
            end
            
            if azim ==1 && elev == 7
                ylabel('0 el')
            end
            
        end
    end
    
    
    % Create textbox
    annotation(figH1,'textbox',...
        [0.020 0.96 0.43 0.03],...
        'String',saveName,...
        'LineStyle','none',...
        'FitBoxToText','off');
    
    if doPrint
        
        disp('Printing Plot')
        set(0, 'CurrentFigure', figH1)
        
        dropBoxSavePath = [saveDir saveName '-rasterMatrix'];
        
        plotpos = [0 0 30 20];
        print_in_A4(0, dropBoxSavePath , '-djpeg', 0, plotpos);
        
        disp('')
        
    end
    
    
    
    %%
    
    D.INFO.stimInds{s} = stimInds;
    D.INFO.spontInds{s} = spontInds;
    
    figH = figure(200); clf
    ColorSet = varycolor(nSkpWins);
    allSummedAz = [];
    allSummedEL = [];
    for o = 1:nSkpWins
        
        if ismember(o, stimInds)
            col = 'b';
        else
            col = 'k';
        end
        
        
        dataToPlot = allSpkWinSums_rot{o};
        dataToPlot_norm = (dataToPlot-MIN_raw) / (MAX_raw - MIN_raw);
        
        El_sum = sum(dataToPlot, 2);
        El_std = nanstd(dataToPlot');
        El_mean = nanmean(dataToPlot, 2);
        El_sem = El_std/(sqrt(numel(El_std)));
        
        allSummedEL(:,o) = El_sum;
        
        %         subplot(2, 3, 1)
        %         hold on
        %         xes = numel(El_sum):-1:1;
        %         plot(smooth(El_sum), xes , 'Color', col, 'linewidth', 1);
        %         %plot(smooth(El_sum), xes , 'ko-', 'linewidth', 1);
        %         axis tight
        %         %xlim([0 1])
        %         line([0 max(El_sum)], [5 5], 'color', 'k', 'linestyle', ':')
        
        subplot(2, 2, 1)
        hold on
        xes = numel(El_mean):-1:1;
        
        
        %plot(smooth(El_mean), xes , 'Color', col, 'linewidth', 1);
        plot(xes,smooth(El_mean), 'Color', col, 'linewidth', 1);
        
        jbfill(xes,(smooth(El_mean)+El_sem')',(smooth(El_mean)-El_sem')',[.5,0.5,.5],[.5,0.5,.5],[],.3);
        %plot(smooth(El_mean), xes , 'ko-', 'linewidth', 1);
        axis tight
        %xlim([0 1])
        line([7 7], [0 max(El_mean)], 'color', 'k', 'linestyle', ':')
        view([90 90])
        title('Mean Elevation')
        
        Az_sum = sum(dataToPlot, 1);
        Az_std = nanstd(dataToPlot);
        Az_mean = nanmean(dataToPlot, 1);
        Az_sem = Az_std/(sqrt(numel(Az_std)));
        
        allSummedAz(:,o) = Az_sum;
        
        %         subplot(2, 3, 4)
        %         hold on
        %         xes = 1:1:numel(Az_sum);
        %         plot(xes, smooth(Az_sum), 'Color', col, 'linewidth', 1);
        %         %plot(xes, smooth(Az_sum), 'ko-', 'linewidth', 1);
        %         axis tight
        %         %ylim([0 1])
        %         line([11 11], [0 max(Az_sum)], 'color', 'k', 'linestyle', ':')
        
        
        subplot(2, 2, 3)
        hold on
        
        xes = 1:1:numel(Az_mean);
        plot(xes, smooth(Az_mean), 'Color', col, 'linewidth', 1);
        jbfill(xes,(smooth(Az_mean)+Az_sem')',(smooth(Az_mean)-Az_sem')',[.5,0.5,.5],[.5,0.5,.5],[],.3);
        
        
        %plot(xes, smooth(Az_mean)+Az_std', 'Color', col, 'linewidth', 1);
        %plot(xes, smooth(Az_mean)-Az_std', 'Color', col, 'linewidth', 1);
        
        %plot(xes, smooth(Az_mean), 'ko-', 'linewidth', 1);
        axis tight
        %ylim([0 1])
        line([17 17], [0 max(Az_mean)], 'color', 'k', 'linestyle', ':')
        title('Mean Azimuth')
        
    end
    
    
    subplot(2, 2, 1);
    set(gca, 'xTick',[1:numel(El_mean)]) % this is actually the x axes because we do the 90 rotation
    set(gca,'xTickLabel',{'-67.5';'';'';'-33.75';'';'';'0';'';'';'-33.75';'';'';'67.5';});
    xlabel('Spike count')
    
    subplot(2, 2, 3)
    set(gca, 'XTick',[1:numel(Az_mean)]);
    set(gca,'XTickLabel',{'-180';'';'';'';'';'';'';'';'-90';'';'';'';'';'';'';'';'0';'';'';'';'';'';'';'';'90';'';'';'';'';'';'';'';'180';});
    ylabel('Spike count')
    
    %bla = {'-180';'';'';'';'';'';'';'';'-90';'';'';'';'';'';'';'';'0';'';'';'';'';'';'';'';'90';'';'';'';'';'';'';'';'180';}
    D.DATA.allSummedEL{s} = allSummedEL;
    D.DATA.allSummedAz{s} = allSummedAz;
    
    
    %% EL
    
    EL_stimTrials = flipud(allSummedEL(:, stimInds));
    EL_spontTrials = flipud(allSummedEL(:, spontInds));
    
    mean_EL_stimTrials = mean(EL_stimTrials, 2);
    std_EL_stimTrials = nanstd(EL_stimTrials');
    sem_EL_stimTrials = std_EL_stimTrials  /(sqrt(numel(std_EL_stimTrials)));
    
    mean_EL_spontTrials = mean(EL_spontTrials, 2);
    std_EL_spontTrials = nanstd(EL_spontTrials');
    sem_EL_spontTrials = std_EL_spontTrials  /(sqrt(numel(std_EL_spontTrials)));
    
    D.DATA.mean_EL_stimTrials{s} = mean_EL_stimTrials;
    D.DATA.sem_EL_stimTrials{s} = sem_EL_stimTrials;
    
    D.DATA.mean_EL_spontTrials{s} = mean_EL_spontTrials;
    D.DATA.sem_EL_spontTrials{s} = sem_EL_spontTrials;
    
    subplot(2, 2, 2)
    ValsEL = [mean_EL_stimTrials mean_EL_spontTrials]';
    ValsEL_err = [sem_EL_stimTrials' sem_EL_spontTrials']';
    
    barweb(ValsEL', ValsEL_err', 1, [], [], [], [], bone, [], []);
    %barweb(barplotZ, barplotZsem, .8, [], [], [], [], bone, [], [])
    view([90 90])
    title('Elevation | Stim and Spont')
    xlabel('Mean Spike Count')
    %% AZ
    
    AZ_stimTrials = allSummedAz(:, stimInds);
    AZ_spontTrials = allSummedAz(:, spontInds);
    
    mean_AZ_stimTrials = mean(AZ_stimTrials, 2);
    std_AZ_stimTrials = nanstd(AZ_stimTrials');
    sem_AZ_stimTrials = std_AZ_stimTrials  /(sqrt(numel(std_AZ_stimTrials)));
    
    mean_AZ_spontTrials = mean(AZ_spontTrials, 2);
    std_AZ_spontTrials = nanstd(AZ_spontTrials');
    sem_AZ_spontTrials = std_AZ_spontTrials  /(sqrt(numel(std_AZ_spontTrials)));
    
    D.DATA.mean_AZ_stimTrials{s} = mean_AZ_stimTrials;
    D.DATA.sem_AZ_stimTrials{s} = sem_AZ_stimTrials;
    
    D.DATA.mean_AZ_spontTrials{s} = mean_AZ_spontTrials;
    D.DATA.sem_AZ_spontTrials{s} = sem_AZ_spontTrials;
    
    subplot(2, 2, 4)
    ValsAZ = [mean_AZ_stimTrials mean_AZ_spontTrials]';
    ValsAZ_err = [sem_AZ_stimTrials' sem_AZ_spontTrials']';
    
    barweb(ValsAZ', ValsAZ_err', 1, [], [], [], [], bone, [], []);
    title('Mean spike count | Stim and Spont')
    ylabel('Mean Spike Count')
    %barweb(barplotZ, barplotZsem, .8, [], [], [], [], bone, [], [])
    
    %xTICKS = get(gca, 'xticks');
    
    %%
    if doPrint
        disp('Printing Plot')
        set(0, 'CurrentFigure', figH)
        
        dropBoxSavePath = [saveDir saveName '-barplots'];
        
        plotpos = [0 0 40 20];
        print_in_A4(0, dropBoxSavePath , '-djpeg', 0, plotpos);
        
        disp('')
    end
    
    %%
    
    figH = figure(591) ;clf
    hold on
    
    smoothWin = 3;
    timepoints = 1:1:numel(mean_AZ_stimTrials);
    
    smoothedMean_stim = smooth(mean_AZ_stimTrials, smoothWin);
    smoothedMean_spont = smooth(mean_AZ_spontTrials, smoothWin);
    
    
    plot(timepoints, smoothedMean_stim, 'b-', 'linewidth', 2)
    plot(timepoints, smoothedMean_spont, 'k-', 'linewidth', 2)
    
    errorbar(timepoints, smoothedMean_stim, sem_AZ_stimTrials, 'b-', 'linewidth', 1)
    errorbar(timepoints, smoothedMean_spont, sem_AZ_spontTrials, 'k-', 'linewidth', 1)
    
    
    [pks,locs,w,p] = findpeaks(smoothedMean_stim, 'MinPeakProminence',1);
    
    [maxPeak, maxind] = max(pks);
    maxWidth = w(maxind);
    maxloc = locs(maxind);
    
    if isempty(pks)
        
        D.DATA.maxPeakStim_AZ(s) = nan;
        D.DATA.maxWidthStim_AZ(s) = nan;
        D.DATA.maxLocStim_AZ(s) = nan;
    else
        D.DATA.maxPeakStim_AZ(s) = maxPeak;
        D.DATA.maxWidthStim_AZ(s) = maxWidth;
        D.DATA.maxLocStim_AZ(s) = maxloc;
    end
    
    skew = skewness(smoothedMean_stim);
    kurt = kurtosis(smoothedMean_stim);
    
    D.DATA.skewStim_AZ(s) = skew;
    D.DATA.kurtStim_AZ(s) = kurt;
    
    hold on
    plot(maxloc, maxPeak, 'rv')
    line([maxloc-maxWidth/2 maxloc+maxWidth/2], [maxPeak maxPeak], 'color', 'r')
    
    % spont trials
    [pks,locs,w,p] = findpeaks(smoothedMean_spont, 'MinPeakProminence',1);
    
    [maxPeak, maxind] = max(pks);
    maxWidth = w(maxind);
    maxloc = locs(maxind);
    
    if isempty(pks)
        
        D.DATA.maxPeakSpont_AZ(s) = nan;
        D.DATA.maxWidthSpont_AZ(s) = nan;
        D.DATA.maxLocSpont_AZ(s) = nan;
    else
        D.DATA.maxPeakSpont_AZ(s) = maxPeak;
        D.DATA.maxWidthSpont_AZ(s) = maxWidth;
        D.DATA.maxLocSpont_AZ(s) = maxloc;
    end
    
    skew = skewness(smoothedMean_spont);
    kurt = kurtosis(smoothedMean_spont);
    
    D.DATA.skewSpont_AZ(s) = skew;
    D.DATA.kurtSpont_AZ(s) = kurt;
    
    hold on
    plot(maxloc, maxPeak, 'rv')
    line([maxloc-maxWidth/2 maxloc+maxWidth/2], [maxPeak maxPeak], 'color', 'r')
    
    axis tight
    set(gca, 'XTick',[1:length(mean_AZ_stimTrials)]);
    set(gca,'XTickLabel',{'-180';'';'';'';'';'';'';'';'-90';'';'';'';'';'';'';'';'0';'';'';'';'';'';'';'';'90';'';'';'';'';'';'';'';'180';});
    
    xlabel('Azimuth')
    ylabel('Mean spike count')
    
    legTxt = [{'Stim', 'Spont'}];
    legend(legTxt )
    legend('boxoff')
    %ylim([0 30])
    
    title([ saveName ' | Peak Azimuth'])
    
    if doPrint
        disp('Printing Plot')
        set(0, 'CurrentFigure', figH)
        
        dropBoxSavePath = [saveDir saveName '-BestAzimuth'];
        
        plotpos = [0 0 15 15];
        print_in_A4(0, dropBoxSavePath , '-djpeg', 0, plotpos);
        
        disp('')
    end
    
    %% Summay plot
    
    figH = figure(294);
    subplot(2, 1, 1)
    hold on
    
    plot(D.DATA.maxLocStim_AZ(s), D.DATA.maxWidthStim_AZ(s), 'b*')
    plot(D.DATA.maxLocSpont_AZ(s), D.DATA.maxWidthSpont_AZ(s), 'ko')
    title('Azimuth')
    ylabel('Width')
    
    
    %% Elevation
    
    
    figH = figure(592) ;clf
    hold on
    
    smoothWin = 3;
    timepoints = 1:1:numel(mean_EL_stimTrials);
    
    smoothedMean_stim = smooth(mean_EL_stimTrials, smoothWin);
    smoothedMean_spont = smooth(mean_EL_spontTrials, smoothWin);
    
    
    plot(timepoints, smoothedMean_stim, 'b-', 'linewidth', 2)
    plot(timepoints, smoothedMean_spont, 'k-', 'linewidth', 2)
    
    errorbar(timepoints, smoothedMean_stim, mean_EL_stimTrials, 'b-', 'linewidth', 1)
    errorbar(timepoints, smoothedMean_spont, mean_EL_spontTrials, 'k-', 'linewidth', 1)
    
    
    [pks,locs,w,p] = findpeaks(smoothedMean_stim, 'MinPeakProminence',1);
    
    
    [maxPeak, maxind] = max(pks);
    maxWidth = w(maxind);
    maxloc = locs(maxind);
    
    if isempty(pks)
        
        D.DATA.maxPeakStim_EL(s) = nan;
        D.DATA.maxWidthStim_EL(s) = nan;
        D.DATA.maxLocStim_EL(s) = nan;
    else
        D.DATA.maxPeakStim_EL(s) = maxPeak;
        D.DATA.maxWidthStim_EL(s) = maxWidth;
        D.DATA.maxLocStim_EL(s) = maxloc;
    end
    
    skew = skewness(smoothedMean_stim);
    kurt = kurtosis(smoothedMean_stim);
    
    D.DATA.skewStim_EL(s) = skew;
    D.DATA.kurtStim_EL(s) = kurt;
    
    hold on
    plot(maxloc, maxPeak, 'rv')
    line([maxloc-maxWidth/2 maxloc+maxWidth/2], [maxPeak maxPeak], 'color', 'r')
    
    % spont trials
    [pks,locs,w,p] = findpeaks(smoothedMean_spont, 'MinPeakProminence',1);
    
    [maxPeak, maxind] = max(pks);
    maxWidth = w(maxind);
    maxloc = locs(maxind);
    
    if isempty(pks)
        
        D.DATA.maxPeakSpont_EL(s) = nan;
        D.DATA.maxWidthSpont_EL(s) = nan;
        D.DATA.maxLocSpont_EL(s) = nan;
    else
        D.DATA.maxPeakSpont_EL(s) = maxPeak;
        D.DATA.maxWidthSpont_EL(s) = maxWidth;
        D.DATA.maxLocSpont_EL(s) = maxloc;
    end
    
    
    skew = skewness(smoothedMean_spont);
    kurt = kurtosis(smoothedMean_spont);
    
    D.DATA.skewSpont_EL(s) = skew;
    D.DATA.kurtSpont_EL(s) = kurt;
    
    hold on
    plot(maxloc, maxPeak, 'rv')
    line([maxloc-maxWidth/2 maxloc+maxWidth/2], [maxPeak maxPeak], 'color', 'r')
    
    axis tight
    set(gca, 'XTick',[1:length(mean_EL_stimTrials)]);
    set(gca,'XTickLabel',{'-67.5';'';'';'-33.75';'';'';'0';'';'';'-33.75';'';'';'67.5';});
    
    xlabel('Elevation')
    ylabel('Mean spike count')
    
    legTxt = [{'Stim', 'Spont'}];
    legend(legTxt )
    legend('boxoff')
    %    ylim([0 30])
    
    title([ saveName ' | Peak Elevation'])
    
    if doPrint
        disp('Printing Plot')
        set(0, 'CurrentFigure', figH)
        
        dropBoxSavePath = [saveDir saveName '-BestElevation'];
        
        plotpos = [0 0 15 15];
        print_in_A4(0, dropBoxSavePath , '-djpeg', 0, plotpos);
        
        disp('')
    end
    
    
    
    figH = figure(294);
    subplot(2, 1, 2)
    hold on
    plot(D.DATA.maxLocStim_EL(s), D.DATA.maxWidthStim_EL(s), 'b*')
    plot(D.DATA.maxLocSpont_EL(s), D.DATA.maxWidthSpont_EL(s), 'ko')
    title('Elevation')
    ylabel('Width')
    
    
    %%
    
    %set(gca, 'YTick',[1:length(ele)]);%17.01.05
    %set(gca,'YTickLabel',{ele});
    
    
    %% D Prime calculation
    AzContra = [1:16]; % 33 total, 17 is 0;
    AzIpsi = [18:33]; % 33 total, 17 is 0;
    ELTop = [1:6]; % 13 total, 7 is 0;
    ELDown = [7:13]; % 13 total, 7 is 0;
    
    D.INFO.AzContra{s} = AzContra;
    D.INFO.AzIpsi{s} = AzIpsi;
    D.INFO.ELTop{s} = ELTop;
    D.INFO.ELDown{s} = ELDown;
    
    %this_d_prime(p, q) = 2 * (meanA - meanB) / sqrt(stdA^2 + stdB^2);
    %% Azimuth
    % During Stim Trials
    AZ_Stim_inds_contra = AZ_stimTrials(AzContra,:);
    AZ_Stim_inds_ispi = AZ_stimTrials(AzIpsi,:);
    
    AZ_Stim_inds_contra_mean = nanmean(nanmean(AZ_Stim_inds_contra));
    AZ_Stim_inds_ispi_mean = nanmean(nanmean(AZ_Stim_inds_ispi));
    
    AZ_Stim_inds_contra_std = nanstd(nanstd(AZ_Stim_inds_contra));
    AZ_Stim_inds_ispi_std = nanstd(nanstd(AZ_Stim_inds_ispi));
    
    D_Az_Stim = 2* (AZ_Stim_inds_contra_mean - AZ_Stim_inds_ispi_mean) / sqrt(AZ_Stim_inds_contra_std^2 + AZ_Stim_inds_ispi_std^2);
    
    % During Spont Trials
    AZ_Spont_inds_contra = AZ_spontTrials(AzContra,:);
    AZ_Spont_inds_ispi = AZ_spontTrials(AzIpsi,:);
    
    AZ_Spont_inds_contra_mean = nanmean(nanmean(AZ_Spont_inds_contra));
    AZ_Spont_inds_ispi_mean = nanmean(nanmean(AZ_Spont_inds_ispi));
    
    AZ_Spont_inds_contra_std = nanstd(nanstd(AZ_Spont_inds_contra));
    AZ_Spont_inds_ispi_std = nanstd(nanstd(AZ_Spont_inds_ispi));
    
    D_Az_Spont = 2* (AZ_Spont_inds_contra_mean - AZ_Spont_inds_ispi_mean) / sqrt(AZ_Spont_inds_contra_std^2 + AZ_Spont_inds_ispi_std^2);
    
    % Pooled Trials
    AZ_All_inds_contra = allSummedAz(AzContra,:);
    AZ_All_inds_ispi = allSummedAz(AzIpsi,:);
    
    AZ_All_inds_contra_mean = nanmean(nanmean(AZ_All_inds_contra));
    AZ_All_inds_ispi_mean = nanmean(nanmean(AZ_All_inds_ispi));
    
    AZ_All_inds_contra_std = nanstd(nanstd(AZ_All_inds_contra));
    AZ_All_inds_ispi_std = nanstd(nanstd(AZ_All_inds_ispi));
    
    D_Az_All = 2* (AZ_All_inds_contra_mean - AZ_All_inds_ispi_mean) / sqrt(AZ_All_inds_contra_std^2 + AZ_All_inds_ispi_std^2);
    
    %% Elevation
    
    % During Stim Trials
    EL_Stim_inds_contra = EL_stimTrials(ELTop,:);
    EL_Stim_inds_ispi = EL_stimTrials(ELDown,:);
    
    EL_Stim_inds_contra_mean = nanmean(nanmean(EL_Stim_inds_contra));
    EL_Stim_inds_ispi_mean = nanmean(nanmean(EL_Stim_inds_ispi));
    
    EL_Stim_inds_contra_std = nanstd(nanstd(EL_Stim_inds_contra));
    EL_Stim_inds_ispi_std = nanstd(nanstd(EL_Stim_inds_ispi));
    
    D_EL_Stim = 2* (EL_Stim_inds_contra_mean - EL_Stim_inds_ispi_mean) / sqrt(EL_Stim_inds_contra_std^2 + EL_Stim_inds_ispi_std^2);
    
    pooled_D_EL_Stim(s) =  D_EL_Stim;
    
    % During Spont Trials
    EL_Spont_inds_contra = EL_spontTrials(ELTop,:);
    EL_Spont_inds_ispi = EL_spontTrials(ELDown,:);
    
    EL_Spont_inds_contra_mean = nanmean(nanmean(EL_Spont_inds_contra));
    EL_Spont_inds_ispi_mean = nanmean(nanmean(EL_Spont_inds_ispi));
    
    EL_Spont_inds_contra_std = nanstd(nanstd(EL_Spont_inds_contra));
    EL_Spont_inds_ispi_std = nanstd(nanstd(EL_Spont_inds_ispi));
    
    D_EL_Spont = 2* (EL_Spont_inds_contra_mean - EL_Spont_inds_ispi_mean) / sqrt(EL_Spont_inds_contra_std^2 + EL_Spont_inds_ispi_std^2);
    
    pooled_D_EL_Spont(s) =  D_EL_Spont;
    
    % Pooled Trials
    EL_All_inds_contra = allSummedAz(ELTop,:);
    EL_All_inds_ispi = allSummedAz(ELDown,:);
    
    EL_All_inds_contra_mean = nanmean(nanmean(EL_All_inds_contra));
    EL_All_inds_ispi_mean = nanmean(nanmean(EL_All_inds_ispi));
    
    EL_All_inds_contra_std = nanstd(nanstd(EL_All_inds_contra));
    EL_All_inds_ispi_std = nanstd(nanstd(EL_All_inds_ispi));
    
    D_EL_All = 2* (EL_All_inds_contra_mean - EL_All_inds_ispi_mean) / sqrt(EL_All_inds_contra_std^2 + EL_All_inds_ispi_std^2);
    
    pooled_D_EL_All(s) =  D_EL_All;
    
    D.DATA.pooled_D_EL_Stim{s} = pooled_D_EL_Stim;
    D.DATA.pooled_D_EL_Spont{s} = pooled_D_EL_Spont;
    D.DATA.pooled_D_EL_All{s} = pooled_D_EL_All;
    
    %%
    figure(120);
    
    hold on
    subplot(3, 1, 1)
    plot(D_Az_Stim, D_EL_Stim, 'b*')
    
    hold on
    subplot(3, 1, 2)
    plot(D_Az_Spont, D_EL_Spont, 'k*')
    
    hold on
    subplot(3, 1, 3)
    plot(D_Az_All, D_EL_All, 'ko')
    
    
    disp('')
end


disp('')

figure(120);

subplot(3, 1, 1)
ylim([-20 20])
xlim([-20 20])
title('Stim D-Prime')

subplot(3, 1, 2)
ylim([-20 20])
xlim([-20 20])
title('Spont D-Prime')

subplot(3, 1, 3)
ylim([-20 20])
xlim([-20 20])
title('Pooled D-Prime')

%%
if doPrint
    disp('Printing Plot')
    set(0, 'CurrentFigure', figH)
    
    dropBoxSavePath = [saveDir saveName '-SummaryDPrime'];
    
    plotpos = [0 0 40 20];
    print_in_A4(0, dropBoxSavePath , '-djpeg', 0, plotpos);
    
    disp('')
end

%%
figH = figure(294);

subplot(2, 1, 1)
xlim([1 22])
set(gca, 'XTick',[1:numel(Az_mean)]);
set(gca,'XTickLabel',{'-180';'';'';'';'';'';'-90';'';'';'';'';'0';'';'';'';'';'90';'';'';'';'';'180';});

subplot(2, 1, 2)
xlim([1 9])
set(gca, 'XTick',[1:length(mean_EL_stimTrials)]);
set(gca,'XTickLabel',{'67.5';'';'33.75';'';'0';'';'-33.75';'';'-67.5';});

if doPrint
    disp('Printing Plot')
    set(0, 'CurrentFigure', figH)
    
    dropBoxSavePath = [saveDir saveName '-SummaryMaxAZEL'];
    
    plotpos = [0 0 40 20];
    print_in_A4(0, dropBoxSavePath , '-djpeg', 0, plotpos);
    
    disp('')
end

%% Save D

Data_SaveName = [saveDir '_0_AllData_Janie.mat'];
save(Data_SaveName, 'D');

end

