%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%% This code needs to be run in Matalb 2014b!! %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Run each cell by pressing cntrl + enter
% Make sure that there is a '\' at the end of path entries, eg, C:\Users\Neuropix\Documents\GitHub\code2018\

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1. Initialize the analysis code (cntrl + enter)

pathToCodeRepository = 'C:\Users\Neuropix\Documents\GitHub\code2018\'; %Enter the directory where the matalb analysis code is located
vidsToAnalyze = {'3Tadpoles_20190802_11-20_001.avi'}; % Enter the path to the original video to analyze

% -------------------------------------------------------------------------------------------------------------------
addpath(genpath(pathToCodeRepository)) % adds the code to the matlab path 
%videoDirectory=[];
C_OBJ = chronoAnalysis_Obj(vidsToAnalyze); % creates a matlab object C_OBJ for the video analysis 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2. Make several contrast-adjusted or rotated videos from images created via ffmpeg
% make sure that the FFMPEG image directory only contains the images that
% you want to be included in the analysis video - move all other images not to
% be used into a "DoNotUse" directory

imageDir = {'Z:\JanieData\Tadpoles\3Tadpoles_perturbation\3Tadpoles_20190802_21-03\Raw\'}; % The path to the ffmpeg raw image directory

movieName = '3Tadpoles_20190802_11-20'; % enter a description of the video name and edits, eg "faa3-001-cam1-2021-Jul-08_contrast-rotated"
saveDir = {'Z:\JanieData\Tadpoles\3Tadpoles_perturbation\3Tadpoles_20190802_11-20-edited\'}; % the path to the directory where the newly created, contrast-enhanced videos will be saved, eg "editedVideos"

% if the movie needs to be rotated so that the box you will draw around the
% ROI is straight, make sure to change the variable "doRotate" to 1,
% otherwise leave it as a 0

doRotate = 0; % change to 1 if you want to rotate the images for the video, otherwise leave as a 0
rotationAngle = 0; % the amount in degrees that you want to rotate the image, eg, -5 or 7, otherwise leave as a 0

% 
%-------------------------------------------------------------------------------------------------------------------
 disp('Running code to make enhanced movies...')
 VideoFrameRate = 1; % 1 frame per second
 makeMultipleMoviesFromImages(C_OBJ, imageDir, movieName, saveDir, VideoFrameRate, doRotate, rotationAngle) % runs to the code to load the images and makes a new video
 disp('Finished making movies...')
 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %% 3. Define a ROI and calculate Optic Flow on enhanced videos
 % here you will analyze the same video several times, each time drawing a different ROI square around a different mouse
 
 vidDir = 'H:\SilkesData\VideosSPF\2021-Jul-06adlib\editedVids\cam1\'; % Directory where the contrast-adjusted videos are from step 2
 saveTag = '_mouse-topleft'; % the name of the mouse or ROI description - a directory with this name will be created where the detections will be saved
 
 %
 %-------------------------------------------------------------------------------------------------------------------
 dsFrameRate = 1;
 vidFrameRate = 1;
 calcOFOnDefinedRegion_DS_multipleFilesInDir(C_OBJ, dsFrameRate, vidDir, vidFrameRate, saveTag)
 
 %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %% 4. Calculate the real starting time for the video and make the OF plots
 % From the "VideoInfo.txt" file that was made when the original videos
 % were saved, enter the time that the original video was started

StartingClockTime = '10:23:28'; % The original time that the video was started
StartingAlignmentTime  = '11:00:00'; % Now round up the original time to the next even hour

detectionsDir = 'H:\SilkesData\VideosSPF\2021-Jul-06adlib\editedVids\cam1\mouse336\'; % Directory containing the .mat files from step 3
VidTag  = 'Mouse-339'; % This is the name of the video tag for the figures that will be made 

% 
%-------------------------------------------------------------------------------------------------------------------
dsFrameRate = 1;
loadOFDetectionsAndMakePlot(C_OBJ, detectionsDir, dsFrameRate, StartingClockTime, StartingAlignmentTime, VidTag)
 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5: Extract the movement detections from the OF flow in 6 min bins
% Here you must first define how many segments are in the entire OF plot -
% these are the changes that happen due to changes in lighting conditons

%mvmtArtifacts = [3, 5:10000, 3000];
mvmtArtifacts = [];

OFPath = ['H:\SilkesData\VideosSPF\2021-Jul-06adlib\OF_Analysis\faa3-001-cam1-2021-Jul-08adlibgood_Mouse-340_OF_DSs1_fullFile.mat']; %path to the mat "fullFile.mat" 
figSaveDir = ['H:\SilkesData\VideosSPF\2021-Jul-06adlib\OF_Analysis\test\']; % Path to directory where you want to save the figures

% 
%-------------------------------------------------------------------------------------------------------------------            
extractMvmtFromOF_separateParts(C_OBJ, OFPath, figSaveDir, mvmtArtifacts)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 