%% Human EEG Analysis scripts

analysisDir = 'C:\Users\Neuropix\Dropbox\AnnalenaData\Data\';

dlc_OBJ = Human_EEG_Analysis_OBJ(analysisDir);

%% 

nDataFiles = numel(dlc_OBJ.ANALYSIS.dataFilenames);


for j = 1:nDataFiles
    filename = dlc_OBJ.ANALYSIS.dataFilenames{j};
    
    dlc_OBJ = loadCSVfile(dlc_OBJ, filename);
    
    visualize = 1;
    dlc_OBJ = findArtifactsPreprocessData(dlc_OBJ,visualize);
    
    %dlc_OBJ = filterAndBinData_PlotMatrix(dlc_OBJ);
    dlc_OBJ = filterAndBinData_PlotMeans(dlc_OBJ);
    
end
