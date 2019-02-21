function [] = combineOTObjectDataSets()

clear all
dbstop if error
close all

dbstop if error
%%
%[OT_DB] = OT_database();

%% Create Chicken Analysis Object

experiment = 3; %efc
recSession = 4; %sc

C_OBJ = chicken_OT_analysis_OBJ(experiment, recSession);

%% %% Stimulus Protocol
% Stim Protocol: (1) HRTF; (2) Tuning; (3) IID; (4) ITD; (5) WN

audSelInd = 2; % This is the index, not the stim number!!!

selection = C_OBJ.RS_INFO.ResultDirName{audSelInd};
disp(selection)

%% RE Loading Object 0 ONLY USE IF analyzed before!!!
%%
disp('Loading Saved Object...')

audStimDir = C_OBJ.RS_INFO.ResultDirName{audSelInd};
objFile = 'C_OBJ.mat';
objPath = [C_OBJ.PATHS.OT_Data_Path C_OBJ.INFO.expDir C_OBJ.PATHS.dirD audStimDir C_OBJ.PATHS.dirD '__Spikes' C_OBJ.PATHS.dirD objFile];
dataSet1 = load(objPath);

%%

disp(['Loaded: ' objPath])

experiment = 3; %efc
recSession = 4; %sc

C_OBJ = chicken_OT_analysis_OBJ(experiment, recSession);

%% %% Stimulus Protocol
% Stim Protocol: (1) HRTF; (2) Tuning; (3) IID; (4) ITD; (5) WN

audSelInd = 6; % This is the index, not the stim number!!!

selection = C_OBJ.RS_INFO.ResultDirName{audSelInd};


%% RE Loading Object 0 ONLY USE IF analyzed before!!!
%%
disp('Loading Saved Object...')

audStimDir = C_OBJ.RS_INFO.ResultDirName{audSelInd};
objFile = 'C_OBJ.mat';
objPath = [C_OBJ.PATHS.OT_Data_Path C_OBJ.INFO.expDir C_OBJ.PATHS.dirD audStimDir C_OBJ.PATHS.dirD '__Spikes' C_OBJ.PATHS.dirD objFile];
dataSet2 = load(objPath);


%% Making Rasters


plotRaster(dataSet1, 1)
plotRaster(dataSet2, 2)

%% Combining spikes

prompt = 'Combine these data sets? 1=yes; 0=no';

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
    
elseif answer ==0;
    
    disp('Data not combined')
end

%%

OBJS.dataSet1 = dataSet1;
OBJS.dataSet2 = dataSet2;

DataToUseDir = '/media/janie/Data64GB/OTData/OT/CombinedDataJanie/';
savePath = [DataToUseDir dataSet1.C_OBJ.PATHS.audStimDir '-Combined'];

save(savePath, 'OBJS', '-v7.3')
disp(['Saved: '  savePath])
 


%%
end


function [] = plotRaster(dataSet, plotnum)



figH = figure (201);
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
