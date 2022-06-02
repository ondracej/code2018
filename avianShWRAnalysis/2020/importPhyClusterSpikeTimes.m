
function [] = importPhyClusterSpikeTimes(dataDir, clustType, plotDir)



%% load some spikes and compute some basic things

% clu is a length nSpikes vector with the cluster identities of every spike
clu = readNPY(fullfile(dataDir,  'spike_clusters.npy')); %cluster IDs

% ss is a length nSpikes vector with the spike time of every spike (in samples)
ss = readNPY(fullfile(dataDir,  'spike_times.npy'));

% [cids, cgs] = readClusterGroupsCSV(fullfile(folderNames{f},  'cluster_groups.csv'));
[cids, cgs] = readClusterGroupsCSV(fullfile(dataDir,  'cluster_group.tsv'));
% cids is length nClusters, the cluster ID numbers
% cgs is length nClusters, the "cluster group":
% - 0 = noise
% - 1 = mua
% - 2 = good
% - 3 = unsorted


[data, header, raw] = tsvread( [dataDir '\',  'cluster_info.tsv']);

clustChans = cell2mat(cellfun(@str2num, raw(:,6), 'uni', false));
depth = cell2mat(cellfun(@str2num, raw(:,7), 'uni', false));
clust_id = cell2mat(cellfun(@str2num, raw(:,1), 'uni', false));


ClustersInds = find(cgs==clustType);
ClusterIDs = cids(ClustersInds);

spikeTimes_samps = [];
for j = 1:numel(ClusterIDs)
    
    spikeTimesInds = find(clu == ClusterIDs(j));
    spikeTimes_samps{j} = double(ss(spikeTimesInds));
    
    clustInd = find(clust_id == ClusterIDs(j));
    clustChan(j) = clustChans(clustInd);
    clustDepth(j) = depth(clustInd);
    
    
end



clust.clustType = clustType;
clust.ClusterIDs = ClusterIDs;
clust.spikeTimes_samps = spikeTimes_samps;
clust.dataDir = dataDir;
clust.cids = cids;
clust.cgs = cgs;
clust.cgs = cgs;
clust.ss = ss;
clust.clu = clu;


%%



% sp.st are spike times in seconds
% sp.clu are cluster identities

sp = loadKSdir(dataDir);

for o = 1:numel(ClusterIDs)
    
    thisClustID = ClusterIDs(o);
    thisChan = clustChan(o);
    thisDepth = clustDepth(o);
    
    gwfparams.dataDir = dataDir;    % KiloSort/Phy output folder
    apD = dir(fullfile(dataDir, '*ap*.bin')); % AP band file from spikeGLX specifically
    gwfparams.fileName = apD(1).name;         % .dat file containing the raw
    gwfparams.dataType = 'int16';            % Data type of .dat file (this should be BP filtered)
    gwfparams.nCh = 385;                      % Number of channels that were streamed to disk in .dat file
    gwfparams.wfWin = [-40 41];              % Number of samples before and after spiketime to include in waveform
    gwfparams.nWf = 2000;                    % Number of waveforms per unit to pull out
    gwfparams.spikeTimes = ceil(sp.st(sp.clu==thisClustID)*30000); % Vector of cluster spike times (in samples) same length as .spikeClusters
    gwfparams.spikeClusters = sp.clu(sp.clu==thisClustID);
    %gwfparams.spikeTimes = spikeTimes_samps; % Vector of cluster spike times (in samples) same length as .spikeClusters
    %gwfparams.spikeClusters = ClusterIDs;
    
    
    wf = getWaveForms(gwfparams);
    
    allWaveforms = squeeze(wf.waveFormsMean);
    
    
    chInd = thisChan+1;
    thisWave = allWaveforms(chInd, :);
    allWaves = squeeze(wf.waveForms(1,:,:,:));
    thisCHanAllaWaves = allWaves(:,chInd,:);
    
    figure (102+o);
    hold on;
    thisCHanAllaWaves = squeeze(thisCHanAllaWaves);
    plot(thisCHanAllaWaves(1:500,:)', 'color', [.5 .5 .5])
    plot(thisWave, 'linewidth', 2, 'color', 'k');
    axis tight
    
    titleTxt = ['Cluster ID: ' num2str(thisClustID) ' | Channel: ' num2str(thisChan) ' | Depth: ' num2str(thisDepth)];
    title(titleTxt)
    
    
    
    %% Saving
    figure (102+o);
    saveName = [plotDir 'Cluster-' num2str(thisClustID)];
    plotpos = [0 0 12 10];
    print_in_A4(0, saveName, '-djpeg', 0, plotpos);
    
    
end


end

