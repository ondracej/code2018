dbstop if error

test = '/home/janie/Data/100_AUX1.continuous';
dirD = '/';
%%
%[pathstr,name,ext] = fileparts(fileName);
[pathstr,name,ext] = fileparts(test);
bla = find(test == dirD);
dataName = test(bla(end-1)+1:bla(end)-1);
saveName = [pathstr dirD dataName '-fullData'];
%%
disp('Loading Data...')
tic
%[data, timestamps, info] = load_open_ephys_data(test);
[data, timestamps, info] = load_open_ephys_data_faster(test, 'unscaledInt16');
toc

%Fs = info.header.sampleRate;

%fObj = filterData(Fs);
%%