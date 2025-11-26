function [] = analyzeMvmtInVideo_OF_compared_to_HamedsAnalysis()

%vid_path = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w025\DATA_VIDEO\w25_2021-07-18_00174_converted_img\';
vid_path = 'X:\EEG-LFP-songLearning\w025andw027\w0025\w25-18-07-2021_00174_converted_1fps\';

    
    %% Hamed's analysis
    
    %vid_path = obj.PATH.vid_path;
    %vid_path = 'X:\EEG-LFP-songLearning\JaniesAnalysisBackup\w038\DATA_VIDEO\converted_Imgs_1_frame_per_min\w038_01_09_21_00219-converted_img\';
    %vidroi=VideoReader(vid_path);
    %disp('object was created for the video file. start of reading frames...');
    %im1_=double(rgb2gray(read(vidroi, frames(1)))); % first x_old (in comparison)
    
    imageNames = dir(fullfile(vid_path, '*.png'));
    imageNames = {imageNames.name}';
    nImags = numel(imageNames);
    
    frames = 1:nImags;
    
    %app.roi_y=1:1024;  app.roi_x=1:1280;
    % In case a smaller ROI needs to be defined
    roi_y = 1:1024;
    roi_x = 1:1280;
    
    img1 = imread([vid_path imageNames{frames(1)}]);
    im1=double(img1(roi_y,roi_x));
    acc_dif=zeros(size(im1)); % contains accumulated absolute value of consecutive differences
    
    % creating wait bar to display progress
    %  f = waitbar(0,'Analysing frames...');
    tic;
    
    % difining some variables that are used in the loop
    y_pixls=1:size(im1,1);  y_vals=y_pixls'/sum(y_pixls); % a vector of values from 0 to 1 with ...
    % a length equal to the height of the image. Also the same for length
    x_pixls=1:size(im1,2);  x_vals=x_pixls'/sum(x_pixls);
    % loop through frames
    
    for i= frames(2:end)
        % this section of the lop generates the r_dif variable,
        
        img2 = imread([vid_path imageNames{i}]);
        im2=double(img2(roi_y,roi_x));
        
        dif=abs(im2-im1);   % difference computation
        y_dif=sum(dif,2); % difference along vertical axis
        x_dif=sum(dif,1); % difference along horizontal axis
        % computing the weighted average of moved pixels (dif) along y and x:
        y_dif_mean=y_dif'*y_vals;
        x_dif_mean=x_dif*x_vals;
        r_dif(i)=sqrt(x_dif_mean^2 + y_dif_mean^2); % position of the center of changes in the current ...
        % following frames (r in polar coordinates)
        
        
        % this section of the loop is for the acc_diff (accumulated differences) that shows all of the
        % movements occuring during the specific frames of the video. It just
        % does not accumulate the whole differences in all single frames because
        % there are many speckle random points that are different in two
        % following frames. So we also make a mask and filter out the single
        % points thatt their change doesnt seem to be consistent in time. To do
        % that we compare the current difference matrix with the previous one and
        % consider a point as REAL difference only if it appears in both of these
        % matrices
        %if i==frames(2), dif_old=zeros(size(dif)); end
        if i==frames(2), dif_old=zeros(size(dif)); end
        avg_dif=(dif+dif_old)/2;
        dif_thresh=median(avg_dif) + 5*iqr(abs(avg_dif)); % threshold for considering a point as..
        % a consistant difference
        mask=avg_dif>dif_thresh; % to make sure that these points are constantly changing, ...
        % at least in 2 consecutive frames, not just speckle noise spots
        acc_dif=acc_dif+mask.*abs(dif); % accumulated absolute value of consecutive differences
        im1=im2; % consider x_new as x_old for the next comparison
        dif_old=dif;
        
        %{
                      % update waitbar
                      if rem(i,20)==0
                          x=(length(frames)-(i-frames(1)))*toc/(i-frames(1));
                          waitbar((i-frames(1))/length(frames),f,['Remaining time: ' num2str(ceil(x/60)) ' min...']);
                      end
        %}
        if rem(i,1000)==0
            disp([ 'frame number being read: ' num2str(i) ' ...']); % disply the current frame value
        end
        
    end
    last_im=im1;
    last_dif=dif;
    % waitbar(1,f,'Video read completely!');
    
    figure; 
    subplot(2, 1, 2); cla
    plot(smooth(r_dif, 60))
    axis tight
    xlabel('Time (s)')
    % waitbar(1,f,'Video read completely!');
    
    %figure; plot(r_dif)
    %axis tight
    %ylim([0 60000])
    
    %xlabel('Time (s)')
    obj.ANALYSIS.VID.r_dif = r_dif;
    obj.ANALYSIS.VID.framesOffOn = framesOffOn;
    
    %% OF - must use in matlab 2014b
    
    %{
    videoToAnalyze = obj.PATH.VidPath{:};
    OFDir = [obj.PATH.editedVidPath];

    
    %% 
    %%
            fileFormat = 4; 
           
            %%
            switch fileFormat
                case 1
                    imgFormat = '*.tiff';
                case 2
                    imgFormat = '*.jpg';
                case 3
                    imgFormat = '*.jpg';
                     case 4
                    imgFormat = '*.png';
            end
            
            
              imageNames = dir(fullfile(vid_path{:},imgFormat));
            imageNames = {imageNames.name}';
            
            
          
         
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









%}






end
