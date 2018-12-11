function [] = sortSpikesAndMakeRasters(spikes, ClustOfSpikes, stimInfo, Stims, FinalSavePath)

Fs = stimInfo.Fs;
nStims = stimInfo.nStims;
nUniqueStimC2 = stimInfo.nUniqueStimC2;
nUniqueStimC1 = stimInfo.nUniqueStimC1;
epochLength_samps = stimInfo.epochLength_samps;
preStim_samps = stimInfo.preStim_samps;
stimEnd_samps = stimInfo.stimEnd_samps;
stimEpochs = stimInfo.stimEpochs;

dbstop if error

nDiffSpikes = numel(ClustOfSpikes);
%clustLabels = unique(spikes.assigns);
clustSpks = spikes.assigns; % For all spikes, which one belongs to which cluster

EpochAssignments = spikes.trials;

spiketimes = spikes.spiketimes;

allClustAssignments = [];
for q = 1:nDiffSpikes
    allClustAssignments{q} = find(clustSpks == ClustOfSpikes(q));
end

%% Major Sorting now
Spks = [];
for q = 1:nDiffSpikes
    theseSpikesInds = allClustAssignments{q};
    
    theseSpikeTimes_s = spiketimes(theseSpikesInds);
    theseSpikeTimes_samp = round(theseSpikeTimes_s*Fs);
    
    theseEpochAssignmentsForThisClust = EpochAssignments(theseSpikesInds);
    
    AllStimResponses_Spk_samp = [];
    AllStimResponses_Spk_s = [];
    for s = 1:nStims
        
        theseEpochs = stimEpochs{s};
        spkResponses_samp = cell(1, numel(theseEpochs));
        spkResponses_s = cell(1, numel(theseEpochs));
        
        match = ismember(theseEpochs, theseEpochAssignmentsForThisClust);
        
        if sum(match) == 0 % no spiking responses
            AllStimResponses_Spk_samp{s}  = spkResponses_samp;
            AllStimResponses_Spk_s{s} = spkResponses_s;
            
        else
            matchInds_Epoch = theseEpochs(match);
            matchInds_ThisStim = find(match ==1);
            nMatchInds = numel(matchInds_ThisStim);
            
            for e = 1:nMatchInds
                thisEpochInd = matchInds_Epoch(e);
                thisStimInd = matchInds_ThisStim(e);
                
                spkInds = find(theseEpochAssignmentsForThisClust == thisEpochInd);
                nSpkInds = numel(spkInds);
                
                thisSpk_samp = []; thisSpk_s = [];
                
                for spk = 1:nSpkInds
                    thisSpkInd = spkInds(spk);
                    thisSpk_samp(spk) = theseSpikeTimes_samp(thisSpkInd);
                    thisSpk_s(spk) = theseSpikeTimes_s(thisSpkInd);
                end
                
                spkResponses_samp{thisStimInd} = thisSpk_samp;
                spkResponses_s{thisStimInd} = thisSpk_s;
            end
            
            AllStimResponses_Spk_samp{s} = spkResponses_samp;
            AllStimResponses_Spk_s{s} = spkResponses_s;
        end
    end
    
    
    Spks{q}.AllStimResponses_Spk_samp = AllStimResponses_Spk_samp;
    Spks{q}.AllStimResponses_Spk_s = AllStimResponses_Spk_s;
    
    disp('')
end

%% Make Rasters


%
%         if nUniqueStimC1 < nUniqueStimC2
%             num_rows = nUniqueStimC1;
%             num_cols = nUniqueStimC2;
%         else
%             num_rows = nUniqueStimC2;
%             num_cols = nUniqueStimC1;
%         end
%






%% Reshape spikes into a matrix according to the stims

for q = 1:nDiffSpikes
    cnt = 1;
    allSpksMatrix = []; allSpksStimNames = [];
    for o = 1:nUniqueStimC2
        for oo = 1:nUniqueStimC1
            allSpksMatrix{o,oo} = Spks{q, 1}.AllStimResponses_Spk_samp{cnt};
            allSpksStimNames{o,oo} = Stims.stimName{cnt};
            cnt = cnt+1;
        end
    end
end

epchLength_ms = (epochLength_samps/Fs)*1000;
xticks_ms = 0:50:epchLength_ms;
xticks_samps = (xticks_ms/1000)*Fs;

%%
gray = [0.8 0.8 0.8];
figH = figure(101);clf
for o = 1:nUniqueStimC2
    for oo = 1:nUniqueStimC1
        
        thisStim_spks = allSpksMatrix{o,oo};
        this_nStims = numel(thisStim_spks );
        %stimsWSpikes_log = cellfun(@(x) ~isempty(x), thisStim_spks);
        
        thisStimMatrix = nan(epochLength_samps, this_nStims);
        
        for q = 1:this_nStims
            
            theseSpks = thisStim_spks{q};
            
            thisStimMatrix(theseSpks) = q;
            
            %y_low =  (q * spk_size_y - spk_size_y);
            %y_high = (q * spk_size_y - y_offset_between_repetitions);
            
            %spk_vct = repmat(theseSpks, 2, 1); % this draws a straight vertical line
            %this_run_spks = size(spk_vct, 2);
            %ln_vct = repmat([y_high; y_low], 1, this_run_spks); % this defines the line height
            
            
            %line(spk_vct, ln_vct, 'LineWidth', 0.5, 'Color', 'k');
            
            %nspks = size(theseSpks, 2);
            %axis tight
            %axis off
        end
        
        allSpkMatrix_nan{o,oo} = thisStimMatrix;
        
        pos = getAxPos(nUniqueStimC2, nUniqueStimC1, o, oo);
        axes('position', pos);
        area([preStim_samps  stimEnd_samps], [this_nStims this_nStims], 'FaceColor', gray, 'EdgeColor', gray)
        hold on
        plot(thisStimMatrix, 'k.')
        hold on
        
        %line([preStim_samps preStim_samps], [0 this_nStims], 'color', 'k')
        %line([stimEnd_samps stimEnd_samps], [0 this_nStims], 'color', 'k')
        
        line([0 0], [0 this_nStims], 'color', 'k')
        line([epochLength_samps epochLength_samps], [0 this_nStims], 'color', 'k')
        line([0 epochLength_samps], [0 0], 'color', 'k')
        line([0 epochLength_samps], [this_nStims this_nStims], 'color', 'k')
        
        ylim([0 this_nStims])
        xlim([0 epochLength_samps])
        
        
        
        
        set(gca, 'xtick', xticks_samps)
        
        
        for j = 1:numel(xticks_samps)
            xlabs{j} = num2str(xticks_ms(j));
            
        end
        
        set(gca, 'xticklabel', xlabs)
        xlabel('Time [ms]')
        
        
        
        
        % axis off
        disp('')
    end
    
    %xtimepoints_samps = 1:epochLength_samps;
    %xtimepoints_ms = (xtimepoints_samps/Fs)*1000;
    
    
end

disp('')

%%
figure(figH)

disp('Printing Plot')
set(0, 'CurrentFigure', figH)

FigSaveName = [FinalSavePath '_raster'];

plotpos = [0 0 40 20];
%print_in_A4(0, FigSaveName, export_to, 0, plotpos);
print_in_A4(0, FigSaveName, '-djpeg', 0, plotpos);

save(FinalSavePath, 'spikes', 'ClustOfSpikes', 'stimInfo', 'Stims', 'allSpksMatrix', 'allSpkMatrix_nan', 'allSpksStimNames')

disp(['Saved: ' FinalSavePath])

end

