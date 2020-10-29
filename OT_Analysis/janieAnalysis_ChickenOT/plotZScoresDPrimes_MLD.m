function [] = plotZScoresDPrimes_MLD()

d = load('/media/dlc/Data8TB/TUM/OT/OTProject/MLD/MLD_AllData_Janie.mat');
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


%% Zscores for HRTF

zscores= cell2mat(d.D.DATA.ZScore);
xes = ones(1, numel(zscores));

subplot(3, 2, 2)
scatter(xes, zscores, '.', 'jitter','on', 'jitterAmount',0.1);
ylim([-5 11])
xlim([.5 1.5])
hold on
line([.5 1.5], [0,0], 'color', 'k')
line([.5 1.5], [.5,.5], 'color', 'k', 'linestyle', ':')
line([.5 1.5], [-.5,-.5], 'color', 'k', 'linestyle', ':')
set(gca,'xtick',[])
ylabel('Z-Score')

% Dprime

dprimeStim = d.D.DATA.pooled_D_AZ_Stim;

subplot(3, 2, 4)
scatter(xes, dprimeStim, '.', 'jitter','on', 'jitterAmount',0.1);
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
scatter(xes, dprimeSpont, '.', 'jitter','on', 'jitterAmount',0.1);
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
scatter(xes, dprimeStim, '.', 'jitter','on', 'jitterAmount',0.1);
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
scatter(xes, dprimespont, '.', 'jitter','on', 'jitterAmount',0.1);
ylim([-10 5])
xlim([.5 1.5])
hold on
line([.5 1.5], [0,0], 'color', 'k')
line([.5 1.5], [1,1], 'color', 'k', 'linestyle', ':')
line([.5 1.5], [-1,-1], 'color', 'k', 'linestyle', ':')
set(gca,'xtick',[])
ylabel({'D-Prime Elevation' ; '(Top preference)'})
title('Baseline')




saveName = [FigSaveDir 'AuditoryPlots'];

plotpos = [0 0 25 20];
print_in_A4(0, saveName, '-djpeg', 1, plotpos);
disp('')
print_in_A4(0, saveName, '-depsc', 1, plotpos);

disp('')

end