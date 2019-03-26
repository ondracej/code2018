

%% Load the data

%find all the suitable files in a directory using 'dir'
% define a directory where all the files are

dataDir ='';

% Then search the files in that directory for a text string that matches
% your file

textSearch = '';

allDataFiles = dir(fullfile(dataDir,textSearch));

nDataFiles = numel(allDataFiles); % find the number of relevant files
namesDataFiles = cell(1,nDataFiles); % preallocate

% What should we do if there arent any file found??
if isempty(allDataFiles)
    disp('No files found, please choose another directory...');
    return
end

%%
% Now we propagate all the file names of interest
% look up 'for'

for j = 1:nDataFiles
    namesDataFiles{j} = allDataFiles(j).name;
end

%% Now we load the data

concatData = [];

for k = 1:nDataFiles
    
    fileToLoad = [dataDir  namesDataFiles{k}];
    
    d = load(fileToLoad); % What are the parts of the 'd' variable?
    
    %d.fV1;
    %d.im;
    %d.rectim1;
    
    % which is the data that we want to plot?
    
concatData{k} = d.fV1; % why do we have to use a cell here?
end
    
    
    
    
    
    
    
    
    
    



    