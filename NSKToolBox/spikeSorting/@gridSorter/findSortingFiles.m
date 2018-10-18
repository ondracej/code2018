function obj=findSortingFiles(obj)
%locate spike sorting related files from the same recording to determine which step were already done
%check conditions for recalculating the different stages of spike sorting. Notice that for the 3 first procedures only, calcululation of a subset of uncalculated channels is possiblee
obj.sortingFileNames=[];
for i=1:obj.nCh
    obj.sortingFileNames.spikeDetectionFile{i}=[obj.sortingDir filesep 'ch_' num2str(obj.chPar.s2r(i)) '_spikeDetection.mat'];
    obj.sortingFileNames.spikeDetectionExist(i)=exist(obj.sortingFileNames.spikeDetectionFile{i},'file');
    
    obj.sortingFileNames.featureExtractionFile{i}=[obj.sortingDir filesep 'ch_' num2str(obj.chPar.s2r(i)) '_featureExtraction.mat'];
    obj.sortingFileNames.featureExtractionExist(i)=exist(obj.sortingFileNames.featureExtractionFile{i},'file');
    
    obj.sortingFileNames.clusteringFile{i}=[obj.sortingDir filesep 'ch_' num2str(obj.chPar.s2r(i)) '_clustering.mat'];
    obj.sortingFileNames.clusteringExist(i)=exist(obj.sortingFileNames.clusteringFile{i},'file');
end

obj.sortingFileNames.avgWaveformFile=[obj.sortingDir filesep 'AllClusteredWaveforms.mat'];

obj.sortingFileNames.mergedAvgWaveformFile=[obj.sortingDir filesep 'AllMergedWaveforms.mat'];
obj.sortingFileNames.mergedAvgWaveformExist=exist(obj.sortingFileNames.mergedAvgWaveformFile,'file');

obj.sortingFileNames.fittingFile=[obj.sortingDir filesep 'spikeSorting.mat'];
obj.sortingFileNames.fittingExist=exist(obj.sortingFileNames.fittingFile,'file');

obj.sortingFileNames.postProcessingAnalysisFile=[obj.sortingDir filesep 'postProcessingAnalysis.mat'];
obj.sortingFileNames.postProcessingAnalysisExist=exist(obj.sortingFileNames.postProcessingAnalysisFile,'file');
if obj.sortingFileNames.postProcessingAnalysisExist %check if part of the units were already processed in a previous run
    tmp=load(obj.sortingFileNames.postProcessingAnalysisFile,'postProcessingAnalysisExist');
    obj.sortingFileNames.postProcessingAnalysisExist=tmp.postProcessingAnalysisExist;
end

obj.sortingFileNames.assessQualityFile=[obj.sortingDir filesep 'errorEstimates.mat'];
obj.sortingFileNames.assessQualityExist=exist(obj.sortingFileNames.fittingFile,'file');
