function [] =  loadKiloSortPhyClusters()

%% Script to do some basic loading of data and plotting for the dual phase3 recording. 

% this repository can be found at: https://github.com/kwikteam/npy-matlab
% You will need it to load the data in matlab. 
addpath(genpath('C:\Users\Administrator\Documents\code\GitHub\npy-matlab'))

% this repository can be found at: https://github.com/cortex-lab/spikes
% It is not necessary for working with these data in general, but it is 
% necessary for some of the functionality of this particular script. 
addpath(genpath('C:\Users\Administrator\Documents\code\GitHub\spikes'))

%% load some spikes and compute some basic things 

dataDir = 'F:\TUM\SWR-Project\ZF-59-15\Ephys\';
folderNames = {'2019-04-28_19-34-00'}; 
nShanks = 1;
Fs = 30000;
 
% This contains the x- and y-coordinates in space of every recording site
% as "xcoords" and "ycoords" (this information is also in
% channel_positions.npy) and the list of which channels are connected (only
% 374 out of the 384 can record data; "connected" is logical, size 384x1)

chanMapDir = 'F:\TUM\SWR-Project\KiloSortConfigFiles\';
%load(fullfile('posterior', 'forPRBimecP3opt3.mat'))
load(fullfile(chanMapDir, 'chanMap4.mat'))
yc = ycoords(connected); xc = xcoords(connected);

for f = 1:nShanks    
    
% clu is a length nSpikes vector with the cluster identities of every spike
clu = readNPY(fullfile([dataDir folderNames{f}],  'spike_clusters.npy')); %cluster IDs

% ss is a length nSpikes vector with the spike time of every spike (in samples)
ss = readNPY(fullfile([dataDir folderNames{f}],  'spike_times.npy'));

%%
% convert to times in seconds
% st = double(ss)/Fs; % we need this in samples
% 
% % spikeTemplates is like clu, except with the template numbers rather than
% % cluster numbers. Each spike was extracted by one particular template
% % (identified here), but when templates were merged in the manual sorting,
% % the spikes of both take on a new cluster identity in clu. So
% % spikeTemplates reflects the original output of the algorithm; 
% %clu is the result of manual sorting. 
% spikeTemplates = readNPY(fullfile([dataDir folderNames{f}],  'spike_templates.npy')); % note: zero-indexed
% 
% % tempScalingAmps is a length nSpikes vector with the "amplitudes":
% % each spike is extracted by a particular template after scaling the
% % template by some factor - that factor is the amplitude. The actual
% % amplitude of the spike is this amplitude multiplied by the size of the
% % template itself - we compute these later. 
%  % tempScalingAmps = readNPY(fullfile(folderNames{f},  'amplitudes.npy'));
% tempScalingAmps = readNPY(fullfile([dataDir folderNames{f}],  'amplitudes.npy'));
% 
% % cids is a length nClusters vector specifying the cluster IDs that are used
% % cgs is a length nClusters vector specifying the "group" of each cluster:
% % 0 = noise; 1 = MUA; 2 = Good; 3 = Unsorted
% % Noise spikes should be excluded from everything; we do this in a moment. 
% % Both MUA and Unsorted reflect real spikes (in my judgment) but ones that
% % couldn't be isolated to a particular neuron. They could include in
% % analyses of population activity, but might include spikes from multiple
% % neurons (or only partial spikes of a single neuron. Good clusters are
% % ones I judged to be well-isolated based on a combination of subjective
% % criteria: how clean the refractory period appeared, how large the spike
% % amplitudes were, how unique the waveform shapes were given the
% % surrounding context. These things can be quantified using the code at
% % (https://github.com/cortex-lab/sortingQuality), but I have not done so
% % when making the "Good" versus "MUA" decision. I think that due to the
% % data quality and density of sites on these probes, the isolation quality
% % is in general extremely good. However you should certainly interpret
% % "single neurons" with caution and very carefully examine any effects you find
% % that might be corrupted by poor isolation. 
% %
% % Note this function is included in the folder with this data (and also the "spikes" repository)

% [cids, cgs] = readClusterGroupsCSV(fullfile(folderNames{f},  'cluster_groups.csv'));
[cids, cgs] = readClusterGroupsCSV(fullfile([dataDir folderNames{f}],  'cluster_group.tsv'));
% cids is length nClusters, the cluster ID numbers
% cgs is length nClusters, the "cluster group":
% - 0 = noise
% - 1 = mua
% - 2 = good
% - 3 = unsorted

goodClustersInds = find(cgs==2);
goodClusterIDs = cids(goodClustersInds);

for j = 1:numel(goodClusterIDs)
    
    spikeTimesInds = find(clu == goodClusterIDs(j));
    spikeTimes_samps{j} = ss(spikeTimesInds);
end

%% Do a quick insanity check
fileName = 'F:\TUM\SWR-Project\ZF-59-15\Ephys\2019-04-28_19-34-00\100_CH10.continuous';

[data, timestamps, info] = load_open_ephys_data(fileName);

win_samp = 0.005*Fs;
timpoints = (-win_samp:1:win_samp)/Fs*1000;

for sp = 1:numel(spikeTimes_samps{1})
    
    theseSpikeTimes = double(spikeTimes_samps{1});
    
    
    roi = theseSpikeTimes(sp) - win_samp : theseSpikeTimes(sp) + win_samp;
    
    %figure(100); clf;
    %hold on
    allSpks(:,sp) = data(roi);
    %plot(timpoints, data(roi));
    %ylim([-300 300])
    %pause
end


%% Load the ShWDetections


   meanSpk = mean(allSpks, 2);

   figure; plot(meanSpk)
   
shWDetectionsFile =    'F:\TUM\SWR-Project\ZF-59-15\Ephys\2019-04-28_19-34-00\SWR-Python\01-19-34-00-Ch-5_py_fullFile_export_ripples.mat';
   
  rD = load([shWDetectionsFile]);
            rippleDetections = double(rD.data); % ins samples of the original data file
            rippleDetectionsx50 = rippleDetections*50; % we do this cuz the resolution of the python code is 50
            nRippleDetections = numel(rippleDetectionsx50);
            
            
            %% Now align the spikes to these events;
            
            spikeWin_s = 0.05;
            spikeWin_samp = spikeWin_s* Fs;
            thisMaxLength = -spikeWin_samp:spikeWin_samp;
           thisMaxLength_ms = thisMaxLength/Fs*1000;
           
             for q = 1:numel(spikeTimes_samps)
                 
             intFR  = zeros(1,numel(thisMaxLength)); % we define a vector for integrated FR
             theseSpikeTimes = double(spikeTimes_samps{q});
                 
                 allSpikes = [];
                 
                 for o = 1: nRippleDetections
                     thisRipple = rippleDetectionsx50(o);
                     
                     spikeWinOn = thisRipple - spikeWin_samp;
                     spikeWinOff = thisRipple + spikeWin_samp;
                     
                     these_spks_on_chan = theseSpikeTimes(theseSpikeTimes >= spikeWinOn & theseSpikeTimes <= spikeWinOff)-spikeWinOn; % Need it to be relative here
                     allSpikes{o} = these_spks_on_chan;
                     
                     nSpks = numel(these_spks_on_chan);
                     
                     % add a 1 to the FR vector for every spike
                     for ind = 1 : nSpks
                         if these_spks_on_chan(ind) ~= 0
                             intFR(these_spks_on_chan(ind)) = intFR(these_spks_on_chan(ind)) +1;
                         end
                     end
                     
                 end
                 
                 spikesOverChans{q} = allSpikes;
                 FROverChans{q} = intFR;
                 
             end
            %%
             cols = {[0.2 0.3 0.6],  [0.2 0.3 0.3],  [0.2 0.3 0.0], [0.5 0.5 0.6], [0.8 0.3 .2], [0.2 0.8 .2]};
             figH = figure(104);  clf
             
             subplot(5, 1, [2 3 4])
             %cols = {'k', 'b', 'r', 'm', 'g'
             cnt = 1;
             for q = 1:numel(spikeTimes_samps)
                 
                 allSpikes = spikesOverChans{q};
                 
                 for o = 1: nRippleDetections
                     
                     theseSpikes = allSpikes{o};
                     
                     xpoints = ones(numel(theseSpikes))*cnt;
                     
                     hold on
                     plot(theseSpikes, xpoints, '.', 'color', cols{q}, 'linestyle', 'none', 'MarkerFaceColor',cols{q},'MarkerEdgeColor',cols{q})
                     
                     cnt = cnt +1;
                     
                 end
             end
             
             axis tight
             xlim([0 numel(thisMaxLength)])
             
             subplot(5, 1, 5); cla
             hold on
             for q = 1:numel(spikeTimes_samps)
                 
                 plot(thisMaxLength_ms, smooth(FROverChans{q}, 0.01*Fs), 'color', cols{q})

             end
               axis tight
             xlim([-50 50])
             
            
             dataForSWR = 'F:\TUM\SWR-Project\ZF-59-15\Ephys\2019-04-28_19-34-00\SWR-Python\19-34-00-Ch-5_py_fullFile_data.mat';
             sD = load(dataForSWR);
             
             swrData =  sD.dataSegs_V_raw;
             Fs =  sD.INFO.fs;
             
             %%
             
            for o = 1: nRippleDetections
                
             subplot(5, 1, 1); cla
             hold on
                  
                %thisRipple = rippleDetectionsx50(o);
                thisRipple = rippleDetectionsx50(67);
                     
                     
                     roi = thisRipple - spikeWin_samp: thisRipple + spikeWin_samp;
                 plot(thisMaxLength_ms, swrData(roi) -mean(swrData(roi)), 'color', 'k')
               
                 title(num2str(o))
                 axis tight
             xlim([-50 50])
             %ylim([-400 0])
             %pause
            end
        
            
            
            
            
            %% 
                
                
                figure; plot(thisMaxLength, smooth(intFR))
            
            
            

% find and discard spikes corresponding to noise clusters
noiseClusters = cids(cgs==0);

st = st(~ismember(clu, noiseClusters));
ss = ss(~ismember(clu, noiseClusters));
spikeTemplates = spikeTemplates(~ismember(clu, noiseClusters));
tempScalingAmps = tempScalingAmps(~ismember(clu, noiseClusters));
clu = clu(~ismember(clu, noiseClusters));
cgs = cgs(~ismember(cids, noiseClusters));
cids = cids(~ismember(cids, noiseClusters));

% temps are the actual template waveforms. It is nTemplates x nTimePoints x
% nChannels (in this case 1536 x 82 x 374). These should be basically
% identical to the mean waveforms of each template
temps = readNPY(fullfile(dataDir, 'templates.npy'));

% The templates are whitened; we will use this to unwhiten them into raw
% data space for more accurate measurement of spike amplitudes; you would
% also want to do the same for spike widths. 
winv = readNPY(fullfile(dataDir,  'whitening_mat_inv.npy'));

% compute some more things about spikes and templates; see function for
% documentation
[spikeAmps, spikeDepths, templateYpos, tempAmps, tempsUnW] = ...
    templatePositionsAmplitudes(temps, winv, yc, spikeTemplates, tempScalingAmps);

% convert to uV according to the gain and properties of the probe
% 0.6 is the range of voltages acquired (-0.6 to +0.6)
% 512 is the bit range (-512 to +512, 10bits)
% 500 is the gain factor I recorded with 
% 1e6 converts from volts to uV
spikeAmps = spikeAmps*0.6/512/500*1e6; 

f =1;
%sp(f).name = folderNames{f};
sp(f).clu = clu;
sp(f).ss = ss;
sp(f).st = st;
sp(f).spikeTemplates = spikeTemplates;
sp(f).tempScalingAmps = tempScalingAmps;
sp(f).cgs = cgs;
sp(f).cids = cids;
sp(f).yc = yc;
sp(f).xc = xc;
sp(f).ycoords = ycoords;
sp(f).xcoords = xcoords;
sp(f).temps = temps;
sp(f).spikeAmps = spikeAmps;
sp(f).templateYpos = templateYpos;
sp(f).tempAmps = tempAmps;
sp(f).spikeDepths = spikeDepths;
sp(f).tempsUnW = tempsUnW;

end

%% shift spike times of the frontal probe to be aligned with the posterior

load timeCorrection.mat

sp(2).st = timeCorrectFrontal(sp(2).st, b);

%% depths and amplitudes of clusters (as the mean depth and amplitude of all of their constituent spikes)
% get firing rates here also
recordingDuration = sp(1).st(end)-sp(1).st(1);

for s = 1:nShanks
    clu = sp(s).clu;
    sd = sp(s).spikeDepths;
    sa = sp(s).spikeAmps;    
    
    % using a super-tricky algorithm for this - when you make a sparse
    % array, the values of any duplicate indices are added. So this is the
    % fastest way I know to make the sum of the entries of sd for each of
    % the unique entries of clu
    [cids, spikeCounts] = countUnique(clu);    
    q = full(sparse(double(clu+1), ones(size(clu)), sd));
    q = q(cids+1);
    clusterDepths = q./spikeCounts; % had sums, so dividing by spike counts gives the mean depth of each cluster
    
    q = full(sparse(double(clu+1), ones(size(clu)), sa));
    q = q(cids+1);
    clusterAmps = q./spikeCounts;
    
    sp(s).clusterDepths = clusterDepths';
    sp(s).clusterAmps = clusterAmps';
    sp(s).firingRates = spikeCounts'./recordingDuration;
    
end

%% basic plot of clusters over depth 
% on each probe, higher depth numbers are superficial, i.e. nearer to the
% top of the brain; lower numbers are deeper, nearer the tip

v1Borders = [2797 3840]; % determined by manual inspection
hcBorders = [1634 2797];
thalBorders = [0 1634];

mctxBorders = [1550 3840];
striatumBorders = [0 1550];

for s = 1:nShanks
    f(s) = figure; 
    
    cd = sp(s).clusterDepths;
    ca = sp(s).clusterAmps;
    cgs = sp(s).cgs;
    
    xx = rand(size(cgs));
    
    scatter(xx,cd,ca/5);
    hold on;
    scatter(xx(cgs==2),cd(cgs==2),ca(cgs==2)/5)
    title([sp(s).name ' probe, neuron depths and amplitudes']);
    xlabel('random value for visualization')
    ylabel('depth on probe (µm)')
    legend({'MUA/Unsorted', 'Good'});
end

figure(f(1))
plot([0 1], v1Borders(1)*[1 1], 'k--', 'LineWidth', 2.0);
plot([0 1], hcBorders(1)*[1 1], 'k--', 'LineWidth', 2.0);

figure(f(2))
plot([0 1], mctxBorders(1)*[1 1], 'k--', 'LineWidth', 2.0);

v1Count = sum(sp(1).clusterDepths>=v1Borders(1) & sp(1).cgs==2);
hcCount = sum(sp(1).clusterDepths>=hcBorders(1) & sp(1).clusterDepths<hcBorders(2) & sp(1).cgs==2);
thalCount = sum(sp(1).clusterDepths<thalBorders(2) & sp(1).cgs==2);

mctxCount = sum(sp(2).clusterDepths>=mctxBorders(1) & sp(2).cgs==2);
striatumCount = sum(sp(2).clusterDepths<striatumBorders(2) & sp(2).cgs==2);

fprintf(1, 'recorded %d v1 neurons, %d hippocampus, %d thalamus, %d motor cortex, %d striatum\n', v1Count, hcCount, thalCount, mctxCount, striatumCount);



%% rasters of both probes together

win = [120 180];
rasterScale = 8;

f = figure; set(f, 'Color', 'w');

nShanks = length(sp);

for s = 1:nShanks
    %ax(s) = subtightplot(nShanks,1,s);
    ax(s) = subplot(nShanks,1,s);
        
    st = sp(s).st; 
    inclSpikes = st>win(1) & st<=win(2);
    st = st(inclSpikes);
    clu = sp(s).clu; clu = clu(inclSpikes);
    cids = sp(s).cids;
    cgs = sp(s).cgs;
    sd = sp(s).spikeDepths; sd = sd(inclSpikes);
    
    co = get(gca, 'ColorOrder'); nc = size(co,1);
    
    for c = 1:length(sp(s).cids)
        if sp(s).cgs(c)==2
            thisColor = co(mod(c,nc)+1,:);
        else
            thisColor = [0.7 0.7 0.7]; % grey for unsorted and mua
        end
        
        [xx, yy] = rasterize(st(clu==cids(c)));
        theseSD = sd(clu==cids(c));
        yy(1:3:end) = yy(1:3:end)+theseSD';
        yy(2:3:end) = yy(2:3:end)*rasterScale+theseSD';
        
        plot(xx,yy, 'Color', thisColor, 'LineWidth', 1.5); 
        hold on;
    end
    
    box off;
    if s<nShanks
        set(ax(s), 'XTick', []);
    end
    
    ylabel(sprintf('%s probe', sp(s).name));    
    
end
linkaxes(ax, 'x');
xlabel('time (sec)');

%% plot some stimulus responses for the drifting gratings experiment

load experiment2stimInfo.mat

st = sp(1).st;
clu = sp(1).clu;
cgs = sp(1).cgs;
cids = sp(1).cids;
clusterDepths = sp(1).clusterDepths;
FRs = sp(1).firingRates;

v1Borders = [2797 3840]; % determined by manual inspection

% select Good neurons in V1 with at least some reasonable spike rate
inclClusters = cids(cgs==2 & clusterDepths>v1Borders(1) & clusterDepths<=v1Borders(2) & FRs>0.5); 

window = [-0.5 2.5]; % time window over which to make a psth

% use arrow keys to move through clusters, see function help for other
% controls. E.g. try pressing "t". 
%
% Flip through at least until you see cluster 657, which is a good example
psthViewer(st(ismember(clu,inclClusters)),  clu(ismember(clu, inclClusters)), stimStarts, window, stimIDs);


%% combine shanks into single clu/st, for convenience in analyzing the whole dataset together

cluOffset = 5000; 
yposOffset = 4000;

clu = []; st = [];
cids = []; cgs = [];
clusterDepths = [];
for s = 1:nShanks
    clu = [clu; sp(s).clu+(s-1)*cluOffset];
    st = [st; sp(s).st];
    cids = [cids sp(s).cids+(s-1)*cluOffset];
    cgs = [cgs sp(s).cgs];
    clusterDepths = [clusterDepths sp(s).clusterDepths+(s-1)*yposOffset];
end

[st, ii] = sort(st); 
clu = clu(ii);

%% count spikes in bins

binSize = 1; %sec

t = 0:binSize:st(end); % whole recording
nBins = length(t);

inclCIDs = cids(cgs==2); % choose "good" clusters
inclCIDdepths = clusterDepths(ismember(cids, inclCIDs)); % the depths of those clusters

thisClu = clu(st>0 & ismember(clu,inclCIDs));
thisST = st(st>0 & ismember(clu,inclCIDs));
thisSTbins = ceil(thisST./binSize);

% trick to do this binning with the sparse matrix creation function
bin2d = full(sparse(double(thisClu+1), thisSTbins, 1));
binnedSpikes = bin2d(inclCIDs+1,:); % then take just the rows according to the clusters you had
[sortedCIDdepths, ii] = sort(inclCIDdepths);
binnedSpikes = binnedSpikes(ii,:);


binnedRates = binnedSpikes./binSize;

%% simple visualization, with colormap as spike rate, x-axis time, y-axis cluster index

tstart = 0; 
winSize = 60; % seconds

figure; 
nSamps = sum(t>tstart & t<tstart+winSize);
im = imagesc((1:nSamps)*binSize, 1:size(binnedRates,1), binnedRates(:, t>tstart & t<tstart+winSize));
set(gca, 'YDir', 'normal');
caxis([0 70])
colorbar
xlabel('time (sec)')
ylabel('<-- thalamus, hc, vis ctx, striatum, motor ctx -->');
title(sprintf('start time %d seconds', tstart))

%% play through the recording as a movie

while(1)
    set(im, 'CData', binnedRates(:, t>tstart & t<tstart+winSize));     
    title(sprintf('start time %d seconds', tstart))
    drawnow; 
    tstart = tstart+1; 
end

%% correlation between the binned spike rates

corrMat = corr(binnedRates');

%% plot correlation

v1Borders = [2797 3840]; % determined by manual inspection
hcBorders = [1634 2797];
thalBorders = [0 1634];

mctxBorders = [1550 3840]+4000;
striatumBorders = [0 1550]+4000;

figure; 
imagesc(corrMat-diag(diag(corrMat)));
colormap(colormap_blueblackred)
axis square
caxis([-0.6 0.6])
set(gca, 'YDir', 'normal');

firstHC = find(sortedCIDdepths>hcBorders(1),1);
firstV1 = find(sortedCIDdepths>v1Borders(1),1);
firstStriatum = find(sortedCIDdepths>striatumBorders(1),1);
firstMctx = find(sortedCIDdepths>mctxBorders(1),1);

hold on;
lims = ylim();
plot(lims, [firstHC firstHC], 'w--');
plot([firstHC firstHC], lims, 'w--');
plot(lims, [firstV1 firstV1], 'w--');
plot([firstV1 firstV1], lims, 'w--');
plot(lims, [firstStriatum firstStriatum], 'w--');
plot([firstStriatum firstStriatum], lims, 'w--');
plot(lims, [firstMctx firstMctx], 'w--');
plot([firstMctx firstMctx], lims, 'w--');
end

