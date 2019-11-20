function [OT_DB] = OT_database()

%% Chicken OT database

% Raw Exp Counter
efc = 1;

%% Stimulus Protocol
% Stim Protocol: (1) HRTF; (2) Tuning; (3) IID; (4) ITD; (5) WN

% Area =  1 (OT); 2 (MLD) 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OT- 18 , efc = 1; 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

OT_DB(efc).expID  = 18;
OT_DB(efc).expDir  = '_data_20171214';
OT_DB(efc).bird_number  = 20171214;
OT_DB(efc).bird_age  = 43;
OT_DB(efc).bird_DOB  = 20171101;
OT_DB(efc).bird_sex  = 'F';
OT_DB(efc).bird_weight  = 423; % g
OT_DB(efc).exp_number  = efc;

%% SC = 1; RC = 1 | N001
sc = 1; % Increment Session
rsc  = 1;
% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 1015; % microns
OT_DB(efc).RS(sc).Area = 1; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171214_130224_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'WN - Not Auditory';

%% SC = 2; RC = 1 | N002 
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

%% SC = 3; RC = 1 | N003
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

%% SC = 4; RC = 1 | N004
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

%% SC = 5; RC = 1 | N005
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

%% SC = 6; RC = 1 | N006
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

%% SC = 7; RC = 1 | N007 
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

%% SC = 8; RC = 1 | N008
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

%% SC = 9; RC = 1 | N009
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

%% SC = 10; RC = 1 | N010
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

%% SC = 11; RC = 1 | N011
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

%% SC = 12; RC = 1 | N012
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
%OT_DB(efc).RS(sc).nReps(rsc) = 20;83
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
OT_DB(efc).bird_age  = 42;
OT_DB(efc).bird_DOB  = 20171101;
OT_DB(efc).bird_sex  = 'M';
OT_DB(efc).bird_weight  = 502; % g
OT_DB(efc).exp_number  = efc;

%% SC = 1; RC = 1 | N013
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

%% SC = 2; RC = 1 | N014
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

%% SC = 3; RC = 1 | N015
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

%% SC = 4; RC = 1 | N016
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
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171213_1315131_0001';
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

%% SC = 5; RC = 1 | N017
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

%% SC = 6; RC = 1 | N018
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

%% SC = 7; RC = 1 | N019
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

%% SC = 8; RC = 1 | N020 
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

%% SC = 9; RC = 1 | N021
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
%% OT- 16 , efc = 3; 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
efc = efc + 1;

OT_DB(efc).expID  = 16;
OT_DB(efc).expDir  = '_data_20171212';
OT_DB(efc).bird_number  = 20171212;
OT_DB(efc).bird_age  = 41;
OT_DB(efc).bird_DOB  = 20171101;
OT_DB(efc).bird_sex  = 'M';
OT_DB(efc).bird_weight  = 535; % g
OT_DB(efc).exp_number  = efc;

%% SC = 1; RC = 1 | N022
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


%% SC = 2; RC = 1 | N023
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 3227; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171212_142314_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171212_142541_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171212_144748_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171212_144939_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171212_145306_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171212_152053_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171212_153553_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;


%% SC = 3; RC = 1 | N024
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 3324; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171212_154029_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'maybe same neuron?';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171212_154253_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171212_160501_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171212_160655_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171212_161024_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171212_163654_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171212_165151_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

%% SC = 4; RC = 1 | N025
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 3545; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171212_165645_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171212_165912_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171212_172122_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171212_172316_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171212_172648_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171212_175316_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171212_180817_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;
%% SC = 5; RC = 1 | N026 
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 3273; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171212_181639_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171212_181903_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171212_184109_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171212_184315_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171212_184653_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171212_191456_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171212_192954_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171212_193508_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

%% SC = 6; RC = 1 | N027
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 3575; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171212_193912_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171212_194136_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171212_200344_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171212_200538_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171212_200905_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171212_203543_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171212_205041_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OT- 15 , efc = 4; 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
efc = efc + 1;

OT_DB(efc).expID  = 15;
OT_DB(efc).expDir  = '_data_20171207';
OT_DB(efc).bird_number  = 20171207;
OT_DB(efc).bird_age  = 38;
OT_DB(efc).bird_DOB  = 20171030;
OT_DB(efc).bird_sex  = 'M';
OT_DB(efc).bird_weight  = 494; % g
OT_DB(efc).exp_number  = efc;

%% SC = 1; RC = 1 N028
sc = 1; % Increment Session
rsc  = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2766; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171207_145948_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171207_150214_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171207_152503_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171207_152747_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171207_153115_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171207_160302_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171207_161826_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

%% SC = 2; RC = 1 | N029
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 3073; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171207_162415_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171207_162638_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171207_164852_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171207_165044_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171207_165412_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171207_172043_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171207_173542_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

%% SC = 3; RC = 1 | N030
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 3334; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171207_174223_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';

%% SC = 4; RC = 1 | N031
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2251; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171207_180057_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171207_180321_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171207_182619_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171207_183108_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171207_183438_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171207_190153_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171207_191731_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;


%% SC = 5; RC = 1 | N032
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2319; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171207_192242_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171207_192507_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171207_194759_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171207_194953_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171207_195323_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171207_202030_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171207_203600_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OT- 14 , efc = 5; 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
efc = efc + 1;

OT_DB(efc).expID  = 14;
OT_DB(efc).expDir  = '_data_20171206';
OT_DB(efc).bird_number  = 20171206;
OT_DB(efc).bird_age  = 41;
OT_DB(efc).bird_DOB  = 20171026;
OT_DB(efc).bird_sex  = 'F';
OT_DB(efc).bird_weight  = 562; % g
OT_DB(efc).exp_number  = efc;

%% SC = 1; RC = 1 | N033
sc = 1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2743; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171206_124100_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171206_124326_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171206_130540_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171206_131124_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';


%% SC = 2; RC = 1 | N034
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2807; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171206_132504_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171206_132732_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171206_135034_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171206_135336_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171206_135917_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = 'lost neuron';
rsc = rsc +1;

%% SC = 3; RC = 1 | N035
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2479; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171206_153610_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171206_153856_0001';
OT_DB(efc).RS(sc).notes{rsc} = '2 neurons, one exploded';
rsc = rsc +1;

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171206_154812_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171206_155044_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'neuron exploding';
rsc = rsc +1;

%% SC = 4; RC = 1 | N036
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 3086; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171206_163856_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171206_164120_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171206_170334_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171206_170529_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171206_170902_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171206_173538_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171206_175040_0001';
OT_DB(efc).RS(sc).notes{rsc} = 'some other neuron';
rsc = rsc +1;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OT- 13 , efc = 6; 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
efc = efc + 1;

OT_DB(efc).expID  = 13;
OT_DB(efc).expDir  = '_data_20171205';
OT_DB(efc).bird_number  = 20171205;
OT_DB(efc).bird_age  = 41;
OT_DB(efc).bird_DOB  = 20171025;
OT_DB(efc).bird_sex  = 'M';
OT_DB(efc).bird_weight  = 470; % g
OT_DB(efc).exp_number  = efc;

%% SC = 1; RC = 1 | N037
sc = 1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2976; % microns

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171205_134222_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171205_140607_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171205_143302_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171205_143901_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171205_145044_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171205_145313_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171205_145902_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171205_150854_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;


%% SC = 2; RC = 1 | N038
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2663; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171205_155720_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171205_160026_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171205_162232_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171205_162816_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = 'moving electrodes, lost neurons';
rsc = rsc +1;


%% SC = 3; RC = 1 | N039
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2163; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171205_165922_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171205_170146_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171205_172418_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171205_173004_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171205_174119_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171205_180758_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

%% SC = 4; RC = 1 | N040
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2726; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171205_183447_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171205_183717_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171205_190002_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171205_190551_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171205_191648_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171205_194538_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171205_194807_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OT- 12 , efc = 7; 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
efc = efc + 1;

OT_DB(efc).expID  = 12;
OT_DB(efc).expDir  = '_data_20171204';
OT_DB(efc).bird_number  = 20171204;
OT_DB(efc).bird_age  = 42;
OT_DB(efc).bird_DOB  = 20171023;
OT_DB(efc).bird_sex  = 'F';
OT_DB(efc).bird_weight  = 452; % g
OT_DB(efc).exp_number  = efc;

%% SC = 1; RC = 1 | N041
sc = 1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2086; % microns

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171204_150652_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
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
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171204_153931_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;


%% SC = 2; RC = 1 | N042
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2515; % microns

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171204_162523_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171204_164831_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171204_171130_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171204_171651_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171204_172218_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171204_172909_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;


%% SC = 3; RC = 1 | N043
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2576; % microns

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171204_173836_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171204_180152_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
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

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171204_184142_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;


%% SC = 4; RC = 1 | N044
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2969; % microns

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171204_190721_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171204_192935_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171204_195216_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171204_195812_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171204_200914_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OT- 11 , efc = 8; 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
efc = efc + 1;

OT_DB(efc).expID  = 11;
OT_DB(efc).expDir  = '_data_20171117';
OT_DB(efc).bird_number  = 20171117;
OT_DB(efc).bird_age  = 43;
OT_DB(efc).bird_DOB  = 20171005;
OT_DB(efc).bird_sex  = 'M';
OT_DB(efc).bird_weight  = 532; % g
OT_DB(efc).exp_number  = efc;

%% SC = 1; RC = 1 | N045
sc = 1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2352; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171117_132431_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171117_132842_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171117_134854_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171117_141531_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

%% SC = 2; RC = 1 | N046
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2582; % microns

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171117_142434_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171117_145107_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171117_145752_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OT- 10 , efc = 9; 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
efc = efc + 1;

OT_DB(efc).expID  = 10;
OT_DB(efc).expDir  = '_data_20171116';
OT_DB(efc).bird_number  = 20171116;
OT_DB(efc).bird_age  = 42;
OT_DB(efc).bird_DOB  = 20171005;
OT_DB(efc).bird_sex  = 'M';
OT_DB(efc).bird_weight  = 603; % g
OT_DB(efc).exp_number  = efc;


%% SC = 1; RC = 1 | N047
sc = 1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = nan; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171116_124610_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OT- 9 , efc = 10; 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
efc = efc + 1;

OT_DB(efc).expID  = 9;
OT_DB(efc).expDir  = '_data_20171115';
OT_DB(efc).bird_number  = 20171115;
OT_DB(efc).bird_age  = 41;
OT_DB(efc).bird_DOB  = 20171005;
OT_DB(efc).bird_sex  = 'M';
OT_DB(efc).bird_weight  = 567; % g
OT_DB(efc).exp_number  = efc;


%% SC = 1; RC = 1 | N048
sc = 1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 4484; % microns

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171115_175715_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171115_182709_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171115_182926_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OT- 8 , efc = 11; - No Data
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
efc = efc + 1;

OT_DB(efc).expID  = 8;
OT_DB(efc).expDir  = '_data_20171109';
OT_DB(efc).bird_number  = 20171109;
OT_DB(efc).bird_age  = 42;
OT_DB(efc).bird_DOB  = 20170928;
OT_DB(efc).bird_sex  = 'F';
OT_DB(efc).bird_weight  = 545; % g
OT_DB(efc).exp_number  = efc;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OT- 7 , efc = 12; 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
efc = efc + 1;

OT_DB(efc).expID  = 8;
OT_DB(efc).expDir  = '_data_20171108';
OT_DB(efc).bird_number  = 20171108;
OT_DB(efc).bird_age  = 41;
OT_DB(efc).bird_DOB  = 20170928;
OT_DB(efc).bird_sex  = 'M';
OT_DB(efc).bird_weight  = 567; % g
OT_DB(efc).exp_number  = efc;

%% SC = 1; RC = 1 | N049
sc = 1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 1406; % microns

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171108_133247_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

%% SC = 2; RC = 1 | N050
sc = 1+1; 
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2957; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171108_161625_1HzBursts_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OT- 6 , efc = 13 - No Data
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
efc = efc + 1;

OT_DB(efc).expID  = 6;
OT_DB(efc).expDir  = '_data_20171107';
OT_DB(efc).bird_number  = 20171107;
OT_DB(efc).bird_age  = 40;
OT_DB(efc).bird_DOB  = 20170928;
OT_DB(efc).bird_sex  = 'M';
OT_DB(efc).bird_weight  = 532; % g
OT_DB(efc).exp_number  = efc;

%% SC = 1; RC = 1 | N051
sc = 1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2957; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-WNSeach_20171107_142128_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OT- 5 , efc = 14
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
efc = efc + 1;

OT_DB(efc).expID  = 5;
OT_DB(efc).expDir  = '_data_20171102';
OT_DB(efc).bird_number  = 20171102;
OT_DB(efc).bird_age  = 43;
OT_DB(efc).bird_DOB  = 20170920;
OT_DB(efc).bird_sex  = 'F';
OT_DB(efc).bird_weight  = 554; % g
OT_DB(efc).exp_number  = efc;

%% SC = 1; RC = 1 | N052
sc = 1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 1093; % microns

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '2017112_121659_HRTF_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '2017112_12356_tunign_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '2017112_13054_IID_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '2017112_13810_ITD_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

%% SC = 2; RC = 1 | N053
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 1013; % microns

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '2017112_133311_HRTF_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '2017112_135542_tuning_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = 'incomplete';
rsc = rsc +1;

%% SC = 3; RC = 1 | N054
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 823; % microns

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '2017112_14595_HRTF_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

%% SC = 4; RC = 1 | N055
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 1047; % microns

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '2017112_17012-HRTF_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OT- 4 , efc = 15
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
efc = efc + 1;

OT_DB(efc).expID  = 4;
OT_DB(efc).expDir  = '_data_20171101';
OT_DB(efc).bird_number  = 20171101;
OT_DB(efc).bird_age  = 42;
OT_DB(efc).bird_DOB  = 20170920;
OT_DB(efc).bird_sex  = 'F';
OT_DB(efc).bird_weight  = 478; % g
OT_DB(efc).exp_number  = efc;

%% SC = 1; RC = 1 | N056
sc = 1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 1275; % microns

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '2017111_15221_HRTF_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '2017111_152110_Tuning_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '2017111_154648_IID_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '2017111_155050_IID2_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '2017111_155817_ITD_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

%% SC = 2; RC = 1 | N057
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 1474; % microns

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '2017111_165942_HRTF_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '2017111_172159_tuning_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '2017111_174045_IID_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '2017111_174811_ITD_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

%% SC = 3; RC = 1 N058
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 1459; % microns

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '2017111_192433_HRTF_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '2017111_194257_Tuning_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '2017111_20930_ITD_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '2017111_201426_IID_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OT- 3 , efc = 16 - No Data
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
efc = efc + 1;

OT_DB(efc).expID  = 3;
OT_DB(efc).expDir  = '_data_20171031';
OT_DB(efc).bird_number  = 20171031;
OT_DB(efc).bird_age  = 48;
OT_DB(efc).bird_DOB  = 20170913;
OT_DB(efc).bird_sex  = 'F';
OT_DB(efc).bird_weight  = 498; % g
OT_DB(efc).exp_number  = efc;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OT- 2 , efc = 17 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
efc = efc + 1;

OT_DB(efc).expID  = 2;
OT_DB(efc).expDir  = '_data_20171029';
OT_DB(efc).bird_number  = 20171029;
OT_DB(efc).bird_age  = 41;
OT_DB(efc).bird_DOB  = 20170918;
OT_DB(efc).bird_sex  = 'M';
OT_DB(efc).bird_weight  = 550; % g
OT_DB(efc).exp_number  = efc;


%% SC = 1; RC = 1 | 59
sc = 1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 130; % microns

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '20171029_161250_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

%% SC = 2; RC = 1 | N060
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 85; % microns

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '20171029_16292_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;


%% SC = 3; RC = 1 | N061
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 666; % microns

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '20171029_182252_HRTF_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '20171029_1962_TUNING_0001';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;


%% SC = 4; RC = 1 | N062
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 674; % microns

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '20171029_192725_hrtf_0001';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OT- 1 , efc = 18 - No Data
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
efc = efc + 1;

OT_DB(efc).expID  = 1;
OT_DB(efc).expDir  = '_data_20171024';
OT_DB(efc).bird_number  = 20171024;
OT_DB(efc).bird_age  = 41;
OT_DB(efc).bird_DOB  = 20170913;
OT_DB(efc).bird_sex  = 'M';
OT_DB(efc).bird_weight  = 482; % g
OT_DB(efc).exp_number  = efc;

end