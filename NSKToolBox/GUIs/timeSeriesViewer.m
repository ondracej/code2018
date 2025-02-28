function timeSeriesViewer(varargin)
%% %%%%%%%%%%%%%%%%%%%%%%%%%% Definition of default values %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AVG.recordingObj=[]; %initiate recording object

%directories
AVG.Params.NSKToolBoxMainDir=fileparts(which('identifierOfMainDir4NSKToolBox'));

dirSep=filesep; %choose file/dir separator according to platform

AVG.Params.dataClassDirectory=[AVG.Params.NSKToolBoxMainDir dirSep 'dataRecordingObjects' dirSep];
AVG.Params.dataAnalysisDirectory=[AVG.Params.NSKToolBoxMainDir dirSep 'GUIs' dirSep 'dataAnalysis' dirSep];
AVG.Params.colormapFileDirectory=[AVG.Params.NSKToolBoxMainDir dirSep 'GUIs' dirSep 'colormaps' dirSep];

AVG.Params.defaultColorMap='colormapHot128';
colormapFiles=dir([AVG.Params.colormapFileDirectory 'colormap*.mat']);
AVG.Params.colormapList=cellfun(@(x) x(1:end-4),{colormapFiles.name},'UniformOutput',0);
AVG.Params.currentColormap=find(strcmp(AVG.Params.colormapList,AVG.Params.defaultColorMap));
AVG.Params.colormap=load(AVG.Params.colormapList{AVG.Params.currentColormap},'cmap');
AVG.Params.colormap=AVG.Params.colormap.cmap;

AVG.Params.defaultActiveChannels=[];
%AVG.Params.defaultPlotName='ActivityTracePhysicalSpace'; %out of the plot list
AVG.Params.defaultPlotName='ActivityTrace'; %out of the plot list
AVG.Params.scrollBarPixels=20;
AVG.Params.shortTimeFrameMovement=0.2; % [0-1] movement relative to window size
AVG.Params.AVversion='1.0';
AVG.Params.scroolYZoomFactor=0.02; %[0-1]
AVG.Params.mouseBottonPressIndicator=0; %an indicator specifying if the mouse botton is currently pressed
AVG.Params.defaultStartTime=0; %[ms]
AVG.Params.defaultWindow=500; %[ms]
test=[]; %a dummy paramter for testing
AVG.Params.exportFigNumber=1; %initialize export figure counter
AVG.Params.maxNumberOfTriggerInColumn=5; %the maximal number of trigger checkbox objects in a column - above this number stacking is also done over rows 
AVG.Params.defaultTriggerOffset=0; % the default value for trigger offset
AVG.Params.selectedAnalysis=[]; %initialize analysis options

%filter
AVG.Params.filterDesigns={'ellip','butter','cheby1','cheby2','equiripple','kaiserwin'}; %should be listed in filter object
AVG.Params.defaultFilterValue=1;
AVG.Params.defaultFilterOrder=8;
AVG.Params.defaultPadding=20; %[ms]
AVG.Params.defaultFilterLowPassStopFreq=2100; %[Hz]
AVG.Params.defaultFilterHighPassPassFreq=200; %[Hz]
AVG.Params.defaultFilterLowPassPassFreq=2000; %[Hz]
AVG.Params.defaultFilterHighPassStopFreq=190; %[Hz]
AVG.Params.defaultRippleInPassband=0.5; %Ap
AVG.Params.defaultAttenuationInHighpass=4; %Ast
AVG.Params.defaultAttenuationInLowpass=4; %Ast
AVG.Params.defaultFilterSamplingRatio=1;
AVG.Params.defaultFilterMethodValue=1;
AVG.Params.samplingFrequency(1)=20000;

if nargin~=floor(nargin/2)*2
    AVG.recordingObj=varargin{1};
    varargin=varargin(2:end);
end
%get input data into AVG.Params. ('property','value' format);
for v=1:2:length(varargin)
    eval(['AVG.Params.' varargin{v} '=' 'varargin{v+1};'])
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%% Initialization of objects %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%initialize params
AVG.Params.filterPadding=AVG.Params.defaultPadding;

%construct plot object - this object contains the data and the different plot types are its methods
AVG.plotData=AVPlotData;
%initiate with arbitrary data
AVG.plotData.M=randn(10,1,100);
AVG.plotData.T=1:100;

%collect all plot types
[AVG.Params.PlotMethods,AVG.Params.PlotList]=AVG.plotData.getPlotNames;
AVG.Params.currentPlotName=AVG.Params.defaultPlotName;

%collect all analysis methods
AVG.Params.analysisMethods=dir([AVG.Params.dataAnalysisDirectory 'analysis*.m']);
AVG.Params.analysisMethods={AVG.Params.analysisMethods.name};
AVG.Params.analysisMethods=cellfun(@(x) x(1:end-2),AVG.Params.analysisMethods,'UniformOutput',0);
AVG.Params.analysisMethodsNames=cellfun(@(x) x(9:end),AVG.Params.analysisMethods,'UniformOutput',0);
%reorder methods so that Filter is the first method
pFilter=strcmp(AVG.Params.analysisMethods,'analysisFilter');
AVG.Params.analysisMethods=[AVG.Params.analysisMethods(pFilter) AVG.Params.analysisMethods(~pFilter)];
AVG.Params.analysisMethodsNames=[AVG.Params.analysisMethodsNames(pFilter) AVG.Params.analysisMethodsNames(~pFilter)];

%get all dataRecording objects
AVG.Params.dataRecordingClasses=dir([AVG.Params.dataClassDirectory '@*']);
AVG.Params.dataRecordingClasses={AVG.Params.dataRecordingClasses.name};
AVG.Params.dataRecordingClasses=cellfun(@(x) x(2:end),AVG.Params.dataRecordingClasses,'UniformOutput',0);

%construct filter object
AVG.filterObj=filterData; %filter constructor - initialized without sampling frequency
[AVG.Params.filterMethods,AVG.Params.filterNames]=AVG.filterObj.getFilters; %get all filtering methods

%create GUI
createAVGUI;

set(AVG.hMainFigure.hMainAxis,'YLimMode','manual');

if ~isempty(AVG.recordingObj) %initiate viewer with input dataRecording object
    initializeNewRecording;
end
        %% %%%%%%%%%%%%%%%% Nested functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%% Update plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function updatePlot()
        %status==0 basic update
        %status==1 channel update
        set(AVG.hGen.messageBox,'string','Plotting data','ForegroundColor','r');drawnow;
        %set channel data
        AVG.plotData.channelNumbers=AVG.Params.channelNumbers(AVG.Params.activeChannelPlaces);
        AVG.plotData.channelNames=AVG.Params.channelNames(AVG.Params.activeChannelPlaces);
        AVG.plotData.recordingObjReference=AVG.recordingObj; %in case something should be changed in the recording object from the GUI
        %set activity data
        if any(AVG.Params.selectedAnalysis==1) % a filter was selected -> data is padded
            [AVG.plotData.M,AVG.plotData.T]=AVG.recordingObj.getData(AVG.Params.channelNumbers(AVG.Params.activeChannelPlaces),...
                AVG.Params.startTime-AVG.Params.filterPadding,AVG.Params.window+2*AVG.Params.filterPadding);
            for i=AVG.Params.selectedAnalysis
                if i==1 %case filter
                    [AVG.plotData.M]=AVG.filterObj.getFilteredData(AVG.plotData.M);
                else
                    feval(AVG.Params.analysisMethods{i},AVG.plotData);
                end
            end
            %implement a cut edges method for the parent class
            AVG.plotData.M=AVG.plotData.M(:,:,AVG.Params.paddingSamples+1:end-AVG.Params.paddingSamples);
            AVG.plotData.T=AVG.plotData.T(1:end-AVG.Params.paddingSamples*2); %the first time is 0
        else
            [AVG.plotData.M,AVG.plotData.T]=AVG.recordingObj.getData(...
                AVG.Params.channelNumbers(AVG.Params.activeChannelPlaces),AVG.Params.startTime,AVG.Params.window);
            for i=AVG.Params.selectedAnalysis
                if i==1 %case filter
                    AVG.plotData.M=AVG.filterObj.getFilteredData(AVG.plotData.M);
                else
                    feval(AVG.Params.analysisMethods{i},AVG.plotData);
                end
            end
        end
        
        %Run the relevant plot method
        AVG.plotData.replot;
        
        %set slider
        set(AVG.hMainFigure.hTimeSlider,'value',(AVG.Params.startTime(1)+AVG.Params.window) /(AVG.recordingObj.recordingDuration_ms+AVG.Params.window));
        
        set(AVG.hGen.messageBox,'string','Ready','ForegroundColor','k');
    end
%% %%%%%%%%%%%%%%%%%%%%%%%%%% Initialize viewer %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function initializeViewer()
        %Recording object
        if iscell(AVG.recordingObj.recordingName)
            AVG.recordingObj.recordingName=AVG.recordingObj.recordingName{1};
        end
        set(AVG.hMainFigure.hFigure,'name',['Activity viewer - ' AVG.recordingObj.recordingDir ' - ' AVG.recordingObj.recordingName]);
        AVG.Params.startDate=AVG.recordingObj.startDate; %show with: datestr(AVG.Params.startDate)
        AVG.Params.endDate=AVG.recordingObj.endDate;
        AVG.Params.recordingTimeLimits=[0 AVG.recordingObj.recordingDuration_ms];
        
        %adjust trigger related features
        isTriggerActive=cellfun(@(x) ~isempty(x), AVG.Params.triggers); %empty triggers are automatically set to non-active
        if sum(isTriggerActive)>0
            AVG.Params.triggers=AVG.Params.triggers(isTriggerActive);
            AVG.Params.nTriggers=sum(isTriggerActive);
            AVG.Params.currentTrigger=AVG.Params.triggers{1}; %set the first trigger as the current trigger
            [AVG.Params.currentTriggerSorted,AVG.Params.currentTriggerSortedOrder]=sort(AVG.Params.currentTrigger);
            AVG.Params.nCurrentTriggers=numel(AVG.Params.currentTrigger);
        else
            AVG.Params.nTriggers=0;
            AVG.Params.currentTrigger=[];
            AVG.Params.nCurrentTriggers=0;
        end
        AVG.Params.triggerOffset=AVG.Params.defaultTriggerOffset;
        createTriggerGUI(); %also updates gui in the case of no triggers
        
        %adjust sampling frequency related features
        AVG.Params.samplingFrequency=AVG.recordingObj.samplingFrequency;
        AVG.Params.Bin=1/AVG.Params.samplingFrequency(1)*1000; %convert from sampling freq [Hz] to time [ms]
        
        %adjust channels
        AVG.Params.channelNames=AVG.recordingObj.channelNames;
        AVG.Params.channelNumbers=AVG.recordingObj.channelNumbers;
        AVG.Params.activeChannelPlaces=1:numel(AVG.Params.channelNumbers);
        
        %adjust start time
        AVG.Params.startTime=AVG.Params.defaultStartTime; %[ms]
        AVG.Params.window=AVG.Params.defaultWindow; %[ms]
        AVG.Params.multiStartTime=numel(AVG.Params.startTime)>1;
        set(AVG.hNav.startTimeEdit,'string',AVG.Params.defaultStartTime);
        set(AVG.hNav.WindowEdit,'string',AVG.Params.defaultWindow);
        set(AVG.hNav.TimeTxt,'string',['start time [ms] /' num2str(AVG.Params.recordingTimeLimits(2))])
        
        %construct filter object
        %AVG.filterObj=filterData(AVG.Params.samplingFrequency(1)); %filter constructor
        AVG.filterObj.samplingFrequency=AVG.Params.samplingFrequency(1);
        set(AVG.hFilter.hSamplingFrequencyEdit,'string',num2str(AVG.Params.samplingFrequency(1)));
        AVG.Params.paddingSamples=AVG.Params.filterPadding/1000*AVG.Params.samplingFrequency(1);
        designFilter; %design the filter
                
        %delete previous plot
        AVG.plotData.deletePlotBackground;
        AVG.plotData.deletePlotControls;
        %initialize new plot
        AVG.plotData.initializePlot(AVG.Params.currentPlotName,AVG.hMainFigure.hMainAxis,AVG.hPlotProp.hMainPanel);
        
        set(AVG.hGen.messageBox,'string','Ready','ForegroundColor','k');
    end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% General GUI Callbacks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function closeMainGUIFigure(hObj,event)
        delete(AVG.plotData);
        delete(AVG.hMainFigure.hFigure);
        clear AVG;
    end
    function CallbackTimeSlider(hObj,event)
        sliderVal=get(AVG.hMainFigure.hTimeSlider,'value');
        AVG.Params.startTime=sliderVal*(AVG.recordingObj.recordingDuration_ms+AVG.Params.window)-AVG.Params.window;
        set(AVG.hNav.startTimeEdit,'string',num2str(AVG.Params.startTime));
        updatePlot;
    end
    function CallbackRestartPlotPush(hObj,event)
        delete(allchild(AVG.hMainFigure.hFigure));
        AVG.plotData.delete;
        AVG.plotData=AVPlotData;
        createAVGUI(AVG.hMainFigure.hFigure);
        createTriggerGUI();
        
        set(AVG.hMainFigure.hMainAxis,'YLimMode','manual');
        
        initializeViewer;
        updatePlot;
    end
    function CallbackRefreshPlotPush(hObj,Event)
        updatePlot;
    end
    function CallbackExportPlotPush(hObj,Event)
        cmap=get(AVG.hMainFigure.hFigure,'colormap');
        hNewFig=figure('Position',[10 65 1700 940]);
        copyobj(AVG.hMainFigure.hMainAxis,hNewFig);
        
        hAxes=get(hNewFig,'Children');
        hAxes(1).Units='normalized';
        set(hAxes(1),'FontSize',12,'Position',[0.07 0.07 0.91 0.91]);
        set(get(hAxes(1),'xlabel'),'fontsize',14);
        set(get(hAxes(1),'ylabel'),'fontsize',14);
        
        set(hNewFig,'Colormap',cmap,'PaperPositionMode','auto');
        assignin('base',['hExportedPlot' num2str(AVG.Params.exportFigNumber)],hNewFig);
        AVG.Params.exportFigNumber=AVG.Params.exportFigNumber+1;
    end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Menu Callbacks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function CallbackExportData(hObj,event)
        dlgOptions.WindowStyle='normal';
        dataVarible = inputdlg({'Please enter variable name:'},'Export data to workspace',1,{''},dlgOptions);
        assignin('base',[dataVarible{1} '_T'],AVG.plotData.T);
        assignin('base',[dataVarible{1} '_M'],AVG.plotData.M);
        disp('In exported data, M is structured as: [Channels x Trials x Time] and T is the corresponding times in [ms]');
    end

    function CallbackDataTypeSelection(hObj,event)
        %set all fields in menu to off
        for i=1:length(AVG.Params.dataRecordingClasses)
            set(AVG.hMenubar.hRecording.(AVG.Params.dataRecordingClasses{i}),'checked','off');
        end
        set(hObj,'Checked','on');
        AVG.Params.currentDataType=get(hObj,'Label');
        
        eval(['AVG.recordingObj=' AVG.Params.currentDataType ';']); %create a data recording object
        initializeNewRecording;
    end

    function CallbackCredits(hObj,event)
        msgbox({'Developed by Mark Shein-Idelson','e-mail: shein.mark@gmail.com'},'Main developers and contributers');
    end

    function initializeNewRecording
        set(AVG.hGen.messageBox, 'string','Initializing new data','ForegroundColor','r');
        
        if AVG.hTrigger.hGetTrigFromRawFiles.Value
            AVG.Params.triggers=AVG.recordingObj.getTrigger(); %this is the most time consuming step
        else
            AVG.Params.triggers={};
        end
        
        initializeViewer;
        AVG.plotData.refreshPlot=1;
        updatePlot;
    end

    function CallbackPlotTypeSelection(hObj,event)
        %set all fields in menu to off
        for i=1:numel(AVG.Params.PlotMethods)
            set(AVG.hMenubar.hPlot.(AVG.Params.PlotList{i}),'checked','off');
        end
        set(hObj,'Checked','on');
        AVG.Params.currentPlotName=get(hObj,'Label');
        
        %delete previous plot
        AVG.plotData.deletePlotBackground;
        AVG.plotData.deletePlotControls;
        
        AVG.plotData.initializePlot(AVG.Params.currentPlotName,AVG.hMainFigure.hMainAxis,AVG.hPlotProp.hMainPanel);
        AVG.plotData.refreshPlot=1;
        updatePlot;
    end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Mouse Callbacks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%for the mouse callback to be activated the text below should be entered into section creating the GUI
%        iptPointerManager(AVG.hMainFigure.hFigure);
%        mainPlotPointerBehaviour.enterFcn=@CallbackMouseEnterMainPlot;
%        mainPlotPointerBehaviour.exitFcn=@CallbackMouseExitMainPlot;
%        mainPlotPointerBehaviour.traverseFcn=@CallbackMouseTransverseMainPlot;
%        iptSetPointerBehavior(AVG.hMainFigure.hMainAxis, mainPlotPointerBehaviour);
%in addition, the following properties should be set in the figure handle:
%        'WindowButtonMotionFcn',@CallbackMouseMotion,'WindowButtonDownFcn',@CallbackMouseBottonPress, 'WindowButtonUpFcn',@CallbackMouseBottonRelease,'WindowScrollWheelFcn',@CallbackMouseWheelScroll


    function CallbackMouseMotion(hObj,event)
        %AVG.mouse.Position=get(hObj, 'currentpoint'); % get mouse location on figure
    end
    function CallbackMouseWheelScroll(hObj,event)
        yl=ylim(AVG.hMainFigure.hMainAxis);
        dist=yl(2)-yl(1);
        if AVG.Params.mouseBottonPressIndicator==0
            ylim(AVG.hMainFigure.hMainAxis,yl+[-1 1]*dist*AVG.Params.scroolYZoomFactor*event.VerticalScrollCount*event.VerticalScrollAmount)
        else
            ylim(AVG.hMainFigure.hMainAxis,yl+[1 1]*dist*AVG.Params.scroolYZoomFactor*event.VerticalScrollCount*event.VerticalScrollAmount)
        end
    end
    function CallbackMouseBottonPress(hObj,event)
        AVG.Params.mouseBottonPressIndicator=1;
    end
    function CallbackMouseBottonRelease(hObj,event)
        AVG.Params.mouseBottonPressIndicator=0;
    end
    function CallbackMouseEnterMainPlot(hFig,currentPoint)
        set(hFig,'Pointer','hand');
    end
    function CallbackMouseExitMainPlot(hFig,currentPoint)
        set(hFig,'Pointer','arrow');
    end
    function CallbackMouseTransverseMainPlot(hFig,currentPoint)
    end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Navigation Callbacks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function CallbackNavTimeFrameMovePush(hObj,event,mov)
        newStartTime=AVG.Params.startTime+mov*AVG.Params.window;
        if any(newStartTime>=(AVG.Params.recordingTimeLimits(2)))
            msgbox('End of recording reached','Attention','error','replace');
        elseif any(newStartTime<AVG.Params.recordingTimeLimits(1)-AVG.Params.window)
            msgbox('Beginning of recording reached','Attention','error','replace');
        else
            AVG.Params.startTime=newStartTime;
            set(AVG.hNav.startTimeEdit,'string',num2str(newStartTime));
            updatePlot;
        end
    end

    function CallbackNavZoomPush(hObj,event,windowChange)
        winCenter=AVG.Params.startTime+AVG.Params.window/2;
        AVG.Params.window=AVG.Params.window*windowChange;
        AVG.Params.startTime=winCenter-AVG.Params.window/2;
        set(AVG.hNav.WindowEdit,'string',num2str(AVG.Params.window));
        set(AVG.hNav.startTimeEdit,'string',num2str(AVG.Params.startTime));
        updatePlot;
    end

    function CallbackNavTimeEdit(hObj,event)
        newStartTime=str2num(get(AVG.hNav.startTimeEdit,'string'));
        if any(newStartTime>AVG.Params.recordingTimeLimits(2))
        %if any(newStartTime>(AVG.Params.recordingTimeLimits(2)-2*AVG.Params.window)) %changed to above on 091014 for testing
            msgbox('End of recording reached','Attention','error','replace');
            set(AVG.hNav.startTimeEdit,'string',num2str(AVG.Params.startTime));
        elseif any(newStartTime<AVG.Params.recordingTimeLimits(1)-AVG.Params.window)
            msgbox('Beginning of recording reached','Attention','error','replace');
            set(AVG.hNav.startTimeEdit,'string',num2str(AVG.Params.startTime));
        else
            if numel(newStartTime)<=1 && AVG.Params.multiStartTime
                set(AVG.hNav.TimeTxt,'string','start time [ms]','ForegroundColor','k');
                AVG.Params.multiStartTime=0;
                AVG.plotData.refreshPlot=1;
            elseif numel(newStartTime)>1
                set(AVG.hNav.TimeTxt,'string','start times [ms] (multi-mode)','ForegroundColor','r');
                AVG.Params.multiStartTime=1;
            end
            AVG.Params.startTime=newStartTime;
            updatePlot;
        end
    end

    function CallbackNavWindowEdit(hObj,event)
        AVG.Params.window=str2num(get(hObj,'string'));
        updatePlot;
    end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Channel selection Callbacks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function CallbackChAddChannelsEdit(hObj,event)
        ChannelsToAdd=str2num(get(hObj,'string'));
        for i=1:numel(ChannelsToAdd)
            P=find(AVG.Params.activeChannelPlaces==ChannelsToAdd(i));
            if ~isempty(P)
                AVG.Params.activeChannelPlaces=[AVG.Params.activeChannelPlaces P];
            end
        end
        set(hObj,'string','Add channels'); %replace entered channel string with default string
        updatePlot;
    end

    function CallbackChRemoveChannelsEdit(hObj,event)
        %If a channel that was selected does not exist or is already removed, it is not removed and no error is given
        ChannelsToRemove=str2num(get(hObj,'string'));
        for i=1:length(ChannelsToRemove)
            AVG.Params.activeChannelPlaces(find(AVG.Params.channelNumbers(AVG.Params.activeChannelPlaces)==ChannelsToRemove(i)))=[];
        end
        set(hObj,'string','Remove channels');%replace entered channel string with default string
        updatePlot;
    end

    function CallbackChKeepOnlyChannelsEdit(hObj,event)
        ChannelsToKeep=str2num(get(hObj,'string'));
        tmpActiveChannels=zeros(1,numel(ChannelsToKeep));
        for i=1:length(ChannelsToKeep)
            P=find(AVG.Params.channelNumbers==ChannelsToKeep(i));
            if ~isempty(P)
                tmpActiveChannels(i)=P;
            else
                disp('Part of the selected channels do not exist in the recording!!!!');
                return;
            end
        end
        AVG.Params.activeChannelPlaces=tmpActiveChannels;
        set(hObj,'string','Keep only channels');%replace entered channel string with default string
        updatePlot;
    end

    function CallbackChEnableAllChannelsPush(hObj,event)
        AVG.Params.activeChannelPlaces=1:numel(AVG.Params.channelNumbers);
        updatePlot;
    end

    function CallbackChManualChannelSelectPush(hObj,event)
        channelsPerColumn=30;
        nActiveChannels=length(AVG.Params.activeChannelPlaces);
        nChannels=numel(AVG.Params.channelNumbers);
        AVG.manualChannelSelectionFigure.hFigure = figure('Position',[AVG.hMainFigure.scrsz(3)*0.01 AVG.hMainFigure.scrsz(4)*0.07 AVG.hMainFigure.scrsz(3)*0.3 AVG.hMainFigure.scrsz(4)*0.85], ...
            'Name','Activity Viewer - manual channel selection', 'NumberTitle','off', 'MenuBar','none', 'Toolbar','none', 'HandleVisibility','off');
        AVG.manualChannelSelectionFigure.VBox=uix.VBox('Parent',AVG.manualChannelSelectionFigure.hFigure, 'Spacing',4, 'Padding',4);
        AVG.manualChannelSelectionFigure.hChannelGrid = uix.Grid('Parent',AVG.manualChannelSelectionFigure.VBox, 'Spacing',5, 'Padding',10);
        AVG.manualChannelSelectionFigure.applySelectionPush=uicontrol('Parent', AVG.manualChannelSelectionFigure.VBox, 'Callback',{@CallbackManualChSelectionApplyPush,}, 'Style','push', 'String','Apply selection');
        for i=1:nChannels
            AVG.manualChannelSelectionFigure.hCh(i)=uicontrol('Parent', AVG.manualChannelSelectionFigure.hChannelGrid, ...
                'Style','checkbox', 'String', [num2str(AVG.Params.channelNumbers(i)) ' - ' AVG.Params.channelNames{i}],'value',0);
        end
        for i=1:nActiveChannels
            set(AVG.manualChannelSelectionFigure.hCh(AVG.Params.activeChannelPlaces),'value',1);
        end
        set(AVG.manualChannelSelectionFigure.hChannelGrid,'Widths',-1*ones(1,ceil(nActiveChannels/channelsPerColumn)),'Heights', -1*ones(1,channelsPerColumn));
        set(AVG.manualChannelSelectionFigure.VBox, 'Heights',[-1 30]);
    end

    function CallbackManualChSelectionApplyPush(hObj,event)
        for i=1:numel(AVG.Params.channelNumbers)
            p(i)=get(AVG.manualChannelSelectionFigure.hCh(i),'value');
        end
        AVG.Params.activeChannelPlaces=AVG.Params.channelNumbers(p==1);
        delete(AVG.manualChannelSelectionFigure.hFigure);
        updatePlot;
    end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Filter Callbacks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function CallbackFilterLowPassPassEdit(hObj,event),designFilter,end
    function CallbackFilterHighPassPassEdit(hObj,event),designFilter,end
    function CallbackFilterLowPassStopEdit(hObj,event),designFilter,end
    function CallbackFilterHighPassStopEdit(hObj,event),designFilter,end
    function CallbackFilterMethodPopup(hObj,event),designFilter,end
    function CallbackFilterOrderEdit(hObj,event),designFilter,end
    function CallbackFilterSamplingRatioEdit(hObj,event),designFilter,end
    function CallbackFilterSamplingFrequencyEdit(hObj,event),designFilter,end
    function CallbackFilterDesignPopup(hObj,event),designFilter,end
    function CallbackFilterRippleEdit(hObj,event),designFilter,end
    function CallbackFilterLowPassAttenuationEdit(hObj,event),designFilter,end
    function CallbackFilterHighPassAttenuationEdit(hObj,event),designFilter,end

    function CallbackPaddingSamplesEdit(hObj,event)
        AVG.Params.filterPadding=str2num(get(hObj,'string'));
        AVG.Params.paddingSamples=AVG.Params.filterPadding/1000*AVG.Params.samplingFrequency(1);
    end
    function CallbackPlotFilterPush(hObj,event)
        AVG.filterObj.plotFilter;
    end
    function designFilter()
        methodValue=get(AVG.hFilter.hMethodPopup,'value');
        AVG.filterObj.filterOrder=str2num(get(AVG.hFilter.hOrderEdit,'string'));
        AVG.filterObj.filterDesign=AVG.Params.filterDesigns{get(AVG.hFilter.hDesignPopup,'value')};
        AVG.filterObj.highPassPassCutoff=str2num(get(AVG.hFilter.hHighPassPassEdit,'string'));
        AVG.filterObj.highPassStopCutoff=str2num(get(AVG.hFilter.hHighPassStopEdit,'string'));
        AVG.filterObj.lowPassPassCutoff=str2num(get(AVG.hFilter.hLowPassPassEdit,'string'));
        AVG.filterObj.lowPassStopCutoff=str2num(get(AVG.hFilter.hLowPassStopEdit,'string'));
        AVG.filterObj.rippleInPassband=str2num(get(AVG.hFilter.hRippleEdit,'string'));
        AVG.filterObj.attenuationInHighpass=str2num(get(AVG.hFilter.hHighpassAttenuationEdit,'string'));
        AVG.filterObj.attenuationInLowpass=str2num(get(AVG.hFilter.hLowpassAttenuationEdit,'string'));
        AVG.filterObj.downSamplingFactor=str2num(get(AVG.hFilter.hSamplingRatioEdit,'string'));
        
        if ~strcmp(AVG.filterObj.currentDesignedFilter,'bandstop')
            if AVG.Params.samplingFrequency(1)<2*AVG.filterObj.lowPassPassCutoff
                AVG.filterObj.lowPassStopCutoff=AVG.Params.samplingFrequency(1)/2;
                AVG.filterObj.lowPassPassCutoff=AVG.filterObj.lowPassStopCutoff*0.95;
                set(AVG.hFilter.hHighPassPassEdit,'string',num2str(AVG.filterObj.highPassPassCutoff));
                set(AVG.hFilter.hHighPassStopEdit,'string',num2str(AVG.filterObj.highPassStopCutoff));
                disp('Notice: filter settings were changed since sampling frequency was lower than the highpass cutoff');
            end
            if AVG.filterObj.lowPassPassCutoff<=AVG.filterObj.highPassPassCutoff
                
                AVG.filterObj.highPassStopCutoff=AVG.filterObj.lowPassPassCutoff/2;
                AVG.filterObj.highPassPassCutoff=AVG.filterObj.highPassStopCutoff*1.05;
                
                set(AVG.hFilter.hHighPassPassEdit,'string',num2str(AVG.filterObj.highPassPassCutoff));
                set(AVG.hFilter.hHighPassStopEdit,'string',num2str(AVG.filterObj.highPassStopCutoff));
                disp('Notice: filter settings were changed since highpass cutoff was higher than lowpass cutoff');
            end
        end
        
        AVG.filterObj=AVG.filterObj.(AVG.Params.filterMethods{methodValue}); %design the filter
        set(AVG.hFilter.hOrderEdit,'string',num2str(AVG.filterObj.filterOrder));
    end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Analysis Callbacks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function CallbackAnaysisTogglePush(hObj,Event,select)
        if get(hObj,'value')
            AVG.Params.selectedAnalysis=[AVG.Params.selectedAnalysis select];
        else
            set(AVG.hAnalysis.hToggleButtons(select),'string',[AVG.Params.analysisMethodsNames{select} ' (-)']);
            AVG.Params.selectedAnalysis(find(AVG.Params.selectedAnalysis==select))=[];
        end
        for i=1:numel(AVG.Params.selectedAnalysis)
            set(AVG.hAnalysis.hToggleButtons(AVG.Params.selectedAnalysis(i)),'string',[AVG.Params.analysisMethodsNames{AVG.Params.selectedAnalysis(i)} ' (' num2str(i) ')']);
        end
    end
    function CallbackRemoveAllAnalysisPush(hObj,event)
        set(AVG.hAnalysis.hToggleButtons,'value',0);
        for i=1:numel(AVG.hAnalysis.hToggleButtons)
            set(AVG.hAnalysis.hToggleButtons(i),'string',[AVG.Params.analysisMethodsNames{i} ' (-)']);
        end
        AVG.Params.selectedAnalysis=[];
    end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Trigger Callbacks %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function CallbackManualSetPush(hObj,Event)
        trigIn=get(AVG.hTrigger.manualSetEdit,'string');
        if ~isempty(trigIn)
            tmpTrig={str2num(trigIn)};
            if AVG.Params.nTriggers==0
                AVG.Params.triggers=tmpTrig;
            else
                AVG.Params.triggers=[AVG.Params.triggers tmpTrig];
            end
            AVG.Params.nTriggers=AVG.Params.nTriggers+1;
            createTriggerGUI();
            set(AVG.hTrigger.manualSetEdit,'string','');
            CallbackTriggerCheckbox([],[],AVG.Params.nTriggers)
        else
            disp('Trigger input not provided!');
        end
    end

    function CallbackTrigOffset(hObj,Event)
        tmp=str2num(get(AVG.hTrigger.hOffsetEdit,'string'));
        if isnumeric(tmp) && numel(tmp)==1
            AVG.Params.triggerOffset=tmp;
        else
            msgbox('Input delay is not a valid number','Attention','error','replace');
            set(AVG.hTrigger.hOffsetEdit,'string',0);
        end
    end

    function CallbackManualLoadFile(hObj,Event)
        [tmpTrigFile,tmpTrigDir]= uigetfile('*.mat','Choose the Mat file',cd,'MultiSelect','on');
        if tmpTrigFile==0 %no folder chosen
            msgbox('File was not chosen and triggers were not added','Attention','error','replace');
        else
            tmpTrig=load([tmpTrigDir dirSep tmpTrigFile]);
            trigName=fields(tmpTrig);
            trigName=trigName{1};
            
            tmpTrig=tmpTrig.(trigName);
            if ~iscell(tmpTrig)
                error('Trigger variable should be a cell array of trigger vectors');
            end
            AVG.Params.nTriggers=AVG.Params.nTriggers+numel(tmpTrig);
            AVG.Params.triggers=[AVG.Params.triggers tmpTrig];
            createTriggerGUI();
            CallbackTriggerCheckbox([],[],AVG.Params.nTriggers);
        end
    end

    function CallbackManualLoadVariable(hObj,Event)
        dlgOptions.WindowStyle='normal';
        triggerVar = inputdlg({'Please enter variable name:'},'Get trigger from workspace',1,{''},dlgOptions);
        tmpTrig=[];
        evalin('base',['assignin(''caller'',''tmpTrig'',' triggerVar{1} ')']);
        if iscell(tmpTrig)
            AVG.Params.nTriggers=AVG.Params.nTriggers+numel(tmpTrig);
            AVG.Params.triggers=[AVG.Params.triggers tmpTrig];
        elseif isnumeric(tmpTrig)
            AVG.Params.nTriggers=AVG.Params.nTriggers+1;
            AVG.Params.triggers=[AVG.Params.triggers {tmpTrig}];            
        else
            error('Trigger variable should be a cell array of trigger vectors, or a numeric array with one vector');
        end

        createTriggerGUI();
        CallbackTriggerCheckbox([],[],AVG.Params.nTriggers);
    end

    function CallbackTriggerNumberEdit(hObj,Event)
        tmpTriggerNumber=str2num(get(AVG.hTrigger.hNumber,'string'));
        if tmpTriggerNumber>AVG.Params.nCurrentTriggers || tmpTriggerNumber<1
            msgbox('Selected trigger number is not within current trigger limits','Attention','error','replace');
            set(AVG.hTrigger.hNumber,'string','0');
        else
            newTime=AVG.Params.currentTrigger(tmpTriggerNumber);
            AVG.Params.startTime=newTime+AVG.Params.triggerOffset;
            set(AVG.hNav.startTimeEdit,'string',num2str(AVG.Params.startTime));
            CallbackNavTimeEdit()
        end
        
    end

    function CallbackTriggerDirectionPush(hObj,Event,direction)        
        if direction==1 %forward direction
            if AVG.Params.startTime(1)<AVG.Params.currentTriggerSorted(end)+AVG.Params.triggerOffset
                tmpNumber=AVG.Params.currentTriggerSortedOrder(find(AVG.Params.currentTriggerSorted>(0.001+AVG.Params.startTime(1)-AVG.Params.triggerOffset),1,'first'));
                if isempty(tmpNumber) %this is only reached in extreme cases due to rounding problems
                    msgbox('Ending of trigger list reached','Attention','error','replace');
                    return;
                end
            else
                msgbox('Ending of trigger list reached','Attention','error','replace');
                return;
            end
        else %backward direction
            if AVG.Params.startTime(1)>(AVG.Params.currentTriggerSorted(1)+AVG.Params.triggerOffset)
                tmpNumber=AVG.Params.currentTriggerSortedOrder(find(AVG.Params.currentTriggerSorted<(AVG.Params.startTime(1)-AVG.Params.triggerOffset-0.001),1,'last'));
                if isempty(tmpNumber) %this is only reached in extreme cases due to rounding problems
                    msgbox('Beginning of trigger list reached','Attention','error','replace');
                    return;
                end
            else
                msgbox('Beginning of trigger list reached','Attention','error','replace');
                return;
            end
        end
        newTime=AVG.Params.currentTrigger(tmpNumber);
        set(AVG.hTrigger.hNumber,'string',num2str(tmpNumber));
        AVG.Params.startTime=newTime+AVG.Params.triggerOffset;
        set(AVG.hNav.startTimeEdit,'string',num2str(AVG.Params.startTime));
        CallbackNavTimeEdit()
    end

    function CallbackExportSelectedTrigger(hObj,Event)
        assignin('base','exportedTrigger',AVG.Params.currentTrigger);
    end

    function CallbackSendTriggerToStartTime(hObj,Event)
        if AVG.Params.nTriggers>0
            set(AVG.hNav.startTimeEdit,'string',num2str(AVG.Params.currentTrigger+AVG.Params.triggerOffset))
            CallbackNavTimeEdit()
        else
            msgbox('There are no selected triggers','Attention','error','replace');
        end
    end

    function CallbackDeleteTrigger(hObj,Event)
        %delete selected trigger
        selectedTrigger=find(cell2mat(get(AVG.hTrigger.hCheck,'value')));
        AVG.Params.triggers(selectedTrigger)=[];
        AVG.Params.nTriggers=AVG.Params.nTriggers-1;
        createTriggerGUI();
    end

    function CallbackAddTrigSubPopPush(hObj,Event)
        tmp=str2num(get(AVG.hTrigger.selectSubPopEdit,'string'));
        if isnumeric(tmp) && min(tmp)>0 && max(tmp)<=numel(AVG.Params.currentTrigger)
            AVG.Params.triggers=[AVG.Params.triggers {AVG.Params.currentTrigger(tmp)}];
            AVG.Params.nTriggers=AVG.Params.nTriggers+1;
            createTriggerGUI();
            CallbackTriggerCheckbox([],[],AVG.Params.nTriggers)
        else
            msgbox('Entered values are not valid triger places','Attention','error','replace');
            set(AVG.hTrigger.selectSubPopEdit,'string','')
        end
    end
    
    function CallbackTriggerCheckbox(hObj,Event,triggerNumber)
        set(AVG.hTrigger.hCheck(:),'value',0);
        set(AVG.hTrigger.hCheck(triggerNumber),'value',1);
        AVG.Params.currentTrigger=AVG.Params.triggers{triggerNumber};
        [AVG.Params.currentTriggerSorted,AVG.Params.currentTriggerSortedOrder]=sort(AVG.Params.currentTrigger);
        AVG.Params.nCurrentTriggers=numel(AVG.Params.currentTrigger);
    end
%% %%%%%%%%%%%%%%%%%%%%%%%%%% Create GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function createAVGUI(figH)
        % Construct main GUI screen
        %% Open a window and add some menus
        if nargin<1
            AVG.hMainFigure.scrsz = get(0,'ScreenSize');
            AVG.hMainFigure.hFigure = figure('Position',[AVG.hMainFigure.scrsz(3)*0.01 AVG.hMainFigure.scrsz(4)*0.07 AVG.hMainFigure.scrsz(3)*0.98 AVG.hMainFigure.scrsz(4)*0.85], ...
                'Name','Activity viewer', 'NumberTitle','off', 'MenuBar','none', 'Toolbar','none', 'HandleVisibility','off','CloseRequestFcn',@closeMainGUIFigure);
        end
        
        % define zoom options
        AVG.hMainFigure.hZoom = zoom(AVG.hMainFigure.hFigure);
        set(AVG.hMainFigure.hZoom,'Enable','on','Motion','Both','RightClickAction','PostContextMenu');
        
        % Set default panel color
        %uix.set(AVG.hMainFigure.hFigure, 'DefaultBoxPanelTitleColor',[0.7 1.0 0.7]);
        
        % set file menus
        AVG.hMenubar.hFile = uimenu(AVG.hMainFigure.hFigure, 'Label', 'File' );
        AVG.hMenubar.exportData=uimenu( AVG.hMenubar.hFile, 'Label', 'Export data', 'Callback', @CallbackExportData);
        %AVG.hMenubar.fileLoad=uimenu( AVG.hMenubar.hFile, 'Label', 'Load', 'Callback', @CallbackMenuLoad);
        %AVG.hMenubar.fileExit=uimenu( AVG.hMenubar.hFile, 'Label', 'Exit', 'Callback', @CallbackMenuExit);
        
        % set plot meuns
        AVG.hMenubar.hPlotType = uimenu(AVG.hMainFigure.hFigure, 'Label', 'Plot' );
        for i=1:length(AVG.Params.PlotList)
            AVG.hMenubar.hPlot.(AVG.Params.PlotList{i})=uimenu(AVG.hMenubar.hPlotType,...
                'Label', AVG.Params.PlotList{i}, 'Checked','off', 'Callback', @CallbackPlotTypeSelection);
        end
        set(AVG.hMenubar.hPlot.(AVG.Params.currentPlotName), 'Checked','on');
        
        % set data type meuns
        AVG.hMenubar.hDataType = uimenu(AVG.hMainFigure.hFigure, 'Label', 'Load data' );
        for i=1:length(AVG.Params.dataRecordingClasses)
            AVG.hMenubar.hRecording.(AVG.Params.dataRecordingClasses{i})=uimenu(AVG.hMenubar.hDataType,...
                'Label', AVG.Params.dataRecordingClasses{i}, 'Checked','off', 'Callback', @CallbackDataTypeSelection);
        end
        
        AVG.hMenubar.hCredits = uimenu(AVG.hMainFigure.hFigure, 'Label', 'Other' );
        AVG.hMenubar.hMainDeveloper=uimenu(AVG.hMenubar.hCredits, 'Label', 'Developed by', 'Callback', @CallbackCredits);
        
        % Arrange the main interface windows
        AVG.hMainFigure.hMainWindow = uix.HBox('Parent',AVG.hMainFigure.hFigure, 'Spacing',4);
        AVG.hMainFigure.hLeftBox = uix.VBox('Parent',AVG.hMainFigure.hMainWindow, 'Spacing',4, 'Padding',4);
        AVG.hMainFigure.hMidGrid = uix.Grid('Parent',AVG.hMainFigure.hMainWindow, 'Spacing',4, 'Padding',7);
        AVG.hMainFigure.hRightBox = uix.VBox('Parent',AVG.hMainFigure.hMainWindow, 'Spacing',4, 'Padding',4);
        set(AVG.hMainFigure.hMainWindow, 'Widths',[-2 -8 -2]);
        
        % Set left box
        AVG.hGen.General = uix.Panel('Parent',AVG.hMainFigure.hLeftBox, 'Title','General');
        AVG.hNav.MainPanel = uix.Panel('Parent',AVG.hMainFigure.hLeftBox, 'Title','Navigation');
        AVG.hCh.ChannelSelectionPanel = uix.Panel('Parent',AVG.hMainFigure.hLeftBox, 'Title','Channel selection');
        AVG.hPlotProp.hMainPanel = uix.Panel('Parent',AVG.hMainFigure.hLeftBox, 'Title','Plot specific properties');
        set(AVG.hMainFigure.hLeftBox, 'Heights',[-1 -2 -2 -3]);
        
        % Set mid box - main plot
        AVG.hMainFigure.dummyEmptyBoxes(1)=uix.Empty('Parent', AVG.hMainFigure.hMidGrid,'Visible','off');
        AVG.hMainFigure.dummyEmptyBoxes(2)=uix.Empty('Parent', AVG.hMainFigure.hMidGrid,'Visible','off');
        AVG.hMainFigure.dummyEmptyBoxes(3)=uix.Empty('Parent', AVG.hMainFigure.hMidGrid,'Visible','off');
        AVG.hMainFigure.hTimeSlider=uicontrol('Parent',AVG.hMainFigure.hMidGrid, 'Style','slider', 'Min',0, 'Max',1, 'Value',0, 'Callback',@CallbackTimeSlider);
        AVG.hMainFigure.hMainAxis=axes('Parent', AVG.hMainFigure.hMidGrid, 'ActivePositionProperty','Position', 'FontSize',8,'NextPlot','add','ColorOrderIndex',1);
        AVG.hMainFigure.dummyEmptyBoxes(4)=uix.Empty('Parent', AVG.hMainFigure.hMidGrid,'Visible','off');
        set(AVG.hMainFigure.hMidGrid,'Widths',[45 -1],'Heights', [AVG.Params.scrollBarPixels -1 35]);
        
        % Set right box
        AVG.hProcessing.hMainPanel = uix.TabPanel('Parent',AVG.hMainFigure.hRightBox, 'Padding',2, 'TabWidth',90);
        AVG.hFilter.hMainPanel=uix.Panel('Parent',AVG.hProcessing.hMainPanel, 'Padding',4);
        AVG.hAnalysis.hMainPanel=uix.Panel('Parent',AVG.hProcessing.hMainPanel, 'Padding',4);
        set(AVG.hProcessing.hMainPanel,'TabTitles',{'Filter','Analysis'}, 'Selection',2);
        
        AVG.hTrigger.hMainTriggerPanel = uix.Panel('Parent',AVG.hMainFigure.hRightBox, 'Title','Triggers');
        set(AVG.hMainFigure.hRightBox, 'Heights',[-1,-1]);
        %% construch general GUI
        AVG.hGen.mainVBox=uix.VBox('Parent', AVG.hGen.General, 'Padding', 2, 'Spacing', 5);
        AVG.hGen.messageBox=uicontrol('Parent', AVG.hGen.mainVBox, 'HorizontalAlignment','left', 'Style','text',...
            'String','Ready','ForegroundColor','k','FontSize',12,'FontWeight','Bold');
        
        AVG.hGen.generalGrid=uix.Grid('Parent', AVG.hGen.mainVBox, 'Padding', 2, 'Spacing', 5);
        AVG.hGen.refreshPlotPush=uicontrol('Parent', AVG.hGen.generalGrid, 'Callback',{@CallbackRefreshPlotPush}, 'Style','push', 'String','Refresh plot');
        AVG.hGen.restartPlotPush=uicontrol('Parent', AVG.hGen.generalGrid, 'Callback',{@CallbackRestartPlotPush}, 'Style','push', 'String','Restart plot');
        AVG.hGen.exportPlotPush=uicontrol('Parent', AVG.hGen.generalGrid, 'Callback',{@CallbackExportPlotPush}, 'Style','push', 'String','Export plot');
                
        set(AVG.hGen.generalGrid, 'Widths',-1,'Heights', -1 );
        set(AVG.hGen.mainVBox,'Heights',[-1,-3]);
        %% Construct Navigation GUI
        AVG.hNav.mainBox=uix.VBox('Parent', AVG.hNav.MainPanel, 'Padding', 5, 'Spacing', 10);
        
        AVG.hNav.timeControlBox=uix.HBox('Parent', AVG.hNav.mainBox, 'Padding', 5, 'Spacing', 10);
        AVG.hNav.hFastBackPush=uicontrol('Parent', AVG.hNav.timeControlBox, 'Callback',{@CallbackNavTimeFrameMovePush,-1}, 'Style','push', 'String','<<','FontSize',12,'FontWeight','Bold','BackgroundColor',[0.6 0.6 1]);
        AVG.hNav.hBackPush=uicontrol('Parent', AVG.hNav.timeControlBox, 'Callback',{@CallbackNavTimeFrameMovePush,-AVG.Params.shortTimeFrameMovement}, 'Style','push', 'String','<','FontSize',12,'FontWeight','Bold','BackgroundColor',[1 0.6 0.6]);
        AVG.hNav.ZoomBox=uix.VBox('Parent', AVG.hNav.timeControlBox, 'Padding', 5, 'Spacing', 10);
        AVG.hNav.hZoomInPush=uicontrol('Parent', AVG.hNav.ZoomBox, 'Callback',{@CallbackNavZoomPush,0.5}, 'Style','push','FontSize',12,'FontWeight','Bold','String','+');
        AVG.hNav.hZoomOutPush=uicontrol('Parent', AVG.hNav.ZoomBox, 'Callback',{@CallbackNavZoomPush,2}, 'Style','push','FontSize',12,'FontWeight','Bold','String','-');
        AVG.hNav.hForwardPush=uicontrol('Parent', AVG.hNav.timeControlBox, 'Callback',{@CallbackNavTimeFrameMovePush,AVG.Params.shortTimeFrameMovement}, 'Style','push', 'String','>','FontSize',12,'FontWeight','Bold','BackgroundColor',[1 0.6 0.6]);
        AVG.hNav.hFastForwardPush=uicontrol('Parent', AVG.hNav.timeControlBox, 'Callback',{@CallbackNavTimeFrameMovePush,1}, 'Style','push', 'String','>>','FontSize',12,'FontWeight','Bold','BackgroundColor',[0.6 0.6 1]);
        
        set(AVG.hNav.timeControlBox, 'Widths',[-2,-3,-4,-3,-2]);
        
        AVG.hNav.timeControlGrid=uix.Grid('Parent', AVG.hNav.mainBox, 'Padding', 5, 'Spacing', 10);
        
        AVG.hNav.TimeTxt=uicontrol('Parent', AVG.hNav.timeControlGrid, 'HorizontalAlignment','left', 'Style','text', 'String','start time [ms]');
        AVG.hNav.WindowTxt=uicontrol('Parent', AVG.hNav.timeControlGrid, 'HorizontalAlignment','left','Style','text', 'String','window [ms]');
        
        AVG.hNav.startTimeEdit=uicontrol('Parent', AVG.hNav.timeControlGrid, 'Callback',{@CallbackNavTimeEdit},'Style','edit', 'String',AVG.Params.defaultStartTime);
        AVG.hNav.WindowEdit=uicontrol('Parent', AVG.hNav.timeControlGrid, 'Callback',{@CallbackNavWindowEdit}, 'Style','edit', 'String',AVG.Params.defaultWindow);
        
        set(AVG.hNav.timeControlGrid, 'Widths',[-2 -1],'Heights', [-1 -1] );
        
        set(AVG.hNav.mainBox, 'Heights',[-3,-2]);
        %% Construct channel GUI
        AVG.hCh.mainBox=uix.VBox('Parent', AVG.hCh.ChannelSelectionPanel, 'Padding', 5, 'Spacing', 10);
        
        AVG.hCh.AddChannelsEdit=uicontrol('Parent', AVG.hCh.mainBox, 'Callback',{@CallbackChAddChannelsEdit},'Style','edit', 'String','Add channels');
        AVG.hCh.removeChannelsEdit=uicontrol('Parent', AVG.hCh.mainBox, 'Callback',{@CallbackChRemoveChannelsEdit}, 'Style','edit', 'String','Remove channels');
        AVG.hCh.keepOnlyChannelsEdit=uicontrol('Parent', AVG.hCh.mainBox, 'Callback',{@CallbackChKeepOnlyChannelsEdit}, 'Style','edit', 'String','Keep only channels');
        AVG.hCh.enableAllChannelsPush=uicontrol('Parent', AVG.hCh.mainBox, 'Callback',{@CallbackChEnableAllChannelsPush}, 'Style','push', 'String','Enable all channels');
        AVG.hCh.manualChannelSelectPush=uicontrol('Parent', AVG.hCh.mainBox, 'Callback',{@CallbackChManualChannelSelectPush}, 'Style','push', 'String','Select manually');
        
        %AVG.hCh.empty1=uix.Empty('Parent', AVG.hCh.mainBox);
        
        set(AVG.hCh.mainBox, 'Heights',[-1,-1,-1,-1,-1]);
        %% Construct filter GUI
        % set filter panel
        %fileds are arranged as a N x 2 grid of text and input
        
        AVG.hFilter.hMainVBox= uix.VBox( 'Parent', AVG.hFilter.hMainPanel, 'Spacing',4, 'Padding',4);
        AVG.hFilter.hMainGrid= uix.Grid( 'Parent', AVG.hFilter.hMainVBox, 'Spacing',10 );
        
        %text column
        AVG.hFilter.hFilterTxt=uicontrol('Parent', AVG.hFilter.hMainGrid, 'HorizontalAlignment','left', 'Style','text', 'String','Filter');
        AVG.hFilter.hDesignTxt=uicontrol('Parent', AVG.hFilter.hMainGrid, 'HorizontalAlignment','left', 'Style','text', 'String','Filter design');
        AVG.hFilter.hOrderTxt=uicontrol('Parent', AVG.hFilter.hMainGrid, 'HorizontalAlignment','left','Style','text', 'String','Filter order');
        AVG.hFilter.hSamplingFrequencyTxt=uicontrol('Parent', AVG.hFilter.hMainGrid, 'HorizontalAlignment','left','Style','text', 'String','Sampling Freq. [Hz]');
        AVG.hFilter.hLowPassStopTxt=uicontrol('Parent', AVG.hFilter.hMainGrid, 'HorizontalAlignment','left','Style','text', 'String','Lowpass stop Freq. [Hz]');
        AVG.hFilter.hLowPassPassTxt=uicontrol('Parent', AVG.hFilter.hMainGrid, 'HorizontalAlignment','left','Style','text', 'String','Lowpass pass Freq. [Hz]');
        AVG.hFilter.hAttenuationLowPassTxt=uicontrol('Parent', AVG.hFilter.hMainGrid, 'HorizontalAlignment','left','Style','text', 'String','Lowpass attenuation [dB]');
        AVG.hFilter.hHighPassPassTxt=uicontrol('Parent', AVG.hFilter.hMainGrid, 'HorizontalAlignment','left','Style','text', 'String','Highpass pass Freq. [Hz]');
        AVG.hFilter.hHighPassStopTxt=uicontrol('Parent', AVG.hFilter.hMainGrid, 'HorizontalAlignment','left','Style','text', 'String','Highpass stop Freq. [Hz]');
        AVG.hFilter.hAttenuationHighTxt=uicontrol('Parent', AVG.hFilter.hMainGrid, 'HorizontalAlignment','left','Style','text', 'String','High attenuation [dB]');
        AVG.hFilter.hRippleTxt=uicontrol('Parent', AVG.hFilter.hMainGrid, 'HorizontalAlignment','left','Style','text', 'String','Ripple (band) [dB]');
        AVG.hFilter.hSamplingRatio=uicontrol('Parent', AVG.hFilter.hMainGrid, 'HorizontalAlignment','left','Style','text', 'String','Sampling ratio');
        AVG.hFilter.hPaddingSamplesTxt=uicontrol('Parent', AVG.hFilter.hMainGrid, 'HorizontalAlignment','left','Style','text', 'String','Padding [ms]');
        
        %input column
        newPopUpMenu=[AVG.Params.filterNames];
        AVG.hFilter.hMethodPopup=uicontrol('Parent', AVG.hFilter.hMainGrid, 'Callback',{@CallbackFilterMethodPopup},'Style','popup', 'String',newPopUpMenu,'Min',1,'Max',numel(newPopUpMenu));
        AVG.hFilter.hDesignPopup=uicontrol('Parent', AVG.hFilter.hMainGrid, 'Callback',{@CallbackFilterDesignPopup},'Style','popup', 'String',AVG.Params.filterDesigns,'value',AVG.Params.defaultFilterValue);
        AVG.hFilter.hOrderEdit=uicontrol('Parent', AVG.hFilter.hMainGrid, 'Callback',{@CallbackFilterOrderEdit}, 'Style','edit', 'String',AVG.Params.defaultFilterOrder);
        AVG.hFilter.hSamplingFrequencyEdit=uicontrol('Parent', AVG.hFilter.hMainGrid, 'Callback',{@CallbackFilterSamplingFrequencyEdit}, 'Style','edit', 'String',num2str(AVG.Params.samplingFrequency(1)));
        AVG.hFilter.hLowPassStopEdit=uicontrol('Parent', AVG.hFilter.hMainGrid, 'Callback',{@CallbackFilterLowPassStopEdit}, 'Style','edit', 'String',AVG.Params.defaultFilterLowPassStopFreq);
        AVG.hFilter.hLowPassPassEdit=uicontrol('Parent', AVG.hFilter.hMainGrid, 'Callback',{@CallbackFilterLowPassPassEdit}, 'Style','edit', 'String',AVG.Params.defaultFilterLowPassPassFreq);
        AVG.hFilter.hLowpassAttenuationEdit=uicontrol('Parent', AVG.hFilter.hMainGrid, 'Callback',{@CallbackFilterLowPassAttenuationEdit}, 'Style','edit', 'String',AVG.Params.defaultAttenuationInLowpass);
        AVG.hFilter.hHighPassPassEdit=uicontrol('Parent', AVG.hFilter.hMainGrid, 'Callback',{@CallbackFilterHighPassPassEdit}, 'Style','edit', 'String',AVG.Params.defaultFilterHighPassPassFreq);
        AVG.hFilter.hHighPassStopEdit=uicontrol('Parent', AVG.hFilter.hMainGrid, 'Callback',{@CallbackFilterHighPassStopEdit}, 'Style','edit', 'String',AVG.Params.defaultFilterHighPassStopFreq);
        AVG.hFilter.hHighpassAttenuationEdit=uicontrol('Parent', AVG.hFilter.hMainGrid, 'Callback',{@CallbackFilterHighPassAttenuationEdit}, 'Style','edit', 'String',AVG.Params.defaultAttenuationInHighpass);
        AVG.hFilter.hRippleEdit=uicontrol('Parent', AVG.hFilter.hMainGrid, 'Callback',{@CallbackFilterRippleEdit}, 'Style','edit', 'String',AVG.Params.defaultRippleInPassband);
        
        AVG.hFilter.hSamplingRatioEdit=uicontrol('Parent', AVG.hFilter.hMainGrid, 'Callback',{@CallbackFilterSamplingRatioEdit}, 'Style','edit', 'String',AVG.Params.defaultFilterSamplingRatio);
        AVG.hFilter.hPaddingSamplesEdit=uicontrol('Parent', AVG.hFilter.hMainGrid, 'Callback',{@CallbackPaddingSamplesEdit}, 'Style','edit', 'String',AVG.Params.defaultPadding);
        
        %arrange columns into a grid
        set(AVG.hFilter.hMainGrid, 'Widths',[-2 -1],'Heights', 19*ones(1,13) );
        
        AVG.hFilter.hPlotFilterPush=uicontrol('Parent', AVG.hFilter.hMainVBox, 'Callback',{@CallbackPlotFilterPush}, 'Style','push', 'String','Plot filter');
        set(AVG.hFilter.hMainVBox, 'Heights',[-1 30]);
        %% Construct analysis GUI
        AVG.hAnalysis.hMainVbox= uix.VBox( 'Parent', AVG.hAnalysis.hMainPanel, 'Spacing',5 );
        AVG.hAnalysis.hMainGrid= uix.Grid( 'Parent', AVG.hAnalysis.hMainVbox, 'Spacing',10 );        
        for i=1:numel(AVG.Params.analysisMethodsNames)
            AVG.hAnalysis.hToggleButtons(i)=uicontrol('Parent',AVG.hAnalysis.hMainGrid,'Callback',{@CallbackAnaysisTogglePush,i},...
               'Style','toggle','String',[AVG.Params.analysisMethodsNames{i} ' (-)']);
        end
        set(AVG.hAnalysis.hMainGrid,'Widths',[-1 -1]);
        AVG.hAnalysis.hRemoveAll=uicontrol('Parent',AVG.hAnalysis.hMainVbox,'Callback',{@CallbackRemoveAllAnalysisPush}, 'Style','push', 'String','Remove all','BackgroundColor',[0.5 0.7 0.5]);
        set(AVG.hAnalysis.hMainVbox,'Heights',[-1 40]);
        %% Construct Trigger Box
        AVG.hTrigger.MainVBox=uix.VBox('Parent', AVG.hTrigger.hMainTriggerPanel, 'Padding', 4, 'Spacing', 4);
        
        AVG.hTrigger.navigationHBox=uix.HBox('Parent', AVG.hTrigger.MainVBox, 'Padding', 4, 'Spacing', 4);
        AVG.hTrigger.hForward=uicontrol('Parent',AVG.hTrigger.navigationHBox,'Callback',{@CallbackTriggerDirectionPush,-1}, 'Style','push', 'String','<<');
        AVG.hTrigger.hNumber=uicontrol('Parent',AVG.hTrigger.navigationHBox,'Callback',@CallbackTriggerNumberEdit, 'Style','edit', 'String','0');
        AVG.hTrigger.hBackward=uicontrol('Parent',AVG.hTrigger.navigationHBox,'Callback',{@CallbackTriggerDirectionPush,1}, 'Style','push', 'String','>>');
        set(AVG.hTrigger.navigationHBox, 'Widths',[-1 40 -1]);
        
        AVG.hTrigger.hGetTrigFromRawFiles=uicontrol('Parent', AVG.hTrigger.MainVBox, 'HorizontalAlignment','left','Style','check', 'String','load trig. data','value',false);
        
        AVG.hTrigger.OffsetHBox=uix.HBox('Parent', AVG.hTrigger.MainVBox, 'Padding', 4, 'Spacing', 4);
        AVG.hTrigger.hOffsetTxt=uicontrol('Parent', AVG.hTrigger.OffsetHBox, 'HorizontalAlignment','left','Style','text', 'String','Offset [ms]');
        AVG.hTrigger.hOffsetEdit=uicontrol('Parent', AVG.hTrigger.OffsetHBox, 'Style','edit', 'String',0,'Callback',@CallbackTrigOffset);
        set(AVG.hTrigger.OffsetHBox, 'Widths',[-1 -2]);
        
        AVG.hTrigger.selectSubPopulationHBox=uix.HBox('Parent', AVG.hTrigger.MainVBox, 'Padding', 4, 'Spacing', 4);
        AVG.hTrigger.selectSubPopPush=uicontrol('Parent', AVG.hTrigger.selectSubPopulationHBox,'String','Add sub. pop.','Callback',@CallbackAddTrigSubPopPush,'HorizontalAlignment','left','Style','push');
        AVG.hTrigger.selectSubPopEdit=uicontrol('Parent', AVG.hTrigger.selectSubPopulationHBox,'Style','edit', 'String','');
        set(AVG.hTrigger.selectSubPopulationHBox, 'Widths',[-1 -2]);
        
        AVG.hTrigger.manualSetHBox=uix.HBox('Parent', AVG.hTrigger.MainVBox, 'Padding', 4, 'Spacing', 4);
        AVG.hTrigger.manualSetPush=uicontrol('Parent', AVG.hTrigger.manualSetHBox, 'Style','push', 'String','Add manually','Callback',@CallbackManualSetPush);
        AVG.hTrigger.manualSetEdit=uicontrol('Parent', AVG.hTrigger.manualSetHBox, 'Style','edit', 'String','');
        set(AVG.hTrigger.manualSetHBox, 'Widths',[-1 -2]);
        
        AVG.hTrigger.manualLoadHBox=uix.HBox('Parent', AVG.hTrigger.MainVBox, 'Padding', 4, 'Spacing', 4);
        AVG.hTrigger.manualLoadTxtTxt=uicontrol('Parent', AVG.hTrigger.manualLoadHBox, 'HorizontalAlignment','left','Style','text', 'String','Load trigger: ');
        AVG.hTrigger.manualLoadFile=uicontrol('Parent', AVG.hTrigger.manualLoadHBox,'Style','push','String','Mat. file','Callback',@CallbackManualLoadFile);
        AVG.hTrigger.manualLoadVariable=uicontrol('Parent', AVG.hTrigger.manualLoadHBox,'Style','push','String','Mat. var','Callback',@CallbackManualLoadVariable);
 
        AVG.hTrigger.exportTriggerHBox=uix.HBox('Parent', AVG.hTrigger.MainVBox, 'Padding', 4, 'Spacing', 4);
        AVG.hTrigger.exportSelectedTrigger=uicontrol('Parent', AVG.hTrigger.exportTriggerHBox, 'Style','push', 'String','Export selected trigger','Callback',@CallbackExportSelectedTrigger);
        AVG.hTrigger.sendTriggerToStartTimePush=uicontrol('Parent', AVG.hTrigger.exportTriggerHBox, 'Style','push', 'String','send to start times','Callback',@CallbackSendTriggerToStartTime,'ForegroundColor','r');
        
        AVG.hTrigger.manualLoadFile=uicontrol('Parent',AVG.hTrigger.MainVBox,'Style','push','String','delete trigger','Callback',@CallbackDeleteTrigger);
        
        %delete this handle for terminating the trigger GUI and replacing it with a new one
        AVG.hTrigger.MainGrid=uix.Grid('Parent',AVG.hTrigger.MainVBox, 'Spacing',4, 'Padding',4);
        
        set(AVG.hTrigger.MainVBox, 'Heights',[50 25 25 25 25 25 50 25 -1]);
    end %createGUI
%% %%%%%%%%%%%%%%%%%%%%%%%%%% Create Trigger GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function createTriggerGUI() %the function sets the first trigger to be default
        if isfield(AVG.hTrigger,'MainGrid') %delete trigger graphical objects
            delete(AVG.hTrigger.MainGrid);
            AVG.hTrigger.MainGrid=uix.Grid('Parent',AVG.hTrigger.MainVBox, 'Spacing',4, 'Padding',4);
        end
        AVG.hTrigger.hCheck=[];
        %plot graphical checkboxes for active trigger
        for i=1:AVG.Params.nTriggers
            AVG.hTrigger.hCheck(i)=uicontrol('Parent',AVG.hTrigger.MainGrid,'Style','checkbox',...
                'String',[num2str(i) ' - N=' num2str(numel(AVG.Params.triggers{i}))],...
                'value',i==1,'Callback',{@CallbackTriggerCheckbox,i});
        end
        if AVG.Params.nTriggers>0
            set(AVG.hTrigger.MainGrid, 'Widths', -1*ones(1,min(3,ceil(AVG.Params.nTriggers/AVG.Params.maxNumberOfTriggerInColumn))), 'Heights', 20*ones(1,min(AVG.Params.maxNumberOfTriggerInColumn,AVG.Params.nTriggers)));
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end %EOF

%% Remarks
%*Filter object does not deal with NaNs. If they appear in the signal the singal becomes all NaN. This causes problems with filtering at the beginning
%   and ending of the session. Zeros can be inserted instead of NaNs in the object that gets the data, but this will result in twisted traces due to the
%   strong transition on onset.