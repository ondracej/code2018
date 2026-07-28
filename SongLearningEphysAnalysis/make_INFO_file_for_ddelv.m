function [] =  make_INFO_file_for_ddelv()

wavDir = ['X:\ForSepp\2021-08-30\'];


fileNames = dir(fullfile(wavDir, '*.wav'));

nFiles = numel(fileNames);

times = [];
for j = 1:nFiles
    
    times{j} = fileNames(j).date;
    
end

INFO.times = times;
INFO.fileNames = fileNames;

save([wavDir 'INFO.mat'], 'INFO')

end