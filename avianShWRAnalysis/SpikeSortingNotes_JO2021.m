%% Janies Spike Sorting Notes Nov 2021


%% Convert OEPS to Bin

dataDir = 'G:\SWR\ZF-72-01\20210225\15-05-52\Ephys\';
chanMap = [2 1 5 11 14 4 8 7 15 16 6 12 13 3 9 10]; % tetrode shanks, by depth 

% 13 3 9 10
% 15 16 6 12
% 14 4 8 7 
% 2 1 5 11

convertOpenEphysToRawBinary_JO(dataDir, chanMap);  % convert data, only for OpenEphys

   
%% Create Chan Map for Kilosort 2.5

%% 4 Shank probe Ver 1

Nchannels = 16;
connected = true(Nchannels, 1);
chanMap   = 1:Nchannels;
chanMap0ind = chanMap - 1;

xcoords   = repmat([1 2 3 4]', 1, Nchannels/4);
xcoords   = xcoords(:);
ycoords   = repmat(1:Nchannels/4, 4, 1);
ycoords   = ycoords(:);
kcoords   = ones(Nchannels,1); % grouping of channels (i.e. tetrode groups)

fs = 30000; % sampling frequency
save('E:\Data\ProbeFiles\4ShankChanMap.mat', ...
    'chanMap','connected', 'xcoords', 'ycoords', 'kcoords', 'chanMap0ind', 'fs')

%% Kilosort Config File

ops.chanMap             = "E:\Data\ProbeFiles\4ShankChanMap.mat";
% ops.chanMap = 1:ops.Nchan; % treated as linear probe if no chanMap file

% sample rate
ops.fs = 30000;  

% frequency for high pass filtering (150)
ops.fshigh = 300;   

% threshold on projections (like in Kilosort1, can be different for last pass like [10 4])
ops.Th = [10 4];  

% how important is the amplitude penalty (like in Kilosort1, 0 means not used, 10 is average, 50 is a lot) 
%ops.lam = 10;  
ops.lam = 2;  

% splitting a cluster at the end requires at least this much isolation for each sub-cluster (max = 1)
ops.AUCsplit = 0.9; 

% minimum spike rate (Hz), if a cluster falls below this for too long it gets removed
%ops.minFR = 1/50; 
ops.minFR = 0.17; 

% number of samples to average over (annealed from first to second value) 
ops.momentum = [20 400]; 

% spatial constant in um for computing residual variance of spike
%ops.sigmaMask = 30; 
ops.sigmaMask = 30; 

% threshold crossings for pre-clustering (in PCA projection space)
%ops.ThPre = 8; 
ops.ThPre = 10; 

% spatial scale for datashift kernel
%ops.sig = 20;
ops.sig = 40;

% type of data shifting (0 = none, 1 = rigid, 2 = nonrigid)
ops.nblocks = 0;

%ops.nt0 = 61; %unit of samples , must be less than 81
ops.nt0 = 61; %unit of samples , must be less than 81

%% danger, changing these settings can lead to fatal errors
% options for determining PCs
ops.spkTh           = -6;      % spike threshold in standard deviations (-6)
ops.reorder         = 1;       % whether to reorder batches for drift correction. 
ops.nskip           = 25;  % how many batches to skip for determining spike PCs

ops.GPU                 = 1; % has to be 1, no CPU version yet, sorry
% ops.Nfilt               = 1024; % max number of clusters
ops.nfilt_factor        = 4; % max number of clusters per good channel (even temporary ones)
ops.ntbuff              = 64;    % samples of symmetrical buffer for whitening and spike detection
ops.NT                  = 64*1024+ ops.ntbuff; % must be multiple of 32 + ntbuff. This is the batch size (try decreasing if out of memory). 
ops.whiteningRange      = 32; % number of channels to use for whitening each channel
ops.nSkipCov            = 25; % compute whitening matrix from every N-th batch
ops.scaleproc           = 200;   % int16 scaling of whitened data
ops.nPCs                = 3; % how many PCs to project the spikes into
ops.useRAM              = 0; % not yet available

%% Run Kilosort with params


main_kilosort




