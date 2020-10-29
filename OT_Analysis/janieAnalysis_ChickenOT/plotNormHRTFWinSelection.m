function [] = plotNormHRTFWinSelection(experiment, recSession, NeuronName, oo, nNeuronsInSet)
dbstop if error
if nargin <3
    
    experiment = 1;
    recSession = 3;
    NeuronName = 'N-03';
end

C_OBJ = chicken_OT_analysis_OBJ(experiment, recSession);

%%
allStims = C_OBJ.RS_INFO.StimProtocol_name;
tf = find(strcmpi(allStims,'HRTF'));

audSelInd = tf(1); % SpikesThis is the index, spikesnot the stim number!!!
Stim = C_OBJ.RS_INFO.StimProtocol_name{audSelInd};
disp(Stim);

FigSaveDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/ForPaper/';

%% Stimulus Protocol
% Stim Protocol: (1) HRTF; (2) Tuning; (3) IID; (4) ITD; (5) WN

selection = C_OBJ.RS_INFO.ResultDirName{audSelInd};
disp(selection)

%% RE Loading Object 0 ONLY USE IF analyzed before!!!
%%

disp('Loading Saved Object...')

audStimDir = C_OBJ.RS_INFO.ResultDirName{audSelInd};
objFile = 'C_OBJ.mat';
objPath = [C_OBJ.PATHS.OT_Data_Path C_OBJ.INFO.expDir C_OBJ.PATHS.dirD audStimDir C_OBJ.PATHS.dirD '__Spikes' C_OBJ.PATHS.dirD objFile];
load(objPath);
disp(['Loaded: ' objPath])


%%
nallSpks = numel(C_OBJ.SPKS.spikes.spiketimes);

nStims = C_OBJ.S_SPKS.INFO.nStims;
nReps = C_OBJ.S_SPKS.INFO.nReps;
saveName = C_OBJ.PATHS.audStimDir;


%%
analysisWin_ms = 20;
totalRecDuration_ms = 300;
Fs = C_OBJ.SETTINGS.SampleRate;

StimWins_ms = 0:analysisWin_ms:totalRecDuration_ms-analysisWin_ms;
StimWins_samps = StimWins_ms/1000*Fs;
nWins = numel(StimWins_samps);
totalRec_samps = totalRecDuration_ms/1000*Fs;

spkTimes_samp = C_OBJ.S_SPKS.SORT.AllStimResponses_Spk_samp;

%% Stim (Rest)

spks_stims = [];
sumsOverAllReps = [];
for j = 1:nStims
    Spks_reps = [];
    for k = 1:nReps
        
        spks = (spkTimes_samp{1, j}{1,k});
        
        Spks_wins = [];
        for w = 1:nWins % goes over the windows for a particular rep
            
            if w == nWins
                thisWinStart = StimWins_samps(w);
                thisWinEnd = totalRec_samps;
            else
                thisWinStart = StimWins_samps(w);
                thisWinEnd = StimWins_samps(w+1);
            end
            
            Spks_wins(w) = numel(spks(spks >= thisWinStart & spks <= thisWinEnd));
        end
        
        Spks_reps(k,:) = Spks_wins;
        
    end
    zscores = zscore(Spks_reps, 0, 'all');
    sumsOverAllReps(j,:) = sum(Spks_reps, 1);
    spks_stims{j} = Spks_reps;
    
end

%% Now making SRFs

%% Needs to be in this order

n_elev = 13;
n_azim = 33;

sumsOverAllReps = zscore(sumsOverAllReps, 0, 'all');
maxZ = round(max(max(sumsOverAllReps)));
minZ = round(min(min(sumsOverAllReps)));

%sumsOverAllReps = sumsOverAllReps;
alLWins = [];
for w = 1:nWins
    
    allStimInWin = sumsOverAllReps(:,w);
    
    ct = 1;
    thisWin = [];
    
    for elev = 1:n_elev
        for azim = 1:n_azim
            
            thisWin(elev, azim) = allStimInWin(ct);
            ct = ct+1;
        end
    end
    
    alLWins{w} = thisWin;
end

%% find mins and maxes of smoothed

for w = 1:nWins
    
    thisWin = alLWins{w};
    smoothThisWin = flipud(moving_average2(thisWin(:,:),1,1));% rows ;collumns
    
    minsOverSmoothedWins(w) = min(min(smoothThisWin));
    maxesOverSmoothedWins(w) = max(max(smoothThisWin));
    
end

MIN_smooth = min(minsOverSmoothedWins);
MAX_smooth = max(maxesOverSmoothedWins);



WinSet = [5 6 7 8 9 10 11 12];
numWins = numel(WinSet);
clims = [0 1];
switch oo
    
    case 1
        cnt = 1;
    case 2
        cnt = 9;
    case 3
        cnt = 17;
    case 4
        cnt = 25;
    case 5
        cnt = 33;
    case 6
        cnt = 41;
end

for w = 1:numWins
    thisWinInd = WinSet(w);
    
    thisWin = alLWins{thisWinInd};
    
    smoothedWin = flipud(moving_average2(thisWin(:,:),1,1));% rows ;collumns
    
    dataToPlot_smooth_norm = (smoothedWin-MIN_smooth) / (MAX_smooth - MIN_smooth);
    hold on
    
    plot_aSRF(dataToPlot_smooth_norm , 5, 8, cnt)
    caxis(clims)
    set(gca,'ytick',[])
    set(gca,'xtick',[])
    
    if cnt == 1
        title('Spont: -20-0 ms')
        ylabel({NeuronName; 'El.'});
    elseif cnt == 2
        title('Stim: 0-20 ms')
    elseif cnt == 3
        title('Stim: 20-40 ms')
    elseif cnt == 4
        title('Stim: 40-60 ms')
    elseif cnt == 5
        title('Stim: 60-80 ms')
    elseif cnt == 6
        title('Post: 80-100 ms')
    elseif cnt == 7
        title('Post: 100-120 ms')
    elseif cnt == 8
        title('Post: 120-140 ms')
    elseif cnt == 9
        ylabel({NeuronName; 'El.'});
    elseif cnt == 17
        ylabel({NeuronName; 'El.'});
    elseif cnt == 25
        ylabel({NeuronName; 'El.'});
    elseif cnt == 33
        ylabel({NeuronName; 'El.'});
        xlabel('Az.');
    elseif cnt == 34
        xlabel('Az.');
    elseif cnt == 35
        xlabel('Az.');
    elseif cnt == 36
        xlabel('Az.');
    elseif cnt == 37
        xlabel('Az.');
    elseif cnt == 38
        xlabel('Az.');
    elseif cnt == 39
        xlabel('Az.');
    elseif cnt == 40
        xlabel('Az.');
    end
    
    cnt  = cnt +1;
    
end


%%

%%
if oo == nNeuronsInSet
    
    
    disp('Printing Plot')
    figure(406)
    saveName = [FigSaveDir 'HRTF-aSRF-Stim'];
    
    plotpos = [0 0 50 30];
    print_in_A4(0, saveName, '-djpeg', 0, plotpos);
    print_in_A4(0, saveName, '-depsc', 0, plotpos);
end


end

function plot_aSRF(data, subplot1, subplot2, subplot3)

subplot(subplot1, subplot2, subplot3)
surf(data);
shading interp
view([ 0 90])
axis tight

% caxis([0 5])

end


