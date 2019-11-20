function [] = compareSWRStatsAcrossNights()

n2 = load('D:\TUM\SWR-Project\ZF-71-76\20190916\18-05-58\Analysis\vDetections');
n3 = load('D:\TUM\SWR-Project\ZF-71-76\20190917\16-05-11\Analysis\vDetections');
n4 = load('D:\TUM\SWR-Project\ZF-71-76\20190918\18-04-28\Analysis\vDetections');
n5 = load('D:\TUM\SWR-Project\ZF-71-76\20190919\17-51-46\Analysis\vDetections');
n6 = load('D:\TUM\SWR-Project\ZF-71-76\20190920\18-37-00\Analysis\vDetections');
n7 = load('D:\TUM\SWR-Project\ZF-71-76\20190923\18-21-42\Analysis\vDetections');

disp('')
Fs = 30000;


percentVerage  = [14.66 23.81 22.81 18.06 16.63];

medianspercent = median(percentVerage);
mediansem = std(percentVerage)/sqrt(numel(percentVerage));

%%
n2_swrs_fs = n2.allSWR.allSWR_fs;
n2_swrs_h = n2.allSWR.allSWR_H;
n2_swrs_w = n2.allSWR.allSWR_W_fs;

n2_sTo8_s = 2+54*60+1*60;

nightOn = n2_sTo8_s*Fs;
nightOff = nightOn+12*3600*Fs;

n2_inds =  find(n2_swrs_fs >= nightOn & n2_swrs_fs < nightOff); 

n2_NightSWRs_fs = n2_swrs_fs(n2_inds)-nightOn;
n2_NightSWRs_h = n2_swrs_h(n2_inds);
n2_NightSWRs_w = n2_swrs_w(n2_inds);

%%
n3_swrs_fs = n3.allSWR.allSWR_fs ;
n3_swrs_h = n3.allSWR.allSWR_H ;
n3_swrs_w = n3.allSWR.allSWR_W_fs ;

n3_sTo8_s = 49+54*60+3*60;

nightOn = n3_sTo8_s*Fs;
nightOff = nightOn+12*3600*Fs;

n3_inds =  find(n3_swrs_fs >= nightOn & n3_swrs_fs < nightOff); 

n3_NightSWRs_fs = n3_swrs_fs(n3_inds)-nightOn;
n3_NightSWRs_h = n3_swrs_h(n3_inds);
n3_NightSWRs_w = n3_swrs_w(n3_inds);
%%

n4_swrs_fs = n4.allSWR.allSWR_fs ;
n4_swrs_h = n4.allSWR.allSWR_H ;
n4_swrs_w = n4.allSWR.allSWR_W_fs ;

n4_sTo8_s = 32+55*60+1*60;

nightOn = n4_sTo8_s*Fs;
nightOff = nightOn+12*3600*Fs;

n4_inds =  find(n4_swrs_fs >= nightOn & n4_swrs_fs < nightOff); 

n4_NightSWRs_fs = n4_swrs_fs(n4_inds)-nightOn;
n4_NightSWRs_h = n4_swrs_h(n4_inds);
n4_NightSWRs_w = n4_swrs_w(n4_inds);

%%
n5_swrs_fs = n5.allSWR.allSWR_fs ;
n5_swrs_h = n5.allSWR.allSWR_H ;
n5_swrs_w = n5.allSWR.allSWR_W_fs ;

n5_sTo8_s = 15+8*60+2*60;

nightOn = n5_sTo8_s*Fs;
nightOff = nightOn+12*3600*Fs;

n5_inds =  find(n5_swrs_fs >= nightOn & n5_swrs_fs < nightOff); 

n5_NightSWRs_fs = n5_swrs_fs(n5_inds)-nightOn;
n5_NightSWRs_h = n5_swrs_h(n5_inds);
n5_NightSWRs_w = n5_swrs_w(n5_inds);

%%
n6_swrs_fs = n6.allSWR.allSWR_fs ;
n6_swrs_h = n6.allSWR.allSWR_H ;
n6_swrs_w = n6.allSWR.allSWR_W_fs ;

n6_sTo8_s = 0+23*60+1*60;

nightOn = n6_sTo8_s*Fs;
nightOff = nightOn+12*3600*Fs;

n6_inds =  find(n6_swrs_fs >= nightOn & n6_swrs_fs < nightOff); 

n6_NightSWRs_fs = n6_swrs_fs(n6_inds)-nightOn;
n6_NightSWRs_h = n6_swrs_h(n6_inds);
n6_NightSWRs_w = n6_swrs_w(n6_inds);
%%
n7_swrs_fs = n7.allSWR.allSWR_fs ;
n7_swrs_h = n7.allSWR.allSWR_H ;
n7_swrs_w = n7.allSWR.allSWR_W_fs ;

n7_sTo8_s = 28+21*60+1*60;

nightOn = n7_sTo8_s*Fs;
nightOff = nightOn+12*3600*Fs;

n7_inds =  find(n7_swrs_fs >= nightOn & n7_swrs_fs < nightOff); 

n7_NightSWRs_fs = n7_swrs_fs(n7_inds)-nightOn;
n7_NightSWRs_h = n7_swrs_h(n7_inds);
n7_NightSWRs_w = n7_swrs_w(n7_inds);

%%

disp('')

binSize_s = 1*60;
binSize_Fs = binSize_s*Fs;

TOns = 1:binSize_Fs:12*3600*Fs;

nightsOrder = [2 3 4 5 6];

for k = 1:numel(nightsOrder)
    
    eval(['thisSWR_Fs = n' num2str(nightsOrder(k)) '_NightSWRs_fs;']);
    eval(['thisSWR_H = n' num2str(nightsOrder(k)) '_NightSWRs_h;']);
    eval(['thisSWR_W = n' num2str(nightsOrder(k)) '_NightSWRs_w;']);
    
    for j = 1:numel(TOns)-1
        theseV_inds =  find(thisSWR_Fs >= TOns(j) & thisSWR_Fs < TOns(j)+binSize_Fs);
        
        
        theseH_vals = thisSWR_H(theseV_inds);
        theseW_vals = thisSWR_W(theseV_inds);
        
        ShWMeanAmp(j) = mean(theseH_vals);
        ShWMeanWidth(j) = mean(theseW_vals)/Fs*1000;
        
        nWRs(j) = numel(theseV_inds);
        rate(j) = nWRs(j)/60;
       disp('') 
    end
    allSWRNights_meanAmp{k} = ShWMeanAmp;
    allSWRNights_meanWidth{k} = ShWMeanWidth;
    allSWRNights_n{k} = rate;
    
end
amps = [];
widths = [];
rates = [];
for k = 1:numel(nightsOrder)
amps(k,:) = allSWRNights_meanAmp{k};
widths(k,:)  = allSWRNights_meanWidth{k};
rates(k,:) = allSWRNights_n{k};
end


%%
figure(302);clf
subplot(3, 1, 1)

%cols = {[0.6350, 0.0780, 0.1840], [0.8500, 0.3250, 0.0980], [0.9290, 0.6940, 0.1250], [0.4940, 0.1840, 0.5560], [0, 0.5, 0],[0, 0.4470, 0.7410],[0 0 0], [.7 .3 .7], [.7 .5 .7], [.7 .9 .7]};
cols = cell2mat({[0.6350, 0.0780, 0.1840]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; [0, 0, 0]; [0.4940, 0.1840, 0.5560]});

titleString = {'N2', 'N3', 'N4', 'N5', 'N6'};
boxplot(amps', 'whisker', 0, 'symbol', 'k.', 'outliersize', 2,  'jitter', 0.9, 'colors', cols, 'labels', titleString, 'plotstyle', 'compact', 'Whisker', 10);
%ylim([50 200])
ylabel('SWR Amplitude')
subplot(3, 1, 2)
boxplot(widths', 'whisker', 0, 'symbol', 'k.', 'outliersize', 2,  'jitter', 0.9, 'colors', cols, 'labels', titleString, 'plotstyle', 'compact', 'Whisker', 10);
%ylim([20 80])
ylabel('SWR Duration')
subplot(3, 1, 3)
%rates_Hz = rates/60;
boxplot(rates', 'whisker', 0, 'symbol', 'k.', 'outliersize', 2,  'jitter', 0.9, 'colors', cols, 'labels', titleString, 'plotstyle', 'compact', 'Whisker', 10);
ylabel('SWR Rate')
%barweb(for_barplot_means, for_barplot_mean_sems, 0.8, LFP_list_022);

plotDir = 'D:\TUM\SWR-Project\ZF-71-76\Plots\';

saveName = [plotDir  'boxplotsSWRStats_Nights'];

plotpos = [0 0 10 20];

print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);


%%

figure(311);clf; 

group2 = ones(1, size(rates, 2))*2;
group3 = ones(1, size(rates, 2))*3;
group4 = ones(1, size(rates, 2))*4;
group5 = ones(1, size(rates, 2))*5;
group6 = ones(1, size(rates, 2))*6;
%group7 = ones(1, numel(n7_NightSWRs_h))*7;

groups = [group2 group3 group4 group5 group6];
yes = [rates(1,:) rates(2,:) rates(3,:) rates(4,:) rates(5,:)];
xes = [widths(1,:) widths(2,:) widths(3,:) widths(4,:) widths(5,:)];
h = scatterhist(xes,yes,'Group',groups,'Kernel','on', 'Location','SouthEast',...
    'Direction','out', 'LineStyle',{'-','-'}, 'Marker','..', 'color', cols);

saveName = [plotDir  'Scatterplot_Nights_rateVwidth'];

plotpos = [0 0 10 10];

print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);

%%
figure(311);clf; 

group2 = ones(1, size(rates, 2))*2;
group3 = ones(1, size(rates, 2))*3;
group4 = ones(1, size(rates, 2))*4;
group5 = ones(1, size(rates, 2))*5;
group6 = ones(1, size(rates, 2))*6;
%group7 = ones(1, numel(n7_NightSWRs_h))*7;

groups = [group2 group3 group4 group5 group6];
yes = [rates(1,:) rates(2,:) rates(3,:) rates(4,:) rates(5,:)];
xes = [amps(1,:) amps(2,:) amps(3,:) amps(4,:) amps(5,:)];
h = scatterhist(xes,yes,'Group',groups,'Kernel','on', 'Location','SouthEast',...
'Direction','out', 'LineStyle',{'-','-'}, 'Marker','..', 'color', cols);


hold on;
%clr = get(h(1),'colororder');
boxplot(h(2),xes,groups,'orientation','horizontal',...
    'label',{'','','','',''},'color',cols, 'plotstyle', 'compact', 'Whisker', 15);
boxplot(h(3),yes,groups,'orientation','horizontal',...
    'label', {'','','','',''},'color',cols, 'plotstyle', 'compact', 'Whisker', 15);
%set(h(2:3),'XTickLabel','');
view(h(3),[270,90]);  % Rotate the Y plot
axis(h(1),'auto');  % Sync axes
hold off;




saveName = [plotDir  'Final_Scatterplot_Nights_rateVamp_HIST'];

plotpos = [0 0 10 10];

print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);



%%
allnorm_h = [];
allnormLog_h = [];
allRanks_p = [];
allRanks_h = [];
allRanksRate_p = [];
allRanksRate_h = [];

for j = 1:numel(nightsOrder)
    for k = 1:numel(nightsOrder)
        
        [rateSig_p, rateSig_h] = ranksum(rates(j,:), rates(k,:));
        mediansRate = median(rates(j,:));
        sem_rate = (std(rates(j,:)))/sqrt(numel(rates(j,:)));
        
        [h_norm, p_norm, ] = lillietest(widths(j, :));
        [h_log, p_log] = lillietest(log(widths(j, :)));
[p, h] = ranksum(widths(j, :), widths(k, :));

allRanksRate_p(j,k) = rateSig_p;
allRanksRate_h(j,k) = rateSig_h;

allRanks_p(j,k) = p;
allRanks_h(j,k) = h;

allnorm_h(j) = h_norm;
allnormLog_h(j) = h_log;

allMedians(j,k) = mediansRate;
allsems(j,k) = sem_rate;

    end
end







%%

%%



hold on;
%clr = get(h(1),'colororder');
boxplot(h(2),xes,groups,'orientation','horizontal',...
    'label',{'',''},'color',[clr(2,:); clr(1,:)], 'plotstyle', 'compact', 'Whisker', 10);
boxplot(h(3),yes,groups,'orientation','horizontal',...
    'label', {'',''},'color',[clr(2,:); clr(1,:)], 'plotstyle', 'compact', 'Whisker', 10);
%set(h(2:3),'XTickLabel','');
view(h(3),[270,90]);  % Rotate the Y plot
axis(h(1),'auto');  % Sync axes
hold off;

%%
cols = cell2mat({[0.6350, 0.0780, 0.1840]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; [0, 0, 0]; [0.4940, 0.1840, 0.5560]});

ns = [numel(n2_NightSWRs_h) numel(n3_NightSWRs_h) numel(n4_NightSWRs_h) numel(n5_NightSWRs_h) numel(n6_NightSWRs_h)];

nmedian = median(ns);
semn = std(ns)/sqrt(numel(ns));

figure(311);clf; 
groups = [];
group2 = ones(1, numel(n2_NightSWRs_h))*2;
group3 = ones(1, numel(n3_NightSWRs_h))*3;
group4 = ones(1, numel(n4_NightSWRs_h))*4;
group5 = ones(1, numel(n5_NightSWRs_h))*5;
group6 = ones(1, numel(n6_NightSWRs_h))*6;
%group7 = ones(1, numel(n7_NightSWRs_h))*7;

groups = [group2 group3 group4 group5 group6];
xes = [n2_NightSWRs_h n3_NightSWRs_h n4_NightSWRs_h n5_NightSWRs_h n6_NightSWRs_h];
yes = [n2_NightSWRs_w n3_NightSWRs_w n4_NightSWRs_w n5_NightSWRs_w n6_NightSWRs_w];
yes_ms = yes/Fs*1000;
h = scatterhist(yes_ms,xes,'Group',groups,'Kernel','on', 'Location','SouthEast',...
    'Direction','out', 'LineStyle',{'-','-'}, 'Marker','..', 'color', cols);

hold on;
clr = get(h(1),'colororder');
boxplot(h(3),xes,groups,'orientation','horizontal',...
    'label',{'','','','',''},'color',cols, 'plotstyle', 'compact', 'Whisker', 10);
boxplot(h(2),yes_ms,groups,'orientation','horizontal',...
    'label', {'','','','',''},'color',cols, 'plotstyle', 'compact', 'Whisker', 10);
%set(h(2:3),'XTickLabel','');
view(h(3),[270,90]);  % Rotate the Y plot
axis(h(1),'auto');  % Sync axes
hold off;



saveName = [plotDir  'Final_Scatterplot_Nights_hist_amp'];

plotpos = [0 0 10 10];

print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);



%%
allSWRNight_H = {n2_NightSWRs_h; n3_NightSWRs_h; n4_NightSWRs_h; n5_NightSWRs_h; n6_NightSWRs_h};
allSWRNight_W = {n2_NightSWRs_w ;n3_NightSWRs_w ;n4_NightSWRs_w ;n5_NightSWRs_w ;n6_NightSWRs_w};

allnorm_h = [];
allnormLog_h = [];
allRanks_p = [];
allRanks_h = [];


for j = 1:numel(nightsOrder)
    for k = 1:numel(nightsOrder)
        
        [p_h, h_h] = ranksum(allSWRNight_H{j}, allSWRNight_H{k}, 'alpha', 0.05);
        [p_w, h_w] = ranksum(allSWRNight_W{j}, allSWRNight_W{k});
        
        [h_norm, p_norm, ] = lillietest(n2_NightSWRs_h);
        [h_log, p_log] = lillietest(log(n2_NightSWRs_w));

          mediansH = median(allSWRNight_H{j});
          mediansW = median(allSWRNight_W{j}/Fs*1000);
          
        sem_H = (std(allSWRNight_H{j}))/sqrt(numel(allSWRNight_H{j}));
        sem_W = (std(allSWRNight_W{j}/Fs*1000))/sqrt(numel(allSWRNight_W{j}/Fs*1000));

        allRanks_p_h(j,k) = p_h;
        allRanks_h_h(j,k) = h_h;
        
        allRanks_p_w(j,k) = p_w;
        allRanks_h_w(j,k) = h_w;
        
        allMedians_H(j,k) = mediansH;
        allMedians_W(j,k) = mediansW;
        
        allsem_H(j,k) = sem_H;
        allsem_W(j,k) = sem_W;
        
    end
end



allRanks_p(j,k) = p;
allRanks_h(j,k) = h;

allnorm_h(j) = h_norm;
allnormLog_h(j) = h_log;


[R,P] = corrcoef(xes, yes_ms, 'alpha', 0.001);



%%
SWR_rate = nWRs/binSize_s;

smoothWin = 5;
subplot(7, 1, [1] );
plot(smooth(ShWMeanAmp, smoothWin));
%plot(ShWMeanAmp);
axis tight

subplot(7, 1, [4] );
plot(smooth(ShWMeanWidth, smoothWin));
axis tight

subplot(7, 1, [7] );
plot(smooth(SWR_rate));
axis tight


 
%%Fs = 30000;
figure(100);clf
plot(n2_swrs_fs/Fs/3600, n2_swrs_w, 'k.'); axis tight; xlabel('Time (hr)'); ylabel('SWR amplitude (uV)')


ylim([80 450])
subplot(7, 1, [5 6]); plot(allSWR_fs/Fs/3600, allSWR_W_fs/Fs*1000, 'k.'); axis tight; xlabel('Time (hr)'); ylabel('SWR width (ms)')
ylim([1 150])












end
