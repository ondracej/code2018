function [] = combineOTObjectDataSets()

clear all
dbstop if error
close all

dbstop if error

experiment = 5; %efc
recSession = 4; %sc

audSelInd_1 = 2; % This is the index, not the stim number!!!
audSelInd_2 = 6; % This is the index, not the stim number!!!

expTxt = ['__E' num2str(experiment) '-Rs' num2str(recSession)];

%%
%[OT_DB] = OT_database();

%% Create Chicken Analysis Object

C_OBJ = chicken_OT_analysis_OBJ(experiment, recSession);

%% %% Stimulus Protocol
% Stim Protocol: (1) HRTF; (2) Tuning; (3) IID; (4) ITD; (5) WN

selection = C_OBJ.RS_INFO.ResultDirName{audSelInd_1};
disp(selection)

disp('Loading Saved Object...')

audStimDir = C_OBJ.RS_INFO.ResultDirName{audSelInd_1};
objFile = 'C_OBJ.mat';
objPath = [C_OBJ.PATHS.OT_Data_Path C_OBJ.INFO.expDir C_OBJ.PATHS.dirD audStimDir C_OBJ.PATHS.dirD '__Spikes' C_OBJ.PATHS.dirD objFile];
dataSet1 = load(objPath);

%% %% Stimulus Protocol
% Stim Protocol: (1) HRTF; (2) Tuning; (3) IID; (4) ITD; (5) WN

C_OBJ = chicken_OT_analysis_OBJ(experiment, recSession);
selection = C_OBJ.RS_INFO.ResultDirName{audSelInd_2};

%% RE Loading Object 0 ONLY USE IF analyzed before!!!
%%
disp('Loading Saved Object...')

audStimDir = C_OBJ.RS_INFO.ResultDirName{audSelInd_2};
objFile = 'C_OBJ.mat';
objPath = [C_OBJ.PATHS.OT_Data_Path C_OBJ.INFO.expDir C_OBJ.PATHS.dirD audStimDir C_OBJ.PATHS.dirD '__Spikes' C_OBJ.PATHS.dirD objFile];
dataSet2 = load(objPath);


%% Making Rasters

allFR = [];
for q = 1:2
    
    thisObj = [];
    if q == 1
        thisObj= dataSet1.C_OBJ;    
    elseif q == 2
        thisObj= dataSet2.C_OBJ;
    end
    
    data = thisObj.S_SPKS.SORT.AllStimResponses_Spk_s;
    nStims = thisObj.S_SPKS.INFO.nStims;
    nReps = thisObj.S_SPKS.INFO.nReps;
    
    
    range = 0:300;
    cnt = 1;
    Twin_s = 0.3;
    
    FR_spks = [];
    for j = 1:nStims
        for k = 1:nReps
            
            spks = (data{1, j}{1,k})*1000;
            
            %these_spks_on_chan = spks(spks >= reshapedOnsets(p) & spks <= reshapedOffsets(p))-reshapedOnsets(p);
            
            %FRs(k) = numel(spks(spks >= range (1) & spks <= range (end)));
            
            FR_spks(cnt) = (numel(spks(spks >= range (1) & spks <= range (end))))/Twin_s;
            
            cnt = cnt+1;
            disp('')
        end
        
    end
    
    allFR{q} = FR_spks;
    
end

[p,h] = ranksum(allFR{1},allFR{2});

sigText = ['p = ' num2str(p) ', h = ' num2str(h)];


figH = figure (201); clf

plotRaster(dataSet1, 1)

annotation(figH,'textbox',...
    [0.05 0.9 0.50 0.1],...
    'String',{sigText},...
    'LineStyle','none',...
    'FitBoxToText','off');

plotRaster(dataSet2, 2)

%% Combining spikes
DataToUseDir = '/home/janie/Data/TUM/OTAnalysis/CombinedDataJanie/';

prompt = 'Combine these data sets? 1=yes; 0=no:      ';

answer = input(prompt);

if answer ==1
    sortedSpikes1 = dataSet1.C_OBJ.S_SPKS.SORT.allSpksMatrix;
    sortedSpikes2 = dataSet2.C_OBJ.S_SPKS.SORT.allSpksMatrix;
    
    combinedSPKS = [];
    for k = 1: size(sortedSpikes1, 1)
        for j = 1: size(sortedSpikes1, 2)
            combinedSPKS{k, j} = [sortedSpikes1{k, j} sortedSpikes2{k, j}];
        end
    end
    
TAGEND = '-Combined';
OBJS.dataSet1 = dataSet1;
OBJS.dataSet2 = dataSet2;

disp('Data combined')

savePath = [DataToUseDir dataSet1.C_OBJ.PATHS.audStimDir expTxt TAGEND];

disp('Saving Objects...')
tic
save(savePath, 'OBJS', 'combinedSPKS', '-v7.3')
toc
disp(['Saved: '  savePath])

elseif answer ==0;
    TAGEND = '-NOTCombined';
    disp('Data not combined')
    disp('Not saving data')
end

disp('Printing Plot')
set(0, 'CurrentFigure', figH)
plotpos = [0 0 35 40];
FigSavePath = [DataToUseDir dataSet1.C_OBJ.PATHS.audStimDir expTxt TAGEND];
print_in_A4(0, FigSavePath, '-djpeg', 0, plotpos);
disp(['Saved Figure: '  FigSavePath ])
    
%%


%% Print Figure


%%
end


function [] = plotRaster(dataSet, plotnum)

subplot(2, 1, plotnum)
blueCol = [0.2 0.7 0.8];

n_elev = 13;
n_azim = 33;

scanrate = dataSet.C_OBJ.Fs;
cnt = 1;

sortedData = dataSet.C_OBJ.S_SPKS.SORT.allSpksMatrix;
sortedDataNames = dataSet.C_OBJ.S_SPKS.SORT.allSpksStimNames;

nReps = dataSet.C_OBJ.S_SPKS.INFO.nReps;
repsToPlot = 1:nReps;

for azim = 1:n_azim
    for elev = 1:n_elev
        
        for k = repsToPlot
            
            %must subtract start_stim to arrange spikes relative to onset
            theseSpks_ms = (sortedData{elev, azim}{1,k}) /scanrate *1000;
            ypoints = ones(numel(theseSpks_ms))*cnt;
            hold on
            plot(theseSpks_ms, ypoints, 'k.', 'linestyle', 'none', 'MarkerFaceColor','k','MarkerEdgeColor','k')
            
            cnt = cnt +1;
            
        end
        if elev == n_elev
            line([0 300], [cnt cnt], 'color', blueCol)
            %text(-20, cnt-30, (sortedDataNames{elev, azim}(4:10)))
        end
    end
end
set(gca,'ytick',[])

title (dataSet.C_OBJ.PATHS.audStimDir)
%xlabel('Time [ms]')
ylabel('Reps | Azimuth')
axis tight

end
