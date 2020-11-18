function [] = runJaniesAnalysis_batchProcess_JanieFinalAnalysis()

close all
dbstop if error
%%

doPrint = 0;

%%

switch gethostname
    case {'DEADPOOL'}
        
        dataDir = '/home/janie/Data/TUM/OTAnalysis/CombinedDataSets_JanieFeb/Data/';
        saveDir = '/home/janie/Data/TUM/OTAnalysis/CombinedDataSets_JanieFeb/Data/Figs/';
    case 'PLUTO'
        dataDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/MLDNeurons-CombinedHRTF/';
        saveDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/Figs/PopulationAnalysisFigs/';
        
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
Expset = [1 10 11 13 15 16 18];

for s = Expset
    
    filToLoad = trialNames{s};
    saveName = filToLoad(1:28);
    underscore = '_';
    bla = find(saveName == underscore);
    titelName = saveName;
    titelName(bla) = ' ';
    
    NeuronName = filToLoad(1:4);
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
    %sweepLengths_ms = 1000* data.OBJS.dataSet1.C_OBJ.SETTINGS.EpocheLength;
    sweepLengths_ms = 300;
    fs = data.OBJS.dataSet1.C_OBJ.SETTINGS.SampleRate;
    
    D.INFO.saveName{s} = saveName;
    D.INFO.n_stims(s) = n_stims;
    D.INFO.n_reps(s) = n_reps;
    D.INFO.sweepLengths_ms(s) = sweepLengths_ms;
    D.INFO.sweepLengths_ms(s) = sweepLengths_ms;
    D.INFO.n_elev(s) = n_elev;
    D.INFO.n_azim(s) = n_azim;
    
    
    
    
    
    %% HardCoded Response Windows for Hansa's data
    
    %spkWin_ms = 50;
    spkWin_ms = 20;
    
    stimInds = [6 7 8 9 10]; % 20 ms
    spontInds_Pre = [1 2 3 4 5]; % 20 ms
    spontInds_Post = [11 12 13 14 15]; % 20 ms
    
    tOn = 1:spkWin_ms:sweepLengths_ms;
    nSkpWins = numel(tOn);
    
    D.INFO.spkWin_ms(s) = spkWin_ms;
    
    %% aSRFs
    
    
    allSpks = flipud(combinedSPKS); % We do this to make sure negative elevation is on the bottom
    
    spkCnt_stims = [];
    perWin_stims_mean = [];
    perWin_stims_sum = [];
    perWin_stims_std = [];
    
    spkCnt_reps = [];
    spkWinsOverReps = [];
    spkCntsAllStim = [];
    spkCntsAllSpont = [];
    spkCntsAllSpont_post = [];
    
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
            
            %spkCntsAllStim = sum(spkWinsOverReps(:,stimInds), 2);
            
            spkCntsAllStim = [spkCntsAllStim; sum(spkWinsOverReps(:,stimInds), 2)]; % sum of spikes in the 100 ms window
            spkCntsAllSpont = [spkCntsAllSpont; sum(spkWinsOverReps(:,spontInds_Pre), 2)];
            spkCntsAllSpont_post = [spkCntsAllSpont_post; sum(spkWinsOverReps(:,spontInds_Post), 2)];
            
            spkCnt_stims{elev, azim} = spkWinsOverReps;
            perWin_stims_mean{elev, azim} = nanmean(spkWinsOverReps, 1);
            perWin_stims_sum{elev, azim} = sum(spkWinsOverReps, 1);
            perWin_stims_std{elev, azim} = nanstd(spkWinsOverReps);
            
            %SpkWinSums{azim, elev} = perWin_stims_sum{ct}(o);
            %ct = ct+1;
            
        end
        
    end
    
    
    %% Z score Calc
    FR_Stim = spkCntsAllStim/0.1; % 100 ms
    FR_Spont = spkCntsAllSpont/0.1; % 100 ms
    FR_Spont_post = spkCntsAllSpont_post/0.1; % 100 ms
    
    
    meanStim = nanmean(FR_Stim);
    meanSpont = nanmean(FR_Spont);
    meanSpont_post = nanmean(FR_Spont_post);
    
    stdStim = nanstd(FR_Stim);
    stdSpont = nanstd(FR_Spont);
    stdSpont_post = nanstd(meanSpont_post);
    
    semStim = stdStim / (sqrt(numel(FR_Stim)));
    semSpont = stdSpont / (sqrt(numel(FR_Spont)));
    semSpont_post = stdSpont_post / (sqrt(numel(FR_Spont_post)));
    
    covar = cov(FR_Stim, FR_Spont);
    z_score_cov = (meanStim - meanSpont) / sqrt((stdStim^2 + stdSpont^2) - 2*covar(1, 2));
    
    figure(104); clf
    bar(1,meanSpont, 'FaceColor',[1 1 1])
    hold on
    er = errorbar(1,meanSpont,semSpont, semSpont);
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    
    hold on
    bar(2,meanStim, 'FaceColor',[0 .0 0])
    er = errorbar(2,meanStim,semStim, semStim);
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    
    bar(3,meanSpont_post, 'FaceColor',[.5 .5 .5])
    er = errorbar(3,meanSpont_post,semSpont_post, semSpont_post);
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    
    set(gca, 'xtick', [1 2 3]);
    set(gca, 'xticklabel', {'Baseline' ; 'Stimulus' ; 'Post'});
    ylabel('Firing  Rate [Hz]')
    ylim ([0 110])
    
    title([titelName ' | Z-score = ' num2str(z_score_cov)])
    
    if doPrint == 1
        
        disp('Printing Plot')
        figure(104)
        
        dropBoxSavePath = [saveDir saveName '-FR_Zscore'];
        
        %plotpos = [0 0 12 40];
        plotpos = [0 0 12 8];
        print_in_A4(0, dropBoxSavePath , '-djpeg', 0, plotpos);
        
        disp('')
        
    end
    
    %%
    
    D.DATA.ZScore{s} = z_score_cov;
    D.DATA.FR_Stim{s} = FR_Stim;
    D.DATA.FR_Spont{s} = FR_Spont;
    D.DATA.FR_Spont_post{s} = FR_Spont_post;
   
    
    D.DATA.spkCnt_stims{s} = spkCnt_stims;
    D.DATA.perWin_stims_mean{s} = perWin_stims_mean;
    D.DATA.perWin_stims_sum{s} = perWin_stims_sum;
    D.DATA.perWin_stims_std{s} = perWin_stims_std;
    
    %%
    
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
        dataToPlot_smooth_norm = (dataToPlot_smooth-MIN_smooth) / (MAX_smooth - MIN_smooth); % min max normalizization, can plot from 0 to 1
        % https://towardsdatascience.com/everything-you-need-to-know-about-min-max-normalization-in-python-b79592732b79
        % susceptible to outliers
        
        max(dataToPlot_smooth_norm);
        surf(dataToPlot_smooth_norm);
        shading interp
        view([ 0 90])
        axis tight
        caxis(clims)
        
        set(gca,'ytick',[])
        set(gca,'xtick',[])
        xlabel('Azimuth')
        ylabel('Elev.')
        
        colorbar
        if o ==1
            title(titelName)
        end
        
        
    end
    
    %%
    if doPrint
        
        disp('Printing Plot')
        set(0, 'CurrentFigure', figH)
        
        dropBoxSavePath = [saveDir saveName '-vertASRFs'];
        
        %plotpos = [0 0 12 40];
        plotpos = [0 0 7 35];
        print_in_A4(0, dropBoxSavePath , '-djpeg', 0, plotpos);
        
        disp('')
        
    end
    
    %%
    
    % Depends on win size
    %stimInds = [3 4]; % 50 ms
    %spontInds = [1 2 5 6]; % 50 ms
    
    
    
    azPlots = n_azim;
    elPlots = n_elev;
    
    buff_size = .005;
    
    button_width = .80/azPlots;
    button_height = .85/elPlots;
    
    top_button_height = .88;
    left_button_start = .02;
    
    %%
    
    
    nStimWindowsToUseForRaster = numel(stimInds);
    
    AllSpkSums = zeros(n_elev, n_azim);
    
    for oo = 1:nStimWindowsToUseForRaster
        StimWinSpikesSums = allSpkWinSums_rot{stimInds(oo)};
        
        AllSpkSums = AllSpkSums + StimWinSpikesSums;
    end
    
    %StimWinSpikesSums = allSpkWinSums_rot{stimInds(1)}; % first stim window
    StimWinSpikesSums = AllSpkSums;
    
    figH1 = figure(124);clf
    for azim = 1:n_azim
        for elev = 1:n_elev
            
            %% starting from top left
            
            if elev ==1
                y_start = top_button_height;
            else
                %y_start = 1-(TopBuff+row*plot_height+(row-1)*spacer_buffer);
                y_start = (top_button_height-(elev-1)*button_height) - (elev-1)*buff_size; % minus because values decreasing
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
                xlabel({'-180 az'; 'Behind'})
            end
            
            if azim ==33 && elev == 13
                xlabel({'+180 az'; 'Behind'})
            end
            
            if azim == 9 && elev == 13
                xlabel({'-90 az'; 'Left'})
            end
            
            if azim == 25 && elev == 13
                xlabel({'+90 az';'Right'})
            end
            
            if azim ==1 && elev == 1
                ylabel('+67.5 el')
            end
            
            if azim ==1 && elev == 13
                ylabel('-67.5 el')
            end
            
            if azim ==17 && elev == 13
                xlabel({'0 az' ; 'Front'})
            end
            
            if azim ==1 && elev == 7
                ylabel('0 el')
            end
            
        end
    end
    
    
    % Create textbox
    annotation(figH1,'textbox',...
        [0.020 0.96 0.43 0.03],...
        'String',titelName,...
        'LineStyle','none',...
        'FitBoxToText','off');
    
    if doPrint == 0
        
        disp('Printing Plot')
        set(0, 'CurrentFigure', figH1)
        
        dropBoxSavePath = [saveDir saveName '-rasterMatrix'];
        
        plotpos = [0 0 15 6];
        print_in_A4(0, dropBoxSavePath , '-djpeg', 0, plotpos);
        print_in_A4(0, dropBoxSavePath , '-depsc', 0, plotpos);
        
        disp('')
        
    end
    
    
    
    %%
    
    D.INFO.stimInds{s} = stimInds;
    D.INFO.spontInds_Pre{s} = spontInds_Pre;
    D.INFO.spontInds_Post{s} = spontInds_Post;
    
    
    figH = figure(200); clf
    ColorSet = varycolor(nSkpWins);
    allSummedAz = [];
    allSummedEL = [];
    for o = 1:nSkpWins
        
        if ismember(o, stimInds)
            col = 'g';
        elseif ismember(o, spontInds_Pre)
            col = 'k';
        elseif ismember(o, spontInds_Post)
            col = 'b';
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
    
    %%
    
    
    
    %% EL
    
    EL_stimTrials = flipud(allSummedEL(:, stimInds));
    %EL_spontTrials = flipud(allSummedEL(:, spontInds_Pre)); % Only using first spont windows
    EL_spontTrials = flipud(allSummedEL(:, spontInds_Post)); % Only using first spont windows
    %EL_spontTrials = flipud(allSummedEL(:, spontInds_Post)); % Only using first spont windows
    
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
    
    %barweb(ValsEL', ValsEL_err', 1, [], [], [], [], bone, [], []); % %crashes
    
    
    xes = 1:size(ValsEL, 2);
    bar(xes, ValsEL(1,:)');
    hold on
    er = errorbar(xes,ValsEL(1,:),ValsEL_err(1,:),ValsEL_err(1,:));
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    
    hold on
    bar(xes, ValsEL(2,:)');
    er = errorbar(xes,ValsEL(2,:),ValsEL_err(2,:),ValsEL_err(2,:));
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    
    %barweb(barplotZ, barplotZsem, .8, [], [], [], [], bone, [], [])
    view([90 90])
    title('Elevation | Stim and Spont')
    xlabel('Mean Spike Count')
    %% AZ
    
    AZ_stimTrials = allSummedAz(:, stimInds);
    %AZ_spontTrials = allSummedAz(:, spontInds);
    %AZ_spontTrials = allSummedAz(:, spontInds_Pre);
    AZ_spontTrials = allSummedAz(:, spontInds_Post);
    
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
    
    
    xes = 1:size(ValsAZ, 2);
    bar(xes, ValsAZ(1,:)');
    hold on
    er = errorbar(xes,ValsAZ(1,:),ValsAZ_err(1,:),ValsAZ_err(1,:));
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    
    hold on
    bar(xes, ValsAZ(2,:)');
    er = errorbar(xes,ValsAZ(2,:),ValsAZ_err(2,:),ValsAZ_err(2,:));
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    
    
    %barweb(ValsAZ', ValsAZ_err', 1, [], [], [], [], bone, [], []);
    title('Mean spike count | Stim and Spont')
    ylabel('Mean Spike Count')
    %barweb(barplotZ, barplotZsem, .8, [], [], [], [], bone, [], [])
    
    %xTICKS = get(gca, 'xticks');
    
    annotation(figH,'textbox',...
        [0.020 0.96 0.43 0.03],...
        'String',titelName,...
        'LineStyle','none',...
        'FitBoxToText','off');
    
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
    
    % errorbar(timepoints, smoothedMean_stim, sem_AZ_stimTrials, 'b-', 'linewidth', 1)
    % errorbar(timepoints, smoothedMean_spont, sem_AZ_spontTrials, 'k-', 'linewidth', 1)
    
    
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
    
    title([ titelName ' | Peak Azimuth'])
    
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
    % plot(D.DATA.maxLocSpont_AZ(s), D.DATA.maxWidthSpont_AZ(s), 'ko')
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
    
    %   errorbar(timepoints, smoothedMean_stim, mean_EL_stimTrials, 'b-', 'linewidth', 1)
    %   errorbar(timepoints, smoothedMean_spont, mean_EL_spontTrials, 'k-', 'linewidth', 1)
    
    
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
    
    title([ titelName ' | Peak Elevation'])
    
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
    % plot(D.DATA.maxLocSpont_EL(s), D.DATA.maxWidthSpont_EL(s), 'ko')
    title('Elevation')
    ylabel('Width')
    
    
    %%
    
    %set(gca, 'YTick',[1:length(ele)]);%17.01.05
    %set(gca,'YTickLabel',{ele});
    
    
    %% D Prime calculation
    AzContra = [5:13]; % -135 +/- up to -45 
    AzIpsi = [21:29]; % % +45 +/- up to 135 
    ELTop = [1:6]; % 13 total, 7 is 0;
    ELDown = [7:13]; % 13 total, 7 is 0;
    
    
    % Doesnt work for d primes
%     AzContra = [9]; % -90 +/- up to 45 / 135
%     AzIpsi = [25]; % % +90 +/- up to 45 / 135
%     ELTop = [1]; % 13 total, 7 is 0;
%     ELDown = [13]; % 13 total, 7 is 0;
    
    
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
    
    pooled_D_Az_Stim(s) =  D_Az_Stim;
    
    % During Spont Trials
    AZ_Spont_inds_contra = AZ_spontTrials(AzContra,:);
    AZ_Spont_inds_ispi = AZ_spontTrials(AzIpsi,:);
    
    AZ_Spont_inds_contra_mean = nanmean(nanmean(AZ_Spont_inds_contra));
    AZ_Spont_inds_ispi_mean = nanmean(nanmean(AZ_Spont_inds_ispi));
    
    AZ_Spont_inds_contra_std = nanstd(nanstd(AZ_Spont_inds_contra));
    AZ_Spont_inds_ispi_std = nanstd(nanstd(AZ_Spont_inds_ispi));
    
    D_Az_Spont = 2* (AZ_Spont_inds_contra_mean - AZ_Spont_inds_ispi_mean) / sqrt(AZ_Spont_inds_contra_std^2 + AZ_Spont_inds_ispi_std^2);
    
    pooled_D_Az_Spont(s) =  D_Az_Spont;
    
    % Pooled Trials
    %     AZ_All_inds_contra = allSummedAz(AzContra,:);
    %     AZ_All_inds_ispi = allSummedAz(AzIpsi,:);
    %
    %     AZ_All_inds_contra_mean = nanmean(nanmean(AZ_All_inds_contra));
    %     AZ_All_inds_ispi_mean = nanmean(nanmean(AZ_All_inds_ispi));
    %
    %     AZ_All_inds_contra_std = nanstd(nanstd(AZ_All_inds_contra));
    %     AZ_All_inds_ispi_std = nanstd(nanstd(AZ_All_inds_ispi));
    %
    %     D_Az_All = 2* (AZ_All_inds_contra_mean - AZ_All_inds_ispi_mean) / sqrt(AZ_All_inds_contra_std^2 + AZ_All_inds_ispi_std^2);
    
    AZ_All_stim = AZ_stimTrials;
    AZ_All_spont = AZ_spontTrials;
    
    AZ_All_inds_stim_mean = nanmean(nanmean(AZ_All_stim));
    AZ_All_inds_spont_mean = nanmean(nanmean(AZ_All_spont));
    
    AZ_All_inds_stim_std = nanstd(nanstd(AZ_All_stim));
    AZ_All_inds_spont_std = nanstd(nanstd(AZ_All_spont));
    
    D_Az_All = 2* (AZ_All_inds_stim_mean - AZ_All_inds_spont_mean) / sqrt(AZ_All_inds_stim_std^2 + AZ_All_inds_spont_std^2);
    
    pooled_D_Az_All(s) =  D_Az_All;
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
    %     EL_All_inds_contra = allSummedAz(ELTop,:);
    %     EL_All_inds_ispi = allSummedAz(ELDown,:);
    %
    %     EL_All_inds_contra_mean = nanmean(nanmean(EL_All_inds_contra));
    %     EL_All_inds_ispi_mean = nanmean(nanmean(EL_All_inds_ispi));
    %
    %     EL_All_inds_contra_std = nanstd(nanstd(EL_All_inds_contra));
    %     EL_All_inds_ispi_std = nanstd(nanstd(EL_All_inds_ispi));
    %
    %     D_EL_All = 2* (EL_All_inds_contra_mean - EL_All_inds_ispi_mean) / sqrt(EL_All_inds_contra_std^2 + EL_All_inds_ispi_std^2);
    %
    %     pooled_D_EL_All(s) =  D_EL_All;
    
    
    EL_All_stim = EL_stimTrials;
    EL_All_spont = EL_spontTrials;
    
    EL_All_inds_stim_mean = nanmean(nanmean(EL_All_stim));
    EL_All_inds_spont_mean = nanmean(nanmean(EL_All_spont));
    
    EL_All_inds_stim_std = nanstd(nanstd(EL_All_stim));
    EL_All_inds_spont_std = nanstd(nanstd(EL_All_spont));
    
    D_EL_All = 2* (EL_All_inds_stim_mean - EL_All_inds_spont_mean) / sqrt(EL_All_inds_stim_std^2 + EL_All_inds_spont_std^2);
    
    pooled_D_EL_All(s) =  D_EL_All;
    
    
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

D.DATA.pooled_D_AZ_Stim = pooled_D_Az_Stim;
D.DATA.pooled_D_AZ_Spont = pooled_D_Az_Spont;
D.DATA.pooled_D_AZ_All = pooled_D_Az_All;

D.DATA.pooled_D_EL_Stim = pooled_D_EL_Stim;
D.DATA.pooled_D_EL_Spont = pooled_D_EL_Spont;
D.DATA.pooled_D_EL_All = pooled_D_EL_All;

disp('')

%%
figure(120);

subplot(3, 1, 1)
xlim([-30 30])
ylim([-10 10])
hold on
line([0 0], [-10 10], 'color', 'k')
line([-30 30], [0 0], 'color', 'k')
title('Population: Stim D-Prime | AZ: Contra vs Ipsi (Left vs Right)')

subplot(3, 1, 2)
xlim([-30 30])
ylim([-10 10])
hold on
line([0 0], [-10 10], 'color', 'k')
line([-30 30], [0 0], 'color', 'k')
title('Population: Spont D-Prime | AZ: Contra vs Ipsi (Left vs Right)')

subplot(3, 1, 3)
xlim([-300 300])
ylim([-450 450])
title('Pooled D-Prime | Stim vs Spont')
hold on
line([0 0], [-450 450], 'color', 'k')
line([-300 300], [0 0], 'color', 'k')

%%
if doPrint
    disp('Printing Plot')
    figure(120);
    
    dropBoxSavePath = [saveDir '-SummaryDPrime'];
    
    plotpos = [0 0 40 20];
    print_in_A4(0, dropBoxSavePath , '-djpeg', 0, plotpos);
    
    disp('')
end

%%
figure(294);

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
    figure(294);
    
    dropBoxSavePath = [saveDir '-SummaryMaxAZEL'];
    
    plotpos = [0 0 40 20];
    print_in_A4(0, dropBoxSavePath , '-djpeg', 0, plotpos);
    
    disp('')
end

%% Save D

Data_SaveName = [saveDir '_0_AllData_Janie_DPrimePost.mat'];
save(Data_SaveName, 'D');

end

