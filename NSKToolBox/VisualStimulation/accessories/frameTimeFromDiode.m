function [frameShifts,upCross,downCross,T]=frameTimeFromDiode(dataRecordingObj,varargin)
% [frameShifts,upCross,downCross]=frameTimeFromDiode(dataRecordingObj);
% Function purpose : calculate triggers from recording
%
% Function recives :    dataRecordingObj - a data recording object for extracting analog and digital data
%                           varargin ('property name','property value')
%
% Function give back :  frameShifts - times of frame shifts
%                       upCross - diode upward threshold crossing
%                       upCross - diode downward threshold crossing
%                       T - digital data time stamps
%
% Last updated : 15/07/15

%% default variables
tStart=0;
tEnd=dataRecordingObj.recordingDuration_ms;

chunckOverlap=1; %ms
maxChunck=1000*60*20; %ms
sessionStartDigiTriggerNumber=3;
analogChNum=1;

plotDiodeTransitions=0;
T=[]; %digital triggers in the recording

%% Output list of default variables
%print out default arguments and values if no inputs are given
if nargin==0
    defaultArguments=who;
    for i=1:numel(defaultArguments)
        eval(['defaultArgumentValue=' defaultArguments{i} ';']);
        if numel(defaultArgumentValue)==1
            disp([defaultArguments{i} ' = ' num2str(defaultArgumentValue)]);
        else
            fprintf([defaultArguments{i} ' = ']);
            disp(defaultArgumentValue);
        end
    end
    return;
end

%% Collects all input variables
for i=1:2:length(varargin)
    eval([varargin{i} '=' 'varargin{i+1};'])
end

%% Main function
Fs=dataRecordingObj.samplingFrequency;
frameSamples=round(1/60*Fs);

%determine the chunck size
if maxChunck>tEnd
    chunkStart=tStart;
    chunkEnd=tEnd;
else
    chunkStart=0:maxChunck:tEnd;
    chunkEnd=[chunkStart(2:end)-chunckOverlap tEnd];
end
nChunks=numel(chunkStart);

%extract digital triggers times if they were not provided during input
hWB=waitbar(0,'Getting digital triggers...');
if isempty(T)
    dataRecordingObj.includeOnlyDigitalDataInTriggers=1;
    T=dataRecordingObj.getTrigger; %extract digital triggers throughout the recording
end

%estimate transition points
hWB=waitbar(0,hWB,'Classifying transition on sample data...');
[Atmp]=dataRecordingObj.getAnalogData(analogChNum,T{sessionStartDigiTriggerNumber}(1:min(10,numel(T{sessionStartDigiTriggerNumber})))-1000,T{sessionStartDigiTriggerNumber+1}(1)-T{sessionStartDigiTriggerNumber}(1)+1000);
Atmp=permute(Atmp,[3 1 2]);Atmp=Atmp(:);
medAtmp = fastmedfilt1d(Atmp,round(frameSamples*0.8));
eva = evalclusters(medAtmp,'kmeans','DaviesBouldin','KList',[2:4]);
[idx,cent] = kmeans(medAtmp,eva.OptimalK,'Replicates',5);
cent=sort(cent);
transitions=(cent(1:end-1)+cent(2:end))/2;

%main loop
hWB=waitbar(0,hWB,'Extracting analog diode data from recording...');
upCross=cell(1,nChunks);
downCross=cell(1,nChunks);
for i=1:nChunks
    [A,t_ms]=dataRecordingObj.getAnalogData(1,chunkStart(i),chunkEnd(i)-chunkStart(i));
    A=squeeze(A);
    medA = fastmedfilt1d(A,round(frameSamples*0.8));
    
    upCross{i}=chunkStart(i)+find(medA(1:end-1)<transitions(1) & medA(2:end)>=transitions(1))/Fs*1000;
    downCross{i}=chunkStart(i)+find(medA(1:end-1)>transitions(1) & medA(2:end)<=transitions(1))/Fs*1000;
    waitbar(i / nChunks);
end
close(hWB);
upCross=cell2mat(upCross');
downCross=cell2mat(downCross');

upCross(diff(upCross)<(1000/Fs))=[]; %if crossing was detected twice due to overlap
downCross(diff(upCross)<(1000/Fs))=[]; %if crossing was detected twice due to overlap

frameShifts=sort([downCross;upCross]);

if plotDiodeTransitions
    figure;
    mx=max(Atmp)+100;
    t_ms=(1:numel(Atmp))/Fs*1000;
    for i=1:numel(transitions)
        line([t_ms(1) t_ms(end)],[transitions(i) transitions(i)],'color','k');
    end
    hold on;
    
    plot(t_ms,Atmp);
    plot(t_ms,medAtmp,'g');
    
    upCrossTmp=find(medAtmp(1:end-1)<transitions(1) & medAtmp(2:end)>=transitions(1));
    downCrossTmp=find(medAtmp(1:end-1)>transitions(1) & medAtmp(2:end)<=transitions(1));
    plot(t_ms(upCrossTmp),medAtmp(upCrossTmp),'^r');
    plot(t_ms(downCrossTmp),medAtmp(downCrossTmp),'vr');
end
