

figDir = 'C:\Users\Neuropix\Dropbox\Writing\00_Articles\May312022_SleepCircuits\Figures\';

OrigFigName = 'C:\Users\Neuropix\Dropbox\Writing\00_Articles\May312022_SleepCircuits\Figures\IS_example2.fig';
FigName = 'IS';
%FigName = 'Fig1MedianSleepDepthWithErrorBarBasedAge';

openfig(OrigFigName)

 saveName = [figDir FigName];
   
%plotpos = [0 0 15 8]; %Fig 1
 %plotpos = [0 0 8 10]; %Fig 2
 %plotpos = [0 0 40 12]; %Fig 2
 %plotpos = [0 0 20 12]; %Fig 2
 %plotpos = [0 0 15 12]; %Fig 2
 
%  figure(302)
% subplot(4,2,[1 2]); cla
% subplot(4,2,[3 4]); cla
% subplot(4,2,[5 6]); cla
 
  %saveName  = 'Z:\HamedData\CorrelationPaper\CurrentDraftMarch2022\Current Figs\Fig. 1\';
 
  
  plotpos = [0 0 25 15]; %Fig 2
  
 print_in_A4(0, saveName, '-djpeg', 0, plotpos);
 print_in_A4(0, saveName, '-depsc', 3, plotpos);