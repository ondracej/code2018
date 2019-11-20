
function [] = calcSWR_CSD()

dataDir = 'D:\TUM\SWR-Project\ZF-60-88\20190429\14-43-33\Ephys';

dataRecordingObj = OERecordingMF(dataDir);
dataRecordingObj = getFileIdentifiers(dataRecordingObj); % creates dataRecordingObject

Fs = dataRecordingObj.samplingFrequency;

vDetections = 'D:\TUM\SWR-Project\ZF-60-88\20190429\14-43-33\Analysis\vDetections';

s=load(vDetections);

allSWR_fs = s.allSWR.allSWR_fs;
allSWR_ms  = allSWR_fs/Fs*1000;


%% Get all SWRs for each channel

%chanMap = [2 7 15 10 13 12 14 11 1 8 16 9 3 6 4 5];
chanMap = [5 4 6 3 9 16 8 1 11 14 12 13 10 15 7 2];
nChans = numel(chanMap);

preTemplate_ms = 100;
winTemplate = 200;
cnt = 1;
swr = [];
for j = 1:nChans
    ch = chanMap(j);
[allSWR,tSW]=dataRecordingObj.getData(ch,(allSWR_ms-preTemplate_ms),winTemplate);    

thisMean = mean(squeeze(allSWR), 1);
swr(:,cnt) = thisMean;
cnt = cnt+1;
end

%%

spw = swr;
fs = Fs;
N = nChans;
chnl_order = chanMap;
% 
% while n <= length(spw_indx)
%     spw(:,:,n)=eeg(spw_indx(n)-fs/10 : spw_indx(n)+fs/10,:); n=n+1;  % spw in the 1st channel
% end

%avg_spw=mean(spw,2)*10^-6; % for further use in ''SCD'' analysis, data turns to Volts instead of uV
avg_spw=swr*10^-6; % for further use in ''SCD'' analysis, data turns to Volts instead of uV
spacing=100*10^-6; %%%%%%%%%%% spacing between neiboring electrodes
CSDoutput = CSD(avg_spw,fs,spacing,'inverse',5*spacing)';
%%
figure;clf
subplot(1,3,1) % CSD

t_peri=((-fs/10:fs/10-1)./fs*1000); % peri-SPW time, +-50 ms around the SPW times
y_peri=(1-.5:N-.5)'; % y values for CSD plot, basically electrode channels , we centered the y cvalues so ...
% they will be natural numbers + .5
imagesc(t_peri,y_peri,CSDoutput, [-10 10]); yticks(.5:1:N-.5);  yticklabels(num2cell(chnl_order)); % flip because of physical placement of channels
ylabel(' ventral <--                    Electrode                    --> dorsal');  colormap(flipud(jet)); % blue = sink; red = sourse
xlabel('peri-SPW time (ms)');      title('CSD (\color{red}sink, \color{blue}source\color{black})');


subplot(1,3,2) % smoothed CSD (spline), we interpolate CSD values in a finer grid
t_grid=repmat(t_peri,length(y_peri)+2,1); % grid for current t values, to extra rows for beginning (zero), and the last natural full number, just ...
% greater than last row which includes a .5 portion
y_grid=repmat([0 ; y_peri ; N] , 1,length(t_peri)); % grid for current y values
t_grid_ext=repmat(t_peri,10*N,1); % new fine t grid
y_grid_ext=repmat((.1:.1:N)',1,size(t_grid,2)); % new fine y grid
[csd_smoo]=interp2( t_grid , y_grid ,[CSDoutput(1,:) ; CSDoutput ; CSDoutput(end,:)],t_grid_ext,y_grid_ext, 'spline'); % CSD interpolation in a finer grid

imagesc((-fs/10:fs/10)./fs*1000,(.1:.1:N)',csd_smoo,  [-10 10]); % fixing the color range for comparing different data
yticks(.5:1:N-.5);  yticklabels(num2cell(chnl_order)); 
ylabel('Electrode');  colormap((jet)); % blue = source; red = sink
xlabel('peri-SPW time (ms)');      title('smoothed CSD (\color{red}sink, \color{blue}source\color{black})');
% overlaying SPW traces
dist=abs(max(avg_spw(:))*2); % rescaling factor just for plot
hold on
for k = 1: N
plot( (-fs/10:fs/10-1)./fs*1000 ,-avg_spw(:,k)'/dist+k-.5  ,'color', 'k','linewidth',1.5)
end

subplot(1,3,3) % LFP
s=imagesc((-fs/10:fs/10)./fs*1000,1:N,avg_spw', [-30 5]*1e-5); yticks(1:1:N); yticklabels(num2cell(chnl_order)); 
ylabel('Electrode');  colormap(flipud(jet));
xlabel('peri-SPW time (ms)');   title(['LFP' Fname])

%% 
figure(103)


subplot(1,3,2) % smoothed CSD (spline), we interpolate CSD values in a finer grid
t_grid=repmat(t_peri,length(y_peri)+2,1); % grid for current t values, to extra rows for beginning (zero), and the last natural full number, just ...
% greater than last row which includes a .5 portion
y_grid=repmat([0 ; y_peri ; N] , 1,length(t_peri)); % grid for current y values
t_grid_ext=repmat(t_peri,10*N,1); % new fine t grid
y_grid_ext=repmat((.1:.1:N)',1,size(t_grid,2)); % new fine y grid
[csd_smoo]=interp2( t_grid , y_grid ,[CSDoutput(1,:) ; CSDoutput ; CSDoutput(end,:)],t_grid_ext,y_grid_ext, 'spline'); % CSD interpolation in a finer grid




plotDir =  'D:\TUM\SWR-Project\ZF-71-76\20190919\17-51-46\Plots\';

%saveName = [plotDir  'RawDataSWR-HF'];
saveName = [plotDir  'SWR-SW_Comparison'];

plotpos = [0 0 10 30];

print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);




%%



end