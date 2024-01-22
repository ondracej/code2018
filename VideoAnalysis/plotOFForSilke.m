function [] = plotOFForSilke()

of1 = load('C:\Users\Janie\Dropbox\tmp\VideosForSilke\editedVids\editedVids\OF_DS-20191021134540696__DS-30fps\OF-FullFile-20191021134540696__DS-30fps_pt-01_roi1');
of2 = load('C:\Users\Janie\Dropbox\tmp\VideosForSilke\editedVids\editedVids\OF_DS-20191021134540696__DS-30fps\OF-FullFile-20191021134540696__DS-30fps_pt-01_roi2');
of3 = load('C:\Users\Janie\Dropbox\tmp\VideosForSilke\editedVids\editedVids\OF_DS-20191021134540696__DS-30fps\OF-FullFile-20191021134540696__DS-30fps_pt-01_roi3');
of4 = load('C:\Users\Janie\Dropbox\tmp\VideosForSilke\editedVids\editedVids\OF_DS-20191021134540696__DS-30fps\OF-FullFile-20191021134540696__DS-30fps_pt-01_roi4');

%%

figure(100);clf


timpoints_fps = 1:1:numel(of1.fV1);
timepoints_s = timpoints_fps./30;


subplot(2, 2, 1)
plot(timepoints_s, of1.fV1/max(of1.fV1), 'k')
axis tight
xlabel('Time (s)'); title('Cage 1'); ylabel('Normalized optic flow')

subplot(2, 2, 2)
plot(timepoints_s, of2.fV1/max(of2.fV1), 'k')
axis tight
xlabel('Time (s)'); title('Cage 2'); ylabel('Normalized optic flow')


subplot(2, 2, 3)
plot(timepoints_s, of3.fV1/max(of3.fV1), 'k')
axis tight
xlabel('Time (s)'); title('Cage 3'); ylabel('Normalized optic flow')

subplot(2, 2, 4)
plot(timepoints_s, of4.fV1/max(of4.fV1), 'k')
axis tight
xlabel('Time (s)'); title('Cage 4'); ylabel('Normalized optic flow')


   plotpos = [0 0 25 12];
            PlotDir = ['C:\Users\Janie\Dropbox\tmp\VideosForSilke\'];
            
            plot_filename = [PlotDir 'OF'];
            %print_in_A4(0, plot_filename, '-depsc', 0, plotpos);
            print_in_A4(0, plot_filename, '-djpeg', 0, plotpos);
            
            
%% 

figure(103); clf
bluecolor = [0 50 150];

subplot(2, 2, 1)
shapeInserter1 = vision.ShapeInserter('Shape','Rectangles','BorderColor','Custom','LineWidth',5.5,'CustomBorderColor',int32(bluecolor));
img1 = step(shapeInserter1,im,rectim1); %insert the ROIs
%img1 = step(shapeInserter1,of1.im,of1.rectim1); %insert the ROIs
image(img1)

subplot(2, 2, 2)
shapeInserter1 = vision.ShapeInserter('Shape','Rectangles','BorderColor','Custom','LineWidth',5.5,'CustomBorderColor',int32(bluecolor));
img1 = step(shapeInserter1,of2.im,of2.rectim1); %insert the ROIs
image(img1)

subplot(2, 2, 3)
shapeInserter1 = vision.ShapeInserter('Shape','Rectangles','BorderColor','Custom','LineWidth',5.5,'CustomBorderColor',int32(bluecolor));
img1 = step(shapeInserter1,of3.im,of3.rectim1); %insert the ROIs
image(img1)

subplot(2, 2, 4)
shapeInserter1 = vision.ShapeInserter('Shape','Rectangles','BorderColor','Custom','LineWidth',5.5,'CustomBorderColor',int32(bluecolor));
img1 = step(shapeInserter1,of4.im,of4.rectim1); %insert the ROIs
image(img1)
plotpos = [0 0 15 12];
            PlotDir = ['C:\Users\Janie\Dropbox\tmp\VideosForSilke\'];
            
            plot_filename  = ['X:\Frog\OF\frogImg']
            plot_filename = [PlotDir 'ROIs'];
            %print_in_A4(0, plot_filename, '-depsc', 0, plotpos);
            print_in_A4(0, plot_filename, '-djpeg', 0, plotpos);
   

%%
end