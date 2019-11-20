function [] = JRCLUST_getSpikesFromRes()
%%
%resFile = 'D:\TUM\SWR-Project\ZF-59-15\20190428\19-34-00\dat\2019-04-28_19-34-00_res';
%SWDetections = 'D:\TUM\SWR-Project\ZF-59-15\20190428\19-34-00\Analysis\vDetections';

%resFile = 'D:\TUM\SWR-Project\ZF-59-15\20190428\18-48-02\dat\2019-04-28_18-48-02_res';
%SWDetections = 'D:\TUM\SWR-Project\ZF-59-15\20190428\18-48-02\Analysis\vDetections';
%%
 %resFile = 'D:\TUM\SWR-Project\Chick-10\20190427\21-58-36\dat\2019-04-27_21-58-36_res';
 %SWDetections = 'D:\TUM\SWR-Project\Chick-10\20190427\21-58-36\Analysis\vDetections';

%%
 resFile = 'D:\TUM\SWR-Project\ZF-60-88\20190429\16-26-20\dat\2019-04-29_16-26-20_res';
 SWDetections = 'D:\TUM\SWR-Project\ZF-60-88\20190429\16-26-20\Analysis\vDetections';

%resFile = 'D:\TUM\SWR-Project\ZF-71-76\20190915\18-46-58_acute\dat\18-46-58_acute_res';
%SWDetections = 'D:\TUM\SWR-Project\ZF-71-76\20190915\18-46-58_acute\Analysis\vDetections';


%%

[filepath,name,ext] = fileparts(resFile);

savePath = [filepath '\' name(1:end-3) '_spks.mat'];

r = load(resFile);

clusterNotes = r.clusterNotes;
clusterSites = r.clusterSites;

realClusterChans = [2 7 15 10 13 12 14 11 1 8 16 9 3 6 4 5]; % deepest(2) = 1
cols = {[0.6350, 0.0780, 0.1840], [0.8500, 0.3250, 0.0980], [0.9290, 0.6940, 0.1250], [0.4940, 0.1840, 0.5560], [0, 0.5, 0],[0, 0.4470, 0.7410],[0 0 0], [.7 .3 .7], [.7 .5 .7], [.7 .9 .7]};

%% spike shapes
meanWfGlobalRaw = r.meanWfGlobalRaw;
 meanWfLocalRaw = r.meanWfLocalRaw;

figure; plot(meanWfGlobalRaw(:,:,2))
figure; plot(meanWfLocalRaw(:,:,2))

spikeClusters  = r.spikeClusters;

spikeTimes= r.spikeTimes;

%% Find all chan descriptions

clustId_Multi = find(strcmp(clusterNotes,'multi'));
clustId_Single = find(strcmp(clusterNotes,'single'));

nMulti = numel(clustId_Multi);
nSingle = numel(clustId_Single);

spkTimes_multi = [];
for j = 1:nMulti
    
    clustID = clustId_Multi(j);
    
    spkClustInd = find(spikeClusters == clustID);
    spkTimes_multi{j} = spikeTimes(spkClustInd);
    
end


spkTimes_single = [];
for j = 1:nSingle
    
    clustID = clustId_Single(j);
    
    spkClustInd = find(spikeClusters == clustID);
    spkTimes_single{j} = spikeTimes(spkClustInd);
    
end

%% Remat CLust ID from Sites in JRCLUST to real OpenEphys Chan
realChanMapping = [];

for j = 1:numel(clusterSites)
    thisClustSite = clusterSites(j);
    realChanMapping(j) = realClusterChans(thisClustSite);
end

%% Save Everything

spk.INFO.clusterNotes = clusterNotes;
spk.INFO.clusterSites = clusterSites;
spk.INFO.realClusterChans = realClusterChans;
spk.INFO.meanWfGlobalRaw = meanWfGlobalRaw;
spk.INFO.meanWfGlobalRaw = meanWfGlobalRaw;
spk.INFO.spikeClusters = spikeClusters;
spk.INFO.spikeTimes = spikeTimes;
spk.spkTimes_multi = spkTimes_multi;
spk.spkTimes_single = spkTimes_single;
spk.realChanMapping = realChanMapping;

save(savePath,'spk');
disp(['Saved: ' savePath])

%% 
s = load(SWDetections);

allSWR_fs = s.allSWR.allSWR_fs;

Fs  = 30000;
allSWRwidths_fs = s.allSWR.allSWR_W_fs;
allSWRwidths_ms = allSWRwidths_fs/Fs*1000;

mean_width = mean(allSWRwidths_ms);
semwidth = std(allSWRwidths_ms)/sqrt(numel(allSWRwidths_ms));

varMean = var(allSWRwidths_ms)

%fileName = 'D:\TUM\SWR-Project\ZF-59-15\20190428\18-48-02\Ephys\100_CH8.continuous';

%fileName = 'D:\TUM\SWR-Project\ZF-60-88\20190429\16-26-20\Ephys\100_CH5.continuous';
%fileName = 'D:\TUM\SWR-Project\ZF-71-76\20190915\18-46-58_acute\Ephys\100_CH15.continuous';
%fileName = 'D:\TUM\SWR-Project\ZF-59-15\20190428\19-34-00\Ephys\100_CH3.continuous';
fileName = 'D:\TUM\SWR-Project\Chick-10\20190427\21-58-36\Ephys\100_CH2.continuous';

[data, timestamps, info] = load_open_ephys_data(fileName);
Fs = info.header.sampleRate;

fObj = filterData(Fs);

fobj.filt.BP=filterData(Fs);
fobj.filt.BP.highPassCutoff=1;
fobj.filt.BP.lowPassCutoff=2000;
fobj.filt.BP.filterDesign='butter';
fobj.filt.BP=fobj.filt.BP.designBandPass;
fobj.filt.BP.padding=true;

fobj.filt.FH2=filterData(Fs);
fobj.filt.FH2.highPassCutoff=100;
fobj.filt.FH2.lowPassCutoff=2000;
fobj.filt.FH2.filterDesign='butter';
fobj.filt.FH2=fobj.filt.FH2.designBandPass;
fobj.filt.FH2.padding=true;

fobj.filt.FN =filterData(Fs);
fobj.filt.FN.filterDesign='cheby1';
fobj.filt.FN.padding=true;
fobj.filt.FN=fobj.filt.FN.designNotch;

fobj.filt.Ripple=filterData(Fs);
fobj.filt.Ripple.highPassCutoff=80;
fobj.filt.Ripple.lowPassCutoff=300;
fobj.filt.Ripple.filterDesign='butter';
fobj.filt.Ripple=fobj.filt.Ripple.designBandPass;
fobj.filt.Ripple.padding=true;


[V_uV_data_full,nshifts] = shiftdim(data',-1);
[DataSeg_BP, ~] = fobj.filt.BP.getFilteredData(V_uV_data_full); % t_
[DataSeg_Notch, ~] = fobj.filt.FN.getFilteredData(DataSeg_BP); % t_DS is in ms
DataSeg_ripple = squeeze(fobj.filt.Ripple.getFilteredData(V_uV_data_full));
%

smoothWin = 0.10*Fs;
DataSeg_rect_ripple = smooth(DataSeg_ripple.^2, smoothWin);

allSWRs_fs = s.allSWR.allSWR_fs;
allSWs_fs = s.allSW.allSW_fs;

%% Single alinged SWR

win_samp = 0.1*Fs;
%for ind = 5:numel(allSWR_fs)
%ind = 38;% zf 59 %19-34-00
%ind= 34; % zf 68
ind= 11; % chick 10 21-52-28

dataSWR_roi = allSWR_fs(ind)-win_samp:allSWR_fs(ind)+win_samp;
timepoints_ms_roi = allSWR_fs(1)-win_samp:allSWR_fs(1)+win_samp;

timepoints_fs = -win_samp:win_samp;
timepoints_ms = timepoints_fs/Fs*1000;
%
figure(102);clf
subplot(6, 1, [1])
plot(timepoints_ms, data(dataSWR_roi), 'k'); axis tight
title(num2str(ind))
%pause
%end
%%
spikeByCluster_inds = r.spikesByCluster; %!!!  These are spike ind referenced to spikeTimes!!!
nCLustersites = numel(r.clusterSites); % 1 is the deepest

uniquesites = unique(r.clusterSites);

allCounts = [];
for j = 1:nCLustersites
    thisClustInds = spikeByCluster_inds{j};
    theseSpikes = spikeTimes(thisClustInds);
    allCounts(j) = numel(theseSpikes);
end

 
finalOrder = [];
for o =1:numel(uniquesites)
    thisSite = uniquesites(o);
    
    matchInds = find(r.clusterSites == thisSite);
    thisCLusterCoutns = allCounts(matchInds);

    [sortedCoutns sortIdnds] = sort(thisCLusterCoutns, 'descend');

    finalOrder = [finalOrder matchInds(sortIdnds)];
end


%%
clustersToUse = spikeByCluster_inds(finalOrder);

for j = 1:nCLustersites
    thisClustInds = clustersToUse{j};
    theseSpikes = spikeTimes(thisClustInds);
    allCounts(j) = numel(theseSpikes);
end

largerClusters = find(allCounts <25000 & allCounts >500);

clustersToUse = clustersToUse(largerClusters);
nCLustersites = numel(clustersToUse);
theseCLustersIDs = r.clusterSites(largerClusters);
cnt = 1;
smoothWin = 0.005*Fs;
for j = 1:nCLustersites
    thisClustInds = clustersToUse{j};
    theseSpikes = spikeTimes(thisClustInds);
   
    %FinalAllSpks = nan(numel(allSWR_fs),size(dataSWR_roi, 2));
    
    
   % FinalAllSpks_SW = zeros(1, size(timepoints_ms_roi, 2));
   % AllSpikes_SW = [];
    
    FinalAllSpks_SWR = zeros(1, size(timepoints_ms_roi, 2));
   % AlLSpikes_SWRs = [];
    subplot(5, 1, [2 3 4])
 %   line([1 size(dataSWR_roi, 2)], [cnt cnt], 'color', 'k', 'linewidth', 1)
%     for o = 1:numel(allSWs_fs)
%         
%         thisStart = allSWs_fs(o)-win_samp;
%         thisStop = allSWs_fs(o)+win_samp;
%           %these_spks_on_chan = spks{chan}(spks{chan} >= start_stim & spks{chan} <= stop_stim)-start_stim;
%         allSpks = theseSpikes(theseSpikes >=thisStart & theseSpikes <=thisStop) -thisStart+1;
%         for ind = 1 : numel(allSpks)
%             FinalAllSpks_SW(allSpks(ind)) = FinalAllSpks_SW(allSpks(ind)) +1;
%         end
%         %FinalAllSpks_SW(o,allSpks) = 1;
%         AllSpikes_SW{o} = allSpks;
%         
%         yes = ones(1, numel(allSpks))*cnt;
%         hold on
%         plot(allSpks, yes, 'color',[20 j*255/nCLustersites 255-j*255/nCLustersites]/255, 'Marker', '.', 'LineStyle', 'none');
%         
%         cnt = cnt +1;
%         
%     end
    
    line([1 size(dataSWR_roi, 2)], [cnt cnt], 'color', 'k', 'linewidth', 1)
    for o = 1:numel(allSWRs_fs)
        
        thisStart = allSWRs_fs(o)-win_samp;
        thisStop = allSWRs_fs(o)+win_samp;
          %these_spks_on_chan = spks{chan}(spks{chan} >= start_stim & spks{chan} <= stop_stim)-start_stim;
        allSpks = theseSpikes(theseSpikes >=thisStart & theseSpikes <=thisStop) -thisStart+1;
        
        for sind = 1 : numel(allSpks)
            FinalAllSpks_SWR(allSpks(sind)) = FinalAllSpks_SWR(allSpks(sind)) +1;
        end

        
        %FinalAllSpks_SWR(o,allSpks) = 1;
       AlLSpikes_SWRs{o} = allSpks;
        
        yes = ones(1, numel(allSpks))*cnt;
        hold on
        plot(allSpks, yes, 'color',[255-j*255/nCLustersites 50 j*255/nCLustersites]/255, 'Marker', '.', 'LineStyle', 'none');
        %plot(allSpks, yes, 'color',cols{mod(j,5)+1}, 'Marker', '.', 'LineStyle', 'none');
        
        cnt = cnt +1;
        
    end
    
    
    %allSpikesOverLCuters{j} = AlLSpikes_SWRs;
    %subplot(5, 1, [5])
   %hold on 
    %AveragePlot  = [FinalAllSpks_SW; FinalAllSpks_SWR];
    %AveragePlot  = [FinalAllSpks_SWR];
    %AveragePlot_sum = sum(AveragePlot, 1);
    %nomralizedPLot = AveragePlot_sum/numel(allSWRs_fs);
    %nomralizedPLot = AveragePlot_sum/max(AveragePlot_sum);
    %plot(timepoints_ms, smooth(nomralizedPLot, smoothWin), 'color',[255-j*255/nCLustersites 50 j*255/nCLustersites]/255)
    
   % subplot(6, 1, [6])
   % hold on
    %AveragePlot_sum_1 = (AveragePlot_sum - min(AveragePlot_sum))/(max(AveragePlot_sum) - min(AveragePlot_sum));
    %AveragePlot_sum_z = zscore(AveragePlot_sum);
    
    %nomralizedPLot_norm = 2*mat2gray(nomralizedPLot) -1;
   % nomralizedPLot_norm = mat2gray(nomralizedPLot);
    
    %plot(timepoints_ms, smooth(nomralizedPLot_norm, smoothWin), 'color',[20 j*255/nCLustersites 255-j*255/nCLustersites]/255)
    
    allFinalSpikes(j,:) = FinalAllSpks_SWR;
    
end

medianSpikes = mean(allFinalSpikes, 1);
smoothMedian = smooth(medianSpikes, smoothWin);

seemspikes = std(allFinalSpikes)/sqrt(size(allFinalSpikes, 1));
smoothsem = smooth(seemspikes, smoothWin);

  subplot(5, 1, [2 3 4])
  axis tight
    xlim([0 numel(dataSWR_roi)])
    
    subplot(5, 1, [5]); cla
    plot(timepoints_ms, smoothMedian, 'k')
    hold on
        plot(timepoints_ms, smoothMedian+smoothsem, 'r')
            plot(timepoints_ms, smoothMedian-smoothsem, 'r')
    axis tight
    
%%  
  plotDir = 'D:\TUM\SWR-Project\Figs\';

  %saveName = [plotDir 'ZF-59-15_18-48-02_SpikeRaster'];
  %saveName = [plotDir 'ZF-68-15_16-26-20_SpikeRaster'];
%saveName = [plotDir 'ZF-59-15_19-34-00_SpikeRaster'];
%saveName = [plotDir 'Chick10-21-58-36_SpikeRaster'];
plotpos = [0 0 6 15];

print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);


%% 10 s trace with SWRs
%for oo = 15:numel(allSWR_fs)
%    ind=oo;
 ind = 34;    %zf 68
%ind = 356; %zf 59 - 17-30
 %    ind = 25; % chik 10 - 21-51-18
        theseCLustersIDs = r.clusterSites(largerClusters);
        
    data = squeeze(DataSeg_Notch);
    rippleData = DataSeg_rect_ripple;
    
    win_samp = 4*Fs;
    
    
    dataSWR_roi = allSWR_fs(ind)-win_samp:allSWR_fs(ind)+win_samp;
    timepoints_ms_roi = allSWR_fs(1)-win_samp:allSWR_fs(1)+win_samp;
    
    timepoints_fs = -win_samp:win_samp;
    timepoints_ms = timepoints_fs/Fs*1000;
    %
    figure(102);clf
    subplot(5, 1, [1])
    plot(timepoints_ms, data(dataSWR_roi), 'k'); axis tight
    hold on
    plot(timepoints_ms, rippleData(dataSWR_roi), 'k'); axis tight
    title(num2str(ind))
    %spikeByCluster_inds = r.spikesByCluster; %!!!  These are spike ind referenced to spikeTimes!!!
    %nCLustersites = numel(r.clusterSites); % 1 is the deepest
    
%     allCounts = [];
%     for j = 1:nCLustersites
%         thisClustInds = spikeByCluster_inds{j};
%         theseSpikes = spikeTimes(thisClustInds);
%         allCounts(j) = numel(theseSpikes);
%     end
%     
%     largerClusters = find(allCounts <30000 & allCounts >500);
%     
%     clustersToUse = spikeByCluster_inds(largerClusters);
%     nCLustersites = numel(clustersToUse);
    
    cnt = 1;
    smoothWin = 0.005*Fs;
    FinalAllSpks_SWR = zeros(1, size(timepoints_ms_roi, 2));
        thisStart = allSWR_fs(ind)-win_samp;
        thisStop = allSWR_fs(ind)+win_samp;
        
    for j = 1:nCLustersites
        thisClustInds = clustersToUse{j};
        theseSpikes = spikeTimes(thisClustInds);
        
        subplot(5, 1, [2 3 4])
        
        line([1 size(dataSWR_roi, 2)], [cnt-.5 cnt-.5], 'color', 'k', 'linewidth', 1)
        
    
        
        %these_spks_on_chan = spks{chan}(spks{chan} >= start_stim & spks{chan} <= stop_stim)-start_stim;
        allSpks = theseSpikes(theseSpikes >=thisStart & theseSpikes <=thisStop) -thisStart+1;
        if ~isempty(allSpks)
            for sind = 1 : numel(allSpks)
                FinalAllSpks_SWR(allSpks(sind)) = FinalAllSpks_SWR(allSpks(sind)) +1;
            end
            
            usedIDs(cnt) = theseCLustersIDs(j);
            
            %FinalAllSpks_SWR(o,allSpks) = 1;
            %   AlLSpikes_SWRs{o} = allSpks;
            
            yes = ones(1, numel(allSpks))*cnt;
            hold on
            plot(allSpks, yes, 'color',[255-j*255/nCLustersites 50 j*255/nCLustersites]/255, 'Marker', '.', 'LineStyle', 'none');
            
            cnt = cnt +1;
        end
        
    end
    axis tight
    xlim([0 numel(dataSWR_roi)])
    ylim([0 cnt])
 %pause
 %end

 %allSpikesOverLCuters{j} = AlLSpikes_SWRs;
    subplot(5, 1, [5]);cla
   hold on 
    %AveragePlot  = [FinalAllSpks_SW; FinalAllSpks_SWR];
    AveragePlot  = [FinalAllSpks_SWR];
   % AveragePlot_sum = sum(AveragePlot, 1);
   % nomralizedPLot = AveragePlot_sum/numel(allSWRs_fs);
    plot(timepoints_ms, smooth(AveragePlot, smoothWin*30), 'color', 'k')
    axis tight
    
%%

  plotDir = 'D:\TUM\SWR-Project\Figs\';

  saveName = [plotDir 'ZF-71-76-18-46-58_acute_SpikeRaster_8s'];
  %saveName = [plotDir 'ZF-68-16-26-20_SpikeRaster_8s'];
%saveName = [plotDir 'ZF-59-15_19-34-00_SpikeRaster_8s'];
%saveName = [plotDir 'Chick10-21_51-18_SpikeRaster_8s'];
plotpos = [0 0 15 12];

print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);


    %%
   




%%

  for j = 1:nClusterIDs
                
                thisChan = ChansToLoad(j);
                thisClustSpikeTimes = spikeTimes_samps{j};
                
                eval(['fileAppend = ''100_CH' num2str(thisChan) '.continuous'';'])
                fileName = [obj.Session.SessionDir fileAppend];
                
                [data, timestamps, info] = load_open_ephys_data(fileName);
                
                Fs = info.header.sampleRate;
                win_samp = 0.010*Fs;
                timepoints_ms = (-win_samp:1:win_samp)/Fs*1000;
                
                allSpks = [];
                for sp = 1:numel(thisClustSpikeTimes)
                    
                    if thisClustSpikeTimes(sp) - win_samp > 0 && thisClustSpikeTimes(sp) + win_samp < obj.Session.samples
                        roi = thisClustSpikeTimes(sp) - win_samp : thisClustSpikeTimes(sp) + win_samp;
                        
                        %figure(100); clf;
                        %hold on
                        allSpks(:,sp) = data(roi);
                        %plot(timpoints, data(roi));
                        %ylim([-300 300])
                        %pause
                    end
                end
                
                %% Plotting
                
                figH = figure(100+j); clf
                
                meanSpk = nanmean(allSpks, 2);
                medianSpk = nanmedian(allSpks, 2);
                semSpk = (std(allSpks'))/(sqrt(size(allSpks, 2)));
                jbfill(timepoints_ms,[meanSpk'+semSpk],[meanSpk'-semSpk],[.5,0.5,.5],[.5,0.5,.5],[],.3);
                hold on
                %jbfill(timepoints_ms,[medianSpk'+semSpk],[medianSpk'-semSpk],[.5,0.5,.5],[.5,0.5,.5],[],.3);
                plot(timepoints_ms, meanSpk, 'k')
                %plot(timepoints_ms, medianSpk, 'b')
                axis tight
                ylim(Yss)
                title([obj.Plotting.titleTxt ': Channel ' num2str(thisChan) ', n = ' num2str(numel(thisClustSpikeTimes)) ' spks' ])
                xlabel('Time [ms]')
                ylabel('uV')
                
                saveName = [PlotDir obj.Plotting.saveTxt '_Spikes_Chan-' num2str(thisChan) '-' saveTag];
                
                plotpos = [0 0 15 10];
                print_in_A4(0, saveName, '-djpeg', 0, plotpos);
                disp('')
                
  end
            
            
  
spk_size_y = 0.005;
y_offset_between_repetitions = 0.001;
buffer = 1000; % in ms
buffer_sampls = (scanrate_labview*buffer)/1000;
  for s = 1 : reps
            start_stim = stim_start(i)-buffer_sampls;
            stop_stim = stim_stop(i)+buffer_sampls;
            length_this_stim = stop_stim-start_stim;

            %must subtract start_stim to arrange spikes relative to onset
            these_spks_on_chan = spks{chan}(spks{chan} >= start_stim & spks{chan} <= stop_stim)-start_stim;
            this_spike_count = size(these_spks_on_chan, 2);

            %% Plot the raster
            
            y_low =  (runs * spk_size_y - spk_size_y);
            y_high = (runs * spk_size_y - y_offset_between_repetitions);

            spk_vct = repmat(these_spks_on_chan, 2, 1); % this draws a straight vertical line
            this_run_spks = size(spk_vct, 2);
            ln_vct = repmat([y_high; y_low], 1, this_run_spks); % this defines the line height

            line(spk_vct, ln_vct, 'LineWidth', 0.5, 'Color', colors{color_order(p)});
  end
  



end


