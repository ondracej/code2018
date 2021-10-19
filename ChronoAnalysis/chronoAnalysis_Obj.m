classdef chronoAnalysis_Obj < handle
    
    
    properties (Access = public)
        
        HOST
        PATH
    end
    
    methods
        
        
        function obj = getVideoInfo(obj,vidPath)
            
            disp('Getting video info...')
            obj.HOST.hostname = gethostname;
            disp('...done!')
            if ispc
                dirD = '\';
            else
                dirD = '/';
            end
            
            obj.HOST.dirD = dirD;
            obj.PATH.VidPath = vidPath;
            [pathstr,name,ext] = fileparts(vidPath{:});
            
            editedVidPath = [pathstr dirD 'OF_Analysis' dirD];
            
            if exist(editedVidPath, 'dir') ==0
                mkdir(editedVidPath);
                disp(['Created directory: ' editedVidPath])
            end
            
            obj.PATH.editedVidPath = editedVidPath;
            
        end
        
        
        %%
        function [] = makeMultipleMoviesFromImages(obj, imageDir, movieName, saveDir, VideoFrameRate, doRotate, rotationAngle)
            
            fileFormat = 3; % (1)- tif, (2) -.jpg
            %doRotate = 1;
            
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
                  
                    if doRotate
                        
                        img = imrotate(img,rotationAngle, 'bilinear');
                        imshow(img)
                    end
                    
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
            OFDir = [vidDir saveTag(2:end) obj.HOST.dirD ];
            
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
                VideoFrameRate = vidFrameRate;
                vidHeight = VideoObj.Height;
                vidWidth = VideoObj.Width;
                vidFormat = VideoObj.VideoFormat;
                
                frameSkip = VideoFrameRate/dsFrameRate;
                
                %%
                videoReader = vision.VideoFileReader(vidToLoad,'ImageColorSpace','Intensity','VideoOutputDataType','uint8'); % create required video objects
                converter = vision.ImageDataTypeConverter;
                opticalFlow1 = vision.OpticalFlow('Method','Lucas-Kanade','ReferenceFrameDelay', 1);% use of the Lucas-Kanade method for optic flow determination
                opticalFlow1.OutputValue = 'Horizontal and vertical components in complex form';
                
                disp('Please use the mouse to draw a rectangle around the region of interest...')
                
                FrameOn = 1;
                FrameOff =nFrames;
                mCnt = 1;
                
                mov = struct('cdata',[],'colormap',[]);
                for frame_ind = FrameOn : frameSkip: FrameOff
                    
                    mov(mCnt).cdata = read(VideoObj,frame_ind);
                    frame = mov(mCnt).cdata;
                    im = step(converter, frame);
                    if cnt == 1
                        figure
                        
                        movROI.cdata = read(VideoObj,420); %420th frame
                        roi_frame = movROI.cdata;
                        im_roi = step(converter, roi_frame);
                        
                        figH = imshow(im_roi); %open the first frame
                        %disp('Select 1st ROI')
                        
                        %% Define ROI
                        
                        rectim1 = getrect; %choose ROI
                        rectim1=ceil(rectim1);
                        disp('Extracting frames and calculating the optic flow...')
                    end
                    
                    
                    im1 = im(rectim1(2):rectim1(2)+rectim1(4),rectim1(1):rectim1(1)+rectim1(3)); %choose this ROI part of the frame to calculate the optic flow

                    of1 = step(opticalFlow1, im1);
                    V1=abs(of1); % length of the velocity vector
                    meanV1=mean(mean(V1)); % mean velocity for every pixel
                    fV1(mCnt)=meanV1;
                    mCnt = mCnt +1;
                    cnt = cnt + 1;
                    disp(strcat('Frame: ',num2str(frame_ind ),' is done'))
                end
                
                fV1(1)=0; % suppress the artifact at the first frame
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
            
            fV1_norm = fV1./(max(max(fV1))); % normalized here
            
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
            %ylim([0 0.25])
            
            [pathstr,name,ext] = fileparts(obj.PATH.VidPath{:}) 
            saveName = [obj.PATH.editedVidPath name '_' VidNameShort '_OF_DSs1'];
            %plotpos = [0 0 25 12];
            plotpos = [0 0 30 12];
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
            %print_in_A4(0, saveName, '-depsc', 0, plotpos);
            
            
            
            %% Save concat OF
            
            bluecolor = [0 50 150];
            shapeInserter1 = vision.ShapeInserter('Shape','Rectangles','BorderColor','Custom','LineWidth',2.5,'CustomBorderColor',int32(bluecolor));
            img1 = step(shapeInserter1,OF.im,OF.rectim1); %insert the ROIs
            
            figure(103); clf
            image(img1)
            axis off
            title(['Video: ' VidNameShort])
            
            saveName = [obj.PATH.editedVidPath  name '_' VidNameShort '_ROI_img'];
            plotpos = [0 0 15 12];
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
            
            %% Clock Info
            Clock.StartingClockTime = StartingClockTime;
            
            rectim1 = OF.rectim1;
            im = OF.im;
            save([obj.PATH.editedVidPath name '_' VidNameShort '_OF_DSs1_fullFile.mat'], 'fV1', 'fV1_norm', 'img1', 'im', 'rectim1', 'dsFrameRate', 'Clock');
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

        
        
        function [] = extractMvmtFromOF_separateParts(obj, fileToLoad, figSaveDir, mvmtArtifacts)
            dbstop if error
            
           %smoothWin_s = 5;
           
             if exist(figSaveDir, 'dir') ==0
                mkdir(figSaveDir);
                disp(['Created directory: ' figSaveDir])
             end
            
            [pathstr,name,ext] = fileparts(fileToLoad); 
            
            underscore = '_';
            bla = find(name ==  underscore);
            saveTag = name;
            saveTag(bla) = '-';
            
            d = load(fileToLoad);
            
            fv = d.fV1; % This is the non-normalized OF
            fvN = fv./(max(max(fv))); % normalize between 1 and 0
           
%             figure(200); clf
%             plot(fvN) % plot the diff
%             axis tight
            
            medVal = nanmean(fvN);
            stdVal = nanstd(fvN);
            negThresh = medVal - stdVal;
            negOutliers = find(fvN <=negThresh);
            posOutliers  = find(fvN >= medVal+stdVal*8);
            
            fvN(negOutliers) = nan;
            fvN(posOutliers) = nan;
            fvN(mvmtArtifacts) = nan;
           
%             figure(200); clf
%             plot(fvN) % plot the diff
%             axis tight
            
            fvN_diff = diff(fvN);
           
            figure(200); clf
            plot(fvN_diff) % plot the diff
            axis tight
            
            %https://de.mathworks.com/matlabcentral/answers/105736-zscore-of-an-array-with-nan-s
            fvN_diff_Z = bsxfun(@minus,fvN_diff,nanmean(fvN_diff));
            fvN_diff_Z = bsxfun(@rdivide,fvN_diff_Z,nanstd(fvN_diff_Z));
            
            timepoints_s = 1:1:numel(fvN_diff_Z);
            timepoints_hr = timepoints_s/3600;
            
            threshCrossing = 1; % 1 std of z-normalized data
                      
            figure(200); clf
            
            plot(timepoints_hr, fvN_diff_Z) % plot the diff
            axis tight
            hold on
            line([0 timepoints_hr(end)], [threshCrossing threshCrossing], 'color', 'r')
           % line([0 numel(fvN_diff_Z)], [2 2], 'color', 'g')
            ylim([-10 10])
            title(['Thresh = ' num2str(threshCrossing) ' std | ' saveTag])
            xlabel('Activity (hours)')
            ylabel('Normalized Activity (z-score)')
            
           saveName = [figSaveDir name '_Detections'];
            %plotpos = [0 0 25 12];
            plotpos = [0 0 20 8];
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
            
            
            %{
            prompt = {'Enter number of segments'};
            dlgtitle = 'Input';
            dims = [1 35];
            definput = {'2'};
            answer = inputdlg(prompt,dlgtitle,dims,definput);
            
            nSegs = str2double(answer{:});
           
            disp('Please use the mouse to define the starts of the segments')
            [x,~] = ginput(nSegs-1);
            
            %% These need to be in multiples of 360
          
            allStarts = [];
            allStops = [];
            
            for j = 1:nSegs
                
                if j == 1;
                    
                    start = 1;
                    stop_multiplier = round(x(1)/360);
                    
                    stop = stop_multiplier*360;
                 
                elseif j == nSegs
                    
                    start = stop +1;
                    stop_multiplier = floor(numel(fvN) / 360);
                    stop = stop_multiplier*360;
                    
                else
                    
                    start = stop +1;
                    stop_multiplier = round(x(j)/360);
                    
                    stop = stop_multiplier*360;
                    
                end
                line([stop stop], [0 1], 'color', 'r')
                line([start start], [0 1], 'color', 'r')
                axis tight
                ylim([0 .5])
                title(saveTag)
                
                allStarts(j) = start;
                allStops(j) = stop;
                
            end
            
             saveName = [figSaveDir name '_Detections_Raw-' ];
                plotpos = [0 0 30 12];
                print_in_A4(0, saveName, '-djpeg', 0, plotpos);

            %%
            %}
        
            %%
            timeWin_min = 6;
            timeWin_s  = timeWin_min *60;
            
%{
%             allPartsTheshCnts = [];
%             allPartsThreshCross_inds = [];
%             allPartsTotalDataSize = [];
%             
%             percentile4ScaleEstimation = 95; % roi3
%             
%             allPartsTheshCnts = [];
%             allPartsThreshCross_inds = [];
%             allPartsTotalDataSize = [];
%             smoothWin_s = 5;
%             for j = 1:nSegs
%                 
%                 median_FullNormFvN = median(fvN);
%                 smoothedfvN = smooth(fvN, smoothWin_s ); % 5 s
%                 
%                 test2 = diff(smoothedfvN);
%                 figure; plot(test2);
%                 
%                 %part_fV = fvN(allStarts(j):allStops(j));
%                 part_fV = smoothedfvN(allStarts(j):allStops(j));
%                 tOn = allStarts(j):timeWin_s:allStops(j);
%                 
%                 figure(240+j);clf;
%                 plot(part_fV);
%                 hold on
%                 axis tight
%                 ylim([0 0.5])
%                 
%                 
%                 test = diff(part_fV);
%                 figure
%                 plot(test);
%                 
%                 disp('Please use mouse to define the baseline')
%                  [~,y] = ginput(1);
%                 
%                 %sortedVals = sort(part_fV, 'ascend');
%                 %scaleEstimator_thresh =sortedVals(round(percentile4ScaleEstimation/100*numel(sortedVals)));
%                 %threshCrossing = find(sortedVals == scaleEstimator_thresh);
%                 threshCrossing = y;
%                 
%                 hold on
%                 line([0 numel(part_fV)], [threshCrossing threshCrossing], 'color', 'r')
%                 axis tight
%                 title(saveTag)
%                 %subplot(2, 1, 2)
%                 
%                % plot(sortedVals)
%                % hold on
%                % line([threshCrossing threshCrossing], [0 1], 'color', 'r')
%                % axis tight
%                 
%                 
%                 saveName = [figSaveDir name '_Detections_Raw-Seg-' num2str(j)];
%                 %plotpos = [0 0 25 12];
%                 plotpos = [0 0 30 12];
%                 print_in_A4(0, saveName, '-djpeg', 0, plotpos);
%                 
                
                
                %%
                
          %}      
                tOn = 1:timeWin_s:numel(fvN_diff_Z);
                
                nBatches = numel(tOn);
                
                allThreshCross_cnts = [];
                allThreshCross_inds = [];
                totalDataSize = [];
                
                dataToThresh = fvN_diff_Z;
                threshCrossing = 1; % 1 std of z-normalized data
                
                for i = 1:nBatches
                    
                    if i == nBatches
                        thisData = dataToThresh(tOn(i):numel(dataToThresh));
                    else
                        thisData = dataToThresh(tOn(i):tOn(i)+timeWin_s-1);
                    end
                    
                    threshCrossInds = find(thisData >= threshCrossing);
                    
                    allThreshCross_cnts(i) = numel(threshCrossInds);
                    allThreshCross_inds{i} = threshCrossInds;
                    totalDataSize(i) = numel(thisData); % this last data entry will be smaller than 6 minutes
                end
                
                
               % allPartsTheshCnts = allThreshCross_cnts;
             %   allPartsThreshCross_inds = allThreshCross_inds;
             %   allPartsTotalDataSize = totalDataSize;
                
     %%
            
            allDetections_6minBins = allThreshCross_cnts(1:end-1); % remove last incomplete bin
            allDurations_s = totalDataSize(1:end-1);
   
            figure(240);clf
            imagesc(allDetections_6minBins)
            caxis([0 100])
            xticks = get(gca, 'xtick');
            xticks_in_hr = xticks*6/60;
             xlabs = [];
                for j = 1:numel(xticks_in_hr)
                    xlabs{j} = num2str(xticks_in_hr(j));
                end
                
            set(gca, 'xticklabel', xlabs)
            set(gca, 'ytick', [])
            xlabel('Activity in 6 Min bins (hours)')
            colorbar('northoutside')
            title(['Activity map - ' saveTag])
            
            saveName = [figSaveDir name '_Detections_Imgsc'];
            %plotpos = [0 0 25 12];
            plotpos = [0 0 20 8];
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
            
            
            %%
            textName = ['Detections-' name '.txt'];
            fileToSave = [figSaveDir textName];
                
            fileID = fopen(fileToSave,'w');
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

