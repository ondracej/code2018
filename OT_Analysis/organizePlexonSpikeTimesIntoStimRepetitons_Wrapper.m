function [] = organizePlexonSpikeTimesIntoStimRepetitons_Wrapper()

SortedSpikeFile_Dir = 'X:\Janie-OT-MLD\PlexonData-HRTF_2025\';
%SortedSpikeFile_Dir = 'X:\Janie-OT-MLD\PlexonData-WN_2025\';
StimType = 1; %HRTF 3 (IID), 4 (ITD), 5 (WN)

sortedFile_txt = '*__Sorted.mat';
sortedFiles = dir(fullfile(SortedSpikeFile_Dir, sortedFile_txt));
sortedFiles = {sortedFiles .name}';
nSortedFiles = numel(sortedFiles);

for q = 1:nSortedFiles
    % Load sorted data
    load([SortedSpikeFile_Dir sortedFiles{q}])
    % Load accompanying INFO
    InfoFile = [sortedFiles{q}(1:end-16) 'INFO.mat'];
    load([SortedSpikeFile_Dir InfoFile])
    
    fileNameBase = sortedFiles{q}(1:end-16);
    
    organizePlexonSpikeTimesIntoStimRepetitions(INFO, Channel01, fileNameBase, StimType)
end








end