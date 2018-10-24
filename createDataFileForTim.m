function [] = createDataFileForTim()
dbstop if error


spikesToLoad = '/storage/laur/Data_3/OndracekJanie/SleepTurtles/turtle_P48/12.04.2015/17-57-11_plots/FinalPeakDetection/Detectedpeaks.mat';
spks = load(spikesToLoad);
CSC_toPlot = 28;
deltaBandCutoff = 6; % 4;
RoiVarDir = '/storage/laur/Data_3/OndracekJanie/SleepTurtles/turtle_P48/12.04.2015/17-57-11_videos/roiVideos/EphysVidPlots/ROISaveVars.mat';
FigDir = '/storage/laur/Data_3/OndracekJanie/SleepTurtles/turtle_P48/12.04.2015/17-57-11_plots/';
cheetahDir = '/storage/laur/Data_3/OndracekJanie/SleepTurtles/turtle_P48/12.04.2015/17-57-11_cheetah/';
i=1;


duration_toplot = 1000*60*60;

r = load(RoiVarDir);
%INFO = r.INFO;
%doMatroxROIs= INFO.doMatroxROIs;

doMatroxROIs= 1;

allROIs = r.allROIs;
nonEmptyInds = find(cell2mat(cellfun(@(x) ~isempty(x), allROIs, 'uniformoutput', 0)));

q=nonEmptyInds;
a=diff(q);
b=find([a inf]>1);
c=diff([0 b]); %length of the sequences
d=cumsum(c); %endpoints of the sequences

%% Find all longer lengths
longLengthsInds = find(c >=200);

allLongLengthsEndpoints = d(longLengthsInds);

if sum(ismember(1, longLengthsInds)) == 1
    
    longLengthsInds(1) = []; % get rid of the 1 index
    allStartPoints = d(longLengthsInds-1)+1;
    allStartPoints = [ 1 allStartPoints ] ; %add the first index back%
    
else
    allStartPoints = d(longLengthsInds-1)+1;
end

lengths = allLongLengthsEndpoints-allStartPoints;

allStartPointsNotEmptyInds = nonEmptyInds(allStartPoints);
allEndPointsNotEmptyInds = nonEmptyInds(allLongLengthsEndpoints);

for j = 1:numel(allStartPointsNotEmptyInds)
    thisStartInd(j) = allStartPointsNotEmptyInds(j);
    thisStopInd(j) =allEndPointsNotEmptyInds(j);
end

if doMatroxROIs
    allROIStart = allROIs(thisStartInd);
    allROIEnd = allROIs(thisStopInd);
else
    
    allROIStart = r.allViewedFiles(thisStartInd);
    allROIEnd = r.allViewedFiles(thisStopInd);
end

disp('')


dash = '-';
dot = '.';

dataRecordingObj = NLRecording([cheetahDir]);

if doMatroxROIs
    [Trig_ms,chNumber,chName]=dataRecordingObj.getTrigger;
    
    MatroxTrigs_ms = Trig_ms{1, 10};
    MatroxTrigs_names = chName{1, 10};
end

dash = '-';
%% Sleep Object
obj=sleepAnalysis;
obj=obj.getExcelData('/storage/laur/Data_2/OndracekJanie/Sleep_Turtles/turtleSpreadSheet.xlsx',{'Exclude', 'CheetahFolderLinux'});
%obj=obj.getExcelData('/home/janie/Data/SleepData/EphysToAnnotate/turtleSpreadSheet.xlsx',{'Exclude', 'CheetahFolderLinux'});
obj=obj.getFilters(32000);
toAnalyze=obj.par.Num(cellfun(@(x) x==0,obj.par.Exclude));

if isunix % need to add a DirD to the cheetah dir for linux
    obj.par.CheetahFolder = obj.par.CheetahFolderLinux;
end

obj=obj.setCurrentRecording(toAnalyze(i));

Fs=dataRecordingObj.samplingFrequency(1);

for j = 1:numel(allROIStart)
    
    if doMatroxROIs
        
        searchString1long = allROIStart{j};
        searchStringdashInd = find(searchString1long == dash);
        searchString1 = searchString1long(1:searchStringdashInd-1);
        
        searchString2long = allROIEnd{j};
        searchStringdashInd = find(searchString2long == dash);
        searchString2 = searchString2long(searchStringdashInd+1:end);
        
        searchString_1 = ['Frame: ' searchString1  ';'];
        searchString_2 = ['Frame: ' searchString2  ';'];
        
        % Start Frame
        frameMatchsInds = cellfun(@(x) strfind(x, searchString_1), MatroxTrigs_names, 'uniformOutput', 0 );
        matroxStartInd = find(cellfun(@(x) ~isempty(x), frameMatchsInds)); % ins in event string for the Frame 0s
        matroxStartInd_ms = MatroxTrigs_ms(matroxStartInd);
        
        % Stop Frame
        frameMatchsInds = cellfun(@(x) strfind(x, searchString_2), MatroxTrigs_names, 'uniformOutput', 0 );
        matroxStopInd = find(cellfun(@(x) ~isempty(x), frameMatchsInds)); % ins in event string for the Frame 0s
        matroxStopInd_ms = MatroxTrigs_ms(matroxStopInd);
        
    else
        searchString1long = allROIStart{j};
        searchStringdashInd = find(searchString1long == dash);
        searchString1 = searchString1long(1:searchStringdashInd-1);
        
        searchString2long = allROIEnd{j};
        searchStringdashInd = find(searchString2long == dash);
        searchStringdotInd = find(searchString2long == dot);
        searchString2 = searchString2long(searchStringdashInd+1:searchStringdotInd-2);
        
        matroxStartInd_ms = str2double(searchString1)*1000;
        matroxStopInd_ms = str2double(searchString2)*1000;
        
    end
    
    thisDiff = matroxStopInd_ms-matroxStartInd_ms;
    startTime_hrs = (matroxStartInd_ms/1000)/(60*60);
    duration_hrs = (duration_toplot/1000)/(60*60);
    
    recINFO.recDur_Hr = duration_hrs;
    recINFO.startTime_Hr = startTime_hrs;
    recINFO.fs = Fs;
    recINFO.ds_factor = 128;
    recINFO.StartingFrame = searchString_1;
    recINFO.SegmentStart_ms = matroxStartInd_ms;
    
    %% Raw Data
    [raw_V,raw_t_ms] = dataRecordingObj.getData(CSC_toPlot,matroxStartInd_ms,duration_toplot);
    
    Time.t_ms = raw_t_ms;
    Time.t_s = raw_t_ms/1000;
    
    %Data.rawData.V = squeeze(raw_V);
    
    %% BP data
    
    [bp_V,bp_t_ms] =obj.filt.FJLB.getFilteredData(raw_V); %bandpassfilter
    
    %Data.bandPassed.V = squeeze(bp_V);
    
    %% Low Frequency
    
    [LF_BP, LF_BP_t_ms]=obj.filt.FL.getFilteredData(bp_V); % Low freq filter
    
    %Data.LF_bandPassed.V = squeeze(LF_BP);
    
    %% High Frequency
    
    [HF_BP, HF_BP_t_ms]=obj.filt.FH.getFilteredData(bp_V); % high freq filter
    
    %Data.HF_bandPassed.V = squeeze(HF_BP);
    
    %%
    
    %% subplot
    Time.roi = (1:Fs*60);
    
    figH105 = figure(105); clf
    subplot(4, 1, 1)
    plot(Time.t_s(Time.roi), squeeze(raw_V(Time.roi)))
    title('Raw Voltage')
    ylim([-1000 1000])
    %%
    subplot(4, 1, 2)
    plot(Time.t_s(Time.roi), squeeze(bp_V(Time.roi)))
    title('Band-Pass Voltage | 1-2000 Hz')
    ylim([-1000 1000])
    %%
    subplot(4, 1, 3)
    plot(Time.t_s(Time.roi), squeeze(LF_BP(Time.roi)))
    title('Low Frequency, Band-Pass Voltage | 1-4.5 Hz')
    ylim([-600 600])
    %%
    subplot(4, 1, 4)
    plot(Time.t_s(Time.roi), squeeze(HF_BP(Time.roi)))
    
    title('High Frequency, Band-Pass Voltage | 100-2000 Hz ')
    xlabel('Time [s]')
    ylim([-200 200])
    %% down sample
    
    [DS_raw_V,DS_t_ms] = obj.filt.F.getFilteredData(raw_V);
    
    [DS_bp_V,~] = obj.filt.F.getFilteredData(bp_V);
    
    [DS_LF_BP,~] = obj.filt.F.getFilteredData(LF_BP);
    
    [DS_HF_BP,~] = obj.filt.F.getFilteredData(HF_BP);
    
    Time.ds_t_ms = DS_t_ms;
    Time.ds_t_s = DS_t_ms/1000;
    
    Data.rawData.V_ds = squeeze(DS_raw_V);
    Data.bandPassed.V_ds = squeeze(DS_bp_V);
    Data.LF_bandPassed.V_ds = squeeze(DS_LF_BP);
    Data.HF_bandPassed.V_ds = squeeze(DS_HF_BP);
    
    %%
    Time.roi_ds = (1:15000);
    
    figH106 = figure(106); clf
    subplot(4, 1, 1)
    plot( Time.ds_t_s(Time.roi_ds), squeeze(DS_raw_V( Time.roi_ds)))
    title('DS Raw Voltage')
    ylim([-1000 1000])
    %%
    subplot(4, 1, 2)
    plot(Time.ds_t_s(Time.roi_ds), squeeze(DS_bp_V( Time.roi_ds)))
    title('DS Band-Pass Voltage | 1-2000 Hz')
    ylim([-1000 1000])
    %%
    subplot(4, 1, 3)
    plot(Time.ds_t_s(Time.roi_ds), squeeze(DS_LF_BP( Time.roi_ds)))
    title('DS Low Frequency, Band-Pass Voltage | 1-4.5 Hz')
    ylim([-600 600])
    %%
    subplot(4, 1, 4)
    plot(Time.ds_t_s(Time.roi_ds), squeeze(DS_HF_BP( Time.roi_ds)))
    
    title('DS High Frequency, Band-Pass Voltage | 100-2000 Hz ')
    xlabel('Time [s]')
    ylim([-20 20])
    
    
    T.roi_ds = Time.roi_ds;
    T.ds_t_ms = Time.ds_t_ms;
    T.ds_t_s =  Time.ds_t_s;
    
    %%
    fil_INFO.BP.hp_cutoff_hz = 1;
    fil_INFO.BP.lp_cutoff_hz = 2000;
    fil_INFO.LF_BP.hp_cutoff_hz = 1;
    fil_INFO.LF_BP.lp_cutoff_hz = 4.5;
    fil_INFO.HF_BP.hp_cutoff_hz = 100;
    fil_INFO.HF_BP.lp_cutoff_hz = 2000;
    fil_INFO.DS_factor = 128;
    
    
    %% Finding Peaks
    
    pTimes_ms = spks.Peaks.absolutePeakTimes_ms;
    
    all_pTimes_ms = [];
    %all_pHeights = [];
    %all_pWidth = [];
    
    for a = 1:numel(pTimes_ms)
        all_pTimes_ms = [all_pTimes_ms pTimes_ms{a}];
        %all_pHeights = [all_pHeights pHeights{j}];
        %all_pWidth = [all_pWidth pWidth{j};];
    end
    
    %op=A(A>l & A<U);    
    ShW.absTime_ms = all_pTimes_ms(all_pTimes_ms > matroxStartInd_ms & all_pTimes_ms < matroxStartInd_ms+duration_toplot);
    ShW.relTime_ms  =  ShW.absTime_ms-matroxStartInd_ms;
    
    %%
    saveDir = '/home/janie/Data/forTim/';
    saveName = [saveDir 'DataSeg_' num2str(j) '.mat'];
    save(saveName, 'Data', 'T', 'ShW', 'fil_INFO', 'recINFO', '-v7.3')
    
    %%
    figure(figH105)
    plot_filename = [saveDir 'DataSeg_' num2str(j) '-allSamples'];
    plotpos = [0 0 30 20];
    export_to = set_export_file_format(4); % 2 = png, 1 = epsc
    printFig(figH105, plot_filename, plotpos, export_to)
    
    figure(figH106)
    plot_filename = [saveDir 'DataSeg_' num2str(j) '-DS'];
    plotpos = [0 0 30 20];
    export_to = set_export_file_format(4); % 2 = png, 1 = epsc
    printFig(figH106, plot_filename, plotpos, export_to)
    
    
    
    
    
    %%
    disp('')
end


end
