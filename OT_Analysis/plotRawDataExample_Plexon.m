function [] = plotRawDataExample_Plexon()

fileToLoad = 'X:\Janie-OT-MLD\Analysis2025\PlexonSpikeSorting\N-3-Exp-01_Rec-03_StimSpkSorted_WN.mat';
fileToLoad_rawData = 'X:\Janie-OT-MLD\PlexonData-WN_2025\N-3-Exp-01_Rec-03_Data.mat';

FigSaveText = 'N-3-Exp-01_Rec-03_StimSpkSorted_WN';
FigSaveDir = 'X:\Janie-OT-MLD\Analysis2025\';

load(fileToLoad);
load(fileToLoad_rawData);

waveforms = spikes.waveform;
pc1 = spikes.pc1;
pc2 = spikes.pc2;
pc3 = spikes.pc3;

Fs = I.Fs;

rois = I.stimROIs;
nROIs = size(rois, 1);

roiSel = 1;
r_inds = randperm(nROIs);
r_indsSel = r_inds(1:roiSel);

nspikes = size(waveforms, 1);
selection = 300;
inds = randperm(nspikes);
indsSel = inds(1:selection);

%%

figure(100);clf
subplot(2, 2, [1 3])

theseROIs_inds = rois(r_indsSel,:);

for o = 1:roiSel
    
    thisROI = theseROIs_inds(o,:);
    
    thisdata = data(thisROI(1):thisROI(2));
    timepoints_samp = 1:size(thisdata, 2);
    
    timepoints_ms = timepoints_samp/Fs;
    
    hold on
    
    plot(timepoints_ms, thisdata, 'k');
    hold on
end
xlabel('Time (ms)')

subplot(2, 2, [2])
waveforms_sel = waveforms(indsSel,:);

disp('')
timepoints_samp_wave = 1:1:size(waveforms, 2);
timepoints_ms_wave = timepoints_samp_wave/ Fs *1000;

plot(timepoints_ms_wave, waveforms_sel, 'k');
hold on
axis tight
ylim([-15000 15000])
xlabel('Time (ms)')

pc1_sel = pc1(indsSel);
pc2_sel = pc2(indsSel);

subplot(2, 2, 4)

scatter(pc1_sel, pc2_sel, 'filled', 'k')
ylim([-10000 35000])
xlim([-10000 35000])
xlabel('PC 1')
ylabel('PC 2')


saveName = [FigSaveDir FigSaveText '__RawDataExample'];

plotpos = [0 0 20 15];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);
disp('')
print_in_A4(0, saveName, '-depsc', 0, plotpos);

end

