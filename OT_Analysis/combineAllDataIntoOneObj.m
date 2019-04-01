function [] = combineAllDataIntoOneObj()


PopulationDir = '/home/janie/LRZ Sync+Share/OT_Analysis/OTAnalysis/FinalPopulation_Janie';
dirD = '/';

search_file = ['N*'];
dir_files = dir(fullfile(PopulationDir, search_file));
nDirs = numel(dir_files);

allDirNames = cell(1, nDirs);
for j = 1:nDirs
    allDirNames{j} = dir_files(j).name;
end

AllDataDir = '/home/janie/LRZ Sync+Share/OT_Analysis/OTAnalysis/AllData/';

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
                
                check = isfield(d, 'combinedSPKS');
                
                if check
                    OBJ.BIRDINFO = d.OBJS.dataSet1.C_OBJ.INFO;
                    
                    OBJ.HRTF.combinedSPKS = d.combinedSPKS;
                    OBJ.HRTF.stimNames = d.OBJS.dataSet1.C_OBJ.S_SPKS.SORT.allSpksStimNames;
                    OBJ.HRTF.stimInfo = d.OBJS.dataSet1.C_OBJ.S_SPKS.INFO;
                    
                else
                    keyboard
                end
                
                %% IID
            case '03-'
                
                disp('loading IID');
                d = load([checkObjsDir thisMat]);
                
                check = isfield(d, 'combinedSPKS');
                
                if check
                    OBJ.BIRDINFO = d.OBJS.dataSet1.C_OBJ.INFO;
                    
                    OBJ.IID.combinedSPKS = d.combinedSPKS;
                    OBJ.IID.stimNames = d.OBJS.dataSet1.C_OBJ.S_SPKS.SORT.allSpksStimNames;
                    OBJ.IID.stimInfo = d.OBJS.dataSet1.C_OBJ.S_SPKS.INFO;
                    
                else
                    
                    OBJ.BIRDINFO = d.C_OBJ.INFO;
                    
                    OBJ.IID.combinedSPKS = d.C_OBJ.S_SPKS.SORT.allSpksMatrix;
                    OBJ.IID.stimNames = d.C_OBJ.S_SPKS.SORT.allSpksStimNames;
                    OBJ.IID.stimInfo = d.C_OBJ.S_SPKS.INFO;
                    
                end
                %% ITD
            case '04-'
                disp('loading ITD');
                d = load([checkObjsDir thisMat]);
                
                check = isfield(d, 'combinedSPKS');
                
                if check
                    OBJ.BIRDINFO = d.OBJS.dataSet1.C_OBJ.INFO;
                    
                    OBJ.ITD.combinedSPKS = d.combinedSPKS;
                    OBJ.ITD.stimNames = d.OBJS.dataSet1.C_OBJ.S_SPKS.SORT.allSpksStimNames;
                    OBJ.ITD.stimInfo = d.OBJS.dataSet1.C_OBJ.S_SPKS.INFO;
                    
                else
                    
                    OBJ.BIRDINFO = d.C_OBJ.INFO;
                    
                    OBJ.ITD.combinedSPKS = d.C_OBJ.S_SPKS.SORT.allSpksMatrix;
                    OBJ.ITD.stimNames = d.C_OBJ.S_SPKS.SORT.allSpksStimNames;
                    OBJ.ITD.stimInfo = d.C_OBJ.S_SPKS.INFO;
                
                end
                %% WN
            case '05-'
                disp('loading WN');
                d = load([checkObjsDir thisMat]);
                
                check = isfield(d, 'combinedSPKS');
                
                if check
                    OBJ.BIRDINFO = d.OBJS.dataSet1.C_OBJ.INFO;
                    
                    OBJ.WN.combinedSPKS = d.combinedSPKS;
                    OBJ.WN.stimNames = d.OBJS.dataSet1.C_OBJ.S_SPKS.SORT.allSpksStimNames;
                    OBJ.WN.stimInfo = d.OBJS.dataSet1.C_OBJ.S_SPKS.INFO;
                
                else
                    
                    OBJ.BIRDINFO = d.C_OBJ.INFO;
                    
                    OBJ.WN.combinedSPKS = d.C_OBJ.S_SPKS.SORT.allSpksMatrix;
                    OBJ.WN.stimNames = d.C_OBJ.S_SPKS.SORT.allSpksStimNames;
                    OBJ.WN.stimInfo = d.C_OBJ.S_SPKS.INFO;
                
                end
                
            otherwise
                keyboard
        end
        
    end
    
    saveName = [allDirNames{k} '-AllStims.mat'];
    disp('')
    save([AllDataDir saveName], 'OBJ', '-v7.3')
    
    
    
end