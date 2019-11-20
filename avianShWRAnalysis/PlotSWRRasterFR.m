function []  = PlotSWRRasterFR()
dbstop if error
close all

d = load('D:\TUM\SWR-Project\ZF-71-76\20190919\17-51-46\Analysis\vDetections.mat');
fileName = 'D:\TUM\SWR-Project\ZF-71-76\20190919\17-51-46\Ephys\106_CH2.continuous';


[data, timestamps, info] = load_open_ephys_data(fileName);
Fs = info.header.sampleRate;

nSamples = numel(data);
allSWRs = d.allSW;
%%

Fs = 30000;


binSize = 1800; % 30 minutes

length_this_stim = binSize *Fs;
TOns = 1:length_this_stim:nSamples;
nTOns = numel(TOns);


allSpksFR = zeros(length_this_stim,1);
        
        spk_size_y = 0.005;
        y_offset_between_repetitions = 0.001;
        
       figure(100); clf
        subplot(1, 6, [1 2 3 4])
       FreqPLot = [];
       
       cnt = 1;
       for s = 1 : nTOns-1
             hold on 
           plotPos = nTOns-cnt;
           
            start_stim = TOns(s);
            stop_stim = TOns(s+1)-1;
            
            %must subtract start_stim to arrange spikes relative to onset
            
            these_spks_on_chan = allSWRs(allSWRs >= start_stim & allSWRs <= stop_stim)-start_stim;
           
            
            yvals = ones(1, numel(these_spks_on_chan))*plotPos;
            
           plot(these_spks_on_chan(1:20:end), yvals(1:20:end), 'k.')
         
            
            
            %y_low =  (s * spk_size_y - spk_size_y);
            %y_high = (s * spk_size_y - y_offset_between_repetitions);
            
            %spk_vct = repmat(these_spks_on_chan, 2, 1); % this draws a straight vertical line
            %this_run_spks = size(spk_vct, 2);
            %ln_vct = repmat([y_high; y_low], 1, this_run_spks); % this defines the line height
            
            %line(spk_vct, ln_vct, 'LineWidth', 0.5, 'Color', 'k');
          
            nbr_spks = size(these_spks_on_chan, 2);
            
            FreqPLot(plotPos) = nbr_spks;
            
            cnt = cnt+1;
            
       end
        
       xlim([0 1800*Fs]);
        
        xtickss = 0:5*60*Fs:1800*Fs;
        axis tight
        
        set(gca, 'xtick', xtickss)
        xtickabs = {'5', '10', '15', '20', '25', '30'};
        set(gca, 'xticklabel', xtickabs )
        
        %%
        
        FreqPLot_Hz = FreqPLot/binSize;
        
       subplot(1, 6, 6); cla
       smoothFreqPLot = FreqPLot_Hz;
       updSmooth = flipud(smoothFreqPLot');
       imagesc(updSmooth, [0 2.5]);
       colormap('parula')
       colorbar
       axis tight
       
       subplot(1, 6, 5); cla
       %flipped_FreqPLot_Hz = flipud(FreqPLot_Hz');
        
        xes = 1:1:numel(FreqPLot_Hz);
        %plot(FreqPLot_Hz,xes, 'ko', 'MarkerFaceColor', 'k')
        plot(FreqPLot_Hz,xes, 'k')
        hold on
        %plot(smooth(FreqPLot_Hz),xes, 'k')
        
        axis tight
        xtickss = 0:0.5:2.5;
        set(gca, 'xtick', xtickss)
        xlim([0 2.5])
        
        
        
        %%
        
        plotDir =  'D:\TUM\SWR-Project\ZF-71-76\20190919\17-51-46\Plots\';
        
        saveName = [plotDir  'SWR_detectionsRasterFR_20pnt'];
        
        plotpos = [0 0 50 20];
        
        print_in_A4(0, saveName, '-djpeg', 0, plotpos);
        print_in_A4(0, saveName, '-depsc', 0, plotpos);
        
        
        
       
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