function [] = loadAndPlotSimilarityStats()

StatsDir = 'H:\HamedsData\Songs\w027\SimilarityAnalysis\SAPStats\';

  textSearch = '*xlsx*'; % text search for ripple detection file
   xlsxFiles = dir(fullfile(StatsDir,textSearch));
   
nFiles = numel(xlsxFiles);



for j  =1:nFiles
    
filePath =    [StatsDir  xlsxFiles(j).name];
   
fileNames{j} = xlsxFiles(j).name;
txtShort{j} = xlsxFiles(j).name(1:10);
stats{j} = load_xls_data(filePath);

end


for j  =1:nFiles
    
  Similarity(j, :) = stats{1,j}.Similarity; 
    Accuracy(j, :) = stats{1,j}.Accuracy;
    Sequential(j, :) = stats{1,j}.Sequential;
    
    col{j} = [j*255/20 50 255-j*255/20]/255;
end
cols = cell2mat(col(:));
disp('')


% x = [Similarity{1}; Similarity{2}; Similarity{3}];
% g = [zeros(length(Similarity{1}), 1); ones(length(Similarity{2}), 1); 2*ones(length(Similarity{3}), 1)];
% boxplot(x, g, 'PlotStyle','compact', 'whisker', 0)
% figure; scatter(x, g)

% x = [Similarity'];
% g = [zeros(length(Similarity{1}), 1); ones(length(Similarity{2}), 1); 2*ones(length(Similarity{3}), 1)];

figure(104);clf
boxplot(Similarity', 'PlotStyle','compact', 'whisker', 0)
%figure; scatter(x, g)

figure(103);clf
%boxplot(xes,groups,'orientation','horizontal','color',cols , 'plotstyle', 'compact', 'Whisker', 15, 'label', txtShort);
boxplot(Similarity','orientation','vertical','color',cols , 'plotstyle', 'compact', 'Whisker', 15, 'label', txtShort);
%view(h(3),[270,90]);  % Rotate the Y plot
meadians = nanmedian(Similarity, 2);
hold on
xess = 1:1:size(Similarity, 1);
plot(xess, meadians,'k')

%%


%cols = cell2mat({[0.6350, 0.0780, 0.1840]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; [0, 0, 0]; [0.4940, 0.1840, 0.5560]});

group1 = ones(1, 90)*1;
group2 = ones(1, 90)*2;
group3 = ones(1, 90)*3;
group4 = ones(1, 90)*4;
group5 = ones(1, 90)*5;
group6 = ones(1, 90)*6;
group7 = ones(1, 90)*7;
group8 = ones(1, 90)*8;
group9 = ones(1, 90)*9;
group10 = ones(1, 90)*10;
group11 = ones(1, 90)*11;
group12 = ones(1, 90)*12;
group13 = ones(1, 90)*13;

groups = [group1 group2 group3 group4 group5 group6 group7 group8 group9 group10 group11 group12 group13];

yes = groups;
% 
% figure(105)
% xes = [Similarity'];
% xes = xes(:);
% h = scatterhist(yes,xes,'Group',groups,'Kernel','on', 'Location','SouthEast',...
%     'Direction','out', 'LineStyle',{'-','-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-'}, 'Marker','.............', 'markersize', 10, 'color', cols);
% % 
% 
% hold on;
% %clr = get(h(1),'colororder');
% boxplot(h(3),xes,groups,'orientation','horizontal',...
%     'label',{'','','','','','','','','','','','',''},'color',cols , 'plotstyle', 'compact', 'Whisker', 15);
% %view(h(3),[270,90]);  % Rotate the Y plot
% view(h(3),[90,270]);  % Rotate the Y plot
% axis(h(1),'auto');  % Sync axes

figure(103);clf
%boxplot(xes,groups,'orientation','horizontal','color',cols , 'plotstyle', 'compact', 'Whisker', 15, 'label', txtShort);
boxplot(Similarity','orientation','vertical','color',cols , 'plotstyle', 'compact', 'Whisker', 15, 'label', txtShort);
%view(h(3),[270,90]);  % Rotate the Y plot
meadians = nanmedian(Similarity, 2);
hold on
xess = 1:1:numel(meadians);
plot(xess, meadians,'k')
%view([90,270]);  % Rotate the Y plotl
%axis(h(1),'auto');  % Sync axes

end

    function [stats] = load_xls_data(filePath)
  
        
[~, ~, raw] = xlsread(filePath,'Sheet1');
raw = raw(3:end,:);
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
stringVectors = string(raw(:,[1,2,15]));
stringVectors(ismissing(stringVectors)) = '';
raw = raw(:,[3,4,5,6,7,8,9,10,11,12,13,14]);

%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

%% Create output variable
data = reshape([raw{:}],size(raw));

%% Create table
stats = table;

%% Allocate imported array to column variable names
stats.Sound1 = stringVectors(:,1);
stats.Sound2 = categorical(stringVectors(:,2));
stats.Similarity = data(:,1);
stats.Accuracy = data(:,2);
stats.Sequential = data(:,3);
stats.Pitchdiff = data(:,4);
stats.FMdiff = data(:,5);
stats.Entropydiff = data(:,6);
stats.Goodnessdiff = data(:,7);
stats.AMdiff = data(:,8);
stats.From1 = data(:,9);
stats.To1 = data(:,10);
stats.From2 = data(:,11);
stats.To2 = data(:,12);
stats.Comments = categorical(stringVectors(:,3));

    end



    