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
        
        
        
        
        function [] = loadOFDetectionsAndMakePlot(obj, detectionsDir, dsFrameRate, StartingClockTime, StartingAlignmentTime, VidTag )
            
            
            searchDir = '*OF*';
            
            filesInDir = dir(fullfile(detectionsDir, searchDir));
            nFilesinDir = numel(filesInDir);
            
            for j=1:nFilesinDir
                fileNames{j} = filesInDir(j).name;
            end
            
            %VidNameShort = fileNames{1}(end-18:end-11);
            VidNameShort = VidTag;
            %% Concatenate
            fV1 = [];
            for j = 1: nFilesinDir
                
                OF = load([detectionsDir fileNames{j}]);
                fV1 = [fV1 OF.fV1];
                
            end
            
            %               figure;
            %               subplot(1, 2, 1)
            %               plot(fV1)
            %               subplot(1, 2, 2)
            %               plot(fV2)
            
            
            
            fV1_norm = fV1./(max(max(fV1)));
            
            
            %% Assumes a fps of 1 fps
            
            smooth_s = 1*60; % 1 minute smooth
            
            smoothWin = smooth_s*dsFrameRate;
            smoothedOF = smooth(fV1_norm, smoothWin);
            
            %%
            timepoints_x = 1:1:numel(fV1_norm);
            %timepoints_x = timepoints_x;
            timepoints_hrs = timepoints_x/3600;
            
            
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
            %subplot(4, 1, 1)
            
            plot(timepoints_hrs, fV1_norm, 'color', [0.7 0.7 0.7]);
            hold on
            plot(timepoints_hrs, smoothedOF, 'k', 'linewidth', 1.5)
            
            axis tight
            set(gca, 'xtick', xtickts/sInHr);
            set(gca, 'xtickLabel',  xlabs)
            xlabel('Time [Hr]')
            ylabel('Normalized OF')
            title([VidNameShort ' | Normalized OF, 1s | smooth = ' num2str(smooth_s) ' s'])
            %%
            %OFImg = getframe(figH);
            %im = OF.im;
            %image(im)
            %FImg = getframe(figH);
            %hcat = horzcat([OFImg.cdata FImg.cdata]);
            %image(hcat)
            ylim([0 0.25])
            
            saveName = [obj.PATH.editedVidPath  VidNameShort '_OF_DSs1'];
            %plotpos = [0 0 25 12];
            plotpos = [0 0 30 12];
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
            print_in_A4(0, saveName, '-depsc', 0, plotpos);
            
            
            
            %% Save concat OF
            
            bluecolor = [0 50 150];
            shapeInserter1 = vision.ShapeInserter('Shape','Rectangles','BorderColor','Custom','LineWidth',2.5,'CustomBorderColor',int32(bluecolor));
            img1 = step(shapeInserter1,OF.im,OF.rectim1); %insert the ROIs
            
            figure(103); clf
            image(img1)
            axis off
            title(['Video: ' VidNameShort])
            
            saveName = [obj.PATH.editedVidPath  VidNameShort '_ROI_img'];
            plotpos = [0 0 15 12];
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
            
            %% Clock Info
            Clock.StartingClockTime = StartingClockTime;
            
            rectim1 = OF.rectim1;
            im = OF.im;
            save([obj.PATH.editedVidPath  VidNameShort '_OF_DSs1_fullFile.mat'], 'fV1', 'fV1_norm', 'img1', 'im', 'rectim1', 'dsFrameRate', 'Clock');
            clear('fV1');
            
            %%
            
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

