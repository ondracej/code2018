%avianSWRAnalysis_SCRIPTS

close all
clear all
dbstop if error

% Code dependencies
pathToCodeRepository = 'C:\Users\Administrator\Documents\code\GitHub\code2018\';
pathToOpenEphysAnalysisTools = 'C:\Users\Administrator\Documents\code\GitHub\analysis-tools\';
%pathToNSKToolbox = 'C:\Users\Administrator\Documents\code\GitHub\code2018\NSKToolBox\';
pathToNSKToolbox = 'C:\Users\Administrator\Documents\code\GitHub\NET\';

addpath(genpath(pathToCodeRepository)) 
addpath(genpath(pathToOpenEphysAnalysisTools)) 
addpath(genpath(pathToNSKToolbox)) 


%% Define Session

dataDir = 'Z:\hameddata2\EEG-LFP-song learning\JaniesAnalysisBackup\w027\chronic_2021-07-23_22-43-29\Ephys';



%% Vieo Analysis

VidPath = 'Z:\hameddata2\EEG-LFP-song learning\w025 and w027\w0027 -just vid\w27_18_08_2021_00215-converted.avi';

[filepath,name,ext] = fileparts(VidPath );

nFrames = 944491;
frameRate = 20;
frameCut_s = 1800;
frameCut_frames = frameCut_s*frameRate;

nMovies = ceil(nFrames/frameCut_frames);
tic
VidObj = VideoReader(VidPath);            
toc
            vidHeight = VidObj.Height;
            vidWidth = VidObj.Width;
            %totalFrames = VidObj.NumberOfFrames;
           
            for j = 1:nMovies
                
                if j == nMovies
                    mov(1:frameCut_frames) = struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),'colormap', []);
                else
                    mov(1:frameCut_frames) = struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),'colormap', []);
                    
                    cnt = 1;
                    while hasFrame(VidObj)
                        %mov(cnt).cdata = read(VidObj, k);
                        mov(cnt).cdata = readFrame(VidObj);
                        
                        if cnt == frameCut_frames
                            
                            saveName = [filepath '\' name '_part-' num2str(j) ];
                            %V = VideoWriter(saveName, 'Uncompressed AVI'); % creates huge files ~20 GB, 'quality' is not an option
                            V = VideoWriter(saveName, 'Motion JPEG AVI');
                            V.Quality = 95;
                            V.FrameRate = frameRate;
                            
                            mov = mov(1:end);
                            tic
                            open(V)
                            writeVideo(V, mov)
                            close(V)
                            toc
                            continue
                        else
                            fprintf('%d/%d\n', cnt, frameCut_frames);
                            cnt = cnt+1;
                            
                            
                        end
                        
                    end
                
                
                
                vidFrame = readFrame(VidObj);
                image(vidFrame, 'Parent', currAxes);
                currAxes.Visible = 'off';
                pause(1/v.FrameRate);
            end
            
            
            
            
            allDiffs = nan(1, nFrames-1);
            cnt = 1;
            for k =1:nFrames-1
                
                img1 = read(VidObj, k);
                grayImage1 = rgb2gray(img1);
                
                %imshow(grayImage1) 
                img2 = read(VidObj, k+1);
                grayImage2 = rgb2gray(img2);
                  
                diffImg = grayImage2-grayImage1;
                %imshow(diffImg) 
                
                difVal = sum(sum(diffImg));
                allDiffs(cnt) = difVal;
                
                cnt = cnt+1;
            end
            
    currAxes = axes;

            
            
            
            
 timeScale_frames = 1:1:nFrames-1;
 timeScale_s = timeScale_frames/frameRate;
 timeScale_hr = timeScale_s/3600;
 figure
plot(timeScale_hr, allDiffs)
plot(timeScale_hr,allDiffs)

%recSession = 54; % (54) Chick-10  | 27.04.2019 - 19-33-33
%recSession = 76; %(76) ZF-72-81 | 16.05.2019 - 19-18-21
recSession = 81; %(81) ZF-72-81 | 16.05.2019 - 21-26-59 - Overnight

D_OBJ = avianSWRAnalysis_OBJ(recSession); 
disp([D_OBJ.INFO.birdName ': ' D_OBJ.Session.time])


%%
dataDir = D_OBJ.Session.SessionDir;
dataRecordingObj = OERecordingMF(dataDir);
dataRecordingObj = getFileIdentifiers(dataRecordingObj); % creates dataRecordingObject

timeSeriesViewer(dataRecordingObj); % loads all the channels







%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Multi-channel Plot

%doPlot = 1; % Make and print plots
%seg_s = 50; % segment to plot (in s)

%D_OBJ = batchPlotDataForOpenEphys_multiChannel(D_OBJ, doPlot, seg_s);
D_OBJ = batchPlotDataForOpenEphys_multiChannel(D_OBJ); % default is doPlot, 40s
disp('Finished plotting')

%% Single Channel Plot

%D_OBJ = batchPlotDataForOpenEphys_singleChannel(D_OBJ, doPlot, seg_s); % default is doPlot, 40s
D_OBJ = batchPlotDataForOpenEphys_singleChannel(D_OBJ); % default is doPlot, 40s
 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-processing for Sebastian's ShWR detections
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% FullFile - creates a "_py_fullFile"

%chanOverride = 7;
%D_OBJ = prepareDataForShWRDetection_FullFile_Python(D_OBJ, chanOverride); 
[D_OBJ] = prepareDataForShWRDetection_FullFile_Python(D_OBJ);

%% Do NOT USE - use fullfile option for now
%chanOverride = [];
%durOverride = [];

%D_OBJ  = prepareDataForShWRDetection_Python(D_OBJ, chanOverride, durOverride);
%D_OBJ  = prepareDataForShWRDetection_Python(D_OBJ);

%% Confirm Detections - not actually using this for now....

% This should be in the code/SWR/Data directory % export_ripples, copy back into directory
%confirmSWR_PythonDetections(D_OBJ) % I cannot figure out how to include this in the analysis object...

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SWR Plotting
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Mean shape, saves the snippets for the detections "SWR_data.mat"


%% Remember to change the data name to x_data

useNotch =0;

[D_OBJ] = SWR_PythonDetections_shapeStatistics(D_OBJ, useNotch );

pathToChronuxToolbox = 'C:\Users\Administrator\Documents\code\GitHub\chronux\';
addpath(genpath(pathToChronuxToolbox)) 

%% Wavelet
waveletInd = 5;
useNotch = 1;
[D_OBJ] = SWR_wavelet(D_OBJ, waveletInd, useNotch );

%% Frequency raster
binSize_s = 15;
[D_OBJ] = SWR_raster(D_OBJ, binSize_s);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Spikesorting with KiloSort
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Make sure the Phy is closed before running!!!
% 
% pathToKiloSort = 'C:\Users\Administrator\Documents\code\GitHub\KiloSort\';
% pathToNumpy = 'C:\Users\Administrator\Documents\code\GitHub\npy-matlab\';
% 
% addpath(genpath(pathToKiloSort))
% addpath(genpath(pathToNumpy))
%             
% pathToYourConfigFile = 'C:\Users\Administrator\Documents\code\GitHub\code2018\KiloSortProj\KiloSortConfigFiles\'; 
% 
% % Config Files - check that the channel map is set correctly there!
% %nameOfConfigFile =  'StandardConfig_avian16Chan_ZF_6088.m';
% nameOfConfigFile =  'StandardConfig_avian16Chan_ZF_5915.m';
% %nameOfConfigFile =  'StandardConfig_avian16Chan_ZF_7281.m';
% %nameOfConfigFile =  'StandardConfig_avian16Chan_Chick10';
% runKilosortFromConfigFile(D_OBJ, pathToYourConfigFile, nameOfConfigFile)
% 
% disp(['Finished Processing ' D_OBJ.Session.SessionDir])

%%

%pathToKiloSort = 'C:\Users\Administrator\Documents\code\GitHub\KiloSort2\';
pathToKiloSort = 'C:\Users\Janie\Documents\GitHub\Kilosort-2.5\';
pathToNumpy = 'C:\Users\Administrator\Documents\code\GitHub\npy-matlab\';

addpath(genpath(pathToKiloSort))
addpath(genpath(pathToNumpy))
            
pathToYourConfigFile = 'C:\Users\Administrator\Documents\code\GitHub\code2018\KiloSortProj\KiloSortConfigFiles'; 

% Config Files - check that the channel map is set correctly there!
%nameOfConfigFile =  'StandardConfig_avian16Chan_ZF_5915.m';
nameOfConfigFile =  'StandardConfig_avian16Chan_ZF_5915_K2.m';

%nameOfConfigFile =  'StandardConfig_avian16Chan_ZF_6088.m';
%nameOfConfigFile =  'StandardConfig_avian16Chan_ZF_6088_K2.m';

%nameOfConfigFile =  'StandardConfig_avian16Chan_Chick10.m';
%nameOfConfigFile =  'StandardConfig_avian16Chan_Chick10_K2.m';

%nameOfConfigFile =  'StandardConfig_avian16Chan_ZF_7281.m';
%nameOfConfigFile =  'StandardConfig_avian16Chan_ZF_7281_K2.m';


%root = 'F:\TUM\SWR-Project\ZF-59-15\Ephys\2019-04-28_21-05-36';
%root = 'F:\TUM\SWR-Project\ZF-59-15\Ephys\2019-04-28_18-07-21';
%root = 'F:\TUM\SWR-Project\ZF-59-15\Ephys\2019-04-28_18-48-02'; 

%chanMap = 'C:\Users\Administrator\Documents\code\GitHub\code2018\KiloSortProj\KiloSortConfigFiles\chanMap16ChanSilicon.mat';

runKilosort2fromConfigFile(D_OBJ, pathToYourConfigFile, nameOfConfigFile)
disp(['Finished Processing ' D_OBJ.Session.SessionDir])

%% Running Phy
% navigate to the data directory in cmd window (the location of the .dat file)
%> activate phy
%> phy template-gui params.py
% pip install git+https://github.com/kwikteam/phy git+https://github.com/kwikteam/phy-contrib --upgrade
%% Make sure to save which channels have which clusters on them!!

D_OBJ = avianSWRAnalysis_OBJ(recSession); 


%% Make plots of spikes aligned to SWRs

addpath(genpath('C:\Users\Administrator\Documents\code\GitHub\npy-matlab'))
addpath(genpath('C:\Users\Administrator\Documents\code\GitHub\spikes'))

ClustType = 2;
% - 0 = noise
% - 1 = mua
% - 2 = good
% - 3 = unsorted

[D_OBJ] = importPhyClusterSpikeTimes(D_OBJ, ClustType);

%% Make plots of the spikes
ClustType = 1;
if ~isfield(D_OBJ.REC, 'GoodClust_2') || ~isfield(D_OBJ.REC, 'MUAClust_1')
    disp('***Make sure to set the cluster information in the database before running!***')
else
    [D_OBJ]  = loadClustTypesAndMakeSpikePlots(D_OBJ, ClustType);    
end
disp('Finished plotting...')
%%

chanSelectionOverride = [];

ClustType = 1;

%[D_OBJ]  = loadClustTypesAndAlignToSWR_Raster(D_OBJ, chanSelectionOverride);
[D_OBJ]  = loadClustTypesAndAlignToSWR_Raster_ClustType(D_OBJ, ClustType);


%% Analysis using the Sleep code

[D_OBJ] = getFreqBandDetection(D_OBJ);

[D_OBJ] = plotDBRatio(D_OBJ);




