function [] = renameFilesinDir()

% w0027D-f02113--M-dph84


renameVideos = 1;
prependZeros = 0;

dbstop if error

dirToRename = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w027\Data\2021-08-19-First100Songs-Motifs\' ;
renamedDir = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w027\Data\2021-08-19-First100Songs-Motifs\Renamed\' ;

if exist(renamedDir, 'dir') == 0
    mkdir(renamedDir);
end

%%
%searchString = '*.jpg';
%searchString = '*.tiff';
searchString = '*.wav';

fileNames = dir(fullfile(dirToRename, searchString));
nFiles = numel(fileNames);

%% This part will change depending nn the naming conventions
underscore = '_';
period = '.';
dash = '-';


%             if prependZeros == 1
%                 folder = dirToRename;  % e.g
%
for k=1:nFiles
    
    underscoreInds = find(fileNames(k).name == underscore);
    periodInds = find(fileNames(k).name == period);
    
    firstPart = fileNames(k).name(underscoreInds+1:periodInds-1);    
    lastPart = '--M-dph85.wav';
    combinedFilename = [firstPart lastPart];
    
    %firstPart = fileNames(k).name(1:underscoreInds(end));
    %numberStr = fileNames(k).name(underscoreInds(end)+1:periodInds(1)-1);
    %numberStrPrepend =   ['0000' numberStr];
    %extText = fileNames(k).name(periodInds(1):end);
    
    
    
    
    file1=[dirToRename fileNames(k).name];
    file2=[renamedDir combinedFilename];
    
    movefile(file1 ,file2)
    disp([num2str(k) '/' num2str(nFiles)])
    
end

%             end

%% For renaming the files

if renameVideos
    
    preNameTxt = '5Tadpoles20190717_10-54';
    nChars = numel(preNameTxt);
    folder = dirToRename;  % e.g
    for k=1:nFiles
        
        thisFile = fileNames{k};
        newFilename = thisFile;
        newFilename(1) = [];
        newFilename(1:nChars) = preNameTxt;
        file1 = [folder fileNames{k}];
        file2=[folder newFilename];
        
        movefile(file1 ,file2)
        disp([num2str(k) '/' num2str(nFiles)])
    end
end

%             if renameVideos
%
%                 preNameTxt = '5Tadpoles20190717';
%                 folder = dirToRename;  % e.g
%                 for k=1:nFiles
%                     file1=[folder preNameTxt sprintf('%d.AVI.avi', k)];
%
%                     if numel(k) == 1
%                         file2=[renamedDir preNameTxt sprintf('00%d.avi',k)];
%                     elseif numel(k) == 2
%                         file2=[renamedDir preNameTxt sprintf('0%d.avi',k)];
%                     elseif numel(k) == 3
%                         file2=[renamedDir preNameTxt sprintf('%d.avi',k)];
%                     end
%
%                     movefile(file1 ,file2)
%                 end
%
%                 keyboard
%             end
%
% %% Other solutions
%
% if addNumber
%     dot = '.';
%     dash = '_';
%
%     finalStr = []; allNums = [];
%     for j = 1:nFiles
%         str = fileNames{j};
%
%         dots = find(str == dot);
%         dashs = find(str == dash);
%
%         chars = str(dashs(end)+3:dots(1)-1);
%         allNums(j) = str2double(chars);
%         if numel(chars) ==3
%
%         elseif numel(chars) ==4
%
%             chars(1) = [];
%
%         elseif numel(chars) ==5
%             chars(1) = [];
%             chars(1) = [];
%         end
%
%         finalStr{j} = [str(1:dashs(end)) chars '.avi'];
%
%         thisName = finalStr{j};
%
%
%         movefile([dirToRename str] , [renamedDir thisName])
%
%
%     end
%
%     [bla inds] = sort(allNums, 'ascend');
%
%     %% Resort the fileNames
%
%
%
%
%
%     partToReplace = 'DLTdv5_data_20160525001_1_';
%     partToReplaceWith = 'DLTdv5_data_20160525001_1_Pt';
%
%     % Loop through each
%     for id = 1:length(files)
%
%         [~, f, ext] = fileparts(files(id).name);
%
%         searchstr = '_';
%         sep = strfind(f, searchstr);
%
%         fileEnding = f(sep(end)+1:end);
%
%         bla = strfind(f, partToReplace);
%         f(bla:length(partToReplaceWith)+length(fileEnding)) = [partToReplaceWith fileEnding];
%
%         %searchstr = '__';
%         %sep = strfind(f, searchstr);
%         %f(sep) = [];
%
%
%
%
%         movefile([dirToRename files(id).name], [renamedDir f ext]);
%     end
%
% end

end