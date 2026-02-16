
function [] = load_images_make_movie_OF_analysis()


allVidDirs = 'X:\EEG-LFP-songLearning\JaniesAnalysis\w038\DATA_VIDEO\';
d = dir(allVidDirs);

dfolders = d([d(:).isdir]);
dfolders = dfolders(~ismember({dfolders(:).name},{'.','..'}));

for ii = 1:numel(dfolders)
    imageDir = [ allVidDirs dfolders(ii).name '\'];
    
    %imageDir = 'X:\EEG-LFP-songLearning\w025andw027\w0025\w25-02-08-2021_00193_converted-1fpm_exact\';
    
    fileFormat  = 3;
    
    [pathstr,name,ext] = fileparts(imageDir);
    vidSaveName = [imageDir  'compiledVideo.avi'];
    %fileFormat = 1; % (1)- tif, (2) -.jpg
    
    %%
    switch fileFormat
        case 1
            imgFormat = '*.tiff';
        case 2
            imgFormat = '*.jpg';
        case 3
            imgFormat = '*.png';
    end
    
    imageNames_Vid = dir(fullfile(imageDir,imgFormat));
    imageNames_Vid = {imageNames_Vid.name}';
    
    nImages = size(imageNames_Vid, 1);
    
    framesToGrab = 1:1:nImages;
    
    %fig1 = figure(100);clf
    
    %videoReader = vision.VideoFileReader(vidToLoad,'ImageColorSpace','Intensity','VideoOutputDataType','uint8'); % create required video objects
    converter = vision.ImageDataTypeConverter;
    opticalFlow = vision.OpticalFlow('Method','Lucas-Kanade','ReferenceFrameDelay', 1);% use of the Lucas-Kanade method for optic flow determination
    opticalFlow.OutputValue = 'Horizontal and vertical components in complex form';
    mCnt =1;
    for f = framesToGrab
        frame = imread([imageDir imageNames_Vid{f}]);
        im = step(converter, frame);
        %                imshow(img_tmp) %open the first frame
        
        %image(im)
        %axis('off')
        %annotation(fig1,'textbox', [0.80 0.08 0.1 0.1], 'String',currTime_txt, 'FontWeight','bold','FontSize',18, 'FitBoxToText','on','LineStyle','none','EdgeColor',[1 1 1],'LineWidth',8,'Color',[1 1 1]);
        rectim1 =  [10 10 1270 1010];
        %
        %     if mCnt == 1
        %         figure
        %         imshow(im) %open the first frame
        %         %disp('Select 1st ROI')
        %
        %         %% Define ROI
        %         %rectim1 = getrect; %choose right eye ROI
        %         %rectim1=ceil(rectim1);
        %
        %         %Hardcoded
        %         %disp('Using hardcoded ROI')
        %
        %
        %     end
        %
        im1 = im(rectim1(2):rectim1(2)+rectim1(4),rectim1(1):rectim1(1)+rectim1(3)); %choose this ROI part of the frame to calculate the optic flow
        %of1 = step(opticalFlow1, im1);
        of1 = step(opticalFlow, im1);
        V1=abs(of1); % lenght of the velocity vector
        meanV1=mean(mean(V1)); %mean velocity for every pixel
        fV1(mCnt)=meanV1;
        mCnt =mCnt +1;
        %   F(f) = getframe(fig1);
        fprintf('%d/%d\n', f, numel(imageNames_Vid));
    end
    
    
    figure(104)
    
    plot(fV1)
    axis tight
    ylim([0 0.1])
    title(dfolders(ii).name, 'Interpreter', 'none')
    
    plotpos = [0 0 20 12];
    RecName_save = [imageDir 'OF'];
    print_in_A4(0, RecName_save, '-djpeg', 0, plotpos);
    %print_in_A4(0, RecName_save, '-depsc', 0, plotpos);
    
    fV1(1)=0; % supress artifact
    save( [imageDir 'OF.mat'], 'fV1', 'rectim1', 'im');
    disp(['Saved:' imageDir 'OF.mat']);
    
    
end

end