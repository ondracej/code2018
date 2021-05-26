function [] = wb_motif_query(spc, bird_name, this_file, good_or_bad)
% Part of the wav_browser.m, this file asks the user how many motifs are
% present in the file, records that information in a structure that is
% incremented with the counters sc_g and sc_b.

    %% Get motif count from the user
    prompt = {['How many motifs are present in ' this_file ' ?']};
    dlsg_title = 'Motif count';
    num_lines = 1;
    def = {''};
    motif_count = inputdlg(prompt,dlsg_title,num_lines,def);
    motif_count = cell2mat(motif_count);

    %% Save the information in a structure
    switch good_or_bad

        case 1 %good file
            sc_g = getappdata(spc, 'sc_g');
            good_file_list = getappdata(spc, 'good_file_list');

            % Save this as as structure
            good_file_list(sc_g).BirdName = bird_name;
            good_file_list(sc_g).FileName = this_file;
            good_file_list(sc_g).Motifs = motif_count;

            % increment counter and save parameters
            sc_g = sc_g + 1;

            setappdata(spc, 'sc_g', sc_g);
            setappdata(spc, 'good_file_list', good_file_list);

        case 2 % bad file
            sc_b = getappdata(spc, 'sc_b');
            bad_file_list = getappdata(spc, 'bad_file_list');

            bad_file_list(sc_b).BirdName = bird_name;
            bad_file_list(sc_b).FileName = this_file;
            bad_file_list(sc_b).Motifs = motif_count;

            % increment counter and save parameters
            sc_b = sc_b + 1;

            setappdata(spc, 'sc_b', sc_b);
            setappdata(spc, 'bad_file_list', bad_file_list);
    end
end

%% EOF
