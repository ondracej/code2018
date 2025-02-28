

figDir = '/home/janie/Dropbox/Writing/00_Articles/0_HamedsPaper/FinalSubmission/submissionSciRep/Figs_forReview/Supplementary-SleepArchitecture/';

OrigFigName = '/home/janie/Dropbox/Writing/00_Articles/0_HamedsPaper/FinalSubmission/submissionSciRep/Figs_forReview/.fig';
%FigName = '2aadult';
FigName = 'summary-sleepsegments';
%FigName = 'Fig1MedianSleepDepthWithErrorBarBasedAge';is w

openfig(OrigFigName)

 saveName = [figDir FigName];

%plotpos = [0 0 12 8]; %Fig 1 % replay renditions
%plotpos = [0 0 10 6]; %Fig 1 % replay renditions
%plotpos = [0 0 25 8]; %Fig 1 % replay renditions
 %plotpos = [0 0 8 10]; %Fig 2
 %plotpos = [0 0 14 6]; %Fig 2
% plotpos = [0 0 8 6]; %Fig 2
% plotpos = [0 0 40 25]; %Fig 2
% plotpos = [0 0 20 18]; %Fig 2
 plotpos = [0 0 15 18]; %Fig 2
 
%  figure(302)
% subplot(4,2,[1 2]); cla
% subplot(4,2,[3 4]); cla
% subplot(4,2,[5 6]); cla
 
  %saveName  = 'Z:\HamedData\CorrelationPaper\CurrentDraftMarch2022\Current Figs\Fig. 1\';
 
  
  %plotpos = [0 0 25 15]; %Fig 2
  
 print_in_A4(0, saveName, '-djpeg', 0, plotpos);
 print_in_A4(0, saveName, '-depsc', 3, plotpos);
 
 
 %%

 h = gcf; %current figure handle

axesObjs = get(h, 'Children');  %axes handles
dataObjs = get(axesObjs, 'Children'); %handles t

%% 

h = gca; % get the handle of the current axes
hPlot = h.Children; % The children of the axes should be the plot line
XData = hPlot.XData; 
YData = hPlot.YData;

h = findobj(gcf,'tag','Outliers');


%%
clear all
h = gcf; %current figure handle

axesObjs = get(h, 'Children');  %axes handles
dataObjs = get(axesObjs, 'Children'); %handles t


h = gca; % get the handle of the current axes
hPlot = h.Children; % The children of the axes should be the plot line
gammaY_g4r4 = hPlot.YData;
gammaX_g4r4 = hPlot.XData;

h = gca; % get the handle of the current axes
hPlot = h.Children; % The children of the axes should be the plot line
betaY_g4r4 = hPlot.YData;
betaX_g4r4 = hPlot.XData;

h = gca; % get the handle of the current axes
hPlot = h.Children; % The children of the axes should be the plot line
deltaY_g4r4 = hPlot.YData;
deltaX_g4r4 = hPlot.XData;

std(gammaY_g4r4)/sqrt(numel(gammaY_g4r4))

totest = [deltaY_g4r4 ; betaY_g4r4 ; gammaY_g4r4]';

[p,tbl,stats] = anova1(totest);
[c,~,~,gnames] = multcompare(stats);

p = anova1(totest);
[p, h] = ranksum(betaY_g4r4, deltaY_g4r4)


%%
h = gca; % get the handle of the current axes
hPlot = h.Children; % The children of the axes should be the plot line
gammaY_j8v8 = hPlot.YData;
gammaX_j8v8 = hPlot.XData;

h = gca; % get the handle of the current axes
hPlot = h.Children; % The children of the axes should be the plot line
betaY_j8v8 = hPlot.YData;
betaX_j8v8 = hPlot.XData;

h = gca; % get the handle of the current axes
hPlot = h.Children; % The children of the axes should be the plot line
deltaY_j8v8 = hPlot.YData;
deltaX_j8v8 = hPlot.XData;

totest = [deltaY_j8v8 ; betaY_j8v8 ; gammaY_j8v8]';

std(gammaY_j8v8)/sqrt(numel(gammaY_j8v8))



[p,tbl,stats] = anova1(totest);
[c,m,h,gnames] = multcompare(stats);
[results,~,~,gnames] = multcompare(stats);


tbl = array2table(c,"VariableNames", ...
    ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"]);
p = anova1(totest);
[p, h] = ranksum(betaY_g4r4, deltaY_g4r4)
%%

h = gca; % get the handle of the current axes
hPlot = h.Children; % The children of the axes should be the plot line
gammaY_r5n5 = hPlot.YData;
gammaX_r5n5 = hPlot.XData;

h = gca; % get the handle of the current axes
hPlot = h.Children; % The children of the axes should be the plot line
betaY_r5n5 = hPlot.YData;
betaX_r5n5 = hPlot.XData;

h = gca; % get the handle of the current axes
hPlot = h.Children; % The children of the axes should be the plot line
deltaY_r5n5 = hPlot.YData;
deltaX_r5n5 = hPlot.XData;

bla = median(deltaY_r5n5)
std(gammaY_r5n5)/sqrt(numel(gammaY_r5n5))

totest = [deltaY_r5n5 ; betaY_r5n5 ; gammaY_r5n5]';
[p,tbl,stats] = anova1(totest);

%%
g4r4_X_DOS = get(dataObjs{1}, 'XData');
g4r4_X_CV = get(dataObjs{1}, 'YData'); 


[R,P] = corrcoef(g4r4_X_DOS(ROI), g4r4_X_CV(ROI))

j8v8_X_DOS = get(dataObjs{2}, 'XData');
j8v8_X_CV = get(dataObjs{2}, 'YData'); 

[R,P] = corrcoef(j8v8_X_DOS(ROI), j8v8_X_CV(ROI))

r5n5_X_DOS = get(dataObjs{3}, 'XData');
r5n5_X_CV = get(dataObjs{3}, 'YData'); 

[R,P] = corrcoef(r5n5_X_DOS(ROI), r5n5_X_CV(ROI))


g4r4_LMAN_DOS = get(dataObjs{4}, 'XData');
g4r4_LMAN_CV = get(dataObjs{4}, 'YData'); 

[R,P] = corrcoef(g4r4_LMAN_DOS(ROI), g4r4_LMAN_CV(ROI))


j8v8_LMAN_DOS = get(dataObjs{5}, 'XData');
j8v8_LMAN_CV = get(dataObjs{5}, 'YData'); 

[R,P] = corrcoef(j8v8_LMAN_DOS(ROI), j8v8_LMAN_CV(ROI))

r5n5_LMAN_DOS = get(dataObjs{6}, 'XData');
r5n5_LMAN_CV = get(dataObjs{6}, 'YData'); 

[R,P] = corrcoef(r5n5_LMAN_DOS(ROI), r5n5_LMAN_CV(ROI))


 %cols = cell2mat({[0.6350, 0.0780, 0.1840]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; [0, 0, 0]; [0.4940, 0.1840, 0.5560]});
    
cols = {'b', 'r'};
% 
% group1 = ones(1, size(g4r4_X_DOS, 2))*1;
% group2 = ones(1, size(g4r4_LMAN_DOS, 2))*2;
% 
% group1 = ones(1, size(j8v8_X_DOS, 2))*1;
% group2 = ones(1, size(j8v8_LMAN_DOS, 2))*2;

group1 = ones(1, size(r5n5_X_DOS, 2))*1;
group2 = ones(1, size(r5n5_LMAN_DOS, 2))*2;

ROI = 1:264;

groups = [group1(ROI) group2(ROI)];

 %yes = [ g4r4_X_CV(ROI) g4r4_LMAN_CV(ROI)];
 %xes = [ g4r4_X_DOS(ROI) g4r4_LMAN_DOS(ROI)] ;

%  yes = [ j8v8_X_CV(ROI) j8v8_LMAN_CV(ROI)];
%  xes = [ j8v8_X_DOS(ROI) j8v8_LMAN_DOS(ROI)] ;
% 
yes = [ r5n5_X_CV(ROI) r5n5_LMAN_CV(ROI)];
xes = [ r5n5_X_DOS(ROI) r5n5_LMAN_DOS(ROI)] ;


 h = scatterhist(xes,yes,'Group',groups,'Kernel','on', 'Location','SouthEast',...
     'Direction','out', 'LineStyle',{'-','-'}, 'Marker','..', 'Markersize', 20, 'color', cols);
 
 %ylim([0 15])
 ylim([0 10])
    xlim([0 200])
   
median(g4r4_X_CV(ROI))
median(j8v8_X_CV(ROI))
median(r5n5_X_CV(ROI))

median(g4r4_LMAN_CV(ROI))
median(j8v8_LMAN_CV(ROI))
median(r5n5_LMAN_CV(ROI))


std(g4r4_LMAN_CV(ROI))/sqrt(numel(g4r4_LMAN_CV(ROI)))
std(j8v8_LMAN_CV(ROI))/sqrt(numel(j8v8_LMAN_CV(ROI)))

    
[hh, p] = ranksum( r5n5_X_CV, r5n5_LMAN_CV)
%[hh, p] = ranksum( g4r4_X_CV, g4r4_LMAN_CV)
%[hh, p] = ranksum( j8v8_X_CV, j8v8_LMAN_CV)


% title(['g4r4, p = ' num2str(hh)])
% saveName = [figDir 'g4r4-scatter'];


title(['r5n5, p = ' num2str(hh)])
saveName = [figDir 'r5n5-scatter'];

title(['j8v8, p = ' num2str(hh)])
saveName = [figDir 'j8rv8-scatter'];



   plotpos = [0 0 15 12]; %Fig 2
   
 print_in_A4(0, saveName, '-djpeg', 0, plotpos);
 print_in_A4(0, saveName, '-depsc', 3, plotpos);

 
 
 
 
 
%%
for j = 1:6
     
xdata = get(dataObjs{j}, 'XData'); 
ydata = get(dataObjs{j}, 'YData');

figure; histogram(ydata, edges)
 end
 

figure; scatter(xdata, ydata)

[R,P] = corrcoef(xdata, ydata)

[R,P]  = corr(xdata,ydata, 'rows', 'complete'); 
