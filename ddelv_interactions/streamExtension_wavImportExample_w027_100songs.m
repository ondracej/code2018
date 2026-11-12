% streamExtension_wavImportExample
%
% Example import script for the Stream Extension.
%
% Imports a folder of .wav recordings (birdsong) as a stream-backed
% datasource. Each .wav file becomes one datapoint. Audio samples are read
% on demand from the files via a ddelv_hdr.StreamedTimeSeriesHDR; only the
% file references and per-file segment boundaries (onset/offset in samples)
% are stored in the datasource.
%
% Data layout:
%   rootFolder/subFolder/*.wav          the audio recordings
%   rootFolder/INFO.mat                 recording timestamps
%
% INFO.mat contains a struct INFO with:
%   INFO.times      1xK cell of date strings, one per file
%   INFO.fileNames  Kx1 struct (from dir()) with fields name, date, datenum
% Files are matched to their timestamp by filename (INFO.fileNames.name).

%% Configuration
%rootFolder = 'C:\Dropbox\projects\dspace\projectsInvolvingDspace\janie\ForSepp';
rootFolder = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w027_100Songs\Data_OnlySongs\';
dbstop if error

d = dir(rootFolder);
% remove all files (isdir property is 0)
dfolders = d([d(:).isdir]) ;
% remove '.' and '..'
dfolders = dfolders(~ismember({dfolders(:).name},{'.','..'}));

nDirs = numel(dfolders);
subFolders = cell(1, nDirs);

cnt = 1;
names = [];
dates = [];
for k = 1:nDirs

    subFolders{k} = dfolders(k).name;
    fileNames = dir(fullfile([rootFolder subFolders{k}],  '*.wav'));

    for i = 1:numel(fileNames)
        names{cnt} = fileNames(i).name;
        names_append{cnt} = [fileNames(i).name(1:end-4) '_' num2str(cnt) '.wav' ];
        dates{cnt} = fileNames(i).date;
        datenums{cnt} = fileNames(i).datenum;
        cnt = cnt+1;
    end

end

collectionName = 'w027-100';

% Bandpass filter (empty = no filtering). 
bandpass_Hz = [450, 12000];

% Reference dates (dd.mm.yy)
dateFormat = 'dd.mm.yy';
%2021-05-26
hatchday = '26.05.21';        % day of hatch
tutoringOnset = '12.07.23';   % first tutoring day
tutoringOffset = '19.08.19';  % last tutoring day

%% Enumerate .wav files across all subfolders
files = [];
fileSubfolders = {};
for s = 1:numel(subFolders)
    subFolder = subFolders{s};
    theseFiles = dir(fullfile(rootFolder, subFolder, '*.wav'));
    [~, order] = sort({theseFiles.name});
    theseFiles = theseFiles(order);
    assert(~isempty(theseFiles), 'No .wav files found in %s.', fullfile(rootFolder, subFolder));
    fprintf('Found %i .wav files in %s.\n', numel(theseFiles), fullfile(rootFolder, subFolder));

    files = [files; theseFiles]; %#ok<AGROW>
    fileSubfolders = [fileSubfolders; repmat({subFolder}, numel(theseFiles), 1)]; %#ok<AGROW>

end

timestampByName = containers.Map('KeyType', 'char', 'ValueType', 'double');
format long
for i = 1:numel(names)
    %timestampByName(names{i}) = datenums{i};
    timestampByName(names_append{i}) = datenum(dates{i});
end


% dates{18}
% bla = datenum(dates{18});
% bla = unique(src.L.t_datenum)
% bla2 = datetime(bla, 'ConvertFrom', 'datenum', 'Format', 'dd-MM-yy')
%bla3 = unique(bla2)


disp('')

Nfiles = numel(files);
assert(Nfiles > 0, 'No .wav files found in any subfolder.');
fprintf('Importing %i .wav files total...\n', Nfiles);

%% Load timestamps from INFO.mat and map by filename
%INFOfile = load(fullfile(rootFolder, 'INFO.mat'));
%INFOfile = load(fullfile([rootFolder '\' subFolders{:}], 'INFO.mat'));
%INFO = INFOfile.INFO;
%timestampByName = containers.Map('KeyType', 'char', 'ValueType', 'double');
%for i = 1:numel(INFO.fileNames)
%    timestampByName(INFO.fileNames(i).name) = INFO.fileNames(i).datenum;
%end

%% Read per-file audio properties and assemble label vectors
allSubfolders = cell(Nfiles, 1);
allFilenames = cell(Nfiles, 1);
t_datenum = NaN(Nfiles, 1);
f_fileId = (1:Nfiles)';
f_onsetInFile_samples = ones(Nfiles, 1);
f_offsetInFile_samples = NaN(Nfiles, 1);

samplingRate = NaN;
for k = 1:Nfiles
    %name = files(k).name; %%%%%%%%%%%%%%%%%%%%% 
    name = names_append{k};
    this_name = names{k};

    %name = names{k};
    info = audioinfo(fullfile(files(k).folder, this_name));

    if isnan(samplingRate)
        samplingRate = info.SampleRate;
    else
        assert(samplingRate == info.SampleRate, ...
            'Inconsistent sampling rate in %s (%g vs %g).', name, info.SampleRate, samplingRate);
    end

    allSubfolders{k} = fileSubfolders{k};
    %allFilenames{k} = name;
    allFilenames{k} = this_name;
    f_offsetInFile_samples(k) = info.TotalSamples;

    if isKey(timestampByName, name)
        %t_datenum(k) = timestampByName(name);
        t_datenum(k) = timestampByName(name);
    else
        warning('No timestamp found in INFO.mat for %s; leaving NaN.', name);
    end
end

%% Create dataset
src = ddelv(t_datenum, f_fileId, f_onsetInFile_samples, f_offsetInFile_samples);
src.Name = collectionName;

% File-link property definition: rootpath, per-file subfolders, per-file filenames
linkDef = ddelv_data.FileLinkPropertyDefinition(rootFolder, allSubfolders, allFilenames);
src.Ldef.f_fileId = linkDef;

%% Standard labels
src.Ldef.t_datenum = ddelv_data.PropertyDefinition([], [], 't_datenum', 'matlab datenum');
src.L.idx = (1:src.N)';
src.Ldef.idx = ddelv_data.PropertyDefinition([], [], 'Datapoint index', '');

% Add streamed HDR for mic0
maxSamples = max(f_offsetInFile_samples);
C = ddelv_hdr.StreamedTimeSeriesHDR('mic0_fixedWnd', src, 'f_fileId', ...
    'f_onsetInFile_samples', 'f_offsetInFile_samples');
C.mode = ddelv_hdr.StreamedTimeSeriesHDR.MODE_WAV_FILES_SINGLE_CHANNEL_FIXED_NUMBER_OF_SAMPLES;
C.samplesToRead = samplingRate * 5; % 5 seconds
C.samplingRate = samplingRate;
C.bandpass_Hz = bandpass_Hz;
C.maskPostOffset = false;
src.addFeatures(C);

% Variable-dimension HDR for mic0: reads each file from onset to offset
C = ddelv_hdr.StreamedTimeSeriesHDR('mic0', src, 'f_fileId', ...
    'f_onsetInFile_samples', 'f_offsetInFile_samples');
C.mode = ddelv_hdr.StreamedTimeSeriesHDR.MODE_WAV_FILES_SINGLE_CHANNEL_ONSET_TO_OFFSET;
C.samplesToRead = maxSamples;
C.samplingRate = samplingRate;
C.bandpass_Hz = bandpass_Hz;
C.maskPostOffset = false;
src.addFeatures(C);

% Assemble project
col = ddelv_data.Project({{src}}, {'Raw'}, collectionName);

%% Derive developmental time labels (MakeTimeLabels, bird_std mode)
view = ddelv.Dataview.getConfiguredDefaultView(src);
action = ddelvActs.streamExtension.MakeTimeLabels();
action.configure(view);
params = struct();
params.mode = 'bird_std';
params.timeLabelName_fractionalDays = 't_datenum';
params.hatchday = hatchday;
params.tutoring_onset = tutoringOnset;
params.tutoring_offset = tutoringOffset;
params.dateFormat = dateFormat;
action.compute(params);

% Launch DataDelv
ddelv(col);
