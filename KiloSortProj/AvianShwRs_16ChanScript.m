
% Make a copy of master_file_example_MOVEME.m and \configFiles\StandardConfig_MOVEME.m and put them in the directory with your data.

%%

%pathToData = 'F:\TUM\SWR-Project\Chick-10\Ephys\2019-04-27_19-33-33\';

%% Path to Spikes - not used?
%pathToSpikes = [pathToData 'SPIKES\'];

%if exist(pathToSpikes , 'dir') == 0
%    mkdir(pathToSpikes);
%    disp(['Created: '  pathToSpikes])
%end


%% Make Channel map

%{
% Generate a channel map file for your probe using \configFiles\createChannelMap.m as a starting point.
% create a channel Map file for simulated data (eMouse)

% here I know a priori what order my channels are in.  So I just manually 
% make a list of channel indices (and give
% an index to dead channels too). chanMap(1) is the row in the raw binary
% file for the first channel. chanMap(1:2) = [33 34] in my case, which happen to
% be dead channels. 

% the first thing Kilosort does is reorder the data with data = data(chanMap, :).
% Now we declare which channels are "connected" in this normal ordering, 
% meaning not dead or used for non-ephys data

% now we define the horizontal (x) and vertical (y) coordinates of these
% 34 channels. For dead or nonephys channels the values won't matter. Again
% I will take this information from the specifications of the probe. These
% are in um here, but the absolute scaling doesn't really matter in the
% algorithm. 

% Often, multi-shank probes or tetrodes will be organized into groups of
% channels that cannot possibly share spikes with the rest of the probe. This helps
% the algorithm discard noisy templates shared across groups. In
% this case, we set kcoords to indicate which group the channel belongs to.
% In our case all channels are on the same shank in a single group so we
% assign them all to group 1. 

% at this point in Kilosort we do data = data(connected, :), ycoords =
% ycoords(connected), xcoords = xcoords(connected) and kcoords =
% kcoords(connected) and no more channel map information is needed (in particular
% no "adjacency graphs" like in KlustaKwik). 
% Now we can save our channel map for the eMouse. 

% would be good to also save the sampling frequency here
%}
%{
Nchannels = 16;
connected = true(Nchannels, 1);
chanMap   = [6 11 3 14 1 16 2 15 5 12 4 13 7 10 8 9];
chanMap0ind = chanMap - 1;
xcoords   = ones(Nchannels,1);
ycoords   = 50 * [1:16]; % 50 micron space, 
kcoords   = ones(Nchannels,1); % grouping of channels (i.e. tetrode groups)

fs = 30000; % sampling frequency
save(pathToData, 'chanMap','connected', 'xcoords', 'ycoords', 'kcoords', 'chanMap0ind', 'fs')
%}

%% Copy Config files
%stdCfgPath = 'C:\Users\Administrator\Documents\code\GitHub\KiloSort\configFiles\StandardConfig_MOVEME.m';
%MstFilePath = 'C:\Users\Administrator\Documents\code\GitHub\KiloSort\master_file_example_MOVEME.m';

%copyfile(stdCfgPath, pathToData)
%copyfile(MstFilePath, pathToData)



%% Edit the config File

% Edit the config file with desired parameters. You should at least set the file paths 
%(ops.fbinary, ops.fproc (this file will not exist yet - kilosort will create it), and ops.root), the sampling frequency (ops.fs), 
%the number of channels in the file (ops.NchanTOT), the number of channels to be included in the sorting (ops.Nchan), 
%the number of templates you want kilosort to produce (ops.Nfilt), and the location of your channel map file (ops.chanMap).

dbstop if error
clear all

pathToConfigFile = 'F:\TUM\SWR-Project\KiloSortConfigFiles\';
configName = 'StandardConfig_avian16Chan.m';

%fpath = 'F:\TUM\SWR-Project\Chick-10\Ephys\2019-04-27_19-33-33\';

% Run the config file
run(fullfile(pathToConfigFile, configName)) % this will create the 'ops' variable

% use GPUs

useGPU = 1; % do you have a GPU? Kilosorting 1000sec of 32chan simulated data takes 55 seconds on gtx 1080 + M2 SSD.

%% Edit the master file
% Edit master_file so that the paths at the top (lines 3-4) point to your local copies of those github repositories, 
%and so that the configuration file is correctly specified (lines 6-7).

%% Run KiloSort

[rez, DATA, uproj] = preprocessData(ops); % preprocess data and extract spikes for initialization
rez                = fitTemplates(rez, DATA, uproj);  % fit templates iteratively
rez                = fullMPMU(rez, DATA);% extract final spike times (overlapping extraction)

%%  not necessary
% This runs the benchmark script. It will report both 1) results for the
% clusters as provided by Kilosort (pre-merge), and 2) results after doing the best
% possible merges (post-merge). This last step is supposed to
% mimic what a user would do in Phy, and is the best achievable score
% without doing splits. 
benchmark_simulation(rez, fullfile(fpath, 'eMouseGroundTruth.mat'));


%%
% save python results file for Phy

%mkdir preAutoMerge
preDir = [fpath 'preAutoMerge\'];
mkdir(preDir)

%rezToPhy(rez, [fpath,'preAutoMerge\']);
rezToPhy(rez, preDir);

fprintf('Kilosort took %2.2f seconds vs 72.77 seconds on GTX 1080 + M2 SSD \n', toc)


%% Now run phy







% now fire up Phy and check these results. There should still be manual
% work to be done (mostly merges, some refinements of contaminated clusters). 
%% AUTO MERGES 
% after spending quite some time with Phy checking on the results and understanding the merge and split functions, 
% come back here and run Kilosort's automated merging strategy. This block
% will overwrite the previous results and python files. Load the results in
% Phy again: there should be no merges left to do (with the default simulation), but perhaps a few splits
% / cleanup. On realistic data (i.e. not this simulation) there will be drift also, which will usually
% mean there are merges left to do even after this step. 
% Kilosort's AUTO merges should not be confused with the "best" merges done inside the
% benchmark (those are using the real ground truth!!!)

rez = merge_posthoc2(rez);
benchmark_simulation(rez, fullfile(fpath, 'eMouseGroundTruth.mat'));

% save python results file for Phy
postDir = [fpath 'postAutoMerge\'];
mkdir(postDir)
%mkdir postAutoMerge
%rezToPhy(rez, [fpath,'postAutoMerge\']);
rezToPhy(rez, postDir);

%% save and clean up
% save matlab results file for future use (although you should really only be using the manually validated spike_clusters.npy file)
save(fullfile(fpath,  'rez.mat'), 'rez', '-v7.3');

% remove temporary file
delete(ops.fproc);
%%
