function [] = renameFiles()


dirToRename = 'D:\Artemis\Songs\w027_Analysis\Data\2021-08-18-LastDay_Last100Songs-Motifs\';

tagForFiles = '-dph84';

wav_file_list = dir(fullfile(dirToRename, '*.wav'));
nFiles = numel(wav_file_list);

for j = 1 : nFiles
    thisName = wav_file_list(j, :).name;
    
    newName = [thisName(1:end-4) tagForFiles '.wav'];
    
    movefile( fullfile(dirToRename, thisName), fullfile(dirToRename, newName))
    
end

end

