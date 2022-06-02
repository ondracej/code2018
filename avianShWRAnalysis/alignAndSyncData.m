function [] = alignAndSyncData()


spikeGlxToolsCode = 'C:\Users\Neuropix\Documents\GitHub\SpikeGLX_Datafile_Tools';

addpath(genpath(spikeGlxToolsCode));

%%

%lfp_bin = 'Z:\JanieData\Neuropixel\w050\raw_04_LH_P3_g0\raw_04_LH_P3_g0_imec0\raw_04_LH_P3_g0_t0.imec0.lf.bin';
%nidaq_bin = 'Z:\JanieData\Neuropixel\w050\raw_04_LH_P3_g0\raw_04_LH_P3_g0_t0.nidq.bin';

%[filepath,name,ext] = fileparts(lfp_bin);

[binName,path] = uigetfile('*.bin', 'Select LFP Binary File');

meta_lfp = ReadMeta(binName, path);

end


function [meta] = ReadMeta(binName, path)

    % Create the matching metafile name
    [dumPath,name,dumExt] = fileparts(binName);
    metaName = strcat(name, '.meta');

    % Parse ini file into cell entries C{1}{i} = C{2}{i}
    fid = fopen(fullfile(path, metaName), 'r');
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