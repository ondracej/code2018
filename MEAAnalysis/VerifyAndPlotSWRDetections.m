function [] = VerifyAndPlotSWRDetections(detectionFile)

if nargin <1
    detectionFile = 'Z:\JanieData\JessicaMeaData\20210809\SWR-Detection\Detections.mat';
end

disp('Loading detection file...')

tic
load(detectionFile);
toc

Fs = 32000;

WinSizeL = 1*Fs;

AllSWRDataOnChans = D.AllSWRDataOnChans;
nDetections = size(AllSWRDataOnChans, 2);
timepoints_s = (1:1:WinSizeL*2+1)/Fs;
plottingOrder = D.plottingOrder;

%%
spc = figure (200);clf %grid

%% Key Press Function
set(spc, 'KeyPressFcn', {@SWRValidation_key_press, spc});
%%

detectionInd = 1;
setappdata(spc, 'detectionInd', detectionInd);
setappdata(spc, 'nDetections', nDetections);
setappdata(spc, 'plottingOrder', plottingOrder);

setappdata(spc, 'timepoints_s', timepoints_s);
setappdata(spc, 'AllSWRDataOnChans', AllSWRDataOnChans);

updateGridPlotMEA(spc, AllSWRDataOnChans, detectionInd, timepoints_s, plottingOrder)

% 
% for j = detectionInd
%     
%     hold on
%     
%     for k = 1:   size(AllSWRDataOnChans, 1)
%         
%         toPlot = AllSWRDataOnChans{k,j};
%         
%         [data_shift,nshifts] = shiftdim(toPlot',-2);
%         
%         % Sharp wave
%         data_BP = (fobj.filt.BP.getFilteredData(data_shift));% 1-2000 BP
%         data_FLBP = squeeze(fobj.filt.FL.getFilteredData(data_BP)); %30-40 LP
%         
%         %{
%         figure(figH)
%         subplot(1, 3, 1)
%         hold on
%         plot(timepoints_s, toPlot+offset, 'k');
%         thisChan = num2str(plottingOrder(k));
%         text(0, toPlot(1)+offset, thisChan)
%         
%         %%
%        
%         
%         subplot(1, 3, 2)
%         hold on
%         plot(timepoints_s, data_FLBP+offsetFil, 'k');
%         % text(0, toPlot(1)+offset, thisChan)
%         
%         subplot(1, 3, 3)
%         hold on
%         data_rippleBP = squeeze(fobj.filt.Ripple.getFilteredData(data_BP)); %80-300 BP
%         
%         plot(timepoints_s, squeeze(data_rippleBP)+offsetFil, 'k');
%         
%         offset = offset+60;
%         offsetFil = offsetFil+30;
%         %}
%         
%         %%
%         
%         
%         figure(spc)
%         
%         if k == 1
%             counter = 0;
%             scnt = 2;
%             
%         elseif k == 7
%             scnt = 9;
%             counter = 1;
%         elseif k == 31
%             scnt = 34;
%             counter = 2;
%         elseif k == 54
%             scnt = 58;
%             counter = 3;
%         else
%             scnt = k+1+counter;
%         end
%         %scnt
%         subplot(8, 8, scnt)
%         
%         %plot(timepoints_s, toPlot, 'k');
%         plot(timepoints_s, data_FLBP, 'k');
%         %plot(timepoints_s, squeeze(data_rippleBP), 'k');
%         
%         
%         thisChan = num2str(plottingOrder(k));
%         title(thisChan)
%         grid('on')
%         axis tight
%         ylim([-40 20])
%         %text(0, toPlot(1)+offset, thisChan)
%         
%     end
%     
%      textAnnotation = ['SWR Detection: ' num2str(detectionInd)];
%     % Create textbox
%     annotation(spc,'textbox', [0.5 0.95 0.36 0.03],'String',{textAnnotation}, 'LineStyle','none','FitBoxToText','off');
%     
%     
    
    
    %{
    figure(figH)
    subplot(1, 3, 1)
    title('Raw')
    axis tight
    set(gca, 'xtick', xticks)
    set(gca, 'xticklabel', xlabs)
    ylim([-50 3500])
    line([1 1], [-50 3500],  'color', 'k', 'linestyle', ':')
    xlabel('Time (s)')
    
    subplot(1, 3, 2)
    title('Low Pass: 30-40 Hz')
    axis tight
    set(gca, 'xtick', xticks)
    set(gca, 'xticklabel', xlabs)
    ylim([-30 1750])
    line([1 1], [-30 1750], 'color', 'k', 'linestyle', ':')
    xlabel('Time (s)')
    
    subplot(1, 3, 3)
    title('Ripple: 80-300 Hz')
    axis tight
    set(gca, 'xtick', xticks)
    set(gca, 'xticklabel', xlabs)
    ylim([-30 1750])
    line([1 1], [-30 1750], 'color', 'k', 'linestyle', ':')
    xlabel('Time (s)')
    
    textAnnotation = ['File: ' name ' | SWR Detection: ' num2str(round(SWR_Detection_s(k,j), 2)) 's' ];
    % Create textbox
    annotation(figH,'textbox', [0.01 0.95 0.36 0.03],'String',{textAnnotation}, 'LineStyle','none','FitBoxToText','off');
    
    saveName = [plotDir name 'SWR-stack' sprintf('%03d',j)];
    figure(figH)
    plotpos = [0 0 50 50];
    
    print_in_A4(0, saveName, '-djpeg', 0, plotpos);
    
    %}
%     figure(figHH)
%     
%    
%     saveName = [plotDir name 'SWR-grid' sprintf('%03d',j)];
%     figure(figHH)
%     plotpos = [0 0 50 50];
%     
%     print_in_A4(0, saveName, '-djpeg', 0, plotpos);
%     
end

