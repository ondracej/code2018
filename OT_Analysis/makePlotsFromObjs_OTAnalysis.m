function [] = makePlotsFromObjs_OTAnalysis()
dbstop if error
%WN_ObjDir = 'E:\OT\OTAnalysis\allWNsJanie\allObjs\CombinedData\';
%WN_ObjDir = 'E:\OT\OTAnalysis\allWNsJanie\allObjs\forUncombinedData\';
WN_ObjDir = 'E:\OT\OTAnalysis\allWNsJanie\allObjs\forCombinedData\';

WNVers = 2;
extSearch = ['*.mat*'];
allWNObjs=dir(fullfile(WN_ObjDir,extSearch));

nObjs = numel(allWNObjs);


for j = 1:nObjs
    
o = load([WN_ObjDir allWNObjs(j).name]);
if WNVers == 1

OBJS = o.OBJS;
OBJS  = OBJS.dataSet1.C_OBJ;
combinedSpikes = o.combinedSPKS;
elseif WNVers == 2
   OBJS = o.C_OBJ;
   combinedSpikes = OBJS.S_SPKS.SORT.allSpksMatrix;
end

    plotWNRaster(combinedSpikes,OBJS, allWNObjs(j).name)

end



end



function [] = plotWNRaster(combinedSpikes,obj, fileName)


  
%             gray = [0.8 0.8 0.8];
%             figH = figure(101);clf
            allSpksMatrix = combinedSpikes;
            epochLength_samps = obj.S_SPKS.INFO.epochLength_samps;
%             stimStart_samp = obj.S_SPKS.INFO.stimStart_samp;
%             stimStop_samp = obj.S_SPKS.INFO.stimStop_samp;
%             spk_size_y = 0.005;
%             y_offset_between_repetitions = 0.001;
%             thisUniqStimFR  = zeros(1,epochLength_samps); % we define a vector for integrated FR
%             allSpksFR = zeros(epochLength_samps,1);
            
            %% Concat all responses
            Fs = obj.Fs;
            
            nStimTypes = numel(allSpksMatrix);
            stimLength_samps = epochLength_samps;
            stimLength_s = epochLength_samps/Fs;
            
            %timePoints = 1:1:stimLength_samps;
            figure(102); clf
            subplot(4, 1, [1 2 3])
            cnt = 1;
            allPSTH = [];
            for k = 1:nStimTypes
                thisStim = combinedSpikes{k};
                thisStim_PSTH = zeros(1, stimLength_samps);
                for s = 1:numel(thisStim)
                    
                    thisSpikeResp = thisStim{s};
                    
                    for sind = 1 : numel(thisSpikeResp)
                        thisStim_PSTH(thisSpikeResp(sind)) = thisStim_PSTH(thisSpikeResp(sind)) +1;
                    end
                    
                    yes = ones(1, numel(thisSpikeResp))*cnt;
                    hold on
                    plot(thisSpikeResp, yes, 'color',[255-k*255/nStimTypes 50 k*255/nStimTypes]/255, 'Marker', '.', 'LineStyle', 'none');
                    cnt = cnt+1;
        
                end
                allPSTH(k,:) = thisStim_PSTH;
                
            end
            
            subplot(4, 1, [1 2 3])
            xlim([0 stimLength_samps])
            set(gca,'xtick',[])
            title(fileName(1:end-13))
            
            subplot(4, 1, [4]); cla
            timepoints_samp = 1:1:stimLength_samps;
            timepoints_ms = timepoints_samp/Fs*1000;
            for k = 1:nStimTypes
                hold on
                thisPsth = allPSTH(k,:);
                smoothPSTH = smooth(thisPsth, 0.005*Fs);
                plot(timepoints_ms , smoothPSTH , 'color',[255-k*255/nStimTypes 50 k*255/nStimTypes]/255);
            end
            xlabel('Time (ms)')
            yss = ylim;
            line([100 100], [yss(1) yss(2)], 'color', 'k')   
            line([200 200], [yss(1) yss(2)], 'color', 'k')   
            %%
            disp('Printing Plot')
            
            %FigSavePath = 'E:\OT\OTAnalysis\allWNsJanie\allObjs\CombinedData\AllWNFigs\';
            %FigSavePath = 'E:\OT\OTAnalysis\allWNsJanie\allObjs\forUncombinedData\AllWNFigs\';
            FigSavePath = 'E:\OT\OTAnalysis\allWNsJanie\allObjs\forCombinedData\AllWNFigs\';
            saveName = [FigSavePath fileName(1:end-13) '_WNRaster'];
            
            plotpos = [0 0 12 15];
            print_in_A4(0, saveName, '-djpeg', 0, plotpos);
            
end
