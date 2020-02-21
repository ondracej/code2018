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
            
            
            fileFormat = 3; % (1)- tif, (2) -.jpg
            
            %%
            switch fileFormat
                case 1
                    imgFormat = '*.tiff';
                case 2
                    imgFormat = '*.jpg';
                case 3
                    imgFormat = '*.jpg';
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
            
            if nImags > FrameCut
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
                        
                        grayImage = rgb2gray(img);
                        %imshow(grayImage, []);
                        %pout_imadjust = imadjust(grayImage );
                        %pout_histeq = histeq(grayImage);
                        pout_histeq = adapthisteq (grayImage);
                        %figure; imshow(grayImage); title('original')
                        %figure; imshow(pout_imadjust); title('contrast')
                        %figure; imshow(pout_histeq); title('histeq')
                        
                        %J = filter2(fspecial('sobel'),grayImage);
                        imshow(pout_histeq)
                        ax = gca;
                        ax.Units = 'pixels';
                        img2 = getframe(ax);
                        img2 = img2.cdata;
                        
                        %figure; imshow(img2)
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
        
        
        
        
        function [] = extractMvmtFromOF(obj, OFPath)
            
            fileToLoad = OFPath;
            
            d = load(fileToLoad);
            
            
            fv = d.fV1;
            fvN = fv./(max(max(fv))); % normalize between 1 and 0
            sortedVals = sort(fvN, 'ascend');
            
            percentile4ScaleEstimation = 95; % we choose a threhsold of 95% of the sorted data
            scaleEstimator_thresh =sortedVals(round(percentile4ScaleEstimation/100*numel(sortedVals)));
            
            figure; clf
            plot(fvN)
            hold on
            line([0 numel(fvN)], [scaleEstimator_thresh scaleEstimator_thresh], 'color', 'r')
            
            
            figure; plot(sortedVals)
            
            fps = 1;
            
            timeWin_min = 6;
            timeWin_s  = timeWin_min *60;
            
            
            %bin all data into 6 min bins
            
            tOn = 1:timeWin_s:numel(fvN);
            nBatches = numel(tOn);
            for i = 1:nBatches
                
                if i == nBatches
                    thisData = fvN(tOn(i):numel(fvN));
                else
                    thisData = fvN(tOn(i):tOn(i)+timeWin_s-1);
                end
                
                
                
                threshCrossInds = find(thisData >= scaleEstimator_thresh);
                
                allThreshCross_cnts(i) = numel(threshCrossInds);
                allThreshCross_inds{i} = threshCrossInds;
                totalDataSize(i) = numel(thisData); % this last data entry will be smaller than 6 minutes
            end
            
            figure;
            imagesc(allThreshCross_cnts)
            
            
            
            
        end

        
        
        function [] = extractMvmtFromOF_separateParts(obj, OFPath)
            dbstop if error
            fileToLoad = OFPath;
            
            d = load(fileToLoad);
            
            
            fv = d.fV1;
            fvN = fv./(max(max(fv))); % normalize between 1 and 0
            
            
            
            %outliers_inds = find(fvN >= 0.3);
            outliers_inds = find(fvN >= 0.25);
            fvN(outliers_inds) = nan;  
            
            figure(200); clf
            plot(fvN)
            %smoothWin_s = 30;
            %smoothFv = smooth(fvN, smoothWin_s);
            %smoothFv = smooth(fvN.^2, smoothWin_s);
            
            plot(fvN)
            hold on
            %plot(smoothFv, 'k')
            %% Nov 14
%             %ROI1/Roi2/ROi3 contrast
%             start1 = 1;
%             stop1 = 39960; % need to make sure this is around number of 360
%             
%             start2 = 39961;
%             stop2 = 83880;
%             
%             start3 = 83881;
%             stop3 = 93776;
%             
            % ROI 2
%             start1 = 1;
%             stop1 = 39960;
%             
%             start2 = 39961;
%             stop2 = 83880;
%             
%             start3 = 83881;
%             stop3 = 93776;
            

            %ROI 3
%             start1 = 1;
%             stop1 = 47160;
%             
%             start2 = 47161;
%             stop2 = 65520;
%             
%             start3 = 65521;
%             stop3 = 93776;

%% Nov 19

%ROI1, 2 3,
            start1 = 1;
            stop1 = 3600; % need to make sure this is around number of 360
            
            start2 = 3661;
            stop2 = 46800;
            
            start3 = 46960;
            stop3 = 86865;

            hold on
            line([stop1 stop1], [0 .3], 'color', 'r')
            line([start2 start2], [0 .3], 'color', 'r')
            line([stop2 stop2], [0 .3], 'color', 'r')
            line([start3 start3], [0 .3], 'color', 'r')
            
            %%
            
            timeWin_min = 6;
            timeWin_s  = timeWin_min *60;
            
            allPartsTheshCnts = [];
            allPartsThreshCross_inds = [];
            allPartsTotalDataSize = [];
            
            for o = 1:3
                switch o
                    case 1
                        part_fV = fvN(start1:stop1);
                           tOn = start1:timeWin_s:stop1;
                           stop = stop1;
                           
                           %Nov14
                          % percentile4ScaleEstimation = 95; % roi1
                           
                           %Nov19
                           %percentile4ScaleEstimation = 88; % roi1
                           %percentile4ScaleEstimation = 92; % roi2
                           percentile4ScaleEstimation = 90; % roi3
                    case 2
                        part_fV = fvN(start2:stop2);
                        tOn = start2:timeWin_s:stop2;
                        stop = stop2;
                        %Nov14
                        %   percentile4ScaleEstimation = 95; % roi1
                           
                           
                           %Nov 19
                           
                        %percentile4ScaleEstimation = 95; % roi1
                        %percentile4ScaleEstimation = 90; % roi2
                        percentile4ScaleEstimation = 92; % roi3
                        
                    case 3
                        part_fV = fvN(start3:stop3);
                        tOn = start3:timeWin_s:stop3;
                        stop = stop3;
                        %Nov14
                        %   percentile4ScaleEstimation = 95; % roi1
                           
                           
                           %Nov 19
                        %percentile4ScaleEstimation = 85; % roi1
                        %percentile4ScaleEstimation = 88; % roi2
                        percentile4ScaleEstimation = 90; % roi3
                end
                
                sortedVals = sort(part_fV, 'ascend');
                figure(242);clf; plot(sortedVals)
                %percentile4ScaleEstimation = 92; % Nov 14
                %percentile4ScaleEstimation = 90; % Nov 19
                scaleEstimator_thresh =sortedVals(round(percentile4ScaleEstimation/100*numel(sortedVals)));
                
                
                figure(100); clf
                plot(part_fV);
                line([0 numel(part_fV)], [scaleEstimator_thresh scaleEstimator_thresh], 'color', 'r')
                axis tight
                %%
                
                
                
                %bin all data into 6 min bins
                
             
                nBatches = numel(tOn);
                
                allThreshCross_cnts = [];
                allThreshCross_inds = [];
                totalDataSize = [];
                for i = 1:nBatches
                    
                    if i == nBatches
                        thisData = fvN(tOn(i):stop);
                    else
                        thisData = fvN(tOn(i):tOn(i)+timeWin_s-1);
                    end
                    
                    threshCrossInds = find(thisData >= scaleEstimator_thresh);
                    
                    allThreshCross_cnts(i) = numel(threshCrossInds);
                    allThreshCross_inds{i} = threshCrossInds;
                    totalDataSize(i) = numel(thisData); % this last data entry will be smaller than 6 minutes
                end
                
                
                allPartsTheshCnts{o} = allThreshCross_cnts;
                allPartsThreshCross_inds{o} = allThreshCross_inds;
                allPartsTotalDataSize{o} = totalDataSize;
                
                
            end
            disp('')
            
            allDetections_6minBins = cell2mat(allPartsTheshCnts);
            allDurations_s = cell2mat(allPartsTotalDataSize);
            
            
            allDetections_6minBins = allDetections_6minBins(1:end-1); % remove last incomplete bin
            allDurations_s = allDurations_s(1:end-1);
   
            figure(240);clf
            imagesc(allDetections_6minBins)
            %%
            textName = 'Detections-ROI3_Nov19-002.txt';
            %textName = 'Detections-ROI3_Nov14-001.txt';
            
            %fileToSave = ['E:\ChronoAnalysis\001_Vids_Nov14\contrastVids\OF_DS\textDetections\' textName];
            fileToSave = ['E:\ChronoAnalysis\002_Vids_Nov19\ContrastVids\OF_Analysis\TextDetections\' textName];
                
            fileID = fopen(fileToSave,'w');
            %fprintf(fileID,'%6s %12s\n','x','exp(x)');
            fprintf(fileID,'%d\n',allDetections_6minBins);
            fclose(fileID);
            
            
            
            
            
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

