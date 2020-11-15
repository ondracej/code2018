function [] = plotCCsEnvelopPSTh()


CCDir = '/home/janie/Data/OTProject/MLD/Figs/EnvAnalysis-HRTF/newMLD/CCs/';
saveDir = ['/home/janie/Data/OTProject/MLD/Figs/EnvAnalysis-HRTF/newMLD/CCPlots/'];


trialSeach = ['*.mat*'];

trialNamesStruct = dir(fullfile(CCDir, trialSeach));
nTrials = numel(trialNamesStruct);
for j = 1:nTrials
    trialNames{j} = trialNamesStruct(j).name;
end


for s = 25:nTrials
    
    d = load([CCDir trialNames{s}]);
    
    
    allCorrsL_matrix_r = flipud(d.CCL.allCorrsL_matrix_r);
    %allCorrsL_matrix_p = flipud(d.CCL.allCorrsL_matrix_p);
    
    allCorrsR_matrix_r = flipud(d.CCR.allCorrsR_matrix_r);
    %allCorrsR_matrix_p = flipud(d.CCR.allCorrsR_matrix_p);
    
    CorrDiff = allCorrsR_matrix_r - allCorrsL_matrix_r;
    
    %%
    
    lmax = max(max(allCorrsL_matrix_r));
    lmin = min(min(allCorrsL_matrix_r));
    
    rmax = max(max(allCorrsR_matrix_r));
    rmin = min(min(allCorrsR_matrix_r));
    
    allMax = max([lmax rmax]);
    allmin = min([lmin rmin]);
    
     
    
    figure(121); clf
    
    xticks = [1 9 17 25 33];
    xicklabs = {'-180', '-90', '0', '90', '180'};
    yticks = [1  7 13];
    yicklabs = {'67.5', '0', '-67.5'};
    colormap('parula')
    
    subplot(4, 1, 1)
    imagesc(allCorrsR_matrix_r)
    title(trialNames{s}(1:4))
    set(gca, 'xtick', xticks )
    set(gca, 'xticklabel', xicklabs)
    set(gca, 'ytick', yticks )
    set(gca, 'yticklabel', yicklabs)
    caxis([allmin allMax])
    %colorbar
    
    subplot(4, 1, 2)
    imagesc(allCorrsL_matrix_r)
    set(gca, 'xtick', xticks )
    set(gca, 'xticklabel', xicklabs)
    set(gca, 'ytick', yticks )
    set(gca, 'yticklabel', yicklabs)
    caxis([allmin allMax])
    %colorbar
    
    subplot(4, 1, 3)
    imagesc(CorrDiff)
    set(gca, 'xtick', xticks )
    set(gca, 'xticklabel', xicklabs)
    set(gca, 'ytick', yticks )
    set(gca, 'yticklabel', yicklabs)
    %caxis([allmin allMax])
    %colorbar
    
    azSum = sum(CorrDiff, 1);
    elsum = sum(CorrDiff, 2);
    
    %figure(102);
    subplot(4, 1, 4)
    plot(smooth(azSum), 'k')
    axis tight
    %subplot(2, 1, 2)
    %plot(elsum)
     set(gca, 'xtick', xticks )
    set(gca, 'xticklabel', xicklabs)
    %set(gca, 'ytick', yticks )
    %set(gca, 'yticklabel', yicklabs)
    %%
    saveName = [saveDir trialNames{s}(1:4) '-EnvCC'];
    plotpos = [0 0 12 18];
    
    print_in_A4(0, saveName, '-djpeg', 0, plotpos);
    print_in_A4(0, saveName, '-depsc', 0, plotpos);
    
    
    %%
    
    
    %%
    
    
end


%%
%{
figure(121); clf
subplot(2, 1, 1)
imagesc(test)
colormap('bone')
colorbar
caxis([-.2 .2])

subplot(2, 1, 2)
imagesc(allCorrsR_matrix_r)
colorbar
caxis([-.2 .2])

plot(allCorrsL_matrix_r, 'ko', 'linestyle', 'none')

allAz = [-180 -168.75 -157.5 -146.25 -135 -123.75 -112.5 -101.25 -90 -78.75 -67.5 -56.25 -45 -33.75 -22.5 -11.25 0 11.25 22.5 33.75 45 56.25 67.5 78.75 90 101.25 112.5 123.75 135 146.25 157.5 168.75 180];
allEl = [-67.5 -56.25 -45 -33.75 -22.5 -11.25 0 11.25 22.5 33.75 45 56.25 67.5];

allAz_forTicks = [-180 -157.5 -135 -112.5 -90 -67.5 -45 -22.5 0 22.5 45 67.5 90 112.5 135 157.5 180];

for o = 1:33 % Diff n of azimuths
    
    thisAz = allAz(o);
    
    thisAz_L_r = allCorrsL_matrix_r(:,o);
    thisAz_L_p = allCorrsL_matrix_p(:,o);
    
    sigAZ_L_inds = find(thisAz_L_p < 0.001);
    sigAZ_L = thisAz_L_r(sigAZ_L_inds);
    
    xesL = ones(1, numel(sigAZ_L)) * thisAz;
    
    thisAz_R_r = allCorrsR_matrix_r(:,o);
    thisAz_R_p = allCorrsR_matrix_p(:,o);
    
    sigAZ_R_inds = find(thisAz_R_p < 0.001);
    sigAZ_R = thisAz_R_r(sigAZ_R_inds);
    
    xesR = ones(1, numel(sigAZ_R)) * thisAz;
    
    subplot(6, 2, 9);
    plot(xesL, sigAZ_L, 'k.', 'linestyle', 'none')
    %scatter(xesL, sigAZ_L, 'k.', 'jitter','on', 'jitterAmount', 0.1); %doesnt work
    hold on
    
    subplot(6, 2, 10)
    plot(xesR, sigAZ_R, 'k.', 'linestyle', 'none')
    %scatter(xesR, sigAZ_R, 'k.', 'jitter','on', 'jitterAmount', 0.05);
    hold on
end

subplot(6, 2, 9)
ylim([-.6 .6])
title('Left: Significant correlations across Azimuth')
set(gca, 'xtick', allAz_forTicks)
xlabel('Azimuth')

subplot(6, 2, 10)
ylim([-.6 .6])
title('Right: Significant correlations across Azimuth')
set(gca, 'xtick', allAz_forTicks)
xlabel('Azimuth')



for o = 1:13 % Diff n of azimuths
    
    thisEl = allEl(o);
    
    thisEL_L_r = allCorrsL_matrix_r(o,:);
    thisEl_L_p = allCorrsL_matrix_p(o,:);
    
    sigEl_L_inds = find(thisEl_L_p < 0.001);
    sigEl_L = thisEL_L_r(sigEl_L_inds);
    
    xesL = ones(1, numel(sigEl_L)) * thisEl;
    
    thisEl_R_r = allCorrsR_matrix_r(:,o);
    thisEl_R_p = allCorrsR_matrix_p(:,o);
    
    sigEl_R_inds = find(thisEl_R_p < 0.001);
    sigEl_R = thisEl_R_r(sigEl_R_inds);
    
    xesR = ones(1, numel(sigEl_R)) * thisEl;
    
    subplot(6, 2, 11)
    plot(xesL, sigEl_L, 'k.', 'linestyle', 'none')
    %scatter(xesL, sigEl_L, 'k.', 'jitter','on', 'jitterAmount', 0.05);
    hold on
    
    subplot(6, 2, 12)
    plot(xesR, sigEl_R, 'k.', 'linestyle', 'none')
    %scatter(xesR, sigEl_R, 'k.', 'jitter','on', 'jitterAmount', 0.05);
    hold on
%}
end
