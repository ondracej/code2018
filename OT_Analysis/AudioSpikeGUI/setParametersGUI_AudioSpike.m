function [] = setParametersGUI_AudioSpike()

dbstop if error
close all

if ispc
    dirD = '\';
else
    dirD = '/';
end

%% Define default output directory
outputDir = 'D:\Janie\tmp\';

%% Figure Settings
fH100 = figure(100); clf
%figSize = fH100.Position;
%scrz = get(0, 'Position' );
%figSize = get(fH100, 'Position');
%figSize = [scrz(1), scrz(2), scrz(3)/2, scrz(4)/2];
figSize  = [0   0   1000   600];

%%
setappdata(fH100, 'figSize', figSize); %###
setappdata(fH100, 'outputDir', outputDir); %###
setappdata(fH100, 'dirD', dirD); %###

set(fH100, 'Tag', 'fH100', 'NumberTitle', 'off', 'Name', 'AudioSpike | Parameter Settings');

setappdata(fH100, 'Parameters', []); %###
setappdata(fH100, 'Pcnt', 1); %###

%% Set Logbox
uicontrol(fH100, 'Style', 'listbox', 'String', {'Task Logging Startup ok!'}, 'Position', [10 10 figSize(3)*.35 figSize(4)*.2], 'tag', 'loglistbox');

%% Aquisition Settings
uicontrol(fH100,'Style','text','Fontweight', 'bold', 'Fontsize', 12, 'HorizontalAlignment', 'left', 'BackgroundColor', [0.95 0.95 0.95], 'ForegroundColor', [0 0 0], 'String','Data Aquisition Settings','Position',[10 figSize(4)*.95 250 20]);

% Sample Rate
sampleRate_String = {'44100', '88200'}; % Define pull down menu here
uicontrol(fH100,'Style','text','Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','Sampling Rate','Position',[10 figSize(4)*.90 110 20]);
sampleRate_H = uicontrol(fH100,'Style','popupmenu','String', sampleRate_String,'Position',[175 figSize(4)*.90 100 20], 'Tag', 'sampleRate_H ');
set(sampleRate_H, 'Callback', {@cbAS_enterSampleRate, fH100})
setappdata(fH100, 'SampleRate', 44100); %###

% Sample Rate Divider
uicontrol(fH100,'Style','text', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','Rate Divider','Position',[10 figSize(4)*.865 150 15]);
defString = '1';
samplingRateDivider_H = uicontrol(fH100,'Style','edit', 'enable', 'off', 'String', defString, 'Position',[175 figSize(4)*.865 30 15]);
%set(samplingRateDivider_H, 'Callback', {@cbAS_entersamplingRateDivider_H, fH100})
setappdata(fH100, 'SampleRateDevider', 1); %### % This should not change

%% Channel Configuration
uicontrol(fH100,'Style','text','Fontweight', 'bold', 'Fontsize', 12, 'HorizontalAlignment', 'left', 'BackgroundColor', [0.95 0.95 0.95], 'ForegroundColor', [0 0 0], 'String','Channel Configurations','Position',[10 figSize(4)*.78 250 20]);

% Output Chans
outputChans_String = {'1', '2', '3', }; % Define pull down menu here
uicontrol(fH100,'Style','text','Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','Output Channels','Position',[10 figSize(4)*.73 150 20]);
outputChans_H = uicontrol(fH100,'Style','list','String', outputChans_String,'max', 5', 'min', 1, 'Position',[20 figSize(4)*.63 100 50]);
set(outputChans_H, 'Callback', {@cbAS_cnfgChans, fH100, 1})
setappdata(fH100, 'OutputChannels', 1); %###

% Input Chans
inputChans_String = {'1', '2', '3', }; % Define pull down menu here
uicontrol(fH100,'Style','text','Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','Input Channels','Position',[180 figSize(4)*.73 150 20]);
inputChans_H = uicontrol(fH100,'Style','list','String', inputChans_String,'max', 5', 'min', 1, 'Position',[190 figSize(4)*.63 100 50]);
set(inputChans_H, 'Callback', {@cbAS_cnfgChans, fH100, 2})
setappdata(fH100, 'InputChannels', 1); %###

%% Stimulus Settings
uicontrol(fH100,'Style','text','Fontweight', 'bold', 'Fontsize', 12, 'HorizontalAlignment', 'left', 'BackgroundColor', [0.95 0.95 0.95], 'ForegroundColor', [0 0 0], 'String','Stimulus Settings','Position',[10 figSize(4)*.55 250 20]);

% Epoch Length [s]
defString = '0.490';
uicontrol(fH100,'Style','text','Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','Epoch Length [s]','Position',[10 figSize(4)*.50 150 20]);
epochLength_H = uicontrol(fH100,'Style','edit', 'String', defString, 'Position',[175 figSize(4)*.50 80 25]);
set(epochLength_H, 'Callback', {@cbAS_setStims, fH100, 1})
setappdata(fH100, 'EpocheLength', str2double(defString)); %###

% Pre Stim Length [s]
defString = '0.050';
uicontrol(fH100,'Style','text','Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','Pre Stimulus [s]','Position',[10 figSize(4)*.45 150 20]);
preStim_H = uicontrol(fH100,'Style','edit', 'String', defString, 'Position',[175 figSize(4)*.45 80 25]);
set(preStim_H , 'Callback', {@cbAS_setStims, fH100, 2})
setappdata(fH100, 'PreStimulus', str2double(defString)); %###

% Rep Period [s]
defString = '0.500';
uicontrol(fH100,'Style','text','Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','Rep. Period [s]','Position',[10 figSize(4)*.40 150 20]);
repPeriod_H = uicontrol(fH100,'Style','edit', 'String', defString, 'Position',[175 figSize(4)*.40 80 25]);
set(repPeriod_H, 'Callback', {@cbAS_setStims, fH100, 3})
setappdata(fH100, 'RepetitionPeriod', str2double(defString)); %###

% N Stim Reps
defString = '3';
uicontrol(fH100,'Style','text','Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','# Stim. Reps.','Position',[10 figSize(4)*.35 150 20]);
nStimReps_H = uicontrol(fH100,'Style','edit', 'String', defString, 'Position',[175 figSize(4)*.35 80 25]);
set(nStimReps_H, 'Callback', {@cbAS_setStims, fH100, 4})
setappdata(fH100, 'StimulusRepetition', str2double(defString)); %###

% Random Presetnation
randomStimPresentation_H = uicontrol(fH100,'Style','checkbox', 'Value', 1, 'String', 'Do Random Stim Presentation','Position', [10 figSize(4)*.30 250 20]);
set(randomStimPresentation_H, 'Callback', {@cbAS_soRandomPresentation, fH100})
setappdata(fH100, 'RandomMode', 1); %###

%% Define Measurement Parameters

uicontrol(fH100,'Style','text','Fontweight', 'bold', 'Fontsize', 12, 'HorizontalAlignment', 'left', 'BackgroundColor', [0.95 0.95 0.95], 'ForegroundColor', [0 0 0], 'String','Define Measurement Parameters','Position',[400 figSize(4)*.95 500 20]);

%nParameters_String = {'1', '2', '3', '4', '5'}; % Define pull down menu here
%uicontrol(fH100,'Style','text','Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','Define Parameters','Position',[400 figSize(4)*.90 130 20]);
nParams_H = uicontrol(fH100,'Style','pushbutton','String', 'Add parameters','Position',[400 figSize(4)*.85 120 50]);
set(nParams_H, 'BackgroundColor', [0.204 0.302 0.494], 'ForegroundColor', [1 1 1])

set(nParams_H, 'Callback', {@cbAS_defineParameters, fH100})

%% Finalize Settings

% Output directory
defString = outputDir;
uicontrol(fH100,'Style','text','Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','Output Dir','Position',[400 figSize(4)*.15 100 20]);
outputDirH = uicontrol(fH100,'Style','edit', 'String', defString, 'Position',[480 figSize(4)*.15 400 20], 'Tag', 'outputDirH');

% save Tage
uicontrol(fH100,'Style','text','Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','Save Text','Position',[400 figSize(4)*.10 100 20]);
saveTagH = uicontrol(fH100,'Style','edit', 'String', '', 'Position',[480 figSize(4)*.10 180 20], 'Tag', 'saveTagH');


%% Finalize Output button
finalize_H = uicontrol(fH100,'Style','pushbutton','String', 'Output Parameters','Position',[680 figSize(4)*.05 200 50]);
set(finalize_H, 'BackgroundColor', [0.204 0.302 0.494], 'ForegroundColor', [1 1 1])

set(finalize_H, 'Callback', {@cbAS_outputParameters, fH100})

end

%% Callback Functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Aquisition Setting
function [] = cbAS_enterSampleRate(src, event, fH100)

value = get(src, 'Value');
string = get(src, 'String');

%sampRateSelection = str2double(src.String(src.Value));
sampRateSelection = str2double(string(value));

logMsg = ['Sample rate set to: ' num2str(sampRateSelection)];
append_to_log(logMsg);

setappdata(fH100, 'SampleRate', sampRateSelection); %###
end

%% Channel Setting 
function [] = cbAS_cnfgChans(src, event, fH100, outOrIn)


value = get(src, 'Value');
string = get(src, 'String');
chanSelection = str2double(string(value));
%chanSelection = (str2double(src.String(src.Value)))';

switch outOrIn
    case 1
        logMsg = ['Output channels set to : ' num2str(chanSelection)'];
        setappdata(fH100, 'OutputChannels', chanSelection); %###
    case 2
        logMsg = ['Input channels set to : ' num2str(chanSelection)'];
        setappdata(fH100, 'InputChannels', chanSelection); %###
end
append_to_log(logMsg);

end

%% Stimulus Settings
function [] = cbAS_setStims(src, event, fH100, settingSwitch)

%textEntry = str2double(src.String);
textEntry = str2double(get(src, 'String'));

switch settingSwitch
    case 1
        setappdata(fH100, 'EpocheLength', textEntry);
        logMsg = ['Epoch Duration [s] set to : ' num2str(textEntry)];
    case 2
        setappdata(fH100, 'PreStimulus', textEntry);
        logMsg = ['Pre Stim Duration [s] set to : ' num2str(textEntry)];
    case 3
        setappdata(fH100, 'RepetitionPeriod', textEntry);
        logMsg = ['Repetition Period Duration [s] set to : ' num2str(textEntry)];
    case 4
        setappdata(fH100, 'StimulusRepetition', textEntry);
        logMsg = ['Stim Repetitions set to : ' num2str(textEntry)];
end
append_to_log(logMsg);
end

%% Random Presentation
function [] = cbAS_soRandomPresentation(src, event, fH100)

%randPresentation = src.Value;
randPresentation = get(src, 'Value');
setappdata(fH100, 'RandomMode', randPresentation); %###

end

%% Defining Parameters
function [] = cbAS_defineParameters(src, event, fH100)

Pcnt = getappdata(fH100, 'Pcnt'); %###
paramH = figure(200); clf
%PfigSize = fH100.Position;
PfigSize = get(fH100, 'Position');

uicontrol(paramH,'Style','text','Fontweight', 'bold', 'Fontsize', 12, 'HorizontalAlignment', 'left', 'BackgroundColor', [0.95 0.95 0.95], 'ForegroundColor', [0 0 0], 'String',['Enter parameter ' num2str(Pcnt) ' settings'],'Position',[10 PfigSize(4)*.65 400 20]);

defString = 'name';
uicontrol(paramH,'Style','text','Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','Param Name [text]','Position',[10 PfigSize(4)*.6 150 20]);
P_name = uicontrol(paramH,'Style','edit', 'String', defString, 'Position',[10 PfigSize(4)*.55 100 25], 'Tag', 'P_name');

defString = 'Unit';
uicontrol(paramH,'Style','text','Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','Param Unit [text]','Position',[10 PfigSize(4)*.5 150 20]);
P_Unit = uicontrol(paramH,'Style','edit', 'String', defString, 'Position',[10 PfigSize(4)*.45 100 25], 'Tag', 'P_Unit');

defString = 'Log';
uicontrol(paramH,'Style','text','Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','Log [1/0]','Position',[10 PfigSize(4)*.40 150 20]);
P_Log = uicontrol(paramH,'Style','edit', 'String', defString, 'Position',[10 PfigSize(4)*.35 100 25], 'Tag', 'P_Log');

defString = 'Level';
uicontrol(paramH,'Style','text','Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','Level','Position',[10 PfigSize(4)*.30 150 20]);
P_Level = uicontrol(paramH,'Style','edit', 'String', defString, 'Position',[10 PfigSize(4)*.25 100 25], 'Tag', 'P_Level');

setParams = uicontrol(paramH, 'Style','pushbutton','String','Set Parameters','Position',[200 PfigSize(4)*.25 150 80]);
set(setParams, 'BackgroundColor', [0.204 0.302 0.494], 'ForegroundColor', [1 1 1])
set(setParams,'Callback',{@cbAS_setParameters, fH100, paramH});

end

%% Set Parameters based on parameter count variable
function [] = cbAS_setParameters(src, event, fH100, paramH)

figSize = getappdata(fH100, 'figSize'); %###

Pcnt = getappdata(fH100, 'Pcnt'); %###
Parameters = getappdata(fH100, 'Parameters'); %###

P_name = findobj('Tag', 'P_name');
%Parameters(Pcnt).Name = P_name.String;
Parameters(Pcnt).Name = get(P_name, 'String');

P_Unit = findobj('Tag', 'P_Unit');
%Parameters(Pcnt).Unit = P_Unit.String;
Parameters(Pcnt).Unit = get(P_Unit, 'String');

P_Log = findobj('Tag', 'P_Log');
%Parameters(Pcnt).Log = str2double(P_Log.String);
Parameters(Pcnt).Log = str2double(get(P_Log, 'String'));

P_Level = findobj('Tag', 'P_Level');
% Comma separated
%pLev = P_Level.String;
pLev = get(P_Level, 'String');

if isempty(pLev)
    Parameters(Pcnt).Level = [];
else
    comma = ',';
    matchInd = strfind(pLev, comma);
    range1 = str2double(pLev(1:matchInd-1));
    range2 = str2double(pLev(matchInd+1:end));
    
    Parameters(Pcnt).Level = [range1 range2];
end

paramStr = ['Name: ' Parameters(Pcnt).Name '   Unit: ' Parameters(Pcnt).Unit '   Log: ' num2str(Parameters(Pcnt).Log) '   Level: ' num2str(Parameters(Pcnt).Level)];

uicontrol(fH100,'Style','text','Fontweight', 'bold', 'Fontsize', 12, 'HorizontalAlignment', 'left', 'BackgroundColor', [0.95 0.95 0.95], 'ForegroundColor', [0 0 0], 'String',['Parameter ' num2str(Pcnt)],'Position',[400 figSize(4)*(.80-Pcnt*.1) 500 20]);
uicontrol(fH100,'Style','text','Fontweight', 'bold', 'Fontsize', 10, 'HorizontalAlignment', 'left', 'BackgroundColor', [0.95 0.95 0.95], 'ForegroundColor', [0 0 0], 'String',paramStr,'Position',[400 figSize(4)*(.75-Pcnt*.1) 500 20]);

%% Send info to log
logMsg = ['Parameters ' num2str(Pcnt) ' set.'];
append_to_log(logMsg);

setappdata(fH100, 'Parameters', Parameters); %###
Pcnt = Pcnt+1;
setappdata(fH100, 'Pcnt', Pcnt); %###

close(paramH)
disp('')
end

%% Output final settings to a mat file
function [] = cbAS_outputParameters(src, event, fH100)


%{

% 1. create settings
AudioSpike.Settings.SampleRate           = 44100;%!!!! noch anpassen!!!
AudioSpike.Settings.SampleRateDevider    = 1;
AudioSpike.Settings.EpocheLength         = 0.4983;
AudioSpike.Settings.PreStimulus          = 0.05;%%0.0100
AudioSpike.Settings.RepetitionPeriod     = 0.500;%%0.6500
AudioSpike.Settings.StimulusRepetition   = 3;
AudioSpike.Settings.OutputChannels       = [1 2];%[1 2];
AudioSpike.Settings.InputChannels        = [1];%%%[1 2];
AudioSpike.Settings.RandomMode           = 1;

% 2. create measurement parameters
AudioSpike.Parameters(1).Name            = 'Level';
AudioSpike.Parameters(1).Unit            = 'dB';
AudioSpike.Parameters(1).Log             = 0;
AudioSpike.Parameters(1).Level           = [70 70];%[40:10:70]',  [40:5:70;fliplr(40:5:70)]'

AudioSpike.Parameters(2).Name            = 'Azimuth';
AudioSpike.Parameters(2).Unit            = 'deg';
AudioSpike.Parameters(2).Log             = 0;% nur im plot!!

AudioSpike.Parameters(3).Name            = 'Elevation';
AudioSpike.Parameters(3).Unit            = 'deg';
AudioSpike.Parameters(3).Log             = 0;

%}
saveTagH = findobj('Tag', 'saveTagH');
%saveTag = saveTagH.String;
saveTag = get(saveTagH, 'String');

outputDirH = findobj('Tag', 'outputDirH');
%outputDir = outputDirH.String;
outputDir = get(outputDirH, 'String');

dirD = getappdata(fH100, 'dirD'); %###

AudioSpike.Settings.SampleRate = getappdata(fH100, 'SampleRate');
AudioSpike.Settings.SampleRateDevider = getappdata(fH100, 'SampleRateDevider');
AudioSpike.Settings.EpocheLength = getappdata(fH100, 'EpocheLength');
AudioSpike.Settings.PreStimulus = getappdata(fH100, 'PreStimulus');
AudioSpike.Settings.RepetitionPeriod = getappdata(fH100, 'RepetitionPeriod');
AudioSpike.Settings.StimulusRepetition = getappdata(fH100, 'StimulusRepetition');
AudioSpike.Settings.OutputChannels = getappdata(fH100, 'OutputChannels');
AudioSpike.Settings.InputChannels = getappdata(fH100, 'InputChannels');
AudioSpike.Settings.RandomMode = getappdata(fH100, 'RandomMode');

AudioSpike.Parameters = getappdata(fH100, 'Parameters');

saveName = [outputDir saveTag '.mat'];
save(saveName, 'AudioSpike');
logMsg = ['Saved file: ' saveName];

append_to_log(logMsg);

end

%% Appending to logbox
function append_to_log(message)

if nargin == 0 || isempty(message)
    return;
end
%%
lb = findobj('Tag', 'loglistbox');
timestr = datestr(now, 'HH:MM:SS --');
message = [timestr ' ' message];

% grab existing entries and count how many we have
strings = get(lb, 'String');
if isempty(strings)
    nbr_entries_prev = 0;
else
    nbr_entries_prev = size(strings, 1);
end

% first entry
if nbr_entries_prev == 0
    strings_new = { message };
    % new entries
else
    strings_new = { strings{1:end} message };
end

% overwrite all strings and highlight the last row.
% this assumes that 'message' is a one line string!
nbr_entries_new = nbr_entries_prev + 1;
set(lb, 'String', strings_new, 'Value', nbr_entries_new);


end