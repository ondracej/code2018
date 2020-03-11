%% TestForPreFilteringData
function [] = preFilterOpehEphyDataForDatFile()


%
%
% dataDir = 'D:\TUM\SWR-Project\ZF-59-15\20190428\19-34-00\Ephys';
%
% dataRecordingObj = OERecordingMF(dataDir);
% dataRecordingObj = getFileIdentifiers(dataRecordingObj); % creates dataRecordingObject
%
% timeSeriesViewer(dataRecordingObj); % loads all the channels
%5, 4, 6, 3, 9, 16, 8, 1, 11, 14, 12, 13, 10, 15, 7, 2

%%

EphysDir = 'D:\TUM\SWR-Project\ZF-59-15\20190428\19-34-00\Ephys\';
savePath = 'D:\TUM\SWR-Project\ZF-59-15\20190428\19-34-00\bin\20190428.bin';

chanMap = [2 7 15 10 13 12 14 11 1 8 16 9 3 6 4 5]; % deepes first, acute

extSearch ='*.continuous*';
allOpenEphysFiles=dir(fullfile(EphysDir,extSearch));
nFiles=numel(allOpenEphysFiles);

chanSet=chanMap;


Fs = 30000;

fObj = filterData(Fs);

fobj.filt.FH2=filterData(Fs);
fobj.filt.FH2.highPassCutoff=100;
fobj.filt.FH2.lowPassCutoff=2000;
fobj.filt.FH2.filterDesign='butter';
fobj.filt.FH2=fobj.filt.FH2.designBandPass;
fobj.filt.FH2.padding=true;

fobj.filt.FH=filterData(Fs);
fobj.filt.FH.highPassPassCutoff=100;
fobj.filt.FH.highPassStopCutoff=80;
fobj.filt.FH.lowPassPassCutoff=1800;
fobj.filt.FH.lowPassStopCutoff=2000;
fobj.filt.FH.attenuationInLowpass=20;
fobj.filt.FH.attenuationInHighpass=20;
fobj.filt.FH=fobj.filt.FH.designBandPass;
fobj.filt.FH.padding=true;


cnt = 1;
allChans = [];

for s=chanSet
    
    eval(['fileAppend = ''100_CH' num2str(s) '.continuous'';'])
    fileName = [EphysDir fileAppend];
    
    [data, timestamps, info] = load_open_ephys_data(fileName);
    
    [V_uV_data_full,nshifts] = shiftdim(data',-1);
    
    %dataHF = squeeze(fobj.filt.FH2.getFilteredData(V_uV_data_full));
    dataFH = squeeze(fobj.filt.FH.getFilteredData(V_uV_data_full));
    
    %figure; plot(timestamps(1:10000), dataHF(1:10000), 'k')
    %hold on
    %plot(timestamps(1:10000), dataFH(1:10000), 'b')
    
    datI = int16(dataFH);
    
    %figure; plot(timestamps(1:10000), datI(1:10000), 'b')
    
    allChans(cnt,:) = datI;
    cnt = cnt+1;
    
end

disp('')



%% This dataset is 385 channels by 30000 time samples.
%>> fid = fopen('D:\my\path\myNewFile.bin', 'w');
%>> fwrite(fid, datI, 'int16');
%>> fclose(fid);

fid = fopen(savePath, 'w');
fwrite(fid, allChans, 'int16');
fclose(fid);

%%

end
