function [] = analyze_movement_video()


videoFile = 'X:\ChickenData\FromNadia_April2026\week1\Day4-28.03.26\8-8.30-morning\ARC-T-0-Raum4-0-20260328085024-20260328090000_converted.mp4';

v = VideoReader(videoFile);

% PARAMETERS
resizeFactor = 0.5;
blurSigma = 2;
motionThreshold = 15;
backgroundAlpha = 0.01;

% Initialize
activity = [];
frameIdx = 0;

% Read first frame
frame = readFrame(v);
frame = im2double(rgb2gray(frame));
frame = imresize(frame, resizeFactor);

% Initial background
background = frame;

prevFrame = frame;

while hasFrame(v)

    frameIdx = frameIdx + 1;

    % Read frame
    frame = readFrame(v);
    frame = rgb2gray(frame);
    frame = im2double(frame);

    % Resize for speed
    frame = imresize(frame, resizeFactor);

    % -------------------------------------------------
    % 1. REMOVE GLOBAL FLICKER
    % -------------------------------------------------

    % Normalize by median brightness
    medVal = median(frame(:));
    frameNorm = frame / medVal;

    % -------------------------------------------------
    % 2. SMOOTH NOISE
    % -------------------------------------------------

    frameSmooth = imgaussfilt(frameNorm, blurSigma);

    % -------------------------------------------------
    % 3. UPDATE BACKGROUND
    % -------------------------------------------------

    background = (1-backgroundAlpha)*background + ...
        backgroundAlpha*frameSmooth;

    % -------------------------------------------------
    % 4. BACKGROUND SUBTRACTION
    % -------------------------------------------------

    fg = abs(frameSmooth - background);

    % -------------------------------------------------
    % 5. FRAME DIFFERENCING
    % -------------------------------------------------

    diffFrame = abs(frameSmooth - prevFrame);

    % Combine methods
    motionMap = fg + diffFrame;

    % -------------------------------------------------
    % 6. THRESHOLD
    % -------------------------------------------------

    bw = motionMap > motionThreshold/255;

    % Morphological cleanup
    bw = bwareaopen(bw, 20);
    bw = imclose(bw, strel('disk',3));

    % -------------------------------------------------
    % 7. ACTIVITY METRIC
    % -------------------------------------------------

    activity(frameIdx) = sum(bw(:)) / numel(bw);

    % Update previous frame
    prevFrame = frameSmooth;

    % Optional display
    if mod(frameIdx,10)==0

        subplot(2,2,1);
        imshow(frameSmooth,[]);
        title('Normalized Frame');

        subplot(2,2,2);
        imshow(background,[]);
        title('Background');

        subplot(2,2,3);
        imshow(motionMap,[]);
        title('Motion Map');

        subplot(2,2,4);
        imshow(bw);
        title(sprintf('Activity = %.4f',activity(frameIdx)));

        drawnow;
    end
end

% -------------------------------------------------
% PLOT ACTIVITY
% -------------------------------------------------

figure;
plot(activity,'LineWidth',2);
xlabel('Frame');
ylabel('Activity Level');
title('Animal Activity Over Time');
grid on;

end