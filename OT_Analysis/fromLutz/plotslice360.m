function C = plotslice360(slice,tx,ty,levelstep,linestyle,levels)

if isempty(tx)&&isempty(ty)
    [az el]=meshgrid([-180:5.625:180],[-73.125:5.625:73.125]);
    az=deg2rad(az);el=deg2rad(el);
    [tx ty] = pr_hammer(az,el,1);
end

hold on;
[C h]=contourf(tx,ty,slice,linspace(levelstep(1), levelstep(2), 21),'ShowText','off', 'LineWidth',1,'linestyle',linestyle);
caxis(levelstep)
axis equal
% axis off;
set(gcf,'color','w');
[az el]=meshgrid([-180:30:180],[-73.125:5.625:73.125]);
az=deg2rad(az);el=deg2rad(el);
[txx tyy] = pr_hammer(az,el,1);
txx=rad2deg(txx);tyy=rad2deg(tyy);
plot(txx,tyy,':k'); % plots Hammerprojection lines
[az el]=meshgrid([-180:5.625:180],[-60:30:60]);
az=deg2rad(az);el=deg2rad(el);
[txx tyy] = pr_hammer(az,el,1);
txx=rad2deg(txx);tyy=rad2deg(tyy);
plot(txx',tyy',':k'); % plots Hammerprojection lines
hold off;
% axis tight

for X = levels
   hold on
   C = contour(tx,ty,slice,'LevelList',X);
   C(C>1.5)=NaN;
   plot(C(1,1:end)',C(2,1:end),'k-','linewidth',2,'color',[0 0 1]);
   hold off
end

end
