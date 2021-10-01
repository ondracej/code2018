

figDir = 'Z:\HamedData\CorrelationPaper\Figures\new story\fig format\EpscFiles\';

OrigFigName = 'Z:\HamedData\CorrelationPaper\Figures\new story\fig format\Fig. 1 EEG SWS.fig';
FigName = 'Fig-2SampleLocalSlowWaveColorCodedBrainMap--test';

openfig(OrigFigName)

 saveName = [figDir FigName];
    
 %plotpos = [0 0 15 12]; %Fig 1
 %plotpos = [0 0 8 12]; %Fig 2
 plotpos = [0 0 25 12]; %Fig 2
 
 print_in_A4(0, saveName, '-djpeg', 0, plotpos);
 print_in_A4(0, saveName, '-depsc', 0, plotpos);