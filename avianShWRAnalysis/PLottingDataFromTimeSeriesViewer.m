

thisData = zf71anaesth_M;
time_ms = zf71_T;



%%
%thisData = zf71ch7sleep_M;
%time_ms = zf71ch7sleep_T;

plotDir = 'D:\TUM\SWR-Project\Figs\';

allData = [plotDir 'AllDataSnippets_CorrCals.mat'];
save(allData, 'chick10_M', 'chick10_T', 'zf60_M', 'zf60_T', 'zf71_M', 'zf71_T', 'zf7176day2final_M', 'zf7176day2final_T', 'zf71anaesth_M', 'zf71anaesth_T' )



%thisData = chick10ch7_M;
%time_ms = chick10ch7_T;

%%
Fs = dataRecordingObj.samplingFrequency;

fObj = filterData(Fs);

fobj.filt.F=filterData(Fs);
fobj.filt.F.downSamplingFactor=120; % original is 128 for 32k
fobj.filt.F=fobj.filt.F.designDownSample;
fobj.filt.F.padding=true;
fobj.filt.FFs=fobj.filt.F.filteredSamplingFrequency;

%fobj.filt.FL=filterData(Fs);
%fobj.filt.FL.lowPassPassCutoff=4.5;
%fobj.filt.FL.lowPassStopCutoff=6;
%fobj.filt.FL.attenuationInLowpass=20;
%fobj.filt.FL=fobj.filt.FL.designLowPass;
%fobj.filt.FL.padding=true;

fobj.filt.FL=filterData(Fs);
fobj.filt.FL.lowPassPassCutoff=30;% this captures the LF pretty well for detection
fobj.filt.FL.lowPassStopCutoff=40;
fobj.filt.FL.attenuationInLowpass=20;
fobj.filt.FL=fobj.filt.FL.designLowPass;
fobj.filt.FL.padding=true;

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

fobj.filt.Ripple=filterData(Fs);
fobj.filt.Ripple.highPassCutoff=80;
fobj.filt.Ripple.lowPassCutoff=300;
fobj.filt.Ripple.filterDesign='butter';
fobj.filt.Ripple=fobj.filt.Ripple.designBandPass;
fobj.filt.Ripple.padding=true;

fobj.filt.SW=filterData(Fs);
fobj.filt.SW.highPassCutoff=8;
fobj.filt.SW.lowPassCutoff=40;
fobj.filt.SW.filterDesign='butter';
fobj.filt.SW=fobj.filt.SW.designBandPass;
fobj.filt.SW.padding=true;

fobj.filt.FN =filterData(Fs);
fobj.filt.FN.filterDesign='cheby1';
fobj.filt.FN.padding=true;
fobj.filt.FN=fobj.filt.FN.designNotch;


DataSeg_BP = fobj.filt.BP.getFilteredData(thisData);
DataSeg_BP_N = squeeze(fobj.filt.FN.getFilteredData(DataSeg_BP));
DataSegRipple = squeeze(fobj.filt.Ripple.getFilteredData(thisData));


%%
figure(100);clf
subplot(2, 1, 1)
plot(time_ms, DataSeg_BP_N, 'k');
ylim([-300 300])
subplot(2, 1, 2)
plot(time_ms, DataSegRipple, 'k');
ylim([-100 100])
%%
plotDir = 'D:\TUM\SWR-Project\Figs\';

saveName = [plotDir 'zf71sleepData'];
plotpos = [0 0 12 10];

print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);

%%

figure(101);clf

plot(time_ms, DataSeg_BP_N, 'k');
hold on
plot(time_ms, DataSegRipple+250, 'k');
ylim([-300 300])
%ylim([-1000 500])
%ylim([-3000 1000])
%%
saveName = [plotDir 'Zf71-sleepData-combo'];
plotpos = [0 0 15 8];

print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);
%%
nChans = 16;

for o = 1:nChans
for s = 1:nChans
    
    
    [r, p] = corrcoef(DataSeg_BP_N(o,:), DataSeg_BP_N(s,:));
    
allRs(o,s) = r(1, 2);
allPs(o,s) = p(1, 2);
end
end
          
%%
figure(204); clf
%imagesc(allRs, [.5 1]);
imagesc(allRs, [.5 1]);
colorbar
colormap('jet')
   
plotDir = 'D:\TUM\SWR-Project\Figs\';
%%
saveName = [plotDir 'zf71_corrMatrix_anesth'];
plotpos = [0 0 12 10];

print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);   

%%
plotOffset = 0.025;
plotWidth = 0.95;
plotHeight = (1-plotOffset)/nChans;
yss = [-300 200];
figure(25); clf
cnt = 0;

            for chPlot = 1:nChans
    thisChan = 16-cnt;
            
          %for chPlot = 1:32
            
            disp('')
            if chPlot == 1
                
                [pos] = [plotOffset plotOffset plotWidth plotHeight];
               % titlePos = [ pos(1)+0.02 0.025 0.030  plotHeight];
            else
                [pos] = [plotOffset plotOffset+plotHeight*(chPlot-1) plotWidth plotHeight];
                titlePos = [ pos(1)+0.02 0.025+plotHeight*(chPlot-1) 0.030  plotHeight];
            end
            
            axes('position', pos);
            
            plot(time_ms,DataSeg_BP_N(thisChan,:), 'k')
            axis tight
            ylim(yss)
            
            %xlabel(['Time [' timeUnitLabel ']']);
            %title (['Raw Data: ECoG Channel ' this_CSC_fileToLoad(1:end-4)]);
            %this_title = this_CSC_fileToLoad(1:end-4);
            
            %ylim([rawData_yLim(1) rawData_yLim(2)])
            
            if chPlot > 1
                set(gca, 'xtick', [])
               axis off
            end
            
            cnt = cnt+1;
            % Create textbox
            %annotation(fig260H,'textbox', titlePos,'String',this_title,'FitBoxToText','off','LineStyle','none');
            % end
            end
              
            
         
plotDir = 'D:\TUM\SWR-Project\Figs\';

saveName = [plotDir 'zf71_rawData10s-anesth'];
plotpos = [0 0 12 10];

print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);   
            


