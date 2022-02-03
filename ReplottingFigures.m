

figDir = 'Z:\HamedData\CorrelationPaper\Figures\new story\feedback\';

OrigFigName = 'G:\SWR\ZF-71-76_Final\20190920\18-37-00\Plots\DataPlot.fig';
FigName = 'Fig-3-JuvneileRegress';
%FigName = 'Fig1MedianSleepDepthWithErrorBarBasedAge';

openfig(OrigFigName)

 saveName = [figDir FigName];
   
%plotpos = [0 0 15 8]; %Fig 1
 %plotpos = [0 0 8 10]; %Fig 2
 %plotpos = [0 0 40 10]; %Fig 2
 
 
 figure(302)
subplot(4,2,[1 2]); cla
subplot(4,2,[3 4]); cla
subplot(4,2,[5 6]); cla
 
  saveName  = 'C:\Users\Neuropix\Dropbox\Writing\00_Articles\JanieScience\Figs\NewFigs\Fig3\DB_Ratio_seg_99_small3';
 plotpos = [0 0 15 12]; %Fig 2
 print_in_A4(0, saveName, '-djpeg', 0, plotpos);
 print_in_A4(0, saveName, '-depsc', 3, plotpos);