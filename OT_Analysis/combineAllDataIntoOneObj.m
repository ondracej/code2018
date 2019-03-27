function [] = combineAllDataIntoOneObj(HRTFObjPath, WNObjPath, ITDObjPath, IIDObjPath)


if ~isempty(HRTFObjPath)
    HRTFObj = load(HRTFObjPath);
else
    HRTFObj = [];
end

if ~isempty(WNObjPath)
    WNObj = load(WNObjPath);
else
    WNObj = [];
end

if ~isempty(ITDObjPath)
    ITDObj = load(ITDObjPath);
else
    ITDObj = [];
end

if ~isempty(IIDObj)
    IIDObj = load(IIDObjPath);
else
    IIDObj = [];
end


disp('')


















end