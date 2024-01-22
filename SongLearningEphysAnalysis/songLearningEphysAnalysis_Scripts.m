%avianSWRAnalysis_SCRIPTS

close all
clear all
dbstop if error

% Code dependencies
pathToCodeRepository = 'C:\Users\Administrator\Documents\code\GitHub\code2018\';
pathToOpenEphysAnalysisTools = 'C:\Users\NeuroPix-DAQ\Documents\GitHub\analysis-tools\';
%pathToNSKToolbox = 'C:\Users\Administrator\Documents\code\GitHub\code2018\NSKToolBox\';
pathToNSKToolbox = 'C:\Users\Administrator\Documents\code\GitHub\NET\';

addpath(genpath(pathToCodeRepository)) 
addpath(genpath(pathToOpenEphysAnalysisTools)) 
addpath(genpath(pathToNSKToolbox))
%% Define Session

dataDir = 'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysisBackup\w027\chronic_2021-07-24_22-37-34\Ephys\';
TriggerChan = 'recons';
BestChan = '49';

extSearch = ['*' BestChan '*'];
BestChanExactName =dir(fullfile(dataDir,extSearch));
tic
[data, timestamps, info] = load_open_ephys_data([dataDir BestChanExactName.name]);
toc

%extSearch = ['*' TriggerChan '*'];
%TriggerChanExactName =dir(fullfile(dataDir,extSearch));
%[Trigdata, timestamps, info] = load_open_ephys_data([dataDir TriggerChanExactName.name]);

Fs = info.header.sampleRate;

%%

timeOfRecording = '22:37:34';
LightsOff = '23:01:48';

sInMin = 60;
minInHr = 60;
hoursInDay = 24;

colon = ':';
bla = find(timeOfRecording == colon);
Rec_initClockHr = str2double(timeOfRecording(1: bla(1)-1));
Rec_initClockMin = str2double(timeOfRecording(bla(1)+1: bla(2)-1));
Rec_initClockS = str2double(timeOfRecording(bla(2)+1:end));

bla = find(LightsOff == colon);
LightsOff_initClockHr = str2double(LightsOff(1: bla(1)-1));
LightsOff_initClockMin = str2double(LightsOff(bla(1)+1: bla(2)-1));
LightsOff_initClockS = str2double(LightsOff(bla(2)+1:end));

DiffHrs = LightsOff_initClockHr - Rec_initClockHr;
DiffMins = LightsOff_initClockMin - Rec_initClockMin;
DiffS = LightsOff_initClockS - Rec_initClockS;

TotalDiff_S = DiffHrs*3600+DiffMins*60+DiffS;
LightOff_samples = TotalDiff_S*Fs;

%% 2 hours after lights off, 8 hour recording samples 

X_HourWin = 8*3600*Fs;

ROI = [LightOff_samples LightOff_samples+X_HourWin];

figure; plot(data(ROI(1): ROI(1)+10000000))
figure; plot(ROIData(1:10000000))

ROIData = data(ROI(1): ROI(2));
clear('data') 

totalSamples = size(ROIData, 1);
            recordingDuration_s  = totalSamples/Fs;
            recordingDuration_hr = recordingDuration_s/3600;
            
            
%% Downsample

batchDuration_s = 60; % 60 s
batchDuration_samp = batchDuration_s*Fs;

tOn_samp = 1:batchDuration_samp:totalSamples;
nBatches = numel(tOn_samp);
            
%% Downsample
fObj = filterData(sampleRate);

fobj.filt.F=filterData(sampleRate);
%fobj.filt.F.downSamplingFactor=120; % original is 128 for 32k
fobj.filt.F.downSamplingFactor=100; % original is 128 for 32k
fobj.filt.F=fobj.filt.F.designDownSample;
fobj.filt.F.padding=true;
fobj.filt.FFs=fobj.filt.F.filteredSamplingFrequency;

%% D/B
reductionFactor = 1; % No reduction

movWin_Var = 10*reductionFactor; % 10 s
movOLWin_Var = 9*reductionFactor; % 9 s

segmentWelch = 1*reductionFactor;
OLWelch = 0.5*reductionFactor;

dftPointsWelch =  2^10;

segmentWelchSamples = round(segmentWelch*fobj.filt.FFs);
samplesOLWelch = round(segmentWelchSamples*OLWelch);

movWinSamples=round(movWin_Var*fobj.filt.FFs);%obj.filt.FFs in Hz, movWin in samples
movOLWinSamples=round(movOLWin_Var*fobj.filt.FFs);

[~,f] = pwelch(randn(1,movWinSamples),segmentWelchSamples,samplesOLWelch,dftPointsWelch,fobj.filt.FFs);

deltaBandLowCutoff = 1;
deltaBandHighCutoff = 4;

gammaBandLowCutoff = 25;
gammaBandHighCutoff = 140;

pfDeltaBand=find(f>=deltaBandLowCutoff & f<deltaBandHighCutoff);
pfGammBand=find(f>=gammaBandLowCutoff & f<gammaBandHighCutoff);

 for i = 1:nBatches-1
                
                if i == nBatches
                    thisData = ROIData(tOn_samp(i):samples);
                else
                    thisData = ROIData(tOn_samp(i):tOn_samp(i)+batchDuration_samp);
                end
                

 tmp_V_DS = buffer(DataSeg_F,movWinSamples,movOLWinSamples,'nodelay');
                pValid=all(~isnan(tmp_V_DS));
                
                [pxx,f] = pwelch(tmp_V_DS(:,pValid),segmentWelchSamples,samplesOLWelch,dftPointsWelch,fobj.filt.FFs);
                


%% Open Trigger File
extSearch = ['*' TriggerChan '*'];
TrigFileExactName =dir(fullfile(dataDir,extSearch));
% 
% 
            tic            
            fix_open_ephys_data([dataDir TrigFileExactName.name])
            
            [data, timestamps, info] = load_open_ephys_data([dataDir TrigFileExactName.name]);
            [data, timestamps, info] = load_open_ephys_data([dataDir '150_CH44.continuous']);
            
            %thisSegData_s = timestamps(1:end) - timestamps(1);
            toc
            disp('Finished loading data')
            
            disp('Finding peaks...')
            [pks,locs,w,p] = findpeaks(data, 'MinPeakHeight', 1);
            
            nTrigs = numel(locs);
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
% pathToKiloSort = 'C:\Users\Administrator\Documents\code\GitHub\KiloSort\'; 
% pathToNumpy = 'C:\Users\Administrator\Documents\code\GitHub\npy-matlab\';
% 
% addpath(genpath(pathToKiloSort)) addpath(genpath(pathToNumpy))
% 
% pathToYourConfigFile = 'C:\Users\Administrator\Documents\code\GitHub\code2018\KiloSortProj\KiloSortConfigFiles\'; 
% 
% % Config Files - check that the channel map is set correctly there! %nameOfConfigFile 
% = 'StandardConfig_avian16Chan_ZF_6088.m'; nameOfConfigFile = 'StandardConfig_avian16Chan_ZF_5915.m'; 
% %nameOfConfigFile = 'StandardConfig_avian16Chan_ZF_7281.m'; %nameOfConfigFile 
% = 'StandardConfig_avian16Chan_Chick10'; runKilosortFromConfigFile(D_OBJ, pathToYourConfigFile, 
% nameOfConfigFile)
% 
% disp(['Finished Processing ' D_OBJ.Session.SessionDir])

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