function [] = ConvertAudioSpikeToPlexon()
dbstop if error


AllNeurons = {'N-03'; 'N-10'; 'N-12'; 'N-16'; 'N-17';'N-21';'N-23'; 'N-24';
    'N-25'; 'N-26'; 'N-27'; 'N-28'; 'N-29'; 'N-31'; 'N-32'; 'N-33'; 'N-34';
    'N-37'; 'N-39';'N-40'; 'N-42';'N-43';'N-44'};

AllExps =       [1; 1; 1; 2; 2; 2; 3; 3; 3; 3; 3; 4; 4; 4; 4; 5; 5; 6; 6; 6; 7; 7; 7];
EllRs =         [3; 10; 12; 4; 5; 9; 2; 3; 4; 5; 6; 1; 2; 4; 5; 1; 2; 1; 3; 4; 2; 3; 4];


% AllNeurons =    {'N-24';'N-26';'N-32'};
% AllExps =       [3; 3; 4];
% EllRs =         [3; 5; 5];


% AllNeurons =    {'N-03'; 'N-05'; 'N-06'; 'N-07';'N-08';'N-09';'N-10'; 'N-11'; 'N-12'; 'N-13'; 'N-14'; 'N-15'; 'N-16'; 'N-17';'N-18'; 'N-19'; 'N-20'; 'N-21';'N-23';
%     'N-25'; 'N-27'; 'N-28'; 'N-29'; 'N-30'; 'N-31';'N-33'; 'N-34'; 'N-35'; 'N-36'; 'N-37';'N-38';'N-39';'N-40'; 'N-41';'N-42';'N-43';'N-44';'N-45';'N-46'};
% AllExps =       [1; 1; 1; 1; 1; 1; 1; 1;  1; 2;2;2;2; 2; 2; 2; 2; 2; 3;3;3;4;4;4;4;5;5;5;5;6;6;6;6;7;7;7;7;8;8];
% EllRs =         [3; 5;6;7;8;9; 10; 11 ;12; 1;2;3;4;  5; 6;7; 8;9;2;4;6;1;2;3;4;1;2;3;4;1;2;3;4;1;2;3;4;1;2];

for E = 1:numel(EllRs)
    %for E = 2
    
    neuronTxt = [AllNeurons{E} '-' ];
    
    exp = AllExps(E);
    Rs = EllRs(E);
    
    %stimIDsToUse = [5 1];
    stimIDsToUse = [1];
    
    % 5 = WN
    % 1 = HRTF
    % 2 = Tuning
    
    
    saveDir = 'F:\PlexonSpikesTest\';
    [OT_DB] = OT_database();
    
    nExperiments = numel(OT_DB);
    
    for j = exp
        %j=experiment
        nRS = numel(OT_DB(j).RS);
        
        for k = Rs
            %k=recSession
            C_OBJ = chicken_OT_analysis_OBJ(j, k);
            
            nStims = numel(C_OBJ.RS_INFO.StimProtocol_ID);
            cnt = 1;
            
            
            availableStims = C_OBJ.RS_INFO.StimProtocol_ID;
            match = find(ismember( availableStims, stimIDsToUse));
            nMatchs = numel(match);
            
            concatData = [];
            
            for s = 1:nMatchs
                audSelInd = match(s); % SpikesThis is the index, spikesnot the stim number!!!
                selection = C_OBJ.RS_INFO.ResultDirName{audSelInd};
                disp(selection);
                
                C_OBJ = getAudioSpikeResults(C_OBJ, audSelInd);
                C_OBJ = organizeStimRepetitions(C_OBJ, audSelInd);
                
                nDataCells = numel(C_OBJ.O_STIMS.allEpochData);
                
                for o = 1:nDataCells
                    thisCell = C_OBJ.O_STIMS.allEpochData{o};
                    
                    %                     firstData = C_OBJ.O_STIMS.allEpochData{1};
                    %                     lastData = C_OBJ.O_STIMS.allEpochData{2580};
                    %
                    %                     figure;
                    %                     subplot(1, 2, 1)
                    %                     plot(firstData)
                    %                     subplot(1, 2, 2)
                    %                     plot(lastData)
                    
                    dataSize = numel(thisCell);
                    %allData = [allData thisCell'];
                    if o == nDataCells
                        allData = cell2mat(C_OBJ.O_STIMS.allEpochData(:))';
                        concatData{s} = allData;
                    end
                    
                    if o == 1 && s == 1 %first time it is run
                        startCnt(o) = 1;
                        endCnt(o) = startCnt(o)+dataSize-1;
                        
                        allStarts(cnt) = startCnt(o);
                        allEnds(cnt) = endCnt(o);
                    elseif o == 1 && s > 1 %first time it is run on the next stim
                        startCnt(o) = allEnds(cnt-1)+1;
                        endCnt(o) = startCnt(o)+dataSize-1;
                        
                        allEnds(cnt) = endCnt(o);
                        allStarts(cnt) = startCnt(o);
                    else
                        startCnt(o) = endCnt(o-1)+1;
                        endCnt(o) = startCnt(o)+dataSize-1;
                        
                        allEnds(cnt) = endCnt(o);
                        allStarts(cnt) = startCnt(o);
                    end
                    
                    thisDataROIs(o,1) = startCnt(o);
                    thisDataROIs(o,2) = endCnt(o);
                    cnt = cnt+1;
                    
                end
                
                INFO.thisStimROI{s} = thisDataROIs;
                INFO.thisStimInds{s} = C_OBJ.O_STIMS.allEpochStimInds;
                INFO.thisStimEpochs{s} = C_OBJ.O_STIMS.stimEpochs;
                INFO.thisStimNames{s} = C_OBJ.O_STIMS.stimName;
                INFO.thisStimNames{s} = C_OBJ.O_STIMS.stimName;
                INFO.thisStimC1{s} = C_OBJ.O_STIMS.stimC1;
                INFO.thisStimC2{s} = C_OBJ.O_STIMS.stimC2;
                INFO.thisStimAlLStimuli{s} = C_OBJ.STIMS.AllStimuli;
                INFO.audStimDir{s} = C_OBJ.PATHS.audStimDir;
            end
            
            concatDataAll = [];
            data = [];
            %fs = 44100;
            concatDataAll = cell2mat(concatData);
            %             figure; plot(concatDataAll(1:0.6*fs));
            %             figure; plot(concatData{1}(1:0.6*fs));
            
            data  = int16(concatDataAll*(double(intmax('int16')) / max(abs(concatDataAll)) ));
            
            textName = [neuronTxt 'Exp-' sprintf('%02d',j) '_Rec-' sprintf('%02d',k) '_Data.mat'];
            saveName = [saveDir textName];
            save(saveName, 'data', '-v7.3')
            
            textName = [neuronTxt 'Exp-' sprintf('%02d',j) '_Rec-' sprintf('%02d',k) '_INFO.mat'];
            saveName = [saveDir textName];
            save(saveName, 'INFO', '-v7.3')
            disp('saveName');
            disp('')
            
        end
        clear('INFO')
        
    end
end

end
