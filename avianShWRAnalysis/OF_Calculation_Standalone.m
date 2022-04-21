%function [] = OF_Calculation_Standalone()

close all
clear all
dbstop if error

%vidToLoad = 'G:\SWR\ZF-71-76_Final\20190920\18-37-00\Videos\ZF-71-76__18-37-14__1142674_Zoom2_00026.avi';
%nFrames = 1142674;

vidToLoad = 'G:\SWR\ZF-71-76_Final\20190923\18-21-42\Videos\ZF-71-76__18-21-54__1147854_Zoom2_00027.avi';
nFrames = 1147854;

video_fps = 20;
ds_fps = 1;
frameSkip = video_fps/ds_fps;

StartingAlignmentTime  = '19:00:00'; % Must be the next even time
StartingClockTime = '18:21:54'; % Must be the next even time


%% if more than 10000 frames...

if nFrames > 10000
    FrameCut = 60*60*ds_fps; % 1 hour
    tOn = 1:FrameCut:nFrames;
    nParts = numel(tOn);
else
    tOn = 1;
    nParts =1;
end


[pathstr,name,ext] = fileparts(vidToLoad);

slash = '\';
bla = find(pathstr == slash);

RecName = pathstr(bla(3)+1:bla(5)-1);
bla = find(RecName == slash);
RecName(bla) = '_';


OFSaveName = ['OF-FullFile-' name];

OFDir = [pathstr '\OF_DS\'];

if exist(OFDir, 'dir') ==0
    mkdir(OFDir);
    disp(['Created directory: ' OFDir])
end

%% Load Video


%%
VideoObj = VideoReader(vidToLoad, 'Tag', 'CurrentVideo');

vidHeight = VideoObj.Height;
vidWidth = VideoObj.Width;
vidFormat = VideoObj.VideoFormat;

%%
videoReader = vision.VideoFileReader(vidToLoad,'ImageColorSpace','Intensity','VideoOutputDataType','uint8'); % create required video objects
converter = vision.ImageDataTypeConverter;
opticalFlow1 = vision.OpticalFlow('Method','Lucas-Kanade','ReferenceFrameDelay', 1);% use of the Lucas-Kanade method for optic flow determination
opticalFlow1.OutputValue = 'Horizontal and vertical components in complex form';


disp('Extracting frames and calculating the optic flow...')
cnt = 1;
for p = 1:nParts
    
    FrameOn = tOn(p);
    FrameOff = tOn(p)+FrameCut;
    
    if p== nParts
        FrameOff =nFrames;
    end
    
    mCnt = 1;
    
    mov = struct('cdata',[],'colormap',[]);
    for frame_ind = FrameOn : frameSkip: FrameOff
        
        mov(mCnt).cdata = read(VideoObj,frame_ind);
        frame = mov(mCnt).cdata;
        im = step(converter, frame);
        if cnt == 1
            
            test_frame = read(VideoObj,50);
            
            test_Im = step(converter, test_frame);
            
            figure
            
            imshow(test_Im) %open the first frame
            %disp('Select 1st ROI')
            
            %% Define ROI
            rectim1 = getrect; %choose right eye ROI
            rectim1=ceil(rectim1);
            
            %Hardcoded
            %disp('Using hardcoded ROI')
            %rectim1 =  [5 243 958 576];
            
        end
        im1 = im(rectim1(2):rectim1(2)+rectim1(4),rectim1(1):rectim1(1)+rectim1(3)); %choose this ROI part of the frame to calculate the optic flow
        of1 = step(opticalFlow1, im1);
        V1=abs(of1); % lenght of the velocity vector
        meanV1=mean(mean(V1)); %mean velocity for every pixel
        fV1(mCnt)=meanV1;
        mCnt = mCnt +1;
        cnt = cnt + 1;
        disp(strcat('Frame: ',num2str(frame_ind ),' is done'))
    end
    
    fV1(1)=0; % suppress the artifact at the first frame
    save([OFDir OFSaveName '_pt-' sprintf('%02d',p) '.mat'], 'fV1', 'rectim1', 'im');
    clear('fV1');
end

%%

%vidsToAnalyze = {'C:\Users\Janie\Documents\Data\Video\18_02_2020_ROI.avi'};
%detectionsDir = 'C:\Users\Janie\Documents\Data\Video\editedVids\OF_DS-18_02_2020_ROI\';


dsFrameRate = 1;
%V_OBJ = videoAnalysis_OBJ(vidsToAnalyze);

%%
%function [] = loadOFDetectionsAndMakePlot(obj, detectionsDir, dsFrameRate, StartingClockTime, StartingAlignmentTime )


searchtxt = '*OF*';

filesInDir = dir(fullfile(OFDir, searchtxt));
nFilesinDir = numel(filesInDir);

for j=1:nFilesinDir
    fileNames{j} = filesInDir(j).name;
end

% VidNameShort = fileNames{1}(end-18:end-11);

%% Concatenate
fV1 = [];
for j = 1: nFilesinDir
    
    OF = load([OFDir fileNames{j}]);
    %fV1 = [fV1 OF.fV1];
    fV1{j} = OF.fV1;
    
end

FV = cell2mat(fV1);

%               figure;
%               subplot(1, 2, 1)
%               plot(fV1)
%               subplot(1, 2, 2)
%               plot(fV2)



fV1_norm = FV./(max(max(FV)));


%% Assumes a fps of 1 fps

%smooth_s = 10*60; % 1 minute smooth
smooth_s = 30; % 30s smooth

smoothWin = smooth_s*ds_fps;
smoothedOF = smooth(fV1_norm, smoothWin);

%%
timepoints_x = 1:1:numel(fV1_norm);
timepoints_x = timepoints_x/ds_fps;
timepoints_hrs = timepoints_x/3600; % 1 hr


%timepoints_s = 1:1:numel(fV1_norm);
%timepoints_hrs = timepoints_s/3600;

%%


colon = ':';
sInMin = 60;
minInHr = 60;
sInHr = sInMin*minInHr;
Day_24Hr = 24;
zero = 0;

thisStr = StartingAlignmentTime;
match = find(thisStr == colon);

Alignment_s_vid = str2double(thisStr(match(2)+1:end));
Alignment_mins_vid = str2double(thisStr(match(1)+1:match(2)-1));
Alignment_hrs_vid = str2double(thisStr(1:match(1)-1));

thisStr = StartingClockTime;
match = find(thisStr == colon);

FirstStart_s_vid = str2double(thisStr(match(2)+1:end));
FirstStart_mins_vid = str2double(thisStr(match(1)+1:match(2)-1));
FirstStart_hrs_vid = str2double(thisStr(1:match(1)-1));

Alignment_diff_s = FirstStart_s_vid - Alignment_s_vid;

Alignment_diff_s_cnt = 0;
if Alignment_diff_s > 0
    FirstStart_mins_vid = FirstStart_mins_vid+1;
    Alignment_diff_s_cnt = sInMin - Alignment_diff_s;
else
    Alignment_diff_s_cnt = Alignment_diff_s;
end

diff_min = minInHr - FirstStart_mins_vid;

if diff_min > 0
    FirstStart_hrs_vid = FirstStart_hrs_vid +1;
    Alignment_diff_s_for_min = diff_min*sInMin;
    Alignment_diff_s_cnt = Alignment_diff_s_for_min + Alignment_diff_s_cnt;
end


%
%             diff_hr = FirstStart_hrs_vid - Alignment_hrs_vid;
%
%             if diff_hr < 0
%
%                 %Alignment_diff_min_for_hrs = (minInHr - diff_min)*sInMin;
%                 Alignment_diff_s_for_hrs = abs(diff_hr)*minInHr*sInMin;
%                 Alignment_diff_s_cnt = Alignment_diff_s_cnt +Alignment_diff_s_for_hrs;
%             elseif diff_hr > 0
%                 disp('please choose a later start time')
%                 keyboard
%             end

nSecondsToFirstAlignment = Alignment_diff_s_cnt;

xtickts = nSecondsToFirstAlignment:sInHr:numel(fV1_norm);

xLab_pt1 = Alignment_hrs_vid:1:24;
xLab_pt2  = 1:1:24;
xlabs_n = [xLab_pt1 xLab_pt2 xLab_pt2 xLab_pt2];

theseLabs = xlabs_n(1:numel(xtickts));

xlabs = [];
for k = 1:numel(xtickts)
    xlabs{k} = [num2str(theseLabs(k)) ':00'];
end


%%
figH = figure(400); clf
subplot(3, 3, [7 8])

plot(timepoints_hrs, fV1_norm, 'color', [0.7 0.7 0.7]);
hold on
plot(timepoints_hrs, smoothedOF, 'k', 'linewidth', 1.5)

axis tight
set(gca, 'xtick', xtickts/sInHr);
set(gca, 'xtickLabel',  xlabs)
xlabel('Time [Hr]')
ylabel('Normalized OF')
%title([VidNameShort ' | Normalized OF, 1s | smooth = ' num2str(smooth_s) ' s'])
%%

saveName = [OFDir RecName '_OF-DSs1'];
%plotpos = [0 0 25 12];
plotpos = [0 0 30 15];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);



%% Save concat OF

bluecolor = [0 50 150];
shapeInserter1 = vision.ShapeInserter('Shape','Rectangles','BorderColor','Custom','LineWidth',2.5,'CustomBorderColor',int32(bluecolor));
img1 = step(shapeInserter1,OF.im,OF.rectim1); %insert the ROIs

figure(103); clf
image(img1)
axis off
% title(['Video: ' VidNameShort])

saveName = [OFDir RecName '_ROI-Image'];
plotpos = [0 0 15 12];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);

%% Clock Info

F.fV1_norm = fV1_norm;
F.smoothedOF = smoothedOF;
F.timepoints_s = timepoints_x;
F.timepoints_hrs = timepoints_hrs;
F.StartingClockTime = StartingClockTime;
F.StartingAlignmentTime = StartingAlignmentTime;
F.xticks = xtickts;
F.xlabs = xlabs;
F.rectim1  = OF.rectim1;
F.im  = OF.im;
F.video_fps = video_fps;
F.ds_fps = ds_fps;
F.frameSkip = frameSkip;

save([OFDir  RecName '_OF-fullFile.mat'], 'F');

%%
