function [] = combineAllDataWrapper()



HRTFObjPath = [];
WNObjPath = '/home/janie/LRZ Sync+Share/OT_Analysis/OTAnalysis/allWNsJanie/allObjs/UncombinedData]/05-WNSeach_20171214_131951_0001--E1-Rs3-Single.mat';
ITDObjPath = '/home/janie/LRZ Sync+Share/OT_Analysis/OTAnalysis/CombinedDataSets_JanieFeb/Data/01-HRTF_20171214_132223_0001--E1-Rs3-Single.mat';
IIDObjPath = [];

combineAllDataIntoOneObj(HRTFObjPath, WNObjPath, ITDObjPath, IIDObjPath)


end