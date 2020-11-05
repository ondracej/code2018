function [] = plotZScoresDPrimes_MLD()

d = load('/media/janie/300GBPassport/OTProject/MLD/_0_AllData_Janie_DPrimePost.mat');

FigSaveDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/ForPaper/';
disp('')

figure(103); clf
%%


for j = 1:28
    
    FR_Stim(j) = nanmean(d.D.DATA.FR_Stim{j});
    FR_Spont(j) = nanmean(d.D.DATA.FR_Spont{j});
    FR_Spont_post(j) = nanmean(d.D.DATA.FR_Spont_post{j});
end

meanFRStim = nanmean(FR_Stim);
meanFRSpont = nanmean(FR_Spont);
meanFRSpontPost = nanmean(FR_Spont_post);

stdFRStim = std(FR_Stim);
stdFRSpont = std(FR_Spont);
stdFRSpontPost = std(FR_Spont_post);

semFRStim = stdFRStim / (sqrt(numel(FR_Stim)));
semFRSpont = stdFRSpont / (sqrt(numel(FR_Spont)));
semFRSpontPost = stdFRSpontPost / (sqrt(numel(FR_Spont_post)));

subplot(3, 2, 1)

bar(1,meanFRSpont, 'FaceColor',[1 1 1])
hold on
er = errorbar(1,meanFRSpont,semFRSpont, semFRSpont);
er.Color = [0 0 0];
er.LineStyle = 'none';

hold on
bar(2,meanFRStim, 'FaceColor',[0 .0 0])
er = errorbar(2,meanFRStim,semFRStim, semFRStim);
er.Color = [0 0 0];
er.LineStyle = 'none';

bar(3,meanFRSpontPost, 'FaceColor',[.5 .5 .5])
er = errorbar(3,meanFRSpontPost,semFRSpontPost, semFRSpontPost);
er.Color = [0 0 0];
er.LineStyle = 'none';

set(gca, 'xtick', [1 2 3]);
set(gca, 'xticklabel', {'Baseline' ; 'Stimulus' ; 'Post'});
ylabel('Firing  Rate [Hz]')
ylim ([0 30])


saveName = [FigSaveDir 'AuditoryPlots-HRTF-FR'];

  plotpos = [0 0 15 12];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);
disp('')
print_in_A4(0, saveName, '-depsc', 0, plotpos);

disp('')



%% Zscores for HRTF

zscores= cell2mat(d.D.DATA.ZScore);
xes = ones(1, numel(zscores));

posZscores = numel(find(zscores > 0.5));
negZscores = numel(find(zscores < -0.5));

posZscoresPercent = posZscores/numel(zscores)*100;
negZscoresPercent = negZscores/numel(zscores)*100;

% 
% subplot(3, 2, 2)
% scatter(xes, zscores, 'o', 'filled', 'jitter','on', 'jitterAmount',0.1);
% ylim([-5 11])
% xlim([.5 1.5])
% hold on
% line([.5 1.5], [0,0], 'color', 'k')
% line([.5 1.5], [.5,.5], 'color', 'k', 'linestyle', ':')
% line([.5 1.5], [-.5,-.5], 'color', 'k', 'linestyle', ':')
% set(gca,'xtick',[])
% ylabel('Z-Score')



    jitterAmount = 0.1;
    jitterValuesX = 2*(rand(size(zscores))-0.5)*jitterAmount;   % +
    
    cols = cell2mat({[0 0 0]; [.5 .5 .5]});
    %cols = cell2mat({[0.6350, 0.0780, 0.1840]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; [0, 0, 0]; [0.4940, 0.1840, 0.5560]});
    
    figure(102); clf
    h = scatterhist(zscores,jitterValuesX, 'Kernel','on', 'Location','NorthEast',...
        'Direction','out', 'LineStyle',{'-','-'}, 'Marker','..', 'Markersize', 20, 'color', cols);
    
    yss = ylim;
    xss = xlim;
    
    hold on
    line([.5 .5], [yss(1) yss(2)], 'color', 'k', 'linestyle', ':')
    line([-.5 -.5], [yss(1) yss(2)], 'color', 'k', 'linestyle', ':')
    
    
saveName = [FigSaveDir 'AuditoryPlots-HRTF-Z-score'];

  plotpos = [0 0 15 12];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);
disp('')
print_in_A4(0, saveName, '-depsc', 0, plotpos);

disp('')
    
%% Dprime
% 
% group2 = ones(1, size(rates, 2))*2;
% group3 = ones(1, size(rates, 2))*3;
% group4 = ones(1, size(rates, 2))*4;
% group5 = ones(1, size(rates, 2))*5;
% group6 = ones(1, size(rates, 2))*6;
% %group7 = ones(1, numel(n7_NightSWRs_h))*7;
% 
% groups = [group2 group3 group4 group5 group6];
% yes = [rates(1,:) rates(2,:) rates(3,:) rates(4,:) rates(5,:)];
% xes = [widths(1,:) widths(2,:) widths(3,:) widths(4,:) widths(5,:)];
% h = scatterhist(xes,yes,'Group',groups,'Kernel','on', 'Location','SouthEast',...
%     'Direction','out', 'LineStyle',{'-','-'}, 'Marker','..', 'color', cols);

group1 = ones(1, size(d.D.DATA.pooled_D_AZ_Stim, 2))*1;
group2 = ones(1, size(d.D.DATA.pooled_D_AZ_Spont, 2))*2;
groups = [group1 group2];

xes = [ d.D.DATA.pooled_D_AZ_Spont d.D.DATA.pooled_D_AZ_Stim] *-1;
yes = [ d.D.DATA.pooled_D_EL_Spont d.D.DATA.pooled_D_EL_Stim] ;


cols = cell2mat({[.5 .5 .5]; [0 0 0]});
%cols = cell2mat({[0.6350, 0.0780, 0.1840]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; [0, 0, 0]; [0.4940, 0.1840, 0.5560]});

 h = scatterhist(xes,yes,'Group',groups,'Kernel','on', 'Location','SouthEast',...
     'Direction','out', 'LineStyle',{'-','-'}, 'Marker','..', 'Markersize', 20, 'color', cols);

 yss = ylim;
 xss = xlim;
 
hold on
line([0 0], [yss(1) yss(2)], 'color', 'k', 'linestyle', '-')
line([xss(1) xss(2)], [0 0], 'color', 'k', 'linestyle', '-')

line([1 1], [yss(1) yss(2)], 'color', 'k', 'linestyle', ':')
line([-1 -1], [yss(1) yss(2)], 'color', 'k', 'linestyle', ':')
line([xss(1) xss(2)], [1 1], 'color', 'k', 'linestyle', ':')
line([xss(1) xss(2)], [-1 -1], 'color', 'k', 'linestyle', ':')




saveName = [FigSaveDir 'AuditoryPlots-DPrime'];

  plotpos = [0 0 15 12];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);
disp('')
print_in_A4(0, saveName, '-depsc', 0, plotpos);

disp('')




dprimeStim = d.D.DATA.pooled_D_AZ_Stim;

dprimeStim_simp = dd.D.DATA.pooled_D_AZ_Stim;

subplot(3, 2, 4)
scatter(xes, dprimeStim, 'o', 'filled', 'jitter','on', 'jitterAmount',0.1);
ylim([-10 40])
xlim([.5 1.5])
hold on
line([.5 1.5], [0,0], 'color', 'k')
line([.5 1.5], [1,1], 'color', 'k', 'linestyle', ':')
line([.5 1.5], [-1,-1], 'color', 'k', 'linestyle', ':')
set(gca,'xtick',[])
ylabel({'D-Prime Azimuth'; '(Left preference)'})
title('Stimulus')
dprimeSpont = d.D.DATA.pooled_D_AZ_Spont;

subplot(3, 2, 3)
scatter(xes, dprimeSpont, 'o', 'filled', 'jitter','on', 'jitterAmount',0.1);
ylim([-10 40])
xlim([.5 1.5])
hold on
line([.5 1.5], [0,0], 'color', 'k')
line([.5 1.5], [1,1], 'color', 'k', 'linestyle', ':')
line([.5 1.5], [-1,-1], 'color', 'k', 'linestyle', ':')
set(gca,'xtick',[])
ylabel({'D-Prime Azimuth'; '(Left preference)'})
title('Baseline')

dprimeStim = d.D.DATA.pooled_D_EL_Stim;

subplot(3, 2, 6)
scatter(xes, dprimeStim, 'o', 'filled', 'jitter','on', 'jitterAmount',0.1);
ylim([-10 5])
xlim([.5 1.5])
hold on
line([.5 1.5], [0,0], 'color', 'k')
line([.5 1.5], [1,1], 'color', 'k', 'linestyle', ':')
line([.5 1.5], [-1,-1], 'color', 'k', 'linestyle', ':')
set(gca,'xtick',[])
ylabel({'D-Prime Elevation Stim.' ; '(Top preference)'})
title('Stimulus')

dprimespont = d.D.DATA.pooled_D_EL_Spont;

subplot(3, 2, 5)
scatter(xes, dprimespont, 'o', 'filled', 'jitter','on', 'jitterAmount',0.1);
ylim([-10 5])
xlim([.5 1.5])
hold on
line([.5 1.5], [0,0], 'color', 'k')
line([.5 1.5], [1,1], 'color', 'k', 'linestyle', ':')
line([.5 1.5], [-1,-1], 'color', 'k', 'linestyle', ':')
set(gca,'xtick',[])
ylabel({'D-Prime Elevation' ; '(Top preference)'})
title('Baseline')

h = scatterhist(xes,dprimeStim,'Kernel','on', 'Location','SouthEast',...
    'Direction','out', 'LineStyle',{'-','-'}, 'Marker','..');


saveName = [FigSaveDir 'AuditoryPlots'];

plotpos = [0 0 25 20];
print_in_A4(0, saveName, '-djpeg', 1, plotpos);
disp('')
print_in_A4(0, saveName, '-depsc', 1, plotpos);

disp('')

end
