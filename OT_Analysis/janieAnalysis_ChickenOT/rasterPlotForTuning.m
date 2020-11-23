function [] = rasterPlotForTuning()


ObjDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/allTuningObjs/';

saveDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/Figs/TuningRasters/';
trialSeach = ['*.mat*'];

trialNamesStruct = dir(fullfile(ObjDir, trialSeach));
nTrials = numel(trialNamesStruct);
for j = 1:nTrials
    trialNames{j} = trialNamesStruct(j).name;
end

%%


for s = 7:nTrials
    
    d = load([ObjDir trialNames{s}]);
    
    C_OBJ = d.C_OBJ;
    
    bla = C_OBJ.STIMS;
    
    allSpksMatrix = C_OBJ.S_SPKS.SORT.allSpksMatrix;
    epochLength_samps = C_OBJ.S_SPKS.INFO.epochLength_samps;
    thisUniqStimFR  = zeros(1,epochLength_samps); % we define a vector for integrated FR
    
    
    stimNames = C_OBJ.S_SPKS.SORT.allSpksStimNames;
    
    
    nStimTypes = numel(allSpksMatrix);
    lounessappend = [50 55 60 65 70 75 80 85 90 95 100 105 110];
    
    conCatAll = [];
    allnames = [];
    cnt =1;
    for k = 1:size(allSpksMatrix, 2) %40
        for j = 1:size(allSpksMatrix, 1) % 11, 13
  %      for j = loudnesses
       
   %         for k = freqs
            
            nTheseReps = numel(allSpksMatrix{j, k});
            for o = 1: nTheseReps
            
                conCatAll{cnt} = allSpksMatrix{j,k}{1,o};
                allnames{cnt} = [stimNames{j,k} '-' num2str(lounessappend(j))];
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
    cnt = 1;
    blacnt  = 1;
    for q = 1 : nAllReps
    
        these_spks_on_chan = conCatAll{q};
        
        ys = ones(1, numel(these_spks_on_chan))*cnt;
        hold on
        plot(these_spks_on_chan, ys, '.', 'color', 'k', 'linestyle', 'none')
        
        nbr_spks = size(these_spks_on_chan, 2);
        
        if mod(cnt, nTheseReps*size(allSpksMatrix, 1)) == 0
            line([0 epochLength_samps], [cnt cnt], 'color', blueCol)
            text(0, cnt-30, allnames{q})
            blacnt = blacnt +1;
        end
        cnt = cnt+1;
        
    end
    ylim([0 nAllReps])
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


