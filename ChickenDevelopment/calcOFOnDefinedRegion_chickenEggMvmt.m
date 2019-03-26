function [] = calcOFOnDefinedRegion_chickenEggMvmt()

dbstop if error

VidDir = 'C:\Data\SleepData\chickens\2019-Mar-19\';
videoToAnalyze = 'chickens-008-cam1-2019-Mar-19';

AnalysisNumber = 1;

%%

OFDir = [VidDir 'OF_Analysis\'];

if exist(OFDir, 'dir') == 0
    mkdir(OFDir);
end

%%

%% Load Video

%vidToLoad = [VidDir videoToAnalyze '.avi'];
vidToLoad = [VidDir videoToAnalyze];

[pathstr,name,ext] = fileparts(vidToLoad);

OFSaveName = ['OF-FullFile-' name '__' sprintf('%02d',AnalysisNumber)];

%%
VideoObj = VideoReader(vidToLoad, 'Tag', 'CurrentVideo');

nFrames = VideoObj.NumberOfFrames;
VideoFrameRate = VideoObj.FrameRate;
vidHeight = VideoObj.Height;
vidWidth = VideoObj.Width;
vidFormat = VideoObj.VideoFormat;

FrameCut = 5000;

disp('')
if nFrames > FrameCut;
    
    tOn = 1:FrameCut:nFrames;
    nParts = numel(tOn);
end

videoReader = vision.VideoFileReader(vidToLoad,'ImageColorSpace','Intensity','VideoOutputDataType','uint8'); % create required video objects
converter = vision.ImageDataTypeConverter;
opticalFlow1 = vision.OpticalFlow('Method','Lucas-Kanade','ReferenceFrameDelay', 1);% use of the Lucas-Kanade method for optic flow determination
opticalFlow2 = vision.OpticalFlow('Method','Lucas-Kanade','ReferenceFrameDelay', 1);% use of the Lucas-Kanade method for optic flow determination
opticalFlow1.OutputValue = 'Horizontal and vertical components in complex form';
opticalFlow2.OutputValue = 'Horizontal and vertical components in complex form';
mCnt = 1;
cnt =1;

for p = 1:nParts
   
    FrameOn = tOn(p);
    FrameOff = tOn(p)+FrameCut-1;
    
    if p== nParts
        FrameOff =nFrames;
    end
    
    mov = struct('cdata',[],'colormap',[]);
    for frame_ind = FrameOn+1 : FrameOff+1
        
        mov(mCnt).cdata = read(VideoObj,frame_ind);
        frame = mov(mCnt).cdata;
        im = step(converter, frame);
        if mCnt == 1
            figure
            imshow(im) %open the first frame
            
            disp('Define the ROI')
            
            %% Define ROI
            rectim1 = getrect; %choose right eye ROI
            rectim1=ceil(rectim1);
    
            disp('Extracting frames and calculating the optic flow...')
        end
        
        im1 = im(rectim1(2):rectim1(2)+rectim1(4),rectim1(1):rectim1(1)+rectim1(3)); %choose this ROI part of the frame to calculate the optic flow
        of1 = step(opticalFlow1, im1);
        V1=abs(of1); % lenght of the velocity vector
        meanV1=mean(mean(V1)); %mean velocity for every pixel
        fV1(cnt)=meanV1;
        mCnt =mCnt +1;
        cnt = cnt+1;
        
        disp(strcat('Frame: ',num2str(frame_ind ),' is done'))
        
    end
    
    disp('')
    
    fV1(1)=0; % suppress the artifact at the first frame
    save([OFDir OFSaveName '_pt-' sprintf('%02d',p) '.mat'], 'fV1', 'rectim1', 'im');
    clear('fV1');
    cnt =1;
end

disp('')

end
