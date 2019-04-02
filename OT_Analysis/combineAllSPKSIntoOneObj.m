function [] = combineAllSPKSIntoOneObj()


PopulationDir = '/home/janie/Data/TUM/OTAnalysis/FinalPopulation_Janie/';
dirD = '/';

search_file = ['N*'];
dir_files = dir(fullfile(PopulationDir, search_file));
nDirs = numel(dir_files);

allDirNames = cell(1, nDirs);
for j = 1:nDirs
    allDirNames{j} = dir_files(j).name;
end

AllDataDir = '/home/janie/Data/TUM/OTAnalysis/AllSPKData/';

for k = 1:nDirs
    
    checkObjsDir = [PopulationDir dirD allDirNames{k} dirD 'Obj' dirD];
    
    search_file = ['*.mat'];
    mat_files = dir(fullfile(checkObjsDir, search_file));
    
    nMats = numel(mat_files);
    allMatNames = cell(1, nMats);
    for j = 1:nMats
        allMatNames{j} = mat_files(j).name;
    end
    
    %% Loading
    
    for o = 1:nMats
        
        thisMat = allMatNames{o};
        thisMatName = thisMat(1:3);
        
        switch thisMatName
            %% HRTF
            case '01-'
                
                disp('loading HRTF');
                d = load([checkObjsDir thisMat]);
                
                check = isfield(d.OBJS, 'dataSet2');
                
                if check
                    OBJ.BIRDINFO = d.OBJS.dataSet1.C_OBJ.INFO;
                    
                    OBJ.HRTF.SPKS.d1_clusterOfInterest = d.OBJS.dataSet1.C_OBJ.SPKS.clustOfInterest;
                    OBJ.HRTF.SPKS.d2_clusterOfInterest = d.OBJS.dataSet2.C_OBJ.SPKS.clustOfInterest;
                    
                    OBJ.HRTF.SPKS.d1_waveforms = d.OBJS.dataSet1.C_OBJ.SPKS.spikes.assigns;
                    OBJ.HRTF.SPKS.d2_waveforms = d.OBJS.dataSet2.C_OBJ.SPKS.spikes.assigns;
                    
                    OBJ.HRTF.SPKS.d1_assigns = d.OBJS.dataSet1.C_OBJ.SPKS.spikes.waveforms;
                    OBJ.HRTF.SPKS.d2_assigns = d.OBJS.dataSet2.C_OBJ.SPKS.spikes.waveforms;
                    
                    OBJ.HRTF.SPKS.d1_spiketimes = d.OBJS.dataSet1.C_OBJ.SPKS.spikes.spiketimes;
                    OBJ.HRTF.SPKS.d2_spiketimes = d.OBJS.dataSet2.C_OBJ.SPKS.spikes.spiketimes;
                    
                    OBJ.HRTF.SPKS.d1_spkParams = d.OBJS.dataSet1.C_OBJ.SPKS.spikes.params;
                    OBJ.HRTF.SPKS.d2_spkParams = d.OBJS.dataSet2.C_OBJ.SPKS.spikes.params;
                    
                    
                else
                    OBJ.BIRDINFO = d.OBJS.dataSet1.C_OBJ.INFO;
                    
                    OBJ.HRTF.SPKS.d1_clusterOfInterest = d.OBJS.dataSet1.C_OBJ.SPKS.clustOfInterest;
                    OBJ.HRTF.SPKS.d1_assigns = d.OBJS.dataSet1.C_OBJ.SPKS.spikes.assigns;
                    OBJ.HRTF.SPKS.d1_waveforms = d.OBJS.dataSet1.C_OBJ.SPKS.spikes.waveforms;
                    OBJ.HRTF.SPKS.d1_spiketimes = d.OBJS.dataSet1.C_OBJ.SPKS.spikes.spiketimes;
                    OBJ.HRTF.SPKS.d1_spkParams = d.OBJS.dataSet1.C_OBJ.SPKS.spikes.params;
                end
                
                %% IID
            case '03-'
                
                disp('loading IID');
                d = load([checkObjsDir thisMat]);
                
                check = isfield(d, 'C_OBJ'); % Mostly will be C_OBJS since we dont combine...
                
                if check
                    OBJ.BIRDINFO = d.C_OBJ.INFO;
                    
                    OBJ.IID.SPKS.d1_clusterOfInterest = d.C_OBJ.SPKS.clustOfInterest;
                    OBJ.IID.SPKS.d1_waveforms = d.C_OBJ.SPKS.spikes.assigns;
                    OBJ.IID.SPKS.d1_assigns = d.C_OBJ.SPKS.spikes.waveforms;
                    OBJ.IID.SPKS.d1_spiketimes = d.C_OBJ.SPKS.spikes.spiketimes;
                    OBJ.IID.SPKS.d1_spkParams = d.C_OBJ.SPKS.spikes.params;
                    
                else
                    
                    OBJ.BIRDINFO = d.OBJS.dataSet1.C_OBJ.INFO;
                    
                    OBJ.IID.SPKS.d1_clusterOfInterest = d.OBJS.dataSet1.C_OBJ.SPKS.clustOfInterest;
                    OBJ.IID.SPKS.d1_assigns = d.OBJS.dataSet1.C_OBJ.SPKS.spikes.assigns;
                    OBJ.IID.SPKS.d1_waveforms = d.OBJS.dataSet1.C_OBJ.SPKS.spikes.waveforms;
                    OBJ.IID.SPKS.d1_spiketimes = d.OBJS.dataSet1.C_OBJ.SPKS.spikes.spiketimes;
                    OBJ.IID.SPKS.d1_spkParams = d.OBJS.dataSet1.C_OBJ.SPKS.spikes.params;
                    
                end
                %% ITD
            case '04-'
                disp('loading ITD');
                d = load([checkObjsDir thisMat]);
                
                check = isfield(d, 'C_OBJ');
                
                if check
                    OBJ.BIRDINFO = d.C_OBJ.INFO;
                    
                    OBJ.ITD.SPKS.d1_clusterOfInterest = d.C_OBJ.SPKS.clustOfInterest;
                    OBJ.ITD.SPKS.d1_assigns = d.C_OBJ.SPKS.spikes.assigns;
                    OBJ.ITD.SPKS.d1_waveforms = d.C_OBJ.SPKS.spikes.waveforms;
                    OBJ.ITD.SPKS.d1_spiketimes = d.C_OBJ.SPKS.spikes.spiketimes;
                    OBJ.ITD.SPKS.d1_spkParams = d.C_OBJ.SPKS.spikes.params;
                    
                    
                else
                    
                    OBJ.BIRDINFO = d.OBJS.dataSet1.C_OBJ.INFO;
                    
                    OBJ.ITD.SPKS.d1_clusterOfInterest = d.OBJS.dataSet1.C_OBJ.SPKS.clustOfInterest;
                    OBJ.ITD.SPKS.d1_assigns = d.OBJS.dataSet1.C_OBJ.SPKS.spikes.assigns;
                    OBJ.ITD.SPKS.d1_waveforms = d.OBJS.dataSet1.C_OBJ.SPKS.spikes.waveforms;
                    OBJ.ITD.SPKS.d1_spiketimes = d.OBJS.dataSet1.C_OBJ.SPKS.spikes.spiketimes;
                    OBJ.ITD.SPKS.d1_spkParams = d.OBJS.dataSet1.C_OBJ.SPKS.spikes.params;
                    
                end
                %% WN
            case '05-'
                disp('loading WN');
                d = load([checkObjsDir thisMat]);
                
                check = isfield(d, 'C_OBJ');
                
                if check
                    OBJ.BIRDINFO = d.C_OBJ.INFO;
                    
                    OBJ.WN.SPKS.d1_clusterOfInterest = d.C_OBJ.SPKS.clustOfInterest;
                    OBJ.WN.SPKS.d1_assigns = d.C_OBJ.SPKS.spikes.assigns;
                    OBJ.WN.SPKS.d1_waveforms = d.C_OBJ.SPKS.spikes.waveforms;
                    OBJ.WN.SPKS.d1_spiketimes = d.C_OBJ.SPKS.spikes.spiketimes;
                    OBJ.WN.SPKS.d1_spkParams = d.C_OBJ.SPKS.spikes.params;
                    
                else % 
                    
                    checkDatasets = isfield(d.OBJS, 'dataSet2');
                    
                    if checkDatasets
                        OBJ.BIRDINFO = d.OBJS.dataSet1.C_OBJ.INFO;
                        
                        OBJ.WN.SPKS.d1_clusterOfInterest = d.OBJS.dataSet1.C_OBJ.SPKS.clustOfInterest;
                        OBJ.WN.SPKS.d2_clusterOfInterest = d.OBJS.dataSet2.C_OBJ.SPKS.clustOfInterest;
                        
                        OBJ.WN.SPKS.d1_waveforms = d.OBJS.dataSet1.C_OBJ.SPKS.spikes.assigns;
                        OBJ.WN.SPKS.d2_waveforms = d.OBJS.dataSet2.C_OBJ.SPKS.spikes.assigns;
                        
                        OBJ.WN.SPKS.d1_assigns = d.OBJS.dataSet1.C_OBJ.SPKS.spikes.waveforms;
                        OBJ.WN.SPKS.d2_assigns = d.OBJS.dataSet2.C_OBJ.SPKS.spikes.waveforms;
                        
                        OBJ.WN.SPKS.d1_spiketimes = d.OBJS.dataSet1.C_OBJ.SPKS.spikes.spiketimes;
                        OBJ.WN.SPKS.d2_spiketimes = d.OBJS.dataSet2.C_OBJ.SPKS.spikes.spiketimes;
                        
                        OBJ.WN.SPKS.d1_spkParams = d.OBJS.dataSet1.C_OBJ.SPKS.spikes.params;
                        OBJ.WN.SPKS.d2_spkParams = d.OBJS.dataSet2.C_OBJ.SPKS.spikes.params;
                        
                    else
                        OBJ.BIRDINFO = d.OBJS.dataSet1.C_OBJ.INFO;
                        
                        OBJ.WN.SPKS.d1_clusterOfInterest = d.OBJS.dataSet1.C_OBJ.SPKS.clustOfInterest;
                        OBJ.WN.SPKS.d1_waveforms = d.OBJS.dataSet1.C_OBJ.SPKS.spikes.assigns;
                        OBJ.WN.SPKS.d1_assigns = d.OBJS.dataSet1.C_OBJ.SPKS.spikes.waveforms;
                        OBJ.WN.SPKS.d1_spiketimes = d.OBJS.dataSet1.C_OBJ.SPKS.spikes.spiketimes;
                        OBJ.WN.SPKS.d1_spkParams = d.OBJS.dataSet1.C_OBJ.SPKS.spikes.params;
                        
                    end
                    
                end
                
            otherwise
                keyboard
        end
        
    end
    
    if exist('OBJ')
        saveName = [allDirNames{k} '-AllSPKS.mat'];
        disp('')
        save([AllDataDir saveName], 'OBJ', '-v7.3')
        
        clear('OBJ', 'd')
    end
end