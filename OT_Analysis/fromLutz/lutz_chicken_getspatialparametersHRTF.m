function s = lutz_chicken_getspatialparametersHRTF()

dbstop if error

%load('D:\Janie\AudioSpike_v_10202017\#H3_HRIR_HRTF.mat') % Loads HRIR, HRTF, allele, allaz
%load('D:\OneDrive\Dokumente\Dokumente Arbeit\Manuscripte\chicken MLD spatial tuning\Data HRTF\#H3_HRIR_HRTF.mat') %#ok<*LOAD> % Loads HRIR, HRTF, allele, allaz
load('/media/dlc/Data8TB/TUM/OT/OTProject/#H3_HRIR_HRTF.mat')
%%%%% #H3_HRIR_HRTF.mat low pass filtered with cutoff at 5621 Hz);

disp('')

% set general variables
sf = 44100;  % sample frequency
nf = sf / 2; % nyquist frequency

degStep = 5.625;
elevRange = -73.125:degStep:73.125;
azRange = -180:degStep:180;

[locsX, locsY] = meshgrid(azRange, elevRange);

Zitd = nan(size(locsX)); Zitd_low = nan(size(locsX));  Zitd_high = nan(size(locsX));
Zild = nan(size(locsX)); Zild_low  = nan(size(locsX)); Zild_high = nan(size(locsX));

for ii = 1:numel(locsY)
    
    [ix, iy] = find(locsX == locsX(ii) & locsY == locsY(ii));
    
    if exist('HRTF','var') == 1
        hrtf= [squeeze(HRTF(ix,iy,:,1)) squeeze(HRTF(ix,iy,:,2))]; %#ok<USENS>
    else
        hrtf =  [fft(squeeze(mHRIR(ix,iy,:,1))) fft(squeeze(mHRIR(ix,iy,:,2)))];  %#ok<USENS> %%%% ChickenHRIR, RookHRIR, DuckHRIR
    end
    
    %     hrir = [squeeze(HRIR(ix,iy,:,1)) squeeze(HRIR(ix,iy,:,2))];             %#ok<*USENS>
    
    %%% ITD by (average)  phase delay
    xds= linspace(0,nf, size(hrtf,1)/2)';
    icutoff_bb =  (xds<= 4500 & xds > 200);
    icutoff_low = (xds<= 2500 & xds > 200);
    icutoff_high = (xds<= 4500 & xds > 2500);
    
    phi  = unwrap(angle(hrtf));
    Dp    = (phi(:,2) - phi(:,1))./(2.*pi);  %phase delay
    Dt     = 1e6.*Dp(1:end/2)./xds; %time delay
    
    itd     =   nanmean(Dt(icutoff_bb));    %average time delay;        
    itd_low     =   nanmean(Dt(icutoff_low)); %%%  for different frequency ranges.
    itd_high     =   nanmean(Dt(icutoff_high));
    
    Zitd(ii) = itd;
    Zitd_low(ii) = itd_low;
    Zitd_high(ii) = itd_high;
    
    %%% ITD by xcorr. Have to check does not work yet (also is restricted
    %%% by samping rate)
    %        [r,lags] = xcorr(hrir(1,:), hrir(2,:)); ITD = 1.e6.*lags(r == max(r))./sf;
    
    
    %%%  ILD and monaural gain ------------------------------
    %     mag = abs(hrtf);   
    %     gain = 20.*log10(mag); %monaural gain    
    
    ildSpec = 20*log10(abs((hrtf(:,2))./(hrtf(:,1))));
    ild   = nanmean(ildSpec(icutoff_bb));
    ild_low = nanmean(ildSpec(icutoff_low));
    ild_high = nanmean(ildSpec(icutoff_high));
    
   Zild(ii) = ild;
    Zild_low(ii) =ild_low;
    Zild_high(ii) =ild_high;
    
    
    %%%% Ignore
    %%%% I was looking at a couple of other parameters that might be mapped
    %%%% in space
    
    %%% ILDvariance-----------------------------------------------------------------
    %     ild   = nanstd(ildSpec(icutoff_bb));
    %     ild_low = nanstd(ildSpec(icutoff_low));
    %     ild_high = nanstd(ildSpec(icutoff_high));
    
    %%% frequency with max ILD-------------------------------------------------
    % icutoff_cntr =  (xds<= 4000 & xds > 1000);
    % [~, idx]   = max(smooth(abs(ildSpec(icutoff_cntr)),7));
    % xf = xds(icutoff_cntr);
    %     ild = xf(idx);
    
    %%% notch  depth  --------------------------------------------------------------
    % dmag = abs(diff(smooth(mag(icutoff_cntr),7)));
    %     [~, idx]   = max(dmag) ;
    %     xf = xds(icutoff_cntr);
    %     ild = xf(idx);
    
    
    %%% coherence between left and right   HRIR -----------------------------------
    % % [cxy,f] = mscohere(squeeze(HRIR(ix,iy,:,1)),squeeze(HRIR(ix,iy,:,2)),256,56,[],sf); %#ok<USENS>
    % % %  plot(f, cxy); ylim([0 1]);pause(.2);
    % %
    % %      icutoff_bb =  (f<= 4500 & f > 200);
    % %     icutoff_low = (f<= 2500 & f > 200);
    % %     icutoff_high = (f<= 4500 & f > 2500);
    % %
    % % coh  = min(cxy(icutoff_bb));
    % % coh_high = min(cxy(icutoff_high));
    % % coh_low = min(cxy(icutoff_low));
    
    %%% mutual information (uses functions hist2, myhist, minf, mi)---------------------------------
    % I=mi(squeeze(HRIR(ix,iy,:,1)),squeeze(HRIR(ix,iy,:,2))) ; %#ok<*USENS>
    

    %%% plot for debugging
    %          plot(xds(icutoff_bb),smooth(abs(ildSpec(icutoff_bb,1)),10)); pause(.5)
    %          disp([locsX(ii) locsY(ii) itd ild]);
    
    
end

[~, s] = findpairs(locsX,locsY,Zitd, Zild);  %%% first output to plot preliminary 'ambiguity' map. supposed to show areas that are more or less ambiguous

figure   %%%%%%% hammer projection (hammerplot) or flat surface plot (surfplot)
itdlims = [-200 200];

subplot 321
hammerplot(locsX,locsY,Zitd, itdlims)
title('itd broadband')
subplot 323
hammerplot(locsX,locsY,Zitd_low, itdlims)
title('itd 200 - 2500 Hz')
subplot 325
hammerplot(locsX,locsY,Zitd_high, itdlims)
title('itd 2500 - 4500 Hz')


ildlims = [-10 10];
subplot 322
hammerplot(locsX,locsY,Zild, ildlims)
title('ild broadband')
subplot 324
hammerplot(locsX,locsY,Zild_low, ildlims)
title('ild 200 - 2500 Hz')
subplot 326
hammerplot(locsX,locsY,Zild_high, ildlims)
title('ild 2500 - 4500 Hz')

saveDir = ['/media/dlc/Data8TB/TUM/OT/OTProject/MLD/AmbPairs/PairsToTest.mat'];

save(saveDir, 's', '-v7.3')


end

function surfplot(X,Y,Z,colorlims) %#ok<DEFNU>

% K = (1/25)*ones(5);
% Z = conv2(Z,K,'same');

[~, ~] = contour(X, Y, Z,linspace(colorlims(1), colorlims(2), 21),'ShowText','on', 'LineWidth',1);

% s.EdgeColor = 'none';
% s.FaceColor = 'interp';
caxis(colorlims)
view(0,90)
xlabel('Azimuth (�)')
ylabel('Elevation (�)')

a = colorbar;
if max(colorlims) == 200
    a.Label.String = 'ITD (microseconds)';
else
    a.Label.String = 'ILD (dB)';
end
colormap jet

end

function hammerplot(Xax,Yax,Zdata, colorlims) %#ok<INUSL>

%%% kernel filter to smooth plot. Does not alter data variables
K = (1/25)*ones(5);
Zdata = conv2(Zdata,K,'same');

[tx ty]=hammer(-180:5.625:180,-73.125:5.625:73.125); %#ok<NCOMMA> %%
tx=rad2deg(tx);ty=rad2deg(ty);
plotslice360(Zdata,tx,ty,colorlims,'-',[]);
h = (colorbar);
set(h,'Fontsize', 12);
ylabel('Elevation [�]', 'Fontsize', 12);
xlabel('Azimuth [�]', 'Fontsize', 12);
Xtickall=[];



for    Longitude=-180:30:180
    Latitude=0;
    Lat= deg2rad(Latitude);
    Long= deg2rad(Longitude);
    R=1;
    X = 2.*R.*sqrt(2).*cos(Lat).*sin(Long./2)./sqrt(1+cos(Lat).*cos(Long./2));
    Y = R.*sqrt(2).*sin(Lat)./sqrt(1+cos(Lat).*cos(Long./2));
    X = rad2deg(X);
    Y = rad2deg(Y);
    text(X-15, Y, [num2str(Longitude),'']);
    % end
end
set(gca,'Xtick',(Xtickall)','xtickLabel',(-180:60:180),'Fontsize',7)
Ytickall=[];
for Latitude=-60:30:60
    Longitude=-0;
    Lat= deg2rad(Latitude);
    Long= deg2rad(Longitude);
    R=1;
    X = 2.*R.*sqrt(2).*cos(Lat).*sin(Long./2)./sqrt(1+cos(Lat).*cos(Long./2));
    Y = R.*sqrt(2).*sin(Lat)./sqrt(1+cos(Lat).*cos(Long./2));
    X = rad2deg(X);
    Y = rad2deg(Y);
    text(X-15, Y, [num2str(Latitude),'']);
    % end
end
colormap parula
set(gca,'Ytick',(Ytickall)','YtickLabel',(-60:30:60),'Fontsize',12)

axis tight;

xlabel('Azimuth (�)')
ylabel('Elevation (�)')

a = colorbar;
if max(colorlims) == 200
    a.Label.String = 'ITD (microseconds)';
else
    a.Label.String = 'ILD (dB)';
end
end

function [ambmap, s] = findpairs(locsX,locsY,Zitd, Zild)
%%% find equal pairs

ambmap = zeros(size(Zild));
Nelepair = 1; Nazipair = 1; Nmixpair = 1; Nneighpair = 1;

for ii = 1:numel(locsY)
    
    %     Schillberg et al 2020
    %     For positions to be termed ambiguous
    % the combination of broadband ITD and broadband ILD was
    % required to be within � 10 ?s and � 1 dB. Since ITD and
    % ILDs are conditionally independent (Fischer and Pena 2017),
    % an influence of the ITD on the resolution of ILD or vice
    % versa is not expected.
    
    % may 1 and 0.25 for chicken, they have smaller heads
    
    ildTemp = Zild(ii);
    itdTemp = Zitd(ii);
    
    %%%% uncomment if only interested in ITD or ILD instead of both
    %%%% parameteres
% %     itdpairs =  ((Zitd >=  itdTemp-1 & Zitd <= itdTemp+1));
% %     ambig_coordinate = [locsX(itdpairs) locsY(itdpairs)];
% %     
% %     ildpairs = ((Zild >=  ildTemp-.025 & Zild <= ildTemp+.025));
% %     ambig_coordinate = [locsX(ildpairs) locsY(ildpairs)];
        
    ambpairs = ((Zitd >=  itdTemp-1 & Zitd <= itdTemp+1) & (Zild >=  ildTemp-.025 & Zild <= ildTemp+0.025));
    %ambpairs = ((Zitd >=  itdTemp-5 & Zitd <= itdTemp+5) & (Zild >=  ildTemp-.5 & Zild <= ildTemp+0.5)); % .5 dB and 5 uS
    ambig_coordinates = [locsX(ambpairs) locsY(ambpairs)];
    
    
    if size(ambig_coordinates,1)>1        
        %%% elevation pair
        if abs(max(diff(ambig_coordinates(:,2)))) > 15 && abs(max(diff(ambig_coordinates(:,1)))) <15
            elepair(Nelepair) = {ambig_coordinates};
            Nelepair  = Nelepair + 1;ambpairs = ((Zitd >=  itdTemp-1 & Zitd <= itdTemp+1) & (Zild >=  ildTemp-.025 & Zild <= ildTemp+0.025));
            
            %%% azimuth pair
        elseif abs(max(diff(ambig_coordinates(:,1)))) > 15 && abs(max(diff(ambig_coordinates(:,2)))) < 15  
            azipair(Nazipair) = {ambig_coordinates};
            Nazipair = Nazipair +1;
            %%% neighboor
        elseif abs(max(diff(ambig_coordinates(:,1)))) < 15 && abs(max(diff(ambig_coordinates(:,2)))) < 15       
            neighpair(Nneighpair) = {ambig_coordinates};
            Nneighpair = Nneighpair +1;
            %%% mix pair
        else  
             mixpair(Nmixpair) = {ambig_coordinates}; %#ok<*AGROW>
             Nmixpair = Nmixpair +1;
        end
        ambmap = ambmap + ambpairs;
    end
    %%% ambiguity map
    %     ambmap = ambmap + ambpairs;
    
    
    
end
s.azimuthpairs = azipair;
s.elevationpairs = elepair;
s.neighbors = neighpair; 
s.mixpairs = mixpair; 
end
%%% spectral maps

function I=mi(A,B,varargin) %#ok<DEFNU>
%MI Determines the mutual information of two images or signals
%
%   I=mi(A,B)   Mutual information of A and B, using 256 bins for
%   histograms
%   I=mi(A,B,L) Mutual information of A and B, using L bins for histograms
%
%   Assumption: 0*log(0)=0
%
%   See also ENTROPY.
%   jfd, 15-11-2006
%        01-09-2009, added case of non-double images
%        24-08-2011, speed improvements by Andrew Hill
if nargin>=3
    L=varargin{1};
else
    L=32;
end
A=double(A);
B=double(B);

na = myhist(A(:),L);
na = na/sum(na);
nb = myhist(B(:),L);
nb = nb/sum(nb);
n2 = hist2(A,B,L);
n2 = n2/sum(n2(:));
I=sum(minf(n2,na'*nb));ambpairs = ((Zitd >=  itdTemp-1 & Zitd <= itdTemp+1) & (Zild >=  ildTemp-.025 & Zild <= ildTemp+0.025));

end
% -----------------------
function y=minf(pab,papb)
I=find(papb(:)>1e-12 & pab(:)>1e-12); % function support
y=pab(I).*log2(pab(I)./papb(I));

end

function n=hist2(A,B,L)
%HIST2 Calculates the joint histogram of two images or signals
%
%   n=hist2(A,B,L) is the joint histogram of matrices A and B, using L
%   bins for each matrix.
%
%   See also MI, HIST.
%   jfd, 15-11-2006, working
%        27-11-2006, memory usage reduced (sub2ind)
%        22-10-2008, added support for 1D matrices
%        01-09-2009, commented specific code for sensorimotor signals
%        24-08-2011, speed improvements by Andrew Hill
ma=min(A(:));
MA=max(A(:));
mb=min(B(:));
MB=max(B(:));
% For sensorimotor variables, in [-pi,pi]
% ma=-pi;
% MA=pi;
% mb=-pi;
% MB=pi;
% Scale and round to fit in {0,...,L-1}
A=round((A-ma)*(L-1)/(MA-ma+eps));
B=round((B-mb)*(L-1)/(MB-mb+eps));
n=zeros(L);
x=0:L-1;
for i=0:L-1
    n(i+1,:) = histc(B(A==i),x,1); %#ok<*HISTC>
end
end

function n=myhist(A,L)
ma=min(A(:));
MA=max(A(:));
A=round((A-ma)*(L-1)/(MA-ma+eps));
x=0:L-1;
n=histc(A,x,1); 
n=n';
end
