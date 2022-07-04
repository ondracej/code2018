function[] = SWRValidation_key_press_obj(src, evnt, spc)

%% Unpack some variables for general use

detectionInd = getappdata(spc, 'detectionInd');
nDetections = getappdata(spc, 'nDetections');

%% Key Press Call Backs

switch evnt.Key
    
    case 'rightarrow'
        %% Move to the next file (to the right)
        move_left_or_right(spc, detectionInd, nDetections, 1)
        
    case 'leftarrow'
        %% Move to the previous file (to the left)
        move_left_or_right(spc, detectionInd, nDetections, 2)
        
    case 's'
        %% Re-Saves the current spectrogram file to the BOS folder
        save_this_file(spc)
        
    case 'd'
        %% Re-Saves the current spectrogram file to the BOS folder
        saveDetectionInd(spc)
    
    case 'r'
    removeDetectionInd(spc)
        
end

%% Nested functions %%

%% save_this_file


end

%% Non-nested functions %%
%% move_to_right
function move_left_or_right(spc, detectionInd, nDetections, left_or_right)

switch left_or_right
    case 1 % move right
        
        if detectionInd == nDetections
            disp('We have reached the last detection');
            setappdata(spc, 'detectionInd', nDetections);
            return
        end
        
        detectionInd = detectionInd + 1;
        
    case 2 % move left
        
        if detectionInd == 1
            disp('We have reached the first file');
            return
        end
        
        detectionInd = detectionInd - 1;
end

setappdata(spc, 'detectionInd', detectionInd);

% plot the update
replotGrid(spc)

end

function [] = replotGrid(spc)

detectionInd = getappdata(spc, 'detectionInd');
%setappdata(spc, 'nDetections', nDetections);
plottingOrder = getappdata(spc, 'plottingOrder');

timepoints_s = getappdata(spc, 'timepoints_s');
AllSWRDataOnChans = getappdata(spc, 'AllSWRDataOnChans');

updateGridPlotMEA_kp(spc)

end

function [] = saveDetectionInd(spc)

detectionInd = getappdata(spc, 'detectionInd');
allSavedDetectionInds = getappdata(spc, 'allSavedDetectionInds');
allSavedDetectionInds = [allSavedDetectionInds detectionInd];

setappdata(spc, 'allSavedDetectionInds', allSavedDetectionInds);

updateAnnotation(spc)

end

function [] = removeDetectionInd(spc)

detectionInd = getappdata(spc, 'detectionInd');
allSavedDetectionInds = getappdata(spc, 'allSavedDetectionInds');
bla = allSavedDetectionInds == detectionInd;

allSavedDetectionInds(bla) = [];

setappdata(spc, 'allSavedDetectionInds', allSavedDetectionInds);

updateAnnotation(spc)

end

function [] = updateAnnotation(spc)

detectionInd = getappdata(spc, 'detectionInd');
allSavedDetectionInds = getappdata(spc, 'allSavedDetectionInds');
nInds = getappdata(spc, 'nInds');

if ismember(detectionInd, allSavedDetectionInds)
    
    textAnnotation = ['SWR Detection: ' num2str(detectionInd) '/' num2str(nInds) ' | d-detection; s-save detection file-- Detected'];
else
    textAnnotation = ['SWR Detection: ' num2str(detectionInd) '/' num2str(nInds) ' | d-detection; s-save detection file' ];
end
% Create textbox
annotation(spc,'textbox', [0.5 0.95 0.36 0.03],'String',{textAnnotation}, 'LineStyle','none','FitBoxToText','off');



end

function [] = updateGridPlotMEA_kp(spc)

nInds = getappdata(spc, 'nInds');

AllSWRDataOnChans = getappdata(spc, 'AllSWRDataOnChans');
%timepoints_s = getappdata(spc, 'timepoints_s');
plottingOrder = getappdata(spc, 'plottingOrder');
detectionInd = getappdata(spc, 'detectionInd');
Fs = getappdata(spc, 'Fs');

figure(spc); clf
disp('Updating plot....')

DS_Factor = 20;

fObj = filterData(Fs);

fobj.filt.F2=filterData(Fs);
fobj.filt.F2.downSamplingFactor=DS_Factor; % original is 128 for 32k for sampling rate of 250
fobj.filt.F2=fobj.filt.F2.designDownSample;
fobj.filt.F2.padding=true;
fobj.filt.F2fs=fobj.filt.F2.filteredSamplingFrequency;

for k = 1:   size(AllSWRDataOnChans, 1)
    
    toPlot = AllSWRDataOnChans{k,detectionInd};
    
    [data_shift,nshifts] = shiftdim(toPlot',-2);
    
    % Filter
    [data_F2, t_s] = (fobj.filt.F2.getFilteredData(data_shift));% 1-2000 BP
    data_F2 = squeeze(data_F2);
    
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
    
    plot(t_s, data_F2, 'k');
    
    
    thisChan = num2str(plottingOrder(k));
    title(thisChan)
    grid('on')
    axis tight
    ylim([-40 20])
    %text(0, toPlot(1)+offset, thisChan)
    
end


allSavedDetectionInds = getappdata(spc, 'allSavedDetectionInds');

if ismember(detectionInd, allSavedDetectionInds)
    
    textAnnotation = ['SWR Detection: ' num2str(detectionInd) '/' num2str(nInds) '-- Detected'];
else
    textAnnotation = ['SWR Detection: ' num2str(detectionInd) '/' num2str(nInds)];
end
% Create textbox
annotation(spc,'textbox', [0.5 0.95 0.36 0.03],'String',{textAnnotation}, 'LineStyle','none','FitBoxToText','off');

disp('Finished....')
end


function [] = save_this_file(spc)

allSavedDetectionInds = getappdata(spc, 'allSavedDetectionInds');
AllSWRDataOnChans = getappdata(spc, 'AllSWRDataOnChans');
SWRDetectionDir = getappdata(spc, 'SWRDetectionDir');
Fs = getappdata(spc, 'Fs');

SWR_Detection_s = getappdata(spc, 'SWR_Detection_s');
SWR_Detection_fs = getappdata(spc, 'Detection_fs');

allValidated_SWR_Detection_s = SWR_Detection_s(:,allSavedDetectionInds);
allValidated_SWR_Detection_fs = SWR_Detection_fs(:,allSavedDetectionInds);

allValidatedSWRS = AllSWRDataOnChans(:,allSavedDetectionInds);
plottingOrder = getappdata(spc, 'plottingOrder');

name = getappdata(spc, 'name');
    
saveName = [SWRDetectionDir name  '_Validated_SWRs.mat'];
save(saveName, 'allValidatedSWRS', 'plottingOrder', 'Fs', 'allValidated_SWR_Detection_s', 'allValidated_SWR_Detection_fs', '-v7.3')
disp(['Saved Validated SWRs: ' saveName])
end



%% EOF