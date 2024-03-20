classdef songAnalysis_OBJ_artemis < handle
    
    
    properties (Access = public)
        
        PATH
        DATA
        
    end
    
    methods
        
        
        function obj = definePaths(obj,analysisDir, birdName, night_dph)
            
            if ispc
                dirD = '\';
            else
                dirD = '/';
            end
            
            
            %% Find Excel files
            
            xlsfiles = dir(fullfile(analysisDir, '*.xls'));
            nFiles = numel(xlsfiles);
            fileNames = [];
            for j = 1:nFiles
                fileNames{j} = xlsfiles(j).name;
            end
            
            list = {fileNames{1:end}};
            
            for j = 1:2
                switch j
                    case 1
                        prompt = 'Please select the "last 100 songs" .xls file';
                    case 2
                        prompt = 'Please select the "first 100 songs" .xls file';
                        
                end
                
                
                [indx,tf] = listdlg('PromptString',prompt, 'ListString',list, 'SelectionMode','single', 'ListSize', [700 200]);
                
                SelectedFiles{j} = list{indx};
                
            end
            
            obj.PATH.birdName = birdName;
            obj.PATH.analysisDir = analysisDir;
            obj.PATH.night_dph = night_dph;
            
            last100Files = SelectedFiles{1};
            first100Files = SelectedFiles{2};
            
            obj.PATH.last100Files= last100Files;
            obj.PATH.first100Files = first100Files;
            
            %% Create plot Dirs
            
            obj.PATH.Plots.last100Files = [analysisDir night_dph '-Plots.Last100Files-night'  dirD];

            if exist(obj.PATH.Plots.last100Files, 'dir') ==0
                mkdir(obj.PATH.Plots.last100Files);
                disp(['Created directory: ' obj.PATH.Plots.last100Files])
                copyfile(strcat(analysisDir, obj.PATH.last100Files), obj.PATH.Plots.last100Files)
            end
            
            obj.PATH.Plots.first100Files = [analysisDir night_dph '-Plots.First100Files-nextday'  dirD];
            
            if exist(obj.PATH.Plots.first100Files, 'dir') ==0
                mkdir(obj.PATH.Plots.first100Files);
                disp(['Created directory: ' obj.PATH.Plots.first100Files])
                copyfile(strcat(analysisDir, obj.PATH.first100Files), obj.PATH.Plots.first100Files)
            end
            
        end
        
        function [obj] = loadData_xls(obj)
            
            for j = 1:2
                
                switch j
                    case 1
                        filename = [obj.PATH.analysisDir obj.PATH.last100Files];
                        disp('Loading data: last 100 files')
                    case 2
                        filename = [obj.PATH.analysisDir obj.PATH.first100Files];
                        disp('Loading data: first 100 files...')
                end
                
                
                %% Get Variable names (only have to do this once)
                
                startCol = 3;
                endCol = 17;
                
                [~, ~, xlsFile] = xlsread(filename,'Sheet1');
                xlsFile_row1 = xlsFile(1,2:24);
                xlsFile_row2 = xlsFile(2,2:24);
                xlsFile_row1(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),xlsFile_row1)) = {''};
                xlsFile_row2(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),xlsFile_row2)) = {''};
                
                nCols = size(xlsFile_row1, 2);
                varNames = [];
                for q = 1:nCols
                    
                    varNames{q} = [xlsFile_row1{q} xlsFile_row2{q}];
                end
                
                name = xlsFile{startCol,2};
                filenames = xlsFile(startCol:end,24);
                
                %% Import column vectors
                
                [~, ~, allData] = xlsread(filename,'Sheet1');
                allData = allData(startCol:end,startCol:endCol);
                
                %allData(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),allData)) = {''};
                
                varNames_used = varNames(1,2:16);
                nVars = numel(varNames_used);
                
                data = [];
                for o = 1:nVars
                    
                    thisVar = varNames_used{o};
                    space = ' ';
                    bla = find(thisVar == space );
                    thisVar(bla) = [];
                    
                    triangle = '^';
                    bla = find(thisVar == triangle);
                    thisVar(bla) = [];
                    
                    eval(['data.' thisVar '= cell2mat(allData(:, o));']);
                 
                    allVars{o} = thisVar;
                end
                
                
                switch j
                    case 1 %last 100 files
                        
                        obj.DATA.last100files.name = name;
                        obj.DATA.last100files.filenames = filenames;
                        obj.DATA.last100files.data = data;
                        obj.DATA.last100files.varNames = allVars;
                        
                    case 2 %first 100 files
                        
                        obj.DATA.first100files.name = name;
                        obj.DATA.first100files.filenames = filenames;
                        obj.DATA.first100files.data = data;
                        obj.DATA.first100files.varNames = allVars;
                        
                end
                
                disp('done...')
            end
            
        end

        %% Cluster syllables
        
        function [obj] = clusterSyllables(obj, fileSwitch)
            
            if fileSwitch == 1
                D.name  = obj.DATA.last100files.name;
                D.filenames = obj.DATA.last100files.filenames;
                D.data  = obj.DATA.last100files.data;
                D.varNames  = obj.DATA.last100files.varNames;
            
            disp('')
            
            syllablestart = D.data.syllablestart;
            syllableduration = D.data.syllableduration;
            
            figure(100); clf
            plot(syllablestart,syllableduration, 'k.', 'Markersize', 5)
            ylabel('Syllable duration (ms)')
            xlabel('Syllable start time (ms)')
            
            
            prompt = {'Enter number of clusters:'};
            dlgtitle = 'Input';
            fieldsize = [1 45];
            definput = {''};
            answer = inputdlg(prompt,dlgtitle,fieldsize,definput);
            
            nClusters = str2num(answer{:});
            
            colStr = {'r.', 'g.', 'b.', 'k.'};
            
            toCluster = [syllablestart syllableduration];
            
            rng = 1;
            
            [idx,C] = kmeans(toCluster, nClusters, 'Distance', 'cityblock', 'Replicates', 5);

            [B,I] = sort(C(:,1),'ascend');
            
            %% Remap Custers based on sorted syllable start 
            
            newCluster_idx = nan(size(idx, 1), 1);
            for j = 1:size(I, 1)
            
                inds = find(idx == I(j));
                
                newCluster_idx(inds)= j;
            end
            
            remappedClusters.nClusters = nClusters;
            remappedClusters.syllablestart_centroids = B;
            remappedClusters.newCluster_idx = newCluster_idx;
            
            AllClusterInds = [];
            for j = 1:size(I, 1)
                
                clusterInds = find(newCluster_idx == j);
                AllClusterInds{j} = clusterInds;
            end
          
            remappedClusters.AllClusterInds = AllClusterInds;

            writematrix(newCluster_idx, strcat(obj.PATH.Plots.last100Files, obj.PATH.last100Files),'Range','W3:W302')
            
            figH = figure(101); clf
            hold on
            for j = 1:nClusters
                thisColStr = colStr{j};
                cnt = j;
                eval(['plot(syllablestart(newCluster_idx == cnt),syllableduration(newCluster_idx == cnt),''' thisColStr ''',''MarkerSize'',5)'])
                
            end
            
            hold on
            plot(C(:,1),C(:,2),'kx',...
                'MarkerSize',15,'LineWidth',3)
            ylabel('Syllable duration (ms)')
            xlabel('Syllable start time (ms)')
            legend('Cluster 1', 'Cluster 2', 'Centroids', 'FontSize',12, 'Location','NW')
            
               annotation(figH,'textbox',[0.02 0.98 0.46 0.028],'String',[obj.PATH.birdName '-' obj.PATH.night_dph '-last 100 files: '],'LineStyle','none','FitBoxToText','off', 'fontsize', 12);
                
                saveName = [obj.PATH.Plots.last100Files obj.PATH.night_dph '_AllClusters_Last100Files_night'];
                plotpos = [0 0 15 12]; % keep this so arena dims look ok
                print_in_A4(0, saveName, '-djpeg', 0, plotpos);
                
        elseif fileSwitch ==2
                D.name  = obj.DATA.first100files.name;
                D.filenames = obj.DATA.first100files.filenames;
                D.data  = obj.DATA.first100files.data;
                D.varNames  = obj.DATA.first100files.varNames;

                 disp('')
            
            syllablestart = D.data.syllablestart;
            syllableduration = D.data.syllableduration;
            
            figure(100); clf
            plot(syllablestart, syllableduration,'k.', 'Markersize', 5)
            ylabel('Syllable duration (ms)')
            xlabel('Syllable start time (ms)')
            
            
            prompt = {'Enter number of clusters:'};
            dlgtitle = 'Input';
            fieldsize = [1 45];
            definput = {''};
            answer = inputdlg(prompt,dlgtitle,fieldsize,definput);
            
            nClusters = str2num(answer{:});
            
            colStr = {'r.', 'g.', 'b.', 'k.'};
            
            toCluster = [syllablestart syllableduration];
            
            rng = 1;
            
            [idx,C] = kmeans(toCluster, nClusters, 'Distance', 'cityblock', 'Replicates', 5);

            [B,I] = sort(C(:,1),'ascend');
            
            %% Remap Custers based on sorted syllable start 
            
            newCluster_idx = nan(size(idx, 1), 1);
            for j = 1:size(I, 1)
            
                inds = find(idx == I(j));
                
                newCluster_idx(inds)= j;
            end
            
            remappedClusters.nClusters = nClusters;
            remappedClusters.syllablestart_centroids = B;
            remappedClusters.newCluster_idx = newCluster_idx;
            
            AllClusterInds = [];
            for j = 1:size(I, 1)
                
                clusterInds = find(newCluster_idx == j);
                AllClusterInds{j} = clusterInds;
            end
          
            remappedClusters.AllClusterInds = AllClusterInds;

            writematrix(newCluster_idx, strcat(obj.PATH.Plots.first100Files, obj.PATH.first100Files),'Range','W3:W302')
            
            figH = figure(102); clf
            hold on
            for j = 1:nClusters
                thisColStr = colStr{j};
                cnt = j;
                eval(['plot(syllablestart(newCluster_idx == cnt),syllableduration(newCluster_idx == cnt),''' thisColStr ''',''MarkerSize'', 5)'])
                
            end

            hold on
            plot(C(:,1),C(:,2),'kx',...
                 'MarkerSize',15,'LineWidth',3) 
            ylabel('Syllable duration (ms)')
            xlabel('Syllable start time (ms)')
            legend('Cluster 1','Cluster 2', 'Centroids',...
                'Location','NW')  
            
            annotation(figH,'textbox',[0.02 0.98 0.46 0.028],'String',[obj.PATH.birdName '-' obj.PATH.night_dph '-first 100 files: '],'LineStyle','none','FitBoxToText','off', 'fontsize', 12);
              
               saveName = [obj.PATH.Plots.first100Files obj.PATH.night_dph '_AllClusters_First100Files_next day'];
                plotpos = [0 0 15 12]; % keep this so arena dims look ok
                print_in_A4(0, saveName, '-djpeg', 0, plotpos);
            
        end

            if fileSwitch == 1
                
                obj.DATA.last100files.clusters.C = C;
                obj.DATA.last100files.clusters.idx = idx;
                obj.DATA.last100files.clusters.nClusters = nClusters;
                obj.DATA.last100files.remappedClusters = remappedClusters;
           
            elseif fileSwitch == 2
                
                obj.DATA.first100files.clusters.C = C;
                obj.DATA.first100files.clusters.idx = idx;
                obj.DATA.first100files.clusters.nClusters = nClusters;
                obj.DATA.first100files.remappedClusters = remappedClusters;
            end
            
            
        end

        %% Plot Clustered Variables
        function [obj] = plotSongVariableClusters(obj, fileSwitch)
            
            
            if fileSwitch == 1
                D.name  = obj.DATA.last100files.name;
                D.filenames = obj.DATA.last100files.filenames;
                D.data  = obj.DATA.last100files.data;
                D.varNames  = obj.DATA.last100files.varNames;
                D.clusters.nClusters = obj.DATA.last100files.remappedClusters.nClusters;
                D.clusters.idx = obj.DATA.last100files.remappedClusters.newCluster_idx;
                D.clusters.C = obj.DATA.last100files.remappedClusters.syllablestart_centroids;
                

            list = D.varNames;
            [indx,tf] = listdlg('PromptString','Choose tracked objects :', 'ListString',list);
            
            nChoices = numel(indx);
            allChoices = list(indx);
            colStr = {'r', 'g', 'b', 'k', 'm', 'c', 'y'};
            
            for o = 1:nChoices
                
                thisVar = allChoices{o};
                eval(['thisData = D.data.' thisVar ';'])
                

                figH = figure(100+o); clf
                hold on
                for j = 1:D.clusters.nClusters
                    plot(D.data.syllablestart(D.clusters.idx==j),thisData(D.clusters.idx==j), colStr{j}, 'Marker', '.', 'linestyle', 'none', 'MarkerSize', 5)
                 
                end
                
                xlabel('Syllable start time (ms)')
                ylabel(thisVar)
                title(thisVar)
               
               annotation(figH,'textbox',[0.02 0.98 0.46 0.028],'String',[obj.PATH.birdName '-' obj.PATH.night_dph '-last 100 files'],'LineStyle','none','FitBoxToText','off', 'fontsize', 12);
                
                saveName = [obj.PATH.Plots.last100Files obj.PATH.night_dph '_last100clusters_' thisVar];
                plotpos = [0 0 15 12]; % keep this so arena dims look ok
                print_in_A4(0, saveName, '-djpeg', 0, plotpos);
                

            end
            
            elseif fileSwitch ==2
                D.name  = obj.DATA.first100files.name;
                D.filenames = obj.DATA.first100files.filenames;
                D.data  = obj.DATA.first100files.data;
                D.varNames  = obj.DATA.first100files.varNames;
                D.clusters.nClusters = obj.DATA.first100files.remappedClusters.nClusters;
                D.clusters.idx = obj.DATA.first100files.remappedClusters.newCluster_idx;
                D.clusters.C = obj.DATA.first100files.remappedClusters.syllablestart_centroids;

            list = D.varNames;
            [indx,tf] = listdlg('PromptString','Choose tracked objects :', 'ListString',list);
            
            nChoices = numel(indx);
            allChoices = list(indx);
            colStr = {'r', 'g', 'b', 'k', 'm', 'c', 'y'};
            
            for o = 1:nChoices
                
                thisVar = allChoices{o};
                eval(['thisData = D.data.' thisVar ';'])
                
                
                figH = figure(100+o); clf
                hold on
                for j = 1:D.clusters.nClusters
                    plot(D.data.syllablestart(D.clusters.idx==j),thisData(D.clusters.idx==j), colStr{j}, 'Marker', '.', 'linestyle', 'none', 'MarkerSize', 5)
                    
                end
                
                xlabel('Syllable start time (ms)')
                ylabel(thisVar)
                title(thisVar)
               
               annotation(figH,'textbox',[0.02 0.98 0.46 0.028],'String',[obj.PATH.birdName '-' obj.PATH.night_dph '-first 100 files'],'LineStyle','none','FitBoxToText','off', 'fontsize', 12);
                
                saveName = [obj.PATH.Plots.first100Files obj.PATH.night_dph '_first100clusters_' thisVar];
                plotpos = [0 0 15 12]; % keep this so arena dims look ok
                print_in_A4(0, saveName, '-djpeg', 0, plotpos);
               
            end
            end            
        end
        
    end
    
    %%
    
    methods (Hidden)
        %class constructor
        function obj = songAnalysis_OBJ_artemis(analysisDir, birdName, night_dph)
            
            %addpath(genpath(analysisDir, ExperimentName))
            
            obj = definePaths(obj, analysisDir, birdName, night_dph);
            
            
        end
    end
    
end



