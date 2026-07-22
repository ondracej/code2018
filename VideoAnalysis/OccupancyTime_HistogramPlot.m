%% Inputs
% x and y are vectors (one value per video frame)
% Example:
% x = ...;
% y = ...;

% Arena parameters
arenaRadius = 25;      % same units as x and y
binSize = 0.5;         % spatial resolution

%% Create spatial bins
edges = -arenaRadius:binSize:arenaRadius;

% Count occupancy
occ = histcounts2(y, x, edges, edges);
% (y first because MATLAB images use rows = y)

%% Convert frames to time (optional)
fps = 30;              % video frame rate
occTime = occ / fps;   % seconds spent in each bin

%% Bin centers
xc = edges(1:end-1) + binSize/2;
yc = edges(1:end-1) + binSize/2;
[Xc,Yc] = meshgrid(xc,yc);

%% Mask outside the circular arena
mask = Xc.^2 + Yc.^2 <= arenaRadius^2;
occTime(~mask) = NaN;

%% Plot
figure;
imagesc(xc, yc, occTime);
axis equal;
axis xy;
hold on;

% Draw arena boundary
theta = linspace(0,2*pi,500);
plot(arenaRadius*cos(theta), arenaRadius*sin(theta), ...
    'k','LineWidth',2);

xlabel('X Position');
ylabel('Y Position');
title('Occupancy Map');
colormap(turbo);    % or hot, jet, parula
colorbar;
c = colorbar;
ylabel(c,'Time (s)');

set(gca,'FontSize',12);



%% Optional: Smooth the occupancy map
% A smoothed map is often easier to interpret.

sigma = 2;   % smoothing in bins

occSmooth = imgaussfilt(occTime, sigma);

% Preserve NaNs outside arena
occSmooth(~mask) = NaN;

figure;
imagesc(xc, yc, occSmooth);
axis equal;
axis xy;
hold on;
plot(arenaRadius*cos(theta), arenaRadius*sin(theta), ...
    'k','LineWidth',2);

xlabel('X Position');
ylabel('Y Position');
title('Smoothed Occupancy Map');
colormap(turbo);
colorbar;


%% If your arena is not centered at (0,0)

centerX = 125;
centerY = 87;
arenaRadius = 25;

mask = (Xc-centerX).^2 + (Yc-centerY).^2 <= arenaRadius^2;

plot(centerX + arenaRadius*cos(theta), ...
     centerY + arenaRadius*sin(theta), ...
     'k','LineWidth',2);