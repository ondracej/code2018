function [colors, color_order] = getPlottingColors(ncols)
    
    if ncols ~= 1
        
        [colors, num_of_colors] = randColorList();
        
        if num_of_colors < ncols
            disp('Too few colors defined')
            keyboard
        end
        
        color_order = randperm(ncols);

    else
        colors = {'k'};
        color_order = 1;
    end
    
end

%% EOF