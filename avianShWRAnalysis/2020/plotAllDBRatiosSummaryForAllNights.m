function [] = plotAllDBRatiosSummaryForAllNights()


DirOf_DOS_1 = 'G:\SWR\ZF-71-76_Final\AllDBFiles\';
DirOf_DOS_2 = 'G:\SWR\ZF-o3b7\AllDBFiles\';

dbstop if error

   textSearch = '*Delta*'; % text search for ripple detection file
   DOS_Files_1 = dir(fullfile(DirOf_DOS_1,textSearch));
DOS_Files_2 = dir(fullfile(DirOf_DOS_2,textSearch));

scaleFactor = 0.9956; % = 1792/1800 

nDOSFiles_1 = numel(DOS_Files_1);
ROIS_1 = [1 6842 14089 6932 7694 4980 5898]; 
ROIS_1_scaled = round(ROIS_1*scaleFactor);
Hrsscaled = round(43200*scaleFactor);

AllDB_1 = [];
for j = 1:nDOSFiles_1
  
    dos_1{j} = load([DirOf_DOS_1 DOS_Files_1(j).name]);
    AllDB_1 = dos_1{1,j}.D.allBufferedData;
    
    if ROIS_1_scaled(j)+Hrsscaled > numel(AllDB_1)
        AllDB_ROI_1{j} = AllDB_1(ROIS_1_scaled(j):end);
    else
        AllDB_ROI_1{j} = AllDB_1(ROIS_1_scaled(j):ROIS_1_scaled(j)+Hrsscaled);
    end
    
    AllDB_Mean_1(j) = nanmean(AllDB_ROI_1{j});
    AllDB_Median_1(j) = nanmedian(AllDB_ROI_1{j});
    AllDB_std_1(j) = std(AllDB_ROI_1{j});
    AllDB_sem_1(j) = AllDB_std_1(j)/sqrt(numel(AllDB_ROI_1{j}));
end



xes_1 = [1 2 3 4 5 6 9];

ROIS_2 = [5733 5909 7402 552 1 1 1 7104 1327 4691 12891 1 2478 2942]; 
ROIS_2_scaled = round(ROIS_2*scaleFactor);

nDOSFiles_2 = numel(DOS_Files_2);
for j = 1:nDOSFiles_2
  
    dos_2{j} = load([DirOf_DOS_2 DOS_Files_2(j).name]);
    AllDB_2 = dos_2{1,j}.D.allBufferedData;
    
     if ROIS_2_scaled(j)+Hrsscaled > numel(AllDB_2)
        AllDB_ROI_2{j} = AllDB_2(ROIS_2_scaled(j):end);
    else
        AllDB_ROI_2{j} = AllDB_2(ROIS_2_scaled(j):ROIS_2_scaled(j)+Hrsscaled);
     end
    
    AllDB_Mean_2(j) = nanmean(AllDB_ROI_2{j});
    AllDB_Median_2(j) = nanmedian(AllDB_ROI_2{j});
    AllDB_std_2(j) = std(AllDB_ROI_2{j});
    AllDB_sem_2(j) = AllDB_std_2(j)/sqrt(numel(AllDB_ROI_2{j}));
end
disp('')


xes_2 = [1 2 3 4 5 7 8 11 14 20 23 24 25 26];


figure (104); clf
subplot(3, 3, [9])
hold on
errorbar(xes_1+4, AllDB_Median_1, AllDB_std_1, 'o');
errorbar(xes_2+19, AllDB_Median_2, AllDB_std_2, 'x');
xlim([0 50])

%%

saveName = [DirOf_DOS_1 '_DB_Summary'];
plotpos = [0 0 40 15];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);

end