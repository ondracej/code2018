
Nchannels = 32;
connected = true(Nchannels, 1);
chanMap   = 1:Nchannels;
chanMap0ind = chanMap - 1;
xcoords   = ones(Nchannels,1);
ycoords   = [1:Nchannels]';
kcoords   = ones(Nchannels,1); % grouping of channels (i.e. tetrode groups)

fs = 25000; % sampling frequency
save('C:\DATA\Spikes\20150601_chan32_4_900s\chanMap.mat', ...
    'chanMap','connected', 'xcoords', 'ycoords', 'kcoords', 'chanMap0ind', 'fs')


%%
 
dataDir = 'G:\SWR\ZF-72-01\20210225\15-05-52\Ephys\';
%chanMap = [10 12 7 11 9 6 8 5 3 16 4 1 13 15 14 2]; % tetrode shanks, by columns, medial to lateral
chanMap = [2 1 5 11 14 4 8 7 15 16 6 12 13 3 9 10]; % tetrode shanks, by columns, medial to lateral

convertOpenEphysToRawBinary_JO(dataDir, chanMap);  % convert data, only for OpenEphys

   



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

%% 4 Shank probe Ver 2
Nchannels = 16;
connected = true(Nchannels, 1);
chanMap   = 1:Nchannels;
chanMap0ind = chanMap - 1;

ycoords   = repmat([1 2 3 4]', 1, Nchannels/4);
ycoords   = ycoords(:);
xcoords   = repmat(1:Nchannels/4, 4, 1);
xcoords   = xcoords(:);
kcoords   = ones(Nchannels,1); % grouping of channels (i.e. tetrode groups)

fs = 30000; % sampling frequency
save('E:\Data\ProbeFiles\4ShankChanMapVer2.mat', ...
    'chanMap','connected', 'xcoords', 'ycoords', 'kcoords', 'chanMap0ind', 'fs')

%% 4 Shank probe Ver 3
Nchannels = 16;
connected = true(Nchannels, 1);
chanMap   = 1:Nchannels;
chanMap0ind = chanMap - 1;

ycoords   = repmat([4 3 2 1]', 1, Nchannels/4);
ycoords   = ycoords(:);
%xcoords   = repmat(1:Nchannels/4, 4, 1);
%xcoords   = xcoords(:);
xcoords   = [4 4 4 4 3 3 3 3 2 2 2 2 1 1 1 1]';
kcoords   = ones(Nchannels,1); % grouping of channels (i.e. tetrode groups)

fs = 30000; % sampling frequency
save('E:\Data\ProbeFiles\4ShankChanMapVer3.mat', ...
    'chanMap','connected', 'xcoords', 'ycoords', 'kcoords', 'chanMap0ind', 'fs')
