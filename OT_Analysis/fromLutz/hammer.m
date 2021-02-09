function [tx,ty] = hammer(az,el)
[az,el]=meshgrid(az,el);
[tx,ty]=pr_hammer(deg2rad(az),deg2rad(el));
end

