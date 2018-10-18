% [hCbar]=IntensityPhysicalSpacePlot(Channels,Intensity,En)
% Function purpose : Plots an intensity channel map on real space
%
% Function recives :    Channels - the channels vector
%                       Intensity - intensity vector
%                       En - Electrode setup matrix
%                       varargin - 'property',value
%                           h - axis handle
%                           markerSize
%                           txtHorizontalAlignment
%                           fontSize
%                           plotGridLines
%                           plotElectrodeNumbers
%                           plotColorBar
%                           Ilim
%
% Function give back :  Intensity plot on real space
%
% Last updated : 11/7/09
function [hCbar,h]=IntensityPhysicalSpacePlot(Channels,Intensity,En,varargin)
hCbar=[];
markerSize=50;
txtHorizontalAlignment='center';
fontSize=12;
plotGridLines=1;
plotElectrodeNumbers=1;
plotColorBar=1;
Ilim=0;
cMap=[];

%print out default arguments and values if no inputs are given
if nargin==0
    defaultArguments=who;
    for i=1:numel(defaultArguments)
        eval(['defaultArgumentValue=' defaultArguments{i} ';']);
        disp([defaultArguments{i} ' = ' num2str(defaultArgumentValue)]);
    end
    return;
end

%Collects all options
for i=1:2:length(varargin)
    eval([varargin{i} '=' 'varargin{i+1};'])
end

if ~exist('h','var')
    h=axes;
else
    axes(h);
end
if Ilim==0
    Act_norm=(Intensity-min(Intensity))./max(Intensity-min(Intensity));
else
    Intensity(Intensity<Ilim(1))=Ilim(1);
    Intensity(Intensity>Ilim(2))=Ilim(2);
    Act_norm=(Intensity-Ilim(1))./(Ilim(2)-Ilim(1));
end

%creating translation between electrodes and locations
translation=[];
En2=fliplr(En);
Elecs=sort(En(:));
Elecs=Elecs(~isnan(Elecs));
for i=1:length(Elecs)
    [n,m]=find(En==Elecs(i));
    translation=[translation;m n Elecs(i)];
end
[max_grid_y,max_grid_x]=size(En);
if plotGridLines
    for i=1:(max_grid_y-1)
        line([0 max_grid_x+1],[i i],'LineWidth',2,'Color',[.8 .8 .8]);
    end
    for i=1:(max_grid_x-1)
        line([i i],[0 max_grid_y+1],'LineWidth',2,'Color',[.8 .8 .8]);
    end
end
xlim([0 max_grid_x]);ylim([0 max_grid_y]);
set(gca,'Box','on');
set(gca,'xtick',[]);
set(gca,'ytick',[]);
set(gca,'XColor',[.8 .8 .8]);
set(gca,'YColor',[.8 .8 .8]);

%check for colormap
if isempty(cMap)
    cMap=colormap;
end

if plotColorBar
    hCbar=colorbar;set(hCbar,'ytick',[0 1]);set(hCbar,'yticklabel',num2str([min(Intensity) round(100*max(Intensity))/100]',3));
    colormap(hCbar,cMap);
end
hold on;

% Plotting Activity points
for i=1:length(Channels)
    x=0.5+translation(find(translation(:,3)==Channels(i)),1)-1;
    y=0.5+translation(find(translation(:,3)==Channels(i)),2)-1;
    if ~isnan(Act_norm(i))
        plot(x,y,'.','color',cMap(ceil(1+Act_norm(i)*63),:),'markersize',markerSize);
    end
end

%Plotting numbers on top of the propagation points
if plotElectrodeNumbers
    for i=1:length(Elecs)
        if Elecs(i)<10
            text(translation(i,1)-0.5,translation(i,2)-0.5,num2str(Elecs(i)),'fontsize',fontSize,'HorizontalAlignment',txtHorizontalAlignment);
        else
            text(translation(i,1)-0.5,translation(i,2)-0.5,num2str(Elecs(i)),'fontsize',fontSize,'HorizontalAlignment',txtHorizontalAlignment);
        end
    end
end

hold off;