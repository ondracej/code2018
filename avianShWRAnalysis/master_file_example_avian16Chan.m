% default options are in parenthesis after the comment

close all
clear all
dbstop if error

%%
addpath(genpath('C:\Users\Administrator\Documents\code\GitHub\KiloSort\')) % path to kilosort folder
addpath(genpath('C:\Users\Administrator\Documents\code\GitHub\npy-matlab\')) % path to npy-matlab scripts

pathToYourConfigFile = 'F:\TUM\SWR-Project\KiloSortConfigFiles\'; % take from Github folder and put it somewhere else (together with the master_file)
run(fullfile(pathToYourConfigFile, 'StandardConfig_avian16Chan.m'))
%% Chan Config
%{
Nchannels = 16;
connected = true(Nchannels, 1);
%chanMap   = [6 11 3 14 1 16 2 15 5 12 4 13 7 10 8 9];
chanMap   = [1:Nchannels];
chanMap0ind = chanMap - 1;
xcoords   = ones(Nchannels,1);
ycoords   = 50 * [1:16]; % 50 micron space,
kcoords   = ones(Nchannels,1); % grouping of channels (i.e. tetrode groups)

fs = 30000; % sampling frequency
save('F:\TUM\SWR-Project\KiloSortConfigFiles\', 'chanMap','connected', 'xcoords', 'ycoords', 'kcoords', 'chanMap0ind', 'fs')

%}
%%
tic; % start timer
%
if ops.GPU
    gpuDevice(1); % initialize GPU (will erase any existing GPU arrays)
end

if strcmp(ops.datatype , 'openEphys')
    disp('Converting openephys file...')
    ops = convertOpenEphysToRawBInary(ops);  % convert data, only for OpenEphys
end
    disp('Finished...')
%
%%
disp('Pre-processing...')
[rez, DATA, uproj] = preprocessData(ops); % preprocess data and extract spikes for initialization
disp('Fitting templates...')
rez                = fitTemplates(rez, DATA, uproj);  % fit templates iteratively
disp('Extracting final spike times...')
rez                = fullMPMU(rez, DATA);% extract final spike times (overlapping extraction)

% AutoMerge. rez2Phy will use for clusters the new 5th column of st3 if you run this)
%     rez = merge_posthoc2(rez);

% save matlab results file
save(fullfile(ops.root,  'rez.mat'), 'rez', '-v7.3');

% save python results file for Phy
rezToPhy(rez, ops.root);

% remove temporary file
delete(ops.fproc);

disp('Finished')

%%
