function [] = ConvertAudioSpikeToPlexon()
dbstop if error
%{
% 
% AllNeurons = {'N-03'; 'N-10'; 'N-12'; 'N-16'; 'N-17';'N-21';'N-23'; 'N-24';
%     'N-25'; 'N-26'; 'N-27'; 'N-28'; 'N-29'; 'N-31'; 'N-32'; 'N-33'; 'N-34';
%     'N-37'; 'N-39';'N-40'; 'N-42';'N-43';'N-44'};
% 
% AllExps =       [1; 1; 1; 2; 2; 2; 3; 3; 3; 3; 3; 4; 4; 4; 4; 5; 5; 6; 6; 6; 7; 7; 7];
% EllRs =         [3; 10; 12; 4; 5; 9; 2; 3; 4; 5; 6; 1; 2; 4; 5; 1; 2; 1; 3; 4; 2; 3; 4];


% AllNeurons =    {'N-24';'N-26';'N-32'};
% AllExps =       [3; 3; 4];
% EllRs =         [3; 5; 5];

%% WN neurons
%  AllNeurons =    {'N-04'; 'N-03'; 'N-05'; 'N-06'; 'N-07';'N-08';'N-09';'N-10'; 'N-11'; 'N-12'; 'N-13'; 'N-14'; 'N-15'; 'N-16'; 'N-17';'N-19'; 'N-20'; 'N-21';'N-23';
%      'N-25'; 'N-27'; 'N-28'; 'N-29'; 'N-30'; 'N-31';'N-33'; 'N-34'; 'N-35'; 'N-36'; 'N-37';'N-38';'N-39';'N-40'; 'N-41';'N-42';'N-43';'N-44';'N-45';'N-46'};
% AllExps =       [1; 1; 1; 1; 1; 1; 1; 1; 1;  1; 2;2;2;2; 2; 2; 2; 2; 2; 3;3;3;4;4;4;4;5;5;5;5;6;6;6;6;7;7;7;7;8;8];
% EllRs =         [4; 3; 5;6;7;8;9; 10; 11 ;12; 1;2;3;4;  5; 6;7; 8;9;2;4;6;1;2;3;4;1;2;3;4;1;2;3;4;1;2;3;4;1;2];

%}

exps = [ones(1, 12) ones(1, 9)*2 ones(1, 6)*3 ones(1, 5)*4 ones(1, 4)*5 ones(1, 4)*6 ones(1, 4)*7 ones(1, 2)*8 ones(1, 1)*9 ones(1, 1)*10 ones(1, 2)*12 ones(1, 1)*13 ones(1, 4)*14 ones(1, 3)*15];
recs = [1:1:12 1:1:9 1:1:6 1:1:5 1:1:4 1:1:4 1:1:4 1:1:2 1 1 1:1:2 1 1:1:4 1:1:3];
Neurons = 1:1:58;

%WN
%ExpInds = [3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 19 20 21 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 42 43 44]; 

%HRTF
ExpInds = [3 8 10 12 13 16 17 19 21 23 24 25 26 27 28 29 31 33 34 36 37 38 39 40 41 42 43 44 45 46]; %HRTF, 12 16 17 21 37 42 43 are inhibited by sound



%saveDir = 'X:\Janie-OT-MLD\PlexonData-WN_2025\';
saveDir = 'X:\Janie-OT-MLD\PlexonData-HRTF_2025\';


    % 5 = WN
    % 1 = HRTF
    % 2 = Tuning
    
stimIDsToUse = [1];

for E = 6:numel(ExpInds)
    thisInd = ExpInds(E);
    %for E = 2
    
    neuronTxt = ['N-' num2str(Neurons(thisInd )) '-' ];
    
    exp = exps(thisInd );
    Rs = recs(thisInd );
    
    
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
