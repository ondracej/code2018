function [] = analyze_movement_video()

close all

%videoFile = 'X:\ChickenData\FromNadia_April2026\week1\Day4-28.03.26\8-8.30-morning\ARC-T-0-Raum4-0-20260328085024-20260328090000_converted.mp4';
%videoFile = 'X:\ChickenData\FromNadia_April2026\week1\Day2-26.03.26\8-8.30-morning\ARC-TCH01-00-085635-090000_converted.mp4' % problems?
videoFile = 'X:\ChickenData\FromNadia_April2026\week1\Day2-26.03.26\8-8.30-morning\ARC-TCH03-00-085635-090000_converted.mp4';

dirD = '\'
[pathstr,name,ext] = fileparts(videoFile);
        
bla = find(pathstr == dirD);

nametext = name(1:13);

textstr = [pathstr(bla(3)+1:bla(4)-1) '__' pathstr(bla(4)+1:bla(5)-1)  '__' pathstr(bla(5)+1:end)]


            editedVidPath = [pathstr dirD 'Analysis' dirD];
            
            if exist(editedVidPath, 'dir') ==0
                mkdir(editedVidPath);
                disp(['Created directory: ' editedVidPath])
            end

v = VideoReader(videoFile);

frameRate = v.FrameRate;

% PARAMETERS
%resizeFactor = 0.5; % not using
%blurSigma = 2;
blurSigma = 1;
%motionThreshold = 15; % 0.0588  motionThreshold/255
%motionThreshold = 80; % 0.31  motionThreshold/255
%motionThreshold = 255; % 0.0588  motionThreshold/255
motionThreshold = 274.5; % 0.0588  motionThreshold/255
backgroundAlpha = 0.01;

% Initialize
activity = [];
frameIdx = 0;

% Read first frame
frame = readFrame(v);

% Rotate the video 
%rotationAngle = -35; % Arc 1 and 4
rotationAngle = -25;
img2 = imrotate(frame,rotationAngle, 'bilinear');
%imshow(img2);

% Crop out the excess video 
[~,rectout] = imcrop(img2)
J = imcrop(img2, rectout);
%imshow(J);

% Convert to grayscale
%frame = im2double(rgb2gray(frame));
%frame = imresize(frame, resizeFactor);

frameJ = im2double(rgb2gray(J));
imshow(frameJ);
%frameJ = imresize(frameJ, resizeFactor); % do not resize for now

% Initial background
background = frameJ;
prevFrame = frameJ;

while hasFrame(v)

    frameIdx = frameIdx + 1;

    % Read frame
    frame = readFrame(v);

% apply rotate and crop changes

frame = imrotate(frame, rotationAngle, 'bilinear');
frame = imcrop(frame, rectout);
%imshow(frame);

frame = rgb2gray(frame);
frame = im2double(frame);
%imshow(frame);

    % Resize for speed
   % frame = imresize(frame, resizeFactor);

    % -------------------------------------------------
    % 1. REMOVE GLOBAL FLICKER
    % -------------------------------------------------

    % Normalize by median brightness
    medVal = median(frame(:));
    frameNorm = frame / medVal;
    %imshow(frameNorm);
    % -------------------------------------------------
    % 2. SMOOTH NOISE
    % -------------------------------------------------

    frameSmooth = imgaussfilt(frameNorm, blurSigma);
    %imshow(frame);
    %imshow(frameSmooth);


    % -------------------------------------------------
    % 3. UPDATE BACKGROUND
    % -------------------------------------------------

    background = (1-backgroundAlpha)*background + backgroundAlpha*frameSmooth;

    %imshow(background);
    
    % -------------------------------------------------
    % 4. BACKGROUND SUBTRACTION
    % -------------------------------------------------

    fg = abs(frameSmooth - background);
    %imshow(fg);
    % -------------------------------------------------
    % 5. FRAME DIFFERENCING
    % -------------------------------------------------

    diffFrame = abs(frameSmooth - prevFrame);
    %imshow(diffFrame);

    % Combine methods
    motionMap = fg + diffFrame;
    %imshow(motionMap);
    %imshow(diffFrame);
    % -------------------------------------------------
    % 6. THRESHOLD
    % -------------------------------------------------
%motionThreshold = 274.5
    bw = motionMap > motionThreshold/255;
%    imshow(bw);
    %colorbar
    %maxmotion = max(motionMap)

    % Morphological cleanup
    % dont use this for now
    %figure(103); clf
    %imshow(bw)
    %figure(100);clf
    %bw1 = bwareaopen(bw, 20); % orig
    %bw1 = bwareaopen(bw, 20);
    bw = bwareaopen(bw, 20);
    %imshow(bw1);
    
    %bw2 = imclose(bw, strel('disk',3)); % orig
    %bw2 = imclose(bw1, strel('disk',20));
    bw = imclose(bw, strel('disk',20));
    %figure(102);clf
    %imshow(bw2);
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
% ------
% 
% -------------------------------------------

activity_raw = activity;

meanactivity = mean(activity(100:end));
stdactivity = std(activity);
thresh = 3*stdactivity+meanactivity;

artifactInds = find(activity > thresh);
activity(artifactInds)=0; % reduce initial artifacts
activity_norm = activity./(max(max(activity))); % normalized here

timepoints= 1:1:numel(activity_norm);
timepoints_s= timepoints/frameRate;
timepoints_min= timepoints_s/60;

figure (100); clf
subplot(2, 1, 1)
plot(timepoints_min, activity_norm,'LineWidth',1);
%hold on
%plot(timepoints_min, activity_raw,'LineWidth',1);
axis tight
ylim([0 1])
xlabel('Time (min)');
ylabel('Normalized Activity Level');
title([textstr ' : ' nametext], 'interpreter', 'none');
grid on;


%% Bin the data into 8, 1-minute bins
frames_per_min = frameRate*60;

TOn = 1:frames_per_min:numel(activity_norm);

allVals = [];
for j = 1:numel(TOn)-1

theseInds = TOn(j):TOn(j+1)-1; 
activitVals = activity_norm(theseInds);
allVals(:,j) = activity_norm(theseInds);
meanBinVals(j) = mean(activitVals);
medianBinVals(j) = median(activitVals);
sem(j) = std(activitVals / sqrt(numel(activitVals)));
end

xes = 1:1:numel(TOn)-1;
figure (100);
subplot(2, 1, 2)

%boxplot(allVals,'PlotStyle','compact', 'whisker', 0)

bar(xes,medianBinVals)
hold on
er = errorbar(xes,medianBinVals,medianBinVals-sem,medianBinVals+sem); 
er.Color = [0 0 0];   
hold on
plot(xes, meanBinVals, 'ko')
ylim([0 0.3])
ylabel('Median Activity')
xlabel('Time (min)')

figName = [editedVidPath nametext]
plotpos = [0 0 15 12];
            print_in_A4(0, figName, '-djpeg', 0, plotpos);
            

%%


DATA.activity_raw = activity_raw;
DATA.artifactInds = artifactInds;
DATA.activity_norm = activity_norm;
DATA.timepoints_min = timepoints_min;
DATA.meanBinVals = meanBinVals;
DATA.medianBinVals = medianBinVals;
DATA.sem = sem;
DATA.TOn = TOn;


INFO.frameRate = frameRate;
INFO.videoFile = videoFile;
INFO.textstr = textstr;
INFO.nametext = nametext;
INFO.videoDur_s = v.Duration;


saveName = [editedVidPath nametext '__data'];
save(saveName, 'DATA', 'INFO');

end