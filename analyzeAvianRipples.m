function []  = analyzeAvianRipples()
dbstop if error
close all

hostName = gethostname;
doPlot = 1;
switch hostName
    case 'DEADPOOL'
        addpath(genpath('/home/janie/Code/code2018/'))
        dirD = '/';
        
        %% Penetration 4
        %fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_15-19-16/100_CH1.continuous'; %DV=1806
        %fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_16-03-12/100_CH1.continuous'; %DV=2207
        
        
        %% Use these
        %fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_16-30-56/100_CH1.continuous'; %DV=2526, 30 min
        %fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-05-32/100_CH1.continuous'; %DV=2998
        fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-29-04/100_CH1.continuous'; %good one %DV=3513
        %fileName = '/media/janie/Data64GB/ShWRChicken/chick2_2018-04-30_17-56-36/100_CH1.continuous'; %DV=1806 %DV=4042
        
        saveDir = ['/media/janie/Data64GB/ShWRChicken/Figs/ShWDetections/'];
        saveName = [saveDir 'ShWDetection_Chick2_17-29-04_'];
        
    case 'TURTLE'
        
        addpath(genpath('/home/janie/code/code2018/'))
        dirD = '/';
        
        %% Use these
        %fileName = '/media/janie/TimeMachine_250GB/ShWRChicken/chick2_2018-04-30_16-30-56/100_CH1.continuous'; %DV=2526, 30 min
        %fileName = '/media/janie/TimeMachine_250GB/ShWRChicken/chick2_2018-04-30_17-05-32/100_CH1.continuous'; %DV=2998
        fileName = '/media/janie/TimeMachine_250GB/ShWRChicken/chick2_2018-04-30_17-29-04/100_CH1.continuous'; %good one %DV=3513
        %fileName = '/media/janie/TimeMachine_250GB/ShWRChicken/chick2_2018-04-30_17-56-36/100_CH1.continuous'; %DV=1806 %DV=4042
        
        saveDir = ['/home/janie/Dropbox/00_Conferences/SFN_2018/figsForPoster/'];
        
end


Fs = 30000;

%d = load('/media/janie/Data64GB/ShWRChicken/Figs/ShWDetections/ShWDetection_Chick2_16-30-56_-RippleDetections.mat');
%d = load('/media/janie/Data64GB/ShWRChicken/Figs/ShWDetections/ShWDetection_Chick2_17-05-32_-RippleDetections.mat');
%d = load('/media/janie/Data64GB/ShWRChicken/Figs/ShWDetections/ShWDetection_Chick2_17-29-04_-RippleDetections.mat');
d = load('/media/janie/Data64GB/ShWRChicken/Figs/ShWDetections/ShWDetection_Chick2_17-56-36_-RippleDetections.mat');



tmpPeaks = d.templatePeaks;

peakW = tmpPeaks.peakW;
peakTime = tmpPeaks.absPeakTime_s;
peakTime_fs = tmpPeaks.asPeakTime_fs;


[C,UInds,ic] = unique(peakTime_fs);

peakW = peakW(UInds);
peakTime = peakTime(UInds);
peakTime_fs = peakTime_fs(UInds);



%%

peaksToUse  =find(peakTime_fs <= 1200*Fs);
peakW = peakW(peaksToUse);
nPeaks = numel(peakW);

figure(100); clf
binWidths = 0:0.002:0.3;
histogram(peakW/Fs, binWidths, 'facecolor', 'k')
%xlim([0.05 0.3])

mean = nanmean(peakW/Fs);
median = nanmedian(peakW/Fs);
hold on
plot(mean, 250, 'rv')
plot(median, 250, 'bv')
ylim([0 350])
xlim([0 0.3])
title(['n=' num2str(nPeaks)])

saveDir = ['/home/janie/Dropbox/00_Conferences/SFN_2018/figsForPoster/'];

%saveName = [saveDir 'Chick2_16-30-56_rippleWidthHist'];
%saveName = [saveDir 'Chick2_17-05-32_rippleWidthHist'];
%saveName = [saveDir 'Chick2_17-29-04_rippleWidthHist'];
saveName = [saveDir 'Chick2_17-56-36_rippleWidthHist'];

plotpos = [0 0 10 10];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);

%% Do not use
%{
binSize_s = 5;


nSegments = numel(TOns);

rippleDetections = [];
for j =1:nSegments-1
    rippleDetections(j) = numel(peakTime_fs(peakTime_fs >= TOns(j) &  peakTime_fs  <= TOns(j+1)-1));
end

rippleDetections_hz = rippleDetections/binSize_s;

xes = 1:1:numel(rippleDetections);
figure(200); clf; plot(xes, smooth(rippleDetections_hz,5))
%}
%% 
figure(100); clf
binSize = 10;
length_this_stim = binSize *Fs;
TOns = 1:length_this_stim:peakTime_fs(end);
nTOns = numel(TOns);


allSpksFR = zeros(length_this_stim,1);
        
        spk_size_y = 0.005;
        y_offset_between_repetitions = 0.001;
        
        subplot(1, 5, [1 2 3 4])
       FreqPLot = [];
        for s = 1 : 120-1
            start_stim = TOns(s);
            stop_stim = TOns(s+1)-1;
            
            %must subtract start_stim to arrange spikes relative to onset
            
            these_spks_on_chan = peakTime_fs(peakTime_fs >= start_stim & peakTime_fs <= stop_stim)-start_stim;
            
            y_low =  (s * spk_size_y - spk_size_y);
            y_high = (s * spk_size_y - y_offset_between_repetitions);
            
            spk_vct = repmat(these_spks_on_chan, 2, 1); % this draws a straight vertical line
            this_run_spks = size(spk_vct, 2);
            ln_vct = repmat([y_high; y_low], 1, this_run_spks); % this defines the line height
            
            line(spk_vct, ln_vct, 'LineWidth', 0.5, 'Color', 'k');
          
            nbr_spks = size(these_spks_on_chan, 2);
            
            FreqPLot(s) = nbr_spks;
        end
        
        xtickss = 0:2*Fs:10*Fs;
        axis tight
        
        set(gca, 'xtick', xtickss)
        xtickabs = {'0', '2', '4', '6', '8', '10'};
        set(gca, 'xticklabel', xtickabs )
        
        
        subplot(1, 5, 5); cla
        
        FreqPLot_Hz = FreqPLot/binSize;
        xes = 1:1:numel(FreqPLot_Hz);
        plot(FreqPLot_Hz ,xes)
        axis tight
        xtickss = 0:0.5:2.5;
        set(gca, 'xtick', xtickss)
        xlim([0 2.5])
        
        
        
       
        %%

saveName = [saveDir 'Chick2_16-30-56_rippleRaster'];
%saveName = [saveDir 'Chick2_17-05-32_rippleRaster'];
%saveName = [saveDir 'Chick2_17-29-04_rippleRaster'];
%saveName = [saveDir 'Chick2_17-56-36_rippleRaster'];

plotpos = [0 0 15 10];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);
        
%%


%%


timeSeries = ones(1, numel(peakTime));

for  k = 1: nPeaks
    timeSeries(allRelmaxInd_ms(k)) = peakVals_uV(k);
end

binSize_s = 5;
binSize_ms = binSize_s*1000;

TOns = 1:binSize_ms:thisDur_ms;

%%  Sum of voltages normalized by number of ShWs - Avg voltage / Shw

%[ShWMeanAmp] = calcShWMeanAmp(TOns, timeSeries);
[ShWRate_Hz, nNonZeros] = calcShWRate(TOns, timeSeries, binSize_s);

plottingXBin_min = 30;
plottingXBin_ms =  plottingXBin_min*60*1000;

%nhrs = ceil(thisDur_ms/(1000*1800));
%nxDivs = ceil(thisDur_ms/(plottingXBin_ms));

smoothWin_1 = 3; % 3*100s% ~ ` min

hourBin = plottingXBin_ms/binSize_ms;

TOns_hr =  1:hourBin:numel(ShWRate_Hz);

plotOffset = 0.1;
plotWidth = 0.80;
plotHeight = (1-.2)/numel(TOns_hr);

FigH2 = figure(101); clf
allVs = [];

maxRate = max(ShWRate_Hz);

if maxRate > 1
    maxlim = 2;
else
    maxlim = 1;
end

    
for j = 1:numel(TOns_hr)-1
    
    theseVs = ShWRate_Hz(TOns_hr(j):TOns_hr(j+1)-1); % normalized timeseries
    
    if j == 1
        [pos] = [0.1 plotOffset plotWidth plotHeight];
        %   titlePos = [pos(1)+0.02 0.025 0.030  plotHeight];
    else
        [pos] = [0.1 plotOffset+plotHeight*(j-1) plotWidth plotHeight];
        %  titlePos = [ pos(1)+0.02 0.025+plotHeight*(p-1) 0.030  plotHeight];
    end
    
    axes('position', pos);cla
    
    plot(theseVs)
    hold on
    plot(smooth(theseVs, smoothWin_1), 'k', 'linewidth', 1.5)
    %hold on
    %plot(potOulierInds, ShWRate_Hz(potOulierInds), 'k*')
    axis tight
    ylim([0 maxlim])
    xlim([0 hourBin])
    
    if j > 1
        set(gca, 'xtick', [])
        set(gca, 'yticklabel', [])
        ylabel(num2str(j))
        %axis off
    else
        xlabel('Time [s]')
        xtics = get(gca, 'xtick');
        xticklabs_s = xtics*binSize_s;
        
        for k = 1:numel(xticklabs_s);
            xlabs{k} = num2str(xticklabs_s(k));
        end
        set(gca, 'xticklabel', xlabs)
        
    end
    
    if j == numel(TOns_hr)-1
        title([titles.titleName_title ' | ShW rate | Bin Size: ' num2str(binSize_s) 's | smooth = 15 s'])
    end
    
    allVs(j,:) = theseVs;
end



%%

end