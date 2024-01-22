function [meta] = ReadMeta(binName, paths)

% Create the matching metafile name
% [~,name,~] = fileparts(binName);
metaName = strrep(binName, '.bin', '.meta');

% Parse ini file into cell entries C{1}{i} = C{2}{i}
fid = fopen(fullfile(paths, metaName), 'r');
% -------------------------------------------------------------
%    Need 'BufSize' adjustment for MATLAB earlier than 2014
%    C = textscan(fid, '%[^=] = %[^\r\n]', 'BufSize', 32768);
C = textscan(fid, '%[^=] = %[^\r\n]');
% -------------------------------------------------------------
fclose(fid);

% New empty struct
meta = struct();

% Convert each cell entry into a struct entry
for i = 1:length(C{1})
    tag = C{1}{i};
    if tag(1) == '~'
        % remake tag excluding first character
        tag = sprintf('%s', tag(2:end));
    end
    meta = setfield(meta, tag, C{2}{i});
end
end % ReadMeta