function [subdir, path] = get_subfolders(path)

subdir = dir(path);

% sort by timestamp
%[~,i] = sort([subdir.datenum]);
% subdir = subdir(i);

% only consider folders and neglect single files
isdir = [subdir.isdir]; 
subdir = subdir(isdir); 

% neglect the first two entries
subdir = {subdir(3:end).name}; % neglect first two empty entries
end

