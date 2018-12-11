function [OT_DB] = OT_database()

%% Chicken OT database

% Raw Exp Counter
efc = 1;

%% Stimulus Protocol
% Stim Protocol: (1) HRTF; (2) Tuning; (3) IID; (4) ITD; (5) WN

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OT- 18 , efc = 1; 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

OT_DB(efc).expID  = 18;
OT_DB(efc).expDir  = '_data_20171214';
OT_DB(efc).bird_number  = 20171214;
OT_DB(efc).bird_age  = [];
OT_DB(efc).bird_DOB  = 20171101;
OT_DB(efc).bird_sex  = 'F';
OT_DB(efc).bird_weight  = 423; % g
OT_DB(efc).exp_number  = efc;

%% SC = 1; RC = 1
sc = 1; % Increment Session
rsc  = 1;
% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 1015; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171214_130224_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'WN - Not Auditory';

%% SC = 2; RC = 1
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 1437; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171214_130558_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'Onset, not very responsive';
rsc = rsc +1;

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171214_130922_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'same neuron, but slower playback rate';
rsc = rsc +1;

%% SC = 3; RC = 1
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2772; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171214_131951_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'multiunit bursting, tonic activation';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171214_132223_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171214_134543_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171214_134739_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171214_135110_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

%% SC = 4; RC = 1
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2308; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171214_143854_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'onset, responds a few times';
rsc = rsc +1;

OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171214_144113_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'same neuron, but slower playback rate 1 per second';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171214_144551_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '1 per second - incomplete / Missing Data???';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171214_144926_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '1 per second';
rsc = rsc +1;

%% SC = 5; RC = 1
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 1819; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171214_151442_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'Not auditory';
rsc = rsc +1;

%% SC = 6; RC = 1
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2020; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171214_151810_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'Not auditory, maybe';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171214_152034_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'lost neuron, incomplete';
rsc = rsc +1;

%% SC = 7; RC = 1
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2794; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171214_153301_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'slightly auditory';
rsc = rsc +1;

%% SC = 8; RC = 1
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2194; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171214_155229_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171214_155453_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'v noisy, stopped recording';
rsc = rsc +1;

%% SC = 9; RC = 1
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2362; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171214_161427_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'too many neurons';
rsc = rsc +1;

%% SC = 10; RC = 1
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2706; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171214_163401_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'single spikes';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171214_163624_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171214_165833_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171214_170034_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171214_170403_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171214_173033_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'lost neuron, incomplete, multiunit';
rsc = rsc +1;

%% SC = 11; RC = 1
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2838; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171214_175445_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'random noise';
rsc = rsc +1;

%% SC = 12; RC = 1
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2613; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171214_181103_0001';
OT_DB(efc).RS(sc).notes{rsc} = '2 neurons, 1 huge one';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171214_181326_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'pre-firing and noisy neurons';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171214_183536_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '2 neurons';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171214_183731_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '2 neurons';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171214_184105_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '2 neurons';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171214_190730_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'losing neurons';
rsc = rsc +1;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OT- 17 , efc = 2; 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
efc = efc + 1;

OT_DB(efc).expID  = 17;
OT_DB(efc).expDir  = '_data_20171213';
OT_DB(efc).bird_number  = 20171213;
OT_DB(efc).bird_age  = [];
OT_DB(efc).bird_DOB  = 20171101;
OT_DB(efc).bird_sex  = 'M';
OT_DB(efc).bird_weight  = 502; % g
OT_DB(efc).exp_number  = efc;

%% SC = 1; RC = 1
sc = 1; % Increment Session
rsc  = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2438; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171213_124518_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'Not auditory';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171213_124753_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'not auditory, lost neuron';
rsc = rsc +1;

%% SC = 2; RC = 1
sc = sc + 1; % Increment Session
rsc  = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2577; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171213_131154_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'Not auditory';
rsc = rsc +1;

%% SC = 3; RC = 1
sc = sc + 1; % Increment Session
rsc  = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2888; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171213_132113_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'Not auditory';
rsc = rsc +1;

%% SC = 4; RC = 1
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 3221; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171213_132558_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'multi neuron, suppressed by WN';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171213_132824_0001';
OT_DB(efc).RS(sc).notes{rsc} = '2 clusters';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171213_135131_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171213_135325_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171213_135654_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = 'some non-stationarities-';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171213_142612_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'losing neurons';
rsc = rsc +1;

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171213_144121_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

%% SC = 5; RC = 1
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 3206; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171213_152612_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'hhuge spike';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171213_152839_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171213_155244_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = 'really crazy!!';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171213_155436_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = 'like hrtf';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171213_155803_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = 'some non-stationarities-';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171213_162452_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'lots of non-stationarities';
rsc = rsc +1;

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171213_163950_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

%% SC = 6; RC = 1
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 873; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171213_165959_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'not auditory';
rsc = rsc +1;

%% SC = 7; RC = 1
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2771; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171213_170956_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'sort of not auditory';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171213_171221_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171213_173427_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171213_173623_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

%% SC = 8; RC = 1
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 3377; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171213_174712_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'strange neuron';
rsc = rsc +1;

%% SC = 9; RC = 1
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 3377; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171213_175230_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'suppressed';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171213_175455_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171213_181819_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171213_182020_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171213_182353_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = 'spikes getting better';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171213_185321_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171213_190953_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OT- 17 , efc = 2; 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
efc = efc + 1;

OT_DB(efc).expID  = 16;
OT_DB(efc).expDir  = '_data_20171212';
OT_DB(efc).bird_number  = 20171212;
OT_DB(efc).bird_age  = [];
OT_DB(efc).bird_DOB  = 20171101;
OT_DB(efc).bird_sex  = 'M';
OT_DB(efc).bird_weight  = 535; % g
OT_DB(efc).exp_number  = efc;

%% SC = 1; RC = 1
sc = 1; % Increment Session
rsc  = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 1015; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171212_125652_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'not auditory';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171212_125919_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'not aud';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171212_132201_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171212_132355_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171212_132724_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = 'spike getting smalelr';
rsc = rsc +1;

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171212_135356_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'weird phone noise';
rsc = rsc +1;








%% 



%%

efc = efc + 1;






























%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OT- 18 , efc = 1; 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% OT- 18

OT_DB(efc).expID  = 18;
OT_DB(efc).expDir  = '_data_20171214';
OT_DB(efc).bird_number  = 20171214;
OT_DB(efc).bird_age  = [];
OT_DB(efc).bird_DOB  = 20171101;
OT_DB(efc).bird_sex  = 'F';
OT_DB(efc).bird_weight  = 423; % g
OT_DB(efc).exp_number  = efc;

%% Session Counter
sc = 1; % Increment Session

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 1278; % microns

%% Stimulus Protocol
% Stim Protocol: (1) HRTF; (2) Tuning; (3) IID; (4) ITD; (5) WN

rsc  = 1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171204_150652_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 6;
%raw_data_file_db(efc).RS(rsc).level = 100; % dB
OT_DB(efc).RS(sc).notes{rsc} = 'Big spike is an offset neuron';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171204_153003_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171204_153355_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '-2 to +2 ms; 25 ms delay';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171204_153931_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = 'spiking getting smaller, losing cell';


%% 
sc = sc + 1; % Increment Session

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2515; % microns

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% OT- 12

OT_DB(efc).expID  = 12;
OT_DB(efc).expDir  = '_data_20171204';
OT_DB(efc).bird_number  = 20171204;
OT_DB(efc).bird_age  = [];
OT_DB(efc).bird_DOB  = 20171023;
OT_DB(efc).bird_sex  = 'F';
OT_DB(efc).bird_weight  = 452; % g
OT_DB(efc).exp_number  = efc;

%% Session Counter
sc = 1; % Increment Session

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2086; % microns

%% Stimulus Protocol
% Stim Protocol: (1) HRTF; (2) Tuning; (3) IID; (4) ITD; (5) WN

rsc  = 1;

%% 
% WN - WNSeach_20171214_130224_0001
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171214_130224_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'WN - Not Auditory';

%%
sc = sc + 1; % Increment Session

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 1437; % microns

%%
rsc  = 1;

%% 
% WN - 05-WNSeach_20171214_130558_0001
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171214_130558_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'WN - Onset, not very responsive';
rsc = rsc +1;

% WN - 05-WNSeach_20171214_130922_0001
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171214_130922_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'WN - Same neuron, playback now 1x per second';
rsc = rsc +1;

%%
sc = sc + 1; % Increment Session

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2772; % microns

%%
rsc  = 1;

% WN - 05-WNSeach_20171214_131951_0001
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171214_131951_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'WN - Multiunit bursting, tonic activation';
rsc = rsc +1;

% HRTF - 01-HRTF_20171214_132223_0001
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171214_132223_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'HRTF 6x';
rsc = rsc +1;


%%


% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171204_150652_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 6;
%raw_data_file_db(efc).RS(rsc).level = 100; % dB
OT_DB(efc).RS(sc).notes{rsc} = 'Big spike is an offset neuron';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171204_153003_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171204_153355_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '-2 to +2 ms; 25 ms delay';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171204_153931_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = 'spiking getting smaller, losing cell';


%% 
sc = sc + 1; % Increment Session

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2515; % microns

%%

rsc  = 1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171204_162523_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 6;
OT_DB(efc).RS(sc).notes{rsc} = 'Big spike is an offset neuron';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171204_164831_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = 'firing ~ 225 ms';

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171204_171130_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '-3 to +3 ms; .25 ms delay ';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171204_171651_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = 'starting to get smaller';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171204_172218_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = 'more reps, losing neuron';
rsc = rsc +1;

% WN
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171204_172909_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = 'spiking getting smaller, losing cell';


%%
sc = sc + 1; % Increment Session

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2576; % microns

rsc  = 1;


% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171204_173836_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 6;
OT_DB(efc).RS(sc).notes{rsc} = 'Might be same neuron as prev recording';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171204_180152_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '3 octaves';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171204_182448_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171204_183044_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% WN
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171204_184142_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = 'spiking getting smaller, losing cell';


%%

sc = sc + 1; % Increment Session

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2969; % microns

rsc  = 1;


% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171204_190721_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 6;
OT_DB(efc).RS(sc).notes{rsc} = 'Small spike';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171204_192935_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = 'same small spike';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171204_195216_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '2 neurons now';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171204_195812_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% WN
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171204_200914_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = 'slowly losing cell';


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OT- 17 , efc = 2; 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

efc = efc + 1;
 
OT_DB(efc).expID  = 17;
OT_DB(efc).expDir  = '_data_20171213';
OT_DB(efc).bird_number  = 20171213;
OT_DB(efc).bird_age  = 42;
OT_DB(efc).bird_DOB  = 20171101;
OT_DB(efc).bird_sex  = 'M';
OT_DB(efc).bird_weight  = 502; % g
OT_DB(efc).exp_number  = efc;

%% Session Counter | SC = 1
sc = 1; % Increment Session

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2438; % microns

rsc  = 1;

% WN
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171213_124518_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'Not Auditory';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171213_124753_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'Lost neuron - incompleted file: 2141/2580';
rsc = rsc +1;


%% Session Counter  | SC = 2
sc = sc + 1; % Increment Session
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2577; % microns

rsc  = 1;

% WN
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171213_131154_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'Not Auditory';

%% Session Counter | SC = 3
sc = sc + 1; % Increment Session
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2888; % microns

rsc  = 1;

% WN
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171213_132113_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'Not Auditory';

%% Session Counter | SC = 4
sc = sc + 1; % Increment Session
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 3221; % microns

rsc  = 1;

% WN
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171213_132558_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'Multiunit - supressed by WN';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171213_132824_0001';
OT_DB(efc).RS(sc).notes{rsc} = '2 neurons';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171213_135131_0001';
OT_DB(efc).RS(sc).notes{rsc} = '15x reps';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171213_135325_0001';
OT_DB(efc).RS(sc).notes{rsc} = '15x reps';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171213_135654_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'some nonstationarities';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171213_142612_0001';
OT_DB(efc).RS(sc).notes{rsc} = '4x reps';
rsc = rsc +1;

% WN
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171213_144121_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';


%% Session Counter | SC = 5
sc = sc + 1; % Increment Session
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 3206; % microns

rsc  = 1;

% WN
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171213_152612_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'Huge spike';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171213_152839_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171213_155244_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'Crazy response!';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171213_155436_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'Like HRTF';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171213_155803_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'some nonstationarities';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171213_162452_0001';
OT_DB(efc).RS(sc).notes{rsc} = '4x reps, lots of nonstationarities';
rsc = rsc +1;

% WN
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171213_163950_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';


%% Session Counter | SC = 6
sc = sc + 1; % Increment Session
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 873; % microns

rsc  = 1;

% WN
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171213_165959_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'Not auditory';


%% Session Counter | SC = 7
sc = sc + 1; % Increment Session
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2771; % microns

rsc  = 1;

% WN
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171213_170956_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'Not Aud';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171213_171221_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171213_173427_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171213_173623_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'Like HRTF';


%% Session Counter | SC = 8
sc = sc + 1; % Increment Session
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 3377; % microns

rsc  = 1;

% WN
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171213_174712_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'strange neuron';


%% Session Counter | SC = 9
sc = sc + 1; % Increment Session
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 3105; % microns

rsc  = 1;

% WN
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171213_175230_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'supressed';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171213_175455_0001';
OT_DB(efc).RS(sc).notes{rsc} = '6x reps';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171213_181819_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171213_182020_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171213_182353_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'spikes get better';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171213_185321_0001';
OT_DB(efc).RS(sc).notes{rsc} = '4x reps, lots of nonstationarities';
rsc = rsc +1;

% WN
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171213_190953_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';



end