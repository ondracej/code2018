function [chickenDB_OT] = chickenDatabase_OT()

dbstop if error

dataDir = 'C:\Janie\Data\OT\Results\';

rfc = 1;
ncnt = 1;
scnt = 1;
%%
% WN = 5
% HRTF = 1
% IID = 3
% ITD = 4
% Tuning = 2

%% OT-12 | 04-Dec-2017
%Info
chickenDB_OT(rfc).INFO.chickenNumber  = '20171204';
chickenDB_OT(rfc).INFO.chickenDOB  = '23-10-2017';
chickenDB_OT(rfc).INFO.chickenAge  = 42; %dph
chickenDB_OT(rfc).INFO.chickenWeight  = 452; %g
chickenDB_OT(rfc).INFO.chickenSex  = 'F';
chickenDB_OT(rfc).INFO.ExpDate  = '04-12-2017';
chickenDB_OT(rfc).INFO.CraniotomySide  = 'R';
chickenDB_OT(rfc).INFO.DateDir  = ['_data_' chickenDB_OT(rfc).INFO.chickenNumber];

%Neuron
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).ProtocolName  = 'HRTF';
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).ProtocolType  = 1;
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).ResultDir  = '01-HRTF_20171204_150652_0001';
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).sortedResult  = 'result_0001.xml';
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).sortedResult  = 'epoches.pcm';
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).time  = '150652';
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).Coords_DV  = 2086; %micron
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).CompleteRec  = 1; 
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).Notes  = '6 reps';
scnt = scnt + 1;

chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).ProtocolName  = 'IID';
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).ProtocolType  = 3;
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).ResultDir  = '03-IID_20171204_153003_0001';
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).sortedResult  = 'result_0001.xml';
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).sortedResult  = 'epoches.pcm';
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).time  = '153003';
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).Coords_DV  = 2086; %micron
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).CompleteRec  = 1; 
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).Notes  = '20 reps';
scnt = scnt + 1;

chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).ProtocolName  = 'ITD';
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).ProtocolType  = 4;
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).ResultDir  = '04-ITD_20171204_153355_0001';
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).sortedResult  = 'result_0001.xml';
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).sortedResult  = 'epoches.pcm';
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).time  = '153355';
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).Coords_DV  = 2086; %micron
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).CompleteRec  = 1; 
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).Notes  = '-2 ms to +2 ms; 0.25 ms delay';
scnt = scnt + 1;

chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).ProtocolName  = 'Tuning';
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).ProtocolType  = 2;
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).ResultDir  = '02-Tuning_20171204_153931_0001';
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).sortedResult  = 'result_0001.xml';
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).sortedResult  = 'epoches.pcm';
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).time  = '153931';
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).Coords_DV  = 2086; %micron
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).CompleteRec  = 1; 
chickenDB_OT(rfc).Neuron(ncnt).Session(scnt).Notes  = '50-110 db, losing spike';
scnt = scnt + 1;



%%
file = 'C:\Janie\Data\OT\Results\_data_20171204\01-HRTF_20171204_150652_0001\result_0001';

thisResultDir = '01-HRTF_20171204_150652_0001';
dateDir = '_data_20171204';
thisResult = 'result_0002.xml';
dirD = '\';

LoadRawEpoch = 0;
thisFile = [dataDir dateDir dirD thisResultDir dirD thisResult];
results = audiospike_loadresult(thisFile, LoadRawEpoch);

%%
Settings = results.Settings;
Parameters = results.Parameters; 
Spikes = results.Spikes;
NonSelectedSpikes = results.NonSelectedSpikes;
Stimuli = results.Stimuli;
StimulusSequence = results.StimulusSequence;
Epochs = results.Epoches;

%%

nSpks = numel(Spikes);

for j = 1:nSpks
    stimInds(j) = Spikes.StimIndex;
end

%% Sort Spike-related stim inds

[sortedB, StInd] = sort(stimInds, 'ascend');
    










disp('')








end