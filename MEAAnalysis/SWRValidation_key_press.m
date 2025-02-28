function[] = SWRValidation_key_press(src, evnt, spc)

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
            save_this_file(spc, current_file, list_of_names, wav_file_dir)

        case 'escape'
            %% Close the browser, save the files, and clear the data
            saving_dialog()

        case 'c' %cut
            
            [wav_x,~] = ginput(2);
            
            line([wav_x(1) wav_x(1)], [0 15000], 'color', 'y');
            hold on
            line([wav_x(2) wav_x(2)], [0 15000], 'color', 'y');
            disp('')
            hold off
            
              setappdata(spc, 'LCut', wav_x(1));
              setappdata(spc, 'RCut', wav_x(2));
              
        case 'q' %clear
            
            wb_plot_wav_spec(spc, current_file, list_of_names, how_many_files, wav_file_dir)
            
%         case 'd'
%             %% Change the wav directory
%             change_dir_prompt()

%         case 'g'
%             %% Flag as a 'good' file (ie, > 3 motifs)
%             move_this_file(1);

%         case 'b'
%             %% Flag as a 'bad' file (ie, < 3 motifs)
%             move_this_file(2);

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
    
    updateGridPlotMEA(spc, AllSWRDataOnChans, detectionInd, timepoints_s, plottingOrder)
   
    end
    
    
    
%% EOF