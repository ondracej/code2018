classdef chronoAnalysis_Obj < handle
    
    
    properties (Access = public)
        
        HOST
        PATH
    end
    
    methods
        
        
        function obj = getVideoInfo(obj,vidPath)
            
            disp('Getting video info...')
            
            obj.HOST.hostname = gethostname;
            
            if ispc
                dirD = '\';
            else
                dirD = '/';
            end
            
            obj.HOST.dirD = dirD;
            obj.PATH.VidPath = vidPath;
            [pathstr,name,ext] = fileparts(vidPath{:});
            
            editedVidPath = [pathstr dirD 'editedVids' dirD];
            
            if exist(editedVidPath, 'dir') ==0
                mkdir(editedVidPath);
                disp(['Created directory: ' editedVidPath])
            end
            
            obj.PATH.editedVidPath = editedVidPath;
            
        end
        
        
        %%
        function [] = makeMultipleMoviesFromImages(obj, imageDir, movieName, saveDir, VideoFrameRate)
            
            
            fileFormat = 2; % (1)- tif, (2) -.jpg
            
            %%
            switch fileFormat
                case 1
                    imgFormat = '*.tiff';
                case 2
                    imgFormat = '*.jpg';
                case 3
                    imgFormat = '*';
            end
            
            imageNames = dir(fullfile(imageDir{:},imgFormat));
            %imageNames(1) = [];
            %imageNames(1) = [];
            imageNames = {imageNames.name}';
            
            nImags = numel(imageNames);
            underscore = '_';
            period = '.';
            
            
            endingTxt_dbl = [];
            for o = 1:nImags
                underscoreInd = find(imageNames{o} == underscore);
                periodInd = find(imageNames{o} == period);
                %endingTxt_dbl(o) = str2double(imageNames{o}(underscoreInd(end)+1:periodInd(1)-1));
                endingTxt_dbl(o) = str2double(imageNames{o}(4:periodInd(1)-1));
            end
            
            [bla, inds] = sort(endingTxt_dbl, 'ascend');
            
            resortedNames = imageNames(inds);
            
            FrameCut = 2*VideoFrameRate*60*60; % 2 hour
            
            if nImags > FrameCut;
                tOn = 1:FrameCut:nImags;
                nParts = numel(tOn);
            else
                tOn = 1;
                nParts = 1;
            end
            
            for q = 1:nParts
                
                FrameOn = tOn(q);
                FrameOff = tOn(q)+FrameCut;
                
                if q== nParts
                    FrameOff =nImags;
                end
                
                %%
                movName = [saveDir{:} movieName '_' sprintf('%03d',q)];
                %% Create Output Video
                outputVideo = VideoWriter(fullfile(movName));
                outputVideo.FrameRate = 10;
                open(outputVideo)
                
                %% Read in Frames
                tic
                for f = FrameOn:FrameOff-1
                    img = imread([imageDir{:} resortedNames{f}]);
                    
                    if fileFormat == 1
                        img2 = im2uint8(img); % need to convert for .tif files
                    elseif fileFormat ==2
                        img2 = img;
                    elseif fileFormat ==3
                        img2 = img;
                    end
                    writeVideo(outputVideo,img2)
                    disp(['Frame: ' num2str(f) '/' num2str(nImags)]);
                    
                end
                toc
                
                %%
                close(outputVideo);
                disp(['Created Video: ' movName]);
            end
        end
        
        
        
        
        %%
        
        function [] = calcOFOnDefinedRegion_DS_multipleFilesInDir(obj, dsFrameRate, vidDir, vidFrameRate, saveTag)
            
            
            vidNames = dir(fullfile(vidDir,'*.avi'));
            vidNames = {vidNames.name}';
            
            nVids = numel(vidNames);
            OFDir = [vidDir 'OF_DS' ];
            
            if exist(OFDir, 'dir') ==0
                mkdir(OFDir);
                disp(['Created directory: ' OFDir])
            end
            
            cnt = 1;
            for o = 1:nVids
                
                %% Load Video
                
                vidToLoad = [vidDir vidNames{o}];
                [pathstr,name,ext] = fileparts(vidToLoad);
                OFSaveName = ['OF-' name saveTag];
                
                %%
                VideoObj = VideoReader(vidToLoad, 'Tag', 'CurrentVideo');
                
                nFrames = VideoObj.NumberOfFrames;
                %VideoFrameRate = VideoObj.FrameRate;
                VideoFrameRate = vidFrameRate;
                vidHeight = VideoObj.Height;
                vidWidth = VideoObj.Width;
                vidFormat = VideoObj.VideoFormat;
                
                
                frameSkip = VideoFrameRate/dsFrameRate;
                
                %thisStart = 1;
                %thisStop = nFrames;
                
                %movieLengthFull = thisStop-thisStart;
                %newNFrames = floor(movieLengthFull/frameSkip);
                
                
                %% if more than 10000 frames...
                %             FrameCut = VideoFrameRate*60*60; % 1 hour
                
                %             if nFrames > FrameCut
                %                 tOn = 1:FrameCut:nFrames;
                %                 nParts = numel(tOn);
                %             else
                %tOn = 1;
                %nParts = numel(tOn);
                %             end
                %%
                videoReader = vision.VideoFileReader(vidToLoad,'ImageColorSpace','Intensity','VideoOutputDataType','uint8'); % create required video objects
                converter = vision.ImageDataTypeConverter;
                opticalFlow1 = vision.OpticalFlow('Method','Lucas-Kanade','ReferenceFrameDelay', 1);% use of the Lucas-Kanade method for optic flow determination
                opticalFlow1.OutputValue = 'Horizontal and vertical components in complex form';
                
                disp('Extracting frames and calculating the optic flow...')
                
                FrameOn = 1;
                FrameOff =nFrames;
                
                %                 if p== nParts
                %                     FrameOff =nFrames;
                %                 end
                
                mCnt = 1;
                
                mov = struct('cdata',[],'colormap',[]);
                for frame_ind = FrameOn : frameSkip: FrameOff
                    
                    mov(mCnt).cdata = read(VideoObj,frame_ind);
                    frame = mov(mCnt).cdata;
                    im = step(converter, frame);
                    if cnt == 1
                        figure
                        figH = imshow(im); %open the first frame
                        %disp('Select 1st ROI')
                        
                        %% Define ROI
                        
                        rectim1 = getrect; %choose right eye ROI
                        %rectim1 = getline;
                        rectim1=ceil(rectim1);
                        %[BW, xi, yi] = roipoly;
                        
                        %Hardcoded
                        %disp('Using hardcoded ROI')
                        %rectim1 =  [5 243 958 576];
                        
                    end
                    im1 = im(rectim1(2):rectim1(2)+rectim1(4),rectim1(1):rectim1(1)+rectim1(3)); %choose this ROI part of the frame to calculate the optic flow
                    
                    %imshow(im1);
                    of1 = step(opticalFlow1, im1);
                    V1=abs(of1); % lenght of the velocity vector
                    meanV1=mean(mean(V1)); %mean velocity for every pixel
                    fV1(mCnt)=meanV1;
                    mCnt = mCnt +1;
                    cnt = cnt + 1;
                    disp(strcat('Frame: ',num2str(frame_ind ),' is done'))
                end
                
                fV1(1)=0; % suppress the artifact at the first frame
                %save([OFDir OFSaveName '_pt-' sprintf('%02d',o) '.mat'], 'fV1', 'rectim1', 'im');
                save([OFDir OFSaveName '.mat'], 'fV1', 'rectim1', 'im');
                disp(['Saved' [OFDir OFSaveName '.mat']])
                clear('fV1');
            end
            
        end
        
    end
    
    %%
    
    
    
    methods (Hidden)
        %class constructor
        function obj = chronoAnalysis_Obj(vidPath)
            
            
            obj = getVideoInfo(obj, vidPath);
            
            
        end
    end
    
end

