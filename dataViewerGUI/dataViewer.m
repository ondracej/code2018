function k = dataViewer
% Call this to open the kilosort gui. 
dbstop if error

% add kilosort to path
if ~exist('dataViewerGUI', 'file')
    mfPath = mfilename('fullpath');
    addpath(genpath(fileparts(mfPath)));
end

f = figure(1029321); % ks uses some defined figure numbers for plotting - with this random number we don't clash
set(f,'Name', 'dataViewer',...
        'MenuBar', 'none',...
        'Toolbar', 'none',...
        'NumberTitle', 'off',...
        'Units', 'normalized',...
        'OuterPosition', [0.1 0.1 0.8 0.8]);
h = dataViewerGUI(f);

if nargout > 0
  k = h;
end

end

