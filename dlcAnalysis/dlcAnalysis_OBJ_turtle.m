classdef dlcAnalysis_OBJ_turtle < handle
    
    
    properties (Access = public)
        
        HOST
        PATH
        DATA
        COORDS
        
        VID
    end
    
    methods
        
        
        function obj = getVideoInfo(obj,analysisDir, filtered )
            
            disp('Getting video info...')
            
            obj.HOST.hostname = gethostname;
            
            if ispc
                dirD = '\';
            else
                dirD = '/';
            end
            
            obj.HOST.dirD = dirD;
            
            %% Find associated files
            
            %[pathstr,name,ext] = fileparts(analysisDir);
            %searchString = ['*' name '*'];
            
            files = dir(fullfile(analysisDir, '*.avi'));
            nFiles = numel(files);
            for j = 1:nFiles
                VideoFileNames{j} = files(j).name;
            end
            
            files = dir(fullfile(analysisDir, '*.csv'));
            nFiles = numel(files);
            for j = 1:nFiles
                CsvFileNames{j} = files(j).name;
            end
            
            searchtext = 'filtered';
            match = strfind(CsvFileNames, searchtext);
            
            if filtered == 1
                bla = find(~cellfun(@isempty,match));   
            else
                bla = find(cellfun(isempty(match)));
            end
            CsvFileNames = CsvFileNames(bla);
             
            
            
%             searchString = ['.csv']; % look for the .csv file
%             
%             matchInds = cellfun(@(x) strfind(x, searchString), fileNames, 'UniformOutput', 0);
%             matchIndsPlace = cell2mat(matchInds);
%             [minVal, minInd] = min(matchIndsPlace);
%             matchInds_nonempty = find(cellfun(@(x) ~isempty(x), matchInds)==1);
%             
%             matchFileName = fileNames{matchInds_nonempty(minInd)};
%             disp(['Analysis file: ' matchFileName])
%             
%             origVideo_path = [analysisDir VidToAnalyze];
%             data_path = [analysisDir matchFileName]; % this assumes we are using the non-filtered data
            
            plotPath = [analysisDir 'Plots' dirD];
            
            %obj.PATH.vidPath = origVideo_path;
            %obj.PATH.dataPath = data_path;
            obj.PATH.analysisDir = analysisDir;
            obj.PATH.plotPath = plotPath;
            
            if exist(obj.PATH.plotPath, 'dir') ==0
                mkdir(obj.PATH.plotPath);
                disp(['Created directory: ' obj.PATH.plotPath])
            end
            
            obj.DATA.CsvFiles = CsvFileNames;
            obj.DATA.VideoFiles = VideoFileNames;
            
        end
        
        function [obj] = loadTrackedData_generic(obj)
            
            dataPath = obj.PATH.analysisDir;
            CsvFileNames = obj.DATA.CsvFiles;
            
            nFilesToLoad = numel(CsvFileNames);
            
            for o = 1:nFilesToLoad
                this_csv_file = [dataPath  CsvFileNames{o}];
                
                
                
                
                %% Initialize variables.
                filename = this_csv_file;
                
                %filename = 'E:\Frog\Analysis\CubanTF-1-shortFrogMovingDLC_resnet50_TreeFrogOct24shuffle1_320000.csv';
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
                uniqueLabels = [];
                cnt =1;
                for j = 1:nElements
                    allLabels{j} = dataArray{1, j}{1,1};
                    
                    b = mod(j, 3);
                    if b ==0
                        uniqueLabels{cnt} =   allLabels{j};
                        cnt = cnt+1;
                    end
                end
                
                   uniqueLabels = unique(uniqueLabels);
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
                for k = 2:nUniqueLabels
                    
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
                
                obj.COORDS{o}.allCoords = allCoords;
                obj.COORDS{o}.varNames = varNames(2:end);
                obj.COORDS{o}.CsvFileName = CsvFileNames{o};
                
                disp('Body parts annotated: ')
                celldisp(varNames);
                disp(['n Entries: ' num2str(allCoords.nEntries )]);
            end
            
            C.allCoords = obj.COORDS{o}.allCoords;
            C.varNames = obj.COORDS{o}.varNames;
            C.CsvFileName = obj.COORDS{o}.CsvFileName;
            C.TurtleName = obj.DATA.TurtleName;
            C.Target = obj.DATA.TargetText;
            
            saveName = [dataPath 'allCoords.mat'];
            save(saveName, 'C', '-v7.3')
            disp('')
        end
        
        function [obj] = loadTrackedData(obj)
            
            disp('Loading tracked data...')
            
            dataPath = obj.PATH.dataPath;
            
            
            %% Initialize variables.
            filename = dataPath;
            delimiter = ',';
            startRow = 4;
            
            %% Read columns of data as strings:
            % For more information, see the TEXTSCAN documentation.
            formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';
            
            %% Open the text file.
            fileID = fopen(filename,'r');
            
            %% Read columns of data according to format string.
            % This call is based on the structure of the file used to generate this
            % code. If an error occurs for a different file, try regenerating the code
            % from the Import Tool.
            dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
            
            
            %% Close the text file.
            fclose(fileID);
            
            %% Convert the contents of columns containing numeric strings to numbers.
            % Replace non-numeric strings with NaN.
            raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
            for col=1:length(dataArray)-1
                raw(1:length(dataArray{col}),col) = dataArray{col};
            end
            numericData = NaN(size(dataArray{1},1),size(dataArray,2));
            
            for col=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]
                % Converts strings in the input cell array to numbers. Replaced non-numeric
                % strings with NaN.
                rawData = dataArray{col};
                for row=1:size(rawData, 1);
                    % Create a regular expression to detect and remove non-numeric prefixes and
                    % suffixes.
                    regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
                    try
                        result = regexp(rawData{row}, regexstr, 'names');
                        numbers = result.numbers;
                        
                        % Detected commas in non-thousand locations.
                        invalidThousandsSeparator = false;
                        if any(numbers==',');
                            thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                            if isempty(regexp(thousandsRegExp, ',', 'once'));
                                numbers = NaN;
                                invalidThousandsSeparator = true;
                            end
                        end
                        % Convert numeric strings to numbers.
                        if ~invalidThousandsSeparator;
                            numbers = textscan(strrep(numbers, ',', ''), '%f');
                            numericData(row, col) = numbers{1};
                            raw{row, col} = numbers{1};
                        end
                    catch me
                    end
                end
            end
            
            
            %% Replace non-numeric cells with NaN
            R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
            raw(R) = {NaN}; % Replace non-numeric cells
            
            %% Allocate imported array to column variable names
            allCoords.bodyparts_scorer = cell2mat(raw(:, 1));
            allCoords.shell1.x = cell2mat(raw(:, 2));
            allCoords.shell1.y = cell2mat(raw(:, 3));
            allCoords.shell1.likelihood = cell2mat(raw(:, 4));
            allCoords.shell2.x = cell2mat(raw(:, 5));
            allCoords.shell2.y = cell2mat(raw(:, 6));
            allCoords.shell2.likelihood = cell2mat(raw(:, 7));
            allCoords.shell3.x = cell2mat(raw(:, 8));
            allCoords.shell3.y = cell2mat(raw(:, 9));
            allCoords.shell3.likelihood = cell2mat(raw(:, 10));
            allCoords.head.x = cell2mat(raw(:, 11));
            allCoords.head.y = cell2mat(raw(:, 12));
            allCoords.head.likelihood = cell2mat(raw(:, 13));
            allCoords.lefthand.x = cell2mat(raw(:, 14));
            allCoords.lefthand.y = cell2mat(raw(:, 15));
            allCoords.lefthand.likelihood = cell2mat(raw(:, 16));
            allCoords.righthand.x = cell2mat(raw(:, 17));
            allCoords.righthand.y = cell2mat(raw(:, 18));
            allCoords.righthand.likelihood = cell2mat(raw(:, 19));
            allCoords.leftfoot.x = cell2mat(raw(:, 20));
            allCoords.leftfoot.y = cell2mat(raw(:, 21));
            allCoords.leftfoot.likelihood = cell2mat(raw(:, 22));
            allCoords.rightfoot.x = cell2mat(raw(:, 23));
            allCoords.rightfoot.y = cell2mat(raw(:, 24));
            allCoords.rightfoot.likelihood = cell2mat(raw(:, 25));
            
            varNames = {'bodyparts_scorer', 'shell1', 'shell2', 'shell3', 'head', 'lefthand', 'righthand', 'leftfoot', 'rightfoot'} ;
            
            allCoords.nEntries = numel(allCoords.rightfoot.y);
            
            obj.COORDS = allCoords;
            obj.COORDS.varNames = varNames;
            
            disp('Body parts annotated: ')
            celldisp(varNames);
            disp(['n Entries: ' num2str(allCoords.nEntries )]);
            
            %% Clear temporary variables
            clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me R;
            
            disp('done...')
        end
        
        function [obj] = loadVideoData(obj)
            
            disp('Loading Video Data...')
            
            vidPath = obj.PATH.vidPath;
            vidObj = VideoReader(vidPath);
            
            V.vidName = vidObj.Name;
            V.vidHeight = vidObj.Height;
            V.vidWidth = vidObj.Width;
            V.nFrames = vidObj.NumberOfFrames;
            V.VidFrameRate = vidObj.FrameRate;
            
            
            obj.VID = V;
            obj.VID.vidObj = vidObj;
            
            disp('done...')
            
        end
        
        %% Analysis
        
        function [obj] = plotTrajectories(obj)
            dbstop if error
            nFiles = numel(obj.COORDS);
            
            for o = 1:nFiles
                
                vidPath = [ obj.PATH.analysisDir  obj.DATA.VideoFiles{o}];
                  vidObj = VideoReader(vidPath);
                
            
            frameToPlot = 10;
            vidFrame = read(vidObj, frameToPlot );
            
            vidHeight = vidObj.Height;
            vidWidth = vidObj.Width;
            
            varNames = obj.COORDS{o}.varNames;
            
            list = {varNames{1:end}};
            [indx,tf] = listdlg('PromptString','Choose tracked objects:', 'ListString',list);
            
            nChoices = numel(indx);
            for j = 1:nChoices
                allChoices{j} = list{indx(j)};
            end
            
            cols = {'r', 'c', 'g', 'b', 'y', 'm',  'w', 'k'};
            
            %% Iterate over Choices
            figH = figure(100);clf
            image(vidFrame)
            
            trackedText = [];
            for j = 1:nChoices
                
                thisTrackedObject = allChoices{j};
                fieldMatch = isfield(obj.COORDS{o}.allCoords , thisTrackedObject);
                
                if fieldMatch
                    eval(['coords_X = obj.COORDS{o}.allCoords.' thisTrackedObject '.x;']);
                    eval(['coords_Y = obj.COORDS{o}.allCoords.' thisTrackedObject '.y;']);
                    eval(['likelihood = obj.COORDS{o}.allCoords.' thisTrackedObject '.likelihood;']);
                    
                end
                
                hold on
               %  plot(coords_X, coords_Y, 'color', cols{j}, 'marker', '.', 'markersize', 10, 'linestyle', 'none')
                plot(coords_Y, coords_X, 'color', cols{j}, 'marker', '.', 'markersize', 10, 'linestyle', '-')
                trackedText = [trackedText '-' thisTrackedObject];
            end
            
            figure(figH)
            axis off
            annotation(figH,'textbox',[0.1 0.96 0.46 0.028],'String',[ obj.DATA.VideoFiles{o} '-' trackedText],'LineStyle','none','FitBoxToText','off', 'fontsize', 12);
            disp('Printing Plot')
            %set(0, 'CurrentFigure', figH)
            
            plotPath = obj.PATH.plotPath;
            saveName = [plotPath  obj.DATA.VideoFiles{o}(1:end-4) trackedText '_tracked'];
            plotpos = [0 0 70 40]; % keep this so arena dims look ok
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
            end
            
        end
        
        function [obj] = plotTrajectories_with_likelihood(obj, likelihood_cutoff)
            
            dbstop if error
            nFiles = numel(obj.COORDS);
            
            varNames = obj.COORDS{1}.varNames;
            
            list = {varNames{1:end}};
            [indx,tf] = listdlg('PromptString','Choose tracked objects:', 'ListString',list);
            
            nChoices = numel(indx);
            
            trackedText_save = [];
            for j = 1:nChoices
                allChoices{j} = list{indx(j)};
                trackedText_save = [trackedText_save '-' list{indx(j)}];
            end
            
            
            for o = 1:nFiles
                
                vidPath = [ obj.PATH.analysisDir  obj.DATA.VideoFiles{o}];
                vidObj = VideoReader(vidPath);
                frameToPlot = 20;
                vidFrame = read(vidObj, frameToPlot );
                
                
                
                cols = {'r', 'c', 'g', 'b', 'y', 'm',  'w', 'k'};
                
                %% Iterate over Choices
                figH = figure(100);clf
                image(vidFrame)
                
                trackedText = [];
                for j = 1:nChoices
                    
                    thisTrackedObject = allChoices{j};
                    fieldMatch = isfield(obj.COORDS{o}.allCoords , thisTrackedObject);
               
                    if fieldMatch
                        eval(['coords_X = obj.COORDS{o}.allCoords.' thisTrackedObject '.x;']);
                        eval(['coords_Y = obj.COORDS{o}.allCoords.' thisTrackedObject '.y;']);
                        eval(['likelihood = obj.COORDS{o}.allCoords.' thisTrackedObject '.likelihood;']);
                        
                    end
                    
                    HL_inds = find(likelihood >= likelihood_cutoff);
                    n_inds = numel(HL_inds);
                    
                    
                    hold on
                    % plot(coords_X, coords_Y, 'color', cols{j}, 'marker', '.', 'markersize', 10, 'linestyle', 'none')
                    plot(coords_Y(HL_inds), coords_X(HL_inds), 'color', cols{j}, 'marker', '.', 'markersize', 20, 'linestyle', '-')
                    trackedText = [trackedText ' | ' thisTrackedObject ' : n=' num2str(n_inds) '/' num2str(numel(likelihood))];
                end
                
                figure(figH)
                axis off
                annotation(figH,'textbox',[0.1 0.96 0.7 0.028],'String',[ obj.DATA.VideoFiles{o} ', LH = ' num2str(likelihood_cutoff) trackedText],'LineStyle','none','FitBoxToText','off', 'fontsize', 12);
                disp('Printing Plot')
                %set(0, 'CurrentFigure', figH)
                
                plotPath = obj.PATH.plotPath;
                saveName = [plotPath  obj.DATA.VideoFiles{o}(1:end-4) trackedText_save '_tracked-LH'];
                %plotpos = [0 0 70 40]; % keep this so arena dims look ok
                plotpos = [0 0 25 20]; % keep this so arena dims look ok
                print_in_A4(0, saveName, '-djpeg', 0, plotpos);
               % print_in_A4(0, saveName, '-depsc', 0, plotpos);
                
            end
        end
        
        function [] = plotTrajectoriesMakeVideo(obj)
            
            
            vidObj = obj.VID.vidObj;
            
            vidWidth = obj.VID.vidWidth;
            vidHeight = obj.VID.vidHeight;
            nFrames= obj.VID.nFrames;
            F(1:nFrames-1) = struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),'colormap', []);
            
            
            varNames = obj.COORDS.varNames;
            list = {varNames{2:end}};
            [indx,tf] = listdlg('PromptString','Choose tracked objects:', 'ListString',list);
            
            nEntries = obj.COORDS.nEntries;
            
            nChoices = numel(indx);
            trackedText = [];
            for j = 1:nChoices
                allChoices{j} = list{indx(j)};
                trackedText = [trackedText '-' list{indx(j)}];
            end
            
            
            cols = {'r', 'c', 'g', 'b', 'y', 'm', 'w', 'k'};
            
            %% Iterate over nEntries
            
            for k = 1: nEntries-1
                figH = figure(100);clf
                frameToPlot = k;
                vidFrame = read(vidObj, frameToPlot );
                image(vidFrame)
                
                for j = 1:nChoices
                    
                    thisTrackedObject = allChoices{j};
                    fieldMatch = isfield(obj.COORDS, thisTrackedObject);
                    
                    if fieldMatch
                        eval(['coords_X = obj.COORDS.' thisTrackedObject '.x;']);
                        eval(['coords_Y = obj.COORDS.' thisTrackedObject '.y;']);
                        eval(['likelihood = obj.COORDS.' thisTrackedObject '.likelihood;']);
                        
                    end
                    
                    hold on
                    plot(coords_X(k:k+1), coords_Y(k:k+1), 'color', cols{j}, 'marker', '.', 'markersize', 20, 'linestyle', '-')
                end
                
                annotation(figH,'textbox',[0.1 0.96 0.46 0.028],'String',[obj.VID.vidName '-Frame:' num2str(k)],'LineStyle','none','FitBoxToText','off', 'fontsize', 12);
                annotation(figH,'textbox',[0.7 0.96 0.46 0.028],'String',trackedText,'LineStyle','none','FitBoxToText','off', 'fontsize', 12);
                
                F(k) = getframe(figH);
            end
            
            plotPath = obj.PATH.plotPath;
            saveName = [plotPath obj.VID.vidName(1:end-4) trackedText '_tracked'];
            
            DS_vidObj = VideoWriter(saveName, 'Motion JPEG AVI');
            DS_vidObj.FrameRate = 1;
            DS_vidObj.Quality=  100;
            
            tic
            disp('Saving movie...');
            open(DS_vidObj)
            writeVideo(DS_vidObj, F);
            close(DS_vidObj)
            disp(['Saved file: ' saveName]);
            toc
            
            clear('F');
            
        end
        
        
        
        function [] = plotTrajectoriesMakeVideo_LH_And_Frame(obj, likelihood_cutoff, frame_cutoff)
            
            
            vidObj = obj.VID.vidObj;
            
            vidWidth = obj.VID.vidWidth;
            vidHeight = obj.VID.vidHeight;
            nFrames= obj.VID.nFrames;
            
            
            varNames = obj.COORDS.varNames;
            list = {varNames{2:end}};
            [indx,tf] = listdlg('PromptString','Choose tracked objects:', 'ListString',list);
            
            %nEntries = obj.COORDS.nEntries;
            nEntries  = frame_cutoff;
            F(1:frame_cutoff) = struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),'colormap', []);
            
            
            nChoices = numel(indx);
            trackedText = [];
            for j = 1:nChoices
                allChoices{j} = list{indx(j)};
                trackedText = [trackedText '-' list{indx(j)}];
            end
            
            
            cols = {'r', 'c', 'g', 'b', 'y', 'm', 'w', 'k'};
            
            %% Iterate over nEntries
            
            for k = 1: nEntries
                figH = figure(100);clf
                frameToPlot = k;
                vidFrame = read(vidObj, frameToPlot );
                image(vidFrame)
                
                for j = 1:nChoices
                    
                    thisTrackedObject = allChoices{j};
                    fieldMatch = isfield(obj.COORDS, thisTrackedObject);
                    
                    if fieldMatch
                        eval(['coords_X = obj.COORDS.' thisTrackedObject '.x;']);
                        eval(['coords_Y = obj.COORDS.' thisTrackedObject '.y;']);
                        eval(['likelihood = obj.COORDS.' thisTrackedObject '.likelihood;']);
                        
                    end
                    
                    
                    hold on
                    CX = coords_X(k);
                    CY = coords_Y(k);
                    
                    test = likelihood(k);
                    testInds = find(test <=  likelihood_cutoff);
                    if ~isempty(testInds)
                        CX(testInds) = nan;
                        CY(testInds) = nan;
                    end
                    
                    %plot(coords_X(k:k+1), coords_Y(k:k+1), 'color', cols{j}, 'marker', '.', 'markersize', 10, 'linestyle', '-')
                    plot(CX, CY, 'color', cols{j}, 'marker', '.', 'markersize', 20, 'linestyle', '-')
                    %  disp('')
                end
                
                annotation(figH,'textbox',[0.1 0.96 0.46 0.028],'String',[obj.VID.vidName '-Frame:' num2str(k)],'LineStyle','none','FitBoxToText','off', 'fontsize', 12);
                annotation(figH,'textbox',[0.7 0.96 0.46 0.028],'String',trackedText,'LineStyle','none','FitBoxToText','off', 'fontsize', 12);
                
                F(k) = getframe(figH);
            end
            
            plotPath = obj.PATH.plotPath;
            saveName = [plotPath obj.VID.vidName(1:end-4) trackedText '_tracked'];
            
            DS_vidObj = VideoWriter(saveName, 'Motion JPEG AVI');
            DS_vidObj.FrameRate = 1;
            DS_vidObj.Quality=  100;
            
            tic
            disp('Saving movie...');
            open(DS_vidObj)
            writeVideo(DS_vidObj, F);
            close(DS_vidObj)
            disp(['Saved file: ' saveName]);
            toc
            
            clear('F');
            
        end
        
        
        
        function [obj] = plotVelocity(obj, likelihood_cutoff)
            
            if nargin <2
                likelihood_cutoff = 0;
                text_save = ['-full'];
            else
                text_save = ['-LH'];
            end
            
            text_supp = ['LH = ' num2str(likelihood_cutoff)];
            
            VidFrameRate = obj.VID.VidFrameRate;
            nEntries = obj.COORDS.nEntries;
            
            varNames = obj.COORDS.varNames;
            
            list = {varNames{2:end}};
            [indx,tf] = listdlg('PromptString','Choose tracked objects:', 'ListString',list);
            
            nChoices = numel(indx);
            trackedText = [];
            for j = 1:nChoices
                allChoices{j} = list{indx(j)};
                trackedText{j} = list{indx(j)};
            end
            
            cols = {'r', 'c','g', 'b', 'y', 'm', 'w', 'k'};
            
            %% Iterate over Choices
            
            timeRes_s = 1/VidFrameRate;
            
            figH = figure(100);clf
            for j = 1:nChoices
                
                
                thisTrackedObject = allChoices{j};
                fieldMatch = isfield(obj.COORDS, thisTrackedObject);
                
                if fieldMatch
                    eval(['coords_X = obj.COORDS.' thisTrackedObject '.x;']);
                    eval(['coords_Y = obj.COORDS.' thisTrackedObject '.y;']);
                    eval(['likelihood = obj.COORDS.' thisTrackedObject '.likelihood;']);
                    
                    HL_inds = find(likelihood >= likelihood_cutoff);
                    n_inds = numel(HL_inds);
                    
                    c_X = coords_X(HL_inds);
                    c_Y = coords_Y(HL_inds);
                    
                    % Determine Euclidian distance for velocity calc
                    euclidianDistance = [];
                    for k = 1:numel(c_X)-1
                        point_xy_t0 = [c_X(k), c_Y(k)];
                        point_xy_t1 = [c_X(k+1), c_Y(k+1)];
                        distance = [point_xy_t0; point_xy_t1];
                        euclidianDistance(k) = pdist(distance,'euclidean');
                        
                    end
                    
                    velocity_px_per_s = euclidianDistance/timeRes_s;
                    hold on
                    
                    
                    %subplot(nChoices, 1, j)
                    hold on
                    plot(euclidianDistance, 'color', cols{j}, 'marker', '.', 'markersize', 20, 'linestyle', '-')
                    clear('coords_X', 'coords_Y');
                    
                end
            end
            
            % Label figure
            legend(trackedText)
            axis tight
            ylim([0 100])
            xlabel('Frames')
            ylabel('Distance (px)')
            
            figure(figH)
            annotation(figH,'textbox',[0.1 0.96 0.46 0.028],'String',[obj.VID.vidName '-' text_supp],'LineStyle','none','FitBoxToText','off', 'fontsize', 12);
            disp('Printing Plot')
            
            % Print figure
            plotPath = obj.PATH.plotPath;
            saveName = [plotPath obj.VID.vidName(1:end-4) '_Distance' text_save];
            plotpos = [0 0 25 15];
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
        end
        
        function [obj] = plotTimeSpentInQuadrants(obj, likelihood_cutoff)
            
            if nargin <2
                likelihood_cutoff = 0;
                text_save = ['-full'];
            else
                text_save = ['-LH'];
            end
            
            text_supp = ['LH = ' num2str(likelihood_cutoff)];
            
            vidObj = obj.VID.vidObj;
            frameToPlot = 100;
            vidFrame = read(vidObj, frameToPlot );
            
            vidHeight = vidObj.Height;
            vidWidth = vidObj.Width;
            
            varNames = obj.COORDS.varNames;
            
            list = {varNames{1:end}};
            [indx,tf] = listdlg('PromptString','Choose tracked objects:', 'ListString',list, 'SelectionMode', 'single');
            
            nChoices = numel(indx);
            for j = 1:nChoices
                allChoices{j} = list{indx(j)};
            end
            
            cols = {'r', 'c', 'g', 'b', 'y', 'm',  'w', 'k'};
            
            %% Iterate over Choices
            figH = figure(100);clf
            image(vidFrame)
            
            topWall_LCorner = [100 200];
            %topWall_LCorner = [100 75];
            topWall_RCorner = [1200 200];
            %bottomWall_LCorner = [100 600];
            bottomWall_LCorner = [100 950];
            %bottomWall_RCorner = [1165 600];
            bottomWall_RCorner = [1200 950];
            
            %topWall_LCorner = [100 130];
            %topWall_RCorner = [1200 100];
            %bottomWall_LCorner = [100 630];
            %bottomWall_RCorner = [1200 600];
            
            
            %%
            
            
            topWall_line = [topWall_LCorner topWall_RCorner];
            topWall_line = [bottomWall_LCorner bottomWall_RCorner];
            
            Xline_Length = topWall_RCorner(1) - topWall_LCorner(1);
            Yline_Length = bottomWall_LCorner(2) - topWall_LCorner(2);
            
            y_quadrants = round(Yline_Length/3);
            x_quadrants = round(Xline_Length/3);
            
            %% Quadrant defs from top left to bottom right
            
            q1_x = [topWall_LCorner(1) topWall_LCorner(1)+x_quadrants];
            q1_y = [topWall_LCorner(2) topWall_LCorner(2)+y_quadrants];
            
            q2_x = [q1_x(2) q1_x(2)+x_quadrants];
            q2_y = q1_y;
            
            q3_x = [q2_x(2) q2_x(2)+x_quadrants];
            q3_y = q1_y;
            
            q4_x = [topWall_LCorner(1) topWall_LCorner(1)+x_quadrants];
            q4_y = [q1_y(2) q1_y(2)+y_quadrants];
            
            q5_x = q2_x;
            q5_y = q4_y;
            
            q6_x = q3_x;
            q6_y = q4_y;
            
            q7_x = q4_x;
            q7_y = [q4_y(2) q4_y(2)+y_quadrants];
            
            q8_x = q2_x;
            q8_y = q7_y;
            
            q9_x = q3_x;
            q9_y = q7_y;
            
            
            %% Draw coordinates on figure
            
            
            for j = 1:9
                
                thisq = ['q' num2str(j)];
                
                eval(['lineq1 = line(' thisq '_x, [' thisq '_y(1) ' thisq '_y(1)]);'])
                %lineq1 = line(q1_x, [q1_y(1) q1_y(1)]);
                lineq1.Color = 'r';
                lineq1.LineWidth = 2;
                
                eval(['lineq1 = line(' thisq '_x, [' thisq '_y(2) ' thisq '_y(2)]);'])
                %lineq1 = line(q1_x, [q1_y(2) q1_y(2)]);
                lineq1.Color = 'r';
                lineq1.LineWidth = 2;
                
                eval(['lineq1 = line([' thisq '_x(1) ' thisq '_x(1)],' thisq '_y);'])
                %lineq1 = line([q1_x(1) q1_x(1)], q1_y);
                lineq1.Color = 'r';
                lineq1.LineWidth = 2;
                
                eval(['lineq1 = line([' thisq '_x(2) ' thisq '_x(2)],' thisq '_y);'])
                %lineq1 = line([q1_x(2) q1_x(2)], q1_y);
                lineq1.Color = 'r';
                lineq1.LineWidth = 2;
                
            end
            
            
            
            %% Quantify n points in each quadrant
            
            
            
            for j = 1:nChoices
                
                thisTrackedObject = allChoices{j};
                fieldMatch = isfield(obj.COORDS, thisTrackedObject);
                
                if fieldMatch
                    eval(['coords_X = obj.COORDS.' thisTrackedObject '.x;']);
                    eval(['coords_Y = obj.COORDS.' thisTrackedObject '.y;']);
                    eval(['likelihood = obj.COORDS.' thisTrackedObject '.likelihood;']);
                    
                end
                
            end
            
            HL_inds = find(likelihood >= likelihood_cutoff);
            n_inds = numel(HL_inds);
            
            c_X = coords_X(HL_inds);
            c_Y = coords_Y(HL_inds);
            
            figure(figH)
            hold on
            
            plot(c_Y, c_X, 'color', 'k', 'marker', '.', 'markersize', 20, 'linestyle', 'none')
            
            axis off
            annotation(figH,'textbox',[0.1 0.96 0.46 0.028],'String',[obj.VID.vidName '-' cell2mat(allChoices) '-' text_supp],'LineStyle','none','FitBoxToText','off', 'fontsize', 12);
            disp('Printing Plot')
            %set(0, 'CurrentFigure', figH)
            
            plotPath = obj.PATH.plotPath;
            saveName = [plotPath obj.VID.vidName(1:end-4) '-' cell2mat(allChoices) '_quadrants-' text_save];
            %plotpos = [0 0 70 40]; % keep this so arena dims look ok
            plotpos = [0 0 25 20]; % keep this so arena dims look ok
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
            print_in_A4(0, saveName, '-depsc', 0, plotpos);
            
            %% Find the n points in each coordinate
            
            npoints = numel(c_X);
            %allPoints = [c_X c_Y];
            allPoints = [c_Y c_X];
            
            q1_cnt = 1; q2_cnt = 1; q3_cnt = 1;q4_cnt = 1;q5_cnt = 1;q6_cnt = 1;q7_cnt = 1;q8_cnt = 1;q9_cnt = 1;
            q1_points = []; q2_points = []; q3_points = []; q4_points = []; q5_points = []; q6_points = []; q7_points = []; q8_points = []; q9_points = [];
            
            for k = 1:npoints
                
                thisPoint = allPoints(k,:);
                
                if thisPoint(1)>= q1_x(1) && thisPoint(1) <= q1_x(2) && thisPoint(2) >= q1_y(1) && thisPoint(2) <= q1_y(2)
                    
                    q1_points(q1_cnt,:) = thisPoint;
                    q1_cnt = q1_cnt+1;
                    
                elseif thisPoint(1)>= q2_x(1) && thisPoint(1) <= q2_x(2) && thisPoint(2) >= q2_y(1) && thisPoint(2) <= q2_y(2)
                    
                    q2_points(q2_cnt,:) = thisPoint;
                    q2_cnt = q2_cnt+1;
                    
                elseif thisPoint(1)>= q3_x(1) && thisPoint(1) <= q3_x(2) && thisPoint(2) >= q3_y(1) && thisPoint(2) <= q3_y(2)
                    
                    q3_points(q3_cnt,:) = thisPoint;
                    q3_cnt = q3_cnt+1;
                    
                elseif thisPoint(1)>= q4_x(1) && thisPoint(1) <= q4_x(2) && thisPoint(2) >= q4_y(1) && thisPoint(2) <= q4_y(2)
                    
                    q4_points(q4_cnt,:) = thisPoint;
                    q4_cnt = q4_cnt+1;
                    
                elseif thisPoint(1)>= q5_x(1) && thisPoint(1) <= q5_x(2) && thisPoint(2) >= q5_y(1) && thisPoint(2) <= q5_y(2)
                    
                    q5_points(q5_cnt,:) = thisPoint;
                    q5_cnt = q5_cnt+1;
                    
                    
                elseif thisPoint(1)>= q6_x(1) && thisPoint(1) <= q6_x(2) && thisPoint(2) >= q6_y(1) && thisPoint(2) <= q6_y(2)
                    
                    q6_points(q6_cnt,:) = thisPoint;
                    q6_cnt = q6_cnt+1;
                    
                    
                elseif thisPoint(1)>= q7_x(1) && thisPoint(1) <= q7_x(2) && thisPoint(2) >= q7_y(1) && thisPoint(2) <= q7_y(2)
                    
                    q7_points(q7_cnt,:) = thisPoint;
                    q7_cnt = q7_cnt+1;
                    
                elseif thisPoint(1)>= q8_x(1) && thisPoint(1) <= q8_x(2) && thisPoint(2) >= q8_y(1) && thisPoint(2) <= q8_y(2)
                    
                    q8_points(q8_cnt,:) = thisPoint;
                    q8_cnt = q8_cnt+1;
                    
                elseif thisPoint(1)>= q9_x(1) && thisPoint(1) <= q9_x(2) && thisPoint(2) >= q9_y(1) && thisPoint(2) <= q9_y(2)
                    
                    q9_points(q9_cnt,:) = thisPoint;
                    q9_cnt = q9_cnt+1;
                end
            end
            
            %%
            
            n_q1_ppoints = size(q1_points, 1);
            n_q2_ppoints = size(q2_points, 1);
            n_q3_ppoints = size(q3_points, 1);
            n_q4_ppoints = size(q4_points, 1);
            n_q5_ppoints = size(q5_points, 1);
            n_q6_ppoints = size(q6_points, 1);
            n_q7_ppoints = size(q7_points, 1);
            n_q8_ppoints = size(q8_points, 1);
            n_q9_ppoints = size(q9_points, 1);
            
            n_points_all = [n_q1_ppoints n_q2_ppoints n_q3_ppoints ; n_q4_ppoints n_q5_ppoints n_q6_ppoints ;n_q7_ppoints n_q8_ppoints n_q9_ppoints];
            n_points_all_reshape = reshape(n_points_all, 1, numel(n_points_all));
            n_allPoints = sum(sum(n_points_all));
            
            nMissingPoints = npoints - n_allPoints;
            
            percentagePoints_per_quadrant = n_points_all./n_allPoints*100;
            
            %%
            fig103 = figure(103); clf
            imagesc(n_points_all, [0 1200])
            
            text(1, 1, num2str(roundn( percentagePoints_per_quadrant(1, 1), -1)), 'Fontsize', 14);
            text(1, 2, num2str(roundn( percentagePoints_per_quadrant(2, 1), -1)), 'Fontsize', 14);
            text(1, 3, num2str(roundn( percentagePoints_per_quadrant(3, 1), -1)), 'Fontsize', 14);
            
            text(2, 1, num2str(roundn( percentagePoints_per_quadrant(1, 2), -1)), 'Fontsize', 14);
            text(2, 2, num2str(roundn( percentagePoints_per_quadrant(2, 2), -1)), 'Fontsize', 14);
            text(2, 3, num2str(roundn( percentagePoints_per_quadrant(3, 2), -1)), 'Fontsize', 14);
            
            text(3, 1, num2str(roundn( percentagePoints_per_quadrant(1, 3), -1)), 'Fontsize', 14);
            text(3, 2, num2str(roundn( percentagePoints_per_quadrant(2, 3), -1)), 'Fontsize', 14);
            text(3, 3, num2str(roundn( percentagePoints_per_quadrant(3, 3), -1)), 'Fontsize', 14);
            
            annotation(fig103,'textbox',[0.1 0.96 0.8 0.028],'String',[obj.VID.vidName '-' text_supp '-' cell2mat(allChoices) ' | Percentage of points detected' ],'LineStyle','none','FitBoxToText','off', 'fontsize', 12);
            
            %title([obj.VID.vidName '-' cell2mat(allChoices)])
            %xlabel('Percentage of points detected')
            set(gca, 'Fontsize', 14)
            axis off
            
            figure(fig103)
            axis off
            disp('Printing Plot')
            %set(0, 'CurrentFigure', figH)
            
            plotPath = obj.PATH.plotPath;
            saveName = [plotPath obj.VID.vidName(1:end-4) '-' cell2mat(allChoices) '_quadrantsPercents'];
            %plotpos = [0 0 70 40]; % keep this so arena dims look ok
            plotpos = [0 0 25 20]; % keep this so arena dims look ok
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
            print_in_A4(0, saveName, '-depsc', 0, plotpos);
            
        end
        
    end
    
    %%
    
    methods (Hidden)
        %class constructor
        function obj = dlcAnalysis_OBJ_turtle(analysisDir, filtered )
            
            addpath(genpath(analysisDir))
            
            obj = getVideoInfo(obj, analysisDir, filtered );
            
            
        end
    end
    
end


