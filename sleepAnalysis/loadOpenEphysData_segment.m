function [] = loadOpenEphysData_segment()
dbstop if error
dirD = '\';
%filename = 'C:\Users\Administrator\Documents\Data\SWR-Project\ZF-72-81\eeg-lfpChronic_2019-05-16_23-21-04\100_CH13.continuous';


%%
%t_start_s = 20;
%dur_s = 40;

%%
% Janies hack

%[data, timestamps, info] = load_open_ephys_data_segment(filename, t_start_s, dur_s);

%%

baseDir = 'C:\Users\Administrator\Documents\Data\SWR-Project\ZF-72-81\eeg-lfpChronic_2019-05-16_23-21-04\';
chanSet = [2 3 6 7 9 10 11 13 14 15 16]; % can loead 4 channels before memory crashes
cnt = 1;

for s = chanSet
    
    eval(['fileAppend = ''100_CH' num2str(s) '.continuous'';'])
    
    fileName = [baseDir fileAppend];
    [pathstr,name,ext] = fileparts(fileName);
    
    bla = find(fileName == dirD);
    dataName = fileName(bla(end-1)+1:bla(end)-1);
    
    disp(['ch-' num2str(s)]);
    tic
    [data(cnt,:), timestamps(cnt,:), info] = load_open_ephys_data(fileName);
    %[data(cnt,:), timestamps(cnt,:), info] = load_open_ephys_data_faster(fileName, 'unscaledInt16'); % made it through 6 chans
    toc
    
    fs = info.header.sampleRate;
    
    %allData(:, cnt) = data;
    %allTimestamps(:, cnt) = timestamps;
    %allInfo{cnt} = info;
    
    cnt = cnt +1;
    
end

disp('')
%{
 
Fs = info.header.sampleRate;

tic
[data, timestamps, info] = load_open_ephys_data(filename); % data in microvolts
toc




[data, timestamps, info] = load_open_ephys_data_faster(filename, 'unscaledInt16');



% [data, timestamps, info] = load_open_ephys_data(filename, [outputFormat])

%                   outputFormat: (optional) If omitted, continuous data is output in double format and is scaled to reflect microvolts.
%                   If this argument is 'unscaledInt16' and the file contains continuous data, the output data will be in
%                   int16 format and will not be scaled; this data must be manually converted to a floating-point format
%                   and multiplied by info.header.bitVolts to obtain microvolt values. This feature is intended to save memory
%                   for operations involving large amounts of data.
disp('')


%}



end
