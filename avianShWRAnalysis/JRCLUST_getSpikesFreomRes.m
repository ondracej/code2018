


resFile = 'D:\TUM\SWR-Project\ZF-59-15\Ephys\20190428\19-34-00\dat\2019-04-28_19-34-00_res.mat';

[filepath,name,ext] = fileparts(resFile);

savePath = [filepath '\' name(1:end-3) '_spks.mat'];

r = load(resFile);

clusterNotes = r.clusterNotes;
clusterSites = r.clusterSites;

realClusterChans = [2 7 15 10 13 12 14 11 1 8 16 9 3 6 4 5]; % deepest(2) = 1

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


