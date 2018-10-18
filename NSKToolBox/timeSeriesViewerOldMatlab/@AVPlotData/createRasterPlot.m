function [obj]=createRasterPlot(obj)
%define default values
obj.refreshPlot=1;
obj.plotParams.normManual=0;
obj.plotParams.normChannel=0;
obj.plotParams.maxValue=1;
obj.plotParams.constantBinNumber=1;
obj.plotParams.binNumber=500;
obj.plotParams.timeBin=obj.recordingObjReference.timeBin;
obj.plotParams.plotChannelNumbers=1;

obj.plotParams.colormap=load('colormapMyHot');
obj.plotParams.colormap=obj.plotParams.colormap.MyHotColorMap;

colormap(obj.hPlotAxis,obj.plotParams.colormap);

%create the GUI plot controls
obj.hPlotControls.plotPropGrid=uiextras.Grid('Parent', obj.hControlPanel, 'Padding', 5, 'Spacing', 10);

obj.hPlotControls.normManual=uicontrol('Parent', obj.hPlotControls.plotPropGrid,...
    'Callback',@CallbackNormManualCheck,'value',obj.plotParams.normManual,'Style','check', 'String','Norm. to value');
obj.hPlotControls.maxValue=uicontrol('Parent', obj.hPlotControls.plotPropGrid,...
    'Callback',@CallbackMaxValueEdit,'Style','edit', 'String',num2str(obj.plotParams.maxValue));
obj.hPlotControls.timeBinTxt=uicontrol('Parent', obj.hPlotControls.plotPropGrid,...
    'Style','text', 'String','Time bin [ms]','HorizontalAlignment','left');
obj.hPlotControls.timeBin=uicontrol('Parent', obj.hPlotControls.plotPropGrid,...
    'Callback',@CallbackTimeBinEdit,'Style','edit', 'String',num2str(obj.plotParams.timeBin));
obj.hPlotControls.normChannels=uicontrol('Parent', obj.hPlotControls.plotPropGrid,...
    'Callback',@CallbackNormChannelsCheck,'Style','check','value',obj.plotParams.normChannel,'String','norm. channels');
obj.hPlotControls.constantBinNumberCheck=uicontrol('Parent', obj.hPlotControls.plotPropGrid,...
    'Callback',@CallbackConstantBinNumberCheck,'Style','check','value',obj.plotParams.constantBinNumber,'String','const. bin num.');
obj.hPlotControls.plotChannelNumbersCheckbox=uicontrol('Parent', obj.hPlotControls.plotPropGrid,...
    'Callback',@CallbackPlotChannelNumbersCheckbox, 'Style','checkbox','value',obj.plotParams.plotChannelNumbers,'String','plot channel numbers');

set(obj.hPlotControls.plotPropGrid, 'ColumnSizes',-1,'RowSizes', [25 25 25 25 25 25 25] );
        
obj.hPlotBackground.hGrid=[];

%callback functions for plot controls
    function CallbackPlotChannelNumbersCheckbox(hObj,event)
        obj.plotParams.plotChannelNumbers=get(obj.hPlotControls.plotChannelNumbersCheckbox,'value');
        obj.replot;
    end
    function CallbackNormManualCheck(hObj,event)
        obj.plotParams.normManual=get(hObj,'value');
    end
    function CallbackMaxValueEdit(hObj,event)
        obj.plotParams.maxValue=str2num(get(hObj,'string'));
    end
    function CallbackTimeBinEdit(hObj,event)
        obj.plotParams.timeBin=str2num(get(hObj,'string'));
        obj.recordingObjReference.timeBin=obj.plotParams.timeBin;
    end
    function CallbackNormChannelsCheck(hObj,event)
        obj.plotParams.normChannel=get(hObj,'value');
    end
    function CallbackConstantBinNumberCheck(hObj,event)
        obj.plotParams.constantBinNumber=get(hObj,'value');
    end 
end %EOF