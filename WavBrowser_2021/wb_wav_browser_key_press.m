function[] = wb_wav_browser_key_press(src, evnt, spc)

    %% Unpack some variables for general use

    % Get directory information
    wav_file_dir = getappdata(spc, 'wav_file_dir');
    
    wav_file_dir_SaveDir  = getappdata(spc, 'wav_file_dir_SaveDir');
    
%     BOS_wav_dir = getappdata(spc, 'BOS_wav_dir');
%     BOS_folder_name = getappdata(spc, 'BOS_folder_name');
%     bad_wavs_dir = getappdata(spc, 'bad_wavs_dir');
%     good_wavs_dir = getappdata(spc, 'good_wavs_dir');
%     DirD = getappdata(spc, 'DirD');

    % Get bird/file parameters
    list_of_names = getappdata(spc, 'list_of_names');
    how_many_files = getappdata(spc, 'how_many_files');
    current_file = getappdata(spc, 'current_file');
%     bird_name = getappdata(spc, 'bird_name');

    %% Key Press Call Backs

    switch evnt.Key

        case 'rightarrow'
            %% Move to the next file (to the right)
            move_left_or_right(spc, current_file, list_of_names, 1, how_many_files)

        case 'leftarrow'
            %% Move to the previous file (to the left)
            move_left_or_right(spc, current_file, list_of_names, 2, how_many_files)

        case 's'
            %% Re-Saves the current spectrogram file to the BOS folder
            save_this_file(spc, current_file, list_of_names, wav_file_dir_SaveDir, wav_file_dir)

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

        case 'k' %squelch
              
           wb_squelch_and_plot_wav_spec(spc, current_file, list_of_names, how_many_files, wav_file_dir)
             
           

    end

%% Nested functions %%

    %% save_this_file
    function save_this_file(spc, current_file, list_of_names, wav_file_dir_SaveDir, wav_file_dir)

        
        
       % current_file = getappdata(spc, 'current_file');
       % list_of_names =  getappdata(spc, 'list_of_names');
        wavName = list_of_names{current_file};
       % wav_file_dir = getappdata(spc, wav_file_dir);
          
        LCut = getappdata(spc, 'LCut');
        RCut = getappdata(spc, 'RCut');
        
      
        
        wav_file = getappdata(spc, 'wav_file');
        fs = getappdata(spc, 'fs');
        %bits = getappdata(spc, 'bits');
        
        %% Filter file
         [b1, a1] = butter(2, [300 10000]/(fs/2));
         filWav = filtfilt(b1, a1, wav_file);
    
    
        LCut_samp = LCut*fs;
        
        duration_s = RCut-LCut;
        duration_samp = duration_s*fs;
        
        newWav = filWav(round(LCut_samp):round(LCut_samp+duration_samp));
        
        
        YY = resample(newWav, 44100, fs);
        
       %prompt = 'Please enter save name:';
       %dlgtitle = 'Saving';
       
        %answer = inputdlg(prompt,dlgtitle);
      
        %endingtxt = cell2mat(answer);
        
        newWavName = [wavName(1:end-4) '--M' '.wav'];
        
        %wavwrite(YY,44100, [wav_file_dir newWavName])
        
        %% Save filed to M Directory
        audiowrite([wav_file_dir_SaveDir newWavName], YY,44100)
        
       % audiowrite([wav_file_dir newWavName], YY,44100)
        %{
            % Make the BOS directory if it does not already exist
            if exist(BOS_wav_dir, 'dir') == 0
                mkdir(BOS_wav_dir);
                disp(['Created a  ' BOS_folder_name ' folder for this directory.'])
            end
       %}

        % write file name to the command window
        this_file = list_of_names{current_file};
        exact_file_name = [wav_file_dir this_file];
        disp(this_file);

        
        %  Save name
        %BOS_wav_dir = getappdata(spc, 'BOS_wav_dir');

        % We could squelch the file here...
      %  squelched_wav_file = squelch(wav_file,fs);

      %  copyfile(exact_file_name, BOS_wav_dir)
     
        %% In case we want to modify the wav file (ie, squelch)
        
        % Get info saved by the from wb_plot_wav_spec function
        %wav_file = getappdata(spc, 'wav_file');
        %fs = getappdata(spc, 'fs');
        %bits = getappdata(spc, 'bits');
        
        %save_name = [BOS_wav_dir this_file];
        
        %wavwrite(wav_file, fs, bits, save_name)
        
    end


    %% move_this_file
    %{
    function move_this_file(good_or_bad)

        if isempty(list_of_names)
            disp('This directory is currently empty. Please change the directory (d).')
            return
        end

        this_file = list_of_names{current_file};
        this_file_to_move = [wav_file_dir this_file];
        
        % Is the file good (>3 motifs) or bad (< 3 motifs).
        switch good_or_bad

            case 1
                this_dir = [good_wavs_dir DirD bird_name DirD];

                    % Check to see if this directory exists
                    if exist(this_dir, 'dir') == 0
                        mkdir(this_dir);
                    end

                wb_motif_query(spc, bird_name, this_file, good_or_bad)

            case 2
                this_dir = [bad_wavs_dir DirD bird_name DirD];

                    % Check to see if this directory exists
                    if exist(this_dir, 'dir') == 0
                        mkdir(this_dir);
                    end

                wb_motif_query(spc, bird_name, this_file, good_or_bad)
        end

        [status,message] = movefile(this_file_to_move, this_dir);

            if status == 0
                warndlg(['Could not move the file! The error message is:' message])
            end

        finish_moving();
    end
    %}

    %% finish_moving
 %{
    function finish_moving()

        this_file = getappdata(spc, 'this_file');

        list_of_names = list_of_names(~strcmp(list_of_names, this_file));
        how_many_files = size(list_of_names, 1);
        setappdata(spc, 'list_of_names', list_of_names);
        setappdata(spc, 'how_many_files', how_many_files);

        % Update the number of current files
        current_file = current_file - 1;

            % Warn the user that there are no more files in the directory
            if current_file == 0 && how_many_files == 0
                disp('This directory is currently empty. Please change the directory (d).')
                return
            end

        setappdata(spc, 'current_file', current_file);

        % Move to the next file automatically
        move_left_or_right(spc, current_file, list_of_names, 1, how_many_files)

    end
%}
    %% saving_dialog
%{
    function saving_dialog()

    
    end

  %}      
        %{
        
        % Ask the user if he/she wants to save the file
        button = questdlg('Do you want to save the file lists?', 'Save file list?', 'yes', 'no', 'no');

            if strcmp(button, 'no') == 1
                disp('Did not save file.');
                close(spc);
                clear all;
                return;

            elseif strcmp(button, 'no') == 0

                good_file_list = getappdata(spc, 'good_file_list');
                bad_file_list = getappdata(spc, 'bad_file_list');

                good_list_save_name = [good_wavs_dir DirD 'For_playback_list.mat'];
                bad_list_save_name = [bad_wavs_dir DirD 'Not_for_playback_list.mat'];

                    %% "For_playback" file
                    if exist(good_list_save_name, 'file') ~= 0
                        
                        existing_good_file_list = load(good_list_save_name);                        
                        new_good_file_list = [existing_good_file_list.good_file_list good_file_list];
                        
                        save(good_list_save_name, 'new_good_file_list');
                        disp('Appended currently existing For_playback file.');
                    else
                        save(good_list_save_name, 'good_file_list')
                    end

                    %% "Not_for_playback" file
                    if exist(bad_list_save_name, 'file') ~= 0
                        
                        existing_bad_file_list = load(bad_list_save_name);
                        new_bad_file_list = [existing_bad_file_list.bad_file_list bad_file_list];
                        
                        save(bad_list_save_name, 'new_bad_file_list', '-append');
                        disp('Appended currently existing Not_for_playback file.');
                    else
                        save(bad_list_save_name, 'bad_file_list')
                    end

                % close the window and clear data
                close(spc);
                clear all;
            end
    end
%}
    %% change_dir_prompt

    %{
    function change_dir_prompt()

        % Ask the user for the new directory
        prompt = {'Please input the new wav file directory:'};
        dlsg_title = 'New wav file directory';
        num_lines = 1;
        def = {''};
        wav_file_dir = inputdlg(prompt,dlsg_title,num_lines,def);
        wav_file_dir = [cell2mat(wav_file_dir) DirD];

        % Define the new bird name
        dirseparators = (wav_file_dir == DirD);
        dirseparators = find(dirseparators == 1, 2, 'last');
        bird_name = wav_file_dir(dirseparators(1) + 1 : dirseparators(2) - 1);

        % Set this new information
        setappdata(spc, 'bird_name', bird_name);
        setappdata(spc, 'wav_file_dir', wav_file_dir);

        % Get info about the wav files in the new directory
        wb_get_wav_info_from_dir(spc, wav_file_dir, DirD)

    end
    %}
    
end

%% Non-nested functions %%

% 
% function squelchWav(spc, current_file, list_of_names, wav_file_dir_SaveDir, wav_file_dir)
% 
%         squelched_wav_file = squelch(wav_file,fs);
%         
%         
%     end
    
    
    %% move_to_right
    function move_left_or_right(spc, current_file, list_of_names, left_or_right, how_many_files)

    wav_file_dir = getappdata(spc, 'wav_file_dir');

        switch left_or_right
            case 1 % move right

                if current_file == how_many_files
                    disp('We have reached the last file');
                    setappdata(spc, 'current_file', current_file);
                    return
                end

                current_file = current_file + 1;

            case 2 % move left

                if current_file == 1
                    disp('We have reached the first file');
                    return
                end

                current_file = current_file - 1;
        end

    % update this new current_file value
    setappdata(spc, 'current_file', current_file);

    % plot the spectrogram
    wb_plot_wav_spec(spc, current_file, list_of_names, how_many_files, wav_file_dir)
    
    end

%% EOF