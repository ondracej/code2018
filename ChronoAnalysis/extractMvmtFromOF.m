

function [] = extractMvmtFromOF(fileToLoad, figSaveDir)

[pathstr,name,ext] = fileparts(fileToLoad); 

d = load(fileToLoad);


fv = d.fV1;
fvN = fv./(max(max(fv))); % normalize between 1 and 0
sortedVals = sort(fvN, 'ascend');

percentile4ScaleEstimation = 95; % we choose a threhsold of 95% of the sorted data
scaleEstimator_thresh =sortedVals(round(percentile4ScaleEstimation/100*numel(sortedVals)));
threshCrossing = find(sortedVals == scaleEstimator_thresh);

figure(102); clf
subplot (2, 1, 1)
plot(fvN)
hold on
line([0 numel(fvN)], [scaleEstimator_thresh scaleEstimator_thresh], 'color', 'r') 
axis tight
title('Concatenated normalized OF')

subplot (2, 1, 2)
plot(sortedVals)
hold on
line([threshCrossing threshCrossing], [0 1], 'color', 'r') 
axis tight
title('Sorted values with 95 percentile')

     saveName = [figSaveDir name '_Detections_Raw'];
            %plotpos = [0 0 25 12];
            plotpos = [0 0 30 12];
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
            %print_in_A4(0, saveName, '-depsc', 0, plotpos);

fps = 1;

timeWin_min = 6;
timeWin_s  = timeWin_min *60;


%bin all data into 6 min bins

tOn = 1:timeWin_s:numel(fvN);
nBatches = numel(tOn);
for i = 1:nBatches
    
    if i == nBatches
        thisData = fvN(tOn(i):numel(fvN));
    else
        thisData = fvN(tOn(i):tOn(i)+timeWin_s-1);
    end
    
    
    
    threshCrossInds = find(thisData >= scaleEstimator_thresh);
    
    allThreshCross_cnts(i) = numel(threshCrossInds);
    allThreshCross_inds{i} = threshCrossInds;
    totalDataSize(i) = numel(thisData); % this last data entry will be smaller than 6 minutes
end

figure(103); clf
imagesc(allThreshCross_cnts)
xlabel(' 6 min bins')

saveName = [figSaveDir name '_Detections_Imgsc'];
            %plotpos = [0 0 25 12];
            plotpos = [0 0 30 12];
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
     


end