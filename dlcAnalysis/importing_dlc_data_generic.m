function [] = importing_dlc_data_generic()

filename = 'E:\Frog\Analysis\CubanTF-1-shortFrogMovingDLC_resnet50_TreeFrogOct24shuffle1_320000.csv';
delimiter = ',';
startRow = 2;
endRow = 3;

%% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow-startRow+1, 'Delimiter', delimiter, 'HeaderLines', startRow-1, 'ReturnOnError', false);

nElements = size(dataArray, 2);
allLabels = [];
for j = 1:nElements
allLabels{j} = dataArray{1, j}{1,1};
end

uniqueLabels= unique(allLabels);
nUniqueLabels = numel(uniqueLabels);
uniqueLabels = uniqueLabels(2:nUniqueLabels-1);
nUniqueLabels = numel(uniqueLabels);

clear('dataArray');

delimiter = ',';
startRow = 4;

formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
  fclose(fileID);

frames = dataArray{1,:};
dash = '-';
cnt = 2;
for k = 1:nUniqueLabels
    
    thisLabel = uniqueLabels{k};
    bla = find(thisLabel == dash);
    thisLabel(bla) = '_';
    
    eval(['allCoords.' thisLabel '.y = dataArray{:, cnt}']);
    cnt = cnt+1;
    eval(['allCoords.' thisLabel '.x = dataArray{:,cnt}']);
    cnt = cnt+1;
    eval(['allCoords.' thisLabel '.likelihood = dataArray{:,cnt}']);
    cnt = cnt+1;
    
    varNames{k} = thisLabel;
end
 
 allCoords.nEntries = size(dataArray{1,1},1);
            
            obj.COORDS = allCoords;
            obj.COORDS.varNames = varNames;
            
            disp('Body parts annotated: ')
            celldisp(varNames);
            disp(['n Entries: ' num2str(allCoords.nEntries )]);
            
    

end


