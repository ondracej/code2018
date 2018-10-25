function [] = defineShWTemplate_FirstPass_LFBP(titles, ShW, DIR, REC, Artifacts, Plotting)

PlotPath = [DIR.plotDir 'Template/'];
if exist(PlotPath, 'dir') == 0
    mkdir(PlotPath);
end

%% Data object
dataRecordingObj = NLRecording(DIR.cheetahDir);
Fs=dataRecordingObj.samplingFrequency(1);
obj = sleepAnalysis;
obj=obj.getFilters(32000);

%% Define segments
seg=20000;
TOn=0:seg:(dataRecordingObj.recordingDuration_ms-seg);

nCycles = 300;
randInd = randperm(numel(TOn));

cnt = 1;
figH100 = figure(100);clf;

for i=1:numel(TOn)
    
    thisind = randInd(i);
    
    [tmpV, t_ms] =dataRecordingObj.getData(REC.bestCSC,TOn(thisind),seg);
    
    % LF of bandpass
    tmp_V_BP =obj.filt.FJLB.getFilteredData(tmpV); %bandpassfilter
    [tmp_LF_BP]=obj.filt.FL.getFilteredData(tmp_V_BP); % Low freq filter
    [tmp_LF_BP_DS,t_DS]=obj.filt.F2.getFilteredData(tmp_LF_BP);
    %[tmp_LF_BP_DS,t_DS]=obj.filt.F.getFilteredData(tmp_LF_BP); %JO
    
    % HP
    [tmp_HP,~]=obj.filt.FH.getFilteredData(tmpV); % HP filter
    
    tmpV = (squeeze(tmpV));
    tmp_V_BP = squeeze(tmp_V_BP);
    tmp_LF_BP = (squeeze(tmp_LF_BP));
    tmp_HP = squeeze(tmp_HP);
    tmp_LF_BP_DS = (squeeze(tmp_LF_BP_DS));
    neg_tmp_LF_BP_DS = -tmp_LF_BP_DS;
    
    rect_HP = abs(tmp_HP);
    HP_sqR = rect_HP.^2;
    reshaped_HP_sqR = reshape(HP_sqR, 1, 1, numel(HP_sqR));
    [tmp_HP_sqR_DS,~]=obj.filt.F2.getFilteredData(reshaped_HP_sqR); %JO
    %[tmp_HP_sqR_DS,~]=obj.filt.F.getFilteredData(reshaped_HP_sqR);
    tmp_HP_sqR_DS = squeeze(tmp_HP_sqR_DS);
    
    tmp_HP_sqR_DS_smoothed =smooth(tmp_HP_sqR_DS, 15);
    
    %% Check for artifacts
    if ~isempty(Artifacts.BPVoltage_Max)
        artifactCheck_max = Artifacts.BPVoltage_Max;
        artifactCheck_min = Artifacts.BPVoltage_Min;
        maxSignal = max(tmp_V_BP);
        minSignal = min(tmp_V_BP);
    else
        disp('Please define artifact threshold')
        keyboard
    end
    
    if max(tmp_V_BP) > Artifacts.BPVoltage_Max || min(tmp_V_BP) < Artifacts.BPVoltage_Min || max(tmp_HP_sqR_DS_smoothed) > Artifacts.HP_sqR_Max
        disp('Noise detected, skipping.')
    else
        
        if ShW.ShWDet == 1
            
            %[peakH,peakTime_DS, peakW, peakP]=findpeaks(tmp_HP_sqR_DS_smoothed,'MinPeakProminence',200,'WidthReference','halfprom'); %  P48
            %[peakH,peakTime_DS, peakW, peakP]=findpeaks(tmp_HP_sqR_DS_smoothed,'MinPeakProminence',300,'WidthReference','halfprom'); %  P48
            %[peakH,peakTime_DS, peakW, peakP]=findpeaks(tmp_HP_sqR_DS_smoothed,'MinPeakProminence',20,'WidthReference','halfprom'); %AB1
            [peakH,peakTime_DS, peakW, peakP]=findpeaks(tmp_HP_sqR_DS_smoothed,'MinPeakProminence',10,'WidthReference','halfprom'); %AB1
            %[peakH,peakTime_DS, peakW, peakP]=findpeaks(tmp_HP_sqR_DS_smoothed,'MinPeakProminence',100,'WidthReference','halfprom'); %AB1
        else
            if ShW.InverseDetection == 1
                peakDetectionData = tmp_LF_BP_DS;
                %figure; plot(tmp_LF_BP_DS)
                [peakH,peakTime_DS, peakW, peakP]=findpeaks(peakDetectionData,'MinPeakProminence',50,'WidthReference','halfprom'); % 180 = 900/5
            else
                peakDetectionData = neg_tmp_LF_BP_DS;
                %[peakH,peakTime_DS, peakW, peakP]=findpeaks(peakDetectionData,'MinPeakProminence',100,'WidthReference','halfprom'); % AC36
                %[peakH,peakTime_DS, peakW, peakP]=findpeaks(peakDetectionData,'MinPeakProminence',150,'WidthReference','halfprom'); % AD25
               %[peakH,peakTime_DS, peakW, peakP]=findpeaks(peakDetectionData,'MinPeakProminence',90,'WidthReference','halfprom'); % AD25
                [peakH,peakTime_DS, peakW, peakP]=findpeaks(peakDetectionData,'MinPeakProminence',40,'WidthReference','halfprom'); % AD25
                %[peakH,peakTime_DS, peakW, peakP]=findpeaks(peakDetectionData,'MinPeakProminence',50,'WidthReference','halfprom'); % AD25
               % [peakH,peakTime_DS, peakW, peakP]=findpeaks(peakDetectionData,'MinPeakProminence',200,'WidthReference','halfprom'); % 
               % [peakH,peakTime_DS, peakW, peakP]=findpeaks(peakDetectionData,'MinPeakProminence',250,'WidthReference','halfprom'); % 180 = 900/5
            end
            
            
        end
        
        %% Define timepoints
        timepoints_s = (t_ms + TOn(thisind)) /1000;
        timepoints_s_DS = (t_DS + TOn(thisind))/1000;
        
        %%
        peakTimeAbs_ms =  t_DS(peakTime_DS)'+ TOn(thisind);
        allRelPeaks_ms  = peakTimeAbs_ms - TOn(thisind);
        
        allRelPeaks_s = allRelPeaks_ms/1000;
        allRelPeaks_samp = round(allRelPeaks_s*Fs);
        
        %%
        figure(figH100);clf;
        
        subplot(5,1,1)
        plot(timepoints_s, tmpV); title( [titles.titleName_title ' | CSC-' num2str(REC.bestCSC) ' | Raw Voltage']);
        axis tight; ylim(Plotting.V_Ylim)
        
        subplot(5, 1, 2)
        plot(timepoints_s, tmp_V_BP); title( 'BP filtered voltage | 1-2000 Hz');
        axis tight; ylim(Plotting.BP_V_Ylim)
        
        subplot(5, 1, 3)
        plot(timepoints_s, tmp_LF_BP); title('LF BP | 1-4 Hz');
        axis tight;  ylim(Plotting.LFBP_Ylim)
        
        subplot(5, 1, 4)
        if ShW.InverseDetection == 1
            plot(timepoints_s_DS, tmp_LF_BP_DS); title('DS LF BP');
            axis tight; ylim(Plotting.NegLFBP_DS_Ylim)
        else
            plot(timepoints_s_DS, neg_tmp_LF_BP_DS); title('Neg DS LF BP');
            axis tight; ylim(Plotting.NegLFBP_DS_Ylim)
        end
        
        subplot(5, 1, 5)
        plot(timepoints_s_DS, tmp_HP_sqR_DS_smoothed); title('DS HP SqR');
        axis tight; ylim(Plotting.HP_sqR_DS_Ylim);
        xlabel('Time [s]')
        
        %%
        for q =1:numel(peakTime_DS)
            
            subplot(5,1, 5)
            hold on;
            plot(timepoints_s_DS(peakTime_DS(q)), tmp_HP_sqR_DS_smoothed(peakTime_DS(q)), 'rv');
            text(timepoints_s_DS(peakTime_DS(q)), tmp_HP_sqR_DS_smoothed(peakTime_DS(q))+(Plotting.HP_sqR_DS_Ylim(2)/10), num2str(cnt))
            
            subplot(5,1, 4)
            if ShW.InverseDetection == 1
                hold on;
                plot(timepoints_s_DS(peakTime_DS(q)), tmp_LF_BP_DS(peakTime_DS(q)), 'r*');
            else
                hold on;
                plot(timepoints_s_DS(peakTime_DS(q)), neg_tmp_LF_BP_DS(peakTime_DS(q)), 'r*');
            end
            
            subplot(5, 1, 1)
            hold on
            plot(timepoints_s(allRelPeaks_samp(q)), 0, 'r*')
            
            subplot(5, 1, 2)
            hold on
            plot(timepoints_s(allRelPeaks_samp(q)), 0, 'r*')
            
            templatePeaks.peakH(cnt) = peakH(q);
            templatePeaks.peakTime_DS(cnt) = peakTime_DS(q);
            templatePeaks.peakTimeAbs_ms(cnt) = peakTimeAbs_ms(q);
            templatePeaks.allRelPeaks_samp(cnt) = allRelPeaks_samp(q);
            
            templatePeaks.peakW(cnt) = peakW(q);
            templatePeaks.peakP(cnt) = peakP(q);
            
            cnt = cnt+1;
            
        end
        
        %%
        plot_filename = [PlotPath titles.titleName_save  '_TemplateShW-' num2str(i) '_' num2str(thisind)];
        plotpos = [0 0 30 20];
        export_to = set_export_file_format(4); % 2 = png, 1 = epsc
        printFig(figH100, plot_filename, plotpos, export_to)
        
        disp('')
    end
    
    if cnt > 2000
        disp('')
        break
    end
    
end

INFO.seg = seg;
INFO.TOn = TOn;
INFO.nCycles= nCycles;
INFO.randInd= randInd;
INFO.cheetahDir = DIR.cheetahDir;
INFO.csc = REC.bestCSC;


save_filename = [PlotPath 'TemplatePeaks.mat'];
save(save_filename, 'templatePeaks', 'INFO');


end