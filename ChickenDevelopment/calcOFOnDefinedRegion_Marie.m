function [] = calcOFOnDefinedRegion_Marie()

dbstop if error

VidDir = '/home/janie/Data/TUM/IRSleep/2018-Dec-10/';
videoToAnalyze = 'IR-001-cam1-2018-Dec-10.avi';

AnalysisNumber = 5;

%%

OFDir = [VidDir 'OF_Analysis/'];

if exist(OFDir, 'dir') == 0
    mkdir(OFDir);
end

%%

%{
searchString = '*.avi*';
files = dir(fullfile(VidDir, searchString));

nFiles = numel(files);
DssVidFile = [];

if nFiles  == 0
    disp('Could not find a video file, quitting...')
    keyboard
    
elseif nFiles >= 1
    DssVidFile = [];
    for j = 1:nFiles
        thisFile = files(j).name;
        
        match = strcmpi(thisFile(end-3:end), '.avi');
        if match == 1
            DssVidFile = thisFile;
            continue
        end
    end
    
    if isempty(DssVidFile)
        disp('No file could be found')
        keyboard
    end
    
end
%}
%% Load Video

vidToLoad = [VidDir videoToAnalyze];

[pathstr,name,ext] = fileparts(vidToLoad);

OFSaveName = ['OF-FullFile-' name '__' sprintf('%02d.mat',AnalysisNumber)];

%%
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

FrameOn = 1;
FrameOff = nFrames-1;

mov = struct('cdata',[],'colormap',[]);
for frame_ind = FrameOn+1 : FrameOff+1
    
    mov(mCnt).cdata = read(VideoObj,frame_ind);
    frame = mov(mCnt).cdata;
    im = step(converter, frame);
    if mCnt == 1
        figure
        imshow(im) %open the first frame
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
    mCnt =mCnt +1;
    disp(strcat('Frame: ',num2str(frame_ind ),' is done'))
end

fV1(1)=0;% suppress the artifact at the first frame


save([OFDir OFSaveName], 'fV1', 'rectim1', 'im');

disp(['Saved: ' [OFDir OFSaveName]])


end
