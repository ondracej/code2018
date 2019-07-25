function [] = trackTadpolesMakeMovie()

DLTDv5Dir = 'F:\Grass\Tadpoles\5Tadpoles_Grp1\editedVids\editedVids\';

searchString = '*xypts*';

all_xy_pts = dir(fullfile(DLTDv5Dir, searchString));

n_xy_ptsFiles = size(all_xy_pts, 1);
names_xy_pts = cell(1, n_xy_ptsFiles);

for j = 1: n_xy_ptsFiles
    names_xy_pts{j} = all_xy_pts(j).name;
end

%% Importing Variables
delimiter = ',';
startRow = 2;
%% Format string for each line of text:


% Some points will be nans where the point couldnt be detected - imp to
% preserve these points as entries
for j = 1: n_xy_ptsFiles
    
    
    names_xy_pts{j}
    filename = [DLTDv5Dir  names_xy_pts{j}];
    
    allFilenames{:,j} = names_xy_pts{j};
   
    delimiter = ',';

    %filename = 'F:\Grass\Tadpoles\5Tadpoles_Grp1\editedVids\DLTdv5_data_120pntsxypts.csv';
delimiter = ',';
startRow = 2;

%% Format for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
%   column7: double (%f)
%	column8: double (%f)
%   column9: double (%f)
%	column10: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

%% Close the text file.

%%
pt1_cam1_X = dataArray{:, 1};
pt1_cam1_Y = dataArray{:, 2};

pt2_cam1_X = dataArray{:, 3};
pt2_cam1_Y = dataArray{:, 4};

pt3_cam1_X = dataArray{:, 5};
pt3_cam1_Y = dataArray{:, 6};

pt4_cam1_X = dataArray{:, 7};
pt4_cam1_Y = dataArray{:, 8};

pt5_cam1_X = dataArray{:, 9};
pt5_cam1_Y = dataArray{:, 10};

nPointsInFile = sum(~isnan(pt1_cam1_X));
fclose(fileID);
%%
plot_filenameVid = 'F:\Grass\Tadpoles\5Tadpoles_Grp1\editedVids\5Tadpoles-1min.avi';
outputVideo = VideoWriter(plot_filenameVid);
outputVideo.FrameRate = 10 ;

vidPath = 'F:\Grass\Tadpoles\5Tadpoles_Grp1\editedVids\20190710_09-11_Tadpoles_20190710_00015_converted_converted_001.avi';
%% Start Recording Video
open(outputVideo);
fig101 = figure(101); clf

    
    disp('Loading Video, this make take a while...')    
    vidReaderObj = VideoReader(vidPath, 'Tag', 'VidReadObj');
    i =1;
    msize = 3;
    for f = 1:nPointsInFile
        
        img = read(vidReaderObj, f);
        
        image(img)
        
        vidHeight = vidReaderObj.Height;
        vidWidth = vidReaderObj.Width;
        
        %% Plot coordinates on figure
        
        
        hold on
        plot(pt1_cam1_X(f), (vidHeight-pt1_cam1_Y(f)), 'yo', 'MarkerSize', msize, 'MarkerFaceColor', 'y') % have to reverse y coordinates
        plot(pt1_cam1_X(f), (vidHeight-pt1_cam1_Y(f)), 'y') % have to reverse y coordinates
        
        plot(pt2_cam1_X(f), (vidHeight-pt2_cam1_Y(f)), 'go', 'MarkerSize', msize, 'MarkerFaceColor', 'g') % have to reverse y coordinates
        plot(pt2_cam1_X(f), (vidHeight-pt2_cam1_Y(f)), 'g') % have to reverse y coordinates
        %plot(pt2_cam1_X(f), (pt2_cam1_Y(f)), 'go', 'MarkerSize', msize, 'MarkerFaceColor', 'g') % have to reverse y coordinates
        %plot(pt2_cam1_X(f), (pt2_cam1_Y(f)), 'g') % have to reverse y coordinates
        
        plot(pt3_cam1_X(f), (vidHeight-pt3_cam1_Y(f)), 'bo', 'MarkerSize', msize, 'MarkerFaceColor', 'b') % have to reverse y coordinates
        plot(pt3_cam1_X(f), (vidHeight-pt3_cam1_Y(f)), 'b') % have to reverse y coordinates
        
        plot(pt4_cam1_X(f), (vidHeight-pt4_cam1_Y(f)), 'mo', 'MarkerSize', msize, 'MarkerFaceColor', 'm') % have to reverse y coordinates
        plot(pt4_cam1_X(f), (vidHeight-pt4_cam1_Y(f)), 'm') % have to reverse y coordinates
        
        plot(pt5_cam1_X(f), (vidHeight-pt5_cam1_Y(f)), 'ro', 'MarkerSize', msize, 'MarkerFaceColor', 'r') % have to reverse y coordinates
        plot(pt5_cam1_X(f), (vidHeight-pt5_cam1_Y(f)), 'r') % have to reverse y coordinates
        
        ylim([0 vidHeight])
        xlim([0 vidWidth])
        axis off
        
        F(i) = getframe(fig101);
        i = i+1;
        
        
    end


writeVideo(outputVideo, F);
close(outputVideo)
disp(['Saved file: ' plot_filenameVid]);

disp('')


%%
fig102 = figure(102);
  img = read(vidReaderObj, 1);
        
        image(img)
     hold on 
        
plot(pt1_cam1_X, (vidHeight-pt1_cam1_Y), 'y', 'linewidth', 2) % have to reverse y coordinates) % have to reverse y coordinates
plot(pt1_cam1_X, (vidHeight-pt1_cam1_Y), 'y*') % have to reverse y coordinates

plot(pt2_cam1_X, (vidHeight-pt2_cam1_Y), 'g', 'linewidth', 2) % have to reverse y coordinates) % have to reverse y coordinates
plot(pt2_cam1_X, (vidHeight-pt2_cam1_Y), 'g*') % have to reverse y coordinates

plot(pt3_cam1_X, (vidHeight-pt3_cam1_Y), 'b', 'linewidth', 2) % have to reverse y coordinates) % have to reverse y coordinates
plot(pt3_cam1_X, (vidHeight-pt3_cam1_Y), 'b*') % have to reverse y coordinates

plot(pt4_cam1_X, (vidHeight-pt4_cam1_Y), 'm', 'linewidth', 2) % have to reverse y coordinates) % have to reverse y coordinates
plot(pt4_cam1_X, (vidHeight-pt4_cam1_Y), 'm*') % have to reverse y coordinates

plot(pt5_cam1_X, (vidHeight-pt5_cam1_Y), 'r', 'linewidth', 2) % have to reverse y coordinates
plot(pt5_cam1_X, (vidHeight-pt5_cam1_Y), 'r*') % have to reverse y coordinates

ylim([0 vidHeight])
xlim([0 vidWidth])
axis off
        
        
       plot_filename = 'F:\Grass\Tadpoles\5Tadpoles_Grp1\editedVids\5Tadpoles-overview';
set(0, 'CurrentFigure', fig102)
export_to = set_export_file_format(4);
plotpos = [0 0 55 40];
print_in_A4(0, plot_filename, export_to, 0, plotpos); 

%%




% pix_1 = [p11,p12];
% pix_2 = [p21,p22];
% distance = sqrt( (p21-p11)^2 + (p22-p12)^2 );

for k = 1:5
    
    switch k
        
        case 1
            pt_X = pt1_cam1_X;
            pt_Y = pt1_cam1_Y;
            
        case 2
            pt_X = pt2_cam1_X;
            pt_Y = pt2_cam1_Y;
        case 3
            pt_X = pt3_cam1_X;
            pt_Y = pt3_cam1_Y;
        case 4
            pt_X = pt4_cam1_X;
            pt_Y = pt4_cam1_Y;
            
        case 5
            pt_X = pt5_cam1_X;
            pt_Y = pt5_cam1_Y;
            
    end
    distance = [];
for j = 1:nPointsInFile-1
    
  
    distance(j) = sqrt( (pt_X(j+1) - pt_X(j))^2 + (pt_Y(j+1) - pt_Y(j))^2);
    
    
end    
allDistnances(:,k) = distance;
end

%%
fig103 = figure(103); clf
cols = {'y', 'g', 'b', 'm', 'r'};
for  j =1 :5
subplot(5, 1, j)
plot(allDistnances(:, j), 'color', cols{j}, 'linewidth', 2)
ylim([0 150])
ylabel('Distance [px]')
end

xlabel('Frames')

plot_filename = 'F:\Grass\Tadpoles\5Tadpoles_Grp1\editedVids\5Tadpoles-distance';
set(0, 'CurrentFigure', fig103)
export_to = set_export_file_format(4);
plotpos = [0 0 25 15];
print_in_A4(0, plot_filename, export_to, 0, plotpos); 

end
