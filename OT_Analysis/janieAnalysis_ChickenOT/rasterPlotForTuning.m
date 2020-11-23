function [] = rasterPlotForTuning()


ObjDir = '/home/janie/Data/OTProject/MLD/TuningJanie/allObjs/';

saveDir = '/home/janie/Data/OTProject/MLD/Figs/TuningRasters/';
trialSeach = ['*.mat*'];

trialNamesStruct = dir(fullfile(ObjDir, trialSeach));
nTrials = numel(trialNamesStruct);
for j = 1:nTrials
    trialNames{j} = trialNamesStruct(j).name;
end

%%


for s = 17:nTrials
    
    d = load([ObjDir trialNames{s}]);
    
    C_OBJ = d.C_OBJ;
    
    
    
    allSpksMatrix = C_OBJ.S_SPKS.SORT.allSpksMatrix;
    epochLength_samps = C_OBJ.S_SPKS.INFO.epochLength_samps;
    thisUniqStimFR  = zeros(1,epochLength_samps); % we define a vector for integrated FR
    
    
    stimNames = C_OBJ.S_SPKS.SORT.allSpksStimNames;
    
    
    nStimTypes = numel(allSpksMatrix);
    
    
    conCatAll = [];
    cnt =1;
    for j = 1:size(allSpksMatrix, 1) % 11, 13
        for k = 1:size(allSpksMatrix, 2) %40
            
            nTheseReps = numel(allSpksMatrix{j, k});
            for o = 1: nTheseReps
                %    for k = 1: 15
                conCatAll{cnt} = allSpksMatrix{j,k}{1,o};
                allnames{cnt} = stimNames{j,k};
                cnt = cnt +1;
            end
            
        end
    end
    
    
    nAllReps = numel(conCatAll);
    %%
    
    %cols = {[0.6350, 0.0780, 0.1840], [0.8500, 0.3250, 0.0980], [0.9290, 0.6940, 0.1250], [0.4940, 0.1840, 0.5560], [0, 0.5, 0],[0, 0.4470, 0.7410],[0 0 0], [.7 .3 .7], [.7 .5 .7], [0.6350, 0.0780, 0.1840], [0.8500, 0.3250, 0.0980], [0.9290, 0.6940, 0.1250], [0.4940, 0.1840, 0.5560], [0, 0.5, 0],[0, 0.4470, 0.7410],[0 0 0], [.7 .3 .7],};
    
    %plotOrder = randperm(nAllReps);
    blueCol = [0.2 0.6 0.8];
    figure (104);  clf
    for q = 1 : nAllReps
    
        these_spks_on_chan = conCatAll{q};
        
        ys = ones(1, numel(these_spks_on_chan))*q;
        hold on
        plot(these_spks_on_chan, ys, '.', 'color', 'k', 'linestyle', 'none')
        
        nbr_spks = size(these_spks_on_chan, 2);
        
        if mod(q, 6*13) == 0
            line([0 epochLength_samps], [q q], 'color', blueCol)
        end
        
        
    end
    
    axis tight
    xlim([0 epochLength_samps])
    % ylabel(['Reps = ' num2str(nAllReps)])
    set(gca, 'xtick', []);
    set(gca, 'ytick', []);
    title(trialNames{s}(1:3))
    %%
    

saveName = [saveDir  trialNames{s}(1:4)  'TuningRaster'];

plotpos = [0 0 15 12];
print_in_A4(0, saveName, '-djpeg', 1, plotpos);
disp('')
print_in_A4(0, saveName, '-depsc', 1, plotpos);


    
end




end

