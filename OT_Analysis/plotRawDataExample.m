function [] = plotRawDataExample()

FigSaveDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/';

experiment = 6; %efc
recSession = 3; %sFigSaveNamec

C_OBJ = chicken_OT_analysis_OBJ(experiment, recSession);

%% Stimulus Protocol
% Stim Protocol: (1) HRTF; (2) Tuning; (3) IID; (4) ITD; (5) WN

audSelInd = 2; % SpikesThis is the index, spikesnot the stim number!!!
selection = C_OBJ.RS_INFO.ResultDirName{audSelInd};
disp(selection)


audStimDir = C_OBJ.RS_INFO.ResultDirName{audSelInd};
objFile = 'C_OBJ.mat';
objPath = [C_OBJ.PATHS.OT_Data_Path C_OBJ.INFO.expDir C_OBJ.PATHS.dirD audStimDir C_OBJ.PATHS.dirD '__Spikes' C_OBJ.PATHS.dirD objFile];
load(objPath);
disp(['Loaded: ' objPath])


%%

%%
% Plot the results


Fs = C_OBJ.Fs;

data_az0_el0 = C_OBJ.EPOCHS.data(38).Data;
timepoints_samp = 1:1:numel(data_az0_el0);
timepoints_ms = timepoints_samp/ Fs *1000;
thresh = C_OBJ.SPKS.spikes.params.thresh;


figure(100);clf
subplot(2, 2, [1 3])
plot(timepoints_ms, data_az0_el0, 'k');
ylim([-0.3 0.4])
hold on
line([0 300], [thresh thresh], 'color', 'r')
xlabel('Time [ms]')
ylabel('Amplitude [AU]')

nSpkwavefroms = 300;
allSpkWaveforms = C_OBJ.SPKS.spikes.waveforms;
WaveformSel = allSpkWaveforms(1:nSpkwavefroms, :);

timepoints_samp = 1:1:size(WaveformSel, 2);
timepoints_ms =  timepoints_samp/ Fs *1000;

subplot(2, 2, 2);
plot(timepoints_ms, WaveformSel, 'k');
xlim([1.5 4])
xlabel('Time [ms]')
ylabel('Amplitude [AU]')

%%

% spikes = ss_default_params(C_OBJ.Fs, 'thresh', thresh );
% spikes = ss_detect(C_OBJ.O_STIMS.allEpochData, spikes);
% 
% %spikes = ss_align(spikes);1
% spikes = ss_kmeans(spikes);
% spikes = ss_energy(spikes);
% spikes = ss_aggregate(spikes);

spikes = C_OBJ.SPKS.spikes;

inds = randperm(12055);
indsSel = inds(1:5000);

x = spikes.waveforms(indsSel,:) * spikes.info.pca.v(:,1);
y = spikes.waveforms(indsSel,:) * spikes.info.pca.v(:,2);
subplot(2, 2, 4)
plot(x, y, '.', 'linestyle', 'none', 'color', 'k')
ylim([-1 1])
xlim([-1.5 .5])
xlabel('PC 1')
ylabel('PC 2')

% figdata = get(gca,'UserData');
% selected = figdata.selected;

% From  splitmerge_tool(spikes)
% makePlotFeatures
% plot_features.m

%x{j} = get_feature( data.spikes,  indices, data.xchoice, data.xparam );
%y{j} = get_feature( data.spikes,  indices, data.ychoice, data.yparam );
%x = spikes.waveforms(which,:) * spikes.info.pca.v(:,param);
      
% x = spikes.waveforms(:,:) * spikes.info.pca.v(:,1);
% y = spikes.waveforms(:,:) * spikes.info.pca.v(:,2);
 

saveName = [FigSaveDir 'RawDataExample'];

plotpos = [0 0 20 15];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);
disp('')
print_in_A4(0, saveName, '-depsc', 0, plotpos);


%bla = C_OBJ.SPKS;
%blaa = C_OBJ.STIMS;

end