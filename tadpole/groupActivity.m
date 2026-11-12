function R = groupActivity(videos, varargin)
%GROUPACTIVITY  Group activity, number of animals moving, and clustering
%from overhead videos of many tadpoles, without identity tracking.
%
%   R = groupActivity(videoFolder)              % all .avi in the folder
%   R = groupActivity({'v001.avi', 'v002.avi'})  % consecutive videos, in order
%   R = groupActivity(..., 'Preview', 4)        % only show detections on
%                                               % 4 light + 4 dark frames
%   groupActivity(videoFolder, 'Seed', 5)       % click animals in 5 light +
%                                               % 5 dark frames (calibration)
%
%   Per real (non-duplicate) frame:
%     MOTION  The frame is compared with the previous real frame (0.5 s
%             earlier at 2 fps). Pixels that changed by more than K x the
%             frame's own noise level count as moving. Tadpoles are darker
%             than the background, so a spot that became DARKER is where a
%             moving animal now is; such spots (merged within a few pixels)
%             are counted as moving animals.
%             The noise level is measured in every frame difference, so the
%             same settings work in the bright light phase and in the dark,
%             noisier, less sharp IR phase. Brightness is normalised per
%             frame; differences across a light/dark switch are skipped.
%   BODIES  Every 'BodyEvery' seconds, all animals (also resting ones) are
%             detected as dark spots against the local background, after
%             removing fixed structures (dish rim, scratches, labels): these
%             are taken from the median of 120 frames spread over the whole
%             recording, separately for light and dark. Their
%             positions give nearest-neighbour distances (clustering) and
%             distance from the dish centre.
%
%   Animals that overlap merge into one spot, so counts are lower bounds
%   when animals are clumped.
%
%   Options
%     'ROI'          [cx cy r] circle (pixels) of the area to analyse. Draw
%                    it INSIDE the reflections in the dish wall. Default []:
%                    draw it on the first frame (saved as roi.mat in
%                    OutFolder and reused next time).
%     'OutFolder'    results folder (default 'groupActivity_results')
%     'StartTime'    clock time of the first frame, e.g.
%                    datenum(2019,7,5,12,22,23) -> clock time in outputs
%     'K'            motion threshold, x frame noise (default 5)
%     'MinContrast'  ... and at least this darkening, as a fraction of the
%                    frame brightness (default 0.2). Separates a body that
%                    moved from tail beating in place and wall reflections.
%     'MinArea'      min. size of a moving spot, px (default 15)
%     'Merge'        merge moving pixels closer than this, px (default 10)
%     'Sigma'        smoothing before differencing, px (default 1.5)
%     'BodyEvery'    seconds between body detections (default 10)
%     'BodyK'        body threshold, x local noise (default 4)
%     'BodyMinContrast'  ... and at least this darkness vs. surroundings,
%                    fraction of brightness (default 0.2)
%     'BodyMerge'    merge body pieces closer than this, px (default 6)
%     'BodyMinArea'  min. body size, px (default 15)
%     'BodyBg'       scale of the local background, px (default 12)
%     'DupTol'       max. pixel difference for a duplicate frame (default 0)
%     'BinSec'       bin size of the summary time series, s (default 60)
%     'PhaseThreshold'  ROI brightness separating light/dark (default: auto)
%     'MaxFrames'    stop each video after this many frames (for tests)
%     'ExcludeDark'  large fixed objects darker than this fraction of the
%                    median brightness (e.g. speaker, cable) are masked out
%                    (default 0.45; set 0 to switch off)
%     'ExcludeMinArea'  min. size of such objects, px (default 800)
%     'NAnimals'     animals per dish (default 10). If more bodies are
%                    found, only the NAnimals darkest are kept; if fewer,
%                    the shortfall is recorded (overlapping/hidden animals).
%                    [] = no cap.
%     'Seed'         n > 0: CLICK MODE. Shows n light and n dark frames
%                    spread over the recording; click every tadpole. Saved
%                    to OutFolder/seeds.mat. Every later run uses the clicks
%                    to choose the body contrast for light and dark and
%                    reports the cross-validated detection accuracy.
%     'MatchRadius'  max. distance detection-click to count as found, px
%                    (default 15)
%     'Preview'      n > 0: show detections on n light and n dark frames,
%                    then stop. Use this to check/tune K, MinArea, BodyK.
%
%   Output R (also saved to OutFolder/results.mat; per-bin table as CSV)
%     .frames   per real frame: t (s), phase (1 light, 0 dark), energy
%               (fraction of ROI pixels changed), nMoving, video, frame
%     .moving   per moving spot: t, x, y, area   (for heat maps)
%     .bodies   per body snapshot: t, phase, nBodies, meanNN, medianNN
%               (nearest-neighbour distance, px), meanRadial (0 = centre,
%               1 = ROI edge), positions {cell}
%     .bins     per BinSec: tStart, clock, phase, energy, nMoving (mean),
%               nMovingMax, fracAnyMoving, nBodies, meanNN, meanRadial,
%               fracComplete (snapshots with all NAnimals found),
%               meanNNcomplete (NN distance from complete snapshots only)
%     .calibration  per phase: chosen contrast, cross-validated hit rate,
%               false detections per frame, position error (if seeded)
%   Processed videos are cached in OutFolder, so an interrupted run
%   continues where it stopped (delete the cache files to recompute).

    p = inputParser;
    p.addParameter('ROI', []);
    p.addParameter('OutFolder', 'groupActivity_results');
    p.addParameter('StartTime', []);
    p.addParameter('K', 5);
    p.addParameter('MinArea', 15);
    p.addParameter('Merge', 10);
    p.addParameter('MinContrast', 0.2);
    p.addParameter('BodyMinContrast', 0.2);
    p.addParameter('BodyMerge', 6);
    p.addParameter('Sigma', 1.5);
    p.addParameter('BodyEvery', 10);
    p.addParameter('BodyK', 4);
    p.addParameter('BodyMinArea', 15);
    p.addParameter('BodyBg', 12);
    p.addParameter('DupTol', 0);
    p.addParameter('BinSec', 60);
    p.addParameter('PhaseThreshold', []);
    p.addParameter('MaxFrames', Inf);
    p.addParameter('Preview', 0);
    p.addParameter('ExcludeDark', 0.45);
    p.addParameter('NAnimals', 10);
    p.addParameter('Seed', 0);
    p.addParameter('MatchRadius', 15);
    p.addParameter('ExcludeMinArea', 800);
    p.addParameter('Plot', true);
    p.parse(varargin{:});
    opt = p.Results;

    vids = listVideos(videos);
    if ~exist(opt.OutFolder, 'dir'), mkdir(opt.OutFolder); end
    fprintf('%d video(s)\n', numel(vids));

    % ---- ROI ---------------------------------------------------------------
    first = toGray(readOne(vids{1}, 1));
    roiFile = fullfile(opt.OutFolder, 'roi.mat');
    if isempty(opt.ROI)
        if exist(roiFile, 'file')
            tmp = load(roiFile); opt.ROI = tmp.roi;
            fprintf('Using saved ROI %s\n', mat2str(round(opt.ROI)));
        else
            opt.ROI = drawRoi(first);
            roi = opt.ROI; save(roiFile, 'roi');
        end
    end
    [H, Wd] = size(first);
    [xx, yy] = meshgrid(1:Wd, 1:H);
    rr = hypot(xx - opt.ROI(1), yy - opt.ROI(2)) / opt.ROI(3);
    mask = rr <= 1;

    % ---- video info, light/dark threshold ------------------------------------
    nF = zeros(numel(vids), 1); fps = nF;
    for k = 1:numel(vids)
        v = VideoReader(vids{k});
        nF(k) = numFrames(v); fps(k) = v.FrameRate;
    end
    tOff = [0; cumsum(nF(1:end - 1) ./ fps(1:end - 1))];
    % sample frames spread over the whole recording: light/dark threshold
    % and the static background (dish rim, scratches) of each phase
    nS = 120;
    cum = [0; cumsum(nF)];
    gIdx = unique(round(linspace(1, cum(end), nS)));
    samp = cell(numel(gIdx), 1); b = nan(1, numel(gIdx));
    for j = 1:numel(gIdx)
        k = find(cum < gIdx(j), 1, 'last');
        f = double(toGray(readOne(vids{k}, gIdx(j) - cum(k))));
        b(j) = median(f(mask));
        samp{j} = f;
    end
    if isempty(opt.PhaseThreshold)
        opt.PhaseThreshold = twoCluster(b);
        fprintf('Light/dark threshold (ROI median brightness): %.1f  (dark ~%.0f, light ~%.0f)\n', ...
                opt.PhaseThreshold, median(b(b < opt.PhaseThreshold)), ...
                median(b(b >= opt.PhaseThreshold)));
    end

    opt.static = cell(1, 2);                       % {dark, light}
    for ph = [0 1]
        sel = find((b >= opt.PhaseThreshold) == ph);
        if numel(sel) >= 8
            st = zeros([size(first), numel(sel)], 'single');
            for j = 1:numel(sel)
                g = samp{sel(j)} / max(b(sel(j)), 1);
                st(:, :, j) = single(gauss(g, opt.Sigma) - gauss(g, opt.BodyBg));
            end
            opt.static{ph + 1} = double(median(st, 3));
        else
            opt.static{ph + 1} = zeros(size(first));
        end
    end
    % exclude large fixed dark objects (speaker, cable): very dark in the
    % median image of either phase and larger than a tadpole
    excl = false(size(first));
    for ph = [0 1]
        sel = find((b >= opt.PhaseThreshold) == ph);
        if numel(sel) >= 8
            st = zeros([size(first), numel(sel)], 'single');
            for j = 1:numel(sel), st(:, :, j) = single(samp{sel(j)} / max(b(sel(j)), 1)); end
            md = double(median(st, 3));
            excl = excl | bwareaopen(md < opt.ExcludeDark & mask, opt.ExcludeMinArea);
        end
    end
    if any(excl(:))
        excl = imdilate(excl, strel('disk', 12, 0));
        fprintf('Excluded large fixed dark object(s) (speaker/cable): %.1f%% of ROI\n', ...
                100 * sum(excl(:) & mask(:)) / sum(mask(:)));
        mask = mask & ~excl;
    end
    opt.excluded = excl;
    clear samp st

    seedFile = fullfile(opt.OutFolder, 'seeds.mat');
    if opt.Seed > 0
        seedFrames(vids, cum, gIdx, b, mask, opt, seedFile);
        R = [];
        return
    end
    calib = [];
    if exist(seedFile, 'file')
        [opt, calib] = calibrateFromSeeds(seedFile, mask, opt);
    end

    if opt.Preview > 0
        previewDetections(vids, nF, mask, rr, opt);
        R = [];
        return
    end

    % ---- process videos ------------------------------------------------------
    F = []; M = []; B = emptyBodies();
    for k = 1:numel(vids)
        [~, nm] = fileparts(vids{k});
        cache = fullfile(opt.OutFolder, ['cache_', nm, '.mat']);
        key = settingsKey(opt);
        c = [];
        if exist(cache, 'file')
            c = load(cache);
            if isfield(c, 'key') && isequal(c.key, key)
                fprintf('[%d/%d] %s: cached\n', k, numel(vids), nm);
            else
                fprintf('[%d/%d] %s: settings changed since cache, recomputing\n', k, numel(vids), nm);
                c = [];
            end
        end
        if isempty(c)
            c = processVideo(vids{k}, k, tOff(k), mask, rr, opt);
            c.key = key;
            save(cache, '-struct', 'c');
        end
        F = [F; c.F]; M = [M; c.M]; B = [B, c.B]; %#ok<AGROW>
    end

    R.frames = array2struct(F, {'t', 'phase', 'energy', 'nMoving', 'video', 'frame'});
    R.moving = array2struct(M, {'t', 'x', 'y', 'area'});
    R.bodies = B;
    R.roi = opt.ROI;
    R.calibration = calib;
    R.options = opt;
    R.bins = makeBins(F, B, opt);
    save(fullfile(opt.OutFolder, 'results.mat'), 'R');
    writeBins(R.bins, fullfile(opt.OutFolder, 'activity_bins.csv'));
    fprintf('Saved %s\n', fullfile(opt.OutFolder, 'results.mat'));
    if opt.Plot, plotResults(R, opt); end
end


% =========================================================================
function c = processVideo(file, vidNo, tOff, mask, rr, opt)
    v = VideoReader(file);
    fps = v.FrameRate;
    [~, nm] = fileparts(file);
    F = zeros(0, 6); M = zeros(0, 4);
    B = emptyBodies();
    prevRaw = []; prevN = []; prevPhase = NaN;
    i = 0; nNew = 0; nextBody = -Inf; t0 = tic;
    nTot = min(numFrames(v), opt.MaxFrames);
    while hasFrame(v) && i < opt.MaxFrames
        raw = readFrame(v); i = i + 1;
        if size(raw, 3) == 3, raw = raw(:, :, 1); end
        if ~isempty(prevRaw) && isDuplicate(raw, prevRaw, opt.DupTol)
            continue
        end
        prevRaw = raw; nNew = nNew + 1;
        t = tOff + (i - 1) / fps;
        g = double(raw);
        med = median(g(mask));
        phase = double(med >= opt.PhaseThreshold);
        g = g / max(med, 1);                       % brightness normalisation
        gs = gauss(g, opt.Sigma);
        energy = NaN; nMov = NaN;
        if ~isempty(prevN) && phase == prevPhase
            [energy, cents, areas] = motion(gs, prevN, mask, opt);
            nMov = numel(areas);
            if nMov
                M = [M; repmat(t, nMov, 1), cents, areas(:)]; %#ok<AGROW>
            end
        end
        F(end + 1, :) = [t, phase, energy, nMov, vidNo, i]; %#ok<AGROW>
        if t >= nextBody
            B(end + 1) = bodies(gs, g, mask, rr, opt, t, phase); %#ok<AGROW>
            nextBody = t + opt.BodyEvery;
        end
        prevN = gs; prevPhase = phase;
        if mod(i, 5000) == 0
            fprintf('   %s: %d / %d frames (%.0f frames/s)\n', nm, i, nTot, i / toc(t0));
        end
    end
    fprintf('[%d] %s: %d frames, %d real (%.0f%%), %.0f s\n', vidNo, nm, i, nNew, ...
            100 * nNew / max(i, 1), toc(t0));
    if fps >= 8 && nNew / max(i, 1) > 0.9
        fprintf(['   NOTE: almost no duplicates found in a %g fps video. If duplicates ', ...
                 'exist but are not\n         pixel-identical, set ''DupTol'' (e.g. 3).\n'], fps);
    end
    c.F = F; c.M = M; c.B = B;
end


function d = isDuplicate(a, b, tol)
    if tol == 0
        d = isequal(a, b);
    else
        d = max(abs(double(a(:)) - double(b(:)))) <= tol;
    end
end


function [energy, cents, areas] = motion(cur, prev, mask, opt)
    D = cur - prev;
    s = 1.4826 * median(abs(D(mask)));             % robust noise level
    s = max(s, 1e-4);
    chg = abs(D) > opt.K * s & mask;
    energy = mean(chg(mask));
    % became darker = animal body arrived. Besides K x noise, require a
    % minimum contrast (fraction of brightness): the dark body passes it,
    % a tail beating in place or a wall reflection does not
    dark = D < -max(opt.K * s, opt.MinContrast) & mask;
    dark = bwareaopen(dark, 3);
    lab = bwlabel(imdilate(dark, strel('disk', opt.Merge, 0)));
    lab(~dark) = 0;
    st = regionprops(lab, 'Area', 'Centroid');
    if isempty(st)
        cents = zeros(0, 2); areas = zeros(0, 1); return
    end
    areas = [st.Area]';
    keep = areas >= opt.MinArea;
    cents = reshape([st(keep).Centroid], 2, [])';
    areas = areas(keep);
end


function [hp, s] = bodyMap(gs, g, mask, opt, phase)
% Dark spots vs. local background, minus fixed structures (rim, scratches).
    hp = gs - gauss(g, opt.BodyBg) - opt.static{phase + 1};
    s = max(1.4826 * median(abs(hp(mask))), 1e-4);
end


function [P, nRaw] = detectBodies(hp, s, mask, contrast, opt)
% Body centroids. Pieces of one animal (eyes, gut, body) closer than
% BodyMerge px are merged. If more than NAnimals spots are found, only the
% NAnimals darkest are kept (the extra ones are faint false detections).
    bw = hp < -max(opt.BodyK * s, contrast) & mask;
    lab = bwlabel(imdilate(bw, strel('disk', opt.BodyMerge, 0)));
    lab(~bw) = 0;
    st = regionprops(lab, 'Centroid', 'Area', 'PixelIdxList');
    st = st([st.Area] >= opt.BodyMinArea);
    nRaw = numel(st);
    if isempty(st), P = zeros(0, 2); return; end
    strength = arrayfun(@(r) -min(hp(r.PixelIdxList)), st);
    if ~isempty(opt.NAnimals) && nRaw > opt.NAnimals
        [~, o] = sort(strength, 'descend');
        st = st(o(1:opt.NAnimals));
    end
    P = reshape([st.Centroid], 2, [])';
end


function c = phaseContrast(opt, phase)
    c = opt.BodyMinContrast;
    if numel(c) == 2, c = c(phase + 1); end        % [dark light]
end


function b = bodies(gs, g, mask, rr, opt, t, phase)
    [hp, s] = bodyMap(gs, g, mask, opt, phase);
    [P, nRaw] = detectBodies(hp, s, mask, phaseContrast(opt, phase), opt);
    b.t = t; b.phase = phase; b.nBodies = size(P, 1); b.nRaw = nRaw;
    b.shortfall = NaN;
    if ~isempty(opt.NAnimals), b.shortfall = max(0, opt.NAnimals - size(P, 1)); end
    b.positions = P;
    if size(P, 1) >= 2
        Dm = sqrt(bsxfun(@minus, P(:, 1), P(:, 1)') .^ 2 + bsxfun(@minus, P(:, 2), P(:, 2)') .^ 2);
        Dm(1:size(P, 1) + 1:end) = Inf;
        nn = min(Dm, [], 2);
        b.meanNN = mean(nn); b.medianNN = median(nn);
    else
        b.meanNN = NaN; b.medianNN = NaN;
    end
    if isempty(P)
        b.meanRadial = NaN;
    else
        idx = sub2ind(size(rr), round(P(:, 2)), round(P(:, 1)));
        b.meanRadial = mean(rr(idx));
    end
end


% =========================================================================
function bins = makeBins(F, B, opt)
    tEnd = max(F(:, 1));
    edges = 0:opt.BinSec:tEnd + opt.BinSec;
    n = numel(edges) - 1;
    bins = struct('tStart', num2cell(edges(1:n)'));
    bt = [B.t]; bN = [B.nBodies]; bNN = [B.meanNN]; bR = [B.meanRadial];
    bS = [B.shortfall];
    for k = 1:n
        m = F(:, 1) >= edges(k) & F(:, 1) < edges(k + 1);
        e = F(m, 3); mv = F(m, 4); ok = isfinite(e);
        bins(k).clock = '';
        if ~isempty(opt.StartTime)
            bins(k).clock = datestr(opt.StartTime + edges(k) / 86400, 'yyyy-mm-dd HH:MM:SS');
        end
        bins(k).phase = NaN;
        if any(m), bins(k).phase = round(mean(F(m, 2))); end
        bins(k).nFrames = sum(ok);
        bins(k).energy = mean(e(ok));
        bins(k).nMoving = mean(mv(ok));
        bins(k).nMovingMax = max([mv(ok); NaN]);
        bins(k).fracAnyMoving = mean(mv(ok) > 0);
        mb = bt >= edges(k) & bt < edges(k + 1);
        bins(k).nBodies = mean(bN(mb));
        bins(k).meanNN = mean(bNN(mb & isfinite(bNN)));
        bins(k).meanRadial = mean(bR(mb & isfinite(bR)));
        bins(k).fracComplete = mean(bS(mb) == 0);          % snapshots with all animals found
        bins(k).meanNNcomplete = mean(bNN(mb & bS == 0 & isfinite(bNN)));
    end
end


function writeBins(bins, file)
    f = fieldnames(bins);
    fid = fopen(file, 'w');
    fprintf(fid, '%s\n', strjoin(f', ','));
    for k = 1:numel(bins)
        vals = cell(1, numel(f));
        for j = 1:numel(f)
            x = bins(k).(f{j});
            if ischar(x), vals{j} = x; else, vals{j} = num2str(x, '%.6g'); end
        end
        fprintf(fid, '%s\n', strjoin(vals, ','));
    end
    fclose(fid);
end


function plotResults(R, opt)
    b = R.bins; th = [b.tStart] / 3600;
    figure('Color', 'w', 'Name', 'Group activity');
    ys = {[b.energy] * 100, [b.nMoving], [b.fracAnyMoving] * 100, [b.meanNN]};
    yl = {'Changed pixels (% ROI)', 'Animals moving (mean)', 'Time any moving (%)', ...
          'Nearest neighbour (px)'};
    for j = 1:4
        subplot(4, 1, j); hold on
        y = ys{j};
        shadeDark(th, [b.phase], opt.BinSec / 3600, [min(y), max(y)]);
        plot(th, y, 'k', 'LineWidth', 1);
        ylabel(yl{j});
        if j == 4, xlabel('Time (h)'); end
    end
end


function shadeDark(th, ph, w, yr)
    if any(~isfinite(yr)) || yr(1) == yr(2), return; end
    for k = find(ph == 0)
        patch([th(k), th(k) + w, th(k) + w, th(k)], [yr(1), yr(1), yr(2), yr(2)], ...
              [0.85 0.85 0.85], 'EdgeColor', 'none');
    end
end


function previewDetections(vids, nF, mask, rr, opt)
% Show moving spots (red) and bodies (cyan) on sample frame pairs.
    picks = {}; need = [opt.Preview, opt.Preview];      % light, dark
    for k = 1:numel(vids)
        v = VideoReader(vids{k});
        for i = unique(round(linspace(2, nF(k) - 10, 60)))
            [a, b2] = realPair(v, i, opt.DupTol);
            if isempty(a), continue; end
            med = median(double(a(mask)));
            ph = double(med >= opt.PhaseThreshold);
            if need(2 - ph) > 0
                picks{end + 1} = {a, b2, ph, sprintf('%s fr %d', shortName(vids{k}), i)}; %#ok<AGROW>
                need(2 - ph) = need(2 - ph) - 1;
            end
            if all(need == 0), break; end
        end
        if all(need == 0), break; end
    end
    n = numel(picks);
    figure('Color', 'w', 'Name', 'Detection preview (red: moving, cyan: bodies)');
    for j = 1:n
        a = double(picks{j}{1}); b2 = double(picks{j}{2});
        ga = a / max(median(a(mask)), 1); gb = b2 / max(median(b2(mask)), 1);
        sa = gauss(ga, opt.Sigma); sb = gauss(gb, opt.Sigma);
        [~, cents] = motion(sb, sa, mask, opt);
        bb = bodies(sb, gb, mask, rr, opt, 0, picks{j}{3});
        subplot(2, ceil(n / 2), j);
        disp8 = mat2gray(gb, [prctile_(gb(mask), 1), prctile_(gb(mask), 99.5)]);
        imshow(disp8); hold on
        th = linspace(0, 2 * pi, 200);
        plot(opt.ROI(1) + opt.ROI(3) * cos(th), opt.ROI(2) + opt.ROI(3) * sin(th), 'y');
        if ~isempty(bb.positions)
            plot(bb.positions(:, 1), bb.positions(:, 2), 'co', 'MarkerSize', 8);
        end
        if ~isempty(cents)
            plot(cents(:, 1), cents(:, 2), 'r+', 'MarkerSize', 10, 'LineWidth', 1.5);
        end
        title(sprintf('%s %s: %d moving, %d bodies', ternary(picks{j}{3}, 'LIGHT', 'DARK'), ...
              picks{j}{4}, size(cents, 1), bb.nBodies), 'Interpreter', 'none', 'FontSize', 8);
    end
end


function [a, b] = realPair(v, i, tol)
% Frame i and the next frame that is not a duplicate of it.
    a = toGray(read(v, i)); b = [];
    for j = i + 1:min(i + 15, numFrames(v))
        c = toGray(read(v, j));
        if ~isDuplicate(c, a, tol), b = c; return; end
    end
    a = [];
end


% =========================================================================
function vids = listVideos(videos)
    if ischar(videos) && exist(videos, 'dir')
        L = dir(fullfile(videos, '*.avi'));
        names = {L.name};
        names = names(~strncmp(names, '._', 2));
        vids = fullfile(videos, names(naturalOrder(names)));
    elseif ischar(videos)
        vids = {videos};
    else
        vids = cellstr(videos);
    end
    if isempty(vids), error('groupActivity:none', 'No videos found.'); end
end


function f = readOne(file, i)
    v = VideoReader(file);
    f = read(v, i);
end


function n = numFrames(v)
    try, n = v.NumFrames; catch, n = v.NumberOfFrames; end
end


function g = toGray(f)
    if size(f, 3) == 3, f = f(:, :, 1); end
    g = f;
end


function out = gauss(I, s)
    if s <= 0, out = I; return; end
    h = fspecial('gaussian', 2 * ceil(3 * s) + 1, s);
    out = imfilter(I, h, 'replicate');
end


function roi = drawRoi(img)
    figure('Name', 'Draw the analysis circle INSIDE the wall reflections, then double-click');
    imshow(img, []);
    title('Drag a circle over the water area (inside the reflections); double-click it when done');
    h = drawcircle('Color', 'y');
    wait(h);
    roi = [h.Center, h.Radius];
    close(gcf);
end


function S = array2struct(A, names)
    S = struct();
    for j = 1:numel(names)
        if isempty(A), S.(names{j}) = []; else, S.(names{j}) = A(:, j); end
    end
end


function thr = twoCluster(x)
    x = x(isfinite(x));
    thr = (min(x) + max(x)) / 2;
    for it = 1:100
        lo = x(x < thr); hi = x(x >= thr);
        if isempty(lo) || isempty(hi), break; end
        t2 = (mean(lo) + mean(hi)) / 2;
        if abs(t2 - thr) < 1e-9, break; end
        thr = t2;
    end
end


function q = prctile_(x, p)
    x = sort(x(:)); q = x(max(1, min(numel(x), round(p / 100 * numel(x)))));
end


function order = naturalOrder(names)
    nums = nan(numel(names), 1);
    for i = 1:numel(names)
        tok = regexp(names{i}, '\d+', 'match');
        if ~isempty(tok), nums(i) = str2double(tok{end}); end
    end
    if any(isnan(nums)) || numel(unique(nums)) < numel(nums)
        [~, order] = sort(names);
    else
        [~, order] = sort(nums);
    end
end


function s = shortName(f)
    [~, s] = fileparts(f);
end


function out = ternary(c, a, b)
    if c, out = a; else, out = b; end
end


% =========================================================================
% seeding (clicking animals) and calibration
% =========================================================================
function B = emptyBodies()
    B = struct('t', {}, 'phase', {}, 'nBodies', {}, 'nRaw', {}, 'shortfall', {}, ...
               'positions', {}, 'meanNN', {}, 'medianNN', {}, 'meanRadial', {});
end


function seedFrames(vids, cum, gIdx, b, mask, opt, seedFile)
% Show opt.Seed light and opt.Seed dark frames spread over the recording;
% the user clicks every tadpole. Saved to seeds.mat (added to existing).
    S = struct('video', {}, 'frame', {}, 'phase', {}, 'points', {});
    if exist(seedFile, 'file'), tmp = load(seedFile); S = tmp.S; end
    [r1, c1] = find(mask);
    rows = max(1, min(r1) - 10):min(size(mask, 1), max(r1) + 10);
    cols = max(1, min(c1) - 10):min(size(mask, 2), max(c1) + 10);
    for ph = [1 0]
        sel = find((b >= opt.PhaseThreshold) == ph);
        if isempty(sel), continue; end
        pick = sel(unique(round(linspace(1, numel(sel), min(opt.Seed, numel(sel))))));
        for j = pick
            k = find(cum < gIdx(j), 1, 'last');
            i = gIdx(j) - cum(k);
            f = double(toGray(readOne(vids{k}, i)));
            g = f / max(median(f(mask)), 1);
            lo = prctile_(g(mask), 0.5); hi = prctile_(g(mask), 99.5);
            d = min(max((g - lo) / max(hi - lo, eps), 0), 1);
            if ph == 0, d = adapthisteq(d); end     % make faint animals visible
            fig = figure('Name', 'Seed frame', 'NumberTitle', 'off', 'Units', 'normalized', ...
                         'Position', [0.05 0.05 0.85 0.85]);
            imshow(d(rows, cols), 'InitialMagnification', 'fit'); hold on
            th = linspace(0, 2 * pi, 200);
            plot(opt.ROI(1) + opt.ROI(3) * cos(th) - cols(1) + 1, ...
                 opt.ROI(2) + opt.ROI(3) * sin(th) - rows(1) + 1, 'y');
            title(sprintf(['%s frame %d of %s (%d/%d): click the BODY of every tadpole ', ...
                           'inside the circle. Backspace = undo, Enter = done'], ...
                          ternary(ph, 'LIGHT', 'DARK'), i, shortName(vids{k}), ...
                          find(pick == j), numel(pick)), 'Interpreter', 'none');
            [x, y] = getpts(gca);
            close(fig);
            S(end + 1).video = vids{k}; %#ok<AGROW>
            S(end).frame = i; S(end).phase = ph;
            S(end).points = [x(:) + cols(1) - 1, y(:) + rows(1) - 1];
            save(seedFile, 'S');
            fprintf('  %s frame %d: %d animals clicked\n', ternary(ph, 'light', 'dark'), ...
                    i, numel(x));
        end
    end
    fprintf('Saved %d seed frames to %s\n', numel(S), seedFile);
end


function [opt, cal] = calibrateFromSeeds(seedFile, mask, opt)
% Choose the body contrast per phase that best matches the clicked animals.
% Accuracy is reported by leave-one-frame-out cross-validation (each frame
% is scored with a setting chosen on the OTHER frames), so it is not
% inflated by tuning on the same frames.
    tmp = load(seedFile); S = tmp.S;
    cands = 0.05:0.025:0.6;
    names = {'dark', 'light'};
    cal = struct('phase', {}, 'nFrames', {}, 'contrast', {}, 'hitRate', {}, ...
                 'falsePerFrame', {}, 'posError', {}, 'clicked', {}, 'found', {});
    fprintf('Calibration from %d seed frames (match radius %d px):\n', numel(S), opt.MatchRadius);
    for ph = [0 1]
        Sp = S([S.phase] == ph);
        if isempty(Sp), continue; end
        n = numel(Sp);
        TP = zeros(n, numel(cands)); FP = TP; FN = TP; ER = TP;
        for j = 1:n
            f = double(toGray(readOne(Sp(j).video, Sp(j).frame)));
            g = f / max(median(f(mask)), 1);
            gs = gauss(g, opt.Sigma);
            [hp, s] = bodyMap(gs, g, mask, opt, ph);
            clicks = Sp(j).points;
            inR = mask(sub2ind(size(mask), min(max(round(clicks(:, 2)), 1), size(mask, 1)), ...
                                           min(max(round(clicks(:, 1)), 1), size(mask, 2))));
            clicks = clicks(inR, :);              % clicks on the speaker etc. are ignored
            for c = 1:numel(cands)
                P = detectBodies(hp, s, mask, cands(c), opt);
                [tp, fp, fn, er] = matchPoints(P, clicks, opt.MatchRadius);
                TP(j, c) = tp; FP(j, c) = fp; FN(j, c) = fn; ER(j, c) = er;
            end
        end
        f1 = @(rows) 2 * sum(TP(rows, :), 1) ./ max(2 * sum(TP(rows, :), 1) + ...
                     sum(FP(rows, :), 1) + sum(FN(rows, :), 1), 1);
        [~, best] = max(f1(1:n));
        % cross-validated accuracy
        tp = 0; fp = 0; fn = 0; er = [];
        for j = 1:n
            others = setdiff(1:n, j);
            if isempty(others), cj = best; else, [~, cj] = max(f1(others)); end
            tp = tp + TP(j, cj); fp = fp + FP(j, cj); fn = fn + FN(j, cj);
            if TP(j, cj) > 0, er(end + 1) = ER(j, cj); end %#ok<AGROW>
        end
        r.phase = names{ph + 1}; r.nFrames = n; r.contrast = cands(best);
        r.hitRate = tp / max(tp + fn, 1); r.falsePerFrame = fp / n;
        r.posError = mean(er); r.clicked = (tp + fn) / n; r.found = (tp + fp) / n;
        cal(end + 1) = r; %#ok<AGROW>
        fprintf(['  %-5s: %d frames, contrast %.3f -> found %.0f%% of clicked animals, ', ...
                 '%.1f false detections/frame, position error %.1f px (cross-validated)\n'], ...
                r.phase, n, r.contrast, 100 * r.hitRate, r.falsePerFrame, r.posError);
        if numel(opt.BodyMinContrast) == 1
            opt.BodyMinContrast = [opt.BodyMinContrast, opt.BodyMinContrast];
        end
        opt.BodyMinContrast(ph + 1) = cands(best);
    end
end


function [tp, fp, fn, err] = matchPoints(P, C, radius)
% Greedy one-to-one matching of detections P to clicks C within radius.
    tp = 0; err = 0;
    if isempty(P) || isempty(C)
        fp = size(P, 1); fn = size(C, 1); return
    end
    D = sqrt(bsxfun(@minus, P(:, 1), C(:, 1)') .^ 2 + bsxfun(@minus, P(:, 2), C(:, 2)') .^ 2);
    e = [];
    while true
        [m, idx] = min(D(:));
        if ~isfinite(m) || m > radius, break; end
        [i, j] = ind2sub(size(D), idx);
        tp = tp + 1; e(end + 1) = m; %#ok<AGROW>
        D(i, :) = Inf; D(:, j) = Inf;
    end
    fp = size(P, 1) - tp; fn = size(C, 1) - tp;
    if ~isempty(e), err = mean(e); end
end


function key = settingsKey(opt)
% Settings that change the per-video results (cache is redone if they change).
    key = [opt.ROI(:)', opt.K, opt.MinContrast, opt.MinArea, opt.Merge, opt.Sigma, ...
           opt.BodyEvery, opt.BodyK, opt.BodyMinArea, opt.BodyBg, opt.BodyMerge, ...
           opt.BodyMinContrast(:)', opt.DupTol, opt.PhaseThreshold, opt.ExcludeDark, ...
           opt.ExcludeMinArea, numel(opt.NAnimals), opt.NAnimals(:)', opt.MaxFrames];
end
