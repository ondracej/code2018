function [] = resampleWavFilesForLisa()

DataDir = '/home/janie/Data/Songs/Finished/w014/Data/';

textSearch = ['*2021*'];

allDirs=dir(fullfile(DataDir,textSearch));

nDirs = numel(allDirs);

for j =1:nDirs
    
    thisDir = [DataDir allDirs(j).name '/'];
    
    wavSearch = ['*.wav*'];
    
    allWavs=dir(fullfile(thisDir,wavSearch));
    
    nWavs = numel(allWavs);
    
    for k = 1:nWavs
        
        wavToload = [thisDir allWavs(k).name];
        
        newWavName = [allWavs(k).name(1:end-4) '_Fs-44100.wav'];
        
        [y, Fs ]= wavread(wavToload);
        
        YY = resample(y, 44100, Fs);
        
        wavwrite(YY,44100, [thisDir newWavName])
        
    end
end

end
