
close all
clear all



%%

vid=VideoReader('D:\faa3-001-cam1-2020-Jul-12_complete.avi');
  numFrames = vid.NumberOfFrames;
  n=numFrames;
  
Folder = 'D:\test2\';
for iFrame = 1:nn
  frames = read(vid, iFrame);
  imwrite(frames, fullfile(Folder, sprintf('%06d.jpg', iFrame)));
end 
FileList = dir(fullfile(Folder, '*.jpg'));
for iFile = 1:length(FileList)
  aFile = fullfile(Folder, FileList(iFile).name);
  img   = imread(aFile);
end

%%

pathToCodeRepository = 'C:\Users\Janie\Documents\GitHub\code2018\';
addpath(genpath(pathToCodeRepository)) 
%%
% Hunting
%vidsToAnalyze = {'F:\Grass\eBUSData\20190619\20190619_16-22\Cricket2a.avi'; 'F:\Grass\eBUSData\20190619\20190619_16-22\Cricket2b.avi'};

% Eyes
%vidsToAnalyze = {'F:\Grass\eBUSData\20190619\20190619_17-09\00000000_000000000073561F.mp4'};

%OF June 19 Night
%vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190619\20190619_22-58\Videos\00000000_0000000001B2CF95.mp4'};

%OF June 20
%vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190620\20190620_21-27\Videos\00000000_0000000006858C4C.mp4'};
%vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190620\20190620_21-27\Videos\00000000_000000000685891F.mp4'};

%OF June 22
%vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190622\20190622_21-03\Videos\00000000_0000000005DC07D0.mp4'};

%OF June 23
%vidsToAnalyze = {'F:\Grass\DLC\FrogTest21-27-Janie-2019-06-23\videos\00000000_0000000006858C4C.mp4'};
%vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190623\20190623_17-40\Videos\00000000_000000000A488A2D.mp4'};

%Day June 24
%vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190624\20190624_16-31\Videos\00000000_000000000F30B595.mp4'};
%vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190624\20190624_16-31\Videos\editedVids\Short4.avi'};

% Night June 24
%vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190624\20190624_23-36\Videos\00000000_0000000010B52E6F.mp4'};

% OF Day June 25
%vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190625\20190625_08-32\Videos\00000000_0000000012A005F3.mp4'};

% OF June 27 (night of June 26)
%vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190627\20190626_01-09\Videos\00000000_000000001B56F6BD.mp4'};

% OF June 27 (night of June 26)
%vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190627\20190627_22-00\Videos\00000000_000000001FD04D58.mp4'};

% Daytime June 27
%vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190627\20190627_08-43\Videos\00000000_000000001CF69992.mp4'};

% Daytime June 26
%vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190626\20190626_09-00\Videos\00000000_0000000017DFD3CE.mp4'};

% Day June 28
%vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190628\20190628_10-01\Videos\00000000_0000000022649534.mp4'};
% Night June 28
%vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190628\20190628_20-44\Videos\00000000_0000000024B13A90.mp4'};

% Day June 29
%vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190629\20190629_11-35\Videos\00000000_0000000027E11AA3.mp4'};

% Night June 29
%vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190629\20190629_21-28\Videos\00000000_000000002A004FFA.mp4'};

% Night June 30
%vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190630\20190630_16-39\Videos\00000000_000000002E1D931C.mp4'};

% Day July 1
%vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190701\20190701_09-21\Videos\00000000_0000000031B35A96.mp4'};

% Night July 1
%vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190701\20190701_21-35\Videos\00000000_0000000034535AF0.mp4'};

% Night July 2
%vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190702\20190702_17-03\Videos\00000000_000000003880EE37.mp4'};

% Night July 3
%vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190703\20190703_19-04\Videos\00000000_000000003E1516EB.mp4'};

% 24 Hrs July 4
%vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190704\20190704_09-13\Videos\00000000_00000000411EAADB.mp4'};

%vidsToAnalyze = {'D:\TUM\SWR-Project\ZF-71-76\20190919\17-51-46\Videos\ZF-71-76__17-51-54__547923_Zoom2_00011.avi'};


%%
V_OBJ = testVideos(V_OBJ);
 
%%

loadTwoVidsMakePlaybackVideo(V_OBJ)

%%

renameFilesinDir(V_OBJ)


%%

close all
clear all

vidDir = 'C:\Users\Janie\Documents\Data\2box-hor\2012.06.22-E09\';
vidsToAnalyze = {'Video 981.wmv', 'Video 982.wmv', 'Video 983.wmv', 'Video 984.wmv', 'Video 985.wmv', 'Video 986.wmv', 'Video 987.wmv', 'Video 988.wmv', 'Video 989.wmv', 'Video 990.wmv', 'Video 991.wmv'};

allStartsStops = [62 1740; 94 2730; 50 3797;  68 4913; 110 1935; 66 5280; 37 3204; 44 4515; 66 1245; 64 7815; 52 33030];

nVids = numel(vidsToAnalyze);
period = '.';

%
for j = 11:nVids
    V_OBJ = videoAnalysis_OBJ({[vidDir vidsToAnalyze{j}]});
    
    theseStartsStops = allStartsStops(j,:);
    
    startFrame = allStartsStops(j,1);
    endFrame = allStartsStops(j,2);
    FrameRateOverride = 30;
    
    bla = find(vidsToAnalyze{j} == period);
    
    videoNameNumber = vidsToAnalyze{j}(7:bla-1);
    %videoName = 'Video984_cut.avi';
    videoName = ['Video_' videoNameNumber '_cut.avi'];
    
    convertWMVToAVI(V_OBJ, startFrame, endFrame, videoName, FrameRateOverride )
    %convertWMVToAVI(V_OBJ, startFrame, endFrame, videoName)
    disp(['Finished' num2str(j) '/' num2str(nVids)])
    
end

 %% Loading and downsampling a movie
 
 doDS = 1;
 dsFrameRate = 30;
 FrameRateOverride = 30;
 startFrame = 18000;
 endFrame = 26854;
 
 convert_and_compress_video_files(V_OBJ, FrameRateOverride, doDS, dsFrameRate, startFrame,endFrame)
 
 %%
 imageDir = {'E:\imgs\'};
 movieName = 'grogBuccal';
 saveDir = {'E:\'};
 makeMoviesFromImages(V_OBJ, imageDir, movieName, saveDir)
 
 %%
 
 imageDir = {'E:\DataForSilke\faa1_002imgs\'};
 movieName = 'faa1-002-Nov14_Imgs';
 saveDir = {'E:\DataForSilke\faa1_002_Video\'};
 VideoFrameRate = 1;
 makeMultipleMoviesFromImages(V_OBJ, imageDir, movieName, saveDir, VideoFrameRate)
 
 disp('Finished making movies...')
 %% make one movie from two sets of video images
 fileFormat = 2;  % (1)- tif, (2) -.jpg
 ImgDirs = {'F:\Grass\eBUSData\20190619\20190619_16-22\Cricket2a', 'F:\Grass\eBUSData\20190619\20190619_16-22\Cricket2b'};
 makeMovieFromImages_2Videos(V_OBJ, ImgDirs, fileFormat)
 
 %%
 createMontageFromVideo(V_OBJ)
 
 %%
   V_OBJ = videoAnalysis_OBJ({['E:\frog-buccalpumping-2.avi']});
    
   
   
 fileFormat = 2;  % (1)- tif, (2) -.jpg
 ImgDir = {'H:\Grass\FrogSleep\CubanTreeFrog1\20190619\20190619_17-09\Videos\editedVids\Eyes\'};
 cropImageCreateMontage(V_OBJ, ImgDir, fileFormat)

 %%
 startFrame = 120;
 endFrame = (60*60*60)/2;
 clockRate_s = 10*30;
 makeFastMoviesWithClock(V_OBJ, startFrame, endFrame, clockRate_s)
 %%
 
vidToAnalyze = 'E:\frogBuccal.avi';

  V_OBJ = videoAnalysis_OBJ({vidToAnalyze});
   
 

 
 calcOFOnDefinedRegion(V_OBJ)
 
 %% Downsampled OF claclulation, 30 fps
 
 V_OBJ = testVideos(V_OBJ);
 
 dsFrameRate = 1;
 FrameRateOverride = 1;
 
 calcOFOnDefinedRegion_DS(V_OBJ, dsFrameRate, FrameRateOverride)
 
 disp('Finished calculating OF...')
 close all
 
 %%
 
 vidDir = 'E:\DataForSilke\faa1_001_Video\';
 dsFrameRate = 1;
 vidFrameRate = 1;
 saveTag = '_ROI-3';
 
 calcOFOnDefinedRegion_DS_multipleFilesInDir(V_OBJ, dsFrameRate, vidDir, vidFrameRate, saveTag)
 

 %% Plotting detections

 %detectionsDir = 'F:\Grass\FrogSleep\CubanTreeFrog1\20190620\20190620_21-27\Videos\editedVids\OF_DS-00000000_000000000685891F\'; 
 %detectionsDir = 'F:\Grass\FrogSleep\CubanTreeFrog1\20190622\20190622_21-03\Videos\editedVids\OF_DS-00000000_0000000005DC07D0\'; 
 %detectionsDir = 'F:\Grass\FrogSleep\CubanTreeFrog1\20190623\20190623_17-40\Videos\editedVids\OF_DS-00000000_000000000A488A2D\';
 
 %detectionsDir = 'F:\Grass\FrogSleep\CubanTreeFrog1\20190624\20190624_23-36\Videos\editedVids\OF_DS-00000000_0000000010B52E6F\';

%  vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190619\20190619_22-58\Videos\00000000_0000000001B2CF95.mp4'};
%  detectionsDir = 'F:\Grass\FrogSleep\CubanTreeFrog1\20190619\20190619_22-58\Videos\editedVids\OF_DS-00000000_0000000001B2CF95\';
%  StartingAlignmentTime  = '23:00:00'; % Must be the next even time
%  StartingClockTime = '22:58:00'; % Must be the next even time
 
% vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190620\20190620_21-27\Videos\00000000_000000000685891F.mp4'};
% detectionsDir = 'F:\Grass\FrogSleep\CubanTreeFrog1\20190620\20190620_21-27\Videos\editedVids\OF_DS-00000000_000000000685891F\';
% StartingAlignmentTime  = '22:00:00'; % Must be the next even time
% StartingClockTime = '21:27:00'; % Must be the next even time
 
%  vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190622\20190622_21-03\Videos\00000000_0000000005DC07D0.mp4'};
%  detectionsDir = 'F:\Grass\FrogSleep\CubanTreeFrog1\20190622\20190622_21-03\Videos\editedVids\OF_DS-00000000_0000000005DC07D0\';
%  StartingAlignmentTime  = '23:00:00'; % Must be the next even time
%  StartingClockTime = '21:03:00'; % Must be the next even time
 
%   vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190623\20190623_17-40\Videos\00000000_000000000A488A2D.mp4'};
%   detectionsDir = 'F:\Grass\FrogSleep\CubanTreeFrog1\20190623\20190623_17-40\Videos\editedVids\OF_DS-00000000_000000000A488A2D\';
%   StartingAlignmentTime  = '18:00:00'; % Must be the next even time
%   StartingClockTime = '17:40:00'; % Must be the next even time

%   vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190624\20190624_23-36\Videos\00000000_0000000010B52E6F.mp4'};
%   detectionsDir = 'F:\Grass\FrogSleep\CubanTreeFrog1\20190624\20190624_23-36\Videos\editedVids\OF_DS-00000000_0000000010B52E6F\';
%   StartingAlignmentTime  = '24:00:00'; % Must be the next even time
%   StartingClockTime = '23:36:00'; % Must be the next even time
  
%  vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190627\20190626_01-09\Videos\00000000_000000001B56F6BD.mp4'};
%   detectionsDir = 'F:\Grass\FrogSleep\CubanTreeFrog1\20190627\20190626_01-09\Videos\editedVids\OF_DS-00000000_000000001B56F6BD\';
%   StartingAlignmentTime  = '02:00:00'; % Must be the next even time
%   StartingClockTime = '01:09:00'; % Must be the next even time

%   vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190627\20190627_22-00\Videos\00000000_000000001FD04D58.mp4'};
%   detectionsDir = 'F:\Grass\FrogSleep\CubanTreeFrog1\20190627\20190627_22-00\Videos\editedVids\OF_DS-00000000_000000001FD04D58\';
%   StartingAlignmentTime  = '22:00:00'; % Must be the next even time
%   StartingClockTime = '22:00:00'; % Must be the next even time

%   vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190628\20190628_20-44\Videos\00000000_0000000024B13A90.mp4'};
%   detectionsDir = 'F:\Grass\FrogSleep\CubanTreeFrog1\20190628\20190628_20-44\Videos\editedVids\OF_DS-00000000_0000000024B13A90\';
%   StartingAlignmentTime  = '21:00:00'; % Must be the next even time
%   StartingClockTime = '20:44:00'; % Must be the next even time
  
%   vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190629\20190629_11-35\Videos\00000000_0000000027E11AA3.mp4'};
%   detectionsDir = 'F:\Grass\FrogSleep\CubanTreeFrog1\20190629\20190629_11-35\Videos\editedVids\OF_DS-00000000_0000000027E11AA3\';
%   StartingAlignmentTime  = '12:00:00'; % Must be the next even time
%   StartingClockTime = '11:35:00'; % Must be the next even time

%   vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190629\20190629_21-28\Videos\00000000_000000002A004FFA.mp4'};
%   detectionsDir = 'F:\Grass\FrogSleep\CubanTreeFrog1\20190629\20190629_21-28\Videos\editedVids\OF_DS-00000000_000000002A004FFA\';
%   StartingAlignmentTime  = '22:00:00'; % Must be the next even time
%   StartingClockTime = '21:28:00'; % Must be the next even time
%   
%   vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190701\20190701_09-21\Videos\00000000_0000000031B35A96.mp4'};
%   detectionsDir = 'F:\Grass\FrogSleep\CubanTreeFrog1\20190701\20190701_09-21\Videos\editedVids\OF_DS-00000000_0000000031B35A96\';
%   StartingAlignmentTime  = '10:00:00'; % Must be the next even time
%   StartingClockTime = '09:21:00'; % Must be the next even time
%   
%   vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190701\20190701_21-35\Videos\00000000_0000000034535AF0.mp4'};
%   detectionsDir = 'F:\Grass\FrogSleep\CubanTreeFrog1\20190701\20190701_21-35\Videos\editedVids\OF_DS-00000000_0000000034535AF0\';
%   StartingAlignmentTime  = '22:00:00'; % Must be the next even time
%   StartingClockTime = '21:35:00'; % Must be the next even time

% vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190703\20190703_19-04\Videos\00000000_000000003E1516EB.mp4'};
% detectionsDir = 'F:\Grass\FrogSleep\CubanTreeFrog1\20190703\20190703_19-04\Videos\editedVids\OF_DS-00000000_000000003E1516EB\';
% StartingAlignmentTime  = '18:00:00'; % Must be the next even time
% StartingClockTime = '19:04:00'; % Must be the next even time

% vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190704\20190704_09-13\Videos\00000000_00000000411EAADB.mp4'};
% detectionsDir = 'F:\Grass\FrogSleep\CubanTreeFrog1\20190704\20190704_09-13\Videos\editedVids\OF_DS-00000000_00000000411EAADB\';
% StartingAlignmentTime  = '10:00:00'; % Must be the next even time
% StartingClockTime = '09:13:00'; % Must be the next even time

% vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190625\20190625_08-32\Videos\00000000_0000000012A005F3.mp4'};
% detectionsDir = 'F:\Grass\FrogSleep\CubanTreeFrog1\20190625\20190625_08-32\Videos\editedVids\OF_DS-00000000_0000000012A005F3\';
% StartingAlignmentTime  = '09:00:00'; % Must be the next even time
% StartingClockTime = '08:32:00'; % Must be the next even time

% vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190626\20190626_09-00\Videos\00000000_0000000017DFD3CE.mp4'};
% detectionsDir = 'F:\Grass\FrogSleep\CubanTreeFrog1\20190626\20190626_09-00\Videos\editedVids\OF_DS-00000000_0000000017DFD3CE\';
% StartingAlignmentTime  = '09:00:00'; % Must be the next even time
% StartingClockTime = '09:00:00'; % Must be the next even time

% vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190627\20190627_08-43\Videos\00000000_000000001CF69992.mp4'};
% detectionsDir = 'F:\Grass\FrogSleep\CubanTreeFrog1\20190627\20190627_08-43\Videos\editedVids\OF_DS-00000000_000000001CF69992\';
% StartingAlignmentTime  = '09:00:00'; % Must be the next even time
% StartingClockTime = '08:43:00'; % Must be the next even time

% vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190628\20190628_10-01\Videos\00000000_0000000022649534.mp4'};
% detectionsDir = 'F:\Grass\FrogSleep\CubanTreeFrog1\20190628\20190628_10-01\Videos\editedVids\OF_DS-00000000_0000000022649534\';
% StartingAlignmentTime  = '11:00:00'; % Must be the next even time
% StartingClockTime = '10:01:00'; % Must be the next even time

% vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190630\20190630_16-39\Videos\00000000_000000002E1D931C.mp4'};
% detectionsDir = 'F:\Grass\FrogSleep\CubanTreeFrog1\20190630\20190630_16-39\Videos\editedVids\OF_DS-00000000_000000002E1D931C\';
% StartingAlignmentTime  = '17:00:00'; % Must be the next even time
% StartingClockTime = '16:39:00'; % Must be the next even time

% vidsToAnalyze = {'F:\Grass\FrogSleep\CubanTreeFrog1\20190702\20190702_17-03\Videos\00000000_000000003880EE37.mp4'};
% detectionsDir = 'F:\Grass\FrogSleep\CubanTreeFrog1\20190702\20190702_17-03\Videos\editedVids\OF_DS-00000000_000000003880EE37\';
% StartingAlignmentTime  = '18:00:00'; % Must be the next even time
% StartingClockTime = '17:03:00'; % Must be the next even time


vidsToAnalyze = {'C:\Users\Janie\Documents\Data\Video\18_02_2020_ROI.avi'};
detectionsDir = 'C:\Users\Janie\Documents\Data\Video\editedVids\OF_DS-18_02_2020_ROI\';
StartingAlignmentTime  = '04:00:00'; % Must be the next even time
StartingClockTime = '15:34:50'; % Must be the next even time


dsFrameRate = 1;
V_OBJ = videoAnalysis_OBJ(vidsToAnalyze);
loadOFDetectionsAndMakePlot(V_OBJ, detectionsDir, dsFrameRate, StartingClockTime, StartingAlignmentTime)

  

 %% Load multiple detections and compare
 
 
 detectionsDir = {'E:\DataForSilke\faa1_001_Video\Roi1\OF_DSOF-faa1-001-Nov14_Imgs_004_ROI-1.mat';
                  'E:\DataForSilke\faa1_001_Video\Roi1\OF_DSOF-faa1-001-Nov14_Imgs_005_ROI-1.mat'}; 
 dsFrameRate = 10;
 StartingAlignmentTime  = '16:00:00'; % Must be the next even time
 StartingClockTime = '15:34:50'; % Must be the next even time
 
 loadMultipleOFDetectionsAndMakePlot(V_OBJ, detectionsDir, dsFrameRate, StartingClockTime, StartingAlignmentTime)
 
 %%
 
 
OFdir = 'F:\Grass\FrogSleep\OFNights\';
% OFdir = 'F:\Grass\FrogSleep\OFDays\';
 dsFrameRate = 1;
 loadDetectionsAcrossDaysAndMakePlots(V_OBJ, OFdir, dsFrameRate)
 
 %%
  
OFdir = 'F:\Grass\FrogSleep\OFNights\';
% OFdir = 'F:\Grass\FrogSleep\OFDays\';
 dsFrameRate = 1;

 loadDetectionsCalcMvmtAcrossDaysAndMakePlots(V_OBJ, OFdir, dsFrameRate)
 
 
 %%
 
 calcOFandMakeVideo_2ROIs(V_OBJ)
 disp('Finished...')
 
 %%
 calcOFandMakeVideo_1ROIs(V_OBJ)
 
 
 %%