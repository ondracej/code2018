dbstop if error

%dataDir = '/media/janie/Data8TB/AA19/16-00-36_cheetah/'; %csc48
dataDir = '/home/janie/Data/MPI/SleepData/AA19/01.23.2017/16-00-36_cheetah/';
csc= 112;
titl = 'TurtleAA19';

%%
dataRecordingObj = NLRecording(dataDir);

Fs = dataRecordingObj.samplingFrequency;

fObj = filterData(Fs);

%% Filters

fobj.filt.FL=filterData(Fs);
fobj.filt.FL.lowPassPassCutoff=4.5;
fobj.filt.FL.lowPassStopCutoff=6;
fobj.filt.FL.attenuationInLowpass=20;
fobj.filt.FL=fobj.filt.FL.designLowPass;
fobj.filt.FL.padding=true;

fobj.filt.FH2=filterData(Fs);
fobj.filt.FH2.highPassCutoff=100;
fobj.filt.FH2.lowPassCutoff=2000;
% fobj.filt.FH2.highPassCutoff=80;
% fobj.filt.FH2.lowPassCutoff=400;
fobj.filt.FH2.filterDesign='butter';
fobj.filt.FH2=fobj.filt.FH2.designBandPass;
fobj.filt.FH2.padding=true;

fobj.filt.FN =filterData(Fs);
fobj.filt.FN.filterDesign='cheby1';
fobj.filt.FN.padding=true;
fobj.filt.FN=fobj.filt.FN.designNotch;

%%

seg=40000; % 40 s

TOn=0:seg:(dataRecordingObj.recordingDuration_ms-seg);
TWin=seg*ones(1,numel(TOn));
nCycles=numel(TOn);

for i=500:nCycles
    
    [tmpV,t_ms]=dataRecordingObj.getData(csc,TOn(i),TWin(i));
    [LF, ~]=fobj.filt.FL.getFilteredData(tmpV); % Low freq filter
    [HF, ~]=fobj.filt.FH2.getFilteredData(tmpV); % high freq filter

    t_s = t_ms/1000 + TOn(i)/1000;
    
    figure(100); clf
    subplot(3, 1, 1)
    plot(t_s , squeeze(tmpV))
    ylim([-800 200])
    subplot(3, 1, 2)
    plot(t_s , squeeze(LF))
    ylim([-800 200])
    subplot(3, 1, 3)
    plot(t_s , squeeze(HF))
    ylim([-80 80])
pause

end



%%
%ThisPoint_s = 20149.96;
%ThisPoint_s = 20139.91;
%ThisPoint_s = 21374.6;
ThisPoint_s = 21284.5;

%%
ThisPoint_ms = ThisPoint_s*1000;

thisPont = ThisPoint_ms - 1500;
%win = 400;
win  = 3000;
%win  = 4000;

[tmpV,t_ms]=dataRecordingObj.getData(csc,thisPont, win);
    [LF, ~]=fobj.filt.FL.getFilteredData(tmpV); % Low freq filter
    [HF, ~]=fobj.filt.FH2.getFilteredData(tmpV); % high freq filter
    [HN, ~]=fobj.filt.FN.getFilteredData(tmpV); % high freq filter
    
    t_s = t_ms/1000;
    xlabs = {'-0.2', '-0.1', '0', '0.1', '0.2'};
    
    figure(100); clf
    subplot(3, 1, 1)
    %plot(t_s , squeeze(tmpV), 'k')
    plot(t_s , squeeze(tmpV), 'k')
    ylim([-700 300])
    %set(gca, 'xticklabel', xlabs)
    subplot(3, 1, 2)
    plot(t_s , squeeze(LF), 'k')
    ylim([-700 300])
    %set(gca, 'xticklabel', xlabs)
    subplot(3, 1, 3)
    plot(t_s , squeeze(HF), 'k')
    ylim([-100 80])
    %set(gca, 'xticklabel', xlabs)

    %%
    saveDir  = '/home/janie/Dropbox/02_talks/Jan2018_DaimlerBenz/Figs/';
    
saveName = [saveDir 'Turtle_05'];

plotpos = [0 0 20 10];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);



    %%
    
    
    
pnt = 20150*Fs;
win = 0.2*Fs;
thisROI  = pnt-win:pnt+win;

bla2 = 154.8897:-0.1:154.68;
bla3 = 154.8897:+0.1:155.0897;
all = [fliplr(bla2)  bla3(2:end) ];
xlabs = {'-0.2', '-0.1', '0', '0.1', '0.2'};
%%
SegData = thisSegData(:,:, thisROI);
SegData_ms = thisSegData_ms(thisROI);

DataSeg_FN = fobj.filt.FN.getFilteredData(SegData);
DataSeg_FL = fobj.filt.FL.getFilteredData(SegData);
DataSeg_FH2 = fobj.filt.FH2.getFilteredData(SegData);

%
figure(105);clf
subplot(2, 1, 1)
plot(SegData_ms, squeeze(DataSeg_FN), 'k');
axis tight
ylim([-800 250])
set(gca, 'xtick', all)
set(gca, 'xticklabel', xlabs)
% subplot(3, 1, 2)
% plot(SegData_ms, squeeze(DataSeg_FL), 'k');
% axis tight
% ylim([-800 200])
subplot(2, 1, 2)
plot(SegData_ms, squeeze(DataSeg_FH2), 'k');
axis tight
ylim([-300 150])
set(gca, 'xtick', all)
set(gca, 'xticklabel', xlabs)
xlabel ('Time [s]')


    %%
    
    %
fig2 = figure(105);clf
subplot(3, 1, 1)
plot(SegData_ms, squeeze(DataSeg_FN), 'k');
axis tight
ylim([-1000 1000])
subplot(3, 1, 2)
plot(SegData_ms, squeeze(DataSeg_FL), 'k');
axis tight
ylim([-1000 1000])
subplot(3, 1, 3)
plot(SegData_ms, squeeze(DataSeg_FH2), 'k');
axis tight
ylim([-150 150])
xlabel ('Time [s]')


