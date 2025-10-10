function [] = PoolStatsOverWNSTAs()

switch gethostname
    case 'PLUTO'
        
        STADir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/Figs/STA-WN/STA-TimeFreq/STAs/';
        
    case 'SALAMANDER'
        
        STADir = '/home/janie/Data/OTProject/MLD/Figs/STA-WN/RasterSTA/WNSTAs/';
        
    case 'NEUROPIXELS'
        STADir = 'X:\Janie-OT-MLD\OT-MLD\OT_Project_2021-Final\MLD\Figs\STAAnalysis\STA-2024\WN\WN-STA-matFiles\';
    case 'DESKTOP-PBLRH65'
        STADir = 'X:\Janie-OT-MLD\OT-MLD\OT_Project_2021-Final\MLD\Figs\STAAnalysis\STA-2025-WN\';
        
end


    FigSaveDir = 'X:\Janie-OT-MLD\OT-MLD\OT_Project_2021-Final\MLD\Figs\STAAnalysis\STA-2025-WN\';
    

trialSeach = ['*.mat*'];

trialNamesStruct = dir(fullfile(STADir, trialSeach));
nTrials = numel(trialNamesStruct);
for j = 1:nTrials
    trialNames{j} = trialNamesStruct(j).name;
end

%%
%Expset = [1:8 34];
alldetsT = [];
alldetsF = [];

cnt = 1;
cnnt = 1;
for s = 1:nTrials
    
   d = load([STADir trialNames{s}]);
        
   allFDetections = d.STA.FDetections_kHz;
   ndets= numel(allFDetections);
   allFDets{s} = allFDetections;
   
   for j = 1:ndets
       alldetsF(cnt) = allFDetections(j);
       cnt = cnt+1;
   end
   
   
 allTDetections = d.STA.TDetections_ms;
   ndets= numel(allTDetections);
   allTDets{s} = allTDetections;
   for j = 1:ndets
       alldetsT(cnnt) = allTDetections(j);
       cnnt = cnnt+1;
   end
   
   
   nSpikes(s) = d.STA.nSpikes;
   
   
end

singleFreqs = numel(find(cell2mat(cellfun(@numel,allFDets','uni',0)) ==1 ));
doubleFreqs = numel(find(cell2mat(cellfun(@numel,allFDets','uni',0)) ==2 ));
totalFreqs = doubleFreqs + singleFreqs;

singleFreqs_percent = singleFreqs/totalFreqs*100;
doubleFreqs_percent = doubleFreqs/totalFreqs*100;

highTs = find(alldetsT >2.0);
alldetswOutLowTs = alldetsT(highTs);
    
maxF = max(alldetsF);
minF = min(alldetsF);
medianF = median(alldetsF);

%%
singleTimes = numel(find(cell2mat(cellfun(@numel,allTDets','uni',0)) ==1 ));
doubleTimes = numel(find(cell2mat(cellfun(@numel,allTDets','uni',0)) ==2 ));
zeroTimes= numel(find(cell2mat(cellfun(@numel,allTDets','uni',0)) ==0 ));
totalTimes = singleTimes + doubleTimes;

singleTimes_percent = singleTimes/totalTimes*100;
doubleTimes_percent = doubleTimes/totalTimes*100;

minTime = min(alldetsT);
maxTime = max(alldetsT);



    cols = cell2mat({[0.6350, 0.0780, 0.1840]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; [0, 0, 0]; [0.4940, 0.1840, 0.5560]});
    
    %%
    
    figure(406); clf
    jitterAmount = 0.1;
    jitterValues1 = 2*(rand(size(alldetsF))-0.5)*jitterAmount;   % +
    
    yes = [jitterValues1];
    
    
    h = scatterhist(alldetsF,yes,'Kernel','on', 'Location','NorthEast',...
        'Direction','out', 'LineStyle',{'-'}, 'Marker','..', 'Markersize', 20, 'color', cols(1,:));
    
    clr = get(h(1),'colororder');
    boxplot(h(2),alldetsF,'orientation','horizontal',...
        'label',{''},'color',cols(1,:), 'plotstyle', 'compact', 'Whisker', 10);
    
    
    axis(h(2),'auto');  % Sync axes
    
    
    plotpos = [0 0 12 10];
    print_in_A4(0, [FigSaveDir 'Fdetections'], '-depsc', 0, plotpos);

    %%
    
figure(407);clf
    
alldetsT = alldetswOutLowTs;
%alldetsT = alldetsT;

 jitterAmount = 0.1;
    jitterValues1 = 2*(rand(size(alldetsT))-0.5)*jitterAmount;   % +
    
    yes = [jitterValues1];
    
    h = scatterhist(alldetsT,yes,'Kernel','on', 'Location','NorthEast',...
        'Direction','out', 'LineStyle',{'-'}, 'Marker','..', 'Markersize', 20, 'color', cols(5,:));
    
    clr = get(h(1),'colororder');
    boxplot(h(2),alldetsT,'orientation','horizontal',...
        'label',{''},'color',cols(5,:), 'plotstyle', 'compact', 'Whisker', 10);
    
    
    axis(h(2),'auto');  % Sync axes
  yss = ylim
    line([2 2], [yss(1) yss(2)], 'color', 'k', 'linestyle', ':')
    
     plotpos = [0 0 12 10];
    print_in_A4(0, [FigSaveDir 'Tdetections_nolows'], '-depsc', 0, plotpos);
    print_in_A4(0, [FigSaveDir 'Tdetections_nolows'], '-djpeg', 0, plotpos);
    %print_in_A4(0, [FigSaveDir 'Tdetections_wlows'], '-depsc', 0, plotpos);
    % print_in_A4(0, [FigSaveDir 'Tdetections_wlows'], '-djpeg', 0, plotpos);
end
