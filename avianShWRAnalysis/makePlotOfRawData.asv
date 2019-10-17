function [] = makePlotOfRawData()

fileToLoad = 'D:\TUM\SWR-Project\ZF-71-76\20190919\17-51-46\Plots\data32.mat';


d = load(fileToLoad);
Fs = 30000;

V_uV_data_full = d.d.V_uV_data_full;
tOn = d.d.tOn;
win_fs = d.d.batchDuration_samp;

timepoints_fs = tOn:1:win_fs+tOn;
timepoints_s = timepoints_fs/Fs;




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

%%
  DataSeg_BPFL = fobj.filt.BP.getFilteredData(V_uV_data_full);
  DataSeg_ripple = fobj.filt.Ripple.getFilteredData(V_uV_data_full);
  DataSeg_BPFL  = squeeze(DataSeg_BPFL);
  DataSeg_ripple = squeeze(DataSeg_ripple);
  DataSeg_FH2 = fobj.filt.FH2.getFilteredData(V_uV_data_full);
  DataSeg_FH2 = squeeze(DataSeg_FH2);
  
  roiStart = 3014485;
  roiStart_s = roiStart/Fs;
  roiEnd = roiStart + 90*Fs;
  roiEnd_s =  roiEnd/Fs;
  roi = roiStart:roiEnd;
   %%
  figure (100);clf
  tOn_s = tOn/Fs;
  
  subplot(8, 2, [1 2])
  plot(timepoints_s(roi), DataSeg_BPFL(roi), 'k');
  %plot(DataSeg_BPFL(roi), 'k');
  axis tight
  ylim([-500 500])
  
  roiStartB = 411475 + roiStart;
  roiStartB_s = roiStartB/Fs;
  roiEndB = roiStartB+ + 10*Fs;
  roiEndB_s = roiEndB/Fs;
  
  roiB = roiStartB:roiEndB;
  roiB_s = roiB/Fs; 
  
  roiStartC = 1194557 + roiStart;
  roiStartC_s = roiStartC/Fs;
  roiEndC = roiStartC + 10*Fs;
  roiEndC_s = roiEndC/Fs;
  roiC = roiStartC:roiEndC;
  roiC_s =  roiC/Fs;
  
  
  subplot(8, 2, [3])
  plot(timepoints_s(roiB), DataSeg_BPFL(roiB), 'k');
  axis tight
  ylim([-500 500])
  
  subplot(8, 2, [4])
  plot(timepoints_s(roiC), DataSeg_BPFL(roiC), 'k');
axis tight
ylim([-500 500])

subplot(8, 2, [1 2])

  hold on
%   line([roiStartB-roiStart  roiStartB-roiStart], [-500 500], 'color', 'r')
%   line([roiEndB-roiStart  roiEndB-roiStart], [-500 500], 'color', 'r')
%   
%   line([roiStartC-roiStart  roiStartC-roiStart], [-500 500], 'color', 'r')
%   line([roiEndC-roiStart  roiEndC-roiStart], [-500 500], 'color', 'r')

  line([roiStartB_s+tOn_s roiStartB_s+tOn_s], [-500 500], 'color', 'r')
  line([roiEndB_s+tOn_s  roiEndB_s+tOn_s], [-500 500], 'color', 'r')
  
  line([roiStartC_s+tOn_s roiStartC_s+tOn_s], [-500 500], 'color', 'r')
  line([roiEndC_s+tOn_s roiEndC_s+tOn_s], [-500 500], 'color', 'r')

  roiStartD = 149254 - .25*Fs + roiStartB;
  roiStartD_s = roiStartD/Fs;
  roiEndD = roiStartD+ .75*Fs;
  roiEndD_s = roiEndD/Fs;
  roiD = roiStartD:roiEndD;

  subplot(8, 2, [5  6])
  plot(timepoints_s(roiD), DataSeg_BPFL(roiD), 'k');
axis tight
ylim([-500 500])
  
subplot(8, 2, [7  8])
  hold on
  plot(timepoints_s(roiD), DataSeg_ripple(roiD), 'k');
axis tight  
ylim([-30 30])
  
  subplot(8, 2, [3])
  hold on
  line([roiStartD_s+tOn_s roiStartD_s+tOn_s], [-500 500], 'color', 'r')
  line([roiEndD_s+tOn_s  roiEndD_s+tOn_s], [-500 500], 'color', 'r')
  
%%
disp('')

dataDir = 'D:\TUM\SWR-Project\ZF-71-76\20190919\17-51-46\Ephys';

dataRecordingObj = OERecordingMF(dataDir);
dataRecordingObj = getFileIdentifiers(dataRecordingObj); % creates dataRecordingObject

SWRDetectionsFile = 'D:\TUM\SWR-Project\ZF-71-76\20190919\17-51-46\Analysis\vDetections.mat';
s = load(SWRDetectionsFile);
allSWR = s.allSWR;
SWRs_ms = allSWR/Fs*1000;

nSWRsToPlot = 1000;
%%
SWSelection = SWRs_ms(5000:6000);
            
              preTemplate_ms = 350;
            winTemplate = 1000;
            ch = 15;
[allSW,tSW]=dataRecordingObj.getData(ch,(SWSelection-preTemplate_ms),winTemplate);
            
            allSWRs = squeeze(allSW);
  


 
            
            %% Collect SWR HFI
            
            %[tmpHFV,tmpHFT] =  fobj.filt.Ripple.getFilteredData(allSW);
            [tmpHFV,tmpHFT] =  fobj.filt.FH2.getFilteredData(allSW);
            allSWs = squeeze(allSW);
            meanLFP = mean(allSWs(1:nSWRsToPlot,:), 1);
            
            tmpHFV_V = squeeze(tmpHFV);
            
            %figure; plot(tmpHFT, tmpHFV_V)
            
            binsSize_ms = 2;
            binsSize_samps = binsSize_ms/1000*Fs;
            HFI = [];
            for j = 1:nSWRsToPlot
                bla = buffer(tmpHFV_V(j,:), binsSize_samps);
                absBla = abs(bla);
                HFI(:,j) = sum(absBla, 1)/binsSize_samps;
            end
     %%       
 subplot(8, 2, [9 10 11 12])
            %imagesc(HFI', [0 2500]) %chick
            %imagesc(HFI', [0 40])
            imagesc(HFI', [0 40])
            %imagesc(HFI')
            cb = colorbar('NorthOutside');


            
             subplot(8, 2, [13 14])
            plot(tmpHFT, meanLFP, 'r', 'linewidth', 1.5)
            legend('mean LFP', 'Location', 'southeast')
            legend('boxoff')
            
            %ylim([-1000 200])
            %ylim([-600 50])
            axis tight
            set(gca,'XMinorTick','on','YMinorTick','on')
            
            meanHPI = mean(HFI, 2);
            hold on
            subplot(8, 2, [15 16])
            plot(meanHPI, 'k', 'linewidth', 1.5)
            %ylim([200 1200]) % ZF
            %ylim([0 50]) % chick
            axis tight
            legend('mean HPI', 'Location', 'southeast')
            legend('boxoff')
            
           plotDir =  'D:\TUM\SWR-Project\ZF-71-76\20190919\17-51-46\Plots\';
           
           saveName = [plotDir  'RawDataSWR-HF'];
            
               plotpos = [0 0 20 50];
            
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
            print_in_A4(0, saveName, '-depsc', 0, plotpos);
            
  %%          
end