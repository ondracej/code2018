%% Tadpole Analysis

VideoPath = 'Z:\JanieData\Tadpoles\5Tadpoles_Grp1\20190710_09-11_Tadpoles_20190710_00015_converted.avi';
OutputDir = 'Z:\JanieData\Tadpoles\5Tadpoles_Grp1\20190710_09-11_Tadpoles_20190710_00015_converted_ffmpeg\';

% ffmpeg -i Z:\JanieData\Tadpoles\5Tadpoles_Grp1\20190710_09-11_Tadpoles_20190710_00015_converted.avi -qscale:v 1 -qmin 1 -qmax 1 Z:\JanieData\Tadpoles\5Tadpoles_Grp1\20190710_09-11_Tadpoles_20190710_00015_converted_ffmpeg\raw%08d.jpg -hide_banner

%% Export frames from video to directory w ffmpeg:

%ffmpeg -i <path-to-video> --qscale:v 1 -qmin 1 -qmax 1 <path-to-image-directory>\thumb%06d.jpg -hide_banner
%ffmpeg -i Z:\JanieData\Tadpoles\Tadpoles\6Tadpoles_Grp1\6-5_Tadpoles\5Tadpoles_20190725_21-13\Videos\5Tadpoles_20190725_21-13_001.avi -qscale:v 1 -qmin 1 -qmax 1 Z:\JanieData\Tadpoles\Tadpoles\6Tadpoles_Grp1\6-5_Tadpoles\5Tadpoles_20190725_21-13\Videos\5Tadpoles_20190725_21-13_001_ffmpeg\raw%08d.jpg -hide_banner

%%  Adjust histogram of images


imageDir = 'Z:\JanieData\Tadpoles\5Tadpoles_Grp1\20190710_09-11_Tadpoles_20190710_00015_converted_ffmpeg\';
fileFormat = 2;
outputVideoName = [imageDir '_contrastEnhanced.avi'];
switch fileFormat
    case 1
        imgFormat = '*.tiff';
    case 2
        imgFormat = '*.jpg';
    case 3
        imgFormat = '*.jpg';
end

imageNames = dir(fullfile(imageDir,imgFormat));
imageNames = {imageNames.name}';
nImags = numel(imageNames);
FrameOn = 1;
FrameOff = nImags;

outputVideo = VideoWriter(fullfile(outputVideoName));
outputVideo.FrameRate = 10;
open(outputVideo)


for f = FrameOn:FrameOff
    img = imread([imageDir imageNames{f}]);
    %     if   fileFormat ==2
    %         img2 = im2uint8(img);
    %         ;
    %     end
    grayImage = rgb2gray(img);
    J = adapthisteq(grayImage,'clipLimit',0.02,'Distribution','rayleigh');
    imshowpair(grayImage,J,'montage');
    imshow(J)
    
    %pout_histeq = adapthisteq (grayImage);
    %imshow(pout_histeq)
    ax = gca;
    ax.Units = 'pixels';
    img2 = getframe(ax);
    img2 = img2.cdata;
    
    %figure; imshow(img2)
    
    writeVideo(outputVideo,img2)
    disp(['Frame: ' num2str(f) '/' num2str(nImags)]);
end
close(outputVideo);
disp(['Saved: ' outputVideoName])