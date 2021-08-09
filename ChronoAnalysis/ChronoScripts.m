close all
clear all

pathToCodeRepository = 'C:\Users\Janie\Documents\GitHub\code2018\';
vidsToAnalyze = {'D:\SilkesData\VideosSPF\2021-Jul-29RFstillandafter6stavationPART2\faa2-001-cam2-2021-Jul-29.avi'};

%%
addpath(genpath(pathToCodeRepository)) 
videoDirectory=[];
C_OBJ = chronoAnalysis_Obj(vidsToAnalyze);

%% FFMPEG

%ffmpeg -i E:\DataForSilke\faa1-001-cam1-2019-Nov-14.AVI E:\DataForSilke\faa1-001-Imgs\thumb%06d.jpg -hide_banner
%https://stackoverflow.com/questions/10225403/how-can-i-extract-a-good-quality-jpeg-image-from-an-h264-video-file-with-ffmpeg
% ffmpeg -i E:\DataForSilke\OrigVideos\faa1-001-cam1-2019-Nov-14.AVI -qscale:v 2 E:\DataForSilke\faa_001_ffmpeg\thumb%06d.jpg -hide_banner


%% Make movies from images

 imageDir = {'D:\SilkesData\VideosSPF\2021-Jul-06adlib\FFMPEG_faa3-001-cam1-2021-Jul-08adlibgood\'};
 movieName = 'faa3-001-cam1-2021-Jul-08adlibgood';
 saveDir = {'D:\SilkesData\VideosSPF\2021-Jul-06adlib\editedVids\'};

 VideoFrameRate = 1;
 makeMultipleMoviesFromImages(C_OBJ, imageDir, movieName, saveDir, VideoFrameRate)
 
 disp('Finished making movies...')

%     switch fileFormat
%                 case 1
%                     imgFormat = '*.tiff';
%                 case 2
%                     imgFormat = '*.jpg';
%                     
%                 case 3
%                     imgFormat = '*';
%             end
 %% calc OF on multiple vidoes
 
 vidDir = 'D:\SilkesData\VideosSPF\2021-Jul-06adlib\editedVids\cam1\';
 dsFrameRate = 1;
 vidFrameRate = 1;
 saveTag = '_mouse340';
 
 calcOFOnDefinedRegion_DS_multipleFilesInDir(C_OBJ, dsFrameRate, vidDir, vidFrameRate, saveTag)
 
 %%
 
StartingAlignmentTime  = '13:00:00'; % Must be the next even time
StartingClockTime = '12:06:35'; % Must be the next even time

% StartingAlignmentTime  = '16:00:00'; % Must be the next even time
% StartingClockTime = '15:49:49'; % Must be the next even time

detectionsDir = 'D:\SilkesData\VideosSPF\2021-Jul-29RFstillandafter6stavationPART2\editedVideos\cam2\mouse339\';
VidTag  = 'Mouse-339';
dsFrameRate = 1;
loadOFDetectionsAndMakePlot(C_OBJ, detectionsDir, dsFrameRate, StartingClockTime, StartingAlignmentTime, VidTag)
 
%%

OFPath = ['/media/janie/DataRed1TB/chronoAnalysis/001_Vids/OF_DS/ROI-1_OF_DSs1_fullFile.mat'];

extractMvmtFromOF(C_OBJ, OFPath)
            
%%
%OFPath = ['E:\ChronoAnalysis\001_Vids_Nov14\contrastVids\OF_DS\ROI-1_OF_DSs1_fullFile.mat'];
%OFPath = ['E:\ChronoAnalysis\001_Vids_Nov14\contrastVids\OF_DS\ROI-2_OF_DSs1_fullFile.mat'];
%OFPath = ['E:\ChronoAnalysis\001_Vids_Nov14\contrastVids\OF_DS\ROI-3_OF_DSs1_fullFile.mat'];

%OFPath = ['E:\ChronoAnalysis\002_Vids_Nov19\ContrastVids\OF_Analysis\ROI-1_OF_DSs1_fullFile.mat'];
%OFPath = ['E:\ChronoAnalysis\002_Vids_Nov19\ContrastVids\OF_Analysis\ROI-2_OF_DSs1_fullFile.mat'];
OFPath = ['D:\SilkesData\VideosSPF\2021-Jul-29RFstillandafter6stavationPART2\OF_Analysis\faa2-001-cam2-2021-Jul-29_Mouse-338_OF_DSs1_fullFile.mat'];
SaveTag = 'Mouse-338';
extractMvmtFromOF_separateParts(C_OBJ, OFPath, SaveTag)

%close all
 