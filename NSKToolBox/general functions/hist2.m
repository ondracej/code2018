function [D,h,cb]=hist2(X1,X2,varargin)
% [D,h,cb]=hist2(X1,X2,varargin)
% Function purpose : Calculates and plots a 2D histogram
%
% Function recives :    X1 - first axis coordinates
%                       X2 - second axis coordinates
%                       varargin - arguments in format: 'property',value,...
%                           logColorScale - [default=true] whether to use a logarithmic color scale
%                           h - axis handle for plotting
%                           n1 - [1x1] - number of bins for coordinate 1
%                           n2 - [1x1] - number of bins for coordinate 2
%                           dX1 - [1x1] - interval for coordinate 1
%                           dX2 - [1x1] - interval for coordinate 2
%                           c1 - [1,M] - bin centers for coordinate 1
%                           c2 - [1,M] - bin centers for coordinate 2
%
% Function give back :  D - the count histogram
%                       h - a handle to the density plot (if not entered only calculates and doesnt plot)
%
% Last updated : 27/06/12

%set default variables
n1=50;
n2=50;
dX1=[];
dX2=[];
c1=[];
c2=[];
h=[];
plotResults=1;
logColorScale=1;
plotColorBar=1;

%Collects all arguments
for i=1:2:length(varargin)
    eval([varargin{i} '=' 'varargin{i+1};'])
end

minX1=min(X1(:));
minX2=min(X2(:));
maxX1=max(X1(:));
maxX2=max(X2(:));

if isempty(c1) %coordinate 1
    if isempty(dX1) %divide hist to n bins
        if minX1~=maxX1
            c1=linspace(minX1,maxX1,n1);
        else
            c1=linspace(minX1-1,maxX1+1,n1);
            disp('There is only one value on the X dimension, cant plot a 2D hist');
        end
    else %divide hist to sections of length dX
        c1=minX1:dX1:(maxX1+dX1);
        c1=c1+dX1/2;
    end
end
if isempty(c2) %coordinate 1
    if isempty(dX2) %divide hist to n bins
        if minX2~=maxX2
            c2=linspace(minX2,maxX2,n2);
        else
            c2=linspace(minX2-1,maxX2+1,n2);
            disp('There is only one value on the Y dimension, cant plot a 2D hist');
        end
    else %divide hist to sections of length dX
        c2=minX2:dX2:(maxX2+dX2);
        c2=c2+dX2/2;
    end
end

nBin1=numel(c1);
nBin2=numel(c2);

%interpolate to grid
x1r=interp1(c1,1:numel(c1),X1(:),'nearest');
x2r=interp1(c2,1:numel(c2),X2(:),'nearest');

D=accumarray([x1r x2r],1,[nBin1 nBin2])';

if plotResults %plot results
    if isempty(h)
        h=axes;
    else
        axes(h);
    end
    colormap(flipud(gray(256)));
    if logColorScale
        imagesc(c1,c2,log10(1+D));
    else
        imagesc(c1,c2,D);
    end
    if plotColorBar
        cb=colorbar('location','EastOutside');
        if logColorScale
            ylabel(cb,'log_{10}(1+#)');
        else
            ylabel(cb,'#');
        end
    else
        cb=[];
    end
    set(h,'YDir','normal');
end