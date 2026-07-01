function [] = exploreBurstAnalysis()
dbstop if error

dirBurstFiles = ['/home/janie/Dropbox/02_talks/2026/BCCN/Data/BurstData/'];
%plotDir = ['X:\EEG-LFP-songLearning\JaniesAnalysis\ALL_PLOTS\w025\All_LFP_dy\BurstDetection\Plots\'];



fileNames = dir(fullfile(dirBurstFiles, '*.mat'));

index = strfind({fileNames.name}, ['BurstDetection']);
idx = find(~cellfun(@isempty,index));
FileNames =  fileNames(idx);
nFiles = numel(FileNames);


for k = 1:nFiles
    %fileToLoad = 'X:\EEG-LFP-songLearning\JaniesAnalysis\ALL_PLOTS\w025\All_LFP_dy\BurstDetection\chronic_2021-07-14_20-24-58_BurstDetection-7.mat';
    fileToLoad = FileNames(k).name;


    load([dirBurstFiles fileToLoad])
    deltaMask = BURSTS.deltaMask;
    allRipples__Delta_peakDur_s = BURSTS.allRipples__Delta_peakDur_s;
    allRipples_NonDelta_peakDur_s = BURSTS.allRipples_NonDelta_peakDur_s;
    nonDelta_peakTimes_peakPower = BURSTS.nonDelta_peakTimes_peakPower;
    Delta_peakTimes_peakPower= BURSTS.Delta_peakTimes_peakPower;

    nBins = numel(Delta_peakTimes_peakPower);
    allDeltaMask = [];
    allDeltaDur_ms = [];
    allNonDeltaDur_ms = [];
    allNonDelta_pP = [];
    allDelta_pP = [];

    for j = 1:nBins



        % subplot(5, 1, 1)
        %
        % plot(deltaMask(:,j) )
        % ylim([-0.5 1.5])
        % title ('Delta mask')
        allDeltaMask  = [allDeltaMask ; deltaMask(:,j)];



        deltaDur_ms = allRipples__Delta_peakDur_s{:, j}*1000;
        nondeltaDur_ms = allRipples_NonDelta_peakDur_s{:, j}*1000;



        allDeltaDur_ms = [allDeltaDur_ms ; deltaDur_ms];


        % subplot(5, 1, 3)
        % histogram(nondeltaDur_ms, edges)
        % ylim([0 5])


        allNonDeltaDur_ms = [allNonDeltaDur_ms ; nondeltaDur_ms];

        delta_pP = Delta_peakTimes_peakPower{:, j};
        nondelta_pP = nonDelta_peakTimes_peakPower{:, j};



        allDelta_pP = [allDelta_pP ;delta_pP];


        allNonDelta_pP = [allNonDelta_pP;  nondelta_pP];

    end


    disp('')
    figure(104); clf

    edges = 0:1:60;
    subplot(5, 1, 2)
    histogram(allDeltaDur_ms, edges, 'normalization', 'probability')
    title ('Delta dur ms')
    ylim([0 0.1])

    subplot(5, 1, 3)
    histogram(allNonDeltaDur_ms, edges, 'normalization', 'probability')
    title ('NonDelta dur ms')
    ylim([0 0.1])

    edges = 0:0.5:10;

    subplot(5, 1, 4)
    histogram(allDelta_pP, edges, 'normalization', 'probability')
    title ('Delta pP')
    ylim([0 0.3])

    subplot(5, 1, 5)
    histogram(allNonDelta_pP, edges, 'normalization', 'probability')
    title ('NonDelta pP')
    ylim([0 0.3])


    subplot(5, 1, 1)

    deltabins = sum(allDeltaMask);
    allBins = numel(allDeltaMask);
    deltafraction = deltabins/allBins;

    title([INFO.EphysRecName ' | delta fraction: ' num2str(deltafraction)], 'interpreter', 'none')
    axis off


    plotpos = [0 0 15 10];
    save_txt = [INFO.EphysRecName '_burstsummary'];
    plot_filename = [plotDir save_txt];
    print_in_A4(0, plot_filename, '-djpeg', 0, plotpos);
    %print_in_A4(0, plot_filename, '-depsc', 0, plotpos);

end


%derivdelta = abs(diff(allDeltaMask));
%absderivdelta = abs(derivdelta);

%bla = find(derivdelta > 0);
%bla2 = find(derivdelta < 0);

%plot(-derivdelta(1:60000))
%hold on
%plot(allDeltaMask(1:60000))
%ylim([-0.5 1.5])



end