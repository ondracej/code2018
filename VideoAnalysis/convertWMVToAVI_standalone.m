function [] = convertWMVToAVI_standalone()


pathToVideoDirectory = 'E:\2box-hor\2012.06.22-E09\';
convertedAviDir = [pathToVideoDirectory 'converted-AVI\'];

vidNames = dir(fullfile(pathToVideoDirectory,'*.wmv'));
vidNames = {vidNames.name}';
nVids = numel(vidNames);

FrameRateOverride = []; % change if you want a diff frame rate than original video

if exist(convertedAviDir, 'dir') ==0
    mkdir(convertedAviDir);
    disp(['Created directory: ' convertedAviDir])
end

%%
for j = 1:nVids
    VidObj = VideoReader([pathToVideoDirectory vidNames{j}]);
    
    vidHeight = VidObj.Height;
    vidWidth = VidObj.Width;
    totalFrames = VidObj.NumberOfFrames;
    
    if isempty(FrameRateOverride)
        VidFrameRate = VidObj.FrameRate;
    else
        VidFrameRate = FrameRateOverride;
    end
    
    FrameOn = 1;
    FrameOff = totalFrames;
    
    nFrames = numel(FrameOn:FrameOff);
    framesToGrab = FrameOn:FrameOff;
    
    disp('All Frames Video')
    mov(1:nFrames) = struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),'colormap', []);
    cnt = 1;
    for k =framesToGrab
        mov(cnt).cdata = read(VidObj, k);
        fprintf('%d/%d\n', cnt, nFrames);
        cnt = cnt+1;
    end
    
    saveName = [convertedAviDir vidNames{j}(1:end-4) '.avi'];
    %V = VideoWriter(saveName, 'Uncompressed AVI'); % creates huge files ~20 GB, 'quality' is not an option
    V = VideoWriter(saveName, 'Motion JPEG AVI');
    V.Quality = 95;
    V.FrameRate = VidFrameRate;
    
    mov = mov(1:end);
    tic
    open(V)
    writeVideo(V, mov)
    close(V)
    toc
    
    disp(['Saved: ' saveName])
    clear('mov');
end

end