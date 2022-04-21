%function [] = SWR_delay_map_plotter_function(file_add, swrInds, channelsNotToInclude)
function [] = SWR_delay_map_plotter_function_SiliconProbe(file_add, swrInds)

dbstop if error
% code for the delay map of the dispersion of SWRs

%%%%%%%%%%%%%%%%%%%%%%%%%% The Recipe %%%%%%%%%%%%%%%%%%%%%%%%%%%

% We read SWRs (columns), one at a time, from variable SWRs. Within each
% SWR, we make the envelioe of the ripple burst using Hilbert transform. The
% onset of the ripple wave is ditermined using a threshold crossing over the envelope.
% Therefore we will have the time-of-ocurrance of SWR at each channel. Then we center
% all these times relative to the first one, so all will be either zero or
% positive numbers. When we perform this procress for all detected SWRs, we
% interpolate this relative-delay-time matrix for more spatial point, to have
% a better spacial resolution in the visualization and plot it
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% add the data folder to the current path

DetectionDir = 'G:\SWR\ZF-72-01\20210225\15-18-05\Ephys\Detections\';

load([DetectionDir '__SWR-Detections.mat']) % D
load([DetectionDir '__Final_SWR-Detections.mat']) %FD

%%
data_name = [D.INFO.birdName '-' D.INFO.RecSession];
figSaveDir = [D.INFO.SessionDir 'DelayMapPlots\'];

if exist(figSaveDir, 'dir') == 0
    mkdir(figSaveDir);
    disp(['Created: '  figSaveDir])
end

%% FinalSWR Detections

SW_ms = FD.allMinInds_ABS_concat_ms;

%% Create a DataObject

dataRecordingObj = OERecordingMF(D.INFO.SessionDir);
dataRecordingObj = getFileIdentifiers(dataRecordingObj); % creates dataRecordingObject

fs = dataRecordingObj.samplingFrequency;
recordingDur_ms = dataRecordingObj.recordingDuration_ms;
recordingDur_s = recordingDur_ms/1000;

%%
chMap = [10 12 7 11 9 6 8 5 3 16 4 1 13 15 14 2]; % across rows, m-l

%[b1,a1] = butter(2,[150 400]/(fs/2)); % ripple burst spectral range
%[b2,a2] = butter(2,[.2 20]/(fs/2)); % sharp wave range

%Ripple = [6 150];

[b1,a1] = butter(2,[80 400]/(fs/2)); % ripple burst spectral range
[b2,a2] = butter(2,[.2 40]/(fs/2)); % sharp wave range

[rawData,t_ms]=dataRecordingObj.getData(chMap,SW_ms-1000, 2000);
thisChanData = [];

for k = 1:numel(SW_ms)
    
    swr_count = k;
    
    thisChanData = []; sharp_wave = [];
    for q = 1:numel(chMap)
        thisChanData(:,q) = squeeze(rawData(q,k,:));
    end
    
    ripple=filtfilt(b1,a1,thisChanData);
    sharp_wave=filtfilt(b2,a2,thisChanData);
    
    zscoreRip = zscore(ripple, 1, 1);
   
    allRipples{swr_count} = ripple;
    allZRipples{swr_count} = zscoreRip;
    allSW{swr_count} = sharp_wave;
    
end

ripples_mat = [];
sharp_wave_mat = [];
for k = 1:numel(SW_ms)
    swr_count = k;
    ripple = allRipples{k};
    rippleZ = allZRipples{k};
    sharp_wave = allSW{k};
    
    ripplesZ_mat(:,:,k)=rippleZ;
    ripples_mat(:,:,k)=ripple;
    sharp_wave_mat(:,:,k)=sharp_wave;
    
    %% extracting the ripple envelope, plotting 1 SWR along channels
    % extracting the trough times across channels
    
    %{
    t_trough_ind = [];
    for chnl=1:size(sharp_wave_mat,2)
        %[~,t_trough_ind(chnl)]=min(sharp_wave_mat(:,chnl,swr_count),[],'all','linear');
        
        [~,t_trough_ind(chnl)]=min(sharp_wave_mat(:,chnl,swr_count));
        
    end
    %t_trough=(t_trough_ind-min(t_trough_ind,[],'all'))/fs;
    t_trough=(t_trough_ind-min(t_trough_ind))/fs;
    %}
    
    % ripple envelope and plot with sharp waves
    %win_len=round(fs/20) ; % sliding window for the RMS envelope
    win_len=round(fs) ; % sliding window for the RMS envelope
    %[up,lo] = envelope(ripples_mat(:,:,swr_count),win_len,'rms');
    [up,lo] = envelope(ripplesZ_mat(:,:,swr_count), win_len, 'analytic');
    
    % plotting one SW and ripple envelopes for all channels
    samps=1:1:size(thisChanData, 1);
    t_plot=samps/(fs/1)-1;
    
    %%
    offset=100;
    offset2=10;
    col_g = [0 .4 .2];
    col_r = [1 .5 .6];
    
    smoothWin_ms = 5;
    smoothWin_samp = smoothWin_ms/1000*fs;
    
    %%
    figure(103); clf
    chnls=1:16; % channels to plot
    for chnl=1:16 %size(SWRs,1)
        
        thisChan = num2str(chMap(chnl));
        
        subplot(1,4,1) % for the sharp wave and the ripples
        plot(t_plot,ripples_mat(samps,chnl,swr_count)*5-offset*chnl,'color',col_r);
        hold on
        plot(t_plot,sharp_wave_mat(samps,chnl,swr_count)-offset*chnl,'color',col_g);
        text(-0.5, sharp_wave_mat(chnl,swr_count)-offset*chnl, thisChan)
        
        subplot(1,4,2); % for the sharp wave and ripples envelope
        plot(t_plot,ripplesZ_mat(samps,chnl,swr_count)-offset2*chnl,'color',col_r);
        hold on
        %plot(t_plot,up(samps,chnl)-offset2*chnl,t_plot,lo(samps,chnl)-offset2*chnl,'color',[.5 0 0]);
        plot(t_plot,smooth(up(samps,chnl), smoothWin_samp)-offset2*chnl,t_plot,smooth(lo(samps,chnl), smoothWin_samp)-offset2*chnl,'color',[.5 0 0]);
        text(-0.5, ripplesZ_mat(chnl,swr_count)-offset2*chnl, thisChan)
        % line([t_plot(1) t_plot(end)], [1+offset2*chnl 1+offset2*chnl], 'color', 'k')
    end
    
    subplot(1,4,1)
    ylabel('channels')
    %yticklabels([]);
    xlim([-.5 .5])
    ylim([-1850 150])
    xlabel('Time (sec)');
    title(['Raw Data: ' data_name ' SWR: ' num2str(swr_count) ]);
    
    subplot(1,4,2);
    %yticks([]);
    xlim([-.5 .5])
    ylim([-185 15])
    xlabel('Time (sec)');
    
    
    %%
    smootharray = [];
    for oo = 1:16
        smootharray(:,oo) = smooth(up(:,oo), smoothWin_samp);
    end
    
    %%
    %tr=median(up)+3*iqr(up);
    tr = 3;
    
    
    t0=ones(1,length(chnls));
    
    hold on
    % adding the threshold to the subplot 1
    searchROI = 30000-(0.06*fs):30000+(0.06*fs);
    
    subplot(1,4,2)
    yss = ylim;
    
    line([t_plot(searchROI(1)) t_plot(searchROI(1))], [yss(1) yss(2)], 'color', 'k')
    line([t_plot(searchROI(end)) t_plot(searchROI(end))], [yss(1) yss(2)], 'color', 'k')
    line([t_plot(30000) t_plot(30000)], [yss(1) yss(2)], 'color', 'k')
    
    for chnl=1:16
        
        t_0=find(up(searchROI,chnl) > tr) + searchROI(1); % time index of the first supra threshold detection
        if ~isempty(t_0)
            
            t0(chnl)=t_0(1);  % fist supra-threshold sample for each channel
            
            subplot(1,4,1)
            plot(t_plot(t0(chnl-chnls(1)+1)),up(t0(chnl-chnls(1)+1),chnl)-offset*chnl,'color',[.4 .0 .4],'marker','s','markersize',5);
            
            subplot(1,4,2)
            plot(t_plot(t0(chnl-chnls(1)+1)),up(t0(chnl-chnls(1)+1),chnl)-offset2*chnl,'color',[.4 .0 .4],'marker','s','markersize',5);
            
        end
        
    end
    
    title('Ripple Onset Detection');
    
    t00=t0/fs; % in s
    
    %% delay map visualization
    
    % the time when the SWR has been detected in a channel first, is the reference time, or zero
    % delay, and we consider the time of observation of the SWR in the other
    % channels as the daly of the spread of the SWR, so we subtract the t_min
    % from all the t_delays
    sorted_t00=unique(sort(t00));
    t00_min=sorted_t00(1);
    
    
    %%
    
    whichInd = find(t00 == t00_min);
    firstChan = chMap(whichInd);
    
    % with the channels with no detected SWR.
    t0=t00-t00_min;
    allzeros = find(t0 =< 0); % chans with no detections
    
    t0NoZeros = t0;
    t0NoZeros(allzeros) = nan;
    % constructing the grid of coordinates based on the paddings of our
    % recording micro array electorde
    % z matrix, regarding the fact that some of the entries in the 8x8 array
    % are not active electrodes, we can assign any random value, i.e. random delay, to those places, just to be able to
    % make a complete matrix. To keep the continuity, we assign a neighboring values to those entries.
    % At the end we do not consider those places on the final plot
    
    toT0 = t0NoZeros;
    zz = [];
    zz=[toT0(1:4) toT0(5:8) toT0(9:12) toT0(13:16) ];
    z=reshape(zz,4,4);
    
    
    zX=[chMap(1:4) chMap(5:8) chMap(9:12) chMap(13:16)];
    zZ=reshape(zX,4,4);
    
    %%
    
    subplot(1, 4, [3 4])
    cmap=flipud(copper);
    colormap(cmap)
    
    %clims = [0 .05];
    
    zToPlot = flipud(z);
    [row, col] = find(zToPlot == 0);
    [nr,nc] = size(zToPlot);
    pcolor([zToPlot nan(nr,1); nan(1,nc+1)]);
    colorbar
    hold on
    plot(col+.5, row+.5, 'k*')
   % caxis(clims);
    
    % Label the names
    
    cnt =1;
    for cols  = [1 2 3 4]
        for rows = [4 3 2 1]
            text(cols+.45, rows+.6, num2str(chMap(cnt)))
            cnt = cnt +1;
        end
    end
    
    title([data_name(1:end-11) ' SWR ' num2str(swr_count) ': Delay map']);
    a = colorbar;
    a.Label.String = 'delay (sec)';
    axis off
    
    saveName = [figSaveDir 'DataDelayMap__' sprintf('%03d', swr_count)];
    plotpos = [0 0 30 15];
    print_in_A4(0, saveName, '-djpeg', 0, plotpos);
    print_in_A4(0, saveName, '-depsc', 0, plotpos);
    
    AllZ_s{k} = z;
    
end
%% Detection Info To Save

Det.ripples_mat = ripples_mat;
Det.sharp_wave_mat = sharp_wave_mat;
Det.up = up;
Det.lo = lo;
Det.tr = tr;
Det.plottingOrder = plottingOrder;
Det.chansNotToPlot = chansNotToPlot;
Det.t_plot = t_plot;
Det.firstChan = firstChan;
Det.medianTime = medianTime;
Det.t00 = t00;
Det.t00_min = t00_min;
Det.t0 = t0;
Det.t0NoZeros = t0NoZeros;
Det.z = z;
Det.zToPlot = zToPlot;

save([figSaveDir name(1:end-11) '_DelayMap_' sprintf('%03d', swr_count) '.mat'], 'Det', '-v7.3')

% Create rectangle
%annotation(figure0,'rectangle', [0.654 0.780 0.0704 0.097],'Color',[1 1 0.066],'FaceColor',[0.501 0.501 0.501]);
%annotation(figure0,'rectangle',[0.6545 0.1571 0.07042 0.09761],'Color',[1 1 0.06666],'FaceColor',[0.501 0.501 0.501]);
%annotation(figure0,'rectangle',[0.186 0.1595 0.0704 0.0976],'Color',[1 1 0.06666],'FaceColor',[0.5019607 0.5019607 0.50196]);
%annotation(figure0,'rectangle', [0.186714 0.7809 0.07042 0.0976],'Color',[1 1 0.0666],'FaceColor',[0.50196 0.5019 0.501960]);
%annotation(figure0,'rectangle',[0.18671 0.4261 0.070428 0.097],'Color',[1 1 0.0666],'FaceColor',[0.501960 0.50196 0.501960]);

%% smooting the matrix
%{
    % finding the RGB value associated with the matrix:
    ncol = size(cmap,1);
    col_ind = floor(1+(ncol-1)*zz/max_val);
    rgb_image = ind2rgb(col_ind,cmap);
    
    % interpolation
    im=reshape(rgb_image,8,8,3);
    F = griddedInterpolant(im);
    
    [sx,sy,sz] = size(im);
    xq = (0:1/30:sx)';
    yq = (0:1/30:sy)';
    zq = (1:sz)';
    F.Method = 'linear';
    
    vq = (F({xq,yq,zq}));
      clim=[0 .3]; %
    spacing=100; % spacing between electrode pads
    imagesc([0 8*spacing],[0 8*spacing],vq,clim);axis equal
  
    
    
    zToPlot = flipud(nanmoving_average2(z, 1, 1));
    figure1=figure(142);clf
    
    
    pcolor([zToPlot nan(nr,1); nan(1,nc+1)]);
     shading flat;
     axis off
    colorbar
    
    
    colormap(cmap);
%}



% Create rectangle
%     annotation(figure1,'rectangle', [0.654 0.780 0.0704 0.097],'Color',[1 1 0.066],'FaceColor',[0.501 0.501 0.501]);
%     annotation(figure1,'rectangle',[0.6545 0.1571 0.07042 0.09761],'Color',[1 1 0.06666],'FaceColor',[0.501 0.501 0.501]);
%     annotation(figure1,'rectangle',[0.186 0.1595 0.0704 0.0976],'Color',[1 1 0.06666],'FaceColor',[0.5019607 0.5019607 0.50196]);
%     annotation(figure1,'rectangle', [0.186714 0.7809 0.07042 0.0976],'Color',[1 1 0.0666],'FaceColor',[0.50196 0.5019 0.501960]);
%     annotation(figure1,'rectangle',[0.18671 0.4261 0.070428 0.097],'Color',[1 1 0.0666],'FaceColor',[0.501960 0.50196 0.501960]);
%


end











