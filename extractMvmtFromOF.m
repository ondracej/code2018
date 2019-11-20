

function [] = extractMvmtFromOF()

fileToLoad = '/home/janie/Data/VideosForSilke/OF-FullFile-AC22_02-04-2017__13-50-46__DSs-1__771039-Converted-1-771039.mat';

d = load(fileToLoad);


fv = d.fV1;
fvN = fv./(max(max(fv))); % normalize between 1 and 0
sortedVals = sort(fvN, 'ascend');

percentile4ScaleEstimation = 95; % we choose a threhsold of 95% of the sorted data
scaleEstimator_thresh =sortedVals(round(percentile4ScaleEstimation/100*numel(sortedVals)));

figure; clf
plot(fvN)
hold on
line([0 numel(fvN)], [scaleEstimator_thresh scaleEstimator_thresh], 'color', 'r') 


figure; plot(sortedVals)

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

figure;
imagesc(allThreshCross_cnts)




end