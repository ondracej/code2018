

function [pos] = getAxPos(num_rows, num_cols, row, col)



LeftBuff = 0.001;
%TopBuff = 0.005;
TopBuff = 0.050;
%spacer_buffer = 0.005;
spacer_buffer = 0.0025;

plot_height = (1-TopBuff*2-((num_rows-1)*spacer_buffer))/num_rows;
plot_width = (1-LeftBuff*2-((num_cols-1)*spacer_buffer))/num_cols;

%%
if row ==1
    y_start = 1-(TopBuff+row*plot_height);
else
    y_start = 1-(TopBuff+row*plot_height+(row-1)*spacer_buffer);
end

if col ==1
    x_start = LeftBuff;
else
    x_start = LeftBuff+((col-1)*plot_width)+((col-1)*spacer_buffer);
end

pos = [x_start y_start plot_width plot_height];



end
