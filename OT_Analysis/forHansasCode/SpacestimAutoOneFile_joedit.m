%% Fenstert PSTH nach signifikantem An- und Abstieg in Aktivit�t

%clear all;
close all;

%% w�hlt alle Dateien aus der aktuellen Directory aus
% cd 'D:\data\Scan\Physiology\chickenf32\receptive fields\passt'
% files = dir('*.f32');
% savedata=cell(numel(files),15); %creates cell array, cell(row, column)
% for k=1:numel(files);
%     clearvars -except k savedata files;
%% read spikes and some parameter

% data=spikedatf([pathname filename]);
%data=spikedatf('D:\data\Scan\Physiology\chickenf32\receptive fields\passt\h21_018G1-1.f32');

%[filename pathname]=uigetfile('/home/janie/Dropbox/00_Conferences/Fens_2018/HansaData/DataToUse/passt/*f32');

dataDir = ['/home/janie/Dropbox/00_Conferences/Fens_2018/HansaData/DataToUse/passt/'];
filToLoad = ['h20_001aG1-1.f32'];

data=spikedatf([dataDir filToLoad]);
% data = sweeplength  = 400 ; stim = 16x1 double; sweep = 1x10 struct w field spikes
%data(1).stim(1) = sample ON?
%data(1).stim(2) = sample OFF?
%data(1).stim(3) = trial number
%data(1).stim(4) = 70 DB right?
%data(1).stim(5) = 70 DB left?
%data(1).stim(6) = 0
%data(1).stim(7) = 1
%data(1).stim(8) = 1
%data(1).stim(9) = 0
%data(1).stim(10) = total duration of record in ms
%data(1).stim(11) = n repetitions
%data(1).stim(12) = pre stim silence in ms
%data(1).stim(13) = azimuth
%data(1).stim(14) = electaion
%data(1).stim(15) = 35 DB right?
%data(1).stim(16) = 35 DB left?

% Is sweep length in ms?? What are the stim values?? is sweep the repetitions of the stim? 10x each?
% Stim values must be some experiment parameters - get what these actually are from Hansa
%%

%     data=spikedatf([files(k).name]);
nos=size(data,2)-1;  % Number of stims minus the silent stim (199) %gibt die Stimulusanzahl an. Bei (data,2) ist die Anzahl der Stimuli hinterlegt: (9 Elevation* 22 Azimuth) + den Nullstimulus
n_reps=data(1).stim(11); % 11th positions gives number of repetitions

%% soll sicherstellen, dass genug sweeps pro read da sind; read 199 sets, 1352 sweeps,

%% findet Analyse Fenster im PSTH
array_1=[];
array_2=[];
for z=10:1:(data(1).sweeplength)-10 %Warum -10? % If the sweep lenght is 400, why only care about it from 10 to 390??
    %     z=10:1:(data(1).sweeplength)
    
    fenstervon=0+z; %Was soll das?? 390 ms
    fensterbis=10+z;%10ms Fenster !!! 400 ms
    %     fensterbis=z;%10ms Fenster !!!
    for x=1:nos %Stimulizahl 198 "data" %% nos sollte Zahl der Stimuli entsprechen
        for y=1:n_reps   %Repetitionszahl, "sweeps"
            afenster_1(y)=length(find (fenstervon <= data(x).sweep(y).spikes & data(x).sweep(y).spikes <= fensterbis)); %  Analyse fenster  10-150ms
            bfenster_1(y)=length(find (0<= data(x).sweep(y).spikes & data(x).sweep(y).spikes <= 10)); % Why do you only look between 0 and 10, i though spont was until 50 ms?
            all_spikes_1(x)=sum(afenster_1);%Summe aller Spikes, Achtung! Information dar�ber wieviel spikes in welcher Wiederholung waren geht verloren!(s.u.)
            all_spikesspont_1(x)=sum(bfenster_1);%Summe Spontanaktivit�t
        end
    end
    array_1= [array_1 all_spikes_1];
     %array_2= [array_2 ;all_spikes_1]; % 381 diff 10 ms bins, 198 diff stimuli
end
spikarray_1=reshape(array_1,nos,length(array_1)/(nos));%146

for i= 1:length(array_1)/(nos) %381, the lengh of all the bins
    [p_fenster_1,h_fenster_1]=signtest(spikarray_1(:,i),all_spikesspont_1,0.01);%p<= 0.01  11.11.05 % Wrong statistsics test
    [h,p]=ttest(spikarray_1(:,i),all_spikesspont_1',0.01);%p<= 0.01  11.11.05 % Wrong statistsics test
    % this is comparing, for all of the 198 diff stimuli, the number of
    % spikes in bin 10ms 20ms to the number of spikes in bin 0ms to 10 ms,
    % for each 10 ms bin comparison
    
    h_fensterall_1(i)=h_fenster_1;
    h_ttestall(i)=h;
end

%figure; 
%plot(h_ttestall-.1, 'r*', 'linestyle', 'none')
%hold on; plot(h_fensterall_1, 'ko', 'linestyle', 'none')
%%

sps_1=find(h_fensterall_1);
bla = diff(sps_1);
hmin_1=min(find(diff(sps_1)==1));%findet die ersten zwei signifikanten zusammenh�ngende positionen
hmax_1=max(find(diff(sps_1)==1))+1;%findet letzten zwei signifikanten zusammenh�ngende positionen

% windowvon_1=sps_1(hmin_1)+9;
% windowbis_1=sps_1(hmax_1)+19;
windowvon=sps_1(hmin_1)+9;
windowbis=sps_1(hmax_1)+19;

%% falls es keine signifikante Antwort gibt 
% if isempty (windowvon)
%     '
%     


%% von bis az und ele normal
for zz=1:nos;
    azall(zz)=data(zz).stim(13); %13. Position f�r Azimuth
    eleall(zz)=data(zz).stim(14); %14. Position f�r Elevation
end
az=unique(azall); % achtung , wenn nullstim drin ist
ele=unique(eleall);

%% ersetzt "-" in filename mit "_"
filename = 'h21_016G1-1.f32';
filename=filename(1:12);
filename=strrep(filename,'_','-'); %Unterstrich raus
% filename=files(k).name;
% filename=strrep(filename,'_','-'); %Unterstrich raus

%% create sum PSTH
binwidth_s=0.001;%[s]
max_time=(data(1).sweeplength)/1000;%[ms]
spike_times=[];
htime=0:binwidth_s:max_time;
for yy=1:n_reps;
    for xy = 1:nos;
        %if 1-isempty(data(xy).sweep);%eingef�gt 6.12.04
        spike_times=[spike_times data(xy).sweep(yy).spikes]; % concat all spikes in ms
        %end
    end
end
% convert to seconds
spike_times=spike_times/1e3; % convert back to s

psth=histc(spike_times,htime);
psthall(xy,:)=psth; % what does this do
summenpsth=sum(psthall); % this is the same as psth

spontlevel=(std(summenpsth(1:50))*2)+mean(summenpsth(1:50)); %2x std
spontmean = mean(summenpsth(1:50));
spontstd = std(summenpsth(1:50))*3;

maxspikecount=max(summenpsth);

%% figure
figure(1); clf
plot(summenpsth);
hold on
%line([0 data(1).sweeplength],[spontlevel spontlevel],'linestyle','--','color',[.5 .5 .5]);
title([filename '  SummenPSTH']);
xlabel('Time [ms]','Fontsize',10);
ylabel('# of spikes','Fontsize',10);
set(gca, 'Xlim',[0 400]);
line([50 250],[0 0],'linestyle','-','color','r','LineWidth',3); % why until 250?

figure(1),line([windowvon windowvon],[0 max(summenpsth)],'linestyle','--','color',[.5 .5 .5]);
line([windowbis windowbis],[0 max(summenpsth)],'linestyle','--','color',[.5 .5 .5]);
hold off
pause(0.3)

%% puts dataarray together
arr=[];
latarr=[];
for z= 1:length(az);%1:7;
    
    z2=az(z);
    
    for y = 1:length(ele);%1:13
        
        y1=ele(y);
        
        for x=1:nos;
            
            if find(data(x).stim(14)==y1)& find(data(x).stim(13)==z2);
                minlatallall=[];
                for yy=1:n_reps;
                    
                    a(x)=length(find (windowvon <= data(x).sweep(yy).spikes & data(x).sweep(yy).spikes <= windowbis)); %  Analysefenster  10-150ms
                    a=sum(a);
                    
                    b=find(windowvon <= data(x).sweep(yy).spikes & data(x).sweep(yy).spikes <= windowbis);
                    if isempty(b)
                        xr1=NaN;
                    else
                        xr1=data(x).sweep(yy).spikes(b);
                    end
                    minlatallall=[minlatallall min(xr1)];
                end
                latarr=[latarr nanmean(minlatallall)];
            else
                a(x)=0;
                
            end
            
            allspikes(y)=sum(a); % Summe aller Spikes, Achtung! Information dar�ber wieviel spikes in welcher Wiederholung waren geht verloren
            
        end
    end
    
    arr=[arr allspikes];
    
end
latarr=latarr-50;

Spikearray=reshape(arr,length(ele),length(az));%Summe aus allen Durchg�ngen

%% normalisieren
maxispike=max(max(Spikearray));
maxispike=round(maxispike*10)/10;
Spikearray=Spikearray/max(max(Spikearray)); % normalize spikearray by max
Spikearray_norm=Spikearray/max(max(Spikearray));
%% smoothes
smoothSpikearray=moving_average2(Spikearray(:,:),1,1);% rows ;collumns
smoothSpikearray_norm=smoothSpikearray/max(max(smoothSpikearray)); %normalizing by max again...

% from other code
figure(2); clf
surf((Spikearray_norm));
shading interp
view([ 0 90])


%% figure
figure(1),contourf((Spikearray),12), colormap hot;
figure(2),contourf((Spikearray_norm),12), colormap hot;
figure(3),contourf((smoothSpikearray_norm),12), colormap hot;

colormap(flipud(colormap));
hold on
[con,h]=contour((smoothSpikearray_norm),max(max(smoothSpikearray_norm))/1.3333,'--k');%%1.3333
[con,h]=contour((smoothSpikearray_norm),max(max(smoothSpikearray_norm))/1.3333,'--k');%%1.3333
%% find largest contour
[rowind colind]=find(con==con(1,1));
[maxvalue, maxind]=max(con(2,colind));
con=con(:,colind(maxind):(colind(maxind)+maxvalue));

set(h,'LineWidth',3);
[xvals, yvals]=contvalues(con); % Coordinates of contour boundaries
%% umrechnen von values in Grad-Koordinaten
Longitude= -180+(xvals.values-1)*16.875;
Latitude = - 67.5+(yvals.values-1)*16.875;
%% Umrechnung in Radians
Long = deg2rad(Longitude);
Lat = deg2rad(Latitude);
%% unprojizierter Fl�cheninhalt
flaecheninhaltunprojiziert=polyarea(Long,Lat);
% figure, plot(Long,Lat);
%% projizieren von Kontourpositionen nach der Hammer-Projektion (die eine equal-area Projektion ist)
R=1;
[X,Y]=pr_hammer(Long,Lat,R);
% X = rad2deg(X);
% Y = rad2deg(Y);
% figure,plot(X,Y)
flaecheninhalt=polyarea(X,Y); %errechnet Fl�cheninhalt von Kontourgrenzen

%% Schwerpunkt
[schwerpunktx, schwerpunkty]=centroid(xvals.values, yvals.values);
% plot(schwerpunktx,schwerpunkty,'dw','Markersize',12);
%% Umrechnung Schwerpunkt in Grad
schwerpunktx_degree=-180+(schwerpunktx-1)*16.875;
schwerpunkty_degree=-67.5+(schwerpunkty-1)*16.875;

max_resp=max(max(smoothSpikearray)); %using smoothSpikearray gives too many maxresp...
[maxrespy,maxrespx]=find(smoothSpikearray==max(max(smoothSpikearray)));
% plot(maxrespx,maxrespy,'*w','Markersize',12);
maxrespx_degree=az(maxrespx);
maxrespy_degree=ele(maxrespy);

caxis([0 1])
h=colorbar;

set(h,'Fontsize',12);
htitle=get(h,'title');
set(htitle,'String', 'normalized # of spikes','Fontsize',12,'VerticalAlignment','Middle');
set(gca,'xlim',[1 length(az)],'Ylim',[1 length(ele)]);

set(gca, 'XTick',[1:length(az)]);%17.01.05
set(gca,'XTickLabel',{az});
set(gca,'XTickLabel',{'-180';'';'';'';'';'';'-90';'';'';'';'';'0';'';'';'';'';'90';'';'';'';'';'180';});
set(gca, 'YTick',[1:length(ele)]);%17.01.05
set(gca,'YTickLabel',{ele});
set(gca,'YTickLabel',{'-67.5';'';'-33.75';'';'0';'';'33.75';'';'67.5';});
title([filename, ', window=' num2str(windowvon) '- ' num2str(windowbis) 'ms, max=' num2str(maxispike) ],'Fontsize',12,'Fontweight','bold');

xlabel('Azimuth[�]','Fontsize',12);
ylabel('Elevation[�]','Fontsize',12);

%% Gibt Position mit maximaler Antwort raus
max_resp=max(max(Spikearray));
[maxrespy,maxrespx]=find(Spikearray==max(max(Spikearray)));
%% Latenzen; gibt Zeitpunkt von Spikes raus
minlatall=[];
emptycount=0;
for yy1=1:n_reps;
    for xy1 = 1:nos;
        
        if data(xy1).stim(14)==ele(maxrespy(1)) & data(xy1).stim(13)== az(maxrespx(1));%specifies point in FRA (freq/SPL combination); hier k�nnte ich zum Beispiel immer den Punkt der maximalen Antwort rausnehmen und dort die firstspike Analyse machen
            
            xr1=data(xy1).sweep(yy1).spikes;
            minlat=(min(xr1));
            minlatall=[minlatall minlat];
            if isempty(xr1)%f�llt leere durchg�nge auf, wichtig f�r plot
                emptycount=emptycount+1;
                xr1=-100;
            end
            
%             figure(3),plot(xr1,yy1, 'k.');
            hold on
        end
    end
end


set(gca,'xlim',[0 500]);
set(gca,'ylim',[0 n_reps]);
hold off

%% K�rzeste stLatenz (minfirstsp_lat) Mittel auf den drei k�rzesten (minfir3sp_lat), mittlere Latenz (meanfirstsp_lat) und deren Standardabweichungen)
minlatall=minlatall-50; % correct for stimulus offset due to silent periode (e.g. 50 ms)
ind=find(minlatall >=windowvon-50 & minlatall <=windowbis -50); %makes sure that it is no spontaneous spike
meanfirstsp_lat=mean(minlatall(ind)); %-50 corrects for stimulus offset
sdfirstsp_lat=std(minlatall(ind));
minfirstsp_lat=min(minlatall(ind)); %-50 corrects for stimulus offset
sortlat=sort(minlatall(ind));
if length(sortlat)<3
    minfirst3sp_lat = [];
    sdminfirst3sp_lat=[];
else
minfirst3sp_lat=mean(sortlat(1:3)); %-50 corrects for stimulus offset
sdminfirst3sp_lat=std(sortlat(1:3));
end


% if emptycount>7
%     'achtung'
% end


%% save file
% savedatanames=['filename', 'Spikearray', 'Windowvon', 'Windowbis',  'Flaecheninhalt', 'Schwerpunktx_degree', 'Schwerpunkty_degree', 'Maxispike', 'Maxrespx_degree', 'Maxrespy_degree', 'Minfirst3sp_lat', 'Sdminfirst3sp_lat', 'Minfirstsp_lat', 'Meanfirstsp_lat', 'Sdfirstsp_lat'];
% savedata(k,:)={filename, Spikearray, windowvon, windowbis, flaecheninhalt, schwerpunktx_degree, schwerpunkty_degree, maxispike, maxrespx_degree, maxrespy_degree, minfirst3sp_lat, sdminfirst3sp_lat, minfirstsp_lat, meanfirstsp_lat, sdfirstsp_lat};

if 0
    file=['D:\data\Scan\Physiology\' filename 'mat'];
    save('filename', 'Spikearray', 'windowvon', 'windowbis',  'flaecheninhalt', 'schwerpunktx_degree', 'schwerpunkty_degree', 'maxispike', 'maxrespx_degree', 'maxrespy_degree', 'minfirst3sp_lat', 'sdminfirst3sp_lat', 'minfirstsp_lat', 'meanfirstsp_lat', 'sdfirstsp_lat');
end
% end
% save('RFsnew','savedata', 'savedatanames');
