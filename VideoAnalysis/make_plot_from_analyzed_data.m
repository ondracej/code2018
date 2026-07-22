function [] = make_plot_from_analyzed_data()

dataDir  = 'Z:\hameddata2\ChickenData\FromNadia_April2026\Room3Analysis-midday/';
plotPath = 'Z:\hameddata2\ChickenData\FromNadia_April2026\Room3Analysis-midday\AnalysisPlots\';

fileNames = dir(fullfile(dataDir, '*.mat'));
%            fileNames = dir(fullfile(songDataDir, ['*' searchTerm '*']));
            fileNames = {fileNames.name}';
            nFiles = numel(fileNames);
            
            allData = [];
            for j = 1:nFiles
                thisFile = fileNames{j};
                load([dataDir thisFile]);
                
                meanActivity(j) = median(DATA.medianBinVals(1:7));
                sem(j) = std(DATA.medianBinVals(1:7))/sqrt(numel(DATA.medianBinVals(1:7)));
                
                err_neg(j) = meanActivity(j) - sem(j);
                err_pos(j) = meanActivity(j) + sem(j); 
                
                
                
                allData(j,:) = DATA.medianBinVals(1:7);
                alldatasem(j,:) = DATA.sem(1:7);
            end
            
            xes = 1:1:nFiles;

            figure(103); clf;
            bar(xes,meanActivity)
hold on
er = errorbar(xes,meanActivity,sem,sem);
er.Color = [0 0 0];

figName = [plotPath 'medians'];
plotpos = [0 0 15 12];
print_in_A4(0, figName, '-djpeg', 0, plotpos);
print_in_A4(0, figName, '-depsc', 0, plotpos);

%%
allDataT =allData'; 
allDatasemT = alldatasem';
xes = 1:1:7;
figure(103); clf
bar(xes , allData)
er = errorbar(xes,allDataT,allDatasemT,allDatasemT);
er.Color = [0 0 0];

disp('')
end


