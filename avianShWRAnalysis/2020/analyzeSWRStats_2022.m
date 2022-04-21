function [] = analyzeSWRStats_2022()

fileToLoad = 'H:\HamedsData\w042_w044\w044\chronic_2022-01-01_20-26-41\Ephys\Detections\__Final_SWR-Detections.mat';
fileToLoad2 = 'H:\HamedsData\w042_w044\w044\chronic_2022-01-01_20-26-41\Ephys\Detections\__SWR-Detections.mat';

load(fileToLoad);
load(fileToLoad2);

disp('')

allBPsamps = FD.allBP_samps;
nSWs = size(allBPsamps, 1);

rng = 1;
inds = randperm(nSWs);


set = 20;
for j = 1:set
    
    thisSWRInd = inds(j);
    thisSWR = allBPsamps(thisSWRInd,:);
    thisSWHF = FD.allSWHF_samps(thisSWRInd,:);
    timepoints = 1:1:numel(thisSWR);
    timepoints_s = timepoints/FD.Fs_orig;
    timepoints_ms = timepoints_s/1000;
    
    figure(104); clf
    subplot(2, 1, 1)
    plot(timepoints_s,thisSWR);
    xlim([0.3 0.7])
    ylim([-400 300])
    
    subplot(2, 1, 2)
    plot(timepoints_s,thisSWHF);
    xlim([0.3 0.7])
    ylim([-80 80])
   pause 
end
    

end