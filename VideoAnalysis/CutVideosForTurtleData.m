function [] = CutVideosForTurtleData()
vidDir = 'C:\Users\Janie\Documents\Data\2box-hor\2012.08.13-E09\';

vidSaveDir = [vidDir 'editedVids\'];

if exist(vidSaveDir, 'dir') == 0
    mkdir(vidSaveDir);
end

searchString = '*.wmv';
files = dir(fullfile(vidDir, searchString));
nFiles = numel(files);
for j = 1:nFiles
    vidsToAnalyze{j} = files(j).name;
end
            
allStartsStops = [15 3435;  29 2175; 7 2355; 31 2700;  8 1935; 29 2790; 11 2400; 13 3240;  1 2400; 9 6105];


%%
%vidsToAnalyze = {'Video 981.wmv', 'Video 982.wmv', 'Video 983.wmv', 'Video 984.wmv', 'Video 985.wmv', 'Video 986.wmv', 'Video 987.wmv', 'Video 988.wmv', 'Video 989.wmv', 'Video 990.wmv', 'Video 991.wmv'};


nVids = numel(vidsToAnalyze);
period = '.';

%
for j = 1:nVids
    V_OBJ = videoAnalysis_OBJ({[vidDir vidsToAnalyze{j}]});
    
    %theseStartsStops = allStartsStops(j,:);
    
    startFrame = allStartsStops(j,1);
    endFrame = allStartsStops(j,2);
    FrameRateOverride = 30;
    
    bla = find(vidsToAnalyze{j} == period);
    
    videoNameNumber = vidsToAnalyze{j}(7:bla-1);
    %videoName = 'Video984_cut.avi';
    videoName = ['Video_' videoNameNumber '_cut.avi'];
    
    convertWMVToAVI(V_OBJ, startFrame, endFrame, videoName, FrameRateOverride )
    %convertWMVToAVI(V_OBJ, startFrame, endFrame, videoName)
    disp(['Finished ' num2str(j) '/' num2str(nVids)])
    
end

end

function [] = convertWMVToAVI(obj, startFrame, endFrame, videoName, FrameRateOverride)
dbstop if error

VidObj = VideoReader(obj.PATH.VidPath{:});

vidHeight = VidObj.Height;
vidWidth = VidObj.Width;
totalFrames = VidObj.NumberOfFrames;

if isempty(FrameRateOverride)
    VidFrameRate = VidObj.FrameRate;
else
    VidFrameRate = FrameRateOverride;
end

if isnan(endFrame)
    endFrame = totalFrames;
end

FrameOn = startFrame;
FrameOff = endFrame;

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

saveName = [obj.PATH.editedVidPath videoName ];
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
