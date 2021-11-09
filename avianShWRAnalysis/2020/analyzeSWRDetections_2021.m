function [] = analyzeSWRDetections_2021()

detFileToLoad = 'G:\SWR\ZF-72-96\20200108\14-03-08\Ephys\Detections\__SWR-Detections.mat';

load(detFileToLoad);
disp('')

SessionDir = D.INFO.SessionDir;
rippleChans = D.INFO.rippleChans;
SWChan = D.INFO.SWChan;
%%

dataRecordingObj = OERecordingMF(SessionDir);
dataRecordingObj = getFileIdentifiers(dataRecordingObj); % creates dataRecordingObject

Fs_orig = dataRecordingObj.samplingFrequency;
recordingDur_ms = dataRecordingObj.recordingDuration_ms;
recordingDur_s = recordingDur_ms/1000;

%%
nDataChunks = numel(D.AllRippleDetections_abs);
allRipplePeaks_samps = [];
allSWPeaks_samps = [];

% Detections are in samples, 
for j = 1:nDataChunks
    
    thisRippleDet = D.AllRippleDetections_abs{j};
    thisSWDet = D.AllSWDetections_abs{j};
    
    RipplePeaks = thisRippleDet(:,2);
    SWPeaks = thisSWDet(:,2);
    
    allRipplePeaks_samps = [allRipplePeaks_samps; RipplePeaks];
    allSWPeaks_samps = [allSWPeaks_samps ; SWPeaks];
    
end


%%
% Detections are in samples, if we want to load them, we need to convert
% them to ms for the dataRecording object.. 

allRipplePeaks_ms = allRipplePeaks_samps/Fs_orig;
allSWPeaks_ms = allSWPeaks_samps/Fs_orig;

 [rawData_SW,t_ms]=dataRecordingObj.getData(SWChan,allSWPeaks_ms-100, 200);

allSWRs = squeeze(rawData_SW);

figure(100); clf
plot(allSWRs (3,:));

end
