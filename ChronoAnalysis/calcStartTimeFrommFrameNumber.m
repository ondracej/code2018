function [StartingClockTime] = calcStartTimeFrommFrameNumber(origCamStart, frameStart)
sInMin = 60;
minInHr = 60;
hoursInDay = 24;

% Find the number of hours
hrsIntoVideo = floor(frameStart/ sInMin/ minInHr);

% Find the minutes
totalSinHours_min = hrsIntoVideo * sInMin * minInHr;

leftoverS_min = frameStart - totalSinHours_min;
minIntoVideo = floor(leftoverS_min / sInMin);

totalSinMin_s = minIntoVideo * sInMin;

leftoverS_s = leftoverS_min - totalSinMin_s;

%% Find Real Time

colon = ':';

bla = find(origCamStart == colon);

initClockHr = str2double(origCamStart(1: bla(1)-1));
initClockMin = str2double(origCamStart(bla(1)+1: bla(2)-1));
initClockS = str2double(origCamStart(bla(2)+1:end));

newClockS = initClockS + leftoverS_s;

if newClockS > sInMin
    keyboard
end

newClockMin = initClockMin + minIntoVideo;

if newClockMin > minInHr
    
  tempClockMin = newClockMin - minInHr;
  initClockHr = initClockHr+1;   
    newClockMin = tempClockMin;
    
end

newClockHr = initClockHr + hrsIntoVideo;
if newClockHr > hoursInDay
    
    
    
    tempClockHr = newClockHr - hoursInDay;
    
    if tempClockHr > hoursInDay
        
        tempClockHr = tempClockHr - hoursInDay;
    end
    
    newClockHr = tempClockHr;
    
end

StartingClockTime =  [num2str(newClockHr) ':' num2str(newClockMin) ':' num2str(newClockS)];

end
