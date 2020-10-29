%% wrapperForSTAAnalysis
close all
clear all
dbstop if error

exps = [ones(1, 12) ones(1, 9)*2 ones(1, 6)*3 ones(1, 5)*4 ones(1, 4)*5 ones(1, 4)*6 ones(1, 4)*7 ones(1, 2)*8 ones(1, 1)*9 ones(1, 1)*10 ones(1, 2)*12 ones(1, 1)*13 ones(1, 4)*14 ones(1, 3)*15];
recs = [1:1:12 1:1:9 1:1:6 1:1:5 1:1:4 1:1:4 1:1:4 1:1:2 1 1 1:1:2 1 1:1:4 1:1:3];
Neurons = 1:1:58;

%% HRTF

ExpInds = [3 8 10 12 13 16 17 19 21 23 24 25 26 27 28 29 31 32 33 34 36 37 38 39 40 41 42 43 44 45 46]; %HRTF, 12 16 17 21 37 42 43 are inhibited by sound

%AllExpInds = [3 8 10 12 13 16 17 19 21 22 23 24 25 26 27 28 29 31 32 33 34 36 37 38 39 40 41 42 43 44 45 46 48 49 52 53 56 58 ]; %HRTF, 12 16 17 21 37 42 43 are inhibited by sound

%nInds = numel(AllExpInds);
WNRasterInd = [ 10  28 42 23 33 27 29  25 44 34  40 39 31  3   17 43 21  ]; %WN, 2, 4 12 16 17 20 21 37 42 43 are inhibited by sound
WNRasterInd = fliplr(WNRasterInd);

%HRTFExpInds = [27 40 3 39 31]; %Stims
%HRTFExpInds = [23 29 28 36 10]; %Onset
%HRTFExpInds = [28 16 17 42 43 ]; %Other

nInds = numel(WNRasterInd);
figure(406); clf
for j = 1:nInds
    
    thisInd = WNRasterInd(j);
    thisInd
   
    experiment = exps(thisInd);
    recSession = recs(thisInd);
    NeuronName = ['N-' num2str(Neurons(thisInd))];
    
    %STA_for_HRTF_Stims(experiment, recSession, NeuronName)
    %EnvCalc_for_HRTF_Stims(experiment, recSession, NeuronName)
    
    %AnalysiWindowDefinition_HRTF(experiment, recSession, NeuronName)
    %plotNormHRTFWinSelection(experiment, recSession, NeuronName, j, 5)
    
    %STRF_preprocessing_OT(experiment, recSession, NeuronName)
    
    RastersForAmplitudeEnvelopHRTF(experiment, recSession, NeuronName, j)
    
end
%%

%% WN

%WN_ExpInds = [1 3 5 6 7 8 9 10 11 13 14 15 18 19 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 38 39 40 44 47]; %WN, 2, 4 12 16 17 20 21 37 42 43 are inhibited by sound
%AllWN_ExpInds = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 42 43 44 47]; %WN, 2, 4 12 16 17 20 21 37 42 43 are inhibited by sound
%AllWN_ExpInds = [3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 19 20 21 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 42 43 44 ]; %WN, 2, 4 12 16 17 20 21 37 42 43 are inhibited by sound
WNRasterInd = [ 10  28 42 23 33 27 29  25 44 34  40 39 31  3   17 43 21  ]; %WN, 2, 4 12 16 17 20 21 37 42 43 are inhibited by sound

WNRasterInd = fliplr(WNRasterInd);
figure(406); clf
%nInds = numel(WN_ExpInds);
nInds = numel(WNRasterInd);
for j = 1:nInds
    
    %thisInd = WN_ExpInds(j);
    thisInd = WNRasterInd(j);
    
%     if thisInd <=40
%         audSelInd = 1;
%     elseif thisInd > 40
%         audSelInd = 2;
%     end
    
    experiment = exps(thisInd);
    recSession = recs(thisInd);
    NeuronName = ['N-' num2str(Neurons(thisInd))];
    
   %STA_for_WN_Stims(experiment, recSession, NeuronName)
   
    RastersForAmplitudeEnvelopWN(experiment, recSession, NeuronName, j)
    %EnvCalc_for_WN_Stims(experiment, recSession, NeuronName)
end

%%



%experiment =    [1; 1; 1; 2; 2; 3; 3; 3; 3; 3; 3; 4; 4; 4; 4; 5; 5; 5; 6; 6; 6; 6; 7; 7; 7; 7; 8; 8; 10; 12; 14; 14; 15; 15];
%recSession =    [3; 8; 10; 1; 7; 1; 2; 3; 4; 5; 6; 1; 2; 4; 5; 1; 2; 4; 1; 2; 3; 4; 1; 2; 3; 4; 1; 2; 1; 1; 1; 2; 1; 3];



%audSelInd =     [2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 1; 1; 1; 1; 2; 2; 1; 1; 1; 1; 1; 1];
%NeuronName = {'N-03'; 'N-08'; 'N-10'; 'N-13'; 'N-19'; 'N-22'; 'N-22'; 'N-24'; 'N-25'; 'N-26'; 'N-27'; 'N-28'; 'N-29'; 'N-31'; 'N-32'; 'N-33'; 'N-34'; 'N-36';...
%'N-37'; 'N-38'; 'N-39'; 'N-40';'N-41';'N-42'; 'N-43'; 'N-44'; 'N-45'; 'N-46'; 'N-48'; 'N-52'; 'N-53'; 'N-56'; 'N-58'};



