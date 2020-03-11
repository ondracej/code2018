%% you need to change most of the paths in this block
 
%addpath(genpath('D:\GitHub\KiloSort2')) % path to kilosort folder
addpath(genpath('C:\Users\Janie\Documents\GitHub\Kilosort2'))

%addpath('D:\GitHub\npy-matlab') % for converting to Phy
addpath('C:\Users\Janie\Documents\GitHub\npy-matlab')

%rootZ = 'G:\drift_simulations\test'; % the raw data binary file is in this folder

%rootZ = 'D:\TUM\SWR-Project\ZF-59-15\20190428\19-34-00\dat\KilosortPhy'; % the raw data binary file is in this folder
rootZ = 'D:\TUM\SWR-Project\ZF-72-96\20200108\13-57-02\dat';

rootH = rootZ;
pathToYourConfigFile = 'C:\Users\Janie\Documents\GitHub\code2018\avianShWRAnalysis\KS2_configFiles'; % take from Github folder and put it somewhere else (together with the master_file)

%chanMapFile = 'Linear16x1_kilosortChanMap_allConnected.mat';
chanMapFile = 'Linear16x1_kilosortChanMap_0Disconnected.mat';


%rootH = 'H:\'; % path to temporary binary file (same size as data, should be on fast SSD)
%rootH = 'D:\TUM\SWR-Project\ZF-71-76\20190915\20-01-48\dat'; % path to temporary binary file (same size as data, should be on fast SSD)
%pathToYourConfigFile = 'D:\GitHub\KiloSort2\configFiles'; % take from Github folder and put it somewhere else (together with the master_file)


%%
ops.trange = [0 Inf]; % time range to sort
ops.NchanTOT    = 16; % total number of channels in your recording

run(fullfile(pathToYourConfigFile, 'StandardConfig_JO_acute_v1.m'))
ops.fproc       = fullfile(rootH, 'temp_wh.dat'); % proc file on a fast SSD
ops.chanMap = fullfile(pathToYourConfigFile, chanMapFile);

%% this block runs all the steps of the algorithm
fprintf('Looking for data inside %s \n', rootZ)

% is there a channel map file in this folder?
fs = dir(fullfile(rootZ, 'chan*.mat'));
if ~isempty(fs)
    ops.chanMap = fullfile(rootZ, fs(1).name);
end

% find the binary file
fs          = [dir(fullfile(rootZ, '*.bin')) dir(fullfile(rootZ, '*.dat'))];
ops.fbinary = fullfile(rootZ, fs(1).name);

% preprocess data to create temp_wh.dat
rez = preprocessDataSub(ops);
%rez.temp.Nbatch = rez.ops.Nbatch;
%rez.temp.Nbatch = 20000;
%gpuDevice(1) 
% time-reordering as a function of drift
%rez.temp.Nbatch = round(rez.temp.Nbatch/2);
rez = clusterSingleBatches(rez);

% saving here is a good idea, because the rest can be resumed after loading rez
save(fullfile(rootZ, 'rez.mat'), 'rez', '-v7.3');

% main tracking and template matching algorithm
rez = learnAndSolve8b(rez);

% final merges
rez = find_merges(rez, 1);

% final splits by SVD
rez = splitAllClusters(rez, 1);

% final splits by amplitudes
rez = splitAllClusters(rez, 0);

% decide on cutoff
rez = set_cutoff(rez);

fprintf('found %d good units \n', sum(rez.good>0))

% write to Phy
fprintf('Saving results to Phy  \n')
rezToPhy(rez, rootZ);

%% if you want to save the results to a Matlab file...

% discard features in final rez file (too slow to save)
rez.cProj = [];
rez.cProjPC = [];

% save final results as rez2
fprintf('Saving final results in rez2  \n')
fname = fullfile(rootZ, 'rez2.mat');
save(fname, 'rez', '-v7.3');
