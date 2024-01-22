function[] = wav_browser(wav_file_dir)

if nargin <1
    %% Enter the directory path
    
    wav_file_dir = 'Z:\JanieData\SongbirdSongs\Julia-makeSound\Data\w014\BOS\';
end

%%
dbstop if error

if ispc
    dirD = '\';
elseif isunix
    dirD = '/';
end

good_wavs_dir = [wav_file_dir 'Edited' dirD];
%
% if exist(good_wavs_dir , 'dir') == 0
%     mkdir(good_wavs_dir );
% end

%DirD = directoryDelimiter;


%% As the user for the wav file directory

%     prompt = {'Please input the wav file directory:'};
%     dlsg_title = 'Wav file directory';
%     num_lines = 1;
%     def = {'/home/janie/Data/Songs/Finished/71-75/Data/2021-05-05/'};
%     wav_file_dir = inputdlg(prompt,dlsg_title,num_lines,def);
%     wav_file_dir = [cell2mat(wav_file_dir) DirD];

%% Define the bird name from the wav file directory

% "wav_file_dir" contains the bird name
%dirseparators = (wav_file_dir == DirD);

% where's does the bird names start?
%dirseparators = find(dirseparators == 1, 2, 'last');
%bird_name = wav_file_dir(dirseparators(1) + 1 : dirseparators(2) - 1);

%% Define the sorted wav file directories

%good_wavs_dir = '/home/janie/Data/Songs/Finished/71-75/Data/2021-05-05/testDir1/';
%bad_wavs_dir = '/home/janie/Data/Songs/Finished/71-75/Data/2021-05-05/testDir1/';

%% Other parameters

% Arbitrary spectrogram scale
spec_scale = 0.2;

% Set figure handle
spc = figure(100);

%% Get/Set some info about the wav files in the directory


wav_file_list = dir(fullfile(wav_file_dir, '*.wav'));

how_many_files = size(wav_file_list, 1);
list_of_names = cell(how_many_files, 1);

%% Populate the list of wav file names

for j = 1 : how_many_files
    list_of_names{j, :} = wav_file_list(j, :).name;
end

%BOS_folder_name = 'BOS';
%BOS_wav_dir = [wav_file_dir BOS_folder_name DirD];

setappdata(spc, 'wav_file_list', wav_file_list);
setappdata(spc, 'how_many_files', how_many_files);
setappdata(spc, 'list_of_names', list_of_names);

%setappdata(spc, 'BOS_folder_name', BOS_folder_name);
%setappdata(spc, 'BOS_wav_dir', BOS_wav_dir);

setappdata(spc, 'current_file', 0);


%% Set all the spc info

% Set directory information
setappdata(spc, 'wav_file_dir', wav_file_dir);
setappdata(spc, 'good_wavs_dir', good_wavs_dir);
%setappdata(spc, 'bad_wavs_dir', bad_wavs_dir);
setappdata(spc, 'DirD', dirD);

% Set bird/file parameters
%setappdata(spc, 'bird_name', bird_name);
setappdata(spc, 'current_file', 0);

% Set good/bad file counters
setappdata(spc, 'sc_g', 1);
%setappdata(spc, 'sc_b', 1);

% Others
setappdata(spc, 'spec_scale', spec_scale);
scrsz = get(0,'ScreenSize');
set(spc, 'Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);

%% Key Press Function!

set(spc, 'KeyPressFcn', {@wb_wav_browser_key_press, spc});

end