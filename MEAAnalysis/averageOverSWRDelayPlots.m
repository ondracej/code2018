function [] = averageOverSWRDelayPlots()


delayDetectionsDir = 'Z:\JanieData\JanieSliceSWRDetections\1406\DetectionPlots-New\';

FilesToLoad = [1 4 5 6 8 11 14 15 16 17 19 20 21 22 23 25 27 29 32 33 34 35];


nFiles = numel(FilesToLoad);

for j = 1:nFiles
    
    d =  load([delayDetectionsDir '_DelayMap_'  sprintf('%03d', j) '.mat']);
    
    %allZs{j} = d.Det.zToPlot;
    
    bla(:,j) = horzcat(d.Det.zToPlot(:));
    
end

meansOverSWRs = nanmean(bla, 2);
mediansOverSWRs = nanmedian(bla, 2);

meansOverSWRs_reshape=reshape(meansOverSWRs,8,8);
mediansOverSWRs_reshape=reshape(mediansOverSWRs,8,8);

cmap=flipud(copper);
%cmap=flipud(parula);
colormap(cmap)

clims = [0 .35];

zToPlot = meansOverSWRs_reshape;
zToPlot = mediansOverSWRs_reshape;
[row, col] = find(zToPlot == 0);
%zToPlot = z;
[nr,nc] = size(zToPlot);
pcolor([zToPlot nan(nr,1); nan(1,nc+1)]);
%shading flat;
colorbar
hold on
plot(col+.5, row+.5, 'k*')
caxis(clims);

disp('')
end