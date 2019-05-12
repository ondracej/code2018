function [] = loadAndSave16ChanData()

dbstop if error
dirD = '/';

baseDir = '/media/janie/Data64GB/ZF-59-15/';

FileNames = {
    'exp1_2019-04-28_18-07-21/';
    'exp1_2019-04-28_18-48-02/';
    'exp1_2019-04-28_19-34-00/';
    'exp1_2019-04-28_20-20-36/';
    'exp1_2019-04-28_21-05-19/';
    'exp1_2019-04-28_21-05-36/';
    };

nFiles = numel(FileNames);
saveDir = ['/media/janie/Data64GB/ZF-59-15/Figs/'];

chanSet = [6 11 3 14 1 16 2 15 5 12 4 13 7 10 8 9];

cnt = 1;

fileSelection = 1;

for s = chanSet
    
    %fileAppend = '100_CH10.continuous';
    
    eval(['fileAppend = ''100_CH' num2str(s) '.continuous'';'])
    
    fileName = [baseDir FileNames{fileSelection } fileAppend];
    [pathstr,name,ext] = fileparts(fileName);
    bla = find(fileName == dirD);
    dataName = fileName(bla(end-1)+1:bla(end)-1);
    %saveName = [pathstr dirD dataName '-fullData'];
    [data, timestamps, info] = load_open_ephys_data(fileName);
    Fs = info.header.sampleRate;
    
    
    allData(:, cnt) = data;
    allTimestamps(:, cnt) = timestamps;
    allInfo{cnt} = info;
    
    cnt = cnt +1;
    
end


disp('')



end
