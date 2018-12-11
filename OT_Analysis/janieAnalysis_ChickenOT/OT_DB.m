 [OT_DB] = OT_database()

%% Chicken OT database

% Raw Exp Counter
efc = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% OT- 12

OT_DB(efc).expID  = 12;
OT_DB(efc).bird_number  = 20171204;
OT_DB(efc).bird_age  = [];
OT_DB(efc).bird_DOB  = 20171023;
OT_DB(efc).bird_sex  = 'F';
OT_DB(efc).bird_weight  = 452; % g
OT_DB(efc).exp_number  = efc;

%%
sc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = 2086; % microns

rsc  = 1;
%% Stimulus Protocol
% Stim Protocol: (1) HRTF; (2) Tuning; (3) IID; (4) ITD; (5) WN

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-HRTF_20171204_150652_0001';
OT_DB(efc).RS(sc).nReps(rsc) = 5;
%raw_data_file_db(efc).RS(rsc).level = 100; % dB
OT_DB(efc).RS(sc).notes{rsc} = 'Big spike is an offset neuron';

rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-IID_20171204_153003_0001';
OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';

rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-ITD_20171204_153355_0001';
OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';

rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-Tuning_20171204_153931_0001';
OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = 'spiking getting smaller, losing cell';

rsc = rsc +1;


%%
