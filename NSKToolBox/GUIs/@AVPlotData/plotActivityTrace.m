function [obj]=plotActivityTrace(obj)
%selection of input data
hText=[];
if obj.nCh==1 && obj.nTrials>1
    M=squeeze(obj.M);
    %this option fails only when the two dimensions of M are equal - check
elseif obj.nTrials==1 && obj.nCh>1
    M=squeeze(obj.M);
elseif obj.nCh==1 && obj.nTrials==1
    M=squeeze(obj.M)';
elseif obj.nCh>1 && obj.nTrials>1
    obj.hPlot=[];hText=[];
    msgbox('activity trace plot only support either multiple trials or channels (not both)','Attention','error','replace');
    return;
end

if obj.refreshPlot %for first appearance when shifts were not chosen
    verticalShift=max(nanstd(obj.M(:))*5,eps);
    obj.plotParams.shifts=((size(M,1)-1):-1:0)'*verticalShift;
    set(obj.hPlotControls.verticalShiftEdit,'string',num2str(verticalShift));
    ylim(obj.hPlotAxis,[obj.plotParams.shifts(end)-1*verticalShift obj.plotParams.shifts(1)+1*verticalShift+eps]);
    obj.refreshPlot=0;
end

M=bsxfun(@plus,M,obj.plotParams.shifts);
obj.hPlot=plot(obj.hPlotAxis,obj.T,M);obj.hPlotAxis.ColorOrderIndex=1;

if obj.nTrials==1 & obj.plotParams.plotChannelNumbers
    hText=text(obj.T(end)*0.99*ones(1,obj.nCh),M(:,end),num2cell(obj.channelNumbers),...
        'Parent',obj.hPlotAxis,'FontSize',6,'FontWeight','Bold','BackgroundColor','w');
elseif obj.nCh==1 & obj.plotParams.plotChannelNumbers
    hText=text(obj.T(end)*0.99*ones(1,obj.nTrials),M(:,end),num2cell(1:obj.nTrials),...
        'Parent',obj.hPlotAxis,'FontSize',6,'FontWeight','Bold','BackgroundColor','w');
end

xlim(obj.hPlotAxis,[obj.T(1) obj.T(end)]);
xlabel(obj.hPlotAxis,'Time');
ylabel(obj.hPlotAxis,'Voltage (shifted by a constant)');
[hScaleBar]=addScaleBar(obj.hPlotAxis);
obj.hPlot=[obj.hPlot;hText;hScaleBar];