close all
clear all

%pathToCodeRepository = 'C:\Users\Janie\Documents\GitHub\code2018\';
pathToCodeRepository = '/home/janie/Documents/code/code2018/';

addpath(genpath(pathToCodeRepository)) 


%vidsToAnalyze = {'E:\chronoAnalysis\OrigVideos\faa1-001-cam1-2019-Nov-14.avi'};
vidsToAnalyze = {'/media/janie/DataRed1TB/chronoAnalysis/OrigVideos/faa1-001-cam1-2019-Nov-14.avi'};

videoDirectory=[];

C_OBJ = chronoAnalysis_Obj(vidsToAnalyze);


%% FFMPEG

%ffmpeg -i E:\DataForSilke\faa1-001-cam1-2019-Nov-14.AVI E:\DataForSilke\faa1-001-Imgs\thumb%06d.jpg -hide_banner
%https://stackoverflow.com/questions/10225403/how-can-i-extract-a-good-quality-jpeg-image-from-an-h264-video-file-with-ffmpeg
% ffmpeg -i E:\DataForSilke\OrigVideos\faa1-001-cam1-2019-Nov-14.AVI -qscale:v 2 E:\DataForSilke\faa_001_ffmpeg\thumb%06d.jpg -hide_banner


%% Make movies from images

 imageDir = {'E:\chronoAnalysis\ffmpeg_002\'};
 movieName = 'faa1-002-Nov14';
 saveDir = {'E:\chronoAnalysis\002_Vids\'};

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
 
 vidDir = 'E:\chronoAnalysis\001_Vids\';
 dsFrameRate = 1;
 vidFrameRate = 1;
 saveTag = '_ROI-3';
 
 calcOFOnDefinedRegion_DS_multipleFilesInDir(C_OBJ, dsFrameRate, vidDir, vidFrameRate, saveTag)
 
 %%
 
StartingAlignmentTime  = '18:00:00'; % Must be the next even time
StartingClockTime = '17:47:50'; % Must be the next even time
detectionsDir = 'E:\chronoAnalysis\001_Vids\ROI-3\';
VidTag  = 'ROI-3';
dsFrameRate = 1;
loadOFDetectionsAndMakePlot(C_OBJ, detectionsDir, dsFrameRate, StartingClockTime, StartingAlignmentTime, VidTag)
 
%%

OFPath = ['/media/janie/DataRed1TB/chronoAnalysis/001_Vids/OF_DS/ROI-1_OF_DSs1_fullFile.mat'];

extractMvmtFromOF(C_OBJ, OFPath)
            
%%
%OFPath = ['/media/janie/DataRed1TB/chronoAnalysis/001_Vids/OF_DS/ROI-1_OF_DSs1_fullFile.mat'];
%OFPath = ['/media/janie/DataRed1TB/chronoAnalysis/001_Vids/OF_DS/ROI-2_OF_DSs1_fullFile.mat'];
OFPath = ['/media/janie/DataRed1TB/chronoAnalysis/001_Vids/OF_DS/ROI-3_OF_DSs1_fullFile.mat'];
extractMvmtFromOF_separateParts(C_OBJ, OFPath)


 