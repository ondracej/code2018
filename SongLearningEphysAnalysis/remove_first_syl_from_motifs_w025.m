function [] = remove_first_syl_from_motifs_w025()


inputDir = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w025\Data-IntroNote\';

ouputDir = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w025\Data-REDO\';




d = dir(inputDir);
% remove all files (isdir property is 0)
dfolders = d([d(:).isdir]);

dfolders = dfolders(~ismember({dfolders(:).name},{'.','..'}));
SylInds = [];
for j = 1:numel(dfolders)
    thisName = dfolders(j).name;
    SylInds(j) = sum(strfind(thisName, 'Motifs')); % for motif files
    %SylInds(j) = sum(strfind(thisName, 'Play')); % for playback files
end

dirsToLoad_inds = find(SylInds ~=0);
spec_scale = 0.08;

for k = 1:numel(dirsToLoad_inds)
    
    thisDirInd = dirsToLoad_inds(k);
    thisDirToLoad = [inputDir dfolders(thisDirInd).name '\'];
    
    disp(['Loading files: ' thisDirToLoad])
    
    
    
    fileNames = dir(fullfile(thisDirToLoad, '*.wav'));
    f = filesep;
    [filepath,name,ext] = fileparts(thisDirToLoad);
    
    
    fileNames = {fileNames.name}';
    
    nFiles = numel(fileNames);
    
    
    for o =1:nFiles
        
        file_to_load = [thisDirToLoad fileNames{o}];
        [wav_file,fs ] = audioread(file_to_load); % already filtered
        LCut_samp = round(0.115*fs);
        newWav = wav_file(LCut_samp:numel(wav_file));
        %{
        figure(105); clf
        subplot(2, 1, 1)
        specgram1((wav_file/spec_scale),512,fs,400,360);
        ylim([0 10000])
        xlabel('Time (s)', 'fontsize', 12)
        ylabel('Frequency (Hz)', 'fontsize', 12)
        subplot(2, 1, 2)
        specgram1((newWav/spec_scale),512,fs,400,360);
        ylim([0 10000])
        xlabel('Time (s)', 'fontsize', 12)
        ylabel('Frequency (Hz)', 'fontsize', 12)
        disp('')
        %}
        YY = resample(newWav, 44100, fs);
        
        
        newWavName = fileNames{o};
        
        %wavwrite(YY,44100, [wav_file_dir newWavName])
        
        %% Save filed to M Directory
        
        outputDir = [ouputDir    dfolders(thisDirInd).name '\'];
        if exist(outputDir, 'dir') == 0
            mkdir(outputDir);
            disp(['Created: '  outputDir])
        end
        
        audiowrite([outputDir newWavName], YY,44100)
    end
end
end