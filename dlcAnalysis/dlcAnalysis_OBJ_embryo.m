classdef dlcAnalysis_OBJ_embryo < handle
    
    
    properties (Access = public)
        
        PATH
        COORDS
        VID
    end
    
    methods
        
        
        function obj = definePaths(obj,analysisDir, ExperimentName)
            
            if ispc
                dirD = '\';
            else
                dirD = '/';
            end
            
            fps = 50;
            obj.VID.fps = fps;
            
            %% Find CSV files
            
            csvfiles = dir(fullfile(analysisDir, '*.csv'));
            nFiles = numel(csvfiles);
            fileNames = [];
            for j = 1:nFiles
                fileNames{j} = csvfiles(j).name;
            end
            
            list = {fileNames{1:end}};
            
            for j = 1:3
                switch j
                    case 1
                        prompt = 'Please select the "BL" csv file';
                    case 2
                        prompt = 'Please select the "postPain" csv file';
                    case 3
                        prompt = 'Please select the "postTouch" csv file';
                end
                
                
                
                [indx,tf] = listdlg('PromptString',prompt, 'ListString',list, 'SelectionMode','single', 'ListSize', [700 200]);
                
                SelectedFiles{j} = list{indx};
                
            end
            
            underscore = '_';
            bla = find(ExperimentName == underscore);
            ExperimentName(bla) = '-';
            
            obj.PATH.ExperimentName = ExperimentName;
            obj.PATH.analysisDir = analysisDir;
            
            BL_csv = SelectedFiles{1};
            pP_csv = SelectedFiles{2};
            pT_csv = SelectedFiles{3};
            
            obj.PATH.BL_csv = BL_csv;
            obj.PATH.pP_csv = pP_csv;
            obj.PATH.pT_csv = pT_csv;
            
            %% Create plot Dirs
            
            obj.PATH.Plots = [analysisDir 'Plots' dirD];
            
            if exist(obj.PATH.Plots, 'dir') ==0
                mkdir(obj.PATH.Plots);
                disp(['Created directory: ' obj.PATH.Plots])
            end
            
            %             obj.PATH.pP_plots = [analysisDir 'pP_Plots' dirD];
            %
            %             if exist(obj.PATH.pP_plots, 'dir') ==0
            %                 mkdir(obj.PATH.pP_plots);
            %                 disp(['Created directory: ' obj.PATH.pP_plots])
            %             end
            %
            %             obj.PATH.pT_plots = [analysisDir 'pT_Plots' dirD];
            %
            %             if exist(obj.PATH.pT_plots, 'dir') ==0
            %                 mkdir(obj.PATH.pT_plots);
            %                 disp(['Created directory: ' obj.PATH.pT_plots])
            %             end
            
        end
        
        
        function [obj] = loadTrackedData(obj)
            
            for j = 1:3
                
                switch j
                    case 1
                        filename = [obj.PATH.analysisDir obj.PATH.BL_csv];
                        disp('Loading tracked data: baseline...')
                    case 2
                        filename = [obj.PATH.analysisDir obj.PATH.pP_csv];
                        disp('Loading tracked data: postPain...')
                    case 3
                        filename = [obj.PATH.analysisDir obj.PATH.pT_csv];
                        disp('Loading tracked data: postTouch...')
                end
                %% Initialize variables.
                
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
                    for row=1:size(rawData, 1)
                        % Create a regular expression to detect and remove non-numeric prefixes and
                        % suffixes.
                        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
                        try
                            result = regexp(rawData{row}, regexstr, 'names');
                            numbers = result.numbers;
                            
                            % Detected commas in non-thousand locations.
                            invalidThousandsSeparator = false;
                            if any(numbers==',')
                                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                                if isempty(regexp(thousandsRegExp, ',', 'once'))
                                    numbers = NaN;
                                    invalidThousandsSeparator = true;
                                end
                            end
                            % Convert numeric strings to numbers.
                            if ~invalidThousandsSeparator
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
                
                allCoords.uppereyelid.x = cell2mat(raw(:, 2));
                allCoords.uppereyelid.y = cell2mat(raw(:, 3));
                allCoords.uppereyelid.likelihood = cell2mat(raw(:, 4));
                
                allCoords.lowereyelid.x = cell2mat(raw(:, 5));
                allCoords.lowereyelid.y = cell2mat(raw(:, 6));
                allCoords.lowereyelid.likelihood = cell2mat(raw(:, 7));
                
                allCoords.upperbeak.x = cell2mat(raw(:, 8));
                allCoords.upperbeak.y = cell2mat(raw(:, 9));
                allCoords.upperbeak.likelihood = cell2mat(raw(:, 10));
                
                allCoords.lowerbeak.x = cell2mat(raw(:, 11));
                allCoords.lowerbeak.y = cell2mat(raw(:, 12));
                allCoords.lowerbeak.likelihood = cell2mat(raw(:, 13));
                
                allCoords.elbow.x = cell2mat(raw(:, 14));
                allCoords.elbow.y = cell2mat(raw(:, 15));
                allCoords.elbow.likelihood = cell2mat(raw(:, 16));
                
                allCoords.tarsus.x = cell2mat(raw(:, 17));
                allCoords.tarsus.y = cell2mat(raw(:, 18));
                allCoords.tarsus.likelihood = cell2mat(raw(:, 19));
                
                allCoords.metatarsus.x = cell2mat(raw(:, 20));
                allCoords.metatarsus.y = cell2mat(raw(:, 21));
                allCoords.metatarsus.likelihood = cell2mat(raw(:, 22));
                
                %             allCoords.rightfoot.x = cell2mat(raw(:, 23));
                %             allCoords.rightfoot.y = cell2mat(raw(:, 24));
                %             allCoords.rightfoot.likelihood = cell2mat(raw(:, 25));
                
                varNames = {'bodyparts_scorer', 'uppereyelid', 'lowereyelid', 'upperbeak', 'lowerbeak', 'elbow', 'tarsus', 'metatarsus'} ;
                
                allCoords.nEntries = numel(allCoords.uppereyelid.y);
                
                switch j
                    case 1 %BL
                        obj.COORDS.BL = allCoords;
                        obj.COORDS.BL_varNames = varNames;
                        
                    case 2 %postPain
                        
                        obj.COORDS.pP = allCoords;
                        obj.COORDS.pP_varNames = varNames;
                        
                    case 3 %postTouch
                        
                        obj.COORDS.pT = allCoords;
                        obj.COORDS.pT_varNames = varNames;
                        
                end
                
                disp('Body parts annotated: ')
                celldisp(varNames);
                disp(['n Entries: ' num2str(allCoords.nEntries )]);
                
                %% Clear temporary variables
                clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me R;
                
                disp('done...')
            end
            
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
        
        function [obj] = plot_variable_over_time(obj, variable)
            
            
            fps = obj.VID.fps;
            
            
            list = {obj.COORDS.BL_varNames{2:end}};
            [indx,tf] = listdlg('PromptString','Choose tracked objects:', 'ListString',list);
            
            nChoices = numel(indx);
            for k = 1:nChoices
                allChoices{k} = list{indx(k)};
            end
            
            for  k =1:3
                
                switch k
                    case 1 %BL
                        coords = obj.COORDS.BL;
                        varNames = obj.COORDS.BL_varNames;
                        
                    case 2 %postPain
                        
                        coords = obj.COORDS.pP;
                        varNames = obj.COORDS.pP_varNames;
                        
                        
                    case 3 %postTouch
                        coords = obj.COORDS.pT;
                        varNames = obj.COORDS.pT_varNames;
                        
                        
                end
                
                figure(100+k);clf
                
                cols = {[0, 0.4470, 0.7410], [0.8500, 0.3250, 0.0980], [0.9290, 0.6940, 0.1250], [0.4940, 0.1840, 0.5560]...
                    [0.4660, 0.6740, 0.1880],  [0, 0.75, 0.75], [0.6350, 0.0780, 0.1840], [0.25, 0.25, 0.25], [0.360000 0.540000 0.660000]...
                    [0.890000 0.150000 0.210000], [0.600000 0.400000 0.800000], [1.000000 0.800000 0.640000], [0.840000 0.040000 0.330000]};
                
                %% Iterate over Choices
                % figH = figure(100);clf
                
                for j = 1:nChoices
                    
                    thisTrackedObject = allChoices{j};
                    
                    switch variable
                        
                        case 1
                            eval(['likelihood = coords.' thisTrackedObject '.likelihood;']);
                            data = likelihood;
                            varText = 'likelihood';
                            ylab = 'Likelihood';
                        case 2
                            
                            eval(['coords_X = coords.' thisTrackedObject '.x;']);
                            data = coords_X;
                            
                            varText = 'value';
                            ylab = 'x-coords';
                        case 3
                            eval(['coords_Y = coords.' thisTrackedObject '.y;']);
                            data = coords_Y;
                            varText = 'value';
                            ylab = 'y-coords';
                    end
                    
                    
                    subplot(nChoices, 1, j)
                    
                    timepoints_frames = 1:1:numel(data);
                    timepoints_s = timepoints_frames/fps;
                    
                    %plot(likelihood, 'color', cols{j}, 'marker', '.', 'markersize', 2, 'linestyle', '-')
                    plot(timepoints_s, data, 'color', cols{j}, 'linestyle', '-')
                    %  legend(thisTrackedObject)
                    %   legend ('boxoff')
                    axis tight
                    meanVal = nanmean(data);
                    stdVal = nanstd(data);
                    
                    minVal(j) = min(data);
                    maxVal(j) = max(data);
                    
                    title([thisTrackedObject ' | Mean ' varText ': '   num2str(meanVal) ' ± ' num2str(stdVal) ' (std)' ])
                    ylabel(ylab)
                    
                    if j == nChoices
                        xlabel('Time (s)')
                    end
                end
                
                
                allMinVals(:,k) = minVal;
                allMaxVals(:,k) = maxVal;
                
            end
            
            allMins = min(allMinVals, [], 2);
            allMaxs = max(allMaxVals, [], 2);
            
            for  o = 1:3
                switch o
                    case 1
                        expText = 'BL';
                        
                    case 2
                        expText = 'postPain';
                        
                    case 3
                        expText = 'postTouch';
                        
                end
                figH = figure(100+o);
                for oo = 1:nChoices
                    
                    subplot(nChoices, 1, oo)
                    ylim([allMins(oo)  allMaxs(oo)])
                end
                
                annotation(figH,'textbox',[0.1 0.96 0.46 0.028],'String',[obj.PATH.ExperimentName '-' expText],'LineStyle','none','FitBoxToText','off', 'fontsize', 12);
                
                saveName = [obj.PATH.Plots ylab '_' expText ];
                plotpos = [0 0 15 20]; % keep this so arena dims look ok
                print_in_A4(0, saveName, '-djpeg', 0, plotpos);
            end
        end
        
        
        
        function [obj] = plotDetectionClusters(obj, likelihood_cutoff)
            
            list = {obj.COORDS.BL_varNames{2:end}};
            [indx,tf] = listdlg('PromptString','Choose tracked objects:', 'ListString',list);
            
            nChoices = numel(indx);
            for k = 1:nChoices
                allChoices{k} = list{indx(k)};
            end
            
            for j = 1:3
                
                switch j
                    case 1 %BL
                        coords = obj.COORDS.BL;
                        varNames = obj.COORDS.BL_varNames;
                        
                        expText = 'BL';
                        
                    case 2 %postPain
                        
                        coords = obj.COORDS.pP;
                        varNames = obj.COORDS.pP_varNames;
                        
                        expText = 'postPain';
                        
                        
                    case 3 %postTouch
                        coords = obj.COORDS.pT;
                        varNames = obj.COORDS.pT_varNames;
                        
                        expText = 'postTouch';
                        
                end
                
                plotPath = obj.PATH.Plots;
                
                vidHeight = 1080;
                vidWidth = 1920;
                
                cols = {[0, 0.4470, 0.7410], [0.8500, 0.3250, 0.0980], [0.9290, 0.6940, 0.1250], [0.4940, 0.1840, 0.5560]...
                    [0.4660, 0.6740, 0.1880],  [0, 0.75, 0.75], [0.6350, 0.0780, 0.1840], [0.25, 0.25, 0.25], [0.360000 0.540000 0.660000]...
                    [0.890000 0.150000 0.210000], [0.600000 0.400000 0.800000], [1.000000 0.800000 0.640000], [0.840000 0.040000 0.330000]};
                
                %% Iterate over Choices
                figH = figure(100+j);clf
                
                trackedText = [];
                legText = [];
                for j = 1:nChoices
                    
                    thisTrackedObject = allChoices{j};
                    
                    eval(['coords_X = coords.' thisTrackedObject '.x;']);
                    eval(['coords_Y = coords.' thisTrackedObject '.y;']);
                    eval(['likelihood = coords.' thisTrackedObject '.likelihood;']);
                    
                    hold on
                    % liklihood
                    HL_inds = find(likelihood >= likelihood_cutoff);
                    n_inds = numel(HL_inds);
                    
                    % plot(coords_X, coords_Y, 'color', C(j,:), 'marker', '.', 'markersize', 10, 'linestyle', 'none')
                    plot(coords_X(HL_inds), coords_Y(HL_inds), 'color', cols{j}, 'marker', '.', 'markersize', 10, 'linestyle', '-')
                    trackedText = [trackedText '-' thisTrackedObject];
                    legText{j} = thisTrackedObject;
                    
                end
                
                xlim([0 vidWidth]);
                ylim([0 vidHeight]);
                legend(legText)
                legend ('boxoff')
                legend('location', 'eastoutside')
                figure(figH)
                title('Detection clusters')
                ylabel('y coordinates')
                xlabel('x coordinates')
                
                annotation(figH,'textbox',[0.1 0.96 0.46 0.028],'String',[ obj.PATH.ExperimentName '-' expText],'LineStyle','none','FitBoxToText','off', 'fontsize', 12);
                disp('Printing Plot')
                
                saveName = [plotPath 'DetectionClusters_' expText];
                plotpos = [0 0 25 18]; % keep this so arena dims look ok
                print_in_A4(0, saveName, '-djpeg', 0, plotpos);
            end
        end
        
        
        
        function [obj] = plotVelocity(obj, likelihood_cutoff)
            
            fps = obj.VID.fps;
            
            list = {obj.COORDS.BL_varNames{2:end}};
            [indx,tf] = listdlg('PromptString','Choose tracked objects:', 'ListString',list);
            
            nChoices = numel(indx);
            for k = 1:nChoices
                allChoices{k} = list{indx(k)};
            end
            
            for j = 1:3
                
                switch j
                    case 1 %BL
                        coords = obj.COORDS.BL;
                        varNames = obj.COORDS.BL_varNames;
                        
                        expText = 'BL';
                        
                    case 2 %postPain
                        
                        coords = obj.COORDS.pP;
                        varNames = obj.COORDS.pP_varNames;
                        
                        expText = 'postPain';
                        
                        
                    case 3 %postTouch
                        coords = obj.COORDS.pT;
                        varNames = obj.COORDS.pT_varNames;
                        
                        expText = 'postTouch';
                        
                end
                
                plotPath = obj.PATH.Plots;
                
                vidHeight = 1080;
                vidWidth = 1920;
                
                cols = {[0, 0.4470, 0.7410], [0.8500, 0.3250, 0.0980], [0.9290, 0.6940, 0.1250], [0.4940, 0.1840, 0.5560]...
                    [0.4660, 0.6740, 0.1880],  [0, 0.75, 0.75], [0.6350, 0.0780, 0.1840], [0.25, 0.25, 0.25], [0.360000 0.540000 0.660000]...
                    [0.890000 0.150000 0.210000], [0.600000 0.400000 0.800000], [1.000000 0.800000 0.640000], [0.840000 0.040000 0.330000]};
                
                %% Iterate over Choices
                
                figure(100+j);clf
                figure(200+j);clf
                
                timeRes_s = 1/fps;
                
                for oo = 1:nChoices
                    
                    thisTrackedObject = allChoices{oo};
                    
                    eval(['coords_X = coords.' thisTrackedObject '.x;']);
                    eval(['coords_Y = coords.' thisTrackedObject '.y;']);
                    eval(['likelihood = coords.' thisTrackedObject '.likelihood;']);
                    
                    hold on
                    % liklihood
                    HL_inds = find(likelihood >= likelihood_cutoff);
                    n_inds = numel(HL_inds);
                    
                    c_X = coords_X(HL_inds);
                    c_Y = coords_Y(HL_inds);
                    
                    euclideanDistance = [];
                    for k = 1:numel(c_X)-1
                        point_xy_t0 = [c_X(k), c_Y(k)];
                        point_xy_t1 = [c_X(k+1), c_Y(k+1)];
                        distance = [point_xy_t0; point_xy_t1];
                        euclideanDistance(k) = pdist(distance,'euclidean');
                        
                    end
                    
                    meanVal_euclidian = mean(euclideanDistance);
                    stdVal_euclidian = std(euclideanDistance);
                    
                    timepoints_frames = 1:1:numel(euclideanDistance);
                    timepoints_s =timepoints_frames/fps;
                    
                    velocity_px_per_s = euclideanDistance/timeRes_s;
                    
                    meanVal_vel = mean(velocity_px_per_s);
                    stdVal_vel = std(velocity_px_per_s);
                    
                    figure(100+j)
                    subplot(nChoices, 1, oo)
                    hold on
                    plot(timepoints_s, euclideanDistance, 'color', cols{oo}, 'marker', '.', 'markersize', 5, 'linestyle', '-')
                    clear('coords_X', 'coords_Y');
                    axis tight
                    ylim([0 5])
                    title([thisTrackedObject ' | Mean Euclidean distance: '   num2str(meanVal_euclidian) ' ± ' num2str(stdVal_euclidian) ' (std)' ])
                    ylabel('Distance (px)')
                    
                    figure(200+j)
                    subplot(nChoices, 1, oo)
                    hold on
                    plot(timepoints_s, velocity_px_per_s, 'color', cols{oo}, 'marker', '.', 'markersize', 5, 'linestyle', '-')
                    clear('coords_X', 'coords_Y');
                    axis tight
                    ylim([0 100])
                    title([thisTrackedObject ' | Mean velocity: '   num2str(meanVal_vel) ' ± ' num2str(stdVal_vel) ' (std)' ])
                    ylabel('Velocity (px/s)')
                    
                    allEucDist{oo} = euclideanDistance;
                    allVel{oo} = velocity_px_per_s;
                end
                
                plotPath = obj.PATH.Plots;
                plotpos = [0 0 15 20]; % keep this so arena dims look ok
                
                figH = figure(200+j);
                xlabel('Time (s)')
                annotation(figH,'textbox',[0.1 0.96 0.46 0.028],'String',[obj.PATH.ExperimentName '-' expText],'LineStyle','none','FitBoxToText','off', 'fontsize', 12);
                saveName = [plotPath 'Velocity' expText];
                print_in_A4(0, saveName, '-djpeg', 0, plotpos);
                
                figH = figure(100+j);
                xlabel('Time (s)')
                annotation(figH,'textbox',[0.1 0.96 0.46 0.028],'String',[obj.PATH.ExperimentName '-' expText],'LineStyle','none','FitBoxToText','off', 'fontsize', 12);
                saveName = [plotPath 'Distance' expText];
                print_in_A4(0, saveName, '-djpeg', 0, plotpos);
                
                allEucDistOverExps{j} = allEucDist;
                allVelsOverExps{j} = allVel;
            end
            
            saveNameDistances = [obj.PATH.Plots 'Euclidean.mat'];
            save(saveNameDistances, 'allEucDistOverExps', 'allVelsOverExps', 'allChoices')
            
            obj.PATH.EuclideanMat = saveNameDistances;
            
        end
        
        
        function obj = makePlotsForDistances(obj, vel_or_dist)
            if isfile(obj.PATH.EuclideanMat)
                load(obj.PATH.EuclideanMat);
            else
                disp('Please run "plotVelocity" analysis')
                return
            end
            
            switch vel_or_dist
                case 1
                    BL_vels = allVelsOverExps{1,1};
                    pP_vels = allVelsOverExps{1,2};
                    pT_vels = allVelsOverExps{1,3};
                    lab = 'Velocity (px/s)';
                    savetxt = 'Velocity';
                case 2
                    BL_vels = allEucDistOverExps{1,1};
                    pP_vels = allEucDistOverExps{1,2};
                    pT_vels = allEucDistOverExps{1,3};
                    lab = 'Distance (px)';
                    savetxt = 'Distance';
                    
            end
            
            nChoices = numel(allChoices);
            p = numSubplots(nChoices);
            
            %% Boxplots
            figure(103); clf
            for k = 1:nChoices
                
                BL_val = BL_vels{1,k};
                pP_val = pP_vels{1,k};
                pT_val = pT_vels{1,k};
                
                [p1,h] = ranksum(BL_val, pP_val);
                [p2,h] = ranksum(BL_val, pT_val);
                
                subplot(p(1),p(2),k)
                
                x = [BL_val pP_val pT_val];
                g = [zeros(length(BL_val), 1); ones(length(pP_val), 1); 2*ones(length(pT_val), 1)];
                %boxplot(x, g, 'plotstyle', 'compact', 'Labels',{'BL','postPain', 'postTouch'}, 'color', 'k' , 'whisker', 50)
                boxplot(x, g, 'Labels',{'BL','postPain', 'postTouch'}, 'color', 'k' , 'whisker', 50)
                yss = ylim;
                text(0.8, yss(2)*0.9, ['BL vs pP: p = ' num2str(p1)]);
                text(0.8, yss(2)*0.8, ['BL vs pT: p = ' num2str(p2)]);
                ylabel(lab)
                title(allChoices{k})
                
            end
            
            plotpos = [0 0 30 15]; % keep this so arena dims look ok
            
            saveName = [obj.PATH.Plots 'Boxplot-' savetxt];
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
                
                
            %% heatmap
            
            clims = [-2 15];
            
            fps = 50;
            smoothWin_s = 1;
            smoothWin_frames = smoothWin_s*fps;
            
            for k = 1:nChoices
                
                thisBLVal = BL_vels{k};
                
                [Z_BL,mean_BL,std_BL]= zscore(thisBLVal);
                
                thispPVal = pP_vels{k};
                thispTVal = pT_vels{k};
                
                zscore_pP = (thispPVal - mean_BL) ./ std_BL;
                zscore_pT = (thispTVal - mean_BL) ./ std_BL;
                
                minVal = min([Z_BL zscore_pP zscore_pT]);
                maxVal = max([Z_BL zscore_pP zscore_pT]);
                
                %clims = [floor(minVal) ceil(maxVal)];
                
                figure(100+k); clf
                subplot(3, 1, 1)
                %imagesc(Z_BL, clims)
                imagesc(smooth(Z_BL, smoothWin_frames)', clims)
                xticks = get(gca, 'xtick');
                xticlabs = xticks/fps;
                for j = 1:numel(xticlabs)
                    xtickLabs{j} = num2str(xticlabs(j));
                end
                set(gca, 'xticklabel',xtickLabs)
                set(gca,'YTickLabel',[]);
                colorbar
                title([allChoices{k} ': Baseline'])
                
                subplot(3, 1, 2)
                %imagesc(zscore_pP, clims)
                imagesc(smooth(zscore_pP, smoothWin_frames)', clims)
                xticks = get(gca, 'xtick');
                xticlabs = xticks/fps;
                for j = 1:numel(xticlabs)
                    xtickLabs{j} = num2str(xticlabs(j));
                end
                set(gca, 'xticklabel',xtickLabs)
                set(gca,'YTickLabel',[]);
                colorbar
                title([allChoices{k} ': postPain'])
                
                subplot(3, 1, 3)
                %imagesc(zscore_pT, clims)
                imagesc(smooth(zscore_pT,smoothWin_frames)', clims)
                xticks = get(gca, 'xtick');
                xticlabs = xticks/fps;
                for j = 1:numel(xticlabs)
                    xtickLabs{j} = num2str(xticlabs(j));
                end
                set(gca, 'xticklabel',xtickLabs)
                set(gca,'YTickLabel',[]);
                colorbar
                title([allChoices{k} ': postTouch'])
                xlabel('Time (s)')
                
                plotpos = [0 0 15 12]; % keep this so arena dims look ok
                
                saveName = [obj.PATH.Plots 'Heatmap-' allChoices{k} '_' savetxt];
                print_in_A4(0, saveName, '-djpeg', 0, plotpos);
                
            end
            %% Z scores
            for k = 1:nChoices
                
                thisBLVal = BL_vels{k};
                [Z_BL,mean_BL,std_BL]= zscore(thisBLVal);
                
                thispPVal = pP_vels{k};
                thispTVal = pT_vels{k};
                
                zscore_pP = (thispPVal - mean_BL) ./ std_BL;
                zscore_pT = (thispTVal - mean_BL) ./ std_BL;
                
                figure(100+k); clf
                
                subplot(3, 1, 1)
                timepoints_frames = 1:1:numel(Z_BL);
                timepoints_s = timepoints_frames/fps;
                plot(timepoints_s, smooth(Z_BL, smoothWin_frames))
                axis tight
                title([allChoices{k} ': Baseline'])
                ylabel('Z-score')
                
                subplot(3, 1, 2)
                timepoints_frames = 1:1:numel(zscore_pP);
                timepoints_s = timepoints_frames/fps;
                plot(timepoints_s, smooth(zscore_pP, smoothWin_frames))
                title([allChoices{k} ': postPain'])
                ylabel('Z-score')
                axis tight
                
                subplot(3, 1, 3)
                timepoints_frames = 1:1:numel(zscore_pT);
                timepoints_s = timepoints_frames/fps;
                plot(timepoints_s, smooth(zscore_pT,smoothWin_frames))
                  axis tight
                xlabel('Time (s)')
                ylabel('Z-score')
                title([allChoices{k} ': postTouch'])
                
                
                plotpos = [0 0 15 12]; % keep this so arena dims look ok
                
                saveName = [obj.PATH.Plots 'Zscores-' allChoices{k} '_' savetxt];
                print_in_A4(0, saveName, '-djpeg', 0, plotpos);
                
            end
            
            
        end
        
        
        function obj = makePlotsMeanWindowAnalysis(obj, vel_or_dist)
        

            if isfile(obj.PATH.EuclideanMat)
                load(obj.PATH.EuclideanMat);
            else
                disp('Please run "plotVelocity" analysis')
                return
            end
            
            switch vel_or_dist
                case 1
                    BL_vels = allVelsOverExps{1,1};
                    pP_vels = allVelsOverExps{1,2};
                    pT_vels = allVelsOverExps{1,3};
                    lab = 'Velocity (px/s)';
                    savetxt = 'Velocity';
                    
                case 2
                    BL_vels = allEucDistOverExps{1,1};
                    pP_vels = allEucDistOverExps{1,2};
                    pT_vels = allEucDistOverExps{1,3};
                    lab = 'Distance (px)';
                    savetxt = 'Distance';
                    
            end
            
            nChoices = numel(allChoices);
            p = numSubplots(nChoices);
            
            %% Boxplots
            figure(103); clf
            
            fps = 50;
            
            timeWindow_roi_s = [10 120];
            timeWindow_roi_frames = timeWindow_roi_s*fps;
            win_s = 5;
            win_frames = win_s*fps;
            for k = 1:nChoices
                
                BL_val = BL_vels{1,k}(timeWindow_roi_frames(1): timeWindow_roi_frames(2)-1);
                pP_val = pP_vels{1,k}(timeWindow_roi_frames(1): timeWindow_roi_frames(2)-1);
                pT_val = pT_vels{1,k}(timeWindow_roi_frames(1): timeWindow_roi_frames(2)-1);
            
                BL_buff = buffer(BL_val, win_frames);
                pP_buff = buffer(pP_val, win_frames);
                pT_buff = buffer(pT_val, win_frames);
                
                BL_means = mean(BL_buff, 1);
                pP_means = mean(pP_buff, 1);
                pT_means = mean(pT_buff, 1);
                
                allBL_buffs{k} =BL_buff;
                allpP_buffs{k} =pP_buff;
                allpT_buffs{k} =pT_buff;
                %[h, pp] = lillietest(BL_means );
                
                [p1,h] = ranksum(BL_means, pP_means);
                [p2,h] = ranksum(BL_means, pT_means);
                
%                 [h, p1] = ttest(BL_means, pP_means);
%                 [h, p2] = ttest(BL_means, pT_means);
                
                subplot(p(1),p(2),k)
                
                toPlot = [BL_means ; pP_means ;pT_means];
                boxplot(toPlot', 'Labels',{'BL','postPain', 'postTouch'}, 'color', 'k' , 'whisker', 50)
               
                yss = ylim;
                text(0.8, yss(2)*0.9, ['BL vs pP: p = ' num2str(p1)]);
                text(0.8, yss(2)*0.8, ['BL vs pT: p = ' num2str(p2)]);
                ylabel(lab)
                title(allChoices{k})
                
            end
            
             plotpos = [0 0 35 15]; % keep this so arena dims look ok
            
            saveName = [obj.PATH.Plots 'BoxplotMeans-' savetxt];
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
               
            clims = [0 0.5];
            
             for k = 1:nChoices
                 
                  
                BL_buff = mean(allBL_buffs{k}, 1);
                pP_buff = mean(allpP_buffs{k}, 1);
                pT_buff = mean(allpT_buffs{k}, 1);
                 
            toPlot = [BL_buff; pP_buff; pT_buff];
             
            subplot(p(1),p(2),k)
             
            imagesc(toPlot)
            %imagesc(toPlot, clims)
            colorbar
            title(allChoices{k})
            
             xticks = 1:5:22;
             
                xticlabs = {'15', '40', '65', '90', '115'}; 
                set(gca, 'xtick', xticks)
                set(gca, 'xticklabels', xticlabs)
                set(gca,'YTickLabel',[]);
                xlabel('Time (s)')
             end
            
              plotpos = [0 0 35 15]; % keep this so arena dims look ok
            
            saveName = [obj.PATH.Plots 'HeatmapMeans-' savetxt];
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
               
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
        
        
        function [obj] = plotTimeSpentInQuadrants(obj, likelihood_cutoff)
            
            if nargin <2
                likelihood_cutoff = 0;
                text_save = ['-full'];
            else
                text_save = ['-LH'];
            end
            
            text_supp = ['LH = ' num2str(likelihood_cutoff)];
            
            vidObj = obj.VID.vidObj;
            frameToPlot = 10;
            vidFrame = read(vidObj, frameToPlot );
            
            varNames = obj.COORDS.varNames;
            
            list = {varNames{2:end}};
            [indx,tf] = listdlg('PromptString','Choose tracked objects:', 'ListString',list, 'SelectionMode', 'single');
            
            nChoices = numel(indx);
            for j = 1:nChoices
                allChoices{j} = list{indx(j)};
            end
            
            cols = {'r', 'c', 'g', 'b', 'y', 'm',  'w', 'k'};
            
            %% Iterate over Choices
            figH = figure(100);clf
            image(vidFrame)
            
            topWall_LCorner = [100 75];
            topWall_RCorner = [1200 100];
            bottomWall_LCorner = [100 600];
            bottomWall_RCorner = [1165 600];
            
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
            
            plot(c_X, c_Y, 'color', 'k', 'marker', '.', 'markersize', 10, 'linestyle', 'none')
            
            axis off
            annotation(figH,'textbox',[0.1 0.96 0.46 0.028],'String',[obj.VID.vidName '-' cell2mat(allChoices) '-' text_supp],'LineStyle','none','FitBoxToText','off', 'fontsize', 12);
            disp('Printing Plot')
            %set(0, 'CurrentFigure', figH)
            
            plotPath = obj.PATH.plotPath;
            saveName = [plotPath obj.VID.vidName(1:end-4) '-' cell2mat(allChoices) '_quadrants-' text_save];
            plotpos = [0 0 70 40]; % keep this so arena dims look ok
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
            
            
            %% Find the n points in each coordinate
            
            npoints = numel(c_X);
            allPoints = [c_X c_Y];
            
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
            imagesc(n_points_all, [0 100])
            
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
            plotpos = [0 0 70 40]; % keep this so arena dims look ok
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
            
        end
        
    end
    
    %%
    
    methods (Hidden)
        %class constructor
        function obj = dlcAnalysis_OBJ_embryo(analysisDir, ExperimentName)
            
            %addpath(genpath(analysisDir, ExperimentName))
            
            obj = definePaths(obj, analysisDir, ExperimentName);
            
            
        end
    end
    
end


