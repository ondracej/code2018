function [] = calcualtedActivityInFlickerVideo

%% =========================================================
%  OVERALL ANIMAL ACTIVITY FROM VIDEO
%  Robust to slow illumination flicker
%
%  Method:
%   1. Read video
%   2. Convert to grayscale
%   3. Estimate illumination field
%   4. Normalize frame to remove flicker
%   5. Frame differencing
%   6. Threshold motion
%   7. Sum motion pixels -> activity metric
%   8. Smooth activity trace
%
%  Works well for many animals in one arena.
%% =========================================================

clear;
clc;
close all;

%% -----------------------------
% PARAMETERS
%% -----------------------------

videoFile = 'X:\ChickenData\FromNadia_April2026\week1\Day4-28.03.26\8-8.30-morning\OF_Analysis\ARC-T-0-Raum4-tiff_rotated.avi';

gaussianSigmaSpatial = 40;   % illumination correction
%motionThreshold = 0.08;      % motion sensitivity
motionThreshold = 0.1;      % motion sensitivity
smoothWindow = 15;           % temporal smoothing

%% -----------------------------
% LOAD VIDEO
%% -----------------------------

v = VideoReader(videoFile);

numFrames = floor(v.Duration * v.FrameRate);

activity = zeros(numFrames-1,1);

%% -----------------------------
% READ FIRST FRAME
%% -----------------------------

frame1 = readFrame(v);

if size(frame1,3) == 3
    frame1 = rgb2gray(frame1);
end

frame1 = im2double(frame1);

%% -----------------------------
% REMOVE ILLUMINATION / FLICKER
%% -----------------------------

illum1 = imgaussfilt(frame1, gaussianSigmaSpatial);

norm1 = frame1 ./ (illum1 + eps);

prevFrame = norm1;

%% -----------------------------
% MAIN LOOP
%% -----------------------------

k = 1;

while hasFrame(v)

    frame = readFrame(v);

    % Convert RGB -> grayscale
    if size(frame,3) == 3
        frame = rgb2gray(frame);
    end

    frame = im2double(frame);

    %% ----------------------------------
    % ESTIMATE ILLUMINATION FIELD
    %% ----------------------------------

    illum = imgaussfilt(frame, gaussianSigmaSpatial);

    %% ----------------------------------
    % NORMALIZE FRAME
    %% ----------------------------------

    normFrame = frame ./ (illum + eps);

    %% ----------------------------------
    % FRAME DIFFERENCE
    %% ----------------------------------

    diffFrame = abs(normFrame - prevFrame);

    %% ----------------------------------
    % THRESHOLD MOTION
    %% ----------------------------------

    motionMask = diffFrame > motionThreshold;

    %% ----------------------------------
    % ACTIVITY METRIC
    %% ----------------------------------

  %  if sum(motionMask(:)) > 5000
   %     activity(k) = NaN; % this is a problem for the artifacts
   % else
        activity(k) = sum(motionMask(:));
    %end
%diffSum(k) = sum(diffFrame);
    %% ----------------------------------
    % UPDATE PREVIOUS FRAME
    %% ----------------------------------

    prevFrame = normFrame;

    %% ----------------------------------
    % OPTIONAL DISPLAY
    %% ----------------------------------

    %{
    subplot(2,2,1)
    imshow(frame, [])
    title('Original')

    subplot(2,2,2)
    imshow(normFrame, [])
    title('Normalized')

    subplot(2,2,3)
    imshow(diffFrame, [])
    title('Frame Difference')

    subplot(2,2,4)
    imshow(motionMask)
    title('Detected Motion')

    drawnow
    %}

    k = k + 1;
end

%% -----------------------------
% SMOOTH ACTIVITY TRACE
%% -----------------------------

activitySmooth = movmean(activity, smoothWindow);

%% -----------------------------
% TIME VECTOR
%% -----------------------------

t = (0:length(activitySmooth)-1) ./ v.FrameRate;

%% -----------------------------
% PLOT RESULTS
%% -----------------------------

figure;

plot(t, activitySmooth, 'LineWidth', 2);

xlabel('Time (s)');
ylabel('Overall Activity');

title('Animal Activity Over Time');

grid on;

%% -----------------------------
% OPTIONAL NORMALIZATION
%% -----------------------------

activityZ = zscore(activitySmooth);

figure;

plot(t, activityZ, 'LineWidth', 2);

xlabel('Time (s)');
ylabel('Z-scored Activity');

title('Normalized Activity');

grid on;

%% -----------------------------
% SAVE RESULTS
%% -----------------------------

results.time = t;
results.activity = activity;
results.activitySmooth = activitySmooth;
results.activityZ = activityZ;

save('activity_results.mat', 'results');

disp('Analysis complete.');

end