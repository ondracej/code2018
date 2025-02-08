function [] = VideoAnalysisNeuropixel()

videoToLoad = 'X:\CorinnaNeuropixSleepData\data\r5n5\20201023_02\cam1__22960809__20201023_225936804.mp4';
saveDir = 'X:\CorinnaNeuropixSleepData\data\r5n5\20201023_02\corrected1fpsFrames\';

VideoOnAlign_s  = 33.227;
VideoOffalign_s  = 4065.85;

totalVideDur_s = VideoOffalign_s - VideoOnAlign_s;

VideoObj = VideoReader(videoToLoad, 'Tag', 'CurrentVideo');

nFrames = VideoObj.NumberOfFrames;

vidHeight = VideoObj.Height;
vidWidth = VideoObj.Width;
vidFormat = VideoObj.VideoFormat;


VideoFrameRate_adj = round(nFrames/totalVideDur_s);

%% Extract 1 fps using corrected frameRate


FramesToGrab = 1:VideoFrameRate_adj:nFrames;
nFramesToGrab = numel(FramesToGrab);

%%

St = '.png';
for j = 1:nFramesToGrab
    
    thisFrame = FramesToGrab(j);
    
    if thisFrame <= nFrames
        
        %bla = step(vidObj, thisFrame)
        
        %frame = step(videoReader);
        %im = step(converter, frame);
        
        IMG = read(VideoObj, thisFrame);
        
        n_strPadded = sprintf( '%05d', thisFrame) ;
        
        Strc = strcat(n_strPadded, St);
        
        
        imwrite(IMG, [saveDir Strc])
        
    end
end

end

