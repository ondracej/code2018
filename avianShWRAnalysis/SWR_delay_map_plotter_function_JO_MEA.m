%function [] = SWR_delay_map_plotter_function(file_add, swrInds, channelsNotToInclude)
function [] = SWR_delay_map_plotter_function_JO_MEA(file_add, swrInds)

file_add = 'Z:\JanieData\JanieSliceSWRDetections\1406\Detections.mat';
swrInds = [1 4 ];

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

%file_add='Z:\zoologie\JanieData\JanieSliceSWRDetections\1453-bic01'; %%%%%%%% the path for the detected SWRs
%swr_count=12; %%%%%%%%%%% which detected SWR to process?

%addpath(genpath(file_add));
%pathparts = strsplit(file_add,'\'); data_name=pathparts{end};
%addpath(genpath(file_add));

[filepath,name,ext] = fileparts(file_add);
data_name = name;
data=load(file_add);

figSaveDir = [filepath '\DetectionPlots-New\'];
if exist(figSaveDir, 'dir') == 0
    mkdir(figSaveDir);
    disp(['Created: '  figSaveDir])
end

%info = load([filepath '\' name(1:end-10) 'RippleData.mat']);

SWRs=data.D.AllSWRDataOnChans; % each column of this cell is one SWR, rows correspond to channels


%  chansNotToPlot = data.D.channelsNotToInclude;
chansNotToPlot = [];

plottingOrder = data.D.plottingOrder;

NoDetChanInds = ismember(plottingOrder, chansNotToPlot);

%addpath(genpath(file_add));



%% reorganizing the data in matrices and SWR trough detection

% designing a filter for extraction of low frequenc ? component of each
% SWR, the sharp wave (e.g. 20-40 Hz)
fs = 32000;
%fs=data.D.Fs; % sampling rate

%[b1,a1] = butter(2,[150 400]/(fs/2)); % ripple burst spectral range
%[b2,a2] = butter(2,[.2 20]/(fs/2)); % sharp wave range

[b1,a1] = butter(2,[80 400]/(fs/2)); % ripple burst spectral range
[b2,a2] = butter(2,[.2 40]/(fs/2)); % sharp wave range

%%

nSWRCounts = size(SWRs, 2);
swrInds = 1:1:nSWRCounts;
for j = 1:nSWRCounts
    % reading from the cell, filtering, and rearranging in a 3D matrix
    swr_count=swrInds(j);
    for chnl=1:size(SWRs,1)
        SWR(:,chnl)=SWRs{chnl,swr_count};
    end
    
    % we filter the data to just extract the low-frequency component,
    % the Sharp Wave, and to detect the trough based on it
    ripple=filtfilt(b1,a1,SWR);
    sharp_wave=filtfilt(b2,a2,SWR);
    
    zscoreRip = zscore(ripple, 1, 1);
    
    ripplesZ_mat(:,:,swr_count) = zscoreRip;
    ripples_mat(:,:,swr_count)=ripple;
    sharp_wave_mat(:,:,swr_count)=sharp_wave;
    
    
    %% plotting one SWR for all channels
    dist=10; % distance between channels for the plottring %???????????????????
    
    col_g = [0 .4 .2];
    col_r = [1 .5 .6];
    col_gr = [.9 .9 .9];
    
    FigH = figure(100); clf
    
    for chnl=1:size(SWRs,1)
        
        match =  NoDetChanInds(chnl);
        
        subplot(1,2,1) % first subplot Sharp Wave
        hold on
        if match
            
            plot((1:length(sharp_wave_mat(:,:,swr_count)))/fs,sharp_wave_mat(:,chnl,swr_count)-dist*chnl,...
                'color', col_gr);
            
            thisChan = num2str(plottingOrder(chnl));
            text(0.5, sharp_wave_mat(chnl,swr_count)-dist*chnl, thisChan)
            
            % continue
            disp('')
        else
            
            plot((1:length(sharp_wave_mat(:,:,swr_count)))/fs,sharp_wave_mat(:,chnl,swr_count)-dist*chnl,...
                'color', col_g);
            
            thisChan = num2str(plottingOrder(chnl));
            text(0.5, sharp_wave_mat(chnl,swr_count)-dist*chnl, thisChan)
            
        end
        
        
        subplot(1,2,2) % second subplot Sharp wave and Ripples
        hold on
        if match
            
            
            plot((1:length(ripples_mat(:,:,swr_count)))/fs,.5*ripples_mat(:,chnl,swr_count)-dist*chnl,...
                'color',col_gr);
            plot((1:length(sharp_wave_mat(:,:,swr_count)))/fs,sharp_wave_mat(:,chnl,swr_count)-dist*chnl,...
                'color',col_gr );
        else
            plot((1:length(ripples_mat(:,:,swr_count)))/fs,.5*ripples_mat(:,chnl,swr_count)-dist*chnl,...
                'color',col_r);
            plot((1:length(sharp_wave_mat(:,:,swr_count)))/fs,sharp_wave_mat(:,chnl,swr_count)-dist*chnl,...
                'color',col_g );
        end
        
        
        hold on
        
        
    end
    figure(FigH)
    subplot(1,2,1)
    axis tight
    %yticks(dist*(-chnl:4:-1));
    % yticklabels(num2cell(1:4:chnl));
    yticklabels([]);
    xlim([.5 1.5])
    ylim([-600 0])
    ylabel('channels')
    xlabel('Time (sec)');
    title(['Raw Data: ' data_name(1:end-11)  ' SWR: ' num2str(swr_count) ]);
    
    subplot(1,2,2)
    % yticks(dist*(-chnl:4:-1));
    %yticklabels({});
    yticklabels([]);
    xlim([.5 1.5])
    ylim([-600 0])
    xlabel('Time (sec)');
    
    %%
    
    %
    % saveName = [figSaveDir 'RawData__' sprintf('%03d', j)];
    % plotpos = [0 0 12 18];
    % print_in_A4(0, saveName, '-djpeg', 0, plotpos);
    
    
    %% extracting the ripple envelope, plotting 1 SWR along channels
    % extracting the trough times across channels
    %     t_trough_ind = [];
    %     for chnl=1:size(sharp_wave_mat,2)
    %         %[~,t_trough_ind(chnl)]=min(sharp_wave_mat(:,chnl,swr_count),[],'all','linear');
    %         match =  NoDetChanInds(chnl); % we do not look for the mins in the noisy channels
    %         if ~match
    %             [~,t_trough_ind(chnl)]=min(sharp_wave_mat(:,chnl,swr_count));
    %         else
    %
    %             t_trough_ind(chnl)=nan;
    %         end
    %     end
    %     %t_trough=(t_trough_ind-min(t_trough_ind,[],'all'))/fs;
    %     t_trough=(t_trough_ind-min(t_trough_ind))/fs;
    
    % ripple envelope and plot with sharp waves
    
    win_len=round(fs/20) ; % sliding window for the RMS envelope
    [up,lo] = envelope(ripplesZ_mat(:,:,swr_count),win_len,'rms');
    
    
    %win_len=round(fs/20) ; % sliding window for the RMS envelope
    %[up,lo] = envelope(ripplesZ_mat(:,:,swr_count), win_len, 'analytic');
    
    
    % plotting one SW and ripple envelopes for all channels
    dist=20; % distance between channels for the plottring %???????????????????
    samps=1:1:length(SWR);
    t_plot=samps/(fs/1)-1;
    
    %%
    figure(103); clf
    chnls=1:59; % channels to plot
    %for chnl=chnls %size(SWRs,1)
    for chnl=1:59 %size(SWRs,1)
        
        subplot(1,4,2); % for the sharp wave and ripples envelope
        
        thisChan = num2str(plottingOrder(chnl));
        match =  NoDetChanInds(chnl); % we do not look for the mins in the noisy channels
        
        if ~match
            plot(t_plot,ripplesZ_mat(samps,chnl,swr_count)-dist*chnl,'color',col_r);     hold on
            plot(t_plot,up(samps,chnl)-dist*chnl,t_plot,lo(samps,chnl)-dist*chnl,'color',[.5 0 0]);
            text(-0.5, sharp_wave_mat(chnl,swr_count)-dist*chnl, thisChan)
        else
       
            plot(t_plot,ripplesZ_mat(samps,chnl,swr_count)-dist*chnl,'color',col_gr);     hold on
            plot(t_plot,up(samps,chnl)-dist*chnl,t_plot,lo(samps,chnl)-dist*chnl,'color',col_gr);
            text(-0.5, sharp_wave_mat(chnl,swr_count)-dist*chnl, thisChan)
        end
        
        
        subplot(1,4,1) % for the sharp wave and the ripples
        if ~match
            plot(t_plot,ripplesZ_mat(samps,chnl,swr_count)-dist*chnl,'color',col_r);     hold on
            plot(t_plot,sharp_wave_mat(samps,chnl,swr_count)-dist*chnl,'color',col_g);
            text(-0.5, sharp_wave_mat(chnl,swr_count)-dist*chnl, thisChan)
        else
            plot(t_plot,ripplesZ_mat(samps,chnl,swr_count)-dist*chnl,'color',col_gr);     hold on
            plot(t_plot,sharp_wave_mat(samps,chnl,swr_count)-dist*chnl,'color',col_gr);
            text(-0.5, sharp_wave_mat(chnl,swr_count)-dist*chnl, thisChan)
        end
        
    end
    
    subplot(1,4,1)
    % yticks(dist*(chnls(1):4:chnls(end)));
    % yticklabels(num2cell(chnls(1):4:chnls(end)));
    ylabel('channels')
    yticklabels([]);
    xlim([-.5 .5])
    % ylim(dist*[chnls(1)-1 chnls(end)+1])
    ylim([-1200 0])
    xlabel('Time (sec)');
    title(['Raw Data: ' data_name(1:end-11)  ' SWR: ' num2str(swr_count) ]);
    
    
    subplot(1,4,2);
    yticks([]);
    xlim([-.5 .5])
    %ylim(dist*[chnls(1)-1 chnls(end)+1])
    ylim([-1200 0])
    xlabel('Time (sec)');
    
    
    %%
    
    % threshold for ripple detection
    %tr=median(up)+3.0*iqr(up);
    
    %tr=median(up)+2*iqr(up);
    tr=1.3;
    
    t0=ones(1,length(chnls));
    
    hold on
    % adding the threshold to the subplot 1
    %for chnl=chnls
    %searchROI = 25500:40000; % -.25s to +.25 s
    searchROI = 32000 -(.12*fs):32000+(.25*fs); % -.25s to +.25 s
    
    for chnl=1:59
        
        thisChan = num2str(plottingOrder(chnl));
        match =  NoDetChanInds(chnl); % we do not look for th
        
        
        %t_0=find(up(searchROI,chnl)>tr(chnl),1) +searchROI(1); % time index of the first supra threshold detection
        t_0=find(up(searchROI,chnl)>tr ,1) +searchROI(1); % time index of the first supra threshold detection
        %t_0=find(up(searchROI,chnl)>tr) +searchROI(1); % time index of the first supra threshold detection
        %t_0=find(up(:,chnl)>tr(chnl),1); % time index of the first supra threshold detection
        if ~isempty(t_0)
          
                t0(chnl-chnls(1)+1)=t_0;  % fist supra-threshold sample for each channel
          
            subplot(1,4,1)
            plot(t_plot(t0(chnl-chnls(1)+1)),up(t0(chnl-chnls(1)+1),chnl)-dist*chnl,'color',[.4 .0 .4],'marker','s','markersize',5);
            
            subplot(1,4,2)
            plot(t_plot(t0(chnl-chnls(1)+1)),up(t0(chnl-chnls(1)+1),chnl)-dist*chnl,'color',[.4 .0 .4],'marker','s','markersize',5);
            
        end
        if match
            t0(chnl-chnls(1)+1) = nan;
        end
    end
    
    title('Ripple Onset Detection');
    
    t00=t0/fs; % in s
    
    %% Is the detection ok
   
    %%
    %     saveName = [figSaveDir 'Detections__' sprintf('%03d', j)];
    %     plotpos = [0 0 15 18];
    %     print_in_A4(0, saveName, '-djpeg', 0, plotpos);
    
    %figure; plot(up(searchROI,chnl))
    %% delay map visualization
    
    % the time when the SWR has been detected in a channel first, is the reference time, or zero
    % delay, and we consider the time of observation of the SWR in the other
    % channels as the daly of the spread of the SWR, so we subtract the t_min
    % from all the t_delays
    sorted_t00=unique(sort(t00));
    %t00_min=sorted_t00(3); % after sorting the delay times, the first one is 0 (or 1/fs) which is associated ...
    t00_min=sorted_t00(2);
    
    medianTime = nanmedian(sorted_t00(1:end));
    % diffT = medianTime-t00_min;
    
    AllDiffsFromMedian = medianTime - sorted_t00;
    
    %TInd = find(AllDiffsFromMedian < 0.17); % look for the first ind where the diff between median is < 110 ms
    TInd = find(AllDiffsFromMedian < 0.15); % look for the first ind where the diff between median is < 110 ms
    
    t00_min=sorted_t00(TInd(1));
    
    
    %%
    
    whichInd = find(t00 == t00_min);
    firstChan = plottingOrder(whichInd);
    
    % with the channels with no detected SWR.
    t0=t00-t00_min;
    
    allzeros = find(t0 < 0); % chans with no detections
    
    
    t0NoZeros = t0;
    t0NoZeros(allzeros) = nan;
    % constructing the grid of coordinates based on the paddings of our
    % recording micro array electorde
    % z matrix, regarding the fact that some of the entries in the 8x8 array
    % are not active electrodes, we can assign any random value, i.e. random delay, to those places, just to be able to
    % make a complete matrix. To keep the continuity, we assign a neighboring values to those entries.
    % At the end we do not consider those places on the final plot
    
    toT0 = t0NoZeros;
    %  toT0 = t0;
    zz = [];
    %zz=[t0(5) t0(1:3) t0(3) t0(4:5) t0(5) t0(6:53) t0(54) t0(54:59) t0(59)];
    zz=[ nan toT0(1:6) nan toT0(7:30) nan toT0(31:53) nan toT0(54:59) nan ];
    z=reshape(zz,8,8)';
    
    
    zX=[ nan plottingOrder(1:6) nan plottingOrder(7:30) nan plottingOrder(31:53) nan plottingOrder(54:59) nan ];
    zZ=reshape(zX,8,8)';
    
    %max_val=max(z,[],'all');
    %min_val=min(z,[],'all');
    %max_val=max(max(z));
    %min_val=min(min(z));
    %imagesc([0 7*spacing],[0 7*spacing],z,clim); colormap(cmap); axis equal
    %%
    %figure0=figure(301); clf
    subplot(1, 4, [3 4])
    %cmap=summer;
    %cmap=flipud(pink);
    cmap=flipud(copper);
    colormap(cmap)
    
    clims = [0 .35];
    
    
    zToPlot = flipud(z);
    [row, col] = find(zToPlot == 0);
    %zToPlot = z;
    [nr,nc] = size(zToPlot);
    pcolor([zToPlot nan(nr,1); nan(1,nc+1)]);
    %shading flat;
    colorbar
    hold on
    plot(col+.5, row+.5, 'k*')
    caxis(clims);
    
    % Label the names
    
    cnt =1;
    for rows = [8 7 6 5 4 3 2 1]
        for cols  = [1 2 3 4 5 6 7 8]
            
            if rows == 8 && cols == 1
                
            elseif rows == 8 && cols ==8
                
            elseif rows == 8 && cols ==8
                
            elseif rows == 4 && cols ==1
                
            elseif rows == 1 && cols ==1
                
            elseif rows == 1 && cols ==8
                
            else
                text(cols+.3, rows+.8, num2str(plottingOrder(cnt)))
                cnt = cnt +1;
            end
        end
    end
    
    
    title([data_name(1:end-11) ' SWR ' num2str(swr_count) ': Delay map']);
    %xlabel('x (\mu m)','fontweight','bold')
    %ylabel('y (\mu m)','fontweight','bold')
    a = colorbar;
    a.Label.String = 'delay (sec)';
    axis off
    
    saveName = [figSaveDir 'DataDelayMap__' sprintf('%03d', swr_count)];
    plotpos = [0 0 30 15];
    print_in_A4(0, saveName, '-djpeg', 0, plotpos);
    print_in_A4(0, saveName, '-depsc', 0, plotpos);
    
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

end










