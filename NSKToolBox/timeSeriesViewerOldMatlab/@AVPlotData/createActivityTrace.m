function [obj]=createActivityTrace(obj,hControlPanel,hPlotAxis)

obj.refreshPlot=1;

%define default values
obj.plotParams.verticalShift=NaN;
obj.plotParams.plotChannelNumbers=1;

obj.hPlotControls.plotPropGrid=uiextras.Grid('Parent', obj.hControlPanel, 'Padding', 5, 'Spacing', 10);

obj.hPlotControls.isOverlap=uicontrol('Parent', obj.hPlotControls.plotPropGrid,...
    'Callback',@CallbackNoOverlapPush,'Style','push', 'String','no overlap','string','remove overlap');
obj.hPlotControls.autoScaleYStd=uicontrol('Parent', obj.hPlotControls.plotPropGrid,...
    'Callback',@CallbackAutoScaleStdYPush, 'Style','push', 'String','Auto scale Y (std)');
obj.hPlotControls.verticalShiftEdit=uicontrol('Parent', obj.hPlotControls.plotPropGrid,...
    'Callback',@CallbackVerticalShiftEdit,'Style','edit', 'String','vertical shift');
obj.hPlotControls.plotChannelNumbersCheckbox=uicontrol('Parent', obj.hPlotControls.plotPropGrid,...
    'Callback',@CallbackPlotChannelNumbersCheckbox, 'Style','checkbox','value',obj.plotParams.plotChannelNumbers,'String','plot channel numbers');
set(obj.hPlotControls.plotPropGrid, 'ColumnSizes',-1,'RowSizes', [30 30 30 30 30] );

%callback functions for plot controls
    function CallbackNoOverlapPush(hObj,event)
        if obj.nCh>1 || obj.nTrials>1
            M=squeeze(obj.M);
        else
            M=squeeze(obj.M)';
        end
        minM=nanmin(M,[],2);
        maxM=nanmax(M,[],2);
        obj.plotParams.shifts=flipud(cumsum([0;maxM(end:-1:2)-minM(end-1:-1:1)]));
        set(obj.hPlotControls.verticalShiftEdit,'string','no overlap');
        ylim(obj.hPlotAxis,[obj.plotParams.shifts(end)+minM(end) obj.plotParams.shifts(1)+maxM(1)]);
        obj.replot;
    end
    function CallbackVerticalShiftEdit(hObj,event)
        M=squeeze(obj.M);
        verticalShift=max(str2num(get(hObj,'string')),eps);
        obj.plotParams.shifts=((size(M,1)-1):-1:0)'*verticalShift;
        ylim(obj.hPlotAxis,[obj.plotParams.shifts(end)-1*verticalShift obj.plotParams.shifts(1)+1*verticalShift]);
        obj.replot;
    end
    function CallbackAutoScaleStdYPush(hObj,event)
        M=squeeze(obj.M);
        verticalShift=nanstd(M(:))*1;
        obj.plotParams.shifts=((size(M,1)-1):-1:0)'*verticalShift;
        set(obj.hPlotControls.verticalShiftEdit,'string',num2str(verticalShift));
        ylim(obj.hPlotAxis,[obj.plotParams.shifts(end)-2*verticalShift obj.plotParams.shifts(1)+2*verticalShift]);
        obj.replot;
    end
    function CallbackPlotChannelNumbersCheckbox(hObj,event)
        obj.plotParams.plotChannelNumbers=get(obj.hPlotControls.plotChannelNumbersCheckbox,'value');
        obj.replot;
    end
end %EOF