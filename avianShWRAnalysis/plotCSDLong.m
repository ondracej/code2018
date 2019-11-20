function [] = plotCSDLong()


% thisData = chick10CSD_M;
% time_ms = chick10CSD_T;


%data = load('D:\TUM\SWR-Project\Figs\Chick10DataCSD');
data = load('D:\TUM\SWR-Project\Figs\Zf59DataCSD');

fs = 30000;
%%
fObj = filterData(fs);

fobj.filt.F=filterData(fs);
fobj.filt.F.downSamplingFactor=100; % original is 128 for 32k
fobj.filt.F=fobj.filt.F.designDownSample;
fobj.filt.F.padding=true;
fobj.filt.FFs=fobj.filt.F.filteredSamplingFrequency;

fobj.filt.FN =filterData(fs);
fobj.filt.FN.filterDesign='cheby1';
fobj.filt.FN.padding=true;
fobj.filt.FN=fobj.filt.FN.designNotch;


%[DataSeg_F, tfs] = fobj.filt.F.getFilteredData(data.chick10csd5s_M);
[DataSeg_F, tfs] = fobj.filt.F.getFilteredData(data.zf59csd25s_M);

%rawData = squeeze(data.chick10csd5s_M)';
%rawTS = data.chick10csd5s_T;

rawData = data.zf59csd25s_M;
[notch, ~] = fobj.filt.FN.getFilteredData(rawData);

rawData = squeeze(notch)';
rawTS = data.zf59csd25s_T;


Fs_F = fobj.filt.FFs;
%swr = squeeze(data.chick10csd2s_M)';
swr = squeeze(DataSeg_F)';

% avg_spw=swr*10^-6; % for further use in ''SCD'' analysis, data turns to Volts instead of uV
%  spacing=100*10^-6; %%%%%%%%%%% spacing between neiboring electrodes
%   CSDoutput = CSD(swr/1000',fs,spacing,'inverse',4E-4);



%t_stamps =  data.chick10csd2s_T;
t_stamps =  tfs;




spwsig =swr;
%time= 10;
%   plot_time = 10;

% Assumption: channels are ordered according to depth in succh a way that
% the first is most superficial and the last is the deepest
% inpus: basically time and signal part of interest
% lines with '%%%%%%%%%' shall be modified

%t0=round(rand(1)*length(time)/fs); % starting time
%plot_time=[0 2.01]; % window to look at
%tlim=t0+plot_time;
%sampl=tlim(1)*fs:tlim(2)*fs;
sampl = 1:5*Fs_F;

%t_stamps=time(sampl)'; %%%%%%%%% Time Stamps to Plot
sig2plot=spwsig(sampl,:); %%%%%%%% LFP Signal to Plot

N=size(sig2plot,2);
chnl_labels=.5:size(sig2plot,2);
spacing=100*10^-6; %%%%%%%%%%% spacing between neiboring electrodes
CSDoutput = CSD(sig2plot/1000,Fs_F,spacing,'inverse',4E-4)';  %%%%%%%%%%% Give your data here, different channels in different columns
t_grid=repmat(t_stamps,length(chnl_labels)+2,1); % grid for current t values, two extra rows for start and the last full digit
y_grid=repmat([0 ; chnl_labels' ; N] , 1,length(t_stamps)); % grid for current y values
t_grid_ext=repmat(t_stamps,10*N,1); % new fine t grid
y_grid_ext=repmat((.1:.1:N)',1,size(t_grid,2)); % new fine y grid
[csd_smoo]=interp2( t_grid , y_grid ,[CSDoutput(1,:) ; CSDoutput ; CSDoutput(end,:)],t_grid_ext,y_grid_ext, 'spline'); % CSD interpolation in a finer grid

%%
figure(100); clf
%imagesc(t_stamps,(.1:.1:N)',csd_smoo); %%%%%%%%%%%%%%%%%  fixing the color range for comparing different data

%imagesc(t_stamps,(.1:.1:N)',csd_smoo, .4*[min(csd_smoo(:))  max(csd_smoo(:))]); %%%%%%%%%%%%%%%%%  fixing the color range for comparing different data
imagesc(t_stamps,(.1:.1:N)',csd_smoo, [-6000 4000]); %%%%%%%%%%%%%%%%%  fixing the color range for comparing different data
yticks(chnl_labels);  % yticklabels(num2cell(chnl_order));
colormap((jet)); % blue = source; red = sink
xlabel(' time (s)');      title('smoothed CSD (\color{red}sink, \color{blue}source\color{black})');
% overlaying SPW traces
dist=abs(max(sig2plot(:)))*1.5; %%%%%%%%%%%%%%%%% rescaling factor just for LFP overlays
hold on
cnt = 0;
for k = 1: N
    %thisPlot = sig2plot(:,N-cnt);
    thisPlot = rawData(:,N-cnt);
    plot( rawTS ,-thisPlot/dist+k-.5  ,'color',.0*[1 1 1],'linewidth',1)
end
axis tight
yticklabels({})
colorbar
%%
plotDir = 'D:\TUM\SWR-Project\Figs\';

    saveName = [plotDir 'CSD-5szf59'];
             plotpos = [0 0 25 15];
            
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
              print_in_A4(0, saveName, '-depsc', 0, plotpos);
              

end
