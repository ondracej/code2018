

figDir = 'Z:\HamedData\CorrelationPaper\CurrentDraftMarch2022\CurrentFigs\Supp2\';

OrigFigName = 'Z:\HamedData\CorrelationPaper\CurrentDraftMarch2022\CurrentFigs\Supp2\supp Fig. 1 (DOS baed on age).fig';
FigName = 'SuppFig2-Age-jo-2';
%FigName = 'Fig1MedianSleepDepthWithErrorBarBasedAge';

openfig(OrigFigName)

 saveName = [figDir FigName];
   
%plotpos = [0 0 15 8]; %Fig 1
 %plotpos = [0 0 8 10]; %Fig 2
 plotpos = [0 0 40 12]; %Fig 2
 %plotpos = [0 0 20 12]; %Fig 2
 %plotpos = [0 0 15 12]; %Fig 2
 
%  figure(302)
% subplot(4,2,[1 2]); cla
% subplot(4,2,[3 4]); cla
% subplot(4,2,[5 6]); cla
 
  %saveName  = 'Z:\HamedData\CorrelationPaper\CurrentDraftMarch2022\Current Figs\Fig. 1\';
 
 print_in_A4(0, saveName, '-djpeg', 0, plotpos);
 print_in_A4(0, saveName, '-depsc', 3, plotpos);