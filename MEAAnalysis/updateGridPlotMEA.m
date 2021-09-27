function [] = updateGridPlotMEA(spc, AllSWRDataOnChans, detectionInd, timepoints_s, plottingOrder)
Fs = 32000;
 
figure(spc); clf
disp('Updating plot....')
for k = 1:   size(AllSWRDataOnChans, 1)
    
    toPlot = AllSWRDataOnChans{k,detectionInd};
    
    [data_shift,nshifts] = shiftdim(toPlot',-2);
    
    % Filter
    
    fObj = filterData(Fs);
    
    fobj.filt.BP=filterData(Fs);
    fobj.filt.BP.highPassCutoff=1;
    fobj.filt.BP.lowPassCutoff=2000;
    fobj.filt.BP.filterDesign='butter';
    fobj.filt.BP=fobj.filt.BP.designBandPass;
    fobj.filt.BP.padding=true;
    
    fobj.filt.FL=filterData(Fs);
    fobj.filt.FL.lowPassPassCutoff=30;% this captures the LF pretty well for detection
    fobj.filt.FL.lowPassStopCutoff=40;
    fobj.filt.FL.attenuationInLowpass=20;
    fobj.filt.FL=fobj.filt.FL.designLowPass;
    fobj.filt.FL.padding=true;
    
    data_BP = (fobj.filt.BP.getFilteredData(data_shift));% 1-2000 BP
    data_FLBP = squeeze(fobj.filt.FL.getFilteredData(data_BP)); %30-40 LP
    
    
    %%
    
   
    
    if k == 1
        counter = 0;
        scnt = 2;
        
    elseif k == 7
        scnt = 9;
        counter = 1;
    elseif k == 31
        scnt = 34;
        counter = 2;
    elseif k == 54
        scnt = 58;
        counter = 3;
    else
        scnt = k+1+counter;
    end
    %scnt
    subplot(8, 8, scnt)
    
    %plot(timepoints_s, toPlot, 'k');
    plot(timepoints_s, data_FLBP, 'k');
    %plot(timepoints_s, squeeze(data_rippleBP), 'k');
    
    
    thisChan = num2str(plottingOrder(k));
    title(thisChan)
    grid('on')
    axis tight
    ylim([-40 20])
    %text(0, toPlot(1)+offset, thisChan)
    
end

textAnnotation = ['SWR Detection: ' num2str(detectionInd)];
% Create textbox
annotation(spc,'textbox', [0.5 0.95 0.36 0.03],'String',{textAnnotation}, 'LineStyle','none','FitBoxToText','off');

disp('Finished....')
end
