function [obj]=plotSuperimposedActivityTrace(obj)
if obj.refreshPlot
    obj.refreshPlot=0;
    minVal=min(obj.M(:));
    maxVal=max(obj.M(:));
    range=maxVal-minVal;
    ylim(obj.hPlotAxis,[minVal-0.01*range maxVal+0.01*range]);
end
obj.hPlot=plot(obj.hPlotAxis,obj.T,squeeze(obj.M)');
xlim(obj.hPlotAxis,[obj.T(1) obj.T(end)]);
xlabel(obj.hPlotAxis,'Time');
ylabel(obj.hPlotAxis,'Voltage');
