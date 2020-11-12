function [] = PoolStatsOverWNSTAs()

switch gethostname
    case 'dlc'
        
        STADir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/Figs/STA-WN/RasterSTA/WNSTAs/';
        
    case 'SALAMANDER'
        
        STADir = '/home/janie/Data/OTProject/MLD/Figs/STA-WN/RasterSTA/WNSTAs/';
        
end

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
   
   
 allTDetections = 20-d.STA.TDetections_ms;
   ndets= numel(allTDetections);
   allTDets{s} = allTDetections;
   for j = 1:ndets
       alldetsT(cnnt) = allTDetections(j);
       cnnt = cnnt+1;
   end
   
   
end

    
    cols = cell2mat({[0.6350, 0.0780, 0.1840]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; [0, 0, 0]; [0.4940, 0.1840, 0.5560]});
    
    %%
    
    figure(406); clf
    jitterAmount = 0.1;
    jitterValues1 = 2*(rand(size(alldetsF))-0.5)*jitterAmount;   % +
    
    yes = [jitterValues1];
    
    
    h = scatterhist(alldetsF,yes,'Kernel','on', 'Location','NorthEast',...
        'Direction','out', 'LineStyle',{'-'}, 'Marker','..', 'Markersize', 20, 'color', cols{1});
    
    clr = get(h(1),'colororder');
    boxplot(h(2),alldetsF,'orientation','horizontal',...
        'label',{''},'color',cols, 'plotstyle', 'compact', 'Whisker', 10);
    
    
    axis(h(2),'auto');  % Sync axes
    
    FigSaveDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/Figs/STA-WN/RasterSTA/';
    
    
    plotpos = [0 0 12 10];
    print_in_A4(0, [FigSaveDir 'Fdetections'], '-depsc', 0, plotpos);

    %%
    
    
 jitterAmount = 0.1;
    jitterValues1 = 2*(rand(size(alldetsT))-0.5)*jitterAmount;   % +
    
    yes = [jitterValues1];
   
figure(407);clf
    


    h = scatterhist(alldetsT,yes,'Kernel','on', 'Location','NorthEast',...
        'Direction','out', 'LineStyle',{'-'}, 'Marker','..', 'Markersize', 20, 'color', cols(5,:));
    
    clr = get(h(1),'colororder');
    boxplot(h(2),alldetsT,'orientation','horizontal',...
        'label',{''},'color',cols(5,:), 'plotstyle', 'compact', 'Whisker', 10);
    
    
    axis(h(2),'auto');  % Sync axes

    
     plotpos = [0 0 12 10];
    print_in_A4(0, [FigSaveDir 'Tdetections'], '-depsc', 0, plotpos);
end
