
%% This code needs to be run in Matalb 2014b!! 

%% 1. Initialize the analysis code

pathToCodeRepository = 'C:\Users\Janie\Documents\GitHub\code2018\'; %Enter the code directory
vidsToAnalyze = {'E:\SilkesData\VideosSPF\2021-Jul-06adlib\faa3-001-cam1-2021-Jul-08adlibgood.avi'}; % Video to analyze

addpath(genpath(pathToCodeRepository)) 
videoDirectory=[];
C_OBJ = chronoAnalysis_Obj(vidsToAnalyze);

%% 2. Make several contrast-adjusted videos from images

imageDir = {'E:\SilkesData\VideosSPF\2021-Jul-06adlib\FFMPEG_faa3-001-cam1-2021-Jul-08adlibgood\'}; % The image directory
movieName = 'faa3-001-cam1-2021-Jul-08adlibgood_contrast-rotated'; % name of the video file to be made
saveDir = {'E:\SilkesData\testVideos\'}; %where I save the videos

%
 VideoFrameRate = 1; % 1 frame per second
 makeMultipleMoviesFromImages(C_OBJ, imageDir, movieName, saveDir, VideoFrameRate)
 
 disp('Finished making movies...')

 %% 3. Calculate Optic Flow on multiple videos
 
 vidDir = 'E:\SilkesData\VideosSPF\2021-Jul-19RFtwodays\editedVids\cam1\test\'; % Directory where the contrast-adjusteds are, see step 2
 saveTag = '_mouse-topleft'; % then name of the mouse or ROI
 
 dsFrameRate = 1;
 vidFrameRate = 1;
 calcOFOnDefinedRegion_DS_multipleFilesInDir(C_OBJ, dsFrameRate, vidDir, vidFrameRate, saveTag)
 %calcOFOnDefinedRegion_DS_multipleFilesInDir(C_OBJ, dsFrameRate, vidDir, vidFrameRate, saveTag)
 
 %% 4. Calculate the real starting time of the video
 
StartingAlignmentTime  = '11:00:00'; % Must be the next even time
StartingClockTime = '10:23:28'; % Must be the next even time

detectionsDir = 'E:\SilkesData\VideosSPF\2021-Jul-19RFtwodays\editedVids\cam1\mouse340\'; % Detection for the particular ROI
VidTag  = 'Mouse-339';
dsFrameRate = 1;
loadOFDetectionsAndMakePlot(C_OBJ, detectionsDir, dsFrameRate, StartingClockTime, StartingAlignmentTime, VidTag)

 %% 5. Make the plots for each of the combined OF calculations
 
StartingAlignmentTime  = '13:00:00'; % Must be the next even time
%StartingClockTime = '17:47:50'; % Must be the next even time

detectionsDir = 'D:\BeforeStarvation\Jul2\Vids_faa1-002-cam1-2020-Jul-02\ROI-6\';
VidTag  = 'ROI-6';
dsFrameRate = 1;
loadOFDetectionsAndMakePlot(C_OBJ, detectionsDir, dsFrameRate, StartingClockTime, StartingAlignmentTime, VidTag)
 
%% 6: Extract the movement detections from the OF flow in 6 min bins

OFPath = ['E:\SilkesData\VideosSPF\2021-Jul-19RFtwodays\OF_Analysis\faa2-001-cam1-2021-Jul-19_Mouse-336_OF_DSs1_fullFile.mat'];
figSaveDir = ['E:\SilkesData\VideosSPF\2021-Jul-19RFtwodays\OF_Analysis\tempFolder\'];

%extractMvmtFromOF(OFPath, figSaveDir)
            
extractMvmtFromOF_separateParts(C_OBJ, OFPath, figSaveDir)


 