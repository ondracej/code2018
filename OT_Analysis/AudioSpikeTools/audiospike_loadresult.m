% ----------------------------------------------------------------------
% Tool script for loading an result XML file created by AudioSpike into 
% the  MATLAB / Octave workspace. It loads all raw spikes as well and
% optionally the raw recorded epoche data
% 
%           Copyright HoerTech gGmbH 2017
% ----------------------------------------------------------------------
function AudioSpike = audiospike_loadresult(filename, loadepoches)
% This script loads a AduioSpike XML-Result into a MATLAB/Octave struct

% default: do NOT load binary epoche data
if (nargin < 2)
    loadepoches = 0;
end

% check file existance
if exist(filename, 'file') ~= 2
    error('XML file %s not found' ,filename);
end

% read XML file (MATLAB or Octave)
if 0 == exist('xmlread')
   xDoc = xmlread_octave(filename);
else
   xDoc = xmlread(filename);
end

% root node must be named 'AudioSpike'
childNodes = xDoc.getChildNodes.getElementsByTagName('AudioSpike');
if (childNodes.getLength ~= 1)
    error('XML file %s is not a valid AudioSpike-XML file.', filename);
end
xDoc = childNodes.item(0);

% 'Result' subnode must be present
childNodes = xDoc.getChildNodes.getElementsByTagName('Result');
resultNode = childNodes.item(0);


% Settings
childNodes = xDoc.getChildNodes.getElementsByTagName('Settings');
AudioSpike.Settings = NodeValuesToStruct(childNodes.item(0));

% Parameters
childNodes = xDoc.getChildNodes.getElementsByTagName('Parameters');
if (childNodes.getLength < 1)
    error('Parameters not found in file');
end
AudioSpike.Parameters = NodeToStruct(childNodes.item(0));

% Stimuli
childNodes = xDoc.getChildNodes.getElementsByTagName('StimulusSequence');
if (childNodes.getLength ~= 1)
    error('StimulusSequence not found');
end
StimSequence = str2num(char(childNodes.item(0).getTextContent));
AudioSpike = setfield(AudioSpike, 'StimulusSequence', StimSequence);

childNodes = xDoc.getChildNodes.getElementsByTagName('AllStimuli');
if (childNodes.getLength < 1)
    error('Stimuli not found in file');
end
AudioSpike.Stimuli = NodeToStruct(childNodes.item(0));


% Spikes
cnSpikes            = xDoc.getChildNodes.getElementsByTagName('Spikes');
cnNonSelectedSpikes = xDoc.getChildNodes.getElementsByTagName('NonSelectedSpikes');

if (cnSpikes.getLength ~= 1 && cnNonSelectedSpikes.getLength ~= 1)
    error('Spikes not found in file');
end
AudioSpike.Spikes = NodeToStruct(cnSpikes.item(0));
AudioSpike.NonSelectedSpikes = NodeToStruct(cnNonSelectedSpikes.item(0));


% Epoches
% load binary epoche data
epoches = [];
if (loadepoches)
    path = fileparts(filename);
    if (length(path))
        epochefile = [path '/epoches.pcm'];
    else
        epochefile = 'epoches.pcm';
    end
    if exist(epochefile, 'file') ~= 2
        error('epoche file %s not found', epochefile);
    end

    fid = fopen(epochefile, 'r');
    epoches.data = fread(fid, 'float');
    fclose(fid);
    epoches.channels = length(AudioSpike.Settings.InputChannels);
    epoches.length   = AudioSpike.Settings.EpocheLengthSamples;
    epoches.count    = length(epoches.data) / epoches.length / epoches.channels;
end

childNodes = xDoc.getChildNodes.getElementsByTagName('Epoches');
if (childNodes.getLength < 1)
    error('Epoches not found in file');
end
AudioSpike.Epoches = NodeToStruct(childNodes.item(0), epoches);

end

% -------------------------------------------------------------------------
% function to parse subnodes into struct including binary epoche data
function theStruct = NodeToStruct(theNode, epoches)
if (nargin < 2)
    epoches = [];
end
epochePosition = 1;

theStruct = [];
subNodes =  theNode.getChildNodes;
% loop through children (e.g. multiple 'Spike' subnodes within 'Spikes' node
% NOTE: XML may contain '#text' nodes to be ignored, thus we count
% separately
nodeIndex = 0;
epocheWarning_displayed = 0;

% count number of epoches that we will expect
expectedepoches = 0;
if (~isempty(epoches))
    for allNodesIndex = 1:subNodes.getLength
        subNode = subNodes.item(allNodesIndex-1);
        if strcmpi(subNode.getNodeName, '#text')
            continue;
        end
        expectedepoches = expectedepoches+1;
    end
end

for allNodesIndex = 1:subNodes.getLength
    subNode = subNodes.item(allNodesIndex-1);
    if strcmpi(subNode.getNodeName, '#text')
        continue;
    end
    nodeIndex = nodeIndex + 1;
    childNodes = subNode.getChildNodes;
    for parIndex = 0:childNodes.getLength-1
        childsubNode = childNodes.item(parIndex);
        if strcmpi(childsubNode.getNodeName, '#text')
            continue;
        end
        % special handling if node name is called 'Data': then it contains
        % base64 encoded binary data!
        if strcmpi(childsubNode.getNodeName, 'Data')
            % convert base64 encodes spike to MATLAB array
            binData = typecast(base64decode(char(childsubNode.getTextContent), '', 'matlab'),'double');
            theStruct = setfield(theStruct, {nodeIndex}, char(childsubNode.getNodeName), binData);
        else
            content = char(childsubNode.getTextContent);
            % try to convert text to numerical value
            if strcmpi(content, 'db')
                numcontent = [];
            else
                numcontent = str2num(content);
            end
            if (isempty(numcontent))
                theStruct = setfield(theStruct, {nodeIndex}, char(childsubNode.getNodeName), content);
            else
                theStruct = setfield(theStruct, {nodeIndex}, char(childsubNode.getNodeName), numcontent);
            end
        end
    end
    % add binary epoche data
    if (~isempty(epoches))
        if nodeIndex > epoches.count
            if epocheWarning_displayed == 0
                disp(['epoche binary file contains only ' num2str(epoches.count) ' epoches, but ' num2str(expectedepoches) ' were expected. Ignoring higher indices ...']);
            end
            epocheWarning_displayed = 1;
        else
            binData = [];
            for channel = 1:epoches.channels
                binData = [binData epoches.data(epochePosition:epochePosition+epoches.length-1)];
                epochePosition = epochePosition+epoches.length;
            end
            theStruct = setfield(theStruct, {nodeIndex}, 'Data', binData);
        end
    end
end

end

% -------------------------------------------------------------------------
% function to parse values from one nodes into struct (used for 'Settings')
function theStruct = NodeValuesToStruct(theNode)
theStruct = [];
childNodes = theNode.getChildNodes;
for parIndex = 0:childNodes.getLength-1
    theChildNode = childNodes.item(parIndex);
    if strcmpi(theChildNode.getNodeName, '#text')
        continue;
    end
    content = char(theChildNode.getTextContent);
    % try to convert text to numerical value
    % special
    if strcmpi(content, 'db')
        numcontent = [];
    else
        numcontent = str2num(content);
    end
    if (isempty(numcontent))
        theStruct = setfield(theStruct, char(theChildNode.getNodeName), content);
    else
        theStruct = setfield(theStruct, char(theChildNode.getNodeName), numcontent);
    end
end
end


