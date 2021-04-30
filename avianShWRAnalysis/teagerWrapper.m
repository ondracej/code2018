

dataDir = 'D:\TUM\SWR-Project\ZF-59-15\20190428\19-34-00\Ephys';
chanMap = [2 7 15 10 13 12 14 11 1 8 16 9 3 6 4 5]; % For this , first channel is on the top
%5, 4, 6, 3, 9, 16, 8, 1, 11, 14, 12, 13, 10, 15, 7, 2
Coeff = 4;
%%
%[spwT, spws, rippT, ripps, eeg, time] = spw_r_detect(varargin)
[spwT, spws, rippT, ripps, eeg, time] = spw_r_detect(dataDir,chanMap, Coeff);

