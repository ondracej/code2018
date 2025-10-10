function [] = MEA_Analysis__loadingMCSData_calculate_spatial_spike_amplitude(fileToLoad, saveDir, ChannelsToNoTIncludeInDetections)
dbstop if error


doPlot = 0; % will pause the analysis

% fileToLoad = '/media/janie/2TBData/JohannaData/20210329/Output/20210329-1431.h5';
% saveDir = '/media/janie/2TBData/JohannasDataFigs/SWRs-202103-29/NewPlots/1431/';
% plotDir = '/media/janie/2TBData/JohannasDataFigs/SWRs-202103-29/NewPlots/1431/';


%fileToLoad = 'E:\JohannasDataFigs\SWRs-202103-29\NewPlots\ RippleData.mat';
%load(fileToLoad)

data = McsHDF5.McsData(fileToLoad);
[filepath,name,ext] = fileparts(fileToLoad);
% 
% plotDir = [saveDir name '\'];
% 
% 
% if exist(plotDir, 'dir') == 0
%     mkdir(plotDir);
%     disp(['Created: '  plotDir])
% end

%% For getting the correct channel order

cfg = [];
cfg.channel = [1 60]; % channel index 5 to 15
cfg.window = [0 1]; % time range 0 to 1 s

dataTmp= data.Recording{1}.AnalogStream{1}.readPartialChannelData(cfg);
%Original
%plottingOrder = [21 31 41 51 61 71 12 22 32 42 52 62 72 82 13 23 33 43 53 63 73 83 14 24 34 44 54 64 74 84 15 25 35 45 55 65 75 85 16 26 36 46 56 66 76 86 17 27 37 47 57 67 77 87 28 38 48 58 68 78];

%Not including ch 15 = reference
plottingOrder = [21 31 41 51 61 71 12 22 32 42 52 62 72 82 13 23 33 43 53 63 73 83 14 24 34 44 54 64 74 84 25 35 45 55 65 75 85 16 26 36 46 56 66 76 86 17 27 37 47 57 67 77 87 28 38 48 58 68 78];

%ChannelsToNoTIncludeInDetections = [12 14 16 65];

ChanLabelInds = str2double(dataTmp.Info.Label(:));

chanInds = [];
for k = 1:numel(plottingOrder)
    chanInds(k) = find(ChanLabelInds == plottingOrder(k));
end

Fs = 32000;
fObj = filterData(Fs);
% 
% fobj.filt.F=filterData(Fs);
% fobj.filt.F.downSamplingFactor=128; % original is 128 for 32k; use 120 for 30k
% fobj.filt.F=fobj.filt.F.designDownSample;
% fobj.filt.F.padding=true;
% fobj.filt.FFs=fobj.filt.F.filteredSamplingFrequency;
% 
% %fobj.filt.FL=filterData(Fs);
% %fobj.filt.FL.lowPassPassCutoff=4.5;
% %fobj.filt.FL.lowPassStopCutoff=6;
% %fobj.filt.FL.attenuationInLowpass=20;
% %fobj.filt.FL=fobj.filt.FL.designLowPass;
% %fobj.filt.FL.padding=true;
% 
% fobj.filt.FL=filterData(Fs);
% fobj.filt.FL.lowPassPassCutoff=30;% this captures the LF pretty well for detection
% fobj.filt.FL.lowPassStopCutoff=40;
% fobj.filt.FL.attenuationInLowpass=20;
% fobj.filt.FL=fobj.filt.FL.designLowPass;
% fobj.filt.FL.padding=true;
% 
% fobj.filt.BP=filterData(Fs);
% fobj.filt.BP.highPassCutoff=1;
% fobj.filt.BP.lowPassCutoff=2000;
% fobj.filt.BP.filterDesign='butter';
% fobj.filt.BP=fobj.filt.BP.designBandPass;
% fobj.filt.BP.padding=true;

fobj.filt.FH2=filterData(Fs);
fobj.filt.FH2.highPassCutoff=100;
fobj.filt.FH2.lowPassCutoff=2000;
fobj.filt.FH2.filterDesign='butter';
fobj.filt.FH2=fobj.filt.FH2.designBandPass;
fobj.filt.FH2.padding=true;

% fobj.filt.Ripple=filterData(Fs);
% fobj.filt.Ripple.highPassCutoff=80;
% fobj.filt.Ripple.lowPassCutoff=300;
% fobj.filt.Ripple.filterDesign='butter';
% fobj.filt.Ripple=fobj.filt.Ripple.designBandPass;
% fobj.filt.Ripple.padding=true;
% 
% fobj.filt.SW=filterData(Fs);
% fobj.filt.SW.highPassCutoff=8;
% fobj.filt.SW.lowPassCutoff=40;
% fobj.filt.SW.filterDesign='butter';
% fobj.filt.SW=fobj.filt.SW.designBandPass;
% fobj.filt.SW.padding=true;

% fobj.filt.FN =filterData(Fs);
% fobj.filt.FN.filterDesign='cheby1';
% fobj.filt.FN.padding=true;
% fobj.filt.FN=fobj.filt.FN.designNotch;


%% Load full channel data

recordingDuration_s = double(data.Recording{1,1}.Duration/1e6);

cfg = [];
cfg.window = [0 recordingDuration_s]; % time
smoothWin = 0.10*Fs;

DetChanInds = ~ismember(plottingOrder, ChannelsToNoTIncludeInDetections);
ChansForDetection = plottingOrder(DetChanInds);
ChanIndsForDetection = chanInds(DetChanInds);

for k = 1:numel(ChansForDetection)
    
    disp(['Processing chan ' num2str((k)) '/' num2str(numel(ChansForDetection))])
    disp(['Chan: ' num2str(ChansForDetection(k))])
    
    thisChan = ChanIndsForDetection(k);
    
    cfg.channel = [thisChan thisChan]; % channel index 5 to 15
    
    chanDataParital= data.Recording{1}.AnalogStream{1}.readPartialChannelData(cfg);
    ChanData = chanDataParital.ChannelData/1e6; %loads all data info
    
    timestamps = chanDataParital.ChannelDataTimeStamps;
    time_samp = 1:1:numel(timestamps);
    time_s = time_samp/Fs;
    
    %% Filter data
    
    %{
    stdValArtifact = 3*std(ChanData);
    posArtifacts = find(ChanData >=stdValArtifact);
    negArtifacts = find(ChanData <=-stdValArtifact);
    
    
    n_max_min = 10000;                                    %For 10,000 resamples,
    win_max_min = round(0.050*Fs);                        %... and window interval of 50 ms,
    max_min_distribution = [];            %... create a surrogate distribution,
    for n=1:n_max_min                                     %... for each surrogate,
        istart=floor(rand*(length(ChanData)-win_max_min));    %... choose a random time index.
        if istart+win_max_min > length(ChanData)              %... make sure the time interval is not too big,
            istart = length(ChanData)-win_max_min-1;
        end
        if istart==0                                      %... make sure the time interval does not start at 0,
            istart=1;
        end                                               %... compute max value - value @ start of interval.
        max_min_distribution{n} = ChanData(istart:istart+win_max_min-1)-ChanData(istart);
    end
    
    randDist = cell2mat(max_min_distribution);
    
    %roi = posArtifacts(1)-1*Fs:posArtifacts(1)+1*Fs;
    %figure; plot(ChanData(roi));
    
    ChanData_cond = ChanData;
    
    posArtN = randperm(numel(posArtifacts));
    %negArtN = randperm(numel(negArtifacts));
    
    ChanData_cond(posArtifacts) = randDist(posArtN);
    %ChanData_cond(negArtifacts) = randDist(negArtN);
    
    %posArtifacts = find(ChanData_cond >=stdValArtifact);
    %negArtifacts = find(ChanData_cond <=-stdValArtifact);
    
    %}
    
    
    [data_shift,nshifts] = shiftdim(ChanData',-2);
    %[data_shift,nshifts] = shiftdim(ChanData_cond',-2);
    
    % spike filter
    
    data_HP = squeeze(fobj.filt.FH2.getFilteredData(data_shift));% HP
    
    
   % allChanData_HP_spike(:,k) = data_HP;
    
    data_rms = rms(data_HP, 2);
    mean_data_rms(k) = nanmean(data_rms);
    %median_data_rms(k) = nanmedian(data_rms);
    std_rms(k) = std(data_rms);
    
    %allChanData_HP_data_rms{k} = data_rms;
    
    allChanName(k) = ChansForDetection(k);
    allChanInd(k) = ChanIndsForDetection(k);
    
end

Spatial_FR_INFO.mean_data_rms = mean_data_rms;
Spatial_FR_INFO.std_rms = std_rms;
Spatial_FR_INFO.allChanName = allChanName;
Spatial_FR_INFO.allChanInd = allChanInd;


figure(103); clf
for j = 1:2
    if j == 1
        subplot(1, 4, [1 2])
        toT0 = mean_data_rms;
    clims = [0 5];
    titleText = 'RMS: Mean';
    elseif j==2
        subplot(1, 4, [3 4])
        toT0 = std_rms;
        clims = [0 3];
        titleText = 'RMS: Std';
    end


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
    %cmap=summer;
    %cmap=flipud(pink);
    %cmap=flipud(jet);
    cmap=(jet);
    colormap(cmap)
     
    
    
    
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
title(titleText)


end


saveName = [saveDir 'FiringRateRMS-SpatialMap_' name];
plotpos = [0 0 22 12];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);

save([saveDir 'Spatial_FR_INFO_' name], 'Spatial_FR_INFO', '-v7.3')


end
