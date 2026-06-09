function [] = calcOFandMakeVideo(VidDir,videoToAnalyze )

dbstop if error

if isunix
    dirD = '/';
elseif ispc
    dirD = '\';
end

%% Input video data
%VidDir = 'E:\ChronoAnalysis\002_Vids_Nov19\';
%videoToAnalyze = 'faa1-002-Nov19_contrastadj_001.avi';

AnalysisNumber = 1; % in case you want to analyze several versions

%% Define Analysis Directory

OFDir = [VidDir 'OF_Analysis' dirD];

if exist(OFDir, 'dir') == 0
    mkdir(OFDir);
end

%% Load Video

vidToLoad = [VidDir videoToAnalyze]; % might need a '.avi' for windows

[pathstr,name,ext] = fileparts(vidToLoad);

OFSaveName = ['OF-FullFile-' name '__' sprintf('%02d',AnalysisNumber)];

%% Readin in Video and calculatate optic flow 

VideoObj = VideoReader(vidToLoad, 'Tag', 'CurrentVideo');

nFrames = VideoObj.NumberOfFrames;
VideoFrameRate = VideoObj.FrameRate;
vidHeight = VideoObj.Height;
vidWidth = VideoObj.Width;
vidFormat = VideoObj.VideoFormat;

videoReader = vision.VideoFileReader(vidToLoad,'ImageColorSpace','Intensity','VideoOutputDataType','uint8'); % create required video objects
converter = vision.ImageDataTypeConverter; 
opticalFlow1 = vision.OpticalFlow('Method','Lucas-Kanade','ReferenceFrameDelay', 1);% use of the Lucas-Kanade method for optic flow determination 
opticalFlow2 = vision.OpticalFlow('Method','Lucas-Kanade','ReferenceFrameDelay', 1);% use of the Lucas-Kanade method for optic flow determination 
opticalFlow1.OutputValue = 'Horizontal and vertical components in complex form';
opticalFlow2.OutputValue = 'Horizontal and vertical components in complex form';
mCnt = 1;
disp('Extracting frames and calculating the optic flow...')
close all
%%
FrameOn = 1;
FrameOff = nFrames;

for frame_ind = FrameOn+1 : FrameOff
    mov(mCnt).cdata = read(VideoObj,frame_ind);
    frame = mov(mCnt).cdata;
    %frame = frame / median(frame(:)); % normalize?
    
    im = step(converter, frame);
    if mCnt == 1
        figure(1)
        imshow(im) %open the first frame
        disp('Select 1st ROI')
        rectim1 = getrect; %choose 1st ROI
        rectim1=ceil(rectim1); 
        figure(2)
        imshow(im) %open the first frame
        disp('Select 2nd ROI')
        drawnow;
        rectim2 = getrect; %choose 2nd ROI
        rectim2=ceil(rectim2);
    end
    im1 = im(rectim1(2):rectim1(2)+rectim1(4),rectim1(1):rectim1(1)+rectim1(3)); %choose this ROI part of the frame to calculate the optic flow
    im2 = im(rectim2(2):rectim2(2)+rectim2(4),rectim2(1):rectim2(1)+rectim2(3));
    of1 = step(opticalFlow1, im1);
    of2 = step(opticalFlow2, im2);
    V1=abs(of1); % lenght of the velocity vector
    V2=abs(of2); % lenght of the velocity vector
    meanV1=mean(mean(V1)); %mean velocity for every pixel 
    meanV2=mean(mean(V2)); %mean velocity for every pixel 
    fV1(mCnt)=meanV1;
    fV2(mCnt)=meanV2;
    mCnt =mCnt +1;
    disp(strcat('Frame: ',num2str(frame_ind ),' is done'))
end
fV1(1)=0;% suppress the artifact at the first frame 
fV2(1)=0; 

%% Plot the optic flow with a moving line
fV1a=fV1./(max(max(fV1)));

%fV_small = fV1;
fV_small = fV1a;

fV2a=fV2./(max(max(fV2)));

fV_large = fV2a;
%fV_large = fV2;


figure(106); clf
subplot(6, 1, 1)
plot(fV_small)
grid on
axis tight
%xlabel('Frames')
title('Raw OF-Small ROI')


hold on
%plot(fV_small+1)
subplot(6, 1, 2)
plot(fV_large)
grid on
axis tight
title('Raw OF-Large ROI')
%legend('Large ROI', 'Small ROI')
xlabel('Frames')



%% detrending

L = detrend(fV_large);
F = detrend(fV_small);

subplot(6, 1, 2)
plot(L)
hold on
plot(F+1)
%plot(F+0.12)
grid on
axis tight
legend('Large ROI', 'Small ROI')
xlabel('Frames')
title('Detrended')

%% coherence

Fs = 20; % frame rate

% Coherence
[Cxy,f] = mscohere(F,L,[],[],[],Fs);

subplot(5, 1, 3)
plot(f,Cxy);
xlabel('Frequency');
ylabel('Coherence');
title('Flicker Coupling');

%% Notch filter - doesnt seem to work

%{
f0 = 0.5;         % Flicker frequency to remove (Hz)

Q = 50;           % Quality factor
                 % Higher Q = narrower notch
                 
bw = f0/Q;

% Design notch filter
d = designfilt('bandstopiir', ...
    'FilterOrder', 2, ...
    'HalfPowerFrequency1', f0-bw/2, ...
    'HalfPowerFrequency2', f0+bw/2, ...
    'DesignMethod', 'butter', ...
    'SampleRate', Fs);

L_double = double(L);
% Apply zero-phase filtering
signalFiltered = filtfilt(d, L_double);

subplot(5, 1, 4); cla
plot(signalFiltered)


freqs = [0.5 1.0 1.5 2.0, 2.5, 3.0, 3.5, 4.0];

L_double = double(L);
filtered = L_double;

for k = 1:length(freqs)

    f0 = freqs(k);

    d = designfilt('bandstopiir', ...
        'FilterOrder',2, ...
        'HalfPowerFrequency1',f0-0.03, ...
        'HalfPowerFrequency2',f0+0.03, ...
        'SampleRate',Fs);

    filtered = filtfilt(d, filtered);
end
figure; 
plot(filtered)
%}

%% regression



% Column vectors
L = L';
F = F';

% Linear regression
X = [ones(size(F)) F];


b = X \ L;

%b = robustfit(F, L);
%L_flicker = b(1) + b(2)*F;

L_clean = L - L_flicker + b(1);
L_clean = L/F;

% Predicted flicker component
L_flicker = X*b;
subplot(5, 1, 4);
plot(L_flicker);
axis tight
title('Flicker')


% Remove flicker contribution
L_clean = L - L_flicker + b(1);

% Plot

%plot(L,'b');
subplot(5, 1, 5);
hold on
figure
plot(L_clean,'b','LineWidth',1);

%legend('Raw','Cleaned');
xlabel('Frame');
ylabel('Optic Flow');
title('Regression-Based Flicker Removal');


%%
figure(103); clf
subplot(2, 1, 1)
%plot(xes_s, fV1a)
plot(fV1a)
axis tight
lightFlicker = 0.7;
bla = find(fV1a >= lightFlicker);
fV1aa = fV1a;
fV1aa(bla) = NaN;

subplot(2, 1, 2)
plot(fV1aa)
%plot(xes_s, fV1aa)
axis tight
%%

figure(104); clf
subplot(2, 1, 1)
%plot(xes_s, fV1a)
plot(fV2a)
bla = find(fV2a >= lightFlicker);
fV2aa = fV2a;
fV2aa(bla) = NaN;

subplot(2, 1, 2)
%plot(xes_s, fV1aa)
plot(fV1aa)

%%
figure(105); clf
subplot(2, 1, 1)
plot(fV1aa)

subplot(2, 1, 2)
plot(fV2aa)


figure; 
xlim([0 100])
xlabel('Time (s)')

keyboard

figure; 
subplot(2, 1, 1)
plot(smooth(fV1, 20))
subplot(2, 1, 2)
plot(smooth(fV2, 20))



redcolor = [150 50 0];
bluecolor = [0 50 150];

redcolorline = [150 50 0]/255;
bluecolorline = [0 50 150]/255;

timepoints = (FrameOn+1:1:FrameOff); %in s

close all

fig100= figure(100); plot(fV1)
fcnt = 1;

for p = 1:numel(timepoints)
    cla
   
    plot(timepoints, fV1, 'color', bluecolorline)
    %plot(timepoints, smooth(fV1, smoothWin) , 'color', bluecolorline)
    
    hold on
    line([timepoints(p),timepoints(p)], [0 1], 'color', [0 0 0])
    axis tight
    %ylim([0 .3])
    ax = gca;
    ax.Units = 'pixels';
    pos = ax.Position;
    ti = ax.TightInset;
    rect = [-ti(1), -ti(2), pos(3)+ti(1)+ti(3)+20, pos(4)+ti(2)+ti(4)];
    F1(fcnt) = getframe(ax,rect);
    fcnt = fcnt+1;
end

close(fig100)

fV2=fV2./(max(max(fV2)));

fig200 = figure(200); plot(fV2)
fcnt = 1;

for p = 1:numel(timepoints)
    cla
    plot(timepoints, fV2, 'color', redcolorline)
    hold on
   line([timepoints(p),timepoints(p)], [0 1], 'color', [0 0 0])
    axis tight
    %ylim([0 .3])
    xlabel('Time [s]')
    ax = gca;
    ax.Units = 'pixels';
    pos = ax.Position;
    ti = ax.TightInset;
    rect = [-ti(1), -ti(2), pos(3)+ti(1)+ti(3)+20, pos(4)+ti(2)+ti(4)];
    F2(fcnt) = getframe(ax,rect);
    fcnt = fcnt+1;
end
close(fig200);


OF.fV1 = fV1;
OF.fV2 = fV2;

save([pathstr dirD 'OF-' OFSaveName '__ROIs.mat'], 'OF');

%% Saving
plot_filenameVid = [pathstr dirD 'OF_VID-' name '.avi'];

vid1 = VideoReader(vidToLoad, 'Tag', 'CurrentVideo');
outputVideo = VideoWriter(plot_filenameVid);
outputVideo.FrameRate = VideoFrameRate ; 
open(outputVideo);

%shapeInserter1 = vision.ShapeInserter('Shape','Rectangles','BorderColor','Custom','LineWidth',2.5,'CustomBorderColor',int32([0 0 255]));
shapeInserter1 = vision.ShapeInserter('Shape','Rectangles','BorderColor','Custom','LineWidth',2.5,'CustomBorderColor',int32(bluecolor));
shapeInserter2 = vision.ShapeInserter('Shape','Rectangles','BorderColor','Custom','LineWidth',2.5,'CustomBorderColor',int32(redcolor));
rectim1 = int32(rectim1);
rectim2 = int32(rectim2);

%% create a nice video output by concatenating images 
 disp('Optic flow frame grabbing')
 
i=1;
for frame_ind = FrameOn+1 : FrameOff -1
    img1 = read(vid1,frame_ind);
    img1 = step(shapeInserter1,img1,rectim1); %insert the ROIs
    img1 = step(shapeInserter2,img1,rectim2); %insert the ROIs
    
    img2 = F1(i).cdata;
    img3 = F2(i).cdata;
    img2 = imresize(img2,[size(F2(1).cdata,1) size(F2(1).cdata,2)]);
   
    img4 = vertcat(img2,img3);
    scale=size(img4,1)/size(img1,1);
    img5 = imresize(img1,scale);
    img5 = imresize(img5,[size(img4,1) size(img5,2)]);
    imgf = horzcat(img5,img4);

    % play video
    %step(videoPlayer, imgt);

    % record new video
    writeVideo(outputVideo, imgf);
    i=i+1;
end
close(outputVideo);


end