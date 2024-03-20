classdef chicken_OT_analysis_OBJ < handle


    properties (Access = public)

        INFO
        RS_INFO
        PATHS

        SETTINGS
        STIMS
        EPOCHS
        Fs

        O_STIMS

        FIG

        SPKS
        S_SPKS

    end


    methods

        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% ~~~~~Functions called by constructor
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function obj = getPathsAndDataDir(obj)

            switch gethostname

                case 'TURTLE'
                    dirD = '/';

                    addpath(genpath('/home/janie/Dropbox/codetocopy/AudioSpike/'));
                    addpath(genpath('/home/janie/Dropbox/codetocopy/janieAnalysis_ChickenOT/'));
                    addpath(genpath('/home/janie/Dropbox/codetocopy/UMS2K-master/'));

                    OT_Data_Path = '/home/janie/LRZ Sync+Share/OT_Analysis/OTAnalysis/allWNsJanie/allObjs/';


                case 'SALAMANDER'
                    dirD = '/';

                    addpath(genpath('/home/janie/Documents/Code/code2018/OT_Analysis/AudioSpikeTools/'));
                    addpath(genpath('/home/janie/Documents/Code/code2018/OT_Analysis/'));
                    addpath(genpath('/home/janie/Documents/Code/UMS2K-master/'));

                    OT_Data_Path = '/home/janie/Data/OTProject/OTData/Results/';


                case 'PLUTO'

                    dirD = '/';

                    addpath(genpath('/home/dlc/code/GitHub/code2018/OT_Analysis/AudioSpikeTools/'));
                    addpath(genpath('/home/dlc/code/GitHub/code2018/OT_Analysis/'));
                    addpath(genpath('/home/dlc/code/GitHub/UMS2K-master/'));

                    OT_Data_Path = '/media/dlc/Data8TB/TUM/OT/OTProject/OTData/Results/';

                case 'NEUROPIXELS'
                    dirD = '\';

                    addpath(genpath('C:\Users\Janie\Documents\GitHub\code2018\'));
                    %addpath(genpath('/home/dlc/code/GitHub/code2018/OT_Analysis/'));
                    %addpath(genpath('/home/dlc/code/GitHub/UMS2K-master/'));

                    OT_Data_Path = 'F:\OT-MLD\OT_Project_2021-Final\OTData\Results\';

            end


            obj.PATHS.dirD = dirD;
            obj.PATHS.OT_Data_Path = OT_Data_Path;

            %% If save to dropbox
            dropboxDir = '/home/janie/Data/TUM/OTAnalysis/allITDJanie/allObjs/Figs/';
            obj.PATHS.dropboxPath = dropboxDir;

        end


        %% Get session Info
        function obj=getSessionInfo(obj,efc, sc)

            disp('Getting session info...')


            [OT_DB] = OT_database();

            obj.INFO.expID = OT_DB(efc).expID;
            obj.INFO.expDir  = OT_DB(efc).expDir;
            obj.INFO.bird_number= OT_DB(efc).bird_number;
            obj.INFO.bird_age  = OT_DB(efc).bird_age;
            obj.INFO.bird_DOB  = OT_DB(efc).bird_DOB;
            obj.INFO.bird_sex  = OT_DB(efc).bird_sex;
            obj.INFO.bird_weight  = OT_DB(efc).bird_weight;
            obj.INFO.exp_number  = OT_DB(efc).exp_number;

            obj.RS_INFO.recording_session = OT_DB(efc).RS(sc).recording_session;
            obj.RS_INFO.DV_Coords = OT_DB(efc).RS(sc).DV_coords;

            obj.RS_INFO.StimProtocol_ID = OT_DB(efc).RS(sc).StimProtocol_ID;
            obj.RS_INFO.StimProtocol_name = OT_DB(efc).RS(sc).StimProtocol_name;
            obj.RS_INFO.ResultDirName = OT_DB(efc).RS(sc).ResultDirName;
            obj.RS_INFO.notes = OT_DB(efc).RS(sc).notes;

            expTextLabel = ['Exp_' num2str(obj.INFO.bird_number) '_S-' num2str(sc)];

            obj.RS_INFO.expTextLabel = expTextLabel;

            disp('')
            disp(['Available Stim Protocols: ' num2str(obj.RS_INFO.StimProtocol_ID)]);
            disp([obj.RS_INFO.StimProtocol_name]);


        end

        function obj = getAudioSpikeResults(obj, audSel)

            disp('Loading Audio Spike Results...')

            audStimDir = obj.RS_INFO.ResultDirName{audSel};

            %dirToLoad = '/home/janie/Data/TUM/Data/OT/Results/_data_20171214/01-HRTF_20171214_163624_0001/';
            resultsPath = [obj.PATHS.OT_Data_Path obj.INFO.expDir obj.PATHS.dirD audStimDir obj.PATHS.dirD];
            %resultsPath = ['/media/dlc/Data8TB/TUM/OT/OTProject/OTData/Results/' obj.INFO.expDir obj.PATHS.dirD audStimDir obj.PATHS.dirD];
            fileToLoad = [resultsPath 'result_0001.xml'];

            disp('loading results...')
            tic
            results = audiospike_loadresult(fileToLoad, 1);
            toc
            disp('finished loading results.')

            %%
            obj.SETTINGS = results.Settings;
            obj.Fs = obj.SETTINGS.SampleRate;

            obj.STIMS.StimulusSequence = results.StimulusSequence;
            obj.STIMS.AllStimuli = results.Stimuli;
            obj.STIMS.nStims = numel(obj.STIMS.AllStimuli);

            obj.EPOCHS.data = results.Epoches;
            obj.EPOCHS.nEpochs = numel(obj.EPOCHS.data);

            spkSavePath = [resultsPath '__Spikes' obj.PATHS.dirD];

            if exist(spkSavePath , 'dir') == 0
                mkdir(spkSavePath );
            end

            obj.PATHS.resultsPath = resultsPath;
            obj.PATHS.spkSavePath = spkSavePath;
            obj.PATHS.audStimDir = audStimDir;

            %%

        end


        function obj = organizeStimRepetitions(obj, audSelInd)

            %% Remap stim repetitions to particular epoch index

            nStims = obj.STIMS.nStims;
            StimulusSequence = obj.STIMS.StimulusSequence ;
            AllStimuli = obj.STIMS.AllStimuli;
            nEpochs = obj.EPOCHS.nEpochs;
            Epochs = obj.EPOCHS.data;
            audSel_ID = obj.RS_INFO.StimProtocol_ID(audSelInd);

            stimEpochs = cell(1, nStims); stimName = cell(1, nStims);
            for s = 1:nStims
                correspondEpochsInds = find(StimulusSequence == s); % Finds for each stim 1:x; which epochs that stim was played during
                stimEpochs{s} = correspondEpochsInds; % for each stim, which epochs that stim is on

                if audSel_ID ==3
                    stimName{s} = [num2str(AllStimuli(s).Level_1) '-' num2str(AllStimuli(s).Level_2)];
                elseif audSel_ID ==2
                    stimName{s} = [num2str(AllStimuli(s).Name) '-' num2str(AllStimuli(s).Level_1)];
                else
                    stimName{s} = AllStimuli(s).Name;
                end

            end

            allEpochStimInds = nan(1, nEpochs); allEpochData = cell(1, nEpochs);
            for j = 1:nEpochs
                allEpochStimInds(j) = Epochs(j).StimIndex; % Which stim was played during this epoch, in order of the epochs
                allEpochData{j} = Epochs(j).Data;
            end

            nEpochsHyp = numel(allEpochData);
            nEpochsRec = numel(find(cellfun(@(x) ~isempty(x), allEpochData)));

            if nEpochsRec ~= nEpochsHyp

                disp('************************* ')
                disp('**** INCOMPLETE FILE **** ')
                disp([num2str(nEpochsRec) '/' num2str(nEpochsHyp) ' epochs recorded...'])
                disp('************************* ')


                allEpochStimInds = allEpochStimInds(1:nEpochsRec);
                allEpochData = allEpochData(1:nEpochsRec);
            end

            disp(['n stims = ' num2str(nStims)])

            obj.O_STIMS.stimEpochs = stimEpochs;
            obj.O_STIMS.stimName = stimName;
            obj.O_STIMS.allEpochStimInds = allEpochStimInds;
            obj.O_STIMS.allEpochData = allEpochData;
            obj.O_STIMS.audSelInd = audSelInd;
            obj.O_STIMS.audSel_ID = audSel_ID;

            %% Organize Stims

            allStims = []; allStimType = [];

            switch obj.O_STIMS.audSel_ID

                case 1 % HRTF

                    % Azimuth(HRTF)
                    allAz = [];
                    for s = 1:nStims
                        allAz(s) = AllStimuli(s).Azimuth;
                    end
                    allStims{1} = allAz;
                    allStimType{1} = 'Azimuth';

                    % Elevation (HRTF)
                    allEl = [];
                    for s = 1:nStims
                        allEl(s) = AllStimuli(s).Elevation;
                    end
                    allStims{2} = allEl;
                    allStimType{2} = 'Elevation';

                    ProtocolName = 'HRTF';

                    stimC1 = allStims{1};
                    stimC2 = allStims{2};


                case 2 % Tuning

                    % Frequency
                    allF = [];
                    for s = 1:nStims
                        allF(s) = AllStimuli(s).Frequency;
                    end

                    allStims{1} = allF ;
                    allStimType{1} = 'Frequency';

                    % SPL
                    allSPL = [];
                    for s = 1:nStims
                        allSPL(s) = AllStimuli(s).Level_1;
                    end
                    allStims{2} = allSPL;
                    allStimType{2} = 'Level';

                    ProtocolName = 'Tuning';

                    stimC1 = allStims{1};
                    stimC2 = allStims{2};


                case 3 % IID
                    allL1 = [];
                    for s = 1:nStims
                        allL1(s) = AllStimuli(s).Level_1;
                    end

                    allStims{1} = allL1;
                    allStimType{1} = 'Level_1';

                    allL2 = [];
                    for s = 1:nStims
                        allL2(s) = AllStimuli(s).Level_2;
                    end
                    allStims{2} = allL2;
                    allStimType{2} = 'Level_2';

                    ProtocolName = 'IID';

                    stimC1 = allStims{1};
                    stimC2 = 1;

                case 4 % ITD

                    allITD = [];
                    for s = 1:nStims
                        allITD(s) = AllStimuli(s).ITD;
                    end

                    allStims = allITD;
                    allStimType = 'ITD';

                    ProtocolName = 'ITD';

                    stimC1 = allStims;
                    stimC2 = 1;

                case 5

                    allWN_Name = [];
                    allWN_Num = [];
                    for s = 1:nStims
                        allWN_Name{s} = AllStimuli(s).Name;
                        allWN_Num(s) = str2double(AllStimuli(s).Name(end));
                    end

                    allStims = allWN_Num;
                    allStimType = 'WN';

                    ProtocolName = 'WN';

                    stimC1 = allStims;
                    stimC2 = 1;

            end


            obj.O_STIMS.stimName = stimName;
            obj.O_STIMS.stimEpochs = stimEpochs;
            obj.O_STIMS.AllStims = allStims;
            obj.O_STIMS.allStimType = allStimType;
            obj.O_STIMS.ProtocolName = ProtocolName;

            %disp(obj.O_STIMS.stimName)
            disp(obj.O_STIMS.allStimType)


            %%
            %             nStimCat = numel(obj.O_STIMS.AllStims);
            %
            %             if nStimCat == 2
            %                 stimC1 = obj.O_STIMS.AllStims{1};
            %                 stimC2 = obj.O_STIMS.AllStims{2};
            %
            %             elseif nStimCat ==1
            %                 stimC1 = obj.O_STIMS.AllStims{1};
            %                 stimC2 = 1;
            %
            %             end
            %
            nUniqueStimC1 = numel(unique(stimC1));
            nUniqueStimC2 = numel(unique(stimC2));

            disp(['Dim 1: ' num2str(nUniqueStimC1)]);
            disp(['Dim 2: ' num2str(nUniqueStimC2)]);

            obj.O_STIMS.stimC1 = stimC1;
            obj.O_STIMS.stimC2 = stimC2;
            obj.O_STIMS.nUniqueStimC1 = nUniqueStimC1;
            obj.O_STIMS.nUniqueStimC2 = nUniqueStimC2;

            %%

        end

        function [obj] = plotEpochs(obj, nReps)

            if nargin <2
                nReps = 300;
            end

            allEpochData = obj.O_STIMS.allEpochData;
            nEpochs = obj.EPOCHS.nEpochs;

            timepoints_samp = (1:obj.SETTINGS.EpocheLengthSamples);
            timepoints_s = timepoints_samp / obj.Fs;

            if nReps > nEpochs
                nReps = nEpochs;

            elseif  numel(allEpochData) ~= nEpochs
                disp('INCOMPLETE FILE')
                disp(['n epochs = ' num2str(numel(allEpochData))])

                nReps = numel(allEpochData);
                if nReps > 300
                    nReps = 300;
                end
            end

            figH1 = figure(100); clf
            for j = 1:nReps
                plot(timepoints_s, allEpochData{j})
                hold on
                axis tight
                %ylim([-.8 .8])
                %ylim([-1 1])
                %ylim([-.3 .3])
                xlabel('Time [s]')
                grid on
                grid minor
                title([obj.O_STIMS.ProtocolName ' | Epochs: ' num2str(j)])
                %pause(.01)

            end

            disp('')

            %obj.FIG.figH1  = figH1;

        end

        function [obj] = setThreshAndPrintFig(obj, SpkThresh)

            %figH1 = obj.FIG.figH1;
            figH1 = figure(100);
            spkSavePath = obj.PATHS.spkSavePath;

            figure(figH1)

            timepoints_samp = (1:obj.SETTINGS.EpocheLengthSamples);
            timepoints_s = timepoints_samp / obj.Fs;

            hold on
            line([0 timepoints_s(end)], [SpkThresh SpkThresh], 'color', 'k')
            ylim([-1 1])

            %% Print Fig
            figure(figH1)

            disp('Printing Plot')
            set(0, 'CurrentFigure', figH1)

            FigSaveName = [spkSavePath 'spkThresh'];
            dropBoxSavePath = [obj.PATHS.dropboxPath obj.RS_INFO.expTextLabel '__' obj.PATHS.audStimDir '_spkThresh'];

            plotpos = [0 0 15 10];
            print_in_A4(0, FigSaveName, '-djpeg', 0, plotpos);
            print_in_A4(0, dropBoxSavePath, '-djpeg', 0, plotpos);

        end

        function [obj] = addSpikesToObject(obj, spikes, clustOfInterest)


            obj.SPKS.spikes = spikes;
            obj.SPKS.clustOfInterest = clustOfInterest;

            disp('Spikes added to object.')
        end

        function [spikes, SpkThresh] = loadSpikes(obj)

            spkSaveName = [obj.PATHS.spkSavePath 'AllSpks.mat'];

            d = load(spkSaveName);

            spikes = d.spikes;
            SpkThresh = d.SpkThresh;

            clusterIDs = unique(spikes.assigns);
            disp(['Cluster IDS: ' num2str(clusterIDs)]);

        end


        %%
        function [obj] = sortSpikesToStims(obj)


            fs = obj.Fs;

            nStims = obj.STIMS.nStims;

            nUniqueStimC2 = obj.O_STIMS.nUniqueStimC2;
            nUniqueStimC1 = obj.O_STIMS.nUniqueStimC1;

            preStimDur_s = 0.1;
            stimDur_s = 0.1;
            postStimDur_s = 0.1;

            preStimDur_samp = preStimDur_s * fs;
            stimDur_samp = preStimDur_s * fs;
            postStimDur_samp = preStimDur_s * fs;

            epochLength_samps = obj.SETTINGS.EpocheLengthSamples;
            stimStart_samp = preStimDur_samp;
            stimStop_samp = preStimDur_samp + stimDur_samp;

            stimEpochs = obj.O_STIMS.stimEpochs;

            %%

            spikes = obj.SPKS.spikes;
            clustOfInterest = obj.SPKS.clustOfInterest;
            nDiffSpikes = numel(clustOfInterest);
            clustSpks = spikes.assigns; % For all spikes, which one belongs to which cluster
            EpochAssignments = spikes.trials;
            spiketimes = spikes.spiketimes;

            allClustAssignments = cell(1, nDiffSpikes);
            for q = 1:nDiffSpikes
                allClustAssignments{q} = find(clustSpks == clustOfInterest(q));
            end

            %% Major Sorting now
            Spks = [];
            for q = 1:nDiffSpikes
                theseSpikesInds = allClustAssignments{q};

                theseSpikeTimes_s = spiketimes(theseSpikesInds);
                theseSpikeTimes_samp = round(theseSpikeTimes_s*fs);

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
            disp('')

            %% Reshape spikes into a matrix according to the stims

            stimName = obj.O_STIMS.stimName;
            for q = 1:nDiffSpikes
                cnt = 1;
                allSpksMatrix = []; allSpksStimNames = [];
                for o = 1:nUniqueStimC2
                    for oo = 1:nUniqueStimC1
                        allSpksMatrix{o,oo} = Spks{q, 1}.AllStimResponses_Spk_samp{cnt};
                        allSpksStimNames{o,oo} = stimName{cnt};
                        cnt = cnt+1;
                    end
                end
            end

            %% Silent Control = 430, last one
            audSel_ID = obj.O_STIMS.audSel_ID;

            if audSel_ID == 1 || audSel_ID == 2

                allSpksMatrix_Silent = Spks{q, 1}.AllStimResponses_Spk_samp{end};
                allSpksStimNames_Silent = stimName{end};
            else
                allSpksMatrix_Silent = [];
                allSpksStimNames_Silent = [];
            end
            %%

            obj.S_SPKS.INFO.preStimDur_s  = preStimDur_s;
            obj.S_SPKS.INFO.stimDur_s  = stimDur_s;
            obj.S_SPKS.INFO.postStimDur_s  = postStimDur_s;

            obj.S_SPKS.INFO.preStimDur_samp  = preStimDur_samp;
            obj.S_SPKS.INFO.stimDur_samp  = stimDur_samp;
            obj.S_SPKS.INFO.postStimDur_samp  = postStimDur_samp;

            obj.S_SPKS.INFO.epochLength_samps  = epochLength_samps;
            obj.S_SPKS.INFO.stimStart_samp = stimStart_samp;
            obj.S_SPKS.INFO.stimStop_samp = stimStop_samp;

            obj.S_SPKS.INFO.epochLength_ms  = (epochLength_samps/fs)*1000;
            obj.S_SPKS.INFO.Fs = fs;

            obj.S_SPKS.INFO.nStims = nStims;
            obj.S_SPKS.INFO.nReps = numel(match);

            obj.S_SPKS.SORT.allSpksMatrix = allSpksMatrix;
            obj.S_SPKS.SORT.allSpksStimNames = allSpksStimNames;

            obj.S_SPKS.SORT.allSpksMatrix_Silent = allSpksMatrix_Silent;
            obj.S_SPKS.SORT.allSpksStimNames_Silent = allSpksStimNames_Silent;

            obj.S_SPKS.SORT.AllStimResponses_Spk_s = Spks{1,1}.AllStimResponses_Spk_s;
            obj.S_SPKS.SORT.AllStimResponses_Spk_samp = Spks{1,1}.AllStimResponses_Spk_samp;




            disp('Sorted all Spikes to Stims.')
        end


        %%
        function [obj] = defineAnalysisWindow(obj)
            % from SpacestimAutoOneFile.m

            nallSpks = numel(obj.SPKS.spikes.spiketimes);

            nStims = obj.S_SPKS.INFO.nStims;
            nReps = obj.S_SPKS.INFO.nReps;

            saveName = obj.PATHS.audStimDir;

            preSpontWin_1 = 1:50;
            preSpontWin_2 = 51:100;
            stimWin_1 = 101:150;
            stimWin_2 = 151:200;
            postSpontWin_1 = 201:250;
            postSpontWin_2 = 251:300;


            data = obj.S_SPKS.SORT.AllStimResponses_Spk_s;

            %% Stim (Rest)
            %here we are going through 10 ms windows, for each repetition of each stimulus
            cnt = 1;
            Twin_s = 0.05;
            for j = 1:nStims
                for k = 1:nReps

                    spks = (data{1, j}{1,k})*1000;

                    %these_spks_on_chan = spks(spks >= reshapedOnsets(p) & spks <= reshapedOffsets(p))-reshapedOnsets(p);

                    preSpontWin_1_spks_reps(k) = numel(spks(spks >= preSpontWin_1(1) & spks <= preSpontWin_1(end)));
                    preSpontWin_2_spks_reps(k) = numel(spks(spks >= preSpontWin_2(1) & spks <= preSpontWin_2(end)));
                    stimWin_1_spks_reps(k) = numel(spks(spks >= stimWin_1(1) & spks <= stimWin_1(end)));
                    stimWin_2_spks_reps(k) = numel(spks(spks >= stimWin_2(1) & spks <= stimWin_2(end)));
                    postSpontWin_1_spks_reps(k) = numel(spks(spks >= postSpontWin_1(1) & spks <= postSpontWin_1(end)));
                    postSpontWin_2_spks_reps(k) = numel(spks(spks >= postSpontWin_2(1) & spks <= postSpontWin_2(end)));

                    preSpontWin_1_spks(cnt) = numel(spks(spks >= preSpontWin_1(1) & spks <= preSpontWin_1(end)));
                    preSpontWin_2_spks(cnt) = numel(spks(spks >= preSpontWin_2(1) & spks <= preSpontWin_2(end)));
                    stimWin_1_spks(cnt) = numel(spks(spks >= stimWin_1(1) & spks <= stimWin_1(end)));
                    stimWin_2_spks(cnt) = numel(spks(spks >= stimWin_2(1) & spks <= stimWin_2(end)));
                    postSpontWin_1_spks(cnt) = numel(spks(spks >= postSpontWin_1(1) & spks <= postSpontWin_1(end)));
                    postSpontWin_2_spks(cnt) = numel(spks(spks >= postSpontWin_2(1) & spks <= postSpontWin_2(end)));

                    cnt = cnt+1;
                    disp('')
                end

                preSpontWin_1_sumRep(j) = sum(preSpontWin_1_spks_reps);
                preSpontWin_2_sumRep(j) =  sum(preSpontWin_2_spks_reps);
                stimWin_1_sumRep(j) = sum(stimWin_1_spks_reps);
                stimWin_2_sumRep(j) = sum(stimWin_2_spks_reps);
                postSpontWin_1_sumRep(j) =   sum(postSpontWin_1_spks_reps);
                postSpontWin_2_sumRep(j) =  sum(postSpontWin_2_spks_reps);

                preSpontWin_1_FR(j,:) = preSpontWin_1_spks_reps/Twin_s;
                preSpontWin_2_FR(j,:) =  preSpontWin_2_spks_reps/Twin_s;
                stimWin_1_FR(j,:) = stimWin_1_spks_reps/Twin_s;
                stimWin_2_FR(j,:) = stimWin_2_spks_reps/Twin_s;
                postSpontWin_1_FR(j,:) = postSpontWin_1_spks_reps/Twin_s;
                postSpontWin_2_FR(j,:) = postSpontWin_2_spks_reps/Twin_s;

            end

            preSpontWin_1_meanFR = nanmean(nanmean(preSpontWin_1_FR));
            preSpontWin_2_meanFR = nanmean(nanmean(preSpontWin_2_FR));
            stimWin_1_meanFR = nanmean(nanmean(stimWin_1_FR));
            stimWin_2_meanFR = nanmean(nanmean(stimWin_2_FR));
            postSpontWin_1_meanFR = nanmean(nanmean(postSpontWin_1_FR));
            postSpontWin_2_meanFR = nanmean(nanmean(postSpontWin_2_FR));

            preSpontWin_1_std = nanstd(nanstd(preSpontWin_1_FR));
            preSpontWin_2_stimWin_1_std = nanstd(nanstd(preSpontWin_2_FR));
            stimWin_1_std = nanstd(nanstd(stimWin_1_FR));
            stimWin_2_std = nanstd(nanstd(stimWin_2_FR));
            postSpontWin_1_std = nanstd(nanstd(postSpontWin_1_FR));
            postSpontWin_2_std = nanstd(nanstd(postSpontWin_2_FR));

            z_score_cov_preSpontWin_1 = (preSpontWin_1_meanFR - preSpontWin_1_meanFR) / sqrt(preSpontWin_1_std^2 + preSpontWin_1_std^2);
            z_score_cov_preSpontWin_2 = (preSpontWin_2_meanFR - preSpontWin_1_meanFR) / sqrt(preSpontWin_2_stimWin_1_std^2 + preSpontWin_1_std^2);
            z_score_cov_stimWin_1 = (stimWin_1_meanFR - preSpontWin_1_meanFR) / sqrt(stimWin_1_std^2 + preSpontWin_1_std^2);
            z_score_cov_stimWin_2 = (stimWin_2_meanFR - preSpontWin_1_meanFR) / sqrt(stimWin_2_std^2 + preSpontWin_1_std^2);
            z_score_cov_postSpontWin_1 = (postSpontWin_1_meanFR - preSpontWin_1_meanFR) / sqrt(postSpontWin_1_std^2 + preSpontWin_1_std^2);
            z_score_cov_postSpontWin_2 = (postSpontWin_2_meanFR - preSpontWin_1_meanFR) / sqrt(postSpontWin_2_std^2 + preSpontWin_1_std^2);

            allZScores = [z_score_cov_preSpontWin_1 z_score_cov_preSpontWin_2 z_score_cov_stimWin_1 z_score_cov_stimWin_2 z_score_cov_postSpontWin_1 z_score_cov_postSpontWin_2];
            %allFrs = [];

            [p_preSpontWin_1, h]  = signrank(reshape(preSpontWin_1_FR, 1, numel(preSpontWin_1_FR)), reshape(preSpontWin_1_FR, 1, numel(preSpontWin_1_FR)));
            [p_preSpontWin_2, h]  = signrank(reshape(preSpontWin_1_FR, 1, numel(preSpontWin_1_FR)), reshape(preSpontWin_2_FR, 1, numel(preSpontWin_2_FR)));
            [p_stimWin_1, h]  = signrank(reshape(preSpontWin_1_FR, 1, numel(preSpontWin_1_FR)), reshape(stimWin_1_FR, 1, numel(stimWin_1_FR)));
            [p_stimWin_2, h]  = signrank(reshape(preSpontWin_1_FR, 1, numel(preSpontWin_1_FR)), reshape(stimWin_2_FR, 1, numel(stimWin_2_FR)));
            [p_postSpontWin_1, h]  = signrank(reshape(preSpontWin_1_FR, 1, numel(preSpontWin_1_FR)), reshape(postSpontWin_1_FR, 1, numel(postSpontWin_1_FR)));
            [p_postSpontWin_2, h]  = signrank(reshape(preSpontWin_1_FR, 1, numel(preSpontWin_1_FR)), reshape(postSpontWin_2_FR, 1, numel(postSpontWin_2_FR)));

            allPs = [p_preSpontWin_1 p_preSpontWin_2 p_stimWin_1 p_stimWin_2 p_postSpontWin_1 p_postSpontWin_2];


            %%

            sortedData = obj.S_SPKS.SORT.allSpksMatrix;
            sortedDataNames = obj.S_SPKS.SORT.allSpksStimNames;

            n_elev = 13;
            n_azim = 33;

            %%
            if nallSpks > 3000
                repsToPlot = [3];
                disp('***** Printing only a selection of spikes...******')
            else
                repsToPlot = 1:nReps;
            end

            figH = figure (201); clf
            blueCol = [0.2 0.7 0.8];
            subplot(7, 1, [1 2 3 4])

            % gray = [0.5 0.5 0.5];
            %
            % hold on
            % qcnt = 0;
            % for q = 1:100
            %
            %     xes = [0 400 400 0];
            %     yes = [qcnt qcnt  qcnt+10 qcnt+10];
            %     a = patch(xes,  yes, gray);
            %     set(a,'EdgeColor','none')
            %     a.FaceAlpha = 0.2;
            %
            %     qcnt  = qcnt + 12;
            %
            % end

            scanrate = obj.Fs;
            cnt = 1;
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
                        text(-20, cnt-30, (sortedDataNames{elev, azim}(4:10)))
                    end
                end
            end
            set(gca,'ytick',[])
            title (obj.PATHS.audStimDir)
            %xlabel('Time [ms]')
            ylabel('Reps | Azimuth')
            axis tight

            %% PSTH

            nStims = obj.S_SPKS.INFO.nStims;
            nReps = obj.S_SPKS.INFO.nReps;


            disp('')
            %%
            binwidth_s=0.001;%[s]
            max_time= obj.SETTINGS.EpocheLength;
            spike_times=[]; psthall = [];
            htime=0:binwidth_s:max_time;

            for xy = 1:nStims
                for yy=1:nReps

                    spike_times=[spike_times data{1,xy}{1,yy}]; % concat all spikes in ms

                end
            end
            % convert to seconds
            %spike_times=spike_times/1e3; % convert back to s

            psth=histc(spike_times,htime);
            psthall(xy,:)=psth; % what does this do
            summenpsth=sum(psthall); % this is the same as psth

            %spontlevel=(std(summenpsth(1:50))*2)+mean(summenpsth(1:50)); %2x std
            %spontmean = mean(summenpsth(1:50));
            %spontstd = std(summenpsth(1:50))*3;

            %maxspikecount=max(summenpsth);

            preStimArea = 1:101;
            stimArea = 101:201;
            postStimArea = 201:301;

            %% figure

            blueCol = [0.2 0.7 0.8];
            greencol = [0.2 0.8 0.7];
            redCol = [0.8 0.3 0.3];
            gray = [0.5 0.5 0.5];


            smoothWin_ms = 5;
            %smooth_psth = smooth(summenpsth, smoothWin_ms);
            %smooth_psth = smooth(summenpsth, smoothWin_ms, 'loess');
            smooth_psth = smooth(summenpsth, smoothWin_ms, 'lowess');

            maxPsth = max(summenpsth);
            maxSmoothPsth = max(smooth_psth);

            subplot(7, 1, [ 5 6])

            a = area([preStimArea(1)  preStimArea(end)], [maxPsth maxPsth], 'FaceColor', gray);
            set(a,'EdgeColor','none')
            a.FaceAlpha = 0.2;
            hold on

            a = area([stimArea(1)  stimArea(end)], [maxPsth maxPsth], 'FaceColor', greencol);
            set(a,'EdgeColor','none')
            a.FaceAlpha = 0.4;
            hold on

            a = area([postStimArea(1)  postStimArea(end)], [maxPsth maxPsth], 'FaceColor', gray);
            set(a,'EdgeColor','none')
            a.FaceAlpha = 0.2;
            hold on

            plot(summenpsth, 'color', gray)

            plot(smooth_psth, 'k', 'linewidth' ,2);
            axis tight

            xlabel('Time [ms]')
            ylabel('PSTH [spks]')
            %%
            subplot(7, 1, [7])
            imagesc(allZScores);
            %colormap('hot')
            %colormap('bone')
            colormap('pink')
            %colormap('redblue')
            hold on
            for o = 1:6
                text(o-.2, 1, ['Z = ' num2str(round(allZScores(o), 2))])
                text(o-.2, 1.2, ['p = ' num2str(round(allPs(o), 4))])

            end

            disp('')
            %%
            disp('Printing Plot')
            set(0, 'CurrentFigure', figH)

            %dropBoxSavePath = [obj.PATHS.dropboxPath saveName '-RasterPsthZscore_smp1'];
            dropBoxSavePath = ['/media/janie/Data64GB/OTData/OT/allHRTFsJanie/' saveName '-RasterPsthZscore_smp1'];
            %FigSaveName = [obj.PATHS.spkSavePath 'HRTF_Raster_v1_SpkClust' num2str(obj.SPKS.clustOfInterest)];

            plotpos = [0 0 35 40];

            %print_in_A4(0, FigSaveName, '-depsc', 0, plotpos);
            %print_in_A4(0, FigSaveName, '-djpeg', 0, plotpos);

            print_in_A4(0, dropBoxSavePath , '-djpeg', 0, plotpos);
            %print_in_A4(0, dropBoxSavePath, '-depsc', 0, plotpos);

            %dropBoxSavePath = [obj.PATHS.dropboxPath saveName  '-RasterPsthZscore_smvZ'];
            %print_in_A4(0, dropBoxSavePath, '-depsc', 1, plotpos);

            %% Now makin SRFs

            %%Sort Spike COunts

            preSpontWin_1_sumRep_cntcheck = sum(preSpontWin_1_sumRep);
            preSpontWin_2_sumRep_cntcheck =  sum(preSpontWin_2_sumRep);
            stimWin_1_sumRep_cntcheck = sum(stimWin_1_sumRep);
            stimWin_2_sumRep_cntcheck = sum(stimWin_2_sumRep);
            postSpontWin_1_sumRep_cntcheck =   sum(postSpontWin_1_sumRep);
            postSpontWin_2_sumRep_cntcheck =  sum(postSpontWin_2_sumRep);

            %%
            preSpontWin_1_spkCntSort = [];
            preSpontWin_2_spkCntSort = [];
            stimWin_1_spkCntSort = [];
            stimWin_2_spkCntSort = [];
            postSpontWin_1_spkCntSort = [];
            postSpontWin_2_spkCntSort = [];

            n_elev = 13;
            n_azim = 33;

            %% Needs to be in this order
            ct = 1;
            for elev = 1:n_elev
                for azim = 1:n_azim

                    preSpontWin_1_spkCntSort(elev, azim) = preSpontWin_1_sumRep(ct);
                    preSpontWin_2_spkCntSort(elev, azim) = preSpontWin_2_sumRep(ct);
                    stimWin_1_spkCntSort(elev, azim) = stimWin_1_sumRep(ct);
                    stimWin_2_spkCntSort(elev, azim) = stimWin_2_sumRep(ct);
                    postSpontWin_1_spkCntSort(elev, azim) = postSpontWin_1_sumRep(ct);
                    postSpontWin_2_spkCntSort(elev, azim) = postSpontWin_2_sumRep(ct);

                    ct = ct+1;
                end
            end

            %% We do not normalize

            %maxispike=max(max(Spikearray));
            %maxispike=round(maxispike*10)/10;
            %Spikearray=Spikearray/max(max(Spikearray));

            %% smooth & rotate

            allArraysCnt = [preSpontWin_1_spkCntSort ; preSpontWin_2_spkCntSort ; stimWin_1_spkCntSort; stimWin_2_spkCntSort;
                postSpontWin_1_spkCntSort ; postSpontWin_2_spkCntSort];

            meanAll = nanmean(nanmean(allArraysCnt));
            stdAll = nanstd(nanstd(allArraysCnt));

            %z = (X - μ) / σ where z is the z-score, X is the value of the element, μ is the population mean, and σ is the standard deviation.

            preSpontWin_1_spkCntSort_Z = (preSpontWin_1_spkCntSort-meanAll)/stdAll;
            preSpontWin_2_spkCntSort_Z = (preSpontWin_2_spkCntSort-meanAll)/stdAll;
            stimWin_1_spkCntSort_Z = (stimWin_1_spkCntSort-meanAll)/stdAll;
            stimWin_2_spkCntSort_Z = (stimWin_2_spkCntSort-meanAll)/stdAll;
            postSpontWin_1_spkCntSort_Z = (postSpontWin_1_spkCntSort-meanAll)/stdAll;
            postSpontWin_2_spkCntSort_Z = (postSpontWin_2_spkCntSort-meanAll)/stdAll;

            preSpontWin_1_smoothSpkArray = flipud(moving_average2(preSpontWin_1_spkCntSort_Z(:,:),1,1));% rows ;collumns
            preSpontWin_2_smoothSpkArray = flipud(moving_average2(preSpontWin_2_spkCntSort_Z(:,:),1,1));% rows ;collumns
            stimWin_1_smoothSpkArray = flipud(moving_average2(stimWin_1_spkCntSort_Z(:,:),1,1));% rows ;collumns
            stimWin_2_smoothSpkArray = flipud(moving_average2(stimWin_2_spkCntSort_Z(:,:),1,1));% rows ;collumns
            postSpontWin_1_smoothSpkArray = flipud(moving_average2(postSpontWin_1_spkCntSort_Z(:,:),1,1));% rows ;collumns
            postSpontWin_2_smoothSpkArray = flipud(moving_average2(postSpontWin_2_spkCntSort_Z(:,:),1,1));% rows ;collumns

            %% Original
%             preSpontWin_1_smoothSpkArray = flipud(moving_average2(preSpontWin_1_spkCntSort(:,:),1,1));% rows ;collumns
%             preSpontWin_2_smoothSpkArray = flipud(moving_average2(preSpontWin_2_spkCntSort(:,:),1,1));% rows ;collumns
%             stimWin_1_smoothSpkArray = flipud(moving_average2(stimWin_1_spkCntSort(:,:),1,1));% rows ;collumns
%             stimWin_2_smoothSpkArray = flipud(moving_average2(stimWin_2_spkCntSort(:,:),1,1));% rows ;collumns
%             postSpontWin_1_smoothSpkArray = flipud(moving_average2(postSpontWin_1_spkCntSort(:,:),1,1));% rows ;collumns
%             postSpontWin_2_smoothSpkArray = flipud(moving_average2(postSpontWin_2_spkCntSort(:,:),1,1));% rows ;collumns
%
%
%
            %smoothSpikearray_norm=smoothSpikearray/max(max(smoothSpikearray));

            allArrays = [preSpontWin_1_smoothSpkArray ; preSpontWin_2_smoothSpkArray ; stimWin_1_smoothSpkArray; stimWin_2_smoothSpkArray;
                postSpontWin_1_smoothSpkArray ; postSpontWin_2_smoothSpkArray];


            maxArrayVal = max(max(allArrays));
            minArrayVal = min(min(allArrays));
            clims = [minArrayVal maxArrayVal ];
            %% Plot

            figHH  = figure(100);clf

            plotAudSpatRFs(figHH, preSpontWin_1_smoothSpkArray, 1, 0, 'Pre-Spont-1', clims)

            %             subplot(1, 8, 1)
            %             surf((preSpontWin_1_smoothSpkArray));
            %             shading interp
            %             view([ 0 90])
            %             axis tight
            %             title('Pre-Spont')
            %             set(gca,'ytick',[])
            %             set(gca,'xtick',[])
            %             xlabel('Azimuth')
            %             ylabel('Elevation')
            %             set(gca, 'clim', clims)

            plotAudSpatRFs(figHH, preSpontWin_2_smoothSpkArray, 2, 0, 'Pre-Spont-2', clims)

            %             subplot(1, 8, 2)
            %             surf((preSpontWin_2_smoothSpkArray));
            %             shading interp
            %             view([ 0 90])
            %             axis tight
            %             title('Stim-1')
            %             set(gca,'ytick',[])
            %             set(gca,'xtick',[])
            %             xlabel('Azimuth')
            %             set(gca, 'clim', clims)
            %             %ylabel('Elevation')

            plotAudSpatRFs(figHH, stimWin_1_smoothSpkArray, 3, 0, 'Stim-1', clims)

            %             subplot(1, 8, 3)
            %             surf((stimWin_1_smoothSpkArray));
            %             shading interp
            %             view([ 0 90])
            %             axis tight
            %             title('Stim-2')
            %             set(gca,'ytick',[])
            %             set(gca,'xtick',[])
            %             xlabel('Azimuth')
            %             set(gca, 'clim', clims)
            %             %ylabel('Elevation')

            plotAudSpatRFs(figHH, stimWin_2_smoothSpkArray, 4, 0, 'Stim-2', clims)

            %             subplot(1, 8, 4)
            %             surf((stimWin_2_smoothSpkArray));
            %             shading interp
            %             view([ 0 90])
            %             axis tight
            %             title('Stim-3')
            %             set(gca,'ytick',[])
            %             set(gca,'xtick',[])
            %             xlabel('Azimuth')
            %             set(gca, 'clim', clims)
            %             %ylabel('Elevation')
            %
            plotAudSpatRFs(figHH, postSpontWin_1_smoothSpkArray, 5, 0, 'Post-Spont-1', clims)

            %             subplot(1, 8, 5)
            %             surf((postSpontWin_1_smoothSpkArray));
            %             shading interp
            %             view([ 0 90])
            %             axis tight
            %             title('Post-Spont-1')
            %             set(gca,'ytick',[])
            %             set(gca,'xtick',[])
            %             xlabel('Azimuth')
            %             set(gca, 'clim', clims)
            %             %ylabel('Elevation')

            plotAudSpatRFs(figHH, postSpontWin_2_smoothSpkArray, 6, 0, 'Pre-Spont-2', clims)

            %             subplot(1, 8, 6)
            %             surf((postSpontWin_2_smoothSpkArray));
            %             shading interp
            %             view([ 0 90])
            %             axis tight
            %             title('Post-Spont-2')
            %             set(gca,'ytick',[])
            %             set(gca,'xtick',[])
            %             xlabel('Azimuth')
            %             set(gca, 'clim', clims)
            %             %ylabel('Elevation')
            %

            plotAudSpatRFs(figHH, preSpontWin_1_smoothSpkArray, 7, 1, 'Pre-Spont-1', clims)
            plotAudSpatRFs(figHH, preSpontWin_2_smoothSpkArray, 8, 1, 'Pre-Spont-2', clims)
            plotAudSpatRFs(figHH, stimWin_1_smoothSpkArray, 9, 1, 'Stim-1',clims)
            plotAudSpatRFs(figHH, stimWin_2_smoothSpkArray, 10, 1, 'Stim-2', clims)
            plotAudSpatRFs(figHH, postSpontWin_1_smoothSpkArray, 11, 1, 'Post-Spont-1', clims)
            plotAudSpatRFs(figHH, postSpontWin_2_smoothSpkArray, 12, 1, 'Pre-Spont-2', clims)

            %%

            %%
            disp('Printing Plot')
            set(0, 'CurrentFigure', figHH)

            %dropBoxSavePath = [obj.PATHS.dropboxPath  saveName '-SpatialRFs'];
            %FigSaveName = [obj.PATHS.spkSavePath 'HRTF_aSRFs_v1_SpkClust' num2str(obj.SPKS.clustOfInterest)];

            dropBoxSavePath = ['/media/janie/Data64GB/OTData/OT/allHRTFsJanie/' saveName '_aSRFs_Z_SpkClust' num2str(obj.SPKS.clustOfInterest)];

            %plotpos = [0 0 60 5];
            plotpos = [0 0 40 10];
            %print_in_A4(0, dropBoxSavePath , '-djpeg', 0, plotpos);
            %print_in_A4(0, dropBoxSavePath, '-depsc', 0, plotpos);

            print_in_A4(0, dropBoxSavePath, '-djpeg', 0, plotpos);
            %print_in_A4(0, FigSaveName, '-depsc', 0, plotpos);


        end

        function [obj] = analyzeHRTFs(obj)
            % from SpacestimAutoOneFile.m

            nallSpks = numel(obj.SPKS.spikes.spiketimes);

            nStims = obj.S_SPKS.INFO.nStims;
            nReps = obj.S_SPKS.INFO.nReps;

            saveName = obj.PATHS.audStimDir;

            preSpontWin_1 = 1:50;
            preSpontWin_2 = 51:100;
            stimWin_1 = 101:150;
            stimWin_2 = 151:200;
            postSpontWin_1 = 201:250;
            postSpontWin_2 = 251:300;


            data = obj.S_SPKS.SORT.AllStimResponses_Spk_s;

            %% Stim (Rest)
            %here we are going through 10 ms windows, for each repetition of each stimulus
            cnt = 1;
            Twin_s = 0.05;
            for j = 1:nStims
                for k = 1:nReps

                    spks = (data{1, j}{1,k})*1000;

                    %these_spks_on_chan = spks(spks >= reshapedOnsets(p) & spks <= reshapedOffsets(p))-reshapedOnsets(p);

                    preSpontWin_1_spks_reps(k) = numel(spks(spks >= preSpontWin_1(1) & spks <= preSpontWin_1(end)));
                    preSpontWin_2_spks_reps(k) = numel(spks(spks >= preSpontWin_2(1) & spks <= preSpontWin_2(end)));
                    stimWin_1_spks_reps(k) = numel(spks(spks >= stimWin_1(1) & spks <= stimWin_1(end)));
                    stimWin_2_spks_reps(k) = numel(spks(spks >= stimWin_2(1) & spks <= stimWin_2(end)));
                    postSpontWin_1_spks_reps(k) = numel(spks(spks >= postSpontWin_1(1) & spks <= postSpontWin_1(end)));
                    postSpontWin_2_spks_reps(k) = numel(spks(spks >= postSpontWin_2(1) & spks <= postSpontWin_2(end)));

                    preSpontWin_1_spks(cnt) = numel(spks(spks >= preSpontWin_1(1) & spks <= preSpontWin_1(end)));
                    preSpontWin_2_spks(cnt) = numel(spks(spks >= preSpontWin_2(1) & spks <= preSpontWin_2(end)));
                    stimWin_1_spks(cnt) = numel(spks(spks >= stimWin_1(1) & spks <= stimWin_1(end)));
                    stimWin_2_spks(cnt) = numel(spks(spks >= stimWin_2(1) & spks <= stimWin_2(end)));
                    postSpontWin_1_spks(cnt) = numel(spks(spks >= postSpontWin_1(1) & spks <= postSpontWin_1(end)));
                    postSpontWin_2_spks(cnt) = numel(spks(spks >= postSpontWin_2(1) & spks <= postSpontWin_2(end)));

                    cnt = cnt+1;
                    disp('')
                end

                preSpontWin_1_sumRep(j) = sum(preSpontWin_1_spks_reps);
                preSpontWin_2_sumRep(j) =  sum(preSpontWin_2_spks_reps);
                stimWin_1_sumRep(j) = sum(stimWin_1_spks_reps);
                stimWin_2_sumRep(j) = sum(stimWin_2_spks_reps);
                postSpontWin_1_sumRep(j) =   sum(postSpontWin_1_spks_reps);
                postSpontWin_2_sumRep(j) =  sum(postSpontWin_2_spks_reps);

                preSpontWin_1_FR(j,:) = preSpontWin_1_spks_reps/Twin_s;
                preSpontWin_2_FR(j,:) =  preSpontWin_2_spks_reps/Twin_s;
                stimWin_1_FR(j,:) = stimWin_1_spks_reps/Twin_s;
                stimWin_2_FR(j,:) = stimWin_2_spks_reps/Twin_s;
                postSpontWin_1_FR(j,:) = postSpontWin_1_spks_reps/Twin_s;
                postSpontWin_2_FR(j,:) = postSpontWin_2_spks_reps/Twin_s;

            end

            preSpontWin_1_meanFR = nanmean(nanmean(preSpontWin_1_FR));
            preSpontWin_2_meanFR = nanmean(nanmean(preSpontWin_2_FR));
            stimWin_1_meanFR = nanmean(nanmean(stimWin_1_FR));
            stimWin_2_meanFR = nanmean(nanmean(stimWin_2_FR));
            postSpontWin_1_meanFR = nanmean(nanmean(postSpontWin_1_FR));
            postSpontWin_2_meanFR = nanmean(nanmean(postSpontWin_2_FR));

            preSpontWin_1_std = nanstd(nanstd(preSpontWin_1_FR));
            preSpontWin_2_stimWin_1_std = nanstd(nanstd(preSpontWin_2_FR));
            stimWin_1_std = nanstd(nanstd(stimWin_1_FR));
            stimWin_2_std = nanstd(nanstd(stimWin_2_FR));
            postSpontWin_1_std = nanstd(nanstd(postSpontWin_1_FR));
            postSpontWin_2_std = nanstd(nanstd(postSpontWin_2_FR));

            z_score_cov_preSpontWin_1 = (preSpontWin_1_meanFR - preSpontWin_1_meanFR) / sqrt(preSpontWin_1_std^2 + preSpontWin_1_std^2);
            z_score_cov_preSpontWin_2 = (preSpontWin_2_meanFR - preSpontWin_1_meanFR) / sqrt(preSpontWin_2_stimWin_1_std^2 + preSpontWin_1_std^2);
            z_score_cov_stimWin_1 = (stimWin_1_meanFR - preSpontWin_1_meanFR) / sqrt(stimWin_1_std^2 + preSpontWin_1_std^2);
            z_score_cov_stimWin_2 = (stimWin_2_meanFR - preSpontWin_1_meanFR) / sqrt(stimWin_2_std^2 + preSpontWin_1_std^2);
            z_score_cov_postSpontWin_1 = (postSpontWin_1_meanFR - preSpontWin_1_meanFR) / sqrt(postSpontWin_1_std^2 + preSpontWin_1_std^2);
            z_score_cov_postSpontWin_2 = (postSpontWin_2_meanFR - preSpontWin_1_meanFR) / sqrt(postSpontWin_2_std^2 + preSpontWin_1_std^2);

            allZScores = [z_score_cov_preSpontWin_1 z_score_cov_preSpontWin_2 z_score_cov_stimWin_1 z_score_cov_stimWin_2 z_score_cov_postSpontWin_1 z_score_cov_postSpontWin_2];
            %allFrs = [];

            [p_preSpontWin_1, h]  = signrank(reshape(preSpontWin_1_FR, 1, numel(preSpontWin_1_FR)), reshape(preSpontWin_1_FR, 1, numel(preSpontWin_1_FR)));
            [p_preSpontWin_2, h]  = signrank(reshape(preSpontWin_1_FR, 1, numel(preSpontWin_1_FR)), reshape(preSpontWin_2_FR, 1, numel(preSpontWin_2_FR)));
            [p_stimWin_1, h]  = signrank(reshape(preSpontWin_1_FR, 1, numel(preSpontWin_1_FR)), reshape(stimWin_1_FR, 1, numel(stimWin_1_FR)));
            [p_stimWin_2, h]  = signrank(reshape(preSpontWin_1_FR, 1, numel(preSpontWin_1_FR)), reshape(stimWin_2_FR, 1, numel(stimWin_2_FR)));
            [p_postSpontWin_1, h]  = signrank(reshape(preSpontWin_1_FR, 1, numel(preSpontWin_1_FR)), reshape(postSpontWin_1_FR, 1, numel(postSpontWin_1_FR)));
            [p_postSpontWin_2, h]  = signrank(reshape(preSpontWin_1_FR, 1, numel(preSpontWin_1_FR)), reshape(postSpontWin_2_FR, 1, numel(postSpontWin_2_FR)));

            allPs = [p_preSpontWin_1 p_preSpontWin_2 p_stimWin_1 p_stimWin_2 p_postSpontWin_1 p_postSpontWin_2];


            %%

            sortedData = obj.S_SPKS.SORT.allSpksMatrix;
            sortedDataNames = obj.S_SPKS.SORT.allSpksStimNames;

            n_elev = 13;
            n_azim = 33;

            %%
            if nallSpks > 3000
                repsToPlot = [3];
                disp('***** Printing only a selection of spikes...******')
            else
                repsToPlot = 1:nReps;
            end

            figH = figure (201); clf
            blueCol = [0.2 0.7 0.8];
            subplot(7, 1, [1 2 3 4])

            % gray = [0.5 0.5 0.5];
            %
            % hold on
            % qcnt = 0;
            % for q = 1:100
            %
            %     xes = [0 400 400 0];
            %     yes = [qcnt qcnt  qcnt+10 qcnt+10];
            %     a = patch(xes,  yes, gray);
            %     set(a,'EdgeColor','none')
            %     a.FaceAlpha = 0.2;
            %
            %     qcnt  = qcnt + 12;
            %
            % end

            scanrate = obj.Fs;
            cnt = 1;
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
                        text(-20, cnt-30, (sortedDataNames{elev, azim}(4:10)))
                    end
                end
            end
            set(gca,'ytick',[])
            title (obj.PATHS.audStimDir)
            %xlabel('Time [ms]')
            ylabel('Reps | Azimuth')
            axis tight

            %% PSTH

            nStims = obj.S_SPKS.INFO.nStims;
            nReps = obj.S_SPKS.INFO.nReps;


            disp('')
            %%
            binwidth_s=0.001;%[s]
            max_time= obj.SETTINGS.EpocheLength;
            spike_times=[]; psthall = [];
            htime=0:binwidth_s:max_time;

            for xy = 1:nStims
                for yy=1:nReps

                    spike_times=[spike_times data{1,xy}{1,yy}]; % concat all spikes in ms

                end
            end
            % convert to seconds
            %spike_times=spike_times/1e3; % convert back to s

            psth=histc(spike_times,htime);
            psthall(xy,:)=psth; % what does this do
            summenpsth=sum(psthall); % this is the same as psth

            %spontlevel=(std(summenpsth(1:50))*2)+mean(summenpsth(1:50)); %2x std
            %spontmean = mean(summenpsth(1:50));
            %spontstd = std(summenpsth(1:50))*3;

            %maxspikecount=max(summenpsth);

            preStimArea = 1:101;
            stimArea = 101:201;
            postStimArea = 201:301;

            %% figure

            blueCol = [0.2 0.7 0.8];
            greencol = [0.2 0.8 0.7];
            redCol = [0.8 0.3 0.3];
            gray = [0.5 0.5 0.5];


            smoothWin_ms = 5;
            %smooth_psth = smooth(summenpsth, smoothWin_ms);
            %smooth_psth = smooth(summenpsth, smoothWin_ms, 'loess');
            smooth_psth = smooth(summenpsth, smoothWin_ms, 'lowess');

            maxPsth = max(summenpsth);
            maxSmoothPsth = max(smooth_psth);

            subplot(7, 1, [ 5 6])

            a = area([preStimArea(1)  preStimArea(end)], [maxPsth maxPsth], 'FaceColor', gray);
            set(a,'EdgeColor','none')
            a.FaceAlpha = 0.2;
            hold on

            a = area([stimArea(1)  stimArea(end)], [maxPsth maxPsth], 'FaceColor', greencol);
            set(a,'EdgeColor','none')
            a.FaceAlpha = 0.4;
            hold on

            a = area([postStimArea(1)  postStimArea(end)], [maxPsth maxPsth], 'FaceColor', gray);
            set(a,'EdgeColor','none')
            a.FaceAlpha = 0.2;
            hold on

            plot(summenpsth, 'color', gray)

            plot(smooth_psth, 'k', 'linewidth' ,2);
            axis tight

            xlabel('Time [ms]')
            ylabel('PSTH [spks]')
            %%
            subplot(7, 1, [7])
            imagesc(allZScores);
            %colormap('hot')
            %colormap('bone')
            colormap('pink')
            %colormap('redblue')
            hold on
            for o = 1:6
                text(o-.2, 1, ['Z = ' num2str(round(allZScores(o), 2))])
                text(o-.2, 1.2, ['p = ' num2str(round(allPs(o), 4))])

            end

            disp('')
            %%
            disp('Printing Plot')
            set(0, 'CurrentFigure', figH)

            %dropBoxSavePath = [obj.PATHS.dropboxPath saveName '-RasterPsthZscore_smp1'];
            dropBoxSavePath = ['/media/janie/Data64GB/OTData/OT/allHRTFsJanie/' saveName '-RasterPsthZscore_smp1'];
            %FigSaveName = [obj.PATHS.spkSavePath 'HRTF_Raster_v1_SpkClust' num2str(obj.SPKS.clustOfInterest)];

            plotpos = [0 0 35 40];

            %print_in_A4(0, FigSaveName, '-depsc', 0, plotpos);
            %print_in_A4(0, FigSaveName, '-djpeg', 0, plotpos);

            print_in_A4(0, dropBoxSavePath , '-djpeg', 0, plotpos);
            %print_in_A4(0, dropBoxSavePath, '-depsc', 0, plotpos);

            %dropBoxSavePath = [obj.PATHS.dropboxPath saveName  '-RasterPsthZscore_smvZ'];
            %print_in_A4(0, dropBoxSavePath, '-depsc', 1, plotpos);

            %% Now makin SRFs

            %%Sort Spike COunts

            preSpontWin_1_sumRep_cntcheck = sum(preSpontWin_1_sumRep);
            preSpontWin_2_sumRep_cntcheck =  sum(preSpontWin_2_sumRep);
            stimWin_1_sumRep_cntcheck = sum(stimWin_1_sumRep);
            stimWin_2_sumRep_cntcheck = sum(stimWin_2_sumRep);
            postSpontWin_1_sumRep_cntcheck =   sum(postSpontWin_1_sumRep);
            postSpontWin_2_sumRep_cntcheck =  sum(postSpontWin_2_sumRep);

            %%
            preSpontWin_1_spkCntSort = [];
            preSpontWin_2_spkCntSort = [];
            stimWin_1_spkCntSort = [];
            stimWin_2_spkCntSort = [];
            postSpontWin_1_spkCntSort = [];
            postSpontWin_2_spkCntSort = [];

            n_elev = 13;
            n_azim = 33;

            %% Needs to be in this order
            ct = 1;
            for elev = 1:n_elev
                for azim = 1:n_azim

                    preSpontWin_1_spkCntSort(elev, azim) = preSpontWin_1_sumRep(ct);
                    preSpontWin_2_spkCntSort(elev, azim) = preSpontWin_2_sumRep(ct);
                    stimWin_1_spkCntSort(elev, azim) = stimWin_1_sumRep(ct);
                    stimWin_2_spkCntSort(elev, azim) = stimWin_2_sumRep(ct);
                    postSpontWin_1_spkCntSort(elev, azim) = postSpontWin_1_sumRep(ct);
                    postSpontWin_2_spkCntSort(elev, azim) = postSpontWin_2_sumRep(ct);

                    ct = ct+1;
                end
            end

            %% We do not normalize

            %maxispike=max(max(Spikearray));
            %maxispike=round(maxispike*10)/10;
            %Spikearray=Spikearray/max(max(Spikearray));

            %% smooth & rotate

            allArraysCnt = [preSpontWin_1_spkCntSort ; preSpontWin_2_spkCntSort ; stimWin_1_spkCntSort; stimWin_2_spkCntSort;
                postSpontWin_1_spkCntSort ; postSpontWin_2_spkCntSort];

            meanAll = nanmean(nanmean(allArraysCnt));
            stdAll = nanstd(nanstd(allArraysCnt));

            %z = (X - μ) / σ where z is the z-score, X is the value of the element, μ is the population mean, and σ is the standard deviation.

            preSpontWin_1_spkCntSort_Z = (preSpontWin_1_spkCntSort-meanAll)/stdAll;
            preSpontWin_2_spkCntSort_Z = (preSpontWin_2_spkCntSort-meanAll)/stdAll;
            stimWin_1_spkCntSort_Z = (stimWin_1_spkCntSort-meanAll)/stdAll;
            stimWin_2_spkCntSort_Z = (stimWin_2_spkCntSort-meanAll)/stdAll;
            postSpontWin_1_spkCntSort_Z = (postSpontWin_1_spkCntSort-meanAll)/stdAll;
            postSpontWin_2_spkCntSort_Z = (postSpontWin_2_spkCntSort-meanAll)/stdAll;

            preSpontWin_1_smoothSpkArray = flipud(moving_average2(preSpontWin_1_spkCntSort_Z(:,:),1,1));% rows ;collumns
            preSpontWin_2_smoothSpkArray = flipud(moving_average2(preSpontWin_2_spkCntSort_Z(:,:),1,1));% rows ;collumns
            stimWin_1_smoothSpkArray = flipud(moving_average2(stimWin_1_spkCntSort_Z(:,:),1,1));% rows ;collumns
            stimWin_2_smoothSpkArray = flipud(moving_average2(stimWin_2_spkCntSort_Z(:,:),1,1));% rows ;collumns
            postSpontWin_1_smoothSpkArray = flipud(moving_average2(postSpontWin_1_spkCntSort_Z(:,:),1,1));% rows ;collumns
            postSpontWin_2_smoothSpkArray = flipud(moving_average2(postSpontWin_2_spkCntSort_Z(:,:),1,1));% rows ;collumns

            %% Original
%             preSpontWin_1_smoothSpkArray = flipud(moving_average2(preSpontWin_1_spkCntSort(:,:),1,1));% rows ;collumns
%             preSpontWin_2_smoothSpkArray = flipud(moving_average2(preSpontWin_2_spkCntSort(:,:),1,1));% rows ;collumns
%             stimWin_1_smoothSpkArray = flipud(moving_average2(stimWin_1_spkCntSort(:,:),1,1));% rows ;collumns
%             stimWin_2_smoothSpkArray = flipud(moving_average2(stimWin_2_spkCntSort(:,:),1,1));% rows ;collumns
%             postSpontWin_1_smoothSpkArray = flipud(moving_average2(postSpontWin_1_spkCntSort(:,:),1,1));% rows ;collumns
%             postSpontWin_2_smoothSpkArray = flipud(moving_average2(postSpontWin_2_spkCntSort(:,:),1,1));% rows ;collumns
%
%
%
            %smoothSpikearray_norm=smoothSpikearray/max(max(smoothSpikearray));

            allArrays = [preSpontWin_1_smoothSpkArray ; preSpontWin_2_smoothSpkArray ; stimWin_1_smoothSpkArray; stimWin_2_smoothSpkArray;
                postSpontWin_1_smoothSpkArray ; postSpontWin_2_smoothSpkArray];


            maxArrayVal = max(max(allArrays));
            minArrayVal = min(min(allArrays));
            clims = [minArrayVal maxArrayVal ];
            %% Plot

            figHH  = figure(100);clf

            plotAudSpatRFs(figHH, preSpontWin_1_smoothSpkArray, 1, 0, 'Pre-Spont-1', clims)

            %             subplot(1, 8, 1)
            %             surf((preSpontWin_1_smoothSpkArray));
            %             shading interp
            %             view([ 0 90])
            %             axis tight
            %             title('Pre-Spont')
            %             set(gca,'ytick',[])
            %             set(gca,'xtick',[])
            %             xlabel('Azimuth')
            %             ylabel('Elevation')
            %             set(gca, 'clim', clims)

            plotAudSpatRFs(figHH, preSpontWin_2_smoothSpkArray, 2, 0, 'Pre-Spont-2', clims)

            %             subplot(1, 8, 2)
            %             surf((preSpontWin_2_smoothSpkArray));
            %             shading interp
            %             view([ 0 90])
            %             axis tight
            %             title('Stim-1')
            %             set(gca,'ytick',[])
            %             set(gca,'xtick',[])
            %             xlabel('Azimuth')
            %             set(gca, 'clim', clims)
            %             %ylabel('Elevation')

            plotAudSpatRFs(figHH, stimWin_1_smoothSpkArray, 3, 0, 'Stim-1', clims)

            %             subplot(1, 8, 3)
            %             surf((stimWin_1_smoothSpkArray));
            %             shading interp
            %             view([ 0 90])
            %             axis tight
            %             title('Stim-2')
            %             set(gca,'ytick',[])
            %             set(gca,'xtick',[])
            %             xlabel('Azimuth')
            %             set(gca, 'clim', clims)
            %             %ylabel('Elevation')

            plotAudSpatRFs(figHH, stimWin_2_smoothSpkArray, 4, 0, 'Stim-2', clims)

            %             subplot(1, 8, 4)
            %             surf((stimWin_2_smoothSpkArray));
            %             shading interp
            %             view([ 0 90])
            %             axis tight
            %             title('Stim-3')
            %             set(gca,'ytick',[])
            %             set(gca,'xtick',[])
            %             xlabel('Azimuth')
            %             set(gca, 'clim', clims)
            %             %ylabel('Elevation')
            %
            plotAudSpatRFs(figHH, postSpontWin_1_smoothSpkArray, 5, 0, 'Post-Spont-1', clims)

            %             subplot(1, 8, 5)
            %             surf((postSpontWin_1_smoothSpkArray));
            %             shading interp
            %             view([ 0 90])
            %             axis tight
            %             title('Post-Spont-1')
            %             set(gca,'ytick',[])
            %             set(gca,'xtick',[])
            %             xlabel('Azimuth')
            %             set(gca, 'clim', clims)
            %             %ylabel('Elevation')

            plotAudSpatRFs(figHH, postSpontWin_2_smoothSpkArray, 6, 0, 'Pre-Spont-2', clims)

            %             subplot(1, 8, 6)
            %             surf((postSpontWin_2_smoothSpkArray));
            %             shading interp
            %             view([ 0 90])
            %             axis tight
            %             title('Post-Spont-2')
            %             set(gca,'ytick',[])
            %             set(gca,'xtick',[])
            %             xlabel('Azimuth')
            %             set(gca, 'clim', clims)
            %             %ylabel('Elevation')
            %

            plotAudSpatRFs(figHH, preSpontWin_1_smoothSpkArray, 7, 1, 'Pre-Spont-1', clims)
            plotAudSpatRFs(figHH, preSpontWin_2_smoothSpkArray, 8, 1, 'Pre-Spont-2', clims)
            plotAudSpatRFs(figHH, stimWin_1_smoothSpkArray, 9, 1, 'Stim-1',clims)
            plotAudSpatRFs(figHH, stimWin_2_smoothSpkArray, 10, 1, 'Stim-2', clims)
            plotAudSpatRFs(figHH, postSpontWin_1_smoothSpkArray, 11, 1, 'Post-Spont-1', clims)
            plotAudSpatRFs(figHH, postSpontWin_2_smoothSpkArray, 12, 1, 'Pre-Spont-2', clims)

            %%

            %%
            disp('Printing Plot')
            set(0, 'CurrentFigure', figHH)

            %dropBoxSavePath = [obj.PATHS.dropboxPath  saveName '-SpatialRFs'];
            %FigSaveName = [obj.PATHS.spkSavePath 'HRTF_aSRFs_v1_SpkClust' num2str(obj.SPKS.clustOfInterest)];

            dropBoxSavePath = ['/media/janie/Data64GB/OTData/OT/allHRTFsJanie/' saveName '_aSRFs_Z_SpkClust' num2str(obj.SPKS.clustOfInterest)];

            %plotpos = [0 0 60 5];
            plotpos = [0 0 40 10];
            %print_in_A4(0, dropBoxSavePath , '-djpeg', 0, plotpos);
            %print_in_A4(0, dropBoxSavePath, '-depsc', 0, plotpos);

            print_in_A4(0, dropBoxSavePath, '-djpeg', 0, plotpos);
            %print_in_A4(0, FigSaveName, '-depsc', 0, plotpos);


        end


        %% Printing Rasters and Figures

        function [] = printRasterVer1(obj)

            gray = [0.8 0.8 0.8];
            figH = figure(101);clf

            audSel_ID = obj.O_STIMS.audSel_ID;

            nUniqueStimC2 = obj.O_STIMS.nUniqueStimC2;
            nUniqueStimC1 = obj.O_STIMS.nUniqueStimC1;
            allSpksMatrix = obj.S_SPKS.SORT.allSpksMatrix;
            epochLength_samps = obj.S_SPKS.INFO.epochLength_samps;

            stimStart_samp = obj.S_SPKS.INFO.stimStart_samp;
            stimStop_samp = obj.S_SPKS.INFO.stimStop_samp;

            xticks_ms = 0:50:obj.S_SPKS.INFO.epochLength_ms;
            xticks_samps = (xticks_ms/1000)*obj.S_SPKS.INFO.Fs;

            for o = 1:nUniqueStimC2
                for oo = 1:nUniqueStimC1

                    thisStim_spks = allSpksMatrix{o,oo};
                    this_nStims = numel(thisStim_spks);

                    thisStimMatrix = nan(epochLength_samps, this_nStims);

                    for q = 1:this_nStims

                        theseSpks = thisStim_spks{q};
                        thisStimMatrix(theseSpks) = q;

                    end

                    allSpkMatrix_nan{o,oo} = thisStimMatrix;

                    pos = getAxPos(nUniqueStimC2, nUniqueStimC1, o, oo);
                    axes('position', pos);
                    area([stimStart_samp  stimStop_samp], [this_nStims this_nStims], 'FaceColor', gray, 'EdgeColor', gray)
                    hold on
                    plot(thisStimMatrix, 'k.')
                    hold on

                    %%
                    line([0 0], [0 this_nStims], 'color', 'k')
                    line([epochLength_samps epochLength_samps], [0 this_nStims], 'color', 'k')
                    line([0 epochLength_samps], [0 0], 'color', 'k')
                    line([0 epochLength_samps], [this_nStims this_nStims], 'color', 'k')

                    ylim([0 this_nStims])
                    xlim([0 epochLength_samps])

                    %%
                    switch audSel_ID

                        case {1, 2}

                            axis off

                        otherwise

                            set(gca, 'xtick', xticks_samps)

                            for j = 1:numel(xticks_samps)
                                xlabs{j} = num2str(xticks_ms(j));
                            end

                            set(gca, 'xticklabel', xlabs)
                            xlabel('Time [ms]')
                    end


                end

            end

            %titleText = [obj.O_STIMS.ProtocolName ' | ' obj.INFO.bird_number ' | ' obj.RS_INFO.ResultDirName{obj.O_STIMS.audSel}];
            titleTextUnderscore = [obj.RS_INFO.ResultDirName{obj.O_STIMS.audSelInd} ' | SpkCluster ' num2str(obj.SPKS.clustOfInterest)];
            titleText = titleTextUnderscore;
            underscore = '_';

            bla = find(titleTextUnderscore  == underscore);

            for p = 1: numel(bla)
                titleText(bla(p)) = '-';
            end

            annotation(figH,'textbox',...
                [0.05 0.94 0.80 0.05],...
                'String',titleText,...
                'LineStyle','none',...
                'HorizontalAlignment','left',...
                'FitBoxToText','off');

            %% Print
            figure(figH)

            disp('Printing Plot')
            set(0, 'CurrentFigure', figH)

            FigSaveName = [obj.PATHS.spkSavePath 'Raster_v1_SpkClust' num2str(obj.SPKS.clustOfInterest)];
            dropBoxSavePath = [obj.PATHS.dropboxPath obj.RS_INFO.expTextLabel '__' obj.PATHS.audStimDir '_Raster_v1_SpkClust' num2str(obj.SPKS.clustOfInterest)];

            plotpos = [0 0 40 20];
            print_in_A4(0, FigSaveName, '-djpeg', 0, plotpos);
            print_in_A4(0, dropBoxSavePath, '-djpeg', 0, plotpos);

        end


        function [] = printRasterVer1_silent(obj)

            gray = [0.8 0.8 0.8];
            figH = figure(101);clf

            audSel_ID = obj.O_STIMS.audSel_ID;

            nUniqueStimC2 = 1;
            nUniqueStimC1 = 1;

            allSpksMatrix = obj.S_SPKS.SORT.allSpksMatrix_Silent;

            epochLength_samps = obj.S_SPKS.INFO.epochLength_samps;

            stimStart_samp = obj.S_SPKS.INFO.stimStart_samp;
            stimStop_samp = obj.S_SPKS.INFO.stimStop_samp;

            xticks_ms = 0:50:obj.S_SPKS.INFO.epochLength_ms;
            xticks_samps = (xticks_ms/1000)*obj.S_SPKS.INFO.Fs;

            for o = 1:nUniqueStimC2
                for oo = 1:nUniqueStimC1

                    thisStim_spks = allSpksMatrix;
                    this_nStims = numel(thisStim_spks);

                    thisStimMatrix = nan(epochLength_samps, this_nStims);

                    for q = 1:this_nStims

                        theseSpks = thisStim_spks{q};
                        thisStimMatrix(theseSpks) = q;

                    end

                    allSpkMatrix_nan{o,oo} = thisStimMatrix;

                    pos = getAxPos(nUniqueStimC2, nUniqueStimC1, o, oo);
                    axes('position', pos);
                    area([stimStart_samp  stimStop_samp], [this_nStims this_nStims], 'FaceColor', gray, 'EdgeColor', gray)
                    hold on
                    plot(thisStimMatrix, 'k.')
                    hold on

                    %%
                    line([0 0], [0 this_nStims], 'color', 'k')
                    line([epochLength_samps epochLength_samps], [0 this_nStims], 'color', 'k')
                    line([0 epochLength_samps], [0 0], 'color', 'k')
                    line([0 epochLength_samps], [this_nStims this_nStims], 'color', 'k')

                    ylim([0 this_nStims])
                    xlim([0 epochLength_samps])

                    %%
                    switch audSel_ID

                        case {1, 2}

                            axis off

                        otherwise

                            set(gca, 'xtick', xticks_samps)

                            for j = 1:numel(xticks_samps)
                                xlabs{j} = num2str(xticks_ms(j));
                            end

                            set(gca, 'xticklabel', xlabs)
                            xlabel('Time [ms]')
                    end


                end

            end

            %titleText = [obj.O_STIMS.ProtocolName ' | ' obj.INFO.bird_number ' | ' obj.RS_INFO.ResultDirName{obj.O_STIMS.audSel}];
            titleTextUnderscore = [obj.RS_INFO.ResultDirName{obj.O_STIMS.audSelInd} ' - Silent | SpkCluster ' num2str(obj.SPKS.clustOfInterest)];
            titleText = titleTextUnderscore;
            underscore = '_';

            bla = find(titleTextUnderscore  == underscore);

            for p = 1: numel(bla)
                titleText(bla(p)) = '-';
            end

            annotation(figH,'textbox',...
                [0.05 0.94 0.80 0.05],...
                'String',titleText,...
                'LineStyle','none',...
                'HorizontalAlignment','left',...
                'FitBoxToText','off');

            %% Print
            figure(figH)

            disp('Printing Plot')
            set(0, 'CurrentFigure', figH)

            FigSaveName = [obj.PATHS.spkSavePath 'SilentRaster_v1_SpkClust' num2str(obj.SPKS.clustOfInterest)];
            dropBoxSavePath = [obj.PATHS.dropboxPath obj.RS_INFO.expTextLabel '__' obj.PATHS.audStimDir '_SilentRaster_v1_SpkClust' num2str(obj.SPKS.clustOfInterest)];

            plotpos = [0 0 15 8];
            print_in_A4(0, FigSaveName, '-djpeg', 0, plotpos);
            print_in_A4(0, dropBoxSavePath, '-djpeg', 0, plotpos);

        end

        function []  = printRaster_WN_Ver1(obj)

            gray = [0.8 0.8 0.8];
            figH = figure(101);clf
            allSpksMatrix = obj.S_SPKS.SORT.allSpksMatrix;
            epochLength_samps = obj.S_SPKS.INFO.epochLength_samps;
            stimStart_samp = obj.S_SPKS.INFO.stimStart_samp;
            stimStop_samp = obj.S_SPKS.INFO.stimStop_samp;
            spk_size_y = 0.005;
            y_offset_between_repetitions = 0.001;
            thisUniqStimFR  = zeros(1,epochLength_samps); % we define a vector for integrated FR
            allSpksFR = zeros(epochLength_samps,1);

            %% Concat all responses

            nStimTypes = numel(allSpksMatrix);

            conCatAll = [];
            cnt =1;
            for j = 1:nStimTypes
                nTheseReps = numel(allSpksMatrix{j});
                for k = 1: nTheseReps
                    conCatAll{cnt} = allSpksMatrix{1,j}{1,k};
                    cnt = cnt +1;
                end
            end

            nAllReps = numel(conCatAll);
            %%
            subplot(4, 1, [1 2 3])
            for s = 1 : nAllReps

                these_spks_on_chan = conCatAll{s};

                y_low =  (s * spk_size_y - spk_size_y);
                y_high = (s * spk_size_y - y_offset_between_repetitions);

                spk_vct = repmat(these_spks_on_chan, 2, 1); % this draws a straight vertical line
                this_run_spks = size(spk_vct, 2);
                ln_vct = repmat([y_high; y_low], 1, this_run_spks); % this defines the line height

                line(spk_vct, ln_vct, 'LineWidth', 0.5, 'Color', 'k');

                nbr_spks = size(these_spks_on_chan, 2);

                % add a 1 to the FR vector for every spike
                for ind = 1 : nbr_spks

                    if these_spks_on_chan(ind) == 0
                        continue
                    else

                        thisUniqStimFR(these_spks_on_chan(ind)) = thisUniqStimFR(these_spks_on_chan(ind)) +1;
                        allSpksFR(these_spks_on_chan(ind)) = allSpksFR(these_spks_on_chan(ind)) +1;
                    end
                end
            end

            axis tight
            xlim([0 epochLength_samps])
            ylabel(['Reps = ' num2str(nAllReps)])
            set(gca, 'xtick', []);
            set(gca, 'ytick', []);

            titleTextUnderscore = [obj.RS_INFO.ResultDirName{obj.O_STIMS.audSelInd} ' | SpkCluster ' num2str(obj.SPKS.clustOfInterest)];
            titleText = titleTextUnderscore;
            underscore = '_';

            bla = find(titleTextUnderscore  == underscore);

            for p = 1: numel(bla)
                titleText(bla(p)) = '-';
            end

            title(titleText)
            %% Firing Rate

            subplot(4, 1, 4)
            smoothiWin = round(obj.Fs*.005);% 5 ms
            FRsmoothed = smooth(thisUniqStimFR, smoothiWin)/nAllReps;
            timepoints = 1:1:numel(FRsmoothed);
            timepoints_ms = timepoints/obj.Fs*1000;

            area([stimStart_samp/obj.Fs*1000  stimStop_samp/obj.Fs*1000], [0.005 0.005], 'FaceColor', gray, 'EdgeColor', gray)
            hold on
            plot(timepoints_ms, FRsmoothed, 'color', 'k', 'LineWidth', 1)

            axis tight
            ylim([0 0.002])
            xlabel('Time [ms]')
            ylabel('FR [Hz]')

            %% Print
            figure(figH)

            disp('Printing Plot')
            set(0, 'CurrentFigure', figH)

            FigSaveName = [obj.PATHS.spkSavePath 'WNRaster_v1_SpkClust' num2str(obj.SPKS.clustOfInterest)];
            %dropBoxSavePath = [obj.PATHS.dropboxPath obj.RS_INFO.expTextLabel '__' obj.PATHS.audStimDir '_WNRaster_v1_SpkClust' num2str(obj.SPKS.clustOfInterest)];
            dropBoxSavePath = ['/media/janie/Data64GB/OTData/OT/allWNsJanie/' FigSaveName];

            plotpos = [0 0 12 15];
            print_in_A4(0, FigSaveName, '-djpeg', 0, plotpos);
            print_in_A4(0, dropBoxSavePath, '-djpeg', 0, plotpos);

        end


        function []  = printRaster_WN_Ver2(obj)

            saveName = obj.PATHS.audStimDir;

            Twin_s = 0.05;

            preSpontWin_1 = 1:50;
            preSpontWin_2 = 51:100;
            stimWin_1 = 101:150;
            stimWin_2 = 151:200;
            postSpontWin_1 = 201:250;
            postSpontWin_2 = 251:300;

            gray = [0.8 0.8 0.8];
            blueCol = [0.2 0.7 0.8];
            scanrate = obj.Fs;

            allSpksMatrix = obj.S_SPKS.SORT.allSpksMatrix;
            epochLength_samps = obj.S_SPKS.INFO.epochLength_samps;
            %epochLength_ms = round(obj.S_SPKS.INFO.epochLength_ms);
            stimStart_samp = obj.S_SPKS.INFO.stimStart_samp;
            %stimStart_ms = stimStart_samp/scanrate*1000;
            stimStop_samp = obj.S_SPKS.INFO.stimStop_samp;
            %stimStop_ms  = stimStop_samp/ scanrate*1000;;

            allSpksFR = zeros(epochLength_samps,1);

            %%


            nStimTypes = numel(allSpksMatrix);

            conCatAll = [];
            cnt =1;
            for j = 1:nStimTypes
                nTheseReps = numel(allSpksMatrix{j});
                for k = 1: nTheseReps
                    conCatAll{cnt} = allSpksMatrix{1,j}{1,k};
                    cnt = cnt +1;
                end
            end

            nAllReps = numel(conCatAll);

            %%
            figH = figure(101);clf
            subplot(6, 1, [1 2 3])
            nStimTypes = numel(allSpksMatrix);
            cnt =1;

            for j = 1 : nStimTypes
                nTheseReps = numel(allSpksMatrix{j});
                for k = 1: nTheseReps

                    %must subtract start_stim to arrange spikes relative to onset
                    spks = allSpksMatrix{1,j}{1,k};
                    %theseSpks_ms = spks /scanrate *1000;
                    ypoints = ones(numel(spks))*cnt;
                    hold on
                    plot(spks, ypoints, 'k.', 'linestyle', 'none', 'MarkerFaceColor','k','MarkerEdgeColor','k')

                    cnt = cnt +1;

                    nbr_spks = numel(spks);
                    % add a 1 to the FR vector for every spike
                    for ind = 1 : nbr_spks

                        % if nbr_spks(ind) == 0
                        %     continue
                        % else

                        allSpksFR(spks(ind)) = allSpksFR(spks(ind)) +1;
                        %end
                    end

                    if k == nTheseReps
                        line([0 epochLength_samps], [cnt cnt], 'color', blueCol)
                        %text(-20, cnt-30, (sortedDataNames{elev, azim}(4:10)))
                    end
                end


            end

            axis tight
            xlim([0 epochLength_samps])
            ylabel(['Reps = ' num2str(nTheseReps)])
            set(gca, 'xtick', []);
            set(gca, 'ytick', []);

            titleTextUnderscore = [obj.RS_INFO.ResultDirName{obj.O_STIMS.audSelInd} ' | SpkCluster ' num2str(obj.SPKS.clustOfInterest)];
            titleText = titleTextUnderscore;
            underscore = '_';

            bla = find(titleTextUnderscore  == underscore);

            for p = 1: numel(bla)
                titleText(bla(p)) = '-';
            end

            title(titleText)

            %% PSTH

            subplot(6, 1, [4 5] )
            smoothiWin = round(obj.Fs*.005);% 5 ms
            FRsmoothed = smooth(allSpksFR, smoothiWin)/nAllReps;
            timepoints = 1:1:numel(FRsmoothed);
            timepoints_ms = timepoints/obj.Fs*1000;


            maxval = max(FRsmoothed);
            if maxval > 0.002
                ylims = 0.005;
            else
                ylims = 0.002;
            end


            area([stimStart_samp/obj.Fs*1000  stimStop_samp/obj.Fs*1000], [0.005 0.005], 'FaceColor', gray, 'EdgeColor', gray)
            hold on
            plot(timepoints_ms, FRsmoothed, 'color', 'k', 'LineWidth', 1)

            axis tight
            ylim([0 ylims])
            xlabel('Time [ms]')
            ylabel('FR [Hz]')


            %%
            for j = 1 : nStimTypes
                nTheseReps = numel(allSpksMatrix{j});
                for k = 1: nTheseReps

                    spks = (allSpksMatrix{1, j}{1,k})/scanrate*1000;

                    %spks_samp = allSpksMatrix{1, j}{1,k};
                    %spks = spks_samp /scanrate*1000;
                    %these_spks_on_chan = spks(spks >= reshapedOnsets(p) & spks <= reshapedOffsets(p))-reshapedOnsets(p);

                    preSpontWin_1_spks_reps(k) = numel(spks(spks >= preSpontWin_1(1) & spks <= preSpontWin_1(end)));
                    preSpontWin_2_spks_reps(k) = numel(spks(spks >= preSpontWin_2(1) & spks <= preSpontWin_2(end)));
                    stimWin_1_spks_reps(k) = numel(spks(spks >= stimWin_1(1) & spks <= stimWin_1(end)));
                    stimWin_2_spks_reps(k) = numel(spks(spks >= stimWin_2(1) & spks <= stimWin_2(end)));
                    postSpontWin_1_spks_reps(k) = numel(spks(spks >= postSpontWin_1(1) & spks <= postSpontWin_1(end)));
                    postSpontWin_2_spks_reps(k) = numel(spks(spks >= postSpontWin_2(1) & spks <= postSpontWin_2(end)));

                    preSpontWin_1_spks(cnt) = numel(spks(spks >= preSpontWin_1(1) & spks <= preSpontWin_1(end)));
                    preSpontWin_2_spks(cnt) = numel(spks(spks >= preSpontWin_2(1) & spks <= preSpontWin_2(end)));
                    stimWin_1_spks(cnt) = numel(spks(spks >= stimWin_1(1) & spks <= stimWin_1(end)));
                    stimWin_2_spks(cnt) = numel(spks(spks >= stimWin_2(1) & spks <= stimWin_2(end)));
                    postSpontWin_1_spks(cnt) = numel(spks(spks >= postSpontWin_1(1) & spks <= postSpontWin_1(end)));
                    postSpontWin_2_spks(cnt) = numel(spks(spks >= postSpontWin_2(1) & spks <= postSpontWin_2(end)));

                    cnt = cnt+1;
                    disp('')
                end

                preSpontWin_1_sumRep(j) = sum(preSpontWin_1_spks_reps);
                preSpontWin_2_sumRep(j) =  sum(preSpontWin_2_spks_reps);
                stimWin_1_sumRep(j) = sum(stimWin_1_spks_reps);
                stimWin_2_sumRep(j) = sum(stimWin_2_spks_reps);
                postSpontWin_1_sumRep(j) =   sum(postSpontWin_1_spks_reps);
                postSpontWin_2_sumRep(j) =  sum(postSpontWin_2_spks_reps);

                preSpontWin_1_FR(j,:) = preSpontWin_1_spks_reps/Twin_s;
                preSpontWin_2_FR(j,:) =  preSpontWin_2_spks_reps/Twin_s;
                stimWin_1_FR(j,:) = stimWin_1_spks_reps/Twin_s;
                stimWin_2_FR(j,:) = stimWin_2_spks_reps/Twin_s;
                postSpontWin_1_FR(j,:) = postSpontWin_1_spks_reps/Twin_s;
                postSpontWin_2_FR(j,:) = postSpontWin_2_spks_reps/Twin_s;

            end

            preSpontWin_1_meanFR = nanmean(nanmean(preSpontWin_1_FR));
            preSpontWin_2_meanFR = nanmean(nanmean(preSpontWin_2_FR));
            stimWin_1_meanFR = nanmean(nanmean(stimWin_1_FR));
            stimWin_2_meanFR = nanmean(nanmean(stimWin_2_FR));
            postSpontWin_1_meanFR = nanmean(nanmean(postSpontWin_1_FR));
            postSpontWin_2_meanFR = nanmean(nanmean(postSpontWin_2_FR));

            preSpontWin_1_std = nanstd(nanstd(preSpontWin_1_FR));
            preSpontWin_2_stimWin_1_std = nanstd(nanstd(preSpontWin_2_FR));
            stimWin_1_std = nanstd(nanstd(stimWin_1_FR));
            stimWin_2_std = nanstd(nanstd(stimWin_2_FR));
            postSpontWin_1_std = nanstd(nanstd(postSpontWin_1_FR));
            postSpontWin_2_std = nanstd(nanstd(postSpontWin_2_FR));

            z_score_cov_preSpontWin_1 = (preSpontWin_1_meanFR - preSpontWin_1_meanFR) / sqrt(preSpontWin_1_std^2 + preSpontWin_1_std^2);
            z_score_cov_preSpontWin_2 = (preSpontWin_2_meanFR - preSpontWin_1_meanFR) / sqrt(preSpontWin_2_stimWin_1_std^2 + preSpontWin_1_std^2);
            z_score_cov_stimWin_1 = (stimWin_1_meanFR - preSpontWin_1_meanFR) / sqrt(stimWin_1_std^2 + preSpontWin_1_std^2);
            z_score_cov_stimWin_2 = (stimWin_2_meanFR - preSpontWin_1_meanFR) / sqrt(stimWin_2_std^2 + preSpontWin_1_std^2);
            z_score_cov_postSpontWin_1 = (postSpontWin_1_meanFR - preSpontWin_1_meanFR) / sqrt(postSpontWin_1_std^2 + preSpontWin_1_std^2);
            z_score_cov_postSpontWin_2 = (postSpontWin_2_meanFR - preSpontWin_1_meanFR) / sqrt(postSpontWin_2_std^2 + preSpontWin_1_std^2);

            allZScores = [z_score_cov_preSpontWin_1 z_score_cov_preSpontWin_2 z_score_cov_stimWin_1 z_score_cov_stimWin_2 z_score_cov_postSpontWin_1 z_score_cov_postSpontWin_2];
            %allFrs = [];

            [p_preSpontWin_1, h]  = signrank(reshape(preSpontWin_1_FR, 1, numel(preSpontWin_1_FR)), reshape(preSpontWin_1_FR, 1, numel(preSpontWin_1_FR)));
            [p_preSpontWin_2, h]  = signrank(reshape(preSpontWin_1_FR, 1, numel(preSpontWin_1_FR)), reshape(preSpontWin_2_FR, 1, numel(preSpontWin_2_FR)));
            [p_stimWin_1, h]  = signrank(reshape(preSpontWin_1_FR, 1, numel(preSpontWin_1_FR)), reshape(stimWin_1_FR, 1, numel(stimWin_1_FR)));
            [p_stimWin_2, h]  = signrank(reshape(preSpontWin_1_FR, 1, numel(preSpontWin_1_FR)), reshape(stimWin_2_FR, 1, numel(stimWin_2_FR)));
            [p_postSpontWin_1, h]  = signrank(reshape(preSpontWin_1_FR, 1, numel(preSpontWin_1_FR)), reshape(postSpontWin_1_FR, 1, numel(postSpontWin_1_FR)));
            [p_postSpontWin_2, h]  = signrank(reshape(preSpontWin_1_FR, 1, numel(preSpontWin_1_FR)), reshape(postSpontWin_2_FR, 1, numel(postSpontWin_2_FR)));

            allPs = [p_preSpontWin_1 p_preSpontWin_2 p_stimWin_1 p_stimWin_2 p_postSpontWin_1 p_postSpontWin_2];

            subplot(6, 1, 6 )

            %clims = [-20 20];
            %imagesc(allZScores, clims);
            imagesc(allZScores);

            %colormap('hot')
            %colormap('bone')
            colormap('pink')
            %colormap('redblue')
            hold on
            for o = 1:6
                text(o-.2, 1, ['Z = ' num2str(round(allZScores(o), 2))])
                text(o-.2, 1.2, ['p = ' num2str(round(allPs(o), 4))])

            end


            %% Print
            figure(figH)

            disp('Printing Plot')
            set(0, 'CurrentFigure', figH)

            FigSaveName = [obj.PATHS.spkSavePath 'WNRaster_v1_SpkClust' num2str(obj.SPKS.clustOfInterest)];
            %dropBoxSavePath = [obj.PATHS.dropboxPath obj.RS_INFO.expTextLabel '__' obj.PATHS.audStimDir '_WNRaster_v1_SpkClust' num2str(obj.SPKS.clustOfInterest)];
            %dropBoxSavePath = ['/media/janie/Data64GB/OTData/OT/allWNsJanie/' saveName '_Clust-' num2str(obj.SPKS.clustOfInterest)];
            dropBoxSavePath = ['/home/janie/Data/OTAnalysis/allWNsJanie/' saveName '_Clust-' num2str(obj.SPKS.clustOfInterest)];

            plotpos = [0 0 12 15];
            %print_in_A4(0, FigSaveName, '-djpeg', 0, plotpos);
            %print_in_A4(0, FigSaveName, '-depsc', 0, plotpos);
            print_in_A4(0, dropBoxSavePath, '-djpeg', 0, plotpos);

        end




        function []  = printRaster_IID_Ver1(obj, IID_ITD_switch)

            switch IID_ITD_switch

                case 1
                    is_IID = 1;
                    titlePart = 'IID';
                case 2
                    is_ITD = 2;
                    titlePart = 'ITD';
            end

            gray = [0.8 0.8 0.8];
            figH = figure(105);clf
            allSpksMatrix = obj.S_SPKS.SORT.allSpksMatrix;
            epochLength_samps = obj.S_SPKS.INFO.epochLength_samps;
            stimStart_samp = obj.S_SPKS.INFO.stimStart_samp;
            stimStop_samp = obj.S_SPKS.INFO.stimStop_samp;
            spk_size_y = 0.005;
            y_offset_between_repetitions = 0.001;

            jSColors = {[.84  .17 .05], [.36 .27 .53],   [.21 .44 .12],  [.94, .56 .078],  [.039 .3 .99],  [.22 .52 .55], [.72 .15 .25]};
            repCols = repmat(jSColors, 1, 1000);
            %% Concat all responses

            nStimTypes = numel(allSpksMatrix);
            nRepsInStim = numel(allSpksMatrix{1});

            conCatAll = [];
            cnt =1;
            for j = 1:nStimTypes
                nTheseReps = numel(allSpksMatrix{j});
                for k = 1: nTheseReps
                    conCatAll{cnt} = allSpksMatrix{1,j}{1,k};
                    cnt = cnt +1;
                end
            end
            %%

            nStimTypes = numel(allSpksMatrix);

            for j = 1:nStimTypes
                theseReps = allSpksMatrix{j};

                thisUniqStimFR  = zeros(1,epochLength_samps); % we define a vector for integrated FR
                allSpksFR = zeros(epochLength_samps,1);

                for ss = 1:numel(theseReps)

                    these_spks_on_Chan = theseReps{ss};
                    nbr_spks = size(these_spks_on_Chan, 2);

                    % add a 1 to the FR vector for every spike
                    for ind = 1 : nbr_spks

                        if these_spks_on_Chan(ind) == 0
                            continue
                        else

                            thisUniqStimFR(these_spks_on_Chan(ind)) = thisUniqStimFR(these_spks_on_Chan(ind)) +1;
                            allSpksFR(these_spks_on_Chan(ind)) = allSpksFR(these_spks_on_Chan(ind)) +1;
                        end
                    end

                end
                allFR{j} = thisUniqStimFR;
                allSpkFR{j} = allSpksFR;
            end

            %%
            nAllReps = numel(conCatAll);
            lincnt = 1;
            subplot(4, 2, [1 3 5 7]); cla
            colCnt = 1;

            for s = 1 : nAllReps

                these_spks_on_chan = conCatAll{s};

                %if isempty(these_spks_on_chan )
                %    continue
                %else
                y_low =  (s * spk_size_y - spk_size_y);
                y_high = (s * spk_size_y - y_offset_between_repetitions);

                spk_vct = repmat(these_spks_on_chan, 2, 1); % this draws a straight vertical line
                this_run_spks = size(spk_vct, 2);
                ln_vct = repmat([y_high; y_low], 1, this_run_spks); % this defines the line height

                line(spk_vct, ln_vct, 'LineWidth', 0.5, 'Color', repCols{colCnt });

                if mod(s, 15) == 0
                    line([0 epochLength_samps], [y_high y_high], 'color', 'k')

                    colCnt  = colCnt +1;
                    AllYs(lincnt) = y_high;
                    lincnt = lincnt +1;

                end
                %end
            end

            axis tight
            xlim([0 epochLength_samps])
            ylabel(['Reps = ' num2str(nAllReps)])
            set(gca, 'xtick', []);
            set(gca, 'ytick', []);

            %titleInd = find(obj.RS_INFO.StimProtocol_ID == obj.O_STIMS.audSelInd);
            titleTextUnderscore = [obj.RS_INFO.ResultDirName{obj.O_STIMS.audSelInd} ' | SpkCluster ' num2str(obj.SPKS.clustOfInterest)];


            titleText = titleTextUnderscore;
            underscore = '_';

            bla = find(titleTextUnderscore  == underscore);

            for p = 1: numel(bla)
                titleText(bla(p)) = '-';
            end

            title(titleText)
            %% Firing Rate

            subplot(4, 2, [2 4 6 8]); cla
            smoothiWin = round(obj.Fs*.005);% 5 ms

            offset = 0;

            offsetRange = 0.005*(numel(allFR)+1);

            area([stimStart_samp/obj.Fs*1000  stimStop_samp/obj.Fs*1000], [offsetRange offsetRange], 'FaceColor', gray, 'EdgeColor', gray)


            for p = 1:numel(allFR)

                thisFR = allFR{p};

                thisText = obj.O_STIMS.stimName{p};

                FRsmoothed = smooth(thisFR, smoothiWin, 'lowess')/nRepsInStim;
                timepoints = 1:1:numel(FRsmoothed);
                timepoints_ms = timepoints/obj.Fs*1000;

                hold on
                plot(timepoints_ms, FRsmoothed+offset, 'color', repCols{p}, 'LineWidth', 1)
                text(-55, [offset], thisText);
                offset = offset + .005;

            end

            axis tight
            ylim([0 offset+.005])
            %ylim([0 offset])
            xlabel('Time [ms]')
            ylabel('FR [Hz]')
            %line([110 110], [0 offset+.005], 'color', 'k')
            %grid on
            %grid('minor')
            %% Print
            figure(figH)

            disp('Printing Plot')
            set(0, 'CurrentFigure', figH)

            FigSaveName = [obj.PATHS.spkSavePath titlePart '_v1_SpkClust' num2str(obj.SPKS.clustOfInterest)];
            %dropBoxSavePath = [obj.PATHS.dropboxPath obj.RS_INFO.expTextLabel '__' obj.PATHS.audStimDir titlePart '_Raster_v1_SpkClust' num2str(obj.SPKS.clustOfInterest)];

            dropBoxSavePath = ['/home/janie/Data/TUM/OTAnalysis/allITDJanie/allObjs/Figs/' obj.RS_INFO.expTextLabel '__' obj.PATHS.audStimDir titlePart '_Raster_v1_SpkClust' num2str(obj.SPKS.clustOfInterest)];
            plotpos = [0 0 20 15];
            print_in_A4(0, dropBoxSavePath, '-djpeg', 0, plotpos);
            print_in_A4(0, dropBoxSavePath, '-depsc', 0, plotpos);

        end


        function [] =  printRaster_HRTF_Ver2_OverAz(obj)

            gray = [0.8 0.8 0.8];


            allSpksMatrix = obj.S_SPKS.SORT.allSpksMatrix;
            epochLength_samps = obj.S_SPKS.INFO.epochLength_samps;
            stimStart_samp = obj.S_SPKS.INFO.stimStart_samp;
            stimStop_samp = obj.S_SPKS.INFO.stimStop_samp;
            allSpkNames = obj.S_SPKS.SORT.allSpksStimNames;

            spk_size_y = 0.005;
            y_offset_between_repetitions = 0.001;

            jSColors = {[.84  .17 .05], [.36 .27 .53],   [.21 .44 .12],  [.94, .56 .078],  [.039 .3 .99],  [.22 .52 .55], [.72 .15 .25]};
            repCols = repmat(jSColors, 1, 5);
            %% Concat all responses

            nStim_Cols_Azimuth = size(allSpksMatrix, 2);
            nStim_Rows_Elevation = size(allSpksMatrix, 1);


            figH = figure(200);


            HoldAzDir = [obj.PATHS.spkSavePath 'AzConstantFigs' obj.PATHS.dirD];

            if exist(HoldAzDir, 'dir') == 0
                mkdir(HoldAzDir);
            end

            %% First lets go through all the diff elevations, holding azimuth the same
            for o = 1:nStim_Cols_Azimuth

                figure(figH); clf

                thisCol_Az = allSpksMatrix(:, o);

                cnt =1;
                conCatAll_Cols = [];
                for j = 1:nStim_Rows_Elevation
                    nTheseReps = numel(thisCol_Az{j, 1});
                    for k = 1: nTheseReps
                        conCatAll_Cols{cnt} = thisCol_Az{j,1}{1,k};
                        cnt = cnt +1;
                    end
                end
                %%
                allFR = []; allSpkFR = [];
                for jj = 1:nStim_Rows_Elevation
                    theseReps = thisCol_Az{jj, 1};

                    thisUniqStimFR  = zeros(1,epochLength_samps); % we define a vector for integrated FR
                    allSpksFR = zeros(epochLength_samps,1);

                    for ss = 1:numel(theseReps)

                        these_spks_on_Chan = theseReps{ss};
                        nbr_spks = size(these_spks_on_Chan, 2);

                        % add a 1 to the FR vector for every spike
                        for ind = 1 : nbr_spks

                            if these_spks_on_Chan(ind) == 0
                                continue
                            else

                                thisUniqStimFR(these_spks_on_Chan(ind)) = thisUniqStimFR(these_spks_on_Chan(ind)) +1;
                                allSpksFR(these_spks_on_Chan(ind)) = allSpksFR(these_spks_on_Chan(ind)) +1;
                            end
                        end

                    end
                    allFR{jj} = thisUniqStimFR;
                    allSpkFR{jj} = allSpksFR;
                end

                %%
                nRepsInStim = nTheseReps;

                nAllReps = numel(conCatAll_Cols);
                lincnt = 1;
                subplot(4, 2, [1 3 5 7]); cla
                colCnt = 1;

                for s = 1 : nAllReps

                    these_spks_on_chan = conCatAll_Cols{s};

                    y_low =  (s * spk_size_y - spk_size_y);
                    y_high = (s * spk_size_y - y_offset_between_repetitions);

                    spk_vct = repmat(these_spks_on_chan, 2, 1); % this draws a straight vertical line
                    this_run_spks = size(spk_vct, 2);
                    ln_vct = repmat([y_high; y_low], 1, this_run_spks); % this defines the line height

                    line(spk_vct, ln_vct, 'LineWidth', 0.5, 'Color', repCols{colCnt });

                    if mod(s, nTheseReps) == 0
                        line([0 epochLength_samps], [y_high y_high], 'color', 'k')

                        colCnt  = colCnt +1;
                        AllYs(lincnt) = y_high;
                        lincnt = lincnt +1;

                    end

                end

                axis tight
                xlim([0 epochLength_samps])
                ylabel(['Reps = ' num2str(nAllReps)])
                set(gca, 'xtick', []);
                set(gca, 'ytick', []);

                titleTextUnderscore = [obj.RS_INFO.ResultDirName{obj.O_STIMS.audSelInd} ' | SpkCluster ' num2str(obj.SPKS.clustOfInterest)];
                titleText = titleTextUnderscore;
                underscore = '_';

                bla = find(titleTextUnderscore  == underscore);

                for p = 1: numel(bla)
                    titleText(bla(p)) = '-';
                end

                title(titleText)
                %% Firing Rate

                subplot(4, 2, [2 4 6 8]); cla
                smoothiWin = round(obj.Fs*.005);% 5 ms

                offset = 0;

                offsetRange = 0.005*(numel(allFR)+1);

                area([stimStart_samp/obj.Fs*1000  stimStop_samp/obj.Fs*1000], [offsetRange offsetRange], 'FaceColor', gray, 'EdgeColor', gray)


                for p = 1:numel(allFR)

                    thisFR = allFR{1,p};

                    thisText = obj.O_STIMS.stimName{p};

                    FRsmoothed = smooth(thisFR, smoothiWin)/nRepsInStim;
                    timepoints = 1:1:numel(FRsmoothed);
                    timepoints_ms = timepoints/obj.Fs*1000;

                    hold on
                    plot(timepoints_ms, FRsmoothed+offset, 'color', repCols{p}, 'LineWidth', 1)
                    text(15, [offset], allSpkNames{p,o}, 'Interpreter', 'none');
                    offset = offset + .005;

                end

                axis tight
                ylim([0 offset+.005])
                %ylim([0 offset])
                xlabel('Time [ms]')
                ylabel('FR [Hz]')

                %% Print


                figure(figH)

                disp('Printing Plot')
                set(0, 'CurrentFigure', figH)

                descriptTitle = allSpkNames{1,o};
                descriptTitle_short = descriptTitle(1:7);

                FigSaveName = [HoldAzDir descriptTitle_short '_v1_SpkClust' num2str(obj.SPKS.clustOfInterest)];
                %dropBoxSavePath = [obj.PATHS.dropboxPath obj.RS_INFO.expTextLabel '__' obj.PATHS.audStimDir '_' descriptTitle_short '_Raster_v1_SpkClust' num2str(obj.SPKS.clustOfInterest)];

                plotpos = [0 0 20 15];
                print_in_A4(0, FigSaveName, '-djpeg', 0, plotpos);
                %print_in_A4(0, dropBoxSavePath, '-djpeg', 0, plotpos);


            end

            disp('')


        end




        function [] =  printRaster_HRTF_Ver2_OverEl(obj)

            gray = [0.8 0.8 0.8];


            allSpksMatrix = obj.S_SPKS.SORT.allSpksMatrix;
            epochLength_samps = obj.S_SPKS.INFO.epochLength_samps;
            stimStart_samp = obj.S_SPKS.INFO.stimStart_samp;
            stimStop_samp = obj.S_SPKS.INFO.stimStop_samp;
            allSpkNames = obj.S_SPKS.SORT.allSpksStimNames;

            spk_size_y = 0.005;
            y_offset_between_repetitions = 0.001;

            jSColors = {[.84  .17 .05], [.36 .27 .53],   [.21 .44 .12],  [.94, .56 .078],  [.039 .3 .99],  [.22 .52 .55], [.72 .15 .25]};
            repCols = repmat(jSColors, 1, 5);
            %% Concat all responses

            nStim_Cols_Azimuth = size(allSpksMatrix, 2);
            nStim_Rows_Elevation = size(allSpksMatrix, 1);


            figH = figure(200);


            HoldElDir = [obj.PATHS.spkSavePath 'ElConstantFigs' obj.PATHS.dirD];

            if exist(HoldElDir, 'dir') == 0
                mkdir(HoldElDir);
            end

            %% First lets go through all the diff elevations, holding azimuth the same
            for o = 1:nStim_Rows_Elevation

                figure(figH); clf

                thisRow_El = allSpksMatrix(o, :);

                cnt =1;
                conCatAll_Cols = [];
                for j = 1:nStim_Cols_Azimuth
                    nTheseReps = numel(thisRow_El{1, j});
                    for k = 1: nTheseReps
                        conCatAll_Cols{cnt} = thisRow_El{1,j}{1,k};
                        cnt = cnt +1;
                    end
                end
                %%
                allFR = []; allSpkFR = [];
                for jj = 1:nStim_Cols_Azimuth
                    theseReps = thisRow_El{1, jj};

                    thisUniqStimFR  = zeros(1,epochLength_samps); % we define a vector for integrated FR
                    allSpksFR = zeros(epochLength_samps,1);

                    for ss = 1:numel(theseReps)

                        these_spks_on_Chan = theseReps{ss};
                        nbr_spks = size(these_spks_on_Chan, 2);

                        % add a 1 to the FR vector for every spike
                        for ind = 1 : nbr_spks

                            if these_spks_on_Chan(ind) == 0
                                continue
                            else

                                thisUniqStimFR(these_spks_on_Chan(ind)) = thisUniqStimFR(these_spks_on_Chan(ind)) +1;
                                allSpksFR(these_spks_on_Chan(ind)) = allSpksFR(these_spks_on_Chan(ind)) +1;
                            end
                        end

                    end
                    allFR{jj} = thisUniqStimFR;
                    allSpkFR{jj} = allSpksFR;
                end

                %%
                nRepsInStim = nTheseReps;

                nAllReps = numel(conCatAll_Cols);
                lincnt = 1;
                subplot(4, 2, [1 3 5 7]); cla
                colCnt = 1;

                for s = 1 : nAllReps

                    these_spks_on_chan = conCatAll_Cols{s};

                    y_low =  (s * spk_size_y - spk_size_y);
                    y_high = (s * spk_size_y - y_offset_between_repetitions);

                    spk_vct = repmat(these_spks_on_chan, 2, 1); % this draws a straight vertical line
                    this_run_spks = size(spk_vct, 2);
                    ln_vct = repmat([y_high; y_low], 1, this_run_spks); % this defines the line height

                    line(spk_vct, ln_vct, 'LineWidth', 0.5, 'Color', repCols{colCnt });

                    if mod(s, nTheseReps) == 0
                        line([0 epochLength_samps], [y_high y_high], 'color', 'k')

                        colCnt  = colCnt +1;
                        AllYs(lincnt) = y_high;
                        lincnt = lincnt +1;

                    end

                end

                axis tight
                xlim([0 epochLength_samps])
                ylabel(['Reps = ' num2str(nAllReps)])
                set(gca, 'xtick', []);
                set(gca, 'ytick', []);

                titleTextUnderscore = [obj.RS_INFO.ResultDirName{obj.O_STIMS.audSelInd} ' | SpkCluster ' num2str(obj.SPKS.clustOfInterest)];
                titleText = titleTextUnderscore;
                underscore = '_';

                bla = find(titleTextUnderscore  == underscore);

                for p = 1: numel(bla)
                    titleText(bla(p)) = '-';
                end

                title(titleText)
                %% Firing Rate

                subplot(4, 2, [2 4 6 8]); cla
                smoothiWin = round(obj.Fs*.005);% 5 ms

                offset = 0;

                offsetRange = 0.005*(numel(allFR)+1);

                area([stimStart_samp/obj.Fs*1000  stimStop_samp/obj.Fs*1000], [offsetRange offsetRange], 'FaceColor', gray, 'EdgeColor', gray)


                for p = 1:numel(allFR)

                    thisFR = allFR{1,p};

                    thisText = obj.O_STIMS.stimName{p};

                    FRsmoothed = smooth(thisFR, smoothiWin)/nRepsInStim;
                    timepoints = 1:1:numel(FRsmoothed);
                    timepoints_ms = timepoints/obj.Fs*1000;

                    hold on
                    plot(timepoints_ms, FRsmoothed+offset, 'color', repCols{p}, 'LineWidth', 1)
                    text(15, [offset], allSpkNames{o,p}, 'Interpreter', 'none');
                    offset = offset + .005;

                end

                axis tight
                ylim([0 offset+.005])
                %ylim([0 offset])
                xlabel('Time [ms]')
                ylabel('FR [Hz]')

                %% Print


                figure(figH)

                disp('Printing Plot')
                set(0, 'CurrentFigure', figH)

                descriptTitle = allSpkNames{o,1};
                descriptTitle_short = descriptTitle(end-7:end);

                FigSaveName = [HoldElDir descriptTitle_short '_v1_SpkClust' num2str(obj.SPKS.clustOfInterest)];
                %dropBoxSavePath = [obj.PATHS.dropboxPath obj.RS_INFO.expTextLabel '__' obj.PATHS.audStimDir '_' descriptTitle_short '_Raster_v1_SpkClust' num2str(obj.SPKS.clustOfInterest)];

                plotpos = [0 0 20 15];
                print_in_A4(0, FigSaveName, '-djpeg', 0, plotpos);
                %print_in_A4(0, dropBoxSavePath, '-djpeg', 0, plotpos);


            end

            disp('')


        end


        function [pos] = getAxPos(num_rows, num_cols, row, col)



            %LeftBuff = 0.001;
            LeftBuff = 0.01;
            %TopBuff = 0.005;
            TopBuff = 0.050;
            %spacer_buffer = 0.005;
            spacer_buffer = 0.0025;

            plot_height = (1-TopBuff*2-((num_rows-1)*spacer_buffer))/num_rows;
            plot_width = (1-LeftBuff*2-((num_cols-1)*spacer_buffer))/num_cols;

            %%
            if row ==1
                y_start = 1-(TopBuff+row*plot_height);
            else
                y_start = 1-(TopBuff+row*plot_height+(row-1)*spacer_buffer);
            end

            if col ==1
                x_start = LeftBuff;
            else
                x_start = LeftBuff+((col-1)*plot_width)+((col-1)*spacer_buffer);
            end

            pos = [x_start y_start plot_width plot_height];



        end



    end

    methods (Hidden)
        %class constructor
        function obj = chicken_OT_analysis_OBJ(efc, sc)

            %if nargin==0
            %    rsc=[];
            %elseif nargin>2
            %    disp('Object was not constructed since too many parameters were given at construction');
            %    return;
            %end
            INIT = InitVarsConfigClass();
            obj = getPathsAndDataDir(obj);
            obj = getSessionInfo(obj, efc, sc);
            %obj = getTriggerInfo(obj);
            %obj = getSpikesTimes(obj);
        end
    end

end
