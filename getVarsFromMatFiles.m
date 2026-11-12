%% Directory containing .mat files
matDir = 'Y:\hameddata2\EEG-LFP-songLearning\JaniesAnalysis\ALL_PLOTS\w027\All_LFP_dy\BurstDetection\';

%% Output text file
outputFile = fullfile(matDir, 'matfile_inventory.txt');

% Find all .mat files
matFiles = dir(fullfile(matDir, '*.mat'));

% Open output file
fid = fopen(outputFile, 'w');

if fid == -1
    error('Could not open output file for writing.');
end

fprintf(fid, 'MAT File Inventory\n');
fprintf(fid, 'Generated on %s\n\n', datestr(now));

% Loop through each MAT file
for k = 1:numel(matFiles)

    filePath = fullfile(matFiles(k).folder, matFiles(k).name);

    fprintf('Processing %s...\n', matFiles(k).name);
    fprintf(fid, '============================================================\n');
    fprintf(fid, 'File: %s\n', filePath);
    fprintf(fid, '============================================================\n');

    try
        % Open MAT file using matfile
        matObj = matfile(filePath);

        % Get variable information
        vars = whos(matObj);

        if isempty(vars)
            fprintf(fid, 'No variables found.\n\n');
            continue;
        end

        % Print table header
        fprintf(fid, '%-25s %-15s %-12s %-12s\n', ...
            'Name', 'Size', 'Class', 'Bytes');
        fprintf(fid, '%s\n', repmat('-',1,70));

        % Print each variable
        for i = 1:numel(vars)

            sz = sprintf('%dx', vars(i).size);
            sz = sz(1:end-1);   % Remove trailing 'x'

            fprintf(fid, '%-25s %-15s %-12s %-12d\n', ...
                vars(i).name, ...
                sz, ...
                vars(i).class, ...
                vars(i).bytes);
        end

        fprintf(fid, '\n');

    catch ME
        fprintf(fid, 'ERROR reading file:\n%s\n\n', ME.message);
    end

end

fclose(fid);

fprintf('Finished.\nResults written to:\n%s\n', outputFile);