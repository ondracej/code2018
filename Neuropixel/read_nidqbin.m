function [meta, ain, din] = read_nidqbin(fname, path, ai_chan_idx, tsec)


% parse the corresponding metafile
meta = ReadMeta(fname, path);

if nargout==1
    return;
end

% read the entire bin file
if nargin == 4
    if contains(fname, '.ap.') || contains(fname, '.lf.')
        ain = ReadBinPartAP(meta, fname, path, tsec);
    else
        ain = ReadBinPart(meta, fname, path, tsec);
    end
else
    ain = ReadBinAll(meta, fname, path);
end

[~,~,XA] = ChannelCountsNI(meta);
ain = GainCorrectNI(ain, XA, meta);   % gain correct the analogue input

if nargout == 3
    din = ExtractAllDigital(ain, meta);   % read out the digital data
end

% choose specific analogue input, e.g. only microphone
if nargin >= 3 
    ain = ain(ai_chan_idx, :);  
end
end



%% from DemoReadSGLXData()
% =========================================================
% Parse ini file returning a structure whose field names
% are the metadata left-hand-side tags, and whose right-
% hand-side values are MATLAB strings. We remove any
% leading '~' characters from tags because MATLAB uses
% '~' as an operator.
%
% If you're unfamiliar with structures, the benefit
% is that after calling this function you can refer
% to metafile items by name. For example:
%
%   meta.fileCreateTime  // file create date and time
%   meta.nSavedChans     // channels per timepoint
%
% All of the values are MATLAB strings, but you can
% obtain a numeric value using str2double(meta.nSavedChans).
% More complicated parsing of values is demonstrated in the
% utility functions below.
%
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


% =========================================================
% Read nSamp timepoints from the binary file, starting
% at timepoint offset samp0. The returned array has
% dimensions [nChan,nSamp]. Note that nSamp returned
% is the lesser of: {nSamp, timepoints available}.
%
% IMPORTANT: samp0 and nSamp must be integers.
%
function dataArray = ReadBin(samp0, nSamp, meta, binName, path)

nChan = str2double(meta.nSavedChans);

nFileSamp = str2double(meta.fileSizeBytes) / (2 * nChan);
samp0 = max(samp0, 0);
nSamp = min(nSamp, nFileSamp - samp0);

sizeA = [nChan, nSamp];

fid = fopen(fullfile(path, binName), 'rb');
fseek(fid, samp0 * 2 * nChan, 'bof');
dataArray = fread(fid, sizeA, 'int16=>double');
fclose(fid);
end % ReadBin



% =========================================================
% Read the entire file (by Corinna)
function dataArray = ReadBinAll(meta, binName, path)

nChan = str2double(meta.nSavedChans);

try
    nSamp = str2double(meta.fileSizeBytes) / (2 * nChan);
catch 
    fprintf('meta file contains no size information \n');
    s = dir(fullfile(path, binName));
    nSamp = s.bytes / (2 * nChan);
end


sizeA = [nChan, nSamp];

fid = fopen(fullfile(path, binName), 'rb');
dataArray = fread(fid, sizeA, 'int16=>double');
fclose(fid);

end


% =========================================================
% Read nidq part of the file (by Corinna)
function dataArray = ReadBinPart(meta, binName, path, tsec)
% part is a two-element vector with the onset and offset of the file in
% seconds

samp = tsec .* str2double( meta.niSampRate ) ;
samp = round(samp);

nChan = str2double(meta.nSavedChans);
nFileSamp = str2double(meta.fileSizeBytes) / (2 * nChan);

nSamp = samp(2) - samp(1);
nSamp = min(nSamp, nFileSamp - samp(1));

sizeA = [nChan, nSamp];

fid = fopen(fullfile(path, binName), 'rb');
frewind(fid)
fseek(fid, samp(1)*2*nChan, 'bof');
dataArray = fread(fid, sizeA, 'int16=>double');
fclose(fid);

% figure; plot(((0:sizeA(2)-1) + samp(1))./ str2double( meta.niSampRate ),...
%     dataArray(1,:));

end

% ==============================================================
% Read ap part of the file (by Corinna)
function dataArray = ReadBinPartAP(meta, binName, path, tsec)
% part is a two-element vector with the onset and offset of the file in
% seconds

samp = tsec .* str2double( meta.imSampRate ) ;
samp = round(samp);

nChan = str2double(meta.nSavedChans);
nFileSamp = str2double(meta.fileSizeBytes) / (2 * nChan);

sizeA = [nChan, nFileSamp];

fid = fopen(fullfile(path, binName), 'rb');
frewind(fid)
fseek(fid, samp*2*nChan, 'bof');
dataArray = fread(fid, sizeA, 'int16=>double');
fclose(fid);

% figure; plot(((0:sizeA(2)-1) + samp(1))./ str2double( meta.niSampRate ),...
%     dataArray(1,:));

end

% =========================================================
% Return sample rate as double.
%
function srate = SampRate(meta)
if strcmp(meta.typeThis, 'imec')
    srate = str2double(meta.imSampRate);
else
    srate = str2double(meta.niSampRate);
end
end % SampRate


% =========================================================
% Return counts of each nidq channel type that compose
% the timepoints stored in binary file.
%
function [MN,MA,XA,DW] = ChannelCountsNI(meta)
M = str2num(meta.snsMnMaXaDw);
MN = M(1);
MA = M(2);
XA = M(3);
DW = M(4);
end % ChannelCountsNI


% =========================================================
% Return an array [lines X timepoints] of uint8 values for
% a specified set of digital lines.
%
% - dwReq is the one-based index into the saved file of the
%    16-bit word that contains the digital lines of interest.
% - dLineList is a zero-based list of one or more lines/bits
%    to scan from word dwReq.
%
function digArray = ExtractDigital(dataArray, meta, dwReq, dLineList)
% Get channel index of requested digital word dwReq
%     if strcmp(meta.typeThis, 'imec')
%         [AP, LF, SY] = ChannelCountsIM(meta);
%         if SY == 0
%             fprintf('No imec sync channel saved\n');
%             digArray = [];
%             return;
%         else
%             digCh = AP + LF + dwReq;
%         end
%     else
[MN,MA,XA,DW] = ChannelCountsNI(meta);
if dwReq > DW
    fprintf('Maximum digital word in file = %d\n', DW);
    digArray = [];
    return;
else
    digCh = MN + MA + XA + dwReq;
end
%     end
[~,nSamp] = size(dataArray);
digArray = zeros(numel(dLineList), nSamp, 'uint8');
for i = 1:numel(dLineList)
    digArray(i,:) = bitget(dataArray(digCh,:), dLineList(i)+1, 'int16');
end
end % ExtractDigital

% =========================================================
% Return an array of all digital channels
function digArray = ExtractAllDigital(dataArray, meta)

% by definition we search for XD1 and all the eight lines
dLineList = eval(meta.niXDChans1);
[MN,MA,XA] = ChannelCountsNI(meta);
ch = MN + MA + XA + 1; % by definition, we use XD1

% Get channel index of the digital word 
[~,nSamp] = size(dataArray);
digArray = zeros(numel(dLineList), nSamp, 'uint8');
for i = 1:numel(dLineList)
    digArray(i,:) = bitget(dataArray(ch,:), dLineList(i)+1, 'int16');
end

end % ExtractAllDigital


% =========================================================
% Having acquired a block of raw nidq data using ReadBin(),
% convert values to gain-corrected voltages. The conversion
% is only applied to the saved-channel indices in chanList.
% Remember saved-channel indices are in range [1:nSavedChans].
% The dimensions of the dataArray remain unchanged. ChanList
% examples:
%
%   [1:MN]      % all MN chans (MN from ChannelCountsNI)
%   [2,6,20]    % just these three channels
%
function dataArray = GainCorrectNI(dataArray, chanList, meta)

    [MN,MA] = ChannelCountsNI(meta);
    fI2V = Int2Volts(meta);

    for i = 1:length(chanList)
        j = chanList(i);    % index into timepoint
        conv = fI2V / ChanGainNI(j, MN, MA, meta); 
        dataArray(j,:) = dataArray(j,:) .* conv;
        dataArray(j,:) = dataArray(j,:) .* 200;
    end
end



% =========================================================
% Return a multiplicative factor for converting 16-bit
% file data to voltage. This does not take gain into
% account. The full conversion with gain is:
%
%   dataVolts = dataInt * fI2V / gain.
%
% Note that each channel may have its own gain.
%
function fI2V = Int2Volts(meta)
    if strcmp(meta.typeThis, 'imec')
        fI2V = str2double(meta.imAiRangeMax) / 512;
    else
        fI2V = str2double(meta.niAiRangeMax) / 32768;
    end
end % Int2Volts



% =========================================================
% Return gain for ith channel stored in the nidq file.
%
% ichan is a saved channel index, rather than an original
% (acquired) index.
%
function gain = ChanGainNI(ichan, savedMN, savedMA, meta)
    if ichan <= savedMN
        gain = str2double(meta.niMNGain);
    elseif ichan <= savedMN + savedMA
        gain = str2double(meta.niMAGain);
    else
        gain = 1;
    end
end % ChanGainNI
