

function [] = plotDOS_ratioForNights()

DirOf_DOS = 'G:\SWR\ZF-71-76_Final\AllTrigsDBMatFiles\';

dbstop if error

   textSearch = '*TRIG*'; % text search for ripple detection file
   TRIG_Files = dir(fullfile(DirOf_DOS,textSearch));
            
   textSearch = '*Delta*'; % text search for ripple detection file
   DOS_Files = dir(fullfile(DirOf_DOS,textSearch));


   OF_File = 'G:\SWR\ZF-71-76_Final\20190920\18-37-00\Videos\OF_DS\20190920_18-37-00_OF-fullFile.mat';
   OF = load(OF_File);
   

nTrigFiles = numel(TRIG_Files);

for j = 1:nTrigFiles
    
    trigs{j} = load([DirOf_DOS TRIG_Files(j).name]);
    allLightOff_samp(j) = trigs{1,j}.TRIGS.LightOff_samp;
    allLightOn_samp(j) = trigs{1,j}.TRIGS.LightOn_samp;
    allFs(j) = trigs{1,j}.TRIGS.fs;
    
    dos{j} = load([DirOf_DOS DOS_Files(j).name]);
    AllDB{j} = dos{1,j}.D.allBufferedData;
    
    %AllDB_smooth{j} = smooth(AllDB{j}, 300);
    AllDB_smooth{j} = smooth(AllDB{j}, 900);
    AllDB_durs(j) = numel(AllDB{j});
end



%%

scaleFactor = 0.9956; % = 1792/1800 

for j = 1:nTrigFiles
Fs = allFs(j);
LightOffSamp = allLightOff_samp(j);
LightOff_s = LightOffSamp/Fs;
LightOff_s_scaled(j) = round(scaleFactor*LightOff_s);

LightOnSamp = allLightOn_samp(j);
LightOn_s = LightOnSamp/Fs;
LightOn_s_scaled(j) = round(scaleFactor*LightOn_s);

end

[maxDur indmax ]= max(LightOff_s_scaled);

[maxDurON indmaxON ]= max(LightOn_s_scaled);
%% nanpad

for j = 1:nTrigFiles
    
    thisDB =LightOff_s_scaled(j);
    
    nnans = maxDur-thisDB;
    DBnans = nan(1, nnans);
    
    nanpaddedDB = [DBnans AllDB_smooth{j}'];
    allnanpadded{j} = nanpaddedDB;
end

cols = redblue(4);



%%
figure(104);clf
subplot(3, 3, [1 2 4 5])
for j = 1:nTrigFiles
    
    hold on
%plot(allnanpadded{j}, 'color', [0.5 0.5 0.5]);
plot(allnanpadded{j}, 'linewidth', 1, 'color',[j*255/5 50 255-j*255/5]/255)

if j == 4
    plot(allnanpadded{j}, 'k', 'linewidth', 2);
end

end

disp('')


yss = ylim;
hold on
line([LightOff_s_scaled(indmax) LightOff_s_scaled(indmax)], [yss(1) yss(2)], 'color', 'k')

line([LightOn_s_scaled(indmax) LightOn_s_scaled(indmax)], [yss(1) yss(2)], 'color', 'k')

xticks = 0:1792*2:70000;
set(gca, 'xtick', xticks) 

xticklabs = {'16:00' ;'17:00' ; '18:00' ; '19:00' ; '20:00' ; '21:00' ; '22:00' ; '23:00' ; '24:00' ; '1:00' ; '2:00' ; '3:00' ; '4:00' ; '5:00' ; '6:00' ; '7:00' ; '8:00' ; '9:00' ; '10:00'; '11:00'}; 
set(gca, 'xticklabel', xticklabs ) 

%%
subplot(3, 3, [3 6 ])
imagesc(dos{1,4}.D.bufferedDeltaThetaOGammaRatio, [0 1200])

xticks_s = 0:5*60:30*60;
    xticks_min = xticks_s/60;
    
    xticklabs = xticks_min;
    
    ytics = get(gca, 'ytick');
    ytics_Hr = ytics/2;
    

xlabs = [];
for j = 1:numel(xticklabs)
    xlabs{j} = num2str(xticklabs(j));
end

ytics_Hr_round = [];
for j = 1:numel(ytics_Hr)
    %ytics_Hr_round{j} = num2str(round(ytics_Hr(j)));
    ytics_Hr_round{j} = num2str(ytics_Hr(j));
end

set(gca, 'xtick', xticks_s)
set(gca, 'xticklabel', xlabs)
set(gca, 'yticklabel', ytics_Hr_round)

xlabel('Time (min)')
ylabel('Time (hr)')
%title([params.DateTime ' | ' titletxt])
colorbar('location', 'northoutside')


%%

subplot(3, 3, [7 8])

plot(OF.F.timepoints_hrs, OF.F.fV1_norm, 'color', [0.7 0.7 0.7]);
hold on
plot(OF.F.timepoints_hrs, OF.F.smoothedOF, 'k', 'linewidth', 1.5)

axis tight
set(gca, 'xtick', OF.F.xticks/3600);
set(gca, 'xtickLabel',  OF.F.xlabs)
xlabel('Time [Hr]')
ylabel('Normalized OF')
%%
saveName = [DirOf_DOS  '_DOS-Summary'];
%plotpos = [0 0 25 12];
plotpos = [0 0 40 15];
print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);


end