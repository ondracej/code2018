

figDir = 'Z:\HamedData\CorrelationPaper\CurrentDraft\FinalFigs\Fig3\fig\';

OrigFigName = 'Z:\HamedData\CorrelationPaper\CurrentDraft\FinalFigs\Fig3\fig\Fig. 3 Juveniles.fig';
FigName = 'Fig-3Juveniles';
%FigName = 'Fig1MedianSleepDepthWithErrorBarBasedAge';

openfig(OrigFigName)

 saveName = [figDir FigName];
    
plotpos = [0 0 15 8]; %Fig 1
 %plotpos = [0 0 8 10]; %Fig 2
% plotpos = [0 0 25 12]; %Fig 2
 
 print_in_A4(0, saveName, '-djpeg', 0, plotpos);
 print_in_A4(0, saveName, '-depsc', 0, plotpos);