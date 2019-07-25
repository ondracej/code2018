close all
clear all
%dataRecordingObj = NLRecording(DIR.cheetahDir);
%%
NLData = 'G:\MPI\turtle_AD20\01.22.2017\16-52-21_cheetah\';
dataRecordingObj = NLRecording(NLData);
timeSeriesViewer(dataRecordingObj)

%%

OEData = 'F:\Grass\FrogSleep\CubanTreeFrog1\20190627\20190627_08-43\Ephys\2019-06-27_08-43-09';
dataRecordingObj = oepsRecording(OEData);

timeSeriesViewer(dataRecordingObj)


%%

oepsData = 'F:\Grass\FrogSleep\CubanTreeFrog1\20190624\20190624_19-14\Ephys\2019-06-24_19-14-36\106_CH1.continuous';

[data, timestamps, info] = load_open_ephys_data(oepsData)

