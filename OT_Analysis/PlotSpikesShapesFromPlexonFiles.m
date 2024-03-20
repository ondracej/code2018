

DirToLoad = ['X:\Janie-OT-MLD\PlexonData-HRTF\'];

PlotDir = [DirToLoad 'SpikeFiles\' ];

if exist(PlotDir , 'dir') == 0
    mkdir(PlotDir );
end

search_file = ['*Data*'];
dir_files = dir(fullfile(DirToLoad, search_file));
nFiles = numel(dir_files);
fs = 41000;

for j = 1:nFiles
load([ DirToLoad dir_files(j).name])

FileName = [dir_files(j).name(1:end-4) '_Spikes'];

roi1 = data(1:round(0.35*fs));
roi2 = data(end-round(0.35*fs):end-1);
timepoints_samps =  1:1:numel(roi1);
timepoints_ms =  timepoints_samps/fs*1000;

figure (100);clf
subplot(1, 2, 1)
plot(timepoints_ms,roi1 )
axis tight
ylim([-30000 30000])
xlabel('Time (ms)')
title('Start')

subplot(1, 2, 2)
plot(timepoints_ms,roi2)
axis tight
ylim([-30000 30000])
xlabel('Time (ms)')
title('End')

saveName = [PlotDir FileName];

plotpos = [0 0 15 8];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);
disp('')
%print_in_A4(0, saveName, '-depsc', 0, plotpos);


end
