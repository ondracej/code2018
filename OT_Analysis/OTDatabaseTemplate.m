%% SC = ; RC = 
sc = sc+1;
rsc = 1;

% Recording Session Counter
OT_DB(efc).RS(sc).recording_session = sc;
OT_DB(efc).RS(sc).DV_coords = []; % microns

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% IID
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 3;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'IID';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '03-';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% ITD
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 4;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'ITD';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '04-';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% Tuning
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 2;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'Tuning';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '02-';
%OT_DB(efc).RS(sc).nReps(rsc) = 20;
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% HRTF
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 1;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'HRTF';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '01-';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;

% WN - WNSeach 
OT_DB(efc).RS(sc).StimProtocol_ID(rsc) = 5;
OT_DB(efc).RS(sc).StimProtocol_name{rsc} = 'WhiteNoise';
OT_DB(efc).RS(sc).ResultDirName{rsc} = '05-';
OT_DB(efc).RS(sc).notes{rsc} = '';
rsc = rsc +1;
