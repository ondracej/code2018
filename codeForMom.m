function [] = codeForMom()
dbstop if error


thisMovie = '/home/janie/Data/Movies/MVI_4512.MP4';

%thisMovie = '/home/janie/Data/Movies/MVI_4521.MP4';
disp('Reading video')
VideoObj = VideoReader(thisMovie, 'Tag', 'CurrentVideo');


VidDuration= VideoObj.Duration;
nFrames = VideoObj.NumberOfFrames;
VideoFrameRate = VideoObj.FrameRate;
vidHeight = VideoObj.Height;
vidWidth = VideoObj.Width;
vidFormat = VideoObj.VideoFormat;



%%
disp('Extracting frames')
folder =  '/home/janie/Data/Movies/Imgs_MVI_4512/';    
    for k= 1:nFrames
        frames = read(VideoObj, k);
        %imwrite(frames, fullfile(folder, sprintf('%06d.tif', k)));
        imwrite(frames, fullfile(folder, sprintf('%d.tif', k)));
        disp('')
    end 

    %% Stabalize
    disp('Stabilizing')
    folder =  '/home/janie/Data/Movies/Imgs_MVI_4512';
    output_folder = '/home/janie/Data/Movies/Output_MVI_4512';
    file_type = 'tif';
    %video_length = nFrames;
    video_length = 300;
    
    dbstop if error
    
    %stabilize(folder, output_folder, file_type, video_length, Gauss_levels)
    stabilize(folder, output_folder, file_type, video_length)
    
%{
%%

filename  = '/home/janie/Data/momsVids/MVI_4512.MP4';

%filename = 'shaky_car.avi';
hVideoSrc = vision.VideoFileReader(filename, 'ImageColorSpace', 'Intensity');

imgA = step(hVideoSrc); % Read first frame into imgA
imgB = step(hVideoSrc); % Read second frame into imgB

figure; imshowpair(imgA, imgB, 'montage');
title(['Frame A', repmat(' ',[1 70]), 'Frame B']);
%%
figure; imshowpair(imgA,imgB,'ColorChannels','red-cyan');
title('Color composite (frame A = red, frame B = cyan)');

ptThresh = 0.035;
pointsA = detectFASTFeatures(imgA, 'MinContrast', ptThresh);
pointsB = detectFASTFeatures(imgB, 'MinContrast', ptThresh);
%%
% Display corners found in images A and B.
figure; imshow(imgA); hold on;
plot(pointsA);
title('Corners in A');

figure; imshow(imgB); hold on;
plot(pointsB);
title('Corners in B');
%%
% Extract FREAK descriptors for the corners
[featuresA, pointsA] = extractFeatures(imgA, pointsA);
[featuresB, pointsB] = extractFeatures(imgB, pointsB);


%%
indexPairs = matchFeatures(featuresA, featuresB);
pointsA = pointsA(indexPairs(:, 1), :);
pointsB = pointsB(indexPairs(:, 2), :);

%%
figure; showMatchedFeatures(imgA, imgB, pointsA, pointsB);
legend('A', 'B');

%%
[tform, pointsBm, pointsAm] = estimateGeometricTransform(...
    pointsB, pointsA, 'affine');
imgBp = imwarp(imgB, tform, 'OutputView', imref2d(size(imgB)));
pointsBmp = transformPointsForward(tform, pointsBm.Location);


%%
% Extract scale and rotation part sub-matrix.
H = tform.T;
R = H(1:2,1:2);
% Compute theta from mean of two possible arctangents
theta = mean([atan2(R(2),R(1)) atan2(-R(3),R(4))]);
% Compute scale from mean of two stable mean calculations
scale = mean(R([1 4])/cos(theta));
% Translation remains the same:
translation = H(3, 1:2);
% Reconstitute new s-R-t transform:
HsRt = [[scale*[cos(theta) -sin(theta); sin(theta) cos(theta)]; ...
  translation], [0 0 1]'];
tformsRT = affine2d(HsRt);

imgBold = imwarp(imgB, tform, 'OutputView', imref2d(size(imgB)));
imgBsRt = imwarp(imgB, tformsRT, 'OutputView', imref2d(size(imgB)));

figure(2), clf;
imshowpair(imgBold,imgBsRt,'ColorChannels','red-cyan'), axis image;
title('Color composite of affine and s-R-t transform outputs');

%}

end
