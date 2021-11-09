

figDir = 'Z:\HamedData\CorrelationPaper\CurrentDraft\FinalFigs\Fig2\Epsc\';

OrigFigName = 'Z:\HamedData\CorrelationPaper\CurrentDraft\FinalFigs\Fig2\figs\Fig. 2 movement - sleep depth - local wave -JUVENILE.fig';
FigName = 'Fig-2WholeNightSleepDepthLocal-waveIncidence-Juvenile';
%FigName = 'Fig1MedianSleepDepthWithErrorBarBasedAge';

openfig(OrigFigName)

 saveName = [figDir FigName];
    
plotpos = [0 0 15 12]; %Fig 1
 %plotpos = [0 0 8 12]; %Fig 2
% plotpos = [0 0 25 12]; %Fig 2
 
 print_in_A4(0, saveName, '-djpeg', 0, plotpos);
 print_in_A4(0, saveName, '-depsc', 0, plotpos);