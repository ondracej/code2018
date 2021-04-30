
%% This code needs to be run in Matalb 2014b!! 

%% 1. Initialize the analysis code

pathToCodeRepository = 'C:\Users\Janie\Documents\GitHub\code2018\';
vidsToAnalyze = {'D:\BeforeStarvation\Jul2\faa1-002-cam1-2020-Jul-02.avi'};

addpath(genpath(pathToCodeRepository)) 
videoDirectory=[];
C_OBJ = chronoAnalysis_Obj(vidsToAnalyze);

%% 2. Make several contrast-adjusted videos from images

imageDir = {'D:\BeforeStarvation\Jul2\faa1-002-cam1-2020-Jul-02_ffmpeg\'};
movieName = 'faa1-002-cam1-2020-Jul-02_contrast';
saveDir = {'D:\BeforeStarvation\Jul2\Vids_faa1-002-cam1-2020-Jul-02\'};

 VideoFrameRate = 1;
 makeMultipleMoviesFromImages(C_OBJ, imageDir, movieName, saveDir, VideoFrameRate)
 
 disp('Finished making movies...')

 %% 3. Calculate Optic Flow on multiple videos
 
 vidDir = 'D:\BeforeStarvation\Jul2\Vids_faa1-002-cam1-2020-Jul-02\';

 saveTag = '_ROI-6';
 
 dsFrameRate = 1;
 vidFrameRate = 1;
 calcOFOnDefinedRegion_DS_multipleFilesInDir(C_OBJ, dsFrameRate, vidDir, vidFrameRate, saveTag)
 
 %% 4. Calculate the real starting time of the video
 
 origCamStart = '12:09:22';
 frameStart = 1;
 
StartingClockTime = calcStartTimeFrommFrameNumber(origCamStart, frameStart);

StartingClockTime  

 %% 5. Make the plots for each of the combined OF calculations
 
StartingAlignmentTime  = '13:00:00'; % Must be the next even time
%StartingClockTime = '17:47:50'; % Must be the next even time

detectionsDir = 'D:\BeforeStarvation\Jul2\Vids_faa1-002-cam1-2020-Jul-02\ROI-6\';
VidTag  = 'ROI-6';
dsFrameRate = 1;
loadOFDetectionsAndMakePlot(C_OBJ, detectionsDir, dsFrameRate, StartingClockTime, StartingAlignmentTime, VidTag)
 
%% 6: Extract the movement detections from the OF flow in 6 min bins

OFPath = ['D:\BeforeStarvation\Jul2\OF_Analysis\faa1-002-cam1-2020-Jul-02_ROI-6_OF_DSs1_fullFile.mat'];
figSaveDir = ['D:\BeforeStarvation\Jul2\OF_Analysis\DetectionFigs\'];

%extractMvmtFromOF(OFPath, figSaveDir)
            
extractMvmtFromOF_separateParts(C_OBJ, OFPath, figSaveDir)


 