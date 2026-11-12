function result = realFrameRate(folders, varargin)
%REALFRAMERATE  Estimate the real frame rate of a TIFF image sequence that
%contains duplicated frames.
%
%   result = realFrameRate(folder)
%   result = realFrameRate({folder1, folder2, ...})      % several sessions
%   result = realFrameRate(folder, 'Name', Value, ...)
%
%   Each TIFF is compared with the frame before it. A frame whose pixels are
%   identical to the previous frame is a DUPLICATE; otherwise it is a NEW
%   frame. The real frame rate is estimated from the "Date modified"
%   timestamps of the NEW frames only.
%
%   Timestamps are read with millisecond precision from the file system
%   ("Date modified" in Windows Explorer). Note: zipping or copying with
%   some tools can round these to whole seconds or overwrite them; the
%   function warns if the timestamps look rounded.
%
%   The sample may consist of several blocks of consecutive frames, e.g.
%   50 frames from the start and 50 from the end of a long recording. The
%   files are split into segments wherever the gap between files is large
%   (> GapSeconds, or > 20x the typical file interval), and rates are
%   estimated within segments. If the file names contain the frame number,
%   the long span between blocks additionally gives a very precise
%   file-writing rate (.fpsFromNames), which checks the 10 fps assumption.
%
%   Options
%     'Pattern'     file pattern(s), char or cell array
%                   (default {'*.tif','*.tiff','*.jpg','*.jpeg'}, any case)
%     'Tolerance'   max. absolute pixel difference still counted as a
%                   duplicate; 0 = must be identical  (default 0)
%     'SortBy'      'name' (natural sort by the number in the file name)
%                   or 'time' (by timestamp)          (default 'name')
%     'NominalFps'  frame rate the camera was set to  (default 10)
%     'Plot'        show diagnostic figure            (default true)
%     'GapSeconds'  min. gap that starts a new segment (default 10)
%     'WikiFormat'  print a summary table for pasting into a wiki and copy
%                   it to the clipboard: 'confluence' (default), 'markdown',
%                   'mediawiki', 'html' (opens a table in the browser to
%                   copy and paste; most reliable for Confluence) or 'none'
%
%   Output (struct; for several folders, one row per folder plus a table
%   in result(1).summaryTable if tables are available)
%     .fps            1 / slope of a straight-line fit of new-frame timestamp
%                     vs. new-frame number (common slope across segments)
%     .fpsCI95        95% confidence interval of .fps
%     .fpsPerSegment  same, separately for each segment (start vs end)
%     .fpsMedian      1 / median interval between new frames
%     .fpsFromRatio   NominalFps * fraction of new frames (complete runs)
%     .fpsFromNames   file rate from frame numbers in names * new fraction
%     .fileRateFromNames  files written per second over the whole span
%     .fpsAcquired    rate at which files were written (incl. duplicates)
%     .nSegments      number of contiguous blocks found
%     .durationHours  time from first to last sampled file (recording
%                     duration if the sample spans start and end)
%     .nFrames, .nNew, .nDuplicates, .dupFraction
%     .runLengths     how many files each new image occupied (1 = no copy)
%     .frames         per-file table/struct: name, time, isNew, maxDiff
%
%   Example
%     r = realFrameRate('D:\tadpoles\session3\sample100');
%     fprintf('Real frame rate: %.3f fps\n', r.fps);

    p = inputParser;
    p.addParameter('Pattern', {'*.tif', '*.tiff', '*.jpg', '*.jpeg'});
    p.addParameter('Tolerance', 0, @(x) isnumeric(x) && isscalar(x) && x >= 0);
    p.addParameter('SortBy', 'name', @(x) any(strcmpi(x, {'name', 'time'})));
    p.addParameter('NominalFps', 10, @(x) isnumeric(x) && isscalar(x) && x > 0);
    p.addParameter('Plot', true);
    p.addParameter('GapSeconds', 10, @(x) isnumeric(x) && isscalar(x) && x > 0);
    p.addParameter('WikiFormat', 'confluence', @(x) any(strcmpi(x, ...
                   {'markdown', 'confluence', 'mediawiki', 'html', 'none'})));
    p.parse(varargin{:});
    opt = p.Results;

    if ischar(folders) || (isstring(folders) && isscalar(folders))
        folders = {char(folders)};
    elseif isstring(folders)
        folders = cellstr(folders);
    end

    for k = 1:numel(folders)
        r = analyseFolder(folders{k}, opt);
        if k == 1
            result = r;
        else
            result(k) = r; %#ok<AGROW>
        end
    end

    if numel(result) > 1
        fprintf('\n===== Summary =====\n');
        fprintf('%-36s %6s %4s %4s %22s %8s %8s %6s\n', 'Folder', 'Frames', 'New', ...
                'Segs', 'Real fps [95% CI]', 'Ratio', 'FileNum', 'Dup %');
        for k = 1:numel(result)
            fprintf('%-36s %6d %4d %4d %7.3f [%6.3f-%6.3f] %8.3f %8.3f %6.1f\n', ...
                    shorten(folderLabel(result(k).folder), 36), result(k).nFrames, ...
                    result(k).nNew, result(k).nSegments, result(k).fps, ...
                    result(k).fpsCI95(1), result(k).fpsCI95(2), ...
                    result(k).fpsFromRatio, result(k).fpsFromNames, ...
                    100 * result(k).dupFraction);
        end
        if exist('table', 'file') || exist('table', 'builtin')
            try
                T = struct2table(rmfield(result, {'frames', 'runLengths', 'fpsCI95', ...
                                                  'fpsPerSegment'}));
                T.ciLow  = arrayfun(@(r) r.fpsCI95(1), result(:));
                T.ciHigh = arrayfun(@(r) r.fpsCI95(2), result(:));
                result(1).summaryTable = T;
            catch
            end
        end
    end

    if strcmpi(opt.WikiFormat, 'html')
        % Rendered table in the web browser: copy it from there and paste
        % into Confluence; it arrives as a real table.
        txt = wikiTable(result, opt);
        f = fullfile(tempdir, 'frameRateSummary.html');
        fid = fopen(f, 'w', 'n', 'UTF-8'); fwrite(fid, txt, 'char'); fclose(fid);
        fprintf('\nSummary table written to %s\n', f);
        try
            web(['file:///', strrep(f, '\', '/')], '-browser');
            fprintf('Opened in your browser: select the table, copy, paste into Confluence.\n');
        catch
            fprintf('Open that file in a browser, copy the table, paste into Confluence.\n');
        end
        result(1).wikiTable = txt;
    elseif ~strcmpi(opt.WikiFormat, 'none')
        txt = wikiTable(result, opt);
        fprintf('\n===== Wiki table (%s) =====\n%s\n', lower(opt.WikiFormat), txt);
        try
            clipboard('copy', txt);
            fprintf('(copied to clipboard)\n');
        catch
        end
        result(1).wikiTable = txt;
    end
end


% -------------------------------------------------------------------------
function txt = wikiTable(result, opt)
% Summary table as Markdown, Confluence or MediaWiki markup.
    hdr = {'Session', 'Duration (h)', 'Files', 'New', 'Dup %', 'Real fps (ratio)', ...
           'Real fps (file numbers)', 'Avg files/s', ...
           sprintf('Time vs %g files/s', opt.NominalFps), 'Blocks'};
    rows = cell(numel(result), numel(hdr));
    for k = 1:numel(result)
        r = result(k);
        if isfinite(r.fileRateFromNames)
            fr    = sprintf('%.2f', r.fileRateFromNames);
            d     = round(100 * (opt.NominalFps / r.fileRateFromNames - 1));
            if d == 0, drift = '0%'; else, drift = sprintf('%+d%%', d); end
            fn    = sprintf('%.3f', r.fpsFromNames);
        else
            fr = 'n/a'; drift = 'n/a'; fn = 'n/a';
        end
        if isfinite(r.durationHours)
            dur = sprintf('%.2f', r.durationHours);
        else
            dur = 'n/a';
        end
        rows(k, :) = {sessionLabel(r.folder), dur, sprintf('%d', r.nFrames), ...
                      sprintf('%d', r.nNew), sprintf('%.1f', 100 * r.dupFraction), ...
                      sprintf('%.3f', r.fpsFromRatio), fn, fr, drift, ...
                      sprintf('%d', r.nSegments)};
    end

    nl = sprintf('\n');
    switch lower(opt.WikiFormat)
        case 'markdown'
            txt = ['| ', strjoin(hdr, ' | '), ' |', nl, ...
                   '|', repmat('---|', 1, numel(hdr)), nl];
            for k = 1:size(rows, 1)
                txt = [txt, '| ', strjoin(rows(k, :), ' | '), ' |', nl]; %#ok<AGROW>
            end
        case 'confluence'
            txt = ['|| ', strjoin(hdr, ' || '), ' ||', nl];
            for k = 1:size(rows, 1)
                txt = [txt, '| ', strjoin(rows(k, :), ' | '), ' |', nl]; %#ok<AGROW>
            end
        case 'mediawiki'
            txt = ['{| class="wikitable sortable"', nl, '! ', strjoin(hdr, ' !! '), nl];
            for k = 1:size(rows, 1)
                txt = [txt, '|-', nl, '| ', strjoin(rows(k, :), ' || '), nl]; %#ok<AGROW>
            end
            txt = [txt, '|}', nl];
        case 'html'
            esc = @(s) strrep(strrep(strrep(s, '&', '&amp;'), '<', '&lt;'), '>', '&gt;');
            txt = ['<!DOCTYPE html><html><head><meta charset="utf-8">', ...
                   '<title>Frame rate summary</title><style>', ...
                   'body{font-family:sans-serif;margin:24px}', ...
                   'table{border-collapse:collapse}', ...
                   'th,td{border:1px solid #999;padding:4px 8px;text-align:right}', ...
                   'th{background:#eee}td:first-child,th:first-child{text-align:left}', ...
                   '</style></head><body>', nl, ...
                   '<p>Select the table (or Ctrl+A), copy, and paste into Confluence.</p>', nl, ...
                   '<table><tr><th>', strjoin(cellfun(esc, hdr, 'UniformOutput', false), ...
                   '</th><th>'), '</th></tr>', nl];
            for k = 1:size(rows, 1)
                txt = [txt, '<tr><td>', strjoin(cellfun(esc, rows(k, :), ...
                       'UniformOutput', false), '</td><td>'), '</td></tr>', nl]; %#ok<AGROW>
            end
            txt = [txt, '</table></body></html>', nl];
    end
end


function s = sessionLabel(folder)
% Session folder name; skips a trailing generic 'Raw' folder.
    parts = regexp(folder, '[\\/]', 'split');
    parts = parts(~cellfun(@isempty, parts));
    s = parts{end};
    if numel(parts) > 1 && any(strcmpi(s, {'raw', 'tif', 'tiff', 'frames', 'images'}))
        s = parts{end - 1};
    end
end


% -------------------------------------------------------------------------
function r = analyseFolder(folder, opt)

    files = listImages(folder, opt.Pattern);
    n = numel(files);
    if n < 3
        pats = opt.Pattern; if ischar(pats), pats = {pats}; end
        error('realFrameRate:tooFew', 'Found only %d files matching %s in %s', ...
              n, strjoin(pats, ', '), folder);
    end
    exts = unique(lower(regexprep({files.name}, '^.*\.', '')));
    if numel(exts) > 1
        warning('realFrameRate:mixed', ['%s contains several image types (%s); they are ', ...
                'treated as one sequence.'], folder, strjoin(exts, ', '));
    end
    isJpeg = any(ismember(exts, {'jpg', 'jpeg'}));
    names = {files.name}';
    paths = fullfile(folder, names);

    % ---- timestamps (seconds), millisecond precision if possible --------
    t = fileTimes(paths, files);

    % ---- order ---------------------------------------------------------
    if strcmpi(opt.SortBy, 'name')
        order = naturalOrder(names);
    else
        [~, order] = sort(t);
    end
    names = names(order); paths = paths(order); t = t(order);
    if any(diff(t) < 0)
        warning('realFrameRate:order', ...
            ['%s: timestamps are not increasing in file-name order (%d times). ', ...
             'Check the file naming, or use ''SortBy'',''time''.'], ...
             folder, sum(diff(t) < 0));
    end

    % ---- duplicate detection --------------------------------------------
    % Unreadable files (corrupt / truncated) are skipped and listed; the
    % next readable file is compared with the last readable one.
    isNew   = true(n, 1);
    maxDiff = nan(n, 1);
    bad     = false(n, 1);
    prev    = [];
    for i = 1:n
        try
            cur = imread(paths{i});
        catch err
            bad(i) = true;
            fprintf('  SKIPPED unreadable file %s (%s)\n', names{i}, ...
                    strtrim(regexprep(err.message, '\s+', ' ')));
            continue
        end
        if isempty(prev)
            prev = cur;            % first readable file: new by definition
            continue
        end
        if ~isequal(size(cur), size(prev))
            maxDiff(i) = Inf;
        elseif opt.Tolerance == 0
            if isequal(cur, prev)
                maxDiff(i) = 0;
            else
                maxDiff(i) = max(abs(double(cur(:)) - double(prev(:))));
            end
        else
            maxDiff(i) = max(abs(double(cur(:)) - double(prev(:))));
        end
        isNew(i) = maxDiff(i) > opt.Tolerance;
        prev = cur;
    end
    if any(bad)
        warning('realFrameRate:unreadable', '%s: %d of %d files could not be read and were skipped.', ...
                folder, sum(bad), n);
        names = names(~bad); paths = paths(~bad); t = t(~bad);
        isNew = isNew(~bad); maxDiff = maxDiff(~bad);
        n = numel(names);
        if n < 3
            error('realFrameRate:tooFew', 'Fewer than 3 readable images in %s', folder);
        end
    end

    % ---- split into contiguous segments at large time gaps ---------------
    % (e.g. frames sampled at the start and at the end of a long recording)
    tRel = t - t(1);
    dt = diff(tRel);
    gapThresh = max(opt.GapSeconds, 20 * median(dt(dt > 0)));
    if isempty(gapThresh) || ~isfinite(gapThresh), gapThresh = opt.GapSeconds; end
    segment = [1; 1 + cumsum(dt > gapThresh)];
    nSeg = max(segment);

    % a frame is only compared with its predecessor inside the same segment
    isNew([1; find(diff(segment)) + 1]) = true;

    tNew   = tRel(isNew);
    segNew = segment(isNew);
    nNew   = numel(tNew);
    runLengths = diff([find(isNew); n + 1]);

    r.folder       = folder;
    r.nFrames      = n;
    r.nNew         = nNew;
    r.nDuplicates  = n - nNew;
    r.dupFraction  = (n - nNew) / n;
    r.nSegments    = nSeg;
    % Fraction of files that carry a new image, counted only over COMPLETE
    % runs (first to last real change in each segment). The first frame of
    % each segment is "new" only because nothing precedes it, and the runs
    % at the segment edges are cut off; counting them biases short samples.
    % use frame numbers from the names (robust to skipped/missing files)
    pos = lastNumbers(names);
    if any(~isfinite(pos)) || numel(unique(pos)) < numel(pos)
        pos = (1:n)';
    end
    nRuns = 0; nSpan = 0;
    for s = 1:nSeg
        idx = find(segment == s);
        ch = idx(isNew(idx));
        ch = ch(ch ~= idx(1));            % real changes only
        if numel(ch) >= 2
            nRuns = nRuns + numel(ch) - 1;
            nSpan = nSpan + pos(ch(end)) - pos(ch(1));
        end
    end
    if nSpan > 0
        r.newFraction = nRuns / nSpan;
    else
        r.newFraction = nNew / n;
    end
    r.fpsFromRatio = opt.NominalFps * r.newFraction;

    % ---- real fps: common slope across segments (separate intercepts) -----
    [r.fps, r.fpsCI95] = pooledRate(tNew, segNew);
    % files written per second inside segments (incl. duplicates)
    [r.fpsAcquired, ~] = pooledRate(tRel, segment);

    % per-segment real fps (to compare beginning vs end of the recording)
    r.fpsPerSegment = nan(1, nSeg);
    for s = 1:nSeg
        r.fpsPerSegment(s) = pooledRate(tNew(segNew == s), ones(sum(segNew == s), 1));
    end
    dNew = diff(tNew); dNew = dNew(diff(segNew) == 0);
    r.fpsMedian  = 1 / median(dNew);
    r.intervalSD = std(dNew);

    % ---- file-rate from frame numbers in file names over the whole span ---
    % Over hours, (frame-number difference)/(time difference) gives the true
    % file-writing rate very precisely; times the fraction of new frames this
    % gives the real fps independent of the 10 fps assumption.
    nums = lastNumbers(names);
    r.fileRateFromNames = NaN;
    r.fpsFromNames      = NaN;
    % recording duration = first file of first block to last file of last
    % block (assumes the sample covers the start and end of the recording)
    if nSeg > 1
        r.durationHours = (tRel(end) - tRel(1)) / 3600;
    else
        r.durationHours = NaN;
    end
    if all(isfinite(nums)) && nSeg > 1 && (tRel(end) - tRel(1)) > 0
        r.fileRateFromNames = (nums(end) - nums(1)) / (tRel(end) - tRel(1));
        r.fpsFromNames      = r.fileRateFromNames * r.newFraction;
    end
    r.runLengths = runLengths;
    r.timestampResolution = timestampResolution(t);

    frames.name    = names;
    frames.time    = t;
    frames.timeRel = tRel;
    frames.segment = segment;
    frames.isNew   = isNew;
    frames.maxDiff = maxDiff;
    frames.uniqueIndex = cumsum(isNew);
    try
        r.frames = struct2table(frames);
    catch
        r.frames = frames;
    end

    % ---- report ---------------------------------------------------------
    fprintf('\n%s\n', folder);
    fprintf('  Files: %d   new: %d   duplicates: %d (%.1f%%)\n', ...
            n, nNew, n - nNew, 100 * r.dupFraction);
    fprintf('  Copies per new image: median %g, range %d-%d\n', ...
            median(runLengths), min(runLengths), max(runLengths));
    fprintf('  Segments (split at gaps > %.0f s): %d, spanning %s\n', ...
            gapThresh, nSeg, hms(tRel(end)));
    fprintf('  Files written at:     %.3f fps (incl. duplicates, within segments)\n', ...
            r.fpsAcquired);
    fprintf('  REAL FRAME RATE:      %.3f fps  [95%% CI %.3f-%.3f]  (timestamp fit)\n', ...
            r.fps, r.fpsCI95(1), r.fpsCI95(2));
    if nSeg > 1
        fprintf('    per segment:        %s fps\n', sprintf('%.3f  ', r.fpsPerSegment));
    end
    fprintf('    median interval:    %.3f fps  (interval SD %.3f s)\n', ...
            r.fpsMedian, r.intervalSD);
    fprintf('    %g fps x new/all:   %.3f fps  (assumes files at exactly %g fps)\n', ...
            opt.NominalFps, r.fpsFromRatio, opt.NominalFps);
    if isfinite(r.fpsFromNames)
        fprintf(['    file numbers:       files written at %.4f fps over the whole span\n', ...
                 '                        -> x new/all = %.3f fps\n'], ...
                r.fileRateFromNames, r.fpsFromNames);
    end

    if r.timestampResolution >= 0.999
        warning('realFrameRate:resolution', ...
            ['%s: timestamps have only ~1 s resolution (were the files ', ...
             'copied/zipped?). With few frames the timestamp-based estimate ', ...
             'is coarse; compare with fpsFromRatio.'], folder);
    end
    if isfinite(r.fps) && abs(r.fps - r.fpsFromRatio) / r.fps > 0.1
        fprintf(['  NOTE: timestamp estimate and %g fps x new/all differ by >10%%;\n', ...
                 '        the camera probably did not write files at exactly %g fps.\n'], ...
                 opt.NominalFps, opt.NominalFps);
    end
    nz = maxDiff(isNew & isfinite(maxDiff));
    if isJpeg && opt.Tolerance == 0 && ~isempty(nz) && median(nz) <= 10
        fprintf(['  NOTE: JPEG files: most "new" frames differ only slightly from the previous\n', ...
                 '        one, so duplicates may have been re-compressed. Look at the max-diff\n', ...
                 '        plot and rerun with e.g. ''Tolerance'', 5.\n']);
    end
    if ~isempty(nz) && opt.Tolerance == 0 && min(nz) <= 2
        fprintf(['  NOTE: some "new" frames differ from the previous one by only %g grey ', ...
                 'level(s).\n        If these are noisy copies, rerun with ''Tolerance''.\n'], ...
                 min(nz));
    end

    if opt.Plot
        plotDiagnostics(r, frames, folder);
    end
end


% -------------------------------------------------------------------------
function t = fileTimes(paths, files)
% Last-modified time in seconds since 1970, ms precision via Java if available.
    n = numel(paths);
    t = nan(n, 1);
    useJava = usejava('jvm');
    for i = 1:n
        if useJava
            t(i) = double(javaObject('java.io.File', paths{i}).lastModified()) / 1000;
        end
    end
    if ~useJava || any(isnan(t)) || all(t == 0)
        % datenum (days) -> seconds; may only have 1 s resolution
        t = ([files.datenum]' - datenum(1970, 1, 1)) * 86400;
    end
end


function res = timestampResolution(t)
% Rough resolution: are all timestamps whole seconds?
    frac = t - floor(t);
    if all(abs(frac) < 1e-6 | abs(frac - 1) < 1e-6)
        res = 1;
    else
        res = 0.001;
    end
end


function files = listImages(folder, pats)
% Files matching any of the patterns, case-insensitive, without duplicates.
    if ischar(pats) || isstring(pats), pats = cellstr(pats); end
    files = [];
    for k = 1:numel(pats)
        for pat = unique({pats{k}, lower(pats{k}), upper(pats{k})})
            f = dir(fullfile(folder, pat{1}));
            files = [files; f(:)]; %#ok<AGROW>
        end
    end
    if isempty(files), files = dir(fullfile(folder, 'no_such_file_')); return; end
    files = files(~[files.isdir]);
    % drop hidden macOS resource files ("._name.tif") and empty files
    keep = ~strncmp({files.name}, '._', 2) & [files.bytes] > 0;
    files = files(keep);
    if isempty(files), return; end
    [~, iu] = unique({files.name});
    files = files(sort(iu));
end


function [rate, ci] = pooledRate(t, seg)
% Rate (1/period) from a fit  t = a_segment + period * k,  where k counts
% frames within each segment. One common period, separate offsets per
% segment, so gaps between segments do not matter.
    rate = NaN; ci = [NaN NaN];
    t = t(:); seg = seg(:);
    [~, ~, g] = unique(seg);
    nG = max(g);
    k = zeros(size(t));
    for s = 1:nG
        idx = find(g == s);
        k(idx) = 0:numel(idx) - 1;
    end
    df = numel(t) - nG - 1;
    if df < 1 || all(k == 0)
        return
    end
    D = full(sparse((1:numel(t))', g, 1, numel(t), nG));
    X = [D, k];
    b = X \ t;
    period = b(end);
    res = t - X * b;
    % SE of the slope: residual variance / within-segment spread of k
    kc = k;
    for s = 1:nG
        kc(g == s) = k(g == s) - mean(k(g == s));
    end
    se = sqrt(sum(res .^ 2) / df / sum(kc .^ 2));
    tc = tcrit975(df);
    rate = 1 / period;
    ci = sort(1 ./ [period + tc * se, max(period - tc * se, eps)]);
end


function nums = lastNumbers(names)
% Last number in each file name (NaN if none).
    nums = nan(numel(names), 1);
    for i = 1:numel(names)
        [~, base] = fileparts(names{i});
        tok = regexp(base, '\d+', 'match');
        if ~isempty(tok)
            nums(i) = str2double(tok{end});
        end
    end
end


function s = hms(sec)
    s = sprintf('%d:%02d:%02d', floor(sec / 3600), floor(mod(sec, 3600) / 60), ...
                round(mod(sec, 60)));
end


function order = naturalOrder(names)
% Sort by the last number in each file name (frame_9 before frame_10).
    nums = lastNumbers(names);
    if any(isnan(nums)) || numel(unique(nums)) < numel(nums)
        [~, order] = sort(names);
    else
        [~, order] = sort(nums);
    end
end


function tc = tcrit975(df)
% Two-sided 95% t critical value without the Statistics Toolbox.
    if df <= 0
        tc = NaN; return
    end
    f = @(x) betainc(df ./ (df + x .^ 2), df / 2, 0.5) / 2 - 0.025;
    tc = fzero(f, [0.5 100]);
end


function s = folderLabel(folder)
% Last two folder levels, e.g. 'session3/Raw', so generic names stay distinct.
    parts = regexp(folder, '[\\/]', 'split');
    parts = parts(~cellfun(@isempty, parts));
    s = strjoin(parts(max(1, end - 1):end), '/');
end


function s = shorten(s, n)
    if numel(s) > n
        s = ['...', s(end - n + 4:end)];
    end
end


function plotDiagnostics(r, fr, folder)
    [~, nm] = fileparts(folder);
    figure('Name', ['Frame rate: ', nm], 'Color', 'w');
    idx = (1:numel(fr.timeRel))';

    subplot(3, 1, 1); hold on
    plot(idx(~fr.isNew), fr.timeRel(~fr.isNew), '.', 'Color', [0.7 0.7 0.7]);
    plot(idx(fr.isNew), fr.timeRel(fr.isNew), 'o', 'Color', [0.1 0.4 0.8]);
    xlabel('File number'); ylabel('Time (s)');
    legend({'duplicate', 'new'}, 'Location', 'northwest');
    title(sprintf('%s:  real %.3f fps, files %.2f fps, %d/%d new', ...
          nm, r.fps, r.fpsAcquired, r.nNew, r.nFrames), 'Interpreter', 'none');

    subplot(3, 1, 2);
    d = fr.maxDiff; d(1) = NaN;
    stem(idx, d, 'filled', 'MarkerSize', 3);
    xlabel('File number'); ylabel('Max pixel diff to previous');
    title('0 = exact duplicate');

    subplot(3, 1, 3);
    tNew = fr.timeRel(fr.isNew);
    sNew = fr.segment(fr.isNew);
    dNew = diff(tNew); dNew = dNew(diff(sNew) == 0);
    if ~isempty(dNew)
        histogram(dNew, 20);
    end
    xlabel('Interval between new frames (s)'); ylabel('Count');
end
