function [] = plotAudSpatRFs(FigH, dataToPlot, plotPos, ifScale, titleTxt, clims)

%maxArrayVal = 50;
figure(FigH)

subplot(2, 6, plotPos)
surf(dataToPlot);
shading interp
view([ 0 90])
axis tight

if ifScale
    cScale = [round(clims(1)) round(clims(2))];
    cscale_txt = ['-clim: ' num2str(round(clims(1))) num2str(round(clims(2)))];
    caxis(cScale)
else
  cscale_txt = 'tight';
    
    
end

title([titleTxt cscale_txt])
set(gca,'ytick',[])
set(gca,'xtick',[])
xlabel('Azimuth')
ylabel('Elevation')

end
