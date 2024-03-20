function [mmf, conv2volt, fs, meta] = get_mmf(lfp_fname, lfp_dir)
% get memory mapped file

meta = ReadMeta(lfp_fname, lfp_dir);
nChansInFile = str2double(meta.nSavedChans);

fI2V = str2double(meta.imAiRangeMax) / 512;
C = textscan(meta.imroTbl, '(%*s %*s %*s %d %d %*s', ...
    'EndOfLine', ')', 'HeaderLines', 1 );
LFgain = double(cell2mat(C(2)));
conv2volt = fI2V / LFgain(1);
fs = str2double(meta.imSampRate);

% 
lfp_full = fullfile(lfp_dir, lfp_fname);
d = dir(lfp_full);
nSamps = d.bytes/2/nChansInFile;

mmf = memmapfile(lfp_full, 'Format', {'int16', [nChansInFile nSamps], 'x'});



