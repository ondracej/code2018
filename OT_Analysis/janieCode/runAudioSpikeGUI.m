function  []  = runAudioSpikeGUI()
dbstop if error

if ispc    
    dirD = '\';
elseif isunix
    dirD = '/';
end

%% Get screensize and set GUI to appropriate position
scrsz = get(0,'ScreenSize');
lower = (scrsz(4)/2);
width = scrsz(3);
height = scrsz(4)/1.1;
set(0,'DefaultFigurePosition', [0 lower width height]);

fH100 = figure(100);clf
set(fH100, 'Tag', 'fH100', 'NumberTitle', 'off', 'Name', 'AudioSpike GUI');

%% Setup Listbox For User Feedback

uicontrol(fH100, 'Style', 'listbox', 'String', {'Startup ok!'}, 'Units', 'norm', 'Position', [0.73 0.1 0.26 0.89], 'tag', 'loglistbox');

% Logbox to text button
h_OutputLogboxTxt = uicontrol(fH100,'Style','pushbutton','String','Logbox To Text','Units', 'norm', 'Position',[.88 .03 .10 .05]);
set(h_OutputLogboxTxt , 'Callback', {@cb_outputLogBoxToText, fH100}, 'BackgroundColor', [0.704 0.202 0.294], 'ForegroundColor', [1 1 1]);

%% Text Box

h_textBox = uicontrol(fH100,'Style','edit', 'String', '', 'Units', 'norm', 'Position',[.73 .02 .14 .07]);
set(h_textBox , 'Callback', {@cb_writeTextToLogbox, fH100})

%% Save Dir
defSaveDir = 'D:\Janie\AudioSpike_v_27102017\AudioSpikeGUI_DataFiles\';

if exist(defSaveDir, 'dir') == 0
    mkdir(defSaveDir);
    append_to_log(['Created dir: ' defSaveDir])
end

h_saveDir = uicontrol(fH100,'Style','edit', 'String', defSaveDir, 'Units', 'norm', 'Position',[.01 .02 .5 .04]);
set(h_saveDir , 'Callback', {@cb_makeSaveDir, fH100, })


%% Create the dir for the AudioSpike Stuctures
defAudSpikeFileDir = [defSaveDir 'AudSpikeFiles' dirD];

if exist(defAudSpikeFileDir, 'dir') == 0
    mkdir(defAudSpikeFileDir);
    append_to_log(['Created dir: ' defAudSpikeFileDir])
end

setappdata(fH100, 'defAudSpikeFileDir', defAudSpikeFileDir)

%% 1 HRTF

HrtfAxis = axes('Units','norm','Position',[0.01 0.85 0.50 0.14],'XTick',[],'YTick',[],'Color',[0.9 0.9 0.9],'XColor',[0.3 0.3 0.3],'YColor',[0.3 0.3 0.3]);
box(HrtfAxis,'on');
uicontrol(fH100, 'Style', 'text', 'String', '1 | HRTR (default SPL)', 'Units', 'norm', 'Position', [0.02 0.95 0.15  0.03], 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor',[0.9 0.9 0.9]);

% HRIR File List
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','Select HRIR File','Units', 'norm', 'Position',[.05 .92 .16 .02]);
HRIR_FileString = {'HRIRconv_100hz-7000hz_Dur-100ms_single', 'HRIRconv_100hz-5000hz_Dur-100ms_single'};
defHRIRFile = 'HRIRconv_100hz-7000hz_Dur-100ms_single';
h_HRIR_FileList = uicontrol(fH100,'Style','popupmenu','String', HRIR_FileString,'Units', 'norm', 'Position',[.05 .88 .16 .03]);
set(h_HRIR_FileList, 'Callback', {@cb_chooseHRIR, fH100})

% HRTF Degree Steps
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','Deg. Step','Units', 'norm', 'Position',[.22 .92 .05 .02]);
HRTF_DegStepsString  = {'5.625', '11.25', '16.875'};
%defDegStep = 5.625;
defDegStep = 11.25;
h_HRTF_DegList = uicontrol(fH100,'Style','popupmenu','String', HRTF_DegStepsString,'Units', 'norm', 'Position',[.22 .88 .05 .03]);
set(h_HRTF_DegList, 'Callback', {@cb_chooseDeg, fH100,'HRTF_DegSteps'})

% HRTF Azimuth Range
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','Az Range','Units', 'norm', 'Position',[.28 .92 .05 .02]);
defAzRange = '-180:180';
h_AzRange = uicontrol(fH100,'Style','edit', 'String', defAzRange, 'Units', 'norm', 'Position',[.28 .88 .05 .03]);
set(h_AzRange, 'Callback', {@cb_enterSaveString, fH100, 1, 'defAzRange'})

% HRTF Elevation Range
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','El Range','Units', 'norm', 'Position',[.34 .92 .05 .02]);
defEleRange = '-67.5:67.5';
h_EleRange = uicontrol(fH100,'Style','edit', 'String', defEleRange, 'Units', 'norm', 'Position',[.34 .88 .05 .03]);
set(h_EleRange, 'Callback', {@cb_enterSaveString, fH100, 1, 'defEleRange'})

% Start HRTF
h_start_HRTF = uicontrol(fH100,'Style','pushbutton','String','Set HRTF','Units', 'norm', 'Position',[.40 .87 .10 .1]);
set(h_start_HRTF, 'Callback', {@cb_start_HRTF, fH100}, 'BackgroundColor', [0.204 0.702 0.494], 'ForegroundColor', [1 1 1]);

%% 2 Auditory Tuning

TuningAxis = axes('Units','norm','Position',[0.01 0.60 0.50 0.22],'XTick',[],'YTick',[],'Color',[0.9 0.9 0.9],'XColor',[0.3 0.3 0.3],'YColor',[0.3 0.3 0.3]);
box(TuningAxis,'on');
uicontrol(fH100, 'Style', 'text', 'String', '2 | Auditory Tuning', 'Units', 'norm', 'Position', [0.02 0.78 0.15 0.03], 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor',[0.9 0.9 0.9]);
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','Frequency Range','Units', 'norm', 'Position',[.05 .75 .10 .02]);

% Freq Range Lo
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String','lo (Hz)','Units', 'norm', 'Position',[.05 .72 .04 .02], 'BackgroundColor', [0.9 0.9 0.9]);
defFreq_lo = 100;
h_defFreq_lo = uicontrol(fH100,'Style','edit', 'String', num2str(defFreq_lo), 'Units', 'norm', 'Position',[.05 .70 .04 .02]);
set(h_defFreq_lo, 'Callback', {@cb_enterSaveString, fH100, 0, 'defFreq_lo'})

% Freq Range Hi
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String','hi (Hz)','Units', 'norm', 'Position',[.10 .72 .04 .02], 'BackgroundColor', [0.9 0.9 0.9]);
defFreq_hi = 7000;
h_defFreq_hi = uicontrol(fH100,'Style','edit', 'String', num2str(defFreq_hi), 'Units', 'norm', 'Position',[.10 .70 .04 .02]);
set(h_defFreq_hi, 'Callback', {@cb_enterSaveString, fH100, 0, 'defFreq_hi'})

% Freq Range nOctaves
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String','n Octaves','Units', 'norm', 'Position',[.05 .66 .1 .02], 'BackgroundColor', [0.9 0.9 0.9]);
defnOctaves = 4;
h_nOctaves = uicontrol(fH100,'Style','edit', 'String', num2str(defnOctaves), 'Units', 'norm', 'Position',[.05 .64 .04 .02]);
set(h_nOctaves, 'Callback', {@cb_enterSaveString, fH100, 0, 'defnOctaves'})

% SPL Level Lo
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','SPL Range','Units', 'norm', 'Position',[.17 .75 .10 .02]);
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String','lo (dB)','Units', 'norm', 'Position',[.17 .72 .04 .02], 'BackgroundColor', [0.9 0.9 0.9]);
defSPL_lo = 20;
h_defSPL_lo = uicontrol(fH100,'Style','edit', 'String', num2str(defSPL_lo), 'Units', 'norm', 'Position',[.17 .70 .04 .02]);
set(h_defSPL_lo, 'Callback', {@cb_enterSaveString, fH100, 0, 'defSPL_lo'})

% SPL Level Hi
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String','hi (dB)','Units', 'norm', 'Position',[.22 .72 .04 .02], 'BackgroundColor', [0.9 0.9 0.9]);
defSPL_hi = 80;
h_defSPL_hi = uicontrol(fH100,'Style','edit', 'String', num2str(defSPL_hi), 'Units', 'norm', 'Position',[.22 .70 .04 .02]);
set(h_defSPL_hi, 'Callback', {@cb_enterSaveString, fH100, 0, 'defSPL_hi'})

% SPL Level steps
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String','SPL step (dB)','Units', 'norm', 'Position',[.17 .66 .1 .02], 'BackgroundColor', [0.9 0.9 0.9]);
defSPLstep = 5;
h_SPLstep = uicontrol(fH100,'Style','edit', 'String', num2str(defSPLstep), 'Units', 'norm', 'Position',[.17 .64 .06 .02]);
set(h_SPLstep, 'Callback', {@cb_enterSaveString, fH100, 0, 'defSPLstep'})

%% Stereo/Mono Buttos

defMode = 1;

bg = uibuttongroup('Visible','on',...
    'Position',[.285 .64 .10 .14],...
    'SelectionChangedFcn', {@cb_modeSelection, fH100});

r1 = uicontrol(bg,'Style',...
    'radiobutton',...
    'String','Stereo',...
    'Units', 'norm', 'Position',[.1 .8 .7 .1],...
    'HandleVisibility','on');

r2 = uicontrol(bg,'Style',...
    'radiobutton',...
    'String','Mono-Ch1',...
    'Units', 'norm', 'Position',[.1 .45 .7 .1],...
    'HandleVisibility','on');

r3 = uicontrol(bg,'Style',...
    'radiobutton',...
    'String','Mono-Ch2',...
    'Units', 'norm', 'Position',[.1 .1 .7 .1],...
    'HandleVisibility','on');

% Start Tuning
h_start_Tuning = uicontrol(fH100,'Style','pushbutton','String','Set Tuning','Units', 'norm', 'Position',[.40 .66 .10 .1]);
set(h_start_Tuning, 'Callback', {@cb_start_Tuning, fH100}, 'BackgroundColor', [0.204 0.702 0.494], 'ForegroundColor', [1 1 1]);

%% 3 IID

IID_Axis = axes('Units','norm','Position',[0.01 0.43 0.50 0.14],'XTick',[],'YTick',[],'Color',[0.9 0.9 0.9],'XColor',[0.3 0.3 0.3],'YColor',[0.3 0.3 0.3]);
box(IID_Axis,'on');
uicontrol(fH100, 'Style', 'text', 'String', '3 | IID', 'Units', 'norm', 'Position', [0.02 0.53 0.15 0.03], 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor',[0.9 0.9 0.9]);

% WN BP Lo
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','WN BandPass','Units', 'norm', 'Position',[.05 .51 .10 .02]);
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String','lo (Hz)','Units', 'norm', 'Position',[.05 .48 .04 .02], 'BackgroundColor', [0.9 0.9 0.9]);
defFreq_WN_lo_IID = 100;
h_defFreq_WNlo = uicontrol(fH100,'Style','edit', 'String', num2str(defFreq_WN_lo_IID), 'Units', 'norm', 'Position',[.05 .46 .04 .02]);
set(h_defFreq_WNlo, 'Callback', {@cb_enterSaveString, fH100, 0, 'defFreq_WN_lo_IID'})

% WN BP Hi
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String','hi (Hz)','Units', 'norm', 'Position',[.10 .46 .04 .02], 'BackgroundColor', [0.9 0.9 0.9]);
defFreq_WN_hi_IID = 7000;
h_defFreq_WNhi = uicontrol(fH100,'Style','edit', 'String', num2str(defFreq_WN_hi_IID), 'Units', 'norm', 'Position',[.10 .46 .04 .02]);
set(h_defFreq_WNhi, 'Callback', {@cb_enterSaveString, fH100, 0, 'defFreq_WN_hi_IID'})

%SPL Range Lo
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','SPL Range','Units', 'norm', 'Position',[.17 .51 .16 .02]);
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String','lo (dB)','Units', 'norm', 'Position',[.17 .48 .04 .02], 'BackgroundColor', [0.9 0.9 0.9]);
defSPL_lo_IID = 20;
h_defSPL_lo = uicontrol(fH100,'Style','edit', 'String', num2str(defSPL_lo_IID), 'Units', 'norm', 'Position',[.17 .46 .04 .02]);
set(h_defSPL_lo, 'Callback', {@cb_enterSaveString, fH100, 0, 'defSPL_lo_IID'})

%SPL Range Hi
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String','hi (dB)','Units', 'norm', 'Position',[.22 .48 .04 .02], 'BackgroundColor', [0.9 0.9 0.9]);
defSPL_hi_IID = 80;
h_defSPL_hi = uicontrol(fH100,'Style','edit', 'String', num2str(defSPL_hi_IID), 'Units', 'norm', 'Position',[.22 .46 .04 .02]);
set(h_defSPL_hi, 'Callback', {@cb_enterSaveString, fH100, 0, 'defSPL_hi_IID'})

% SPL Steps
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String','SPL step (dB)','Units', 'norm', 'Position',[.27 .48 .1 .02], 'BackgroundColor', [0.9 0.9 0.9]);
defSPLstep_IID = 5;
h_SPLstep = uicontrol(fH100,'Style','edit', 'String', num2str(defSPLstep_IID), 'Units', 'norm', 'Position',[.27 .46 .06 .02]);
set(h_SPLstep, 'Callback', {@cb_enterSaveString, fH100, 0, 'defSPLstep_IID'})

% Start IID
h_start_IID = uicontrol(fH100,'Style','pushbutton','String','Set IID','Units', 'norm', 'Position',[.40 .45 .10 .1]);
set(h_start_IID, 'Callback', {@cb_start_IID, fH100}, 'BackgroundColor', [0.204 0.702 0.494], 'ForegroundColor', [1 1 1]);


%% 4 ITD

ITD_Axis = axes('Units','norm','Position',[0.01 0.26 0.50 0.14],'XTick',[],'YTick',[],'Color',[0.9 0.9 0.9],'XColor',[0.3 0.3 0.3],'YColor',[0.3 0.3 0.3]);
box(ITD_Axis ,'on');
uicontrol(fH100, 'Style', 'text', 'String', '4 | ITD (default SPL)', 'Units', 'norm', 'Position', [0.02 0.36 0.15 0.03], 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor',[0.9 0.9 0.9]);
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','WN BandPass','Units', 'norm', 'Position',[.05 .34 .10 .02]);

% WN Range lo
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String','lo (Hz)','Units', 'norm', 'Position',[.05 .31 .04 .02], 'BackgroundColor', [0.9 0.9 0.9]);
defFreq_WN_lo_ITD = 100;
h_defFreq_WNlo = uicontrol(fH100,'Style','edit', 'String', num2str(defFreq_WN_lo_ITD), 'Units', 'norm', 'Position',[.05 .29 .04 .02]);
set(h_defFreq_WNlo, 'Callback', {@cb_enterSaveString, fH100, 0, 'defFreq_WN_lo_ITD'})

% WN Range Hi
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String','hi (Hz)','Units', 'norm', 'Position',[.10 .31 .04 .02], 'BackgroundColor', [0.9 0.9 0.9]);
defFreq_WN_hi_ITD = 7000;
h_defFreq_WNhi = uicontrol(fH100,'Style','edit', 'String', num2str(defFreq_WN_hi_ITD), 'Units', 'norm', 'Position',[.10 .29 .04 .02]);
set(h_defFreq_WNhi, 'Callback', {@cb_enterSaveString, fH100, 0, 'defFreq_WN_hi_ITD'})

% Time Delay Range
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','Delay Range (ms)','Units', 'norm', 'Position',[.17 .34 .11 .02]);
defDelayRange_ITD = '-2:2';
h_delayRange = uicontrol(fH100,'Style','edit', 'String', defDelayRange_ITD, 'Units', 'norm', 'Position',[.17 .30 .11 .03]);
set(h_delayRange , 'Callback', {@cb_enterSaveString, fH100, 1, 'defDelayRange_ITD'})

% Time Delay Step
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','Time step (ms)','Units', 'norm', 'Position',[.30 .34 .08 .02]);
defDelayStep_ITD = 0.5;
h_delayStep = uicontrol(fH100,'Style','edit', 'String', num2str(defDelayStep_ITD), 'Units', 'norm', 'Position',[.30 .30 .08 .03]);
set(h_delayStep , 'Callback', {@cb_enterSaveString, fH100, 0, 'defDelayStep_ITD'})

%Start ITD
h_start_ITD = uicontrol(fH100,'Style','pushbutton','String','Set ITD','Units', 'norm', 'Position',[.40 .28 .10 .1]);
set(h_start_ITD, 'Callback', {@cb_start_ITD, fH100}, 'BackgroundColor', [0.204 0.702 0.494], 'ForegroundColor', [1 1 1]);


%% Other Options
WNSearch_Axis = axes('Units','norm','Position',[0.01 0.10 0.50 0.14],'XTick',[],'YTick',[],'Color',[0.9 0.9 0.9],'XColor',[0.3 0.3 0.3],'YColor',[0.3 0.3 0.3]);
box(WNSearch_Axis,'on');

uicontrol(fH100, 'Style', 'text', 'String', '5 | WN Search (default SPL)', 'Units', 'norm', 'Position', [0.02 0.20 0.15 0.03], 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor',[0.9 0.9 0.9]);
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','WN BandPass','Units', 'norm', 'Position',[.05 .18 .10 .02]);

% WN Range lo
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String','lo (Hz)','Units', 'norm', 'Position',[.05 .15 .04 .02], 'BackgroundColor', [0.9 0.9 0.9]);
defFreq_WN_lo_Search = 100;
h_defFreq_WNlo_search = uicontrol(fH100,'Style','edit', 'String', num2str(defFreq_WN_lo_Search), 'Units', 'norm', 'Position',[.05 .13 .04 .02]);
set(h_defFreq_WNlo_search, 'Callback', {@cb_enterSaveString, fH100, 0, 'defFreq_WN_lo_Search'})

% WN Range Hi
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String','hi (Hz)','Units', 'norm', 'Position',[.10 .15 .04 .02], 'BackgroundColor', [0.9 0.9 0.9]);
defFreq_WN_hi_Search = 7000;
h_defFreq_WNhi_search = uicontrol(fH100,'Style','edit', 'String', num2str(defFreq_WN_hi_Search), 'Units', 'norm', 'Position',[.10 .13 .04 .02]);
set(h_defFreq_WNhi_search, 'Callback', {@cb_enterSaveString, fH100, 0, 'defFreq_WN_hi_Search'})

%Start WN Search
h_start_WNSearch = uicontrol(fH100,'Style','pushbutton','String','Set WN Search','Units', 'norm', 'Position',[.40 .12 .10 .1]);
set(h_start_WNSearch, 'Callback', {@cb_start_WNSearch, fH100}, 'BackgroundColor', [0.204 0.702 0.494], 'ForegroundColor', [1 1 1]);



%% Audio Spike Box

AudSpikeSettingAxis = axes('Units','norm','Position',[0.52 0.50 0.20 0.49],'XTick',[],'YTick',[],'Color',[0.9 0.9 0.9],'XColor',[0.3 0.3 0.3],'YColor',[0.3 0.3 0.3]);
box(AudSpikeSettingAxis ,'on');

uicontrol(fH100, 'Style', 'text', 'String', 'Audio Spike Settings', 'Units', 'norm', 'Position', [0.53 0.93 0.15 0.025], 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor',[0.204 0.202 0.794], 'ForegroundColor', [1 1 1]);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Stimulus Settings
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','Stimulus Settings','Units', 'norm', 'Position',[.53 .88 .11 .02]);

%% Stimulus Duration
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String','StimDur (s)','Units', 'norm', 'Position',[.55 .85 .12 .02], 'BackgroundColor', [0.9 0.9 0.9]);
defStimDur_str  = .20;
h_StimDur = uicontrol(fH100,'Style','edit', 'String', num2str(defStimDur_str), 'Units', 'norm', 'Position',[.66 .85 .05 .03]);
set(h_StimDur , 'Callback', {@cb_enterSaveString, fH100, 0, 'defStimDur_str'})

%% Pre Stim Suration
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String','PreStimDur (s)','Units', 'norm', 'Position',[.55 .82 .12 .02], 'BackgroundColor', [0.9 0.9 0.9]);
defPreStimDur_str  = .10;
h_PreStimDur = uicontrol(fH100,'Style','edit', 'String', num2str(defPreStimDur_str), 'Units', 'norm', 'Position',[.66 .82 .05 .03]);
set(h_PreStimDur , 'Callback', {@cb_enterSaveString, fH100, 0, 'defPreStimDur_str'})

%% n Stim Reps
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String','nStimReps','Units', 'norm', 'Position',[.55 .79 .12 .02], 'BackgroundColor', [0.9 0.9 0.9]);
defnStimReps_str  = 6;
h_nStimReps = uicontrol(fH100,'Style','edit', 'String', num2str(defnStimReps_str), 'Units', 'norm', 'Position',[.66 .79 .05 .03]);
set(h_nStimReps , 'Callback', {@cb_enterSaveString, fH100, 0, 'defnStimReps_str'})

%% Random Mode
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String','RandomMode','Units', 'norm', 'Position',[.55 .76 .12 .02], 'BackgroundColor', [0.9 0.9 0.9]);
defRandomMode_str  = 1;
h_randomMode = uicontrol(fH100,'Style','edit', 'String', num2str(defRandomMode_str), 'Units', 'norm', 'Position',[.66 .76 .05 .03]);
set(h_randomMode , 'Callback', {@cb_enterSaveString, fH100, 0, 'defRandomMode_str'})

%% Stimuolus Repetition
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String','StimulusRepetition (s)','Units', 'norm', 'Position',[.55 .73 .12 .02], 'BackgroundColor', [0.9 0.9 0.9]);
defInterEpochDelay  = 1;
h_interEpochDelay = uicontrol(fH100,'Style','edit', 'String', num2str(defInterEpochDelay), 'Units', 'norm', 'Position',[.66 .73 .05 .03]);
set(h_interEpochDelay , 'Callback', {@cb_enterSaveString, fH100, 0, 'defInterEpochDelay'})

%% Hard Coded parameters
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','Output Parameters','Units', 'norm', 'Position',[.53 .68 .11 .02]);

%% Sampling Rate
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String','SamplingRate','Units', 'norm', 'Position',[.55 .65 .08 .02], 'BackgroundColor', [0.9 0.9 0.9]);
defSampleRate = 44100;
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String',num2str(defSampleRate),'Units', 'norm', 'Position',[.66 .65 .05 .02], 'BackgroundColor', [0.9 0.9 0.9]);

%% Sampling Rate divider
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String','SamplingRateDiv','Units', 'norm', 'Position',[.55 .62 .12 .02], 'BackgroundColor', [0.9 0.9 0.9]);
defSampleRateDivider = 1;
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String',num2str(defSampleRateDivider),'Units', 'norm', 'Position',[.66 .62 .05 .02], 'BackgroundColor', [0.9 0.9 0.9]);

%% Stim Output
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String','StimOutputCh','Units', 'norm', 'Position',[.55 .59 .12 .02], 'BackgroundColor', [0.9 0.9 0.9]);
defStimChansOutput = [1 2];
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String',num2str(defStimChansOutput ),'Units', 'norm', 'Position',[.66 .59 .05 .02], 'BackgroundColor', [0.9 0.9 0.9]);

%% Electrode input channels
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String','ElectrodeInputCh','Units', 'norm', 'Position',[.55 .56 .12 .02], 'BackgroundColor', [0.9 0.9 0.9]);
defElectrodeChansInput = [1];
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String',num2str(defElectrodeChansInput ),'Units', 'norm', 'Position',[.66 .56 .05 .02], 'BackgroundColor', [0.9 0.9 0.9]);

%% Default SPL
uicontrol(fH100,'Style','text',  'FontSize', 10, 'Fontweight', 'bold', 'HorizontalAlignment', 'left', 'String','Default SPL (dB)','Units', 'norm', 'Position',[.55 .52 .12 .02], 'BackgroundColor', [0.9 0.9 0.9]);
defLevelSPL  = 80;
h_defLevelSPL = uicontrol(fH100,'Style','edit', 'String', num2str(defLevelSPL), 'Units', 'norm', 'Position',[.66 .52 .05 .03]);
set(h_defLevelSPL , 'Callback', {@cb_enterSaveString, fH100, 0, 'defLevelSPL'})

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Start AudioSpikeButton

h_StartAudioSpike = uicontrol(fH100,'Style','pushbutton','String','Start AudioSpike','Units', 'norm', 'Position',[.52 .42 .20 .05]);
set(h_StartAudioSpike  , 'Callback', {@cb_start_AudioSpike, fH100}, 'BackgroundColor', [0.204 0.202 0.794], 'ForegroundColor', [1 1 1]);

%% Check AudioSpike Parameters

h_CheckAudioSpikeParams = uicontrol(fH100,'Style','pushbutton','String','Check Parameters','Units', 'norm', 'Position',[.52 .35 .20 .05]);
set(h_CheckAudioSpikeParams   , 'Callback', {@cb_CheckAudioSpikeParameters, fH100}, 'BackgroundColor', [0.704 0.202 0.294], 'ForegroundColor', [1 1 1]);


%% Save All Variables

rampDur_s = 0.005; % 5 ms
setappdata(fH100, 'dirD', dirD);%###
setappdata(fH100, 'rampDur_s', rampDur_s);%###
setappdata(fH100, 'defSaveDir', defSaveDir);%###
setappdata(fH100, 'HRIR_To_Load', defHRIRFile);%###
setappdata(fH100, 'HRTF_DegSteps', defDegStep );%###
setappdata(fH100, 'defAzRange', defAzRange);%###
setappdata(fH100, 'defEleRange', defEleRange);%###
setappdata(fH100, 'defFreq_lo', defFreq_lo);%###
setappdata(fH100, 'defFreq_hi', defFreq_hi);%###
setappdata(fH100, 'defnOctaves', defnOctaves);%###
setappdata(fH100, 'defSPL_lo', defSPL_lo);%###
setappdata(fH100, 'defSPL_hi', defSPL_hi);%###
setappdata(fH100, 'defSPLstep', defSPLstep);%###
setappdata(fH100, 'defMode', defMode);%###
setappdata(fH100, 'defFreq_WN_lo_IID', defFreq_WN_lo_IID);%###
setappdata(fH100, 'defFreq_WN_hi_IID', defFreq_WN_hi_IID);%###
setappdata(fH100, 'defSPL_lo_IID', defSPL_lo_IID);%###
setappdata(fH100, 'defSPL_hi_IID', defSPL_hi_IID);%###
setappdata(fH100, 'defSPLstep_IID', defSPLstep_IID);%###
setappdata(fH100, 'defFreq_WN_lo_ITD', defFreq_WN_lo_ITD);%###
setappdata(fH100, 'defFreq_WN_hi_ITD', defFreq_WN_hi_ITD);%###
setappdata(fH100, 'defDelayRange_ITD', defDelayRange_ITD);%###
setappdata(fH100, 'defDelayStep_ITD', defDelayStep_ITD);%###
setappdata(fH100, 'defStimDur_str', defStimDur_str);%###
setappdata(fH100, 'defPreStimDur_str', defPreStimDur_str);%###
setappdata(fH100, 'defnStimReps_str', defnStimReps_str);%###
setappdata(fH100, 'defRandomMode_str', defRandomMode_str);%###
setappdata(fH100, 'defInterEpochDelay', defInterEpochDelay);%###
setappdata(fH100, 'defSampleRate', defSampleRate);%###
setappdata(fH100, 'defSampleRateDivider', defSampleRateDivider);%###
setappdata(fH100, 'defStimChansOutput', defStimChansOutput);%###
setappdata(fH100, 'defElectrodeChansInput', defElectrodeChansInput);%###
setappdata(fH100, 'defLevelSPL', defLevelSPL);%###
setappdata(fH100, 'stimDur_s', 0.1);%### % This is how long the stim alone is
setappdata(fH100, 'defFreq_WN_lo_Search', defFreq_WN_lo_Search);%###
setappdata(fH100, 'defFreq_WN_hi_Search', defFreq_WN_hi_Search);%###


disp('')

end

%% AudioSpike Structures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [] = cb_start_WNSearch(src, event, fH100)

defFreq_WN_lo_Search = getappdata(fH100, 'defFreq_WN_lo_Search');%###
defFreq_WN_hi_Search = getappdata(fH100, 'defFreq_WN_hi_Search');%###
defLevelSPL = getappdata(fH100, 'defLevelSPL');%###
stimDur_s = getappdata(fH100, 'stimDur_s');%### % This is how long the stim alone is
defSampleRate = getappdata(fH100, 'defSampleRate');%###
rampDur_s = getappdata(fH100, 'rampDur_s');%###
defInterEpochDelay = getappdata(fH100, 'defInterEpochDelay');%###
currTest = ['05-WNSeach'];
setappdata(fH100, 'currTest', currTest);%###

%% SPL Setting

SPLvector_contra = defLevelSPL;
SPLvector_ipsi = defLevelSPL;

%% Noise Signal
%slightlyShorterStim = defStimDur_str- 0.01;

% make 5 different WN stimuli, repeated x many times

nWNs = 5;

for j = 1:nWNs 
    
    
    filNoiseRamp = cb_create_bpWN(defFreq_WN_lo_Search, defFreq_WN_hi_Search, stimDur_s, defSampleRate, rampDur_s);

    
    %%
    label_text=['WN-' num2str(j)];
    
    AudioSpike.Stimuli(j).Name          = label_text;
    AudioSpike.Stimuli(j).FileName      = ['signals/' label_text '.wav'];
    AudioSpike.Stimuli(j).RMS           = [-rms(filNoiseRamp)];
    AudioSpike.Stimuli(j).filWN         = 1;
    AudioSpike.Stimuli(j).Data          = filNoiseRamp;

end

AudioSpike.Parameters(1).Name            = 'Level';
AudioSpike.Parameters(1).Unit            = 'dB';
AudioSpike.Parameters(1).Log             = 0;
AudioSpike.Parameters(1).Level           = [SPLvector_contra; SPLvector_ipsi]';

defnStimReps_str = getappdata(fH100, 'defnStimReps_str');%###

nStims = numel(AudioSpike.Stimuli) * numel(SPLvector_contra); % Freqs at each diff level
playbackDur = round((defInterEpochDelay*nStims * defnStimReps_str)/60);  % 0.7 is approx the playback dur for 1 stim (.15+.15+.4) * numreps
append_to_log(['     nStims = ' num2str(nStims) ' x' num2str(defnStimReps_str)  ' reps | ~' num2str(playbackDur) ' min']);

setappdata(fH100, 'AudioSpike', AudioSpike);%###

cb_setupAudioSpikeSettingsParams(fH100)


end


%% Create AudioSpike HRTF
function [] = cb_start_HRTF(src, event, fH100)


%% Get variables
HRIR_To_Load = getappdata(fH100, 'HRIR_To_Load');%###  from  cb_chooseHRIR
HRTF_DegSteps = getappdata(fH100, 'HRTF_DegSteps');%### from  cb_chooseDeg
defAzRange = getappdata(fH100, 'defAzRange');%###
defEleRange = getappdata(fH100, 'defEleRange');%###

currTest = ['01-HRTF'];
setappdata(fH100, 'currTest', currTest);%###

%% Load the HRIR File
append_to_log(' ')
append_to_log('Creating HRTF Structure...')

HRIR = load(HRIR_To_Load); % this will work as long as the runAudioSpikeGUI is in the same dir as the file...

INFO = HRIR.INFO;

azVec = INFO.azRange;
elVec = INFO.elevRange;
HRIR_Res_deg = INFO.degStep;

sig_ch1 = squeeze(HRIR.spatial(:,:,:,1));   %ohr 1  %27,65,7758 (elevation,azimuth, stimvector)
sig_ch2 = squeeze(HRIR.spatial(:,:,:,2)); %ohr 2

%% Parse the ranges
colon = ':';
colInd = find(defAzRange == colon);

%azdegvon = -180; %degree azi (-90:7.5:90)
%azdegbis = 180; %degree azi (-90:7.5:90)
%eledegvon = -67.5; %degree ele (-82.5:7.5:82.5)!!!
%eledegbis = 67.5; %degree ele (-82.5:7.5:82.5)!!!

azdegvon = str2num(defAzRange(1:colInd-1));
azdegbis = str2num(defAzRange(colInd+1:end));
azvon_startInd = find(azVec == azdegvon);
azbis_endInd = find(azVec == azdegbis);

colInd = find(defEleRange == colon);

eledegvon = str2num(defEleRange(1:colInd-1));
eledegbis = str2num(defEleRange(colInd+1:end));
elevon_startInd = find(elVec == eledegvon);
elebis_endInd = find(elVec == eledegbis);


%% Define Vectors
stepwidth = HRTF_DegSteps;

azvec = azdegvon:stepwidth:azdegbis;
elevec = eledegvon:stepwidth:eledegbis;

az_ZeroInd = find(azvec == 0);
el_ZeroInd = find(elevec == 0);

sig_ch1 = sig_ch1(elevon_startInd:stepwidth/HRIR_Res_deg:elebis_endInd, azvon_startInd:stepwidth/HRIR_Res_deg:azbis_endInd,:);
sig_ch2 = sig_ch2(elevon_startInd:stepwidth/HRIR_Res_deg:elebis_endInd, azvon_startInd:stepwidth/HRIR_Res_deg:azbis_endInd,:);

%% Calculate RMS on ZeroInd

zeroAzEl_ch1  = squeeze(sig_ch1(el_ZeroInd,az_ZeroInd,:))';
zeroAzEl_ch2  = squeeze(sig_ch2(el_ZeroInd,az_ZeroInd,:))';

%azvec(az_ZeroInd)
%elevec(el_ZeroInd)

rmsCh1 = -rms(zeroAzEl_ch1);
rmsCh2 = -rms(zeroAzEl_ch2);

%% Pack Stimuli Into an Audio Spike Structure

cnt = 1;
for i = 1:numel(elevec)
    for j = 1:numel(azvec)
        
        signalsq_Ch1 = squeeze(sig_ch1(i,j,:))';
        signalsq_2_Ch2 = squeeze(sig_ch2(i,j,:))';
        
        this_azi = num2str(azvec(j));
        this_ele = num2str(elevec(i));
        
        label_text = ['az_' this_azi '__el_' this_ele];
        
        AudioSpike.Stimuli(cnt).Name          = label_text;
        AudioSpike.Stimuli(cnt).FileName      = ['signals/' label_text '.wav'];
        AudioSpike.Stimuli(cnt).RMS           = [rmsCh1 ; rmsCh2]';
        AudioSpike.Stimuli(cnt).Azimuth       = this_azi;
        AudioSpike.Stimuli(cnt).Elevation     = this_ele;
        AudioSpike.Stimuli(cnt).Data          = [signalsq_Ch1; signalsq_2_Ch2]'; % column vector, ch1 and ch2
        
        
        cnt = cnt+1;
    end
end

%% Add a silent trial

silentTrial = ones(1, size(signalsq_Ch1, 2))*0;

AudioSpike.Stimuli(cnt).Name          = 'Silent';
AudioSpike.Stimuli(cnt).FileName      = ['signals/Silent.wav'];
AudioSpike.Stimuli(cnt).RMS           = [rmsCh1 ; rmsCh2]';
AudioSpike.Stimuli(cnt).Azimuth       = 0; % Not sure what values to add here
AudioSpike.Stimuli(cnt).Elevation     = 0; % Not sure what values to add here
AudioSpike.Stimuli(cnt).Data          = [silentTrial; silentTrial]';

defnStimReps_str = getappdata(fH100, 'defnStimReps_str');%###

nStims = numel(AudioSpike.Stimuli);
playbackDur = round((.7*nStims *defnStimReps_str )/60);  % 0.7 is approx the playback dur for 1 stim (.15+.15+.4)
append_to_log(['     nStims = ' num2str(nStims) ' x' num2str(defnStimReps_str)  ' reps | ~' num2str(playbackDur) ' min']);

%% Parameters
% SPL
defLevelSPL = getappdata(fH100, 'defLevelSPL');%###

AudioSpike.Parameters(1).Name            = 'Level';
AudioSpike.Parameters(1).Unit            = 'dB';
AudioSpike.Parameters(1).Log             = 0; % axis to be plotted linear
AudioSpike.Parameters(1).Level           = [defLevelSPL]';%NOTE: if more than one output channel is specified in settings above,
% then you may either specify only one column vector (user for ALL channels) or one column for each channel

AudioSpike.Parameters(2).Name            = 'Azimuth';
AudioSpike.Parameters(2).Unit            = 'degree';
AudioSpike.Parameters(2).Log             = 0;

AudioSpike.Parameters(3).Name            = 'Elevation';
AudioSpike.Parameters(3).Unit            = 'degree';
AudioSpike.Parameters(3).Log             = 0;

clear('sig_ch1', 'sig_ch2', 'HRIR', 'INFO', 'signalsq_Ch1', 'signalsq_Ch1');

setappdata(fH100, 'AudioSpike', AudioSpike);%###

cb_setupAudioSpikeSettingsParams(fH100)

disp('')

end

%% Create AudioSpike Tuning
function [] = cb_start_Tuning(src, event, fH100)
disp('')

defFreq_lo = getappdata(fH100, 'defFreq_lo');%###
defFreq_hi = getappdata(fH100, 'defFreq_hi');%###
defnOctaves = getappdata(fH100, 'defnOctaves');%###
defSPL_lo = getappdata(fH100, 'defSPL_lo');%###
defSPL_hi = getappdata(fH100, 'defSPL_hi');%###
defSPLstep = getappdata(fH100, 'defSPLstep');%###
defMode = getappdata(fH100, 'defMode');%###
stimDur_s = getappdata(fH100, 'stimDur_s');%### % This is how long the stim alone is

rampDur_s = getappdata(fH100, 'rampDur_s');%###
%defStimDur_str = getappdata(fH100, 'defStimDur_str');%###
defSampleRate = getappdata(fH100, 'defSampleRate');%###

currTest = ['02-Tuning'];
setappdata(fH100, 'currTest', currTest);%###

%% SPL range

SPLstep_dB = defSPLstep;
range_SPL_lo = defSPL_lo;
range_SPL_hi = defSPL_hi;

SPLvector = range_SPL_lo:SPLstep_dB:range_SPL_hi;

if defMode == 1 % ch 1 and ch 2 are the same
    SPLvector_contra = SPLvector;
    SPLvector_ipsi = SPLvector;
    
elseif defMode == 2 % ch 1 only, ch 2 silent
    SPLvector_contra = SPLvector;
    SPLvector_ipsi = zeros(size(SPLvector));
    
elseif binaural == 3 % ch 2 only, ch 1 silent
    SPLvector_contra = zeros(size(SPLvector));
    SPLvector_ipsi = SPLvector;
end

%% Frequency Range

rangeFreq_lo_hz = defFreq_lo;
rangeFreq_hi_hz = defFreq_hi;

fc_hz = 2000; % centre freq
nOct = defnOctaves; % n octaves
stepsOct = 8;

f_lo = fc_hz/(2^nOct);
f_hi = fc_hz*(2^nOct);

freqs = logspace(log10(f_lo),log10(f_hi),(nOct *2 * stepsOct)+1);

%% limit frequency range
freqVector = freqs(find(freqs <= rangeFreq_hi_hz & freqs >=rangeFreq_lo_hz));
nFreqs = numel(freqVector);

%% http://www.h6.dion.ne.jp/~fff/old/technique/auditory/matlab.html#cramp

sampleRate = defSampleRate;
%stimDur_s = defStimDur_str;

nSamp = stimDur_s*sampleRate;
t = (1:nSamp) / sampleRate;

% prepare ramp
nr = floor(sampleRate * rampDur_s);
ramp = sin(linspace(0, pi/2, nr));
ramp = [ramp, ones(1, nSamp - nr * 2), fliplr(ramp)];

%% Create AudioSpike Structure
append_to_log(' ')
append_to_log('Creating Tuning Structure...')

for j = 1:nFreqs
    
    F_sin = sin(2 * pi * freqVector(j) * t);   % sinusoidal modulation
    F_sin_ramp = F_sin .* ramp;
    
    %{
    %Plot
    figure; plot(F_sin, 'k')
    hold on ; plot(F_sin_ramp, 'b')
    xlim([0 2*nr])
    %}
    
    %%
    label_text=[ num2str(round(freqVector(j))/1000) 'kHz'];
    freq = round(freqVector(j));
    
    AudioSpike.Stimuli(j).Name          = label_text;
    AudioSpike.Stimuli(j).FileName      = ['signals/' num2str(freq) '.wav'];
    AudioSpike.Stimuli(j).RMS           = -rms(F_sin_ramp);
    AudioSpike.Stimuli(j).Frequency     = freq;
    AudioSpike.Stimuli(j).Data          = F_sin_ramp;
    
end

defnStimReps_str = getappdata(fH100, 'defnStimReps_str');%###

nStims = numel(AudioSpike.Stimuli) * numel(SPLvector_contra); % Freqs at each diff level
playbackDur = round((.7*nStims * defnStimReps_str)/60);  % 0.7 is approx the playback dur for 1 stim (.15+.15+.4) * numreps
append_to_log(['     nStims = ' num2str(nStims) ' x' num2str(defnStimReps_str)  ' reps | ~' num2str(playbackDur) ' min']);

AudioSpike.Stimuli(j+1).Name          = 'Silent';
AudioSpike.Stimuli(j+1).FileName      = ['signals/Silent.wav'];
AudioSpike.Stimuli(j+1).RMS           = AudioSpike.Stimuli(j).RMS;
AudioSpike.Stimuli(j+1).Frequency     = 0;
AudioSpike.Stimuli(j+1).Data          = ones(1, size(F_sin_ramp, 2))*0;

%% AudioSpike Parameters

AudioSpike.Parameters(1).Name            = 'Level';
AudioSpike.Parameters(1).Unit            = 'dB';
AudioSpike.Parameters(1).Log             = 0;
AudioSpike.Parameters(1).Level           = [SPLvector_contra; SPLvector_ipsi]';

AudioSpike.Parameters(2).Name            = 'Frequency';
AudioSpike.Parameters(2).Unit            = 'Hz';
AudioSpike.Parameters(2).Log             = 1;% nur im plot!!

setappdata(fH100, 'AudioSpike', AudioSpike);%###

cb_setupAudioSpikeSettingsParams(fH100)

end

%% Create AudioSpike IID
function [] = cb_start_IID(src, event, fH100)

defFreq_WN_lo_IID = getappdata(fH100, 'defFreq_WN_lo_IID');%###
defFreq_WN_hi_IID = getappdata(fH100, 'defFreq_WN_hi_IID');%###
defSPL_lo_IID = getappdata(fH100, 'defSPL_lo_IID');%###
defSPL_hi_IID = getappdata(fH100, 'defSPL_hi_IID');%###
defSPLstep_IID= getappdata(fH100, 'defSPLstep_IID');%###
stimDur_s = getappdata(fH100, 'stimDur_s');%### % This is how long the stim alone is
%defStimDur_str = getappdata(fH100, 'defStimDur_str');%###

defSampleRate = getappdata(fH100, 'defSampleRate');%###
rampDur_s = getappdata(fH100, 'rampDur_s');%###

currTest = ['03-IID'];
setappdata(fH100, 'currTest', currTest);%###

%% SPL range

SPLstep_dB = defSPLstep_IID;
range_SPL_lo = defSPL_lo_IID;
range_SPL_hi = defSPL_hi_IID;

SPLvector = range_SPL_lo:SPLstep_dB:range_SPL_hi;

SPLvector_contra=   SPLvector;
SPLvector_ipsi=   fliplr(SPLvector);

%% Create Canned WN

%filNoiseRamp = cb_create_bpWN(defFreq_WN_lo_IID, defFreq_WN_hi_IID, defStimDur_str, defSampleRate, rampDur_s);
filNoiseRamp = cb_create_bpWN(defFreq_WN_lo_IID, defFreq_WN_hi_IID, stimDur_s, defSampleRate, rampDur_s);

append_to_log(' ')
append_to_log('Creating IID Structure...')

%% Stimulus Structure

label_text=['filWN'];

AudioSpike.Stimuli(1).Name               = label_text;
AudioSpike.Stimuli(1).FileName           = ['signals_noise.wav'];
AudioSpike.Stimuli(1).RMS               = -rms(filNoiseRamp);
AudioSpike.Stimuli(1).filWN              = 1;
AudioSpike.Stimuli(1).Data               = filNoiseRamp;

%% Parameters

AudioSpike.Parameters(1).Name            = 'Level';
AudioSpike.Parameters(1).Unit            = 'dB';
AudioSpike.Parameters(1).Log             = 0;
AudioSpike.Parameters(1).Level           = [SPLvector_contra; SPLvector_ipsi]';

defnStimReps_str = getappdata(fH100, 'defnStimReps_str');%###

nStims = numel(AudioSpike.Stimuli) * numel(SPLvector_contra); % Freqs at each diff level
playbackDur = round((.7*nStims * defnStimReps_str)/60);  % 0.7 is approx the playback dur for 1 stim (.15+.15+.4) * numreps
append_to_log(['     nStims = ' num2str(nStims) ' x' num2str(defnStimReps_str)  ' reps | ~' num2str(playbackDur) ' min']);

setappdata(fH100, 'AudioSpike', AudioSpike);%###

cb_setupAudioSpikeSettingsParams(fH100)

end

%% Create AudioSpike ITD
function [] = cb_start_ITD(src, event, fH100)

defFreq_WN_lo_ITD = getappdata(fH100, 'defFreq_WN_lo_ITD');%###
defFreq_WN_hi_ITD = getappdata(fH100, 'defFreq_WN_hi_ITD');%###
defDelayRange_ITD = getappdata(fH100, 'defDelayRange_ITD');%###
defDelayStep_ITD = getappdata(fH100, 'defDelayStep_ITD');%###
defLevelSPL = getappdata(fH100, 'defLevelSPL');%###
stimDur_s = getappdata(fH100, 'stimDur_s');%### % This is how long the stim alone is

%defStimDur_str = getappdata(fH100, 'defStimDur_str');%###
defSampleRate = getappdata(fH100, 'defSampleRate');%###
rampDur_s = getappdata(fH100, 'rampDur_s');%###

currTest = ['04-ITD'];
setappdata(fH100, 'currTest', currTest);%###

%% SPL Setting

SPLvector_contra = defLevelSPL;
SPLvector_ipsi = defLevelSPL;

%% Noise Signal
%slightlyShorterStim = defStimDur_str- 0.01;
filNoiseRamp = cb_create_bpWN(defFreq_WN_lo_ITD, defFreq_WN_hi_ITD, stimDur_s, defSampleRate, rampDur_s);

%% Time Vector    

colon = ':';
colInd = find(defDelayRange_ITD == colon);

timeDelayvon_s = (str2num(defDelayRange_ITD(1:colInd-1)))/1000;
timeDelaybis_s = (str2num(defDelayRange_ITD(colInd+1:end)))/1000;

delayStep_s = defDelayStep_ITD/1000;

dTimeVec = (timeDelayvon_s:delayStep_s:timeDelaybis_s);
nTimeVecs = numel(dTimeVec);

append_to_log(' ')
append_to_log('Creating ITD Structure...')

for n = 1:nTimeVecs

    sigvec1 = zeros(1, length(filNoiseRamp)+round(defSampleRate*max(abs(dTimeVec))));
    sigvec2 = zeros(1, length(filNoiseRamp)+round(defSampleRate*max(abs(dTimeVec))));
    
    if dTimeVec(n) >= 0
        sigvec1(end-(length(filNoiseRamp)-1):end) = filNoiseRamp;
        sigvec2(end-(round(defSampleRate*abs(dTimeVec(n))+(length(filNoiseRamp)-1))):end-round(defSampleRate*abs(dTimeVec(n))))= filNoiseRamp;
        
    elseif dTimeVec(n) < 0
        
        sigvec2(end-(length(filNoiseRamp)-1):end)=filNoiseRamp;
        sigvec1(end-(round(defSampleRate*abs(dTimeVec(n))+(length(filNoiseRamp)-1))):end-round(defSampleRate*abs(dTimeVec(n)))) = filNoiseRamp;
    end

    %{
figure(1);clf
subplot(2,1,1),plot(sigvec1)
subplot(2,1,2),plot(sigvec2)
%}

    label_text = [num2str(dTimeVec(n)*1000) 'ms' ];
  
    AudioSpike.Stimuli(n).Name               = label_text;
    AudioSpike.Stimuli(n).FileName           = ['signals/' num2str(dTimeVec(n)*1000) 'ms.wav'];
    AudioSpike.Stimuli(n).ITD                = dTimeVec(n);
    AudioSpike.Stimuli(n).RMS               = [-rms(sigvec1) ; -rms(sigvec2)]';
    AudioSpike.Stimuli(n).Data               = [sigvec1; sigvec2]';%%% columnn vectors!!!!!

end

defnStimReps_str = getappdata(fH100, 'defnStimReps_str');%###

nStims = numel(AudioSpike.Stimuli) * numel(SPLvector_contra); % Freqs at each diff level
playbackDur = round((.7*nStims * defnStimReps_str)/60);  % 0.7 is approx the playback dur for 1 stim (.15+.15+.4) * numreps
append_to_log(['     nStims = ' num2str(nStims) ' x' num2str(defnStimReps_str)  ' reps | ~' num2str(playbackDur) ' min']);


AudioSpike.Parameters(1).Name            = 'Level';
AudioSpike.Parameters(1).Unit            = 'dB';
AudioSpike.Parameters(1).Log             = 0;
AudioSpike.Parameters(1).Level           = [SPLvector_contra; SPLvector_ipsi]';

AudioSpike.Parameters(2).Name            = 'ITD';
AudioSpike.Parameters(2).Unit            = 'ms';
AudioSpike.Parameters(2).Log             = 0;


setappdata(fH100, 'AudioSpike', AudioSpike);%###

cb_setupAudioSpikeSettingsParams(fH100)


end

%% Setup AudioSpike Settings and Parameters
function []  = cb_setupAudioSpikeSettingsParams(fH100)

disp('')

AudioSpike = getappdata(fH100, 'AudioSpike');%###

%% Get Settings
defSampleRate = getappdata(fH100, 'defSampleRate');%###
defSampleRateDivider = getappdata(fH100, 'defSampleRateDivider');%###

defStimDur_str = getappdata(fH100, 'defStimDur_str');%###
defPreStimDur_str = getappdata(fH100, 'defPreStimDur_str');%###
defnStimReps_str = getappdata(fH100, 'defnStimReps_str');%###
defRandomMode_str = getappdata(fH100, 'defRandomMode_str');%###
defInterEpochDelay = getappdata(fH100, 'defInterEpochDelay');%###
defStimChansOutput = getappdata(fH100, 'defStimChansOutput');%###
defElectrodeChansInput = getappdata(fH100, 'defElectrodeChansInput');%###

epochLength_s = defStimDur_str + defPreStimDur_str;

if epochLength_s > defInterEpochDelay
    append_to_log(['Need to increase the repetition period to > ' num2str(epochLength_s)])
end

AudioSpike.Settings.SampleRate           = defSampleRate;
AudioSpike.Settings.SampleRateDevider    = defSampleRateDivider;

AudioSpike.Settings.StimulusRepetition   = defnStimReps_str;
AudioSpike.Settings.PreStimulus          = defPreStimDur_str;
AudioSpike.Settings.EpocheLength         = epochLength_s;
AudioSpike.Settings.RepetitionPeriod     = defInterEpochDelay;

%AudioSpike.Settings.SpikeLength          = spikeLength_s;
%AudioSpike.Settings.PreThreshold         = preThreshold_s;

AudioSpike.Settings.OutputChannels       = defStimChansOutput;
AudioSpike.Settings.InputChannels        = defElectrodeChansInput;

AudioSpike.Settings.RandomMode           = defRandomMode_str;

append_to_log('AudioSpike settings saved...')
setappdata(fH100, 'AudioSpike', AudioSpike);%###

%cb_StartAudioSpike(fH100)

end

%% Check AudioSpike Parameters
function []  = cb_CheckAudioSpikeParameters(src, event, fH100)

AudioSpike = getappdata(fH100, 'AudioSpike');%###

nStructs = numel(AudioSpike.Parameters);

append_to_log(' ')
append_to_log('Current Parameters')
for j = 1:nStructs
    str = ['     * ' AudioSpike.Parameters(j).Name];
    append_to_log(str)
end

disp('')
allFields = fieldnames(AudioSpike.Settings);

append_to_log('Current Settings')

for j = 1:numel(allFields)
    thisField = allFields{j};
    thisVal = eval(['AudioSpike.Settings.' thisField]);
    str = ['     *' thisField ' = ' num2str(thisVal)]; 
    append_to_log(str)    
end
end

%% Run AudioSpike
function[] = cb_start_AudioSpike(src, event, fH100)
append_to_log(['Starting AudioSpike...'])

audSpikeFileDir = getappdata(fH100, 'defAudSpikeFileDir');

c = clock;
c = fix(c);

%thisDate_txt = [num2str(c(1)) num2str(c(2)) num2str(c(3)) '_' num2str(c(4)) num2str(c(5)) num2str(c(6))];
thisDate_txt = [num2str(c(1)) sprintf('%02d',c(2))  sprintf('%02d', c(3)) '_' sprintf('%02d',c(4)) sprintf('%02d',c(5)) sprintf('%02d',c(6))];

currTest = getappdata(fH100, 'currTest');%###
SettingFileName = [currTest '_' thisDate_txt];

AudioSpike = getappdata(fH100, 'AudioSpike');%###

stimuli = AudioSpike.Stimuli;
allFields = fieldnames(stimuli);
nStimuli = numel(stimuli);

AudioSpike.Stimuli(:,:).Name
AudioSpikeStructure = [];
for j = 1:numel(allFields)    
    thisField = allFields{j};
    if ~strcmpi(thisField, 'Data')
        
        for k = 1:nStimuli
            %eval(['AudioSpikeStructure.Stimuli(' num2str(k) ',:).' thisField ' = AudioSpike.Stimuli(' k ',:).' thisField ';'])
            eval(['AudioSpikeStructure.Stimuli(k).' thisField ' = AudioSpike.Stimuli(k).' thisField ';'])
        end
    end
end

AudioSpikeStructure.Parameters = AudioSpike.Parameters;
AudioSpikeStructure.Settings = AudioSpike.Settings;

subDir = [currTest '_' thisDate_txt];
saveDir = [audSpikeFileDir 'AudSpk_' currTest '_' thisDate_txt];
save(saveDir, 'AudioSpikeStructure')
append_to_log(['Saved: ' saveDir])

%%
addpath('D:\Janie\AudioSpike_v_20102017\tools');
addpath('D:\Janie\AudioSpike_v_20102017\');

append_to_log('Starting AudioSpike...')
AudioSpikeFile_xml = [SettingFileName '.xml'];
audiospike_createmeas(AudioSpike, AudioSpikeFile_xml);

eval(['system([''start bin\audiospike.exe command=measure file=' AudioSpikeFile_xml ' subpath=' subDir '''])']);
end

%% GUI Functioning %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Append Message to Logbox
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

%% Write Text to Logbox
function [] = cb_writeTextToLogbox(src, ~, ~)

saveStr = src.String;
append_to_log([ '>> ' saveStr])

end

%% Make Save Directory for Logbox Text
function [] = cb_makeSaveDir(src, ~, fH100)

disp('')
saveDir = src.String;
dirD = getappdata(fH100, 'dirD');%###

if exist(saveDir, 'dir') == 0
    mkdir(saveDir);
end

setappdata(fH100, 'defSaveDir', saveDir)
append_to_log(['Created: ' saveDir])

%% Create the dir for the AudioSpike Stuctures
audSpikeFileDir = [saveDir dirD 'AudSpikeFiles' dirD];
setappdata(fH100, 'defAudSpikeFileDir', audSpikeFileDir)

end

%% Output Logbox to Text File
function [] = cb_outputLogBoxToText(~, ~, fH100)

today = date;
dash = '-';
d_inds = find(today == dash);
date_front = [today(d_inds(2)+1:end) dash];
date_mid = today(d_inds(1)+1:d_inds(2)-1);
date_end = [dash today(1:d_inds(1)-1)];

thisDate = [date_front date_mid date_end];
setappdata(fH100, 'thisDate', thisDate); %###

saveDir = getappdata(fH100, 'defSaveDir');

lb = findobj('Tag', 'loglistbox');
strings = get(lb, 'String');
nEntries = size(strings, 1);

fileName = [saveDir thisDate '-LogBoxOutput.txt'];
fileID = fopen(fileName,'w');

for j = 1:nEntries
    strToPrint = strings{j};
    dID = '%s\r\n';
    fprintf(fileID, dID, strToPrint); % Brain Area
end

fclose(fileID);

append_to_log('LogBox Saved:')
append_to_log(fileName)

end

%% Getting Values from GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Save String Value to Handle
function [] = cb_enterSaveString(src, ~, fH100, rangeSwitch, StrH)

if rangeSwitch == 1
    
    saveStr = src.String;
    
    setappdata(fH100, StrH, saveStr);
    append_to_log(['[' StrH(4:end) ' = ' saveStr ']'])
else
    
    saveStr = src.String;
    
    if ischar(saveStr)
        saveStr = str2num(saveStr);
    end
    
    % Only save numeric values
    if isnumeric(saveStr)
        setappdata(fH100, StrH, saveStr);
        append_to_log(['[' StrH(4:end) ' = ' num2str(saveStr) ']'])
    end
end

end

%% Choose HRIR File for HRTF
function [] = cb_chooseHRIR(src, ~, fH100)

saveStr = src.String;
saveVal = src.Value;

HRIR_To_Load =  saveStr{saveVal};
setappdata(fH100, 'HRIR_To_Load', HRIR_To_Load);
append_to_log(['[' HRIR_To_Load ']'])

end

%% Choose Degree Step size for HRTF
function [] = cb_chooseDeg(src, ~, fH100, StrH)

saveStr = src.String;
saveVal = src.Value;

Deg =  str2num(saveStr{saveVal});

setappdata(fH100, StrH, Deg);

append_to_log(['[' StrH ' = ' num2str(Deg) ']'])
end

%% Choose Radio Button
function [] = cb_modeSelection(src, event, fH100)

str = event.NewValue.String;

switch str
    
    case 'Stereo'
        mode = 1;
    case 'Mono-Ch1'
        mode = 2;
    case 'Mono-Ch2'
        mode = 3;
end

setappdata(fH100, 'defMode', mode);%###
append_to_log(['[Mode = ' num2str(mode) ']'])
  
disp('')
end


function [filNoise_ramp] = cb_create_bpWN(WN_lo, WN_hi, stimDur_s, sf, rampDur_s)

lf = WN_lo;   % lowest frequency
hf = WN_hi;   % highest frequency
%% Create Noise Stimulus
%http://www.h6.dion.ne.jp/~fff/old/technique/auditory/matlab.html#cramp

% set general variables
nf = sf / 2; % nyquist frequency

n = round(sf * stimDur_s);  % number of samples
nh = n / 2;  % half number of samples

% =========================================================================
% set variables for filter
lp = lf * stimDur_s; % ls point in frequency domain
hp = hf * stimDur_s; % hf point in frequency domain

% design filter
a = ['BANDPASS'];
filter = zeros(1, n);           % initializaiton by 0
filter(1, lp : hp) = 1;         % filter design in real number
filter(1, n - hp : n - lp) = 1; % filter design in imaginary number

% =========================================================================
% make noise
%rand('state',sum(100 * clock));  % initialize random seed
rng('default')
rng(1) % for consistency?
noise = randn(1, n);             % Gausian noise
noise = noise / max(abs(noise)); % -1 to 1 normalization

% do filter
filNoise = fft(noise);                  % FFT
filNoise = filNoise .* filter;                 % filtering
filNoise = ifft(filNoise);                     % inverse FFT
filNoise = real(filNoise);

%% Do ramp Onset and Offset

% prepare ramp
nr = floor(sf * rampDur_s);
ramp = sin(linspace(0, pi/2, nr));
ramp = [ramp, ones(1, n - nr * 2), fliplr(ramp)];

filNoise_ramp = filNoise .* ramp;


end

%% EOF

