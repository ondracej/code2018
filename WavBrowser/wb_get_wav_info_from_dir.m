function[] = wb_get_wav_info_from_dir(spc, wav_file_dir, DirD)

wav_file_list = dir(fullfile(wav_file_dir, '*.wav'));

how_many_files = size(wav_file_list, 1);
list_of_names = cell(how_many_files, 1);

%% Populate the list of wav file names

for j = 1 : how_many_files
    list_of_names{j, :} = wav_file_list(j, :).name;
end

BOS_folder_name = 'BOS';
BOS_wav_dir = [wav_file_dir BOS_folder_name DirD];

setappdata(spc, 'wav_file_list', wav_file_list);
setappdata(spc, 'how_many_files', how_many_files);
setappdata(spc, 'list_of_names', list_of_names);

setappdata(spc, 'BOS_folder_name', BOS_folder_name);
setappdata(spc, 'BOS_wav_dir', BOS_wav_dir);

setappdata(spc, 'current_file', 0);
end
