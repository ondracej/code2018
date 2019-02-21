function [] = runJaniesAnalysisHansasData_batchProcess()

close all;
dbstop if error
%%

dataDir = ['/home/janie/Dropbox/00_Conferences/2018_FENS/HansaData/DataToUse/passt/'];

saveDir = '/media/janie/Data64GB/OTData/Dec2018_FigsHansa/';

trialSeach = ['*.f32*'];

trialNamesStruct = dir(fullfile(dataDir, trialSeach));
nTrials = numel(trialNamesStruct);
for j = 1:nTrials
    trialNames{j} = trialNamesStruct(j).name;
end

%%

for k = 6:nTrials
    
    filToLoad = trialNames{k};
    saveName = filToLoad(1:end-4);
    
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
    
    n_stims = size(data,2);  % Number of stims minus the silent stim (199) %gibt die Stimulusanzahl an. Bei (data,2) ist die Anzahl der Stimuli hinterlegt: (9 Elevation* 22 Azimuth) + den Nullstimulus
    n_reps = data(1).stim(11); % 11th positions gives number of repetitions
    sweepLengths_ms = data(1).sweeplength;
    
    %% HardCoded Response Windows for Hansa's data
    
    preSpontWin = 1:50;
    stimWin_1 = 51:100;
    stimWin_2 = 101:150;
    stimWin_3 = 151:200;
    postSpontWin_1 = 201:250;
    postSpontWin_2 = 251:300;
    postSpontWin_3 = 301:350;
    postSpontWin_4 = 351:400;
    
    Twin_s = 0.05;
    cnt = 1;
    for j = 1:n_stims
        for k = 1:n_reps
            
            spks = data(j).sweep(k).spikes;
            %these_spks_on_chan = spks(spks >= reshapedOnsets(p) & spks <= reshapedOffsets(p))-reshapedOnsets(p);
            
            preSpontWin_spks_reps(k) = numel(spks(spks >= preSpontWin(1) & spks <= preSpontWin(end)));
            stimWin_1_spks_reps(k) = numel(spks(spks >= stimWin_1(1) & spks <= stimWin_1(end)));
            stimWin_2_spks_reps(k) = numel(spks(spks >= stimWin_2(1) & spks <= stimWin_2(end)));
            stimWin_3_spks_reps(k) = numel(spks(spks >= stimWin_3(1) & spks <= stimWin_3(end)));
            postSpontWin_1_spks_reps(k) = numel(spks(spks >= postSpontWin_1(1) & spks <= postSpontWin_1(end)));
            postSpontWin_2_spks_reps(k) = numel(spks(spks >= postSpontWin_2(1) & spks <= postSpontWin_2(end)));
            postSpontWin_3_spks_reps(k) = numel(spks(spks >= postSpontWin_3(1) & spks <= postSpontWin_3(end)));
            postSpontWin_4_spks_reps(k) = numel(spks(spks >= postSpontWin_4(1) & spks <= postSpontWin_4(end)));
            
            
            preSpontWin_spks(cnt) = numel(spks(spks >= preSpontWin(1) & spks <= preSpontWin(end)));
            stimWin_1_spks(cnt) = numel(spks(spks >= stimWin_1(1) & spks <= stimWin_1(end)));
            stimWin_2_spks(cnt) = numel(spks(spks >= stimWin_2(1) & spks <= stimWin_2(end)));
            stimWin_3_spks(cnt) = numel(spks(spks >= stimWin_3(1) & spks <= stimWin_3(end)));
            postSpontWin_1_spks(cnt) = numel(spks(spks >= postSpontWin_1(1) & spks <= postSpontWin_1(end)));
            postSpontWin_2_spks(cnt) = numel(spks(spks >= postSpontWin_2(1) & spks <= postSpontWin_2(end)));
            postSpontWin_3_spks(cnt) = numel(spks(spks >= postSpontWin_3(1) & spks <= postSpontWin_3(end)));
            postSpontWin_4_spks(cnt) = numel(spks(spks >= postSpontWin_4(1) & spks <= postSpontWin_4(end)));
            cnt = cnt+1;
            disp('')
        end
        
        %         preSpontWin_spks(cnt) = numel(find(preSpontWin(1) <= data(j).sweep(k).spikes & data(j).sweep(k).spikes <= preSpontWin(end)));
        %         stimWin_1_spks(cnt) = numel(find(stimWin_1(1) <= data(j).sweep(k).spikes & data(j).sweep(k).spikes <= stimWin_1(end)));
        %         stimWin_2_spks(cnt) = numel(find(stimWin_2(1) <= data(j).sweep(k).spikes & data(j).sweep(k).spikes <= stimWin_2(end)));
        %         stimWin_3_spks(cnt) = numel(find(stimWin_3(1) <= data(j).sweep(k).spikes & data(j).sweep(k).spikes <= stimWin_3(end)));
        %         postSpontWin_1_spks(cnt) = numel(find(postSpontWin_1(1) <= data(j).sweep(k).spikes & data(j).sweep(k).spikes <= postSpontWin_1(end)));
        %         postSpontWin_2_spks(cnt) = numel(find(postSpontWin_2(1) <= data(j).sweep(k).spikes & data(j).sweep(k).spikes <= postSpontWin_2(end)));
        %         postSpontWin_3_spks(cnt) = numel(find(postSpontWin_3(1) <= data(j).sweep(k).spikes & data(j).sweep(k).spikes <= postSpontWin_3(end)));
        %         postSpontWin_4_spks(cnt) = numel(find(postSpontWin_4(1) <= data(j).sweep(k).spikes & data(j).sweep(k).spikes <= postSpontWin_4(end)));
        
        preSpontWin_sumRep(j) = sum(preSpontWin_spks_reps);
        stimWin_1_sumRep(j) =  sum(stimWin_1_spks_reps);
        stimWin_2_sumRep(j) = sum(stimWin_2_spks_reps);
        stimWin_3_sumRep(j) = sum(stimWin_3_spks_reps);
        postSpontWin_1_sumRep(j) =   sum(postSpontWin_1_spks_reps);
        postSpontWin_2_sumRep(j) =  sum(postSpontWin_2_spks_reps);
        postSpontWin_3_sumRep(j) =  sum(postSpontWin_3_spks_reps);
        postSpontWin_4_sumRep(j) =   sum(postSpontWin_4_spks_reps);
        
        preSpontWin_FR(j,:) = preSpontWin_spks_reps/Twin_s;
        stimWin_1_FR(j,:) =  stimWin_1_spks_reps/Twin_s;
        stimWin_2_FR(j,:) = stimWin_2_spks_reps/Twin_s;
        stimWin_3_FR(j,:) = stimWin_3_spks_reps/Twin_s;
        postSpontWin_1_FR(j,:) = postSpontWin_1_spks_reps/Twin_s;
        postSpontWin_2_FR(j,:) = postSpontWin_2_spks_reps/Twin_s;
        postSpontWin_3_FR(j,:) = postSpontWin_3_spks_reps/Twin_s;
        postSpontWin_4_FR(j,:) = postSpontWin_4_spks_reps/Twin_s;
        
    end
    
    
    preSpontWin_spks_Cnt = sum(preSpontWin_spks);
    stimWin_1_spks_Cnt = sum(stimWin_1_spks);
    stimWin_2_spks_Cnt = sum(stimWin_2_spks);
    stimWin_3_spks_Cnt = sum(stimWin_3_spks);
    postSpontWin_1_spks_Cnt = sum(postSpontWin_1_spks);
    postSpontWin_2_spks_Cnt = sum(postSpontWin_2_spks);
    postSpontWin_3_spks_Cnt = sum(postSpontWin_3_spks);
    postSpontWin_4_spks_Cnt = sum(postSpontWin_4_spks);
    
    preSpontWin_sumRep_cntcheck = sum(preSpontWin_sumRep);
    stimWin_1_sumRep_cntcheck =  sum(stimWin_1_sumRep);
    stimWin_2_sumRep_cntcheck = sum(stimWin_2_sumRep);
    stimWin_3_sumRep_cntcheck = sum(stimWin_3_sumRep);
    postSpontWin_1_sumRep_cntcheck =   sum(postSpontWin_1_sumRep);
    postSpontWin_2_sumRep_cntcheck =  sum(postSpontWin_2_sumRep);
    postSpontWin_3_sumRep_cntcheck =  sum(postSpontWin_3_sumRep);
    postSpontWin_4_sumRep_cntcheck =   sum(postSpontWin_4_sumRep);
    
    
    preSpontWin_meanFR = nanmean(nanmean(preSpontWin_FR));
    stimWin_1_meanFR = nanmean(nanmean(stimWin_1_FR));
    stimWin_2_meanFR = nanmean(nanmean(stimWin_2_FR));
    stimWin_3_meanFR = nanmean(nanmean(stimWin_3_FR));
    postSpontWin_1_meanFR = nanmean(nanmean(postSpontWin_1_FR));
    postSpontWin_2_meanFR = nanmean(nanmean(postSpontWin_2_FR));
    postSpontWin_3_meanFR = nanmean(nanmean(postSpontWin_3_FR));
    postSpontWin_4_meanFR = nanmean(nanmean(postSpontWin_4_FR));
    
    preSpontWin_std = nanstd(nanstd(preSpontWin_FR));
    stimWin_1_std = nanstd(nanstd(stimWin_1_FR));
    stimWin_2_std = nanstd(nanstd(stimWin_2_FR));
    stimWin_3_std = nanstd(nanstd(stimWin_3_FR));
    postSpontWin_1_std = nanstd(nanstd(postSpontWin_1_FR));
    postSpontWin_2_std = nanstd(nanstd(postSpontWin_2_FR));
    postSpontWin_3_std = nanstd(nanstd(postSpontWin_3_FR));
    postSpontWin_4_std = nanstd(nanstd(postSpontWin_4_FR));
    
    %covar = cov(reshape(FR_Stim, 1, numel(FR_Stim)), reshape(FR_Spont, 1, numel(FR_Spont)));
    %z_score_cov = (meanStim - meanSpont) / sqrt((stdStim^2 + stdSpont^2) - 2*covar(1, 2));
    
    % covar_preSpont = cov(reshape(preSpontWin_FR, 1, numel(preSpontWin_FR)), reshape(preSpontWin_FR, 1, numel(preSpontWin_FR)));
    % z_score_cov_preSpont = real((preSpontWin_meanFR - preSpontWin_meanFR) / sqrt((preSpontWin_std^2 + preSpontWin_std^2) - 2*covar(1, 2)));
    %
    % covar_stimWin1 = cov(reshape(stimWin_1_FR, 1, numel(stimWin_1_FR)), reshape(preSpontWin_FR, 1, numel(preSpontWin_FR)));
    % z_score_cov_stimWin1 = real((stimWin_1_meanFR - preSpontWin_meanFR) / sqrt((stimWin_1_std^2 + preSpontWin_std^2) - 2*covar(1, 2)));
    %
    % covar_stimWin2 = cov(reshape(stimWin_2_FR, 1, numel(stimWin_2_FR)), reshape(preSpontWin_FR, 1, numel(preSpontWin_FR)));
    % z_score_cov_stimWin2 = real((stimWin_2_meanFR - preSpontWin_meanFR) / sqrt((stimWin_2_std^2 + preSpontWin_std^2) - 2*covar(1, 2)));
    %
    % covar_stimWin3 = cov(reshape(stimWin_3_FR, 1, numel(stimWin_3_FR)), reshape(preSpontWin_FR, 1, numel(preSpontWin_FR)));
    % z_score_cov_stimWin3 = real((stimWin_3_meanFR - preSpontWin_meanFR) / sqrt((stimWin_3_std^2 + preSpontWin_std^2) - 2*covar(1, 2)));
    %
    % covar_postSpontWin_1 = cov(reshape(postSpontWin_1_FR, 1, numel(postSpontWin_1_FR)), reshape(preSpontWin_FR, 1, numel(preSpontWin_FR)));
    % z_score_cov_postSpontWin_1 = real((postSpontWin_1_meanFR - preSpontWin_meanFR) / sqrt((postSpontWin_1_std^2 + preSpontWin_std^2) - 2*covar(1, 2)));
    %
    % covar_postSpontWin_2 = cov(reshape(postSpontWin_2_FR, 1, numel(postSpontWin_2_FR)), reshape(preSpontWin_FR, 1, numel(preSpontWin_FR)));
    % z_score_cov_postSpontWin_2 = real((postSpontWin_2_meanFR - preSpontWin_meanFR) / sqrt((postSpontWin_2_std^2 + preSpontWin_std^2) - 2*covar(1, 2)));
    %
    % covar_postSpontWin_3 = cov(reshape(postSpontWin_3_FR, 1, numel(postSpontWin_3_FR)), reshape(preSpontWin_FR, 1, numel(preSpontWin_FR)));
    % z_score_cov_postSpontWin_3 = real((postSpontWin_3_meanFR - preSpontWin_meanFR) / sqrt((postSpontWin_3_std^2 + preSpontWin_std^2) - 2*covar(1, 2)));
    %
    % covar_postSpontWin_4 = cov(reshape(postSpontWin_4_FR, 1, numel(postSpontWin_4_FR)), reshape(preSpontWin_FR, 1, numel(preSpontWin_FR)));
    % z_score_cov_postSpontWin_4 = real((postSpontWin_4_meanFR - preSpontWin_meanFR) / sqrt((postSpontWin_4_std^2 + preSpontWin_std^2) - 2*covar(1, 2)));
    
    
    %z_score_cov = (meanStim - meanSpont) / sqrt((stdStim^2 + stdSpont^2)
    
    z_score_cov_preSpont = (preSpontWin_meanFR - preSpontWin_meanFR) / sqrt(preSpontWin_std^2 + preSpontWin_std^2);
    
    z_score_cov_stimWin1 = (stimWin_1_meanFR - preSpontWin_meanFR) / sqrt(stimWin_1_std^2 + preSpontWin_std^2);
    
    z_score_cov_stimWin2 = (stimWin_2_meanFR - preSpontWin_meanFR) / sqrt(stimWin_2_std^2 + preSpontWin_std^2);
    
    z_score_cov_stimWin3 = (stimWin_3_meanFR - preSpontWin_meanFR) / sqrt(stimWin_3_std^2 + preSpontWin_std^2);
    
    z_score_cov_postSpontWin_1 = (postSpontWin_1_meanFR - preSpontWin_meanFR) / sqrt(postSpontWin_1_std^2 + preSpontWin_std^2);
    
    z_score_cov_postSpontWin_2 = (postSpontWin_2_meanFR - preSpontWin_meanFR) / sqrt(postSpontWin_2_std^2 + preSpontWin_std^2);
    
    z_score_cov_postSpontWin_3 = (postSpontWin_3_meanFR - preSpontWin_meanFR) / sqrt(postSpontWin_3_std^2 + preSpontWin_std^2);
    
    z_score_cov_postSpontWin_4 = (postSpontWin_4_meanFR - preSpontWin_meanFR) / sqrt(postSpontWin_4_std^2 + preSpontWin_std^2);
    
    
    allZScores = [z_score_cov_preSpont z_score_cov_stimWin1 z_score_cov_stimWin2 z_score_cov_stimWin3 z_score_cov_postSpontWin_1 z_score_cov_postSpontWin_2 z_score_cov_postSpontWin_3 z_score_cov_postSpontWin_4];
    allFrs = [preSpontWin_meanFR stimWin_1_meanFR stimWin_2_meanFR stimWin_3_meanFR postSpontWin_1_meanFR postSpontWin_2_meanFR postSpontWin_3_meanFR postSpontWin_4_meanFR];
    
    %% stats
    
    %ttest
    % [h, p_preSpontWin]  = ttest(reshape(preSpontWin_FR, 1, numel(preSpontWin_FR)), reshape(preSpontWin_FR, 1, numel(preSpontWin_FR)));
    % [h, p_stimWin_1]  = ttest(reshape(preSpontWin_FR, 1, numel(preSpontWin_FR)), reshape(stimWin_1_FR, 1, numel(stimWin_1_FR)));
    % [h, p_stimWin_2]  = ttest(reshape(preSpontWin_FR, 1, numel(preSpontWin_FR)), reshape(stimWin_2_FR, 1, numel(stimWin_2_FR)));
    % [h, p_stimWin_3]  = ttest(reshape(preSpontWin_FR, 1, numel(preSpontWin_FR)), reshape(stimWin_3_FR, 1, numel(stimWin_3_FR)));
    % [h, p_postSpontWin_1]  = ttest(reshape(preSpontWin_FR, 1, numel(preSpontWin_FR)), reshape(postSpontWin_1_FR, 1, numel(postSpontWin_1_FR)));
    % [h, p_postSpontWin_2]  = ttest(reshape(preSpontWin_FR, 1, numel(preSpontWin_FR)), reshape(postSpontWin_2_FR, 1, numel(postSpontWin_2_FR)));
    % [h, p_postSpontWin_3]  = ttest(reshape(preSpontWin_FR, 1, numel(preSpontWin_FR)), reshape(postSpontWin_3_FR, 1, numel(postSpontWin_3_FR)));
    % [h, p_postSpontWin_4]  = ttest(reshape(preSpontWin_FR, 1, numel(preSpontWin_FR)), reshape(postSpontWin_4_FR, 1, numel(postSpontWin_4_FR)));
    
    %signrank
    [p_preSpontWin, h]  = signrank(reshape(preSpontWin_FR, 1, numel(preSpontWin_FR)), reshape(preSpontWin_FR, 1, numel(preSpontWin_FR)));
    [p_stimWin_1, h]  = signrank(reshape(preSpontWin_FR, 1, numel(preSpontWin_FR)), reshape(stimWin_1_FR, 1, numel(stimWin_1_FR)));
    [p_stimWin_2, h]  = signrank(reshape(preSpontWin_FR, 1, numel(preSpontWin_FR)), reshape(stimWin_2_FR, 1, numel(stimWin_2_FR)));
    [p_stimWin_3, h]  = signrank(reshape(preSpontWin_FR, 1, numel(preSpontWin_FR)), reshape(stimWin_3_FR, 1, numel(stimWin_3_FR)));
    [p_postSpontWin_1, h]  = signrank(reshape(preSpontWin_FR, 1, numel(preSpontWin_FR)), reshape(postSpontWin_1_FR, 1, numel(postSpontWin_1_FR)));
    [p_postSpontWin_2, h]  = signrank(reshape(preSpontWin_FR, 1, numel(preSpontWin_FR)), reshape(postSpontWin_2_FR, 1, numel(postSpontWin_2_FR)));
    [p_postSpontWin_3, h]  = signrank(reshape(preSpontWin_FR, 1, numel(preSpontWin_FR)), reshape(postSpontWin_3_FR, 1, numel(postSpontWin_3_FR)));
    [p_postSpontWin_4, h]  = signrank(reshape(preSpontWin_FR, 1, numel(preSpontWin_FR)), reshape(postSpontWin_4_FR, 1, numel(postSpontWin_4_FR)));
    
    
    allPs = [p_preSpontWin p_stimWin_1 p_stimWin_2 p_stimWin_3 p_postSpontWin_1 p_postSpontWin_2 p_postSpontWin_3 p_postSpontWin_4];
    
    
    
    %% Figure
    
    %% Sort Data
    dataSort = [];
    dataInfo = [];
    
    n_elev = 9;
    n_azim = 22;
    
    ea_cnt = 1;
    for elev = 1:n_elev
        for azim = 1:n_azim
            dataSort{azim, elev} = data(ea_cnt).sweep;
            dataInfo{azim, elev} = data(ea_cnt).stim;
            ea_cnt = ea_cnt+1;
        end
    end
    
    %% Raster
    figH = figure (201); clf
    blueCol = [0.2 0.7 0.8];
    subplot(7, 1, [1 2 3 4])
    
    gray = [0.5 0.5 0.5];
    
    hold on
    qcnt = 0;
    for q = 1:100
        
        xes = [0 400 400 0];
        yes = [qcnt qcnt  qcnt+10 qcnt+10];
        a = patch(xes,  yes, gray);
        set(a,'EdgeColor','none')
        a.FaceAlpha = 0.2;
        
        qcnt  = qcnt + 20;
        
    end
    
    cnt = 1;
    for azim = 1:n_azim
        for elev = 1:n_elev
            
            for k = 1:n_reps
                
                %must subtract start_stim to arrange spikes relative to onset
                theseSpks = dataSort{azim, elev}(k).spikes;
                ypoints = ones(numel(theseSpks))*cnt;
                hold on
                plot(theseSpks, ypoints, 'k.', 'linestyle', 'none', 'MarkerFaceColor','k','MarkerEdgeColor','k')
                
                cnt = cnt +1;
                
            end
            
            
            if elev == n_elev
                line([0 400], [cnt cnt], 'color', blueCol)
                disp('')
                %text(5, cnt-30, num2str(dataInfo{azim, elev}(13)))
            end
            
        end
        
    end
    set(gca,'ytick',[])
    title (filToLoad)
    %xlabel('Time [ms]')
    ylabel('Reps | Azimuth')
    %% PSTH
    binwidth_s=0.001;%[s]
    max_time=(data(1).sweeplength)/1000;%[ms]
    spike_times=[]; psthall = [];
    htime=0:binwidth_s:max_time;
    for yy=1:n_reps
        for xy = 1:n_stims
            %if 1-isempty(data(xy).sweep);%eingef�gt 6.12.04
            spike_times=[spike_times data(xy).sweep(yy).spikes]; % concat all spikes in ms
            %end
        end
    end
    % convert to seconds
    spike_times=spike_times/1e3; % convert back to s
    
    psth=histc(spike_times,htime);
    psthall(xy,:)=psth; % what does this do
    summenpsth=sum(psthall); % this is the same as psth
    
    %spontlevel=(std(summenpsth(1:50))*2)+mean(summenpsth(1:50)); %2x std
    %spontmean = mean(summenpsth(1:50));
    %spontstd = std(summenpsth(1:50))*3;
    
    %maxspikecount=max(summenpsth);
    
    preStimArea = 1:51;
    stimArea = 51:200;
    postStimArea = 200:401;
    
    %% figure
    
    blueCol = [0.2 0.7 0.8];
    greencol = [0.2 0.8 0.7];
    redCol = [0.8 0.3 0.3];
    
    
    
    smoothWin_ms = 5;
    %smooth_psth = smooth(summenpsth, smoothWin_ms);
    %smooth_psth = smooth(summenpsth, smoothWin_ms, 'loess');
    smooth_psth = smooth(summenpsth, smoothWin_ms, 'lowess');
    
    maxPsth = max(summenpsth);
    maxSmoothPsth = max(smooth_psth);
    
    subplot(7, 1, [ 5 6])
    
    a = area([preStimArea(1)  preStimArea(end)], [maxPsth maxPsth], 'FaceColor', gray);
    set(a,'EdgeColor','none')
    a.FaceAlpha = 0.2;
    hold on
    
    a = area([stimArea(1)  stimArea(end)], [maxPsth maxPsth], 'FaceColor', greencol);
    set(a,'EdgeColor','none')
    a.FaceAlpha = 0.4;
    hold on
    
    a = area([postStimArea(1)  postStimArea(end)], [maxPsth maxPsth], 'FaceColor', gray);
    set(a,'EdgeColor','none')
    a.FaceAlpha = 0.2;
    hold on
    
    plot(summenpsth, 'color', gray)
    
    plot(smooth_psth, 'k', 'linewidth' ,2);
    axis tight
    
    xlabel('Time [ms]')
    ylabel('PSTH [spks]')
    %%
    subplot(7, 1, [7])
    imagesc(allZScores);
    %colormap('hot')
    colormap('bone')
    colormap('pink')
    hold on
    for o = 1:8
        text(o-.2, 1, ['Z = ' num2str(round(allZScores(o), 2))])
        text(o-.2, 1.2, ['p = ' num2str(round(allPs(o), 4))])
        
    end
    
    disp('')
    %%
    disp('Printing Plot')
    set(0, 'CurrentFigure', figH)
    
    dropBoxSavePath = [saveDir saveName '-RasterPsthZscore'];
    
    plotpos = [0 0 35 40];
    print_in_A4(0, dropBoxSavePath , '-djpeg', 0, plotpos);
    %print_in_A4(0, dropBoxSavePath, '-depsc', 0, plotpos);
    %dropBoxSavePath = [fiGSavePath saveName '-RasterPsthZscore_vZ'];
    %print_in_A4(0, dropBoxSavePath, '-depsc', 1, plotpos);
    %% Now makin SRFs
    
    %%Sort Spike COunts
    
    preSpontWin_sumRep_cntcheck = sum(preSpontWin_sumRep);
    stimWin_1_sumRep_cntcheck =  sum(stimWin_1_sumRep);
    stimWin_2_sumRep_cntcheck = sum(stimWin_2_sumRep);
    stimWin_3_sumRep_cntcheck = sum(stimWin_3_sumRep);
    postSpontWin_1_sumRep_cntcheck =   sum(postSpontWin_1_sumRep);
    postSpontWin_2_sumRep_cntcheck =  sum(postSpontWin_2_sumRep);
    postSpontWin_3_sumRep_cntcheck =  sum(postSpontWin_3_sumRep);
    postSpontWin_4_sumRep_cntcheck =   sum(postSpontWin_4_sumRep);
    
    
    
    %%
    preSpontWin_spkCntSort = [];
    stimWin_1_spkCntSort = [];
    stimWin_2_spkCntSort = [];
    stimWin_3_spkCntSort = [];
    postSpontWin_1_spkCntSort = [];
    postSpontWin_2_spkCntSort = [];
    postSpontWin_3_spkCntSort = [];
    postSpontWin_4_spkCntSort = [];
    
    n_elev = 9;
    n_azim = 22;
    
    %% Needs to be in this order
    ct = 1;
    for elev = 1:n_elev
        for azim = 1:n_azim
            
            preSpontWin_spkCntSort(azim, elev) = preSpontWin_sumRep(ct);
            stimWin_1_spkCntSort(azim, elev) = stimWin_1_sumRep(ct);
            stimWin_2_spkCntSort(azim, elev) = stimWin_2_sumRep(ct);
            stimWin_3_spkCntSort(azim, elev) = stimWin_3_sumRep(ct);
            postSpontWin_1_spkCntSort(azim, elev) = postSpontWin_1_sumRep(ct);
            postSpontWin_2_spkCntSort(azim, elev) = postSpontWin_2_sumRep(ct);
            postSpontWin_3_spkCntSort(azim, elev) = postSpontWin_3_sumRep(ct);
            postSpontWin_4_spkCntSort(azim, elev) = postSpontWin_4_sumRep(ct);
            
            ct = ct+1;
        end
    end
    
    %% We do not normalize
    
    %maxispike=max(max(Spikearray));
    %maxispike=round(maxispike*10)/10;
    %Spikearray=Spikearray/max(max(Spikearray));
    
    %% smooth & rotate
    
    preSpontWin_smoothSpkArray = rot90(moving_average2(preSpontWin_spkCntSort(:,:),1,1));% rows ;collumns
    stimWin_1_smoothSpkArray = rot90(moving_average2(stimWin_1_spkCntSort(:,:),1,1));% rows ;collumns
    stimWin_2_smoothSpkArray = rot90(moving_average2(stimWin_2_spkCntSort(:,:),1,1));% rows ;collumns
    stimWin_3_smoothSpkArray = rot90(moving_average2(stimWin_3_spkCntSort(:,:),1,1));% rows ;collumns
    postSpontWin_1_smoothSpkArray = rot90(moving_average2(postSpontWin_1_spkCntSort(:,:),1,1));% rows ;collumns
    postSpontWin_2_smoothSpkArray = rot90(moving_average2(postSpontWin_2_spkCntSort(:,:),1,1));% rows ;collumns
    postSpontWin_3_smoothSpkArray = rot90(moving_average2(postSpontWin_3_spkCntSort(:,:),1,1));% rows ;collumns
    postSpontWin_4_smoothSpkArray = rot90(moving_average2(postSpontWin_4_spkCntSort(:,:),1,1));% rows ;collumns
    
    %smoothSpikearray_norm=smoothSpikearray/max(max(smoothSpikearray));
    
    
    %% Plot
    
    cScale = [0 5];
    
    figHH  = figure(100);clf
    
   
    plotAudSpatRFs(figHH, preSpontWin_smoothSpkArray, 1, 0, 'Pre-Spont')
    
%     subplot(1, 8, 1)
%     surf(preSpontWin_smoothSpkArray);
%     shading interp
%     view([ 0 90])
%     axis tight
%     caxis(cScale)
%     title('Pre-Spont')
%     set(gca,'ytick',[])
%     set(gca,'xtick',[])
%     xlabel('Azimuth')
%     ylabel('Elevation')
    
plotAudSpatRFs(figHH, stimWin_1_smoothSpkArray, 2, 0, 'Stim-1')

%     subplot(1, 8, 2)
%     surf((stimWin_1_smoothSpkArray));
%     shading interp
%     view([ 0 90])
%     axis tight
%     clim([cmin, cmax])
%     title('Stim-1')
%     set(gca,'ytick',[])
%     set(gca,'xtick',[])
%     xlabel('Azimuth')
%     %ylabel('Elevation')
    

plotAudSpatRFs(figHH, stimWin_2_smoothSpkArray, 3, 0, 'Stim-2')

%     subplot(1, 8, 3)
%     surf((stimWin_2_smoothSpkArray));
%     shading interp
%     view([0 90])
%     axis tight
%     clim([cmin, cmax])
%     title('Stim-2')
%     set(gca,'ytick',[])
%     set(gca,'xtick',[])
%     xlabel('Azimuth')
%     %ylabel('Elevation')
%     

plotAudSpatRFs(figHH, stimWin_3_smoothSpkArray, 4, 0, 'Stim-3')

% subplot(1, 8, 4)
%     surf((stimWin_3_smoothSpkArray));
%     shading interp
%     view([ 0 90])
%     clim([cmin, cmax])
%     axis tight
%     title('Stim-3')
%     set(gca,'ytick',[])
%     set(gca,'xtick',[])
%     xlabel('Azimuth')
%     %ylabel('Elevation')
    
    
plotAudSpatRFs(figHH, postSpontWin_1_smoothSpkArray, 5, 0, 'Post-Spont-1')
%     subplot(1, 8, 5)
%     surf((postSpontWin_1_smoothSpkArray));
%     shading interp
%     view([ 0 90])
%     axis tight
%     clim([cmin, cmax])
%     title('Post-Spont-1')
%     set(gca,'ytick',[])
%     set(gca,'xtick',[])
%     xlabel('Azimuth')
%     %ylabel('Elevation')
    
plotAudSpatRFs(figHH, postSpontWin_2_smoothSpkArray, 6, 0, 'Post-Spont-2')
%     subplot(1, 8, 6)
%     surf((postSpontWin_2_smoothSpkArray));
%     shading interp
%     view([ 0 90])
%     axis tight
%     clim([cmin, cmax])
%     title('Post-Spont-2')
%     set(gca,'ytick',[])
%     set(gca,'xtick',[])
%     xlabel('Azimuth')
%     %ylabel('Elevation')
    
    
plotAudSpatRFs(figHH, postSpontWin_3_smoothSpkArray, 7, 0, 'Post-Spont-3')
%     subplot(1, 8, 7)
%     surf((postSpontWin_3_smoothSpkArray));
%     shading interp
%     view([ 0 90])
%     axis tight
%     clim([cmin, cmax])
%     title('Post-Spont-3')
%     set(gca,'ytick',[])
%     set(gca,'xtick',[])
%     xlabel('Azimuth')
%     %ylabel('Elevation')
    
plotAudSpatRFs(figHH, postSpontWin_4_smoothSpkArray, 8, 0, 'Post-Spont-4')

%     subplot(1, 8, 8)
%     surf((postSpontWin_4_smoothSpkArray));
%     shading interp
%     view([ 0 90])
%     axis tight
%     clim([cmin, cmax])
%     title('Post-Spont-4')
%     set(gca,'ytick',[])
%     set(gca,'xtick',[])
%     xlabel('Azimuth')
%     %ylabel('Elevation')
%     
    

plotAudSpatRFs(figHH, preSpontWin_smoothSpkArray, 9, 1, 'Pre-Spont')

plotAudSpatRFs(figHH, stimWin_1_smoothSpkArray, 10, 1, 'Stim-1')

plotAudSpatRFs(figHH, stimWin_2_smoothSpkArray, 11, 1, 'Stim-2')

plotAudSpatRFs(figHH, stimWin_3_smoothSpkArray, 12, 1, 'Stim-3')

plotAudSpatRFs(figHH, postSpontWin_1_smoothSpkArray, 13, 1, 'Post-Spont-1')

plotAudSpatRFs(figHH, postSpontWin_2_smoothSpkArray, 14, 1, 'Post-Spont-2')

plotAudSpatRFs(figHH, postSpontWin_3_smoothSpkArray, 15, 1, 'Post-Spont-3')

plotAudSpatRFs(figHH, postSpontWin_4_smoothSpkArray, 16, 1, 'Post-Spont-4')

    %%
    disp('Printing Plot')
    set(0, 'CurrentFigure', figHH)
    
    dropBoxSavePath = [saveDir saveName '-SpatialRFstest'];
    
    plotpos = [0 0 40 10];
    print_in_A4(0, dropBoxSavePath , '-djpeg', 0, plotpos);
    %print_in_A4(0, dropBoxSavePath, '-depsc', 0, plotpos);
    
end

%%


end


function [] = plotAudSpatRFs(FigH, dataToPlot, plotPos, ifScale, titleTxt)

cScale = [0 5];

    figure(FigH)
    
    subplot(2, 8, plotPos)
    surf(dataToPlot);
    shading interp
    view([ 0 90])
    axis tight
    
    if ifScale
        caxis(cScale)
    end
    
    title(titleTxt)
    set(gca,'ytick',[])
    set(gca,'xtick',[])
    xlabel('Azimuth')
    ylabel('Elevation')

end
