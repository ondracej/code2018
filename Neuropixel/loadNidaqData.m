close all
clear all
addpath(genpath('C:\Users\Neuropix\Documents\code\Github\npy-matlab-master\'));

%%
% nidaq_binName = 'Rec_6_22_11_2021_g0_t0.nidq.bin';
% nidaq_path = 'X:\CorinnaNeuropixSleepData\data\MicBirds\blackCyan\';
% csvFile = [nidaq_path 'bird_sleep_states.csv'];

%%
% nidaq_binName = 'raw_g4_t0.nidq.bin';
% nidaq_path = 'X:\CorinnaNeuropixSleepData\data\MicBirds\j8v8\';
% csvFile = [nidaq_path 'bird_sleep_states.csv'];

%%
% nidaq_binName = 'Rec_28_06_2022_g0_t0.nidq.bin';
% nidaq_path = 'X:\CorinnaNeuropixSleepData\data\MicBirds\noLabel\';
% csvFile = [nidaq_path 'bird_sleep_states.csv'];
%%
% nidaq_binName = 'Rec_13_03_2022_g0_t0.nidq.bin';
% nidaq_path = 'X:\CorinnaNeuropixSleepData\data\MicBirds\redred\';
% csvFile = [nidaq_path 'bird_sleep_states.csv'];

%%
% nidaq_binName = 'sleep_theReal_g0_t0.nidq.bin';
% nidaq_path = 'X:\CorinnaNeuropixSleepData\data\MicBirds\r5n5\';
% csvFile = [nidaq_path 'bird_sleep_states.csv'];
%%
nidaq_binName = 'raw_g0_t0.nidq.bin';
nidaq_path = 'X:\CorinnaNeuropixSleepData\data\MicBirds\r15v5\';
csvFile = [nidaq_path 'bird_sleep_states.csv'];

%% Open up bird_sleep_states.csv
delimiter = ',';

% Read columns of data as text:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%*q%*q%q%[^\n\r]';

% Open the text file.
fileID = fopen(csvFile,'r');

% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string',  'ReturnOnError', false);

% Close the text file.
fclose(fileID);

% Convert the contents of columns containing numeric text to numbers.
% Replace non-numeric text with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

% Converts text in the input cell array to numbers. Replaced non-numeric
% text with NaN.
rawData = dataArray{1};
for row=1:size(rawData, 1)
    % Create a regular expression to detect and remove non-numeric prefixes and
    % suffixes.
    regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
    try
        result = regexp(rawData(row), regexstr, 'names');
        numbers = result.numbers;
        
        % Detected commas in non-thousand locations.
        invalidThousandsSeparator = false;
        if numbers.contains(',')
            thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
            if isempty(regexp(numbers, thousandsRegExp, 'once'))
                numbers = NaN;
                invalidThousandsSeparator = true;
            end
        end
        % Convert numeric text to numbers.
        if ~invalidThousandsSeparator
            numbers = textscan(char(strrep(numbers, ',', '')), '%f');
            numericData(row, 1) = numbers{1};
            raw{row, 1} = numbers{1};
        end
    catch
        raw{row, 1} = rawData{row};
    end
end

%R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
%raw(R) = {NaN}; % Replace non-numeric cells

states = numericData(:, 1);
states  = states(2:end);
%%
[nidaq_meta] = ReadMeta(nidaq_binName, nidaq_path);

fs_ni = str2double(nidaq_meta.niSampRate);
nSamp = floor(str2num(nidaq_meta.fileTimeSecs) * fs_ni);
nidaq_dataArray = ReadBin(1, nSamp, nidaq_meta, nidaq_binName, nidaq_path);

MicChan = nidaq_dataArray(1,:);
%figure
%plot(MicChan)

timepoints = 1:1:numel(MicChan);
timepoints_s = timepoints/fs_ni;

%timepoints_s(end)
%%
figure(100); clf
subplot(2, 1, 1)
plot(timepoints_s, MicChan);
axis tight
title('Microphone')
xlabel ('Time (s)')

subplot(2, 1, 2)
plot(states, 'linestyle', 'none', 'marker', '.', 'color', 'r')
axis tight
ylim([-1 2])
title('State')
xlabel ('Time (s)')


%%
