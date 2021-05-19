function [] = wb_plot_wav_spec(spc, current_file, list_of_names, how_many_files, wav_file_dir)
% part of the wave_browser.m, this file plots and updates the spectrogram
% of the selected .wav file

    %% Get spectragram scale
    spec_scale = getappdata(spc, 'spec_scale');

        %% If there are no more files in the directory, we dont need to plot
        if isempty(list_of_names)
            disp('This directory is currently empty. Please change the directory (d).')
            return
        end

    %% Load the file and plot the spectrogram

    this_file = list_of_names{current_file};
    file_to_load = [wav_file_dir this_file];

    % Read in the wav file and save the parameters
    [wav_file,fs, bits] = wavread(file_to_load);
    setappdata(spc, 'wav_file', wav_file);
    setappdata(spc, 'fs', fs);
    setappdata(spc, 'bits', bits);

    setappdata(spc, 'this_file', this_file);

    % Plot the spectrogram
    specgram1((wav_file/spec_scale),512,fs,400,360);
    ylim([0 15000])
    xlabel('Time (s)', 'fontsize', 12)
    ylabel('Frequency (Hz)', 'fontsize', 12)
    
    underscore = '_';
    bla = find(this_file == underscore);
    this_file(bla) = '-';
    
    title(['Spectrogram for ' this_file ' | File ' num2str(current_file) ' of ' num2str(how_many_files) ], 'fontsize', 14)

end

%% EOF