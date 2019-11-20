function [FrogDB] = frogDatabase()


rfc = 1;


if ispc
    DataDir = 'F:\Grass\FrogSleep\';
    dirD = '\';
elseif isunix
    DataDir = [];
    dirD = '/';
end
    
%ElectrodeName = ECog = 1; 
%BrainArea = Pallium = 1; 

%% Cuban Tree Frogs

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cuban Tree Frog #1
%% ECoG Array on Pallium
%% 19 June 2019
%% Light on 5:30 AM, Ligth Off: 9:30 pm
%% (1) CubanTreeFrog1 | 20190619_16-22 *** Cricket hunting

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190619_16-22';
FrogDB(rfc).Session.Date  = '20190619';
FrogDB(rfc).Session.time  = '16-22-xx';
FrogDB(rfc).Session.RecStartTime  = '16:22:00';
FrogDB(rfc).Session.RecDuration  = '00:13:29';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.comments  = 'catching a cricket';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000000486023.mp4', '00000000_0000000000485B60.mp4'}; % Side video first, Overhead 2nd
FrogDB(rfc).Vid.fps= [8.5, 8.5];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (2) CubanTreeFrog1 | 20190619_16-36

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190619_16';
FrogDB(rfc).Session.Date  = '20190619';
FrogDB(rfc).Session.time  = '16-36-xx';
FrogDB(rfc).Session.RecStartTime  = '16:36:00';
FrogDB(rfc).Session.RecDuration  = '00:04:44';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'adjusting cameras';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000000551BE7.mp4', '00000000_00000000005518E9.mp4'};
FrogDB(rfc).Vid.fps= [8.5, 8.5];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (3) CubanTreeFrog1 | 20190619_16-43

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190619_16-43';
FrogDB(rfc).Session.Date  = '20190619';
FrogDB(rfc).Session.time  = '16-43-xx';
FrogDB(rfc).Session.RecStartTime  = '16:43:00';
FrogDB(rfc).Session.RecDuration  = '00:00:29';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'many short videos';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_00000000005BA4B1.mp4', '00000000_00000000005BA25F.mp4'};
FrogDB(rfc).Vid.fps= [8.5, 8.5];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (4) CubanTreeFrog1 |20190619_16-47

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190619_16-47';
FrogDB(rfc).Session.Date  = '20190619';
FrogDB(rfc).Session.time  = '16-47-xx';
FrogDB(rfc).Session.RecStartTime  = '16:47:00';
FrogDB(rfc).Session.RecDuration  = '00:22:14';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'chanign color, adjusting cameras';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_00000000005EEB12.mp4', '00000000_00000000005EE778.mp4'};
FrogDB(rfc).Vid.fps= [8.5, 8.5];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (5) CubanTreeFrog1 | 20190619_17-09 %% Eye Video

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190619_17-09';
FrogDB(rfc).Session.Date  = '20190619';
FrogDB(rfc).Session.time  = '17-09-xx';
FrogDB(rfc).Session.RecStartTime  = '17:09:00';
FrogDB(rfc).Session.RecDuration  = '04:08:58';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'sleeping in corner, nice eye mvmt';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000000073561F.mp4', '00000000_00000000007351BA.mp4'};
FrogDB(rfc).Vid.fps= [8.5, 8.5];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (6) CubanTreeFrog1 | 20190619_21-18 %% In the dark

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190619_21-18';
FrogDB(rfc).Session.Date  = '20190619';
FrogDB(rfc).Session.time  = '21-18-xx';
FrogDB(rfc).Session.RecStartTime  = '21:18:00';
FrogDB(rfc).Session.RecDuration  = '00:56:47';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'nice gular pumping, adjusting cameras';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_00000000015750CB.mp4', '00000000_0000000001574CC4.mp4'};
FrogDB(rfc).Vid.fps= [8.5, 8.5];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (7) CubanTreeFrog1 | 20190619_22-16 - very short %% In the dark

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190619_22-16';
FrogDB(rfc).Session.Date  = '20190619';
FrogDB(rfc).Session.time  = '22-16-xx';
FrogDB(rfc).Session.RecStartTime  = '22:16:00';
FrogDB(rfc).Session.RecDuration  = '00:00:25';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'adjusting cameras';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_00000000018C1585.mp4', '00000000_00000000018C1007.mp4'};
FrogDB(rfc).Vid.fps= [8.5, 8.5];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (8) CubanTreeFrog1 | 20190619_22-18 %% In the dark

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190619_22-18';
FrogDB(rfc).Session.Date  = '20190619';
FrogDB(rfc).Session.time  = '22-18-xx';
FrogDB(rfc).Session.RecStartTime  = '22:18:00';
FrogDB(rfc).Session.RecDuration  = '00:39:28';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'adjusting cameras';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_00000000018EA5E4.mp4', '00000000_00000000018EA1ED.mp4'};
FrogDB(rfc).Vid.fps= [8.5, 8.5];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (9) CubanTreeFrog1 | 20190619_22-58 %%%% Overnight %% In the dark

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190619_22-58';
FrogDB(rfc).Session.Date  = '20190619';
FrogDB(rfc).Session.time  = '22-58-xx';
FrogDB(rfc).Session.RecStartTime  = '22:58:00';
FrogDB(rfc).Session.RecDuration  = '09:32:17';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'overnight, sitting on long; lights on at 6:30am?';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000001B2D40A.mp4', '00000000_0000000001B2CF95.mp4'};
FrogDB(rfc).Vid.fps= [8.5, 8.5];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 20 June 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (10) CubanTreeFrog1 | 20190620_08-36

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190620_08-36';
FrogDB(rfc).Session.Date  = '20190620';
FrogDB(rfc).Session.time  = '08-36-xx';
FrogDB(rfc).Session.RecStartTime  = '08:36:00';
FrogDB(rfc).Session.RecDuration  = '00:17:37';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'moving from wall to under branch';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000003C3B3D3.mp4', '00000000_0000000003C3B039.mp4'};
FrogDB(rfc).Vid.fps= [8.5, 8.5];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (11) CubanTreeFrog1 | 20190620_08-53

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190620_08-53';
FrogDB(rfc).Session.Date  = '20190620';
FrogDB(rfc).Session.time  = '08-53-xx';
FrogDB(rfc).Session.RecStartTime  = '08:53:00';
FrogDB(rfc).Session.RecDuration  = '02:04:51';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'sitting, clise up not v sharp';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000003D3DD46.mp4', '00000000_0000000003D3DA1A.mp4'};
FrogDB(rfc).Vid.fps= [8.5, 8.5];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (12) CubanTreeFrog1 | 20190620_10-58

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190620_10-58';
FrogDB(rfc).Session.Date  = '20190620';
FrogDB(rfc).Session.time  = '10-58-xx';
FrogDB(rfc).Session.RecStartTime  = '10:58:00';
FrogDB(rfc).Session.RecDuration  = '04:25:03';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'sitting, close up under branch';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_00000000044637B0.mp4', '00000000_000000000446330D.mp4'};
FrogDB(rfc).Vid.fps= [8.5, 8.5];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (13) CubanTreeFrog1 | 20190620_15-23

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190620_15-23';
FrogDB(rfc).Session.Date  = '20190620';
FrogDB(rfc).Session.time  = '15-23-xx';
FrogDB(rfc).Session.RecStartTime  = '15:23:00';
FrogDB(rfc).Session.RecDuration  = '01:10:41';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'sitting under a brnach, moves a bit';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000000538EAAB.mp4', '00000000_000000000538E740.mp4'};
FrogDB(rfc).Vid.fps= [8.5, 8.5];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (14) CubanTreeFrog1 | 20190620_16-37

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190620_16-37';
FrogDB(rfc).Session.Date  = '20190620';
FrogDB(rfc).Session.time  = '16-37-xx';
FrogDB(rfc).Session.RecStartTime  = '16:37:00';
FrogDB(rfc).Session.RecDuration  = '00:00:06';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'focusing';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_00000000057CBA79.mp4', '00000000_00000000057CB44F.mp4'};
FrogDB(rfc).Vid.fps= [8.5, 8.5];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (15) CubanTreeFrog1 | 20190620_16-38

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190620_16-38';
FrogDB(rfc).Session.Date  = '20190620';
FrogDB(rfc).Session.time  = '16-38-xx';
FrogDB(rfc).Session.RecStartTime  = '16:38:00';
FrogDB(rfc).Session.RecDuration  = '00:00:19';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'v dark, under branch';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_00000000057D925A.mp4', '00000000_00000000057D8962.mp4'};
FrogDB(rfc).Vid.fps= [8.5, 8.5];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (16) CubanTreeFrog1 | 20190620_16-39

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190620_16-39';
FrogDB(rfc).Session.Date  = '20190620';
FrogDB(rfc).Session.time  = '16-39-xx';
FrogDB(rfc).Session.RecStartTime  = '16:39:00';
FrogDB(rfc).Session.RecDuration  = '00:26:38';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'under branch, mving camera';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_00000000057E9709.mp4', '00000000_00000000057E93DC.mp4'};
FrogDB(rfc).Vid.fps= [8.5, 8.5];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (17) CubanTreeFrog1 | 20190620_17-06 % 10 FPS

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190620_17-06';
FrogDB(rfc).Session.Date  = '20190620';
FrogDB(rfc).Session.time  = '17-06-xx';
FrogDB(rfc).Session.RecStartTime  = '17:06:00';
FrogDB(rfc).Session.RecDuration  = '00:03:54';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'nice focus';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000005970464.mp4', '00000000_00000000059700AB.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (18) CubanTreeFrog1 | 20190620_21-00 

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190620_21-00';
FrogDB(rfc).Session.Date  = '20190620';
FrogDB(rfc).Session.time  = '21-00-xx';
FrogDB(rfc).Session.RecStartTime  = '21:00:00';
FrogDB(rfc).Session.RecDuration  = '00:25:27';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'sitting on branch, adjusting camera';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_00000000066DAEDC.mp4', '00000000_00000000066DAAB5.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (19) CubanTreeFrog1 | 20190620_21-26

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190620_21-26';
FrogDB(rfc).Session.Date  = '20190620';
FrogDB(rfc).Session.time  = '21-26-xx';
FrogDB(rfc).Session.RecStartTime  = '21:26:00';
FrogDB(rfc).Session.RecDuration  = '00:00:32';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'sitting on branch, adjusting camera';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000000685074D.mp4', '00000000_0000000006850394.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (20) CubanTreeFrog1 | 20190620_21-27 %% Overnight, OF calculation

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190620_21-27';
FrogDB(rfc).Session.Date  = '20190620';
FrogDB(rfc).Session.time  = '21-27-xx';
FrogDB(rfc).Session.RecStartTime  = '21:27:00';
FrogDB(rfc).Session.RecDuration  = '11:36:37';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'zoomed out, overnight';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000006858C4C.mp4', '00000000_000000000685891F.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 21 June 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (21) CubanTreeFrog1 | 20190621_09-15 Lights on 8:40 am - Lights off 8:40 pm

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190621_09-15';
FrogDB(rfc).Session.Date  = '20190621';
FrogDB(rfc).Session.time  = '09-15-xx';
FrogDB(rfc).Session.RecStartTime  = '09:15:00';
FrogDB(rfc).Session.RecDuration  = '00:01:10';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'catching cricket';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_00000000090E7CF5.mp4', '00000000_00000000090E792C.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (22) CubanTreeFrog1 | 20190621_09-17

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190621_09-17';
FrogDB(rfc).Session.Date  = '20190621';
FrogDB(rfc).Session.time  = '09-17-xx';
FrogDB(rfc).Session.RecStartTime  = '09:17:00';
FrogDB(rfc).Session.RecDuration  = '02:00:34';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'zoomed out, moving';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_00000000090F98B6.mp4', '00000000_00000000090F94ED.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (23) CubanTreeFrog1 | 20190621_10-45

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190621_10-45';
FrogDB(rfc).Session.Date  = '20190621';
FrogDB(rfc).Session.time  = '10-45-xx';
FrogDB(rfc).Session.RecStartTime  = '10:45:00';
FrogDB(rfc).Session.RecDuration  = '00:03:45';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'moving cameras';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000003A70D5A.mp4', '00000000_0000000003A715F5.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (24) CubanTreeFrog1 | 20190621_10-49

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190621_10-49';
FrogDB(rfc).Session.Date  = '20190621';
FrogDB(rfc).Session.time  = '10-49-xx';
FrogDB(rfc).Session.RecStartTime  = '10:49:00';
FrogDB(rfc).Session.RecDuration  = '01:38:20';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'zoomed in in corner';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000003AA84FC.mp4', '00000000_0000000003AA8819.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (25) CubanTreeFrog1 | 20190621_10-49

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190621_10-49';
FrogDB(rfc).Session.Date  = '20190621';
FrogDB(rfc).Session.time  = '10-49-xx';
FrogDB(rfc).Session.RecStartTime  = '10:49:00';
FrogDB(rfc).Session.RecDuration  = '01:38:20';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'zoomed in in corner';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000003AA84FC.mp4', '00000000_0000000003AA8819.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (26) CubanTreeFrog1 | 20190621_11-17

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190621_11-17';
FrogDB(rfc).Session.Date  = '20190621';
FrogDB(rfc).Session.time  = '11-17-xx';
FrogDB(rfc).Session.RecStartTime  = '11:17:00';
FrogDB(rfc).Session.RecDuration  = '03:06:05';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'sitting in corner, very good';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_00000000097E0FE2.mp4', '00000000_00000000097E0C49.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (27) CubanTreeFrog1 | 20190621_12-28

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190621_12-28';
FrogDB(rfc).Session.Date  = '20190621';
FrogDB(rfc).Session.time  = '12-28-xx';
FrogDB(rfc).Session.RecStartTime  = '12:28:00';
FrogDB(rfc).Session.RecDuration  = '02:51:31';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'zoomed in, jumping away';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_00000000040496C9.mp4', '00000000_0000000004049BE9.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (28) CubanTreeFrog1 | 20190621_15-19

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190621_15-19';
FrogDB(rfc).Session.Date  = '20190621';
FrogDB(rfc).Session.time  = '15-19-xx';
FrogDB(rfc).Session.RecStartTime  = '15:19:00';
FrogDB(rfc).Session.RecDuration  = '02:11:29';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'sitting on branch - cute!';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_00000000040496C9.mp4', '00000000_0000000004049BE9.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (29) CubanTreeFrog1 | 20190621_16-21

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190621_16-21';
FrogDB(rfc).Session.Date  = '20190621';
FrogDB(rfc).Session.time  = '16-21-xx';
FrogDB(rfc).Session.RecStartTime  = '16:21:00';
FrogDB(rfc).Session.RecDuration  = '00:00:33';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'focusing';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000000047BE55.mp4'};
FrogDB(rfc).Vid.fps= [10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (30) CubanTreeFrog1 | 20190621_21-22 - NO Data

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190621_21-22';
FrogDB(rfc).Session.Date  = '20190621';
FrogDB(rfc).Session.time  = '21-22-xx';
FrogDB(rfc).Session.RecStartTime  = '21:22:00';
FrogDB(rfc).Session.RecDuration  = '00:00:00';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'no data, ran out of space';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000000C730CC.mp4', '00000000_0000000000C7357F.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (31) CubanTreeFrog1 | 20190621_21-27 - NO Data

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190621_21-27';
FrogDB(rfc).Session.Date  = '20190621';
FrogDB(rfc).Session.time  = '21-27-xx';
FrogDB(rfc).Session.RecStartTime  = '21:27:00';
FrogDB(rfc).Session.RecDuration  = '00:00:00';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'no data, ran out of space';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000000CBCD57.mp4', '00000000_0000000000CBD13F.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 22 June 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (32) CubanTreeFrog1 | 20190622_17-31

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190622_17-31';
FrogDB(rfc).Session.Date  = '20190622';
FrogDB(rfc).Session.time  = '17-31-xx';
FrogDB(rfc).Session.RecStartTime  = '17:31:00';
FrogDB(rfc).Session.RecDuration  = '02:15:19';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'sitting on a rock in back';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_00000000051A126E.mp4', '00000000_00000000051A14C0.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (33) CubanTreeFrog1 | 20190622_19-46

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190622_19-46';
FrogDB(rfc).Session.Date  = '20190622';
FrogDB(rfc).Session.time  = '19-46-xx';
FrogDB(rfc).Session.RecStartTime  = '19:46:00';
FrogDB(rfc).Session.RecDuration  = '01:16:26';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'great eye mvmt at 93510';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000000595FF29.mp4', '00000000_00000000059602B3.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (34) CubanTreeFrog1 | 20190622_21-03 %% Overnight

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190622_21-03';
FrogDB(rfc).Session.Date  = '20190622';
FrogDB(rfc).Session.time  = '21-03-xx';
FrogDB(rfc).Session.RecStartTime  = '21:03:00';
FrogDB(rfc).Session.RecDuration  = '14:28:13';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'moving around like crazy overnight';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000005DC0445.mp4', '00000000_0000000005DC07D0.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 23 June 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (35) CubanTreeFrog1 | 20190623_11-38

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190623_11-38';
FrogDB(rfc).Session.Date  = '20190623';
FrogDB(rfc).Session.time  = '11-38-xx';
FrogDB(rfc).Session.RecStartTime  = '11:38:00';
FrogDB(rfc).Session.RecDuration  = '00:02:26';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'adjusting cameras';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000008FD216A.mp4', '00000000_0000000008FD2497.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (36) CubanTreeFrog1 | 20190623_11-40

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190623_11-40';
FrogDB(rfc).Session.Date  = '20190623';
FrogDB(rfc).Session.time  = '11-40-xx';
FrogDB(rfc).Session.RecStartTime  = '11:40:00';
FrogDB(rfc).Session.RecDuration  = '05:59:20';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'sitting in corner';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000008FF7CCF.mp4', '00000000_0000000008FF8182.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (37) CubanTreeFrog1 | 20190623_17-40 %% Overnight!!

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190623_17-40';
FrogDB(rfc).Session.Date  = '20190623';
FrogDB(rfc).Session.time  = '17-40-xx';
FrogDB(rfc).Session.RecStartTime  = '17:40:00';
FrogDB(rfc).Session.RecDuration  = '15:14:18';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'adjusting cameras';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000000A48851C.mp4', '00000000_000000000A488A2D.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 24 June 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (38) CubanTreeFrog1 | 20190624_09-01 

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190624_09-01';
FrogDB(rfc).Session.Date  = '20190624';
FrogDB(rfc).Session.time  = '09-01-xx';
FrogDB(rfc).Session.RecStartTime  = '09:01:00';
FrogDB(rfc).Session.RecDuration  = '00:49:51';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'sitting behind dish, grabbing frog for OP';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000000D945BEF.mp4', '00000000_000000000D945F6A.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (39) CubanTreeFrog1 | 20190624_13-42

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190624_13-42';
FrogDB(rfc).Session.Date  = '20190624';
FrogDB(rfc).Session.time  = '2019-06-24_13-42-13';
FrogDB(rfc).Session.RecStartTime  = '13:42:13';
FrogDB(rfc).Session.RecDuration  = '02:34:09';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'connected, close up in foil';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000000E958426.mp4', '00000000_000000000E959685.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 1;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).Session.sampleRate = 30000;
FrogDB(rfc).Session.samples  = 278799360;
FrogDB(rfc).Session.recordingDur_s  = FrogDB(rfc).Session.samples/FrogDB(rfc).Session.sampleRate;
FrogDB(rfc).Session.recordingDur_hr  = FrogDB(rfc).Session.recordingDur_s/3600;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (40) CubanTreeFrog1 | 20190624_16-17

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190624_16-17';
FrogDB(rfc).Session.Date  = '20190624';
FrogDB(rfc).Session.time  = '2019-06-24_16-17-49';
FrogDB(rfc).Session.RecStartTime  = '16:17:49';
FrogDB(rfc).Session.RecDuration  = '00:12:05';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'only overhead video, adding foil';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000000F23F4A1.mp4'};
FrogDB(rfc).Vid.fps= [10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 1;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).Session.sampleRate = 30000;
FrogDB(rfc).Session.samples  = 23287808;
FrogDB(rfc).Session.recordingDur_s  = FrogDB(rfc).Session.samples/FrogDB(rfc).Session.sampleRate;
FrogDB(rfc).Session.recordingDur_hr  = FrogDB(rfc).Session.recordingDur_s/3600;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; 
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 200;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (41) CubanTreeFrog1 | 20190624_16-31

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190624_16-31';
FrogDB(rfc).Session.Date  = '20190624';
FrogDB(rfc).Session.time  = '2019-06-24_16-31-53';
FrogDB(rfc).Session.RecStartTime  = '16:31:53';
FrogDB(rfc).Session.RecDuration  = '00:12:05';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'cute closeup of sleep';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000000F30B595.mp4', '00000000_000000000F30C535.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 1;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).Session.sampleRate = 30000;
FrogDB(rfc).Session.samples  = 50065408;
FrogDB(rfc).Session.recordingDur_s  = FrogDB(rfc).Session.samples/FrogDB(rfc).Session.sampleRate;
FrogDB(rfc).Session.recordingDur_hr  = FrogDB(rfc).Session.recordingDur_s/3600;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (42) CubanTreeFrog1 | 20190624_17-00

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190624_17-00';
FrogDB(rfc).Session.Date  = '20190624';
FrogDB(rfc).Session.time  = '2019-06-24_17-00-35';
FrogDB(rfc).Session.RecStartTime  = '17:00:35';
FrogDB(rfc).Session.RecDuration  = '00:51:31';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'close up of sleep, at end';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Session.sampleRate = 30000;
FrogDB(rfc).Session.samples  = 93370368;
FrogDB(rfc).Session.recordingDur_s  = FrogDB(rfc).Session.samples/FrogDB(rfc).Session.sampleRate;
FrogDB(rfc).Session.recordingDur_hr  = FrogDB(rfc).Session.recordingDur_s/3600;

FrogDB(rfc).Vid.Names = {'00000000_000000000F4AFC44.mp4', '00000000_000000000F4B0B86.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 1;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (43) CubanTreeFrog1 | 20190624_17-53

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190624_17-53';
FrogDB(rfc).Session.Date  = '20190624';
FrogDB(rfc).Session.time  = '2019-06-24_17-53-42';
FrogDB(rfc).Session.RecStartTime  = '17:53:42';
FrogDB(rfc).Session.RecDuration  = '00:51:31';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'moving cameras, some nice closeups';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Session.sampleRate = 30000;
FrogDB(rfc).Session.samples  = 133298176;
FrogDB(rfc).Session.recordingDur_s  = FrogDB(rfc).Session.samples/FrogDB(rfc).Session.sampleRate;
FrogDB(rfc).Session.recordingDur_hr  = FrogDB(rfc).Session.recordingDur_s/3600;

FrogDB(rfc).Vid.Names = {'00000000_000000000F7BAA3E.mp4', '00000000_000000000F7BBB74.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 1;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (44) CubanTreeFrog1 | 20190624_19-14 %% In dark

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190624_19-14';
FrogDB(rfc).Session.Date  = '20190624';
FrogDB(rfc).Session.time  = '2019-06-24_19-14-36';
FrogDB(rfc).Session.RecStartTime  = '19:14:36';
FrogDB(rfc).Session.RecDuration  = '04:15:49';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'nice close ups, some crazy eye movment!!';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Session.sampleRate = 30000;
FrogDB(rfc).Session.samples  = 461294592;
FrogDB(rfc).Session.recordingDur_s  = FrogDB(rfc).Session.samples/FrogDB(rfc).Session.sampleRate;
FrogDB(rfc).Session.recordingDur_hr  = FrogDB(rfc).Session.recordingDur_s/3600;

FrogDB(rfc).Vid.Names = {'00000000_000000000FC5BD50.mp4', '00000000_000000000FC5CCF0.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 1;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.allChs  = [15 14 16 13 10 11 9 12 7 6 8 5  2 3 1 4 ]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [4];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 2500;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 1500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 500;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (45) CubanTreeFrog1 | 20190624_23-36 %% Overnight

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190624_23-36';
FrogDB(rfc).Session.Date  = '20190624';
FrogDB(rfc).Session.time  = '23-36-xx';
FrogDB(rfc).Session.RecStartTime  = '23:36:00';
FrogDB(rfc).Session.RecDuration  = '04:15:49';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'overnight recording, moving and sleeping in corner';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Session.sampleRate = 30000;
FrogDB(rfc).Session.samples  = 461294592;
FrogDB(rfc).Session.recordingDur_s  = FrogDB(rfc).Session.samples/FrogDB(rfc).Session.sampleRate;
FrogDB(rfc).Session.recordingDur_hr  = FrogDB(rfc).Session.recordingDur_s/3600;

FrogDB(rfc).Vid.Names = {'00000000_0000000010B52A87.mp4', '00000000_0000000010B52E6F.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 25 June 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (46) CubanTreeFrog1 |  20190625_08-32

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190625_08-32';
FrogDB(rfc).Session.Date  = '20190625';
FrogDB(rfc).Session.time  = '2019-06-25_08-32-20';
FrogDB(rfc).Session.RecStartTime  = '08:32:20';
FrogDB(rfc).Session.RecDuration  = '04:15:49';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'overnight recording, moving and sleeping in corner';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Session.sampleRate = 30000;
FrogDB(rfc).Session.samples  = 1.2942e+09;
FrogDB(rfc).Session.recordingDur_s  = FrogDB(rfc).Session.samples/FrogDB(rfc).Session.sampleRate;
FrogDB(rfc).Session.recordingDur_hr  = FrogDB(rfc).Session.recordingDur_s/3600;

FrogDB(rfc).Vid.Names = {'00000000_00000000129FF644.mp4', '00000000_0000000012A005F3.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];
FrogDB(rfc).Vid.nFrames= [1293746, 1293625];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 1;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [15];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (47) CubanTreeFrog1 |  20190625_20-31

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190625_20-31';
FrogDB(rfc).Session.Date  = '20190625';
FrogDB(rfc).Session.time  = '20-31-xx';
FrogDB(rfc).Session.RecStartTime  = '20:31:00';
FrogDB(rfc).Session.RecDuration  = '03:12:45';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'did not record ephys, movign around with cable attached';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000015326C3E.mp4', '00000000_0000000015327E21.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (48) CubanTreeFrog1 | 20190625_23-36 %% Overnight

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190625_23-36';
FrogDB(rfc).Session.Date  = '20190625';
FrogDB(rfc).Session.time  = '23-36-xx';
FrogDB(rfc).Session.RecStartTime  = '23:36:00';
FrogDB(rfc).Session.RecDuration  = '08:47:04';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'overnight, moving around, staying in corner';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000010B52A87.mp4', '00000000_0000000010B52E6F.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 26 June 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (49) CubanTreeFrog1 | 20190626_08-55

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190626_08-55';
FrogDB(rfc).Session.Date  = '20190626';
FrogDB(rfc).Session.time  = '05-55-xx';
FrogDB(rfc).Session.RecStartTime  = '05:55:00';
FrogDB(rfc).Session.RecDuration  = '08:47:04';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'focusing cameras, crawling around while connected';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000017DAFF2C.mp4', '00000000_0000000017DB041E.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%
%% (50) CubanTreeFrog1 | 20190626_09-00

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190626_09-00';
FrogDB(rfc).Session.Date  = '20190626';
FrogDB(rfc).Session.time  = '2019-06-26_09-00-01';
FrogDB(rfc).Session.RecStartTime  = '09:00:01';
FrogDB(rfc).Session.RecDuration  = '14:07:33';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'sitting in hole and sleeping';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000017DFC2B7.mp4', '00000000_0000000017DFD3CE.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 1;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [15];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%
%% (51) CubanTreeFrog1 | 20190626_23-14

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190626_23-14';
FrogDB(rfc).Session.Date  = '20190626';
FrogDB(rfc).Session.time  = '2019-06-26_23-14-21';
FrogDB(rfc).Session.RecStartTime  = '23:14:21';
FrogDB(rfc).Session.RecDuration  = '00:00:00';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'debugging noise, lots of videos...';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000001AFE5ECF.mp4', '00000000_000000001AF2F721.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 1;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%
%% (52) CubanTreeFrog1 | 20190626_23-50

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190626_23-50';
FrogDB(rfc).Session.Date  = '20190626';
FrogDB(rfc).Session.time  = '2019-06-26_23-50-16';
FrogDB(rfc).Session.RecStartTime  = '23:50:16';
FrogDB(rfc).Session.RecDuration  = '01:15:19';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'frog sitting htere, squirted h20 on it';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000001B0EB3C7.mp4', '00000000_000000001B0EC069.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 1;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4];
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 27 June 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (53) CubanTreeFrog1 | 20190626_01-09 %% Overnight, no ephys

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190626_01-09';
FrogDB(rfc).Session.Date  = '20190627';
FrogDB(rfc).Session.time  = '01-09-xx';
FrogDB(rfc).Session.RecStartTime  = '01:09:00';
FrogDB(rfc).Session.RecDuration  = '01:15:19';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'sitting in corner on wall behind water all night';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000001B56F297.mp4', '00000000_000000001B56F6BD.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-FrogDB(rfc).Plotting.hpRectOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpRectOffset];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (54) CubanTreeFrog1 | 20190627_08-43

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190627_08-43';
FrogDB(rfc).Session.Date  = '20190627';
FrogDB(rfc).Session.time  = '2019-06-27_08-43-09';
FrogDB(rfc).Session.RecStartTime  = '08:43:09';
FrogDB(rfc).Session.RecDuration  = '13:13:15';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'sitting under the log';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000001CF689B4.mp4', '00000000_000000001CF69992.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 1;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (55) CubanTreeFrog1 | 20190627_22-00 Overnight

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190627_22-00';
FrogDB(rfc).Session.Date  = '20190627';
FrogDB(rfc).Session.time  = '22-00-xx';
FrogDB(rfc).Session.RecStartTime  = '22:00:00';
FrogDB(rfc).Session.RecDuration  = '11:35:54';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'climbing around, ends up in corner';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000001FD0498F.mp4', '00000000_000000001FD04D58.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 28 June 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (56) CubanTreeFrog1 | 20190628_10-01

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190628_10-01';
FrogDB(rfc).Session.Date  = '20190628';
FrogDB(rfc).Session.time  = '2019-06-28_10-01-21';
FrogDB(rfc).Session.RecStartTime  = '10:01:21';
FrogDB(rfc).Session.RecDuration  = '10:39:10';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'sitting in one place, moves to corner';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000002264899B.mp4', '00000000_0000000022649534.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 1;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [15];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (57) CubanTreeFrog1 | 20190628_20-44 - overnight

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190628_20-44';
FrogDB(rfc).Session.Date  = '20190628';
FrogDB(rfc).Session.time  = '20-44-xx';
FrogDB(rfc).Session.RecStartTime  = '20:44:00';
FrogDB(rfc).Session.RecDuration  = '14:50:39';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'hiding under foil';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000024B134D3.mp4', '00000000_0000000024B13A90.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 29 June 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (58) CubanTreeFrog1 | 20190629_11-35

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190629_11-35';
FrogDB(rfc).Session.Date  = '20190629';
FrogDB(rfc).Session.time  = '11-35-xx';
FrogDB(rfc).Session.RecStartTime  = '11:35:00';
FrogDB(rfc).Session.RecDuration  = '09:53:17';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'crawls out from under foil';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000027E116CB.mp4', '00000000_0000000027E11AA3.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (59) CubanTreeFrog1 | 20190629_21-28

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190629_21-28';
FrogDB(rfc).Session.Date  = '20190629';
FrogDB(rfc).Session.time  = '21-28-xx';
FrogDB(rfc).Session.RecStartTime  = '21:28:00';
FrogDB(rfc).Session.RecDuration  = '13:38:39';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'under foil';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000002A004C32.mp4', '00000000_000000002A004FFA.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% June 30 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (60) CubanTreeFrog1 | 20190630_11-07

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190630_11-07';
FrogDB(rfc).Session.Date  = '20190630';
FrogDB(rfc).Session.time  = '11-07-xx';
FrogDB(rfc).Session.RecStartTime  = '11:07:00';
FrogDB(rfc).Session.RecDuration  = '00:50:55';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'under foil';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000002CEDD387.mp4', '00000000_000000002CEDD6F2.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (61) CubanTreeFrog1 | 20190630_12-08

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190630_12-08';
FrogDB(rfc).Session.Date  = '20190630';
FrogDB(rfc).Session.time  = '2019-06-30_12-08-52';
FrogDB(rfc).Session.RecStartTime  = '12:08:00';
FrogDB(rfc).Session.RecDuration  = '00:50:55';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'connected, adjusting cables';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000002D261591.mp4', '00000000_000000002D2618FC.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (62) CubanTreeFrog1 | 20190630_12-53

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190630_12-53';
FrogDB(rfc).Session.Date  = '20190630';
FrogDB(rfc).Session.time  = '2019-06-30_12-53-20';
FrogDB(rfc).Session.RecStartTime  = '12:53:20';
FrogDB(rfc).Session.RecDuration  = '03:45:11';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'connected, only overhead';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000002D4EE4A6.mp4'};
FrogDB(rfc).Vid.fps= [30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (63) CubanTreeFrog1 | 20190630_16-39

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190630_16-39';
FrogDB(rfc).Session.Date  = '20190630';
FrogDB(rfc).Session.time  = '2019-06-30_16-39-14';
FrogDB(rfc).Session.RecStartTime  = '16:39:14';
FrogDB(rfc).Session.RecDuration  = '16:32:53';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'connected overnight, moves around a bit';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000002E1D90EA.mp4', '00000000_000000002E1D931C.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [15];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% July 01 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (64) CubanTreeFrog1 | 20190701_09-15

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190701_09-15';
FrogDB(rfc).Session.Date  = '20190701';
FrogDB(rfc).Session.time  = '2019-07-01_09-15-37';
FrogDB(rfc).Session.RecStartTime  = '09:15:37';
FrogDB(rfc).Session.RecDuration  = '00:04:11';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'connected, closeup of eye, v short';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000031ADD3EA.mp4', '00000000_0000000031ADD87E.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 1;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (65) CubanTreeFrog1 | 20190701_09-21

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190701_09-21';
FrogDB(rfc).Session.Date  = '20190701';
FrogDB(rfc).Session.time  = '09-21-xx';
FrogDB(rfc).Session.RecStartTime  = '09:21:00';
FrogDB(rfc).Session.RecDuration  = '12:13:57';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'closeup of eye, rearragning cameras';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000031B35602.mp4', '00000000_0000000031B35A96.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (66) CubanTreeFrog1 |20190701_21-35 %% Overnigtht

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190701_21-35';
FrogDB(rfc).Session.Date  = '20190701';
FrogDB(rfc).Session.time  = '21-35-xx';
FrogDB(rfc).Session.RecStartTime  = '21:35:00';
FrogDB(rfc).Session.RecDuration  = '12:13:57';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'closeup of eye, rearragning cameras';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_00000000345355A0.mp4', '00000000_0000000034535AF0.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% July 2 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (67) CubanTreeFrog1 |20190702_14-09

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190702_14-09';
FrogDB(rfc).Session.Date  = '20190702';
FrogDB(rfc).Session.time  = '14-09-xx';
FrogDB(rfc).Session.RecStartTime  = '14:09:00';
FrogDB(rfc).Session.RecDuration  = '00:33:36';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'frog on log';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000037E17880.mp4', '00000000_0000000037E17BEB.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (68) CubanTreeFrog1 | 20190702_14-43

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190702_14-43';
FrogDB(rfc).Session.Date  = '20190702';
FrogDB(rfc).Session.time  = '14-43-51';
FrogDB(rfc).Session.RecStartTime  = '14:43:51';
FrogDB(rfc).Session.RecDuration  = '02:19:25';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'breathing connected in front of camera';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000003800D510.mp4', '00000000_000000003800D937.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (69) CubanTreeFrog1 | 20190702_17-03

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190702_17-03';
FrogDB(rfc).Session.Date  = '20190702';
FrogDB(rfc).Session.time  = '2019-07-02_17-03-52';
FrogDB(rfc).Session.RecStartTime  = '17:03:52';
FrogDB(rfc).Session.RecDuration  = '15:34:07';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'connected in front of camera, moving around';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000003880E8D8.mp4', '00000000_000000003880EE37.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [15];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% July 3 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (70) CubanTreeFrog1 | 20190703_10-25

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190703_10-25';
FrogDB(rfc).Session.Date  = '20190703';
FrogDB(rfc).Session.time  = '10-25-54';
FrogDB(rfc).Session.RecStartTime  = '10:25:54';
FrogDB(rfc).Session.RecDuration  = '01:36:45';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'eye in front of camera';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000003C3AE127.mp4', '00000000_000000003C3AE6E4.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 1;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (71) CubanTreeFrog1 | 20190703_12-03

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190703_12-03';
FrogDB(rfc).Session.Date  = '20190703';
FrogDB(rfc).Session.time  = '12-03-48';
FrogDB(rfc).Session.RecStartTime  = '12:03:48';
FrogDB(rfc).Session.RecDuration  = '01:41:37';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'connected, moving around';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000003C9498BE.mp4', '00000000_000000003C949D52.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 1;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (72) CubanTreeFrog1 | 20190703_13-47

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190703_13-47';
FrogDB(rfc).Session.Date  = '20190703';
FrogDB(rfc).Session.time  = '13-47-07';
FrogDB(rfc).Session.RecStartTime  = '13:47:07';
FrogDB(rfc).Session.RecDuration  = '01:41:37';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'short, eye and breathing, adding h2o';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000003CF33BEA.mp4', '00000000_000000003CF34021.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 1;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (73) CubanTreeFrog1 | 20190703_13-53

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190703_13-53';
FrogDB(rfc).Session.Date  = '20190703';
FrogDB(rfc).Session.time  = '13-53-xx';
FrogDB(rfc).Session.RecStartTime  = '13:53:00';
FrogDB(rfc).Session.RecDuration  = '03:23:15';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'in bath, moving around, nice poses';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000003CF90434.mp4', '00000000_000000003CF90731.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (74) CubanTreeFrog1 | 20190703_17-21

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190703_17-21';
FrogDB(rfc).Session.Date  = '20190703';
FrogDB(rfc).Session.time  = '17-21-04';
FrogDB(rfc).Session.RecStartTime  = '17:21:04';
FrogDB(rfc).Session.RecDuration  = '01:39:45';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'breathing, jumping, moving around';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000003DB6F718.mp4', '00000000_000000003DB6FB3E.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 1;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (75) CubanTreeFrog1 |20190703_19-04 %5 Overnight, 

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190703_19-04';
FrogDB(rfc).Session.Date  = '20190703';
FrogDB(rfc).Session.time  = '19-04-xx';
FrogDB(rfc).Session.RecStartTime  = '19:04:00';
FrogDB(rfc).Session.RecDuration  = '01:39:45';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'Overnight, moving around, camera zoomed out';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000003E1511EA.mp4', '00000000_000000003E1516EB.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% July 4 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (76) CubanTreeFrog1 |20190704_09-13 %5 Overnight, 

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190704_09-13';
FrogDB(rfc).Session.Date  = '20190704';
FrogDB(rfc).Session.time  = '09-13-xx';
FrogDB(rfc).Session.RecStartTime  = '09:13:00';
FrogDB(rfc).Session.RecDuration  = '24:54:59';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'All day and overnight, camera zoomed out';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_00000000411EA780.mp4', '00000000_00000000411EAADB.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% July 5 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (76) CubanTreeFrog1 | 20190705_10-08 

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190705_10-08';
FrogDB(rfc).Session.Date  = '20190705';
FrogDB(rfc).Session.time  = '10-08-xx';
FrogDB(rfc).Session.RecStartTime  = '10:08:00';
FrogDB(rfc).Session.RecDuration  = '24:54:59';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'sitting on wall';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000046776498.mp4', '00000000_00000000467768BE.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (77) CubanTreeFrog1 | 20190705_12-14 

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190705_12-14';
FrogDB(rfc).Session.Date  = '20190705';
FrogDB(rfc).Session.time  = '2019-07-05_12-14-59';
FrogDB(rfc).Session.RecStartTime  = '12:14:59';
FrogDB(rfc).Session.RecDuration  = '08:54:30';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'great eye data';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000046EB7D3C.mp4', '00000000_0000000046EB822E.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 1;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (78) CubanTreeFrog1 | 20190705_12-14  %% overnight

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190705_21-10';
FrogDB(rfc).Session.Date  = '20190705';
FrogDB(rfc).Session.time  = '2019-07-05_21-10-08';
FrogDB(rfc).Session.RecStartTime  = '21:10:08';
FrogDB(rfc).Session.RecDuration  = '08:54:30';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'great eye data, overnight';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000048D5BC98.mp4', '00000000_0000000048D5C060.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% July 6 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (79) CubanTreeFrog1 | 20190706_13-52  

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190706_13-52';
FrogDB(rfc).Session.Date  = '20190706';
FrogDB(rfc).Session.time  = '2019-07-06_13-52-24';
FrogDB(rfc).Session.RecStartTime  = '13:52:24';
FrogDB(rfc).Session.RecDuration  = '02:44:11';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'great eye data';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'13-52_Sideview_00008_converted.avi', '13-52_Overhead_00007_converted.avi'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 1;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (80) CubanTreeFrog1 | 20190706_16-37

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190706_16-37';
FrogDB(rfc).Session.Date  = '20190706';
FrogDB(rfc).Session.time  = '2019-07-06_16-37-28';
FrogDB(rfc).Session.RecStartTime  = '16:37:28';
FrogDB(rfc).Session.RecDuration  = '05:04:22';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'great eye data';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'16-37_SideView_00009_converted.avi', '16-37_Overhead_00008_converted.avi'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 1;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (81) CubanTreeFrog1 | 20190706_21-48

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190706_21-48';
FrogDB(rfc).Session.Date  = '20190706';
FrogDB(rfc).Session.time  = '21-48-xx';
FrogDB(rfc).Session.RecStartTime  = '21:48:00';
FrogDB(rfc).Session.RecDuration  = '11:56:50';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'moving around, in back corner';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'21-48_SideView_00011_converted.avi', '21-48_Overhead_00010_converted.avi'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% July 7 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (82) CubanTreeFrog1 | 20190707_09-46

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190707_09-46';
FrogDB(rfc).Session.Date  = '20190707';
FrogDB(rfc).Session.time  = '09-46-xx';
FrogDB(rfc).Session.RecStartTime  = '09:46:00';
FrogDB(rfc).Session.RecDuration  = '23:44:18';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'moving around, in back corner';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'09-46_SideView_00012_converted.avi', '09-46_Overhead_00011_converted.avi'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% July 8 2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (83) CubanTreeFrog1 | 20190708_09-32

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190708_09-32';
FrogDB(rfc).Session.Date  = '20190708';
FrogDB(rfc).Session.time  = '09-32-xx';
FrogDB(rfc).Session.RecStartTime  = '09:32:00';
FrogDB(rfc).Session.RecDuration  = '10:47:45';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'moving around, in back corner';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'09-32_SideView_00013_converted.avi', '09-32_Overhead_00012_converted.avi'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (84) CubanTreeFrog1 | 20190708_09-XX __ Update

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190708_XXXX';
FrogDB(rfc).Session.Date  = '20190708';
FrogDB(rfc).Session.time  = '09-32-xxXX';
FrogDB(rfc).Session.RecStartTime  = '09:32:00';
FrogDB(rfc).Session.RecDuration  = '10:47:45';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'moving around, in back corner';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'Overhead_00013.avi', 'SideView_00014.avi'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% July 9
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (85) CubanTreeFrog1 | 20190709_10-17

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190709_10-17';
FrogDB(rfc).Session.Date  = '20190709';
FrogDB(rfc).Session.time  = '10-17-xx';
FrogDB(rfc).Session.RecStartTime  = '10:17:00';
FrogDB(rfc).Session.RecDuration  = '11:06:20';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'closeup sitting on log';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'SideView_00015_10-17_converted.avi', 'Overhead_00014_10-17_converted.avi'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% July 10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (86) CubanTreeFrog1 | 20190710_09-56

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190710_09-56';
FrogDB(rfc).Session.Date  = '20190710';
FrogDB(rfc).Session.time  = '2019-07-10_09-56-32';
FrogDB(rfc).Session.RecStartTime  = '09:56:32';
FrogDB(rfc).Session.RecDuration  = '11:09:55';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'closeup of eye';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_00000000140EE449.mp4', '00000000_00000000140EE8ED.mp4'};
FrogDB(rfc).Vid.fps= [10, 10];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (87) CubanTreeFrog1 | 20190710_21-08

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190710_21-08';
FrogDB(rfc).Session.Date  = '20190710';
FrogDB(rfc).Session.time  = '2019-07-10_21-08-16';
FrogDB(rfc).Session.RecStartTime  = '21:08:16';
FrogDB(rfc).Session.RecDuration  = '11:09:55';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'closeup of eye';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000016749ECA.mp4', '00000000_000000001674A30F.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% July 11
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (88) CubanTreeFrog1 | 20190711_08-25 - v short

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190711_08-25';
FrogDB(rfc).Session.Date  = '20190711';
FrogDB(rfc).Session.time  = '2019-07-11_08-25-22';
FrogDB(rfc).Session.RecStartTime  = '08:25:22';
FrogDB(rfc).Session.RecDuration  = '00:00:41';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'closeup of eye';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000018E08E19.mp4', '00000000_0000000018E090D8.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 1;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (89) CubanTreeFrog1 | 20190711_08-27

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190711_08-27';
FrogDB(rfc).Session.Date  = '20190711';
FrogDB(rfc).Session.time  = '2019-07-11_08-27-02';
FrogDB(rfc).Session.RecStartTime  = '08:27:02';
FrogDB(rfc).Session.RecDuration  = '02:54:19';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'moving onto log';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000018E211EA.mp4', '00000000_0000000018E21768.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 1;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (90) CubanTreeFrog1 | 20190711_11-24

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190711_11-24';
FrogDB(rfc).Session.Date  = '20190711';
FrogDB(rfc).Session.time  = '2019-07-11_11-24-35';
FrogDB(rfc).Session.RecStartTime  = '11:24:35';
FrogDB(rfc).Session.RecDuration  = '09:39:32';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'awesome dilation of pupil at 9:13:39';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000001984A06A.mp4', '00000000_000000001984A3E5.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 1;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (90) CubanTreeFrog1 | 20190711_21-04 %% Overnight

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190711_21-04';
FrogDB(rfc).Session.Date  = '20190711';
FrogDB(rfc).Session.time  = '2019-07-11_21-04-40';
FrogDB(rfc).Session.RecStartTime  = '21:04:40';
FrogDB(rfc).Session.RecDuration  = '12:47:00';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'moving around, in and out of camera';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000001B97BF75.mp4', '00000000_000000001B97C428.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 1;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% July 12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (91) CubanTreeFrog1 | 20190712_11-15 

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190712_11-15';
FrogDB(rfc).Session.Date  = '20190712';
FrogDB(rfc).Session.time  = '11-15-xx';
FrogDB(rfc).Session.RecStartTime  = '11:15:00';
FrogDB(rfc).Session.RecDuration  = '00:02:25';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'v Short';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000001EA26A91.mp4', '00000000_000000001EA26F44.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (92) CubanTreeFrog1 | 20190712_11-17

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190712_11-17';
FrogDB(rfc).Session.Date  = '20190712';
FrogDB(rfc).Session.time  = '11-17-xx';
FrogDB(rfc).Session.RecStartTime  = '11:17:00';
FrogDB(rfc).Session.RecDuration  = '06:04:58';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'on wall, closeup in bath';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000001EA4AED4.mp4', '00000000_000000001EA4B25E.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (93) CubanTreeFrog1 | 20190712_17-22

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190712_17-22';
FrogDB(rfc).Session.Date  = '20190712';
FrogDB(rfc).Session.time  = '17-22-xx';
FrogDB(rfc).Session.RecStartTime  = '17:22:00';
FrogDB(rfc).Session.RecDuration  = '19:50:56';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'ovenring, lowering head as sleeping??';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000001FF2E9C2.mp4', '00000000_000000001FF2ED4C.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% July 13
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (94) CubanTreeFrog1 | 20190713_13-13

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190713_13-13';
FrogDB(rfc).Session.Date  = '20190713';
FrogDB(rfc).Session.time  = '13-13-xx';
FrogDB(rfc).Session.RecStartTime  = '13:13:00';
FrogDB(rfc).Session.RecDuration  = '05:50:15';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'lowering head as sleeping??';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_0000000024354AC8.mp4', '00000000_000000002435515F.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (95) CubanTreeFrog1 | 20190713_19-04 %% Overnight

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190713_19-04';
FrogDB(rfc).Session.Date  = '20190713';
FrogDB(rfc).Session.time  = '19-04-xx';
FrogDB(rfc).Session.RecStartTime  = '19:04:00';
FrogDB(rfc).Session.RecDuration  = '16:31:24';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'moving around, climbing walls';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000002575FCBE.mp4', '00000000_00000000257600A6.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% July 14
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (96) CubanTreeFrog1 | 20190714_11-35

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190714_11-35';
FrogDB(rfc).Session.Date  = '20190714';
FrogDB(rfc).Session.time  = '11-35-xx';
FrogDB(rfc).Session.RecStartTime  = '11:35:00';
FrogDB(rfc).Session.RecDuration  = '00:05:37';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'short, cleaning, sitting in dish';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000002901AE5F.mp4', '00000000_000000002901B1D9.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (97) CubanTreeFrog1 | 20190714_12-00

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190714_12-00';
FrogDB(rfc).Session.Date  = '20190714';
FrogDB(rfc).Session.time  = '2019-07-14_12-00-29';
FrogDB(rfc).Session.RecStartTime  = '12:00:29';
FrogDB(rfc).Session.RecDuration  = '00:05:37';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'videos???';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'00000000_000000002901AE5F.mp4', '00000000_000000002901B1D9.mp4'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (97) CubanTreeFrog1 | 20190714_12-03 %% Superlong overnight

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog1';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'ECoG';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190714_12-03';
FrogDB(rfc).Session.Date  = '20190714';
FrogDB(rfc).Session.time  = '2019-07-14_12-03-51';
FrogDB(rfc).Session.RecStartTime  = '12:03:51';
FrogDB(rfc).Session.RecDuration  = '21:12:10';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'moving around, not always in focus';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'12-03_Sideview_20190714_00032_converted.avi', '12-03_Sideview_20190714_00032_converted-short_001.avi'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [9];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 5000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 9000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%

%%
%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (101) CubanTreeFrog2 | 20190723_15-03

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog2';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'inSitu-16Chan';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190723_15-03';
FrogDB(rfc).Session.Date  = '20190723';
FrogDB(rfc).Session.time  = '2019-07-23_15-03-38';
FrogDB(rfc).Session.RecStartTime  = '13:03:38';
FrogDB(rfc).Session.RecDuration  = '21:12:10';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'moving around, not always in focus';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'12-03_Sideview_20190714_00032_converted.avi', '12-03_Sideview_20190714_00032_converted-short_001.avi'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [14];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 4000;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [0 6000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;


%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (102) CubanTreeFrog2 | 20190723_15-03

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog2';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'inSitu-16Chan';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190723_16-45';
FrogDB(rfc).Session.Date  = '20190723';
FrogDB(rfc).Session.time  = '2019-07-23_16-45-24';
FrogDB(rfc).Session.RecStartTime  = '16:45:24';
FrogDB(rfc).Session.RecDuration  = '21:12:10';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'moving around, not always in focus';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'12-03_Sideview_20190714_00032_converted.avi', '12-03_Sideview_20190714_00032_converted-short_001.avi'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [14];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;

FrogDB(rfc).Plotting.rawOffset = 600;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-500 2000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (103) CubanTreeFrog2 | 20190723_15-03

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog2';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'inSitu-16Chan';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190723_20-03';
FrogDB(rfc).Session.Date  = '20190723';
FrogDB(rfc).Session.time  = '2019-07-23_20-03-20';
FrogDB(rfc).Session.RecStartTime  = '20:03:30';
FrogDB(rfc).Session.RecDuration  = '21:12:10';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'moving around, not always in focus';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'12-03_Sideview_20190714_00032_converted.avi', '12-03_Sideview_20190714_00032_converted-short_001.avi'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [14];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;


FrogDB(rfc).Plotting.rawOffset = 600;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-500 2000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (104) CubanTreeFrog2 | 20190724_09-52

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog2';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'inSitu-16Chan';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190724_09-52';
FrogDB(rfc).Session.Date  = '20190724';
FrogDB(rfc).Session.time  = '2019-07-24_09-52-08';
FrogDB(rfc).Session.RecStartTime  = '09:52:08';
FrogDB(rfc).Session.RecDuration  = '21:12:10';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'moving around, not always in focus';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'12-03_Sideview_20190714_00032_converted.avi', '12-03_Sideview_20190714_00032_converted-short_001.avi'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [14];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;


FrogDB(rfc).Plotting.rawOffset = 600;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-500 2000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (105) CubanTreeFrog2 | 20190724_09-59

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog2';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'inSitu-16Chan';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190724_09-59';
FrogDB(rfc).Session.Date  = '20190724';
FrogDB(rfc).Session.time  = '2019-07-24_09-59-14';
FrogDB(rfc).Session.RecStartTime  = '09:59:14';
FrogDB(rfc).Session.RecDuration  = '21:12:10';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'moving around, not always in focus';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'12-03_Sideview_20190714_00032_converted.avi', '12-03_Sideview_20190714_00032_converted-short_001.avi'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [14];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;


FrogDB(rfc).Plotting.rawOffset = 600;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-500 2000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (106) CubanTreeFrog2 | 20190724_19-15

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog2';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'inSitu-16Chan';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190724_19-15';
FrogDB(rfc).Session.Date  = '20190724';
FrogDB(rfc).Session.time  = '2019-07-24_19-15-37';
FrogDB(rfc).Session.RecStartTime  = '19:15:37';
FrogDB(rfc).Session.RecDuration  = '21:12:10';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'moving around, not always in focus';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'12-03_Sideview_20190714_00032_converted.avi', '12-03_Sideview_20190714_00032_converted-short_001.avi'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [14];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;


FrogDB(rfc).Plotting.rawOffset = 600;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-500 2000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (107) CubanTreeFrog2 | 20190724_21-06

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog2';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'inSitu-16Chan';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190724_21-06';
FrogDB(rfc).Session.Date  = '20190724';
FrogDB(rfc).Session.time  = '2019-07-24_21-06-20';
FrogDB(rfc).Session.RecStartTime  = '21:06:20';
FrogDB(rfc).Session.RecDuration  = '21:12:10';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'moving around, not always in focus';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'12-03_Sideview_20190714_00032_converted.avi', '12-03_Sideview_20190714_00032_converted-short_001.avi'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [14];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;


FrogDB(rfc).Plotting.rawOffset = 600;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-500 2000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (108) CubanTreeFrog2 | 20190724_21-19 - corrupted

FrogDB(rfc).INFO.Name  = 'CubanTreeFrog2';
FrogDB(rfc).INFO.ID  = 1;
FrogDB(rfc).INFO.Weight_g  = 28;
FrogDB(rfc).INFO.electrodeType  = 1; % 
FrogDB(rfc).INFO.electrodeName  = 'inSitu-16Chan';
FrogDB(rfc).INFO.brainAreaN  = 1; 
FrogDB(rfc).INFO.brainAreaName  = 'Pallium';

FrogDB(rfc).Session.Dir  = '20190724_21-19';
FrogDB(rfc).Session.Date  = '20190724';
FrogDB(rfc).Session.time  = '2019-07-24_21-19-14';
FrogDB(rfc).Session.RecStartTime  = '21:19:14';
FrogDB(rfc).Session.RecDuration  = '21:12:10';
FrogDB(rfc).Session.RecStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = [];
FrogDB(rfc).Session.TempStopTime  = []; 
FrogDB(rfc).Session.comments  = 'moving around, not always in focus';
FrogDB(rfc).Session.n = rfc;

FrogDB(rfc).Vid.Names = {'12-03_Sideview_20190714_00032_converted.avi', '12-03_Sideview_20190714_00032_converted-short_001.avi'};
FrogDB(rfc).Vid.fps= [30, 30];

FrogDB(rfc).DIR.base = [DataDir FrogDB(rfc).INFO.Name dirD FrogDB(rfc).Session.Date dirD];
FrogDB(rfc).DIR.ephysDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Ephys' dirD FrogDB(rfc).Session.time dirD];
FrogDB(rfc).DIR.videoDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Videos' dirD];
FrogDB(rfc).DIR.temperatureDir = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Temperature' dirD];
FrogDB(rfc).DIR.plotDir  = [FrogDB(rfc).DIR.base FrogDB(rfc).Session.Dir dirD 'Plots' dirD];

FrogDB(rfc).REC.hasVideo = 1;
FrogDB(rfc).REC.hasEphys = 0;
FrogDB(rfc).REC.hasTemp = 0;
FrogDB(rfc).REC.hasEMG  = 0;
FrogDB(rfc).REC.hasEKG  = 0;

%FrogDB(rfc).REC.allChs  = [15 10 7 2 14 11 6 3 16 9 8 1 13 12 5 4]; %% %Organized by rows (P-A)
FrogDB(rfc).REC.allChs  = [2 3 1 4 7 6 8 5 10 11 9 12 15 14 16 13]; %% Organized by columns (M-L)
FrogDB(rfc).REC.nChs  = numel(FrogDB(rfc).REC.allChs);
FrogDB(rfc).REC.bestChs  = [5];
FrogDB(rfc).REC.triggerChan  = ['ADC1'];
FrogDB(rfc).REC.cscEMG  = [];
FrogDB(rfc).REC.cscEKG  = 0;


FrogDB(rfc).Plotting.rawOffset = 300;
FrogDB(rfc).Plotting.rawYlim = [-FrogDB(rfc).Plotting.rawOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.rawOffset];
FrogDB(rfc).Plotting.hpRectOffset = 500;
FrogDB(rfc).Plotting.hpRectYlim = [-500 1000];
FrogDB(rfc).Plotting.hpOffset = 100;
FrogDB(rfc).Plotting.hpYlim = [-FrogDB(rfc).Plotting.hpOffset FrogDB(rfc).REC.nChs*FrogDB(rfc).Plotting.hpOffset];

FrogDB(rfc).DB.D_CutoffFreq  = 4;
FrogDB(rfc).DB.B_lowFreq  = 15;
FrogDB(rfc).DB.B_hiFreq  = 40;
FrogDB(rfc).DB.G_lowFreq  = 50;
FrogDB(rfc).DB.G_hiFreq  = 80;

rfc = rfc+1;


