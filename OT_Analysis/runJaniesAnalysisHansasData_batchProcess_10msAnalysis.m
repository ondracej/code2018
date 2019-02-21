function [] = runJaniesAnalysisHansasData_batchProcess_10msAnalysis()

close all;
dbstop if error
%%

dataDir = ['/home/janie/Dropbox/00_Conferences/2018_FENS/HansaData/DataToUse/passt/'];

saveDir = '/home/janie/Data/TUM/OT/OTData/Figures-HansasDataJan2019/';

trialSeach = ['*.f32*'];

trialNamesStruct = dir(fullfile(dataDir, trialSeach));
nTrials = numel(trialNamesStruct);
for j = 1:nTrials
    trialNames{j} = trialNamesStruct(j).name;
end

%%

for s = 1:nTrials
    
    filToLoad = trialNames{s};
    saveName = filToLoad(1:end-4);
    
    D.INFO.saveName{s} = saveName;
    
    data=spikedatf([dataDir filToLoad]);
    
    % data = sweeplength  = 400 ; stim = 16x1 double; sweep = 1x10 struct w field spikes
    %data(1).stim(1) = sample ON?
    %data(1).stim(2) = sample OFF?
    %data(1).stim(3) = trial number
    %data(1).stim(4) = 70 DB right?
    %data(1).stim(5) = 70 DB left?
    %data(1).stim(6) = 0
    %data(1).stim(7) = 1
    %data(1).stim(8) = 1
    %data(1).stim(9) = 0
    %data(1).stim(10) = total duration of record in ms
    %data(1).stim(11) = n repetitions
    %data(1).stim(12) = pre stim silence in ms
    %data(1).stim(13) = azimuth
    %data(1).stim(14) = elevtaion
    %data(1).stim(15) = 35 DB right?
    %data(1).stim(16) = 35 DB left?
    
    %data(199) is silent!
    % Is sweep length in ms?? What are the stim values?? is sweep the repetitions of the stim? 10x each?
    % Stim values must be some experiment parameters - get what these actually are from Hansa
    
    %%
    n_elev = 9;
    n_azim = 22;
    
    n_stims = size(data,2);  % Number of stims minus the silent stim (199) %gibt die Stimulusanzahl an. Bei (data,2) ist die Anzahl der Stimuli hinterlegt: (9 Elevation* 22 Azimuth) + den Nullstimulus
    n_reps = data(1).stim(11); % 11th positions gives number of repetitions
    sweepLengths_ms = data(1).sweeplength;
    
    D.INFO.saveName{s} = saveName;
    D.INFO.n_stims(s) = n_stims;
    D.INFO.n_reps(s) = n_reps;
    D.INFO.sweepLengths_ms(s) = sweepLengths_ms;
    D.INFO.n_elev(s) = n_elev;
    D.INFO.n_azim(s) = n_azim;
    
    %% HardCoded Response Windows for Hansa's data
    
    %     preSpontWin = 1:50;
    %     stimWin_1 = 51:100;
    %     stimWin_2 = 101:150;
    %     stimWin_3 = 151:200;
    %     postSpontWin_1 = 201:250;
    %     postSpontWin_2 = 251:300;
    %     postSpontWin_3 = 301:350;
    %     postSpontWin_4 = 351:400;
    %
    spkWin_ms = 50;
    
    tOn = 1:spkWin_ms:sweepLengths_ms;
    nSkpWins = numel(tOn);
    
    D.INFO.spkWin_ms(s) = spkWin_ms;
    
    
    %%
    spkCnt_stims = [];
    perWin_stims_mean = [];
    perWin_stims_sum = [];
    perWin_stims_std = [];
    
    
    for j = 1:n_stims
        spkCnt_reps = [];
        spkWinsOverReps = [];
        
        for k = 1:n_reps
            
            spks = data(j).sweep(k).spikes;
            
            for o = 1:nSkpWins
                
                spkCnt_reps(o) = numel(spks(spks >= (tOn(o)-1) & spks < (tOn(o)+spkWin_ms-1)));
                
            end
            
            spkWinsOverReps(k,:) = spkCnt_reps; % here very column is a time window, and everyrow is a rep of the same stim
            
        end
        
        spkCnt_stims{j} = spkWinsOverReps;
        perWin_stims_mean{j} = nanmean(spkWinsOverReps, 1);
        perWin_stims_sum{j} = sum(spkWinsOverReps, 1);
        perWin_stims_std{j} = nanstd(spkWinsOverReps);
        
    end
    
     D.DATA.spkCnt_stims{s} = spkCnt_stims;
     D.DATA.perWin_stims_mean{s} = perWin_stims_mean;
     D.DATA.perWin_stims_sum{s} = perWin_stims_sum;
     D.DATA.perWin_stims_std{s} = perWin_stims_std;
    
    %% aSRFs
    
    n_elev = 9;
    n_azim = 22;
    
    allSpkWinSums_raw = [];
    allSpkWinSums_rot_Smooth = [];
    for o = 1:nSkpWins
        SpkWinSums = [];
        ct = 1;
        for elev = 1:n_elev
            for azim = 1:n_azim
                
                SpkWinSums(azim, elev) = perWin_stims_sum{ct}(o);
                ct = ct+1;
            end
        end
        
        allSpkWinSums_raw{o} = SpkWinSums;
        
        bla_smooth = rot90(moving_average2(SpkWinSums(:,:),1,1));
        bla = (rot90(SpkWinSums));
        
        minVal_raw(o) = min(min(bla));
        maxVal_raw(o) = max(max(bla));
        
        minVal_smooth(o) = min(min(bla_smooth));
        maxVal_smooth(o) = max(max(bla_smooth));
        
        %allSpkWinSums_rot{o} = rot90(SpkWinSums);
        allSpkWinSums_rot{o} = (rot90(SpkWinSums));
        allSpkWinSums_rot_Smooth{o} = rot90(moving_average2(SpkWinSums(:,:),1,1));
        
        
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
        
        %dataToPlot = allSpkWinSums_rot{o};
        
        %figure(0+o); clf
        subplot(nSkpWins, 1, o)
        
        %         subplot(4, 1, 1)
        %         surf(dataToPlot);
        %         shading interp
        %         view([ 0 90])
        %         axis tight
        %
        %         set(gca,'ytick',[])
        %         set(gca,'xtick',[])
        %         xlabel('Azimuth')
        %         ylabel('Elevation')
        
        %         dataToPlot_norm = (dataToPlot-min(minVal_raw)) / (max(maxVal_raw) - min(minVal_raw));
        %
        %         subplot(2, 1, 1)
        %         surf(dataToPlot_norm);
        %         shading interp
        %         view([ 0 90])
        %         axis tight
        %
        %         set(gca,'ytick',[])
        %         set(gca,'xtick',[])
        %         xlabel('Azimuth')
        %         ylabel('Elevation')
        %
        %         subplot(2, 1, 2)
        
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
    
    disp('Printing Plot')
    set(0, 'CurrentFigure', figH)
    
    dropBoxSavePath = [saveDir saveName '-vertASRFs'];
    
    plotpos = [0 0 12 40];
    print_in_A4(0, dropBoxSavePath , '-djpeg', 0, plotpos);
    
    disp('')
    
   %%
 
    stimInds = [2 3 4];
    spontInds = [1 4 6 7 8];
 
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
        line([5 5], [0 max(El_mean)], 'color', 'k', 'linestyle', ':')
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
        line([11 11], [0 max(Az_mean)], 'color', 'k', 'linestyle', ':')
        title('Mean Azimuth')
        
    end
    
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
    
    
    subplot(2, 2, 2)
    ValsEL = [mean_EL_stimTrials mean_EL_spontTrials]';
    ValsEL_err = [sem_EL_stimTrials' sem_EL_spontTrials']';
    
    barweb(ValsEL', ValsEL_err', 1, [], [], [], [], bone, [], []);
    %barweb(barplotZ, barplotZsem, .8, [], [], [], [], bone, [], [])
    view([90 90])
    
    %% AZ
    
    AZ_stimTrials = allSummedAz(:, stimInds);
    AZ_spontTrials = allSummedAz(:, spontInds);
    
    mean_AZ_stimTrials = mean(AZ_stimTrials, 2);
    std_AZ_stimTrials = nanstd(AZ_stimTrials');
    sem_AZ_stimTrials = std_AZ_stimTrials  /(sqrt(numel(std_AZ_stimTrials)));
    
    mean_AZ_spontTrials = mean(AZ_spontTrials, 2);
    std_AZ_spontTrials = nanstd(AZ_spontTrials');
    sem_AZ_spontTrials = std_AZ_spontTrials  /(sqrt(numel(std_AZ_spontTrials)));
    
    
    subplot(2, 2, 4)
    ValsAZ = [mean_AZ_stimTrials mean_AZ_spontTrials]';
    ValsAZ_err = [sem_AZ_stimTrials' sem_AZ_spontTrials']';
    
    barweb(ValsAZ', ValsAZ_err', 1, [], [], [], [], bone, [], []);
    %barweb(barplotZ, barplotZsem, .8, [], [], [], [], bone, [], [])
    
    xTICKS = get(gca, 'xticks')
    
    %%
    disp('Printing Plot')
    set(0, 'CurrentFigure', figH)
    
    dropBoxSavePath = [saveDir saveName '-barplots'];
    
    plotpos = [0 0 40 20];
    print_in_A4(0, dropBoxSavePath , '-djpeg', 0, plotpos);
    
    disp('')
    
    %% D Prime calculation
    AzContra = [1:10]; % 22 total, 11 is 0;
    AzIpsi = [12:22]; % 22 total, 11 is 0;
    ELTop = [1:4]; % 9 total, 5 is 0;
    ELDown = [6:9]; % 9 total, 5 is 0;
    
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
disp('Printing Plot')
set(0, 'CurrentFigure', figH)

dropBoxSavePath = [saveDir saveName '-SummaryDPrime'];

plotpos = [0 0 40 20];
print_in_A4(0, dropBoxSavePath , '-djpeg', 0, plotpos);

disp('')


%% Save D

Data_SaveName = [saveDir '_0_AllData_Hansa.mat'];
save(Data_SaveName, 'D');

end

