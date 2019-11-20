% ----------------------------------------------------------------------
% Tool script for creating an XML file for AudioSpike from a MATLAB /
% Octave structure
% 
%           Copyright HoerTech gGmbH 2017
% ----------------------------------------------------------------------

function audiospike_createmeas(config, filename)
% This script converts a MATLAB struct to a AudioSpike XML-file

% try to create XML in MATLAB. On exception create it in Octave using
% Xerces
try
    docNode = com.mathworks.xml.XMLUtils.createDocument('AudioSpike');
    xDoc = docNode.getDocumentElement;
catch
    [folder, name, ext] = fileparts(mfilename('fullpath'));
    javaaddpath([folder '\xerces-2_11_0\xercesImpl.jar']);
    javaaddpath([folder '\xerces-2_11_0\xml-apis.jar']);
    docNode = javaObject('org.apache.xerces.dom.DocumentImpl');
    xDoc = docNode.createElement('AudioSpike');
    docNode.appendChild(xDoc);
end


if isfield(config, 'Settings')
    node = docNode.createElement('Settings');
    xDoc.appendChild(node);
    AddXMLValues(docNode, node, config.Settings);
end

if isfield(config, 'Parameters')
    node = docNode.createElement('Parameters');
    xDoc.appendChild(node);
    for param = 1:length(config.Parameters)
        subNode = docNode.createElement('Parameter');
        node.appendChild(subNode);
        AddXMLValues(docNode, subNode, config.Parameters(param));
    end
end

if isfield(config, 'Stimuli')
    node = docNode.createElement('Stimuli');
    xDoc.appendChild(node);
    for stim = 1:length(config.Stimuli)
        subNode = docNode.createElement('Stimulus');
        node.appendChild(subNode);
        AddXMLValues(docNode, subNode, config.Stimuli(stim), config);
    end
end

if isfield(config, 'Cluster')
    node = docNode.createElement('Result');
    xDoc.appendChild(node);
    subNode = docNode.createElement('Clusters');
    node.appendChild(subNode);
    for param = 1:length(config.Cluster)
        subsubNode = docNode.createElement('Cluster');
        subNode.appendChild(subsubNode);
        AddXMLValues(docNode, subsubNode, config.Cluster(param));
    end
end

% write XML in MATLAB/Octave
if 0 == exist('xmlwrite')
    xmlwrite_octave(filename, docNode);
else
    xmlwrite(filename, docNode);
end

end

% subfunction adding values froma struct to XML node
function AddXMLValues(docNode, subNode, theStruct, config)
names = fieldnames(theStruct);
for field = 1:length(names)
    name = names(field);
    % if name is 'data', then 'filename' is mandatory: then we save
    % data as wave file to filename and remove data from struct
    if strcmp(name, 'Data')
        if 0 == exist('audiowrite')
            wavwrite(theStruct.Data, config.Settings.SampleRate, 32, theStruct.FileName);
        else
            audiowrite(theStruct.FileName, theStruct.Data, config.Settings.SampleRate, 'BitsPerSample', 32);
        end
    else
        node = docNode.createElement(char(name));
        value = getfield(theStruct, char(name));
        if ~isempty(value)
            if (~ischar(value))
                value = mat2str(value);
            end
            node.appendChild(docNode.createTextNode(char(value)));
            subNode.appendChild(node);
        end
    end
end

end