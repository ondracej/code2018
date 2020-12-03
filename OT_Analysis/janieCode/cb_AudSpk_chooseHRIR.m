function [] = cb_AudSpk_chooseHRIR(src, event, fH100)

index_selected = get(src, 'Value');
list = get(src, 'String');
turtleChosen = list{index_selected};

%% Make a UIcontrol for the path directory

thisDate = getappdata(fH100, 'thisDate');

default_path = getappdata(fH100, 'default_path');
dirD = getappdata(fH100, 'dirD');

default_turtle = 'xTURTLEx';

k = findstr(default_turtle, default_path);

%% New path with selected turtle
new_save_path = [default_path(1:k-1) turtleChosen dirD thisDate dirD];

%% Now make the directory textbox visible
cntrl_fig_size = getappdata(fH100, 'cntrl_fig_size');

uicontrol(fH100,'Style','text','Fontweight', 'bold', 'HorizontalAlignment', 'left', 'BackgroundColor', [.8 .8 .8], 'String','Save Path','Position',[150 cntrl_fig_size(4)*.90 150 20]);
savePathH = uicontrol(fH100,'Style','edit','String',new_save_path,'Position',[150 cntrl_fig_size(4)*.87 300 20], 'Tag', 'savePathH');
%set(savePathH,'Visible','on');
set(savePathH, 'Callback', {@cb_enter_new_data_directory, fH100})

%% Save Variables: currentTurtle currentSavePath
setappdata(fH100, 'currentTurtle', turtleChosen) %###
setappdata(fH100, 'currentSavePath', new_save_path) %###

end
