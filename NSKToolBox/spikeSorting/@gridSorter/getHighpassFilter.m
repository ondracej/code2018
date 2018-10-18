function obj=getHighpassFilter(obj)
%calculate the highpass filter for sorting
if isempty(obj.dataRecordingObj)
    %answer = inputdlg(prompt,dlg_title)
    disp('No data recorded object exists, either add object or enter sampling freq. in gridSorter.dataRecordingObj.samplingFrequency');
else
    obj.filterObj=filterData(obj.dataRecordingObj.samplingFrequency);
    obj.filterObj.highPassPassCutoff=obj.filterHighPassPassCutoff;
    obj.filterObj.highPassStopCutoff=obj.filterHighPassStopCutoff;
    obj.filterObj.lowPassPassCutoff=obj.filterLowPassPassCutoff;
    obj.filterObj.lowPassStopCutoff=obj.filterLowPassStopCutoff;
    obj.filterObj.attenuationInHighpass=obj.filterAttenuationInHighpass;
    obj.filterObj.attenuationInLowpass=obj.filterAttenuationInLowpass;
    obj.filterObj.filterDesign=obj.filterDesign;
    obj.filterRippleInPassband=obj.filterRippleInPassband;
    
    %obj.filterObj.highPassCutoff=obj.filterHighPassPassCutoff;
    %obj.filterObj.lowPassCutoff=obj.filterLowPassPassCutoff;
    %obj.filterObj.filterOrder=8;
    
    obj.filterObj=obj.filterObj.designBandPass;
end
end