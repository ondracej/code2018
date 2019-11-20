function [] = doStatisticsOnSWRs()


%Chick 02
b1 = load('D:\TUM\SWR-Project\Chick-02\20180430\17-29-04\Analysis\vDetections');

%Chick 09
b2 = load('D:\TUM\SWR-Project\Chick-09\20190328\18-39-42\Analysis\vDetections');

%Chick 10
b3 = load('D:\TUM\SWR-Project\Chick-10\20190427\22-20-26\Analysis\vDetections');

%Zf 59
b4 = load('D:\TUM\SWR-Project\ZF-59-15\20190428\18-48-02\Analysis\vDetections');

%Zf 68
b5 = load('D:\TUM\SWR-Project\ZF-60-88\20190429\16-26-20\Analysis\vDetections');

%Zf 71 anastheisa
b6 = load('D:\TUM\SWR-Project\ZF-71-76\20190915\18-46-58_acute\Analysis\vDetections');

%Zf 71 chronic
b7 = load('D:\TUM\SWR-Project\ZF-71-76\20190919\17-51-46\Analysis\vDetections');

%%
Fs = 30000;

%Chickens
%cols = {[0.6350, 0.0780, 0.1840], [0.8500, 0.3250, 0.0980], [0.9290, 0.6940, 0.1250], [0.4940, 0.1840, 0.5560], [0, 0.5, 0],[0, 0.4470, 0.7410],[0, 0.75, 0.75], [.7 .3 .7], [.7 .5 .7], [.7 .9 .7]};
cols = {[0.6350, 0.0780, 0.1840], [0.8500, 0.3250, 0.0980], [0.9290, 0.6940, 0.1250], [0.4940, 0.1840, 0.5560], [0, 0.5, 0],[0, 0.4470, 0.7410],[0 0 0], [.7 .3 .7], [.7 .5 .7], [.7 .9 .7]};

figure (101); clf
cnt = 1;

for j = 1:3
    
    eval(['allSWR_H = b' num2str(j) '.allSWR.allSWR_H;']);
    eval(['allSWR_W_fs = b' num2str(j) '.allSWR.allSWR_W_fs;']);
    
    eval(['allSW_H = b' num2str(j) '.allSW.allSW_H;']);
    eval(['allSW_W_fs = b' num2str(j) '.allSW.allSW_W_fs;']);
    
    allSWR_W_ms = allSWR_W_fs/Fs*1000;
    allSW_W_ms = allSW_W_fs/Fs*1000;
    
    Chicken_SWR_H{j} = allSWR_H;
    Chicken_SWR_H_sem(j) = (std(allSWR_H))/(sqrt(size(allSWR_H, 2)));
    
    Chicken_SWR_H_mean(j) = mean(allSWR_H);
    Chicken_SWR_H_median(j) = median(allSWR_H);
    
    Chicken_SWR_W{j} = allSWR_W_ms;
    Chicken_SWR_W_sem(j) = (std(allSWR_W_ms))/(sqrt(size(allSWR_W_ms, 2)));
    
    Chicken_SWR_W_mean(j) = mean(allSWR_W_ms);
    Chicken_SWR_W_median(j) = median(allSWR_W_ms);
    
    Chicken_SW_H{j} = allSW_H;
    Chicken_SW_H_sem(j) = (std(allSW_H))/(sqrt(size(allSW_H, 2)));
    
    Chicken_SW_H_mean(j) = mean(allSW_H);
    Chicken_SW_H_median(j) = median(allSW_H);
    
    Chicken_SW_W{j} = allSW_W_ms;
    Chicken_SW_W_sem{j} = (std(allSW_W_ms))/(sqrt(size(allSW_W_ms, 2)));
    
    Chicken_SW_W_mean(j) = mean(allSW_W_ms);
    Chicken_SW_W_median(j) = median(allSW_W_ms);
    
    
    jitterAmount = 0.25;
    jitterValuesX = 2*(rand(size(allSWR_H))-0.5)*jitterAmount;   % +/-jitterAmount max
    jitterValuesY = 2*(rand(size(allSWR_H))-0.5)*jitterAmount;   % +/-jitterAmount max
    
    % SWR H
    subplot(2, 2, 1)
    plot(jitterValuesX+cnt, jitterValuesY+allSWR_H, 'Marker','.', 'linestyle', 'none', 'color', cols{j})
    hold on
    line([cnt-(jitterAmount+.1) cnt+(jitterAmount+.1)], [Chicken_SWR_H_mean(j) Chicken_SWR_H_mean(j)], 'color', 'k', 'linewidth', 2, 'linestyle', ':') % mean
    line([cnt-(jitterAmount+.1) cnt+(jitterAmount+.1)], [Chicken_SWR_H_median(j) Chicken_SWR_H_median(j)], 'color', 'k', 'linewidth', 2) % median
    
    % SWR W
    subplot(2, 2, 2)
    plot(jitterValuesX+cnt, jitterValuesY+allSWR_W_ms, 'Marker','.', 'linestyle', 'none', 'color', cols{j})
    hold on
    line([cnt-(jitterAmount+.1) cnt+(jitterAmount+.1)], [Chicken_SWR_W_mean(j) Chicken_SWR_W_mean(j)], 'color', 'k', 'linewidth', 2, 'linestyle', ':') % mean
    line([cnt-(jitterAmount+.1) cnt+(jitterAmount+.1)], [Chicken_SWR_W_median(j) Chicken_SWR_W_median(j)], 'color', 'k', 'linewidth', 2) % median
    
    subplot(2, 2, 1)
    
    jitterValuesX = 2*(rand(size(allSW_H))-0.5)*jitterAmount;   % +/-jitterAmount max
    jitterValuesY = 2*(rand(size(allSW_H))-0.5)*jitterAmount;   % +/-jitterAmount max
    
    cnt = cnt+1;
    % SW H
    subplot(2, 2, 1)
    plot(jitterValuesX+cnt, jitterValuesY+allSW_H, 'Marker','.', 'linestyle', 'none', 'color', cols{j})
    hold on
    line([cnt-(jitterAmount+.1) cnt+(jitterAmount+.1)], [Chicken_SW_H_mean(j) Chicken_SW_H_mean(j)], 'color', 'k', 'linewidth', 2, 'linestyle', ':') % mean
    line([cnt-(jitterAmount+.1) cnt+(jitterAmount+.1)], [Chicken_SW_H_median(j) Chicken_SW_H_median(j)], 'color', 'k', 'linewidth', 2) % median
    
    % SW W
    subplot(2, 2, 2)
    plot(jitterValuesX+cnt, jitterValuesY+allSW_W_ms, 'Marker','.', 'linestyle', 'none', 'color', cols{j})
    hold on
    line([cnt-(jitterAmount+.1) cnt+(jitterAmount+.1)], [Chicken_SW_W_mean(j) Chicken_SW_W_mean(j)], 'color', 'k', 'linewidth', 2, 'linestyle', ':') % mean
    line([cnt-(jitterAmount+.1) cnt+(jitterAmount+.1)], [Chicken_SW_W_median(j) Chicken_SW_W_median(j)], 'color', 'k', 'linewidth', 2) % median
    cnt = cnt+1;
    
end


figure(203); clf
subplot(2, 2, 1)

subplot(2, 2, 1)
axis tight
ylim([0 2000])
subplot(2, 2, 2)
axis tight
ylim([0 150])

%% chicken cumdists

figure(103);
subplot(1, 2, 1); cla
for j = 1:3
    
    bincenters = 100:20:1650;
    
    thisChickenH_SWR = Chicken_SWR_H{j};
    [cx, cy] = hist(thisChickenH_SWR, bincenters);
    bla_z = cumsum(cx) ./ sum(cx);
    
    
    hold on
    plot(cy, bla_z, 'color', cols{j}, 'linewidth', 2)
    
    thisChickenH_SW = Chicken_SW_H{j};
    [cx, cy] = hist(thisChickenH_SW, bincenters);
    bla_z = cumsum(cx) ./ sum(cx);
    
    plot(cy, bla_z, 'color', cols{j}, 'linewidth', 2, 'linestyle', ':')
    
end
subplot(1, 2, 1)
axis tight

subplot(1, 2, 2); cla
for j = 1:3
    
    bincenters = 1:5:130;
    
    thisChickenW_SWR = Chicken_SWR_W{j};
    [cx, cy] = hist(thisChickenW_SWR, bincenters);
    bla_z = cumsum(cx) ./ sum(cx);
    
    hold on
    plot(cy, bla_z, 'color', cols{j}, 'linewidth', 2)
    
    thisChickenW_SW = Chicken_SW_W{j};
    [cx, cy] = hist(thisChickenW_SW, bincenters);
    bla_z = cumsum(cx) ./ sum(cx);
    
    plot(cy, bla_z, 'color', cols{j}, 'linewidth', 2, 'linestyle', ':')
    
end
subplot(1, 2, 2)
axis tight


plotDir = 'D:\TUM\SWR-Project\Figs\';

saveName = [plotDir 'ChickenSWStats'];
plotpos = [0 0 15 6];

print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);


%% Normal tests

for o = 1:3
    
    [h_H(o),p_H(o)] = lillietest(Chicken_SWR_H{o});
    [h_W(o),p_W(o)] = lillietest(Chicken_SWR_W{o});
    
    %[h2_H(o),p2_H(o)] = lillietest(log(Chicken_SWR_H{o}));
    %[h2_W(o),p2_W(o)] = lillietest(log(Chicken_SWR_W{o}));
    
end


%% Ranksum within

all_p_H = [];
all_h_H = [];
all_p_W = [];
all_h_W = [];
%for o = 1:3
    for o = 4:6
    
    %[p_H,h_H] = ranksum(Chicken_SWR_H{o}, Chicken_SW_H{o});
    %[p_W,h_W] = ranksum(Chicken_SWR_W{o}, Chicken_SW_W{o});
    
    [p_H,h_H] = ranksum(ZF_SWR_H{o}, ZF_SW_H{o});
    [p_W,h_W] = ranksum(ZF_SWR_W{o}, ZF_SW_W{o});
    
    
    all_p_H(o) = p_H;
    all_h_H(o) = h_H;
    
    all_p_W(o) = p_W;
    all_h_W(o) = h_W;
    
    %[h2_H(o),p2_H(o)] = lillietest(log(Chicken_SWR_H{o}));
    %[h2_W(o),p2_W(o)] = lillietest(log(Chicken_SWR_W{o}));
    
end

%%  Ranksum across
all_p_H = [];
all_h_H = [];
all_p_W = [];
all_h_W = [];
for o = 1:3
    for q = 1:3
        
        [p_H, h_H] = ranksum(Chicken_SWR_H{o}, Chicken_SWR_H{q});
        
        all_p_H(o,q) = p_H;
        all_h_H(o,q) = h_H;
        
        [p_W, h_W] = ranksum(Chicken_SWR_W{o}, Chicken_SWR_W{q});
        
        all_p_W(o,q) = p_W;
        all_h_W(o,q) = h_W;
        %[h2_H(o),p2_H(o)] = lillietest(log(Chicken_SWR_H{o}));
        %[h2_W(o),p2_W(o)] = lillietest(log(Chicken_SWR_W{o}));
    end
end



%%

figure(305);clf

inds = [4 5 6 7];

for k = 1:4
    
    j = inds(k);
    
    eval(['allSWR_H = b' num2str(j) '.allSWR.allSWR_H;']);
    eval(['allSWR_W_fs = b' num2str(j) '.allSWR.allSWR_W_fs;']);
    
    eval(['allSW_H = b' num2str(j) '.allSW.allSW_H;']);
    eval(['allSW_W_fs = b' num2str(j) '.allSW.allSW_W_fs;']);
    
    allSWR_W_ms = allSWR_W_fs/Fs*1000;
    allSW_W_ms = allSW_W_fs/Fs*1000;
    
    ZF_SWR_H{j} = allSWR_H;
    ZF_SWR_H_sem(j) = (std(allSWR_H))/(sqrt(size(allSWR_H, 2)));
    
    ZF_SWR_H_mean(j) = mean(allSWR_H);
    ZF_SWR_H_median(j) = median(allSWR_H);
    
    ZF_SWR_W{j} = allSWR_W_ms;
    ZF_SWR_W_sem(j) = (std(allSWR_W_ms))/(sqrt(size(allSWR_W_ms, 2)));
    
    ZF_SWR_W_mean(j) = mean(allSWR_W_ms);
    ZF_SWR_W_median(j) = median(allSWR_W_ms);
    
    ZF_SW_H{j} = allSW_H;
    ZF_SW_H_sem(j) = (std(allSW_H))/(sqrt(size(allSW_H, 2)));
    
    ZF_SW_H_mean(j) = mean(allSW_H);
    ZF_SW_H_median(j) = median(allSW_H);
    
    ZF_SW_W{j} = allSW_W_ms;
    ZF_SW_W_sem{j} = (std(allSW_W_ms))/(sqrt(size(allSW_W_ms, 2)));
    
    ZF_SW_W_mean(j) = mean(allSW_W_ms);
    ZF_SW_W_median(j) = median(allSW_W_ms);
    
    jitterAmount = 0.25;
    jitterValuesX = 2*(rand(size(allSWR_H))-0.5)*jitterAmount;   % +/-jitterAmount max
    jitterValuesY = 2*(rand(size(allSWR_H))-0.5)*jitterAmount;   % +/-jitterAmount max
    
    % SWR H
    subplot(2, 2, 1)
    plot(jitterValuesX+cnt, jitterValuesY+allSWR_H, 'Marker','.', 'linestyle', 'none', 'color', cols{j})
    hold on
    line([cnt-(jitterAmount+.1) cnt+(jitterAmount+.1)], [ZF_SWR_H_mean(j) ZF_SWR_H_mean(j)], 'color', 'k', 'linewidth', 2, 'linestyle', ':') % mean
    line([cnt-(jitterAmount+.1) cnt+jitterAmount], [ZF_SWR_H_median(j) ZF_SWR_H_median(j)], 'color', 'k', 'linewidth', 2) % median
    
    % SWR W
    subplot(2, 2, 2)
    plot(jitterValuesX+cnt, jitterValuesY+allSWR_W_ms, 'Marker','.', 'linestyle', 'none', 'color', cols{j})
    hold on
    line([cnt-(jitterAmount+.1) cnt+(jitterAmount+.1)], [ZF_SWR_W_mean(j) ZF_SWR_W_mean(j)], 'color','k', 'linewidth', 2, 'linestyle', ':') % mean
    line([cnt-(jitterAmount+.1) cnt+jitterAmount], [ZF_SWR_W_median(j) ZF_SWR_W_median(j)], 'color', 'k', 'linewidth', 2) % median
    
    subplot(2, 2, 1)
    
    jitterValuesX = 2*(rand(size(allSW_H))-0.5)*jitterAmount;   % +/-jitterAmount max
    jitterValuesY = 2*(rand(size(allSW_H))-0.5)*jitterAmount;   % +/-jitterAmount max
    
    cnt = cnt+1;
    % SW H
    subplot(2, 2, 1)
    plot(jitterValuesX+cnt, jitterValuesY+allSW_H, 'Marker','.', 'linestyle', 'none', 'color', cols{j})
    hold on
    line([cnt-(jitterAmount+.1) cnt+(jitterAmount+.1)], [ZF_SW_H_mean(j) ZF_SW_H_mean(j)], 'color', 'k', 'linewidth', 2, 'linestyle', ':') % mean
    line([cnt-(jitterAmount+.1) cnt+jitterAmount], [ZF_SW_H_median(j) ZF_SW_H_median(j)], 'color', 'k', 'linewidth', 2) % median
    
    % SW W
    subplot(2, 2, 2)
    plot(jitterValuesX+cnt, jitterValuesY+allSW_W_ms, 'Marker','.', 'linestyle', 'none', 'color', cols{j})
    hold on
    line([cnt-(jitterAmount+.1) cnt+(jitterAmount+.1)], [ZF_SW_W_mean(j) ZF_SW_W_mean(j)], 'color', 'k', 'linewidth', 2, 'linestyle', ':') % mean
    line([cnt-(jitterAmount+.1) cnt+jitterAmount], [ZF_SW_W_median(j) ZF_SW_W_median(j)], 'color', 'k', 'linewidth', 2) % median
    cnt = cnt+1;
    
end


subplot(2, 2, 1)
axis tight
ylim([0 1000])
subplot(2, 2, 2)
axis tight
ylim([0 150])

%%

figure(242); clf
subplot(1, 2, 1); cla
for j = 4:7
    
    bincenters = 20:10:700;
    
    thisZF_H_SWR = ZF_SWR_H{j};
    [cx, cy] = hist(thisZF_H_SWR, bincenters);
    bla_z = cumsum(cx) ./ sum(cx);
    
    
    hold on
    plot(cy, bla_z, 'color', cols{j}, 'linewidth', 2)
    
    thisZF_H_SW = ZF_SW_H{j};
    [cx, cy] = hist(thisZF_H_SW, bincenters);
    bla_z = cumsum(cx) ./ sum(cx);
    
    plot(cy, bla_z, 'color', cols{j}, 'linewidth', 2, 'linestyle', ':')
    
end
subplot(1, 2, 1)
axis tight

subplot(1, 2, 2); cla
for j = 4:7
    
    bincenters = 10:5:130;
    
    thisZF_W_SWR = ZF_SWR_W{j};
    [cx, cy] = hist(thisZF_W_SWR, bincenters);
    bla_z = cumsum(cx) ./ sum(cx);
    
    hold on
    plot(cy, bla_z, 'color', cols{j}, 'linewidth', 2)
    
    thisZF_W_SW = ZF_SW_W{j};
    [cx, cy] = hist(thisZF_W_SW, bincenters);
    bla_z = cumsum(cx) ./ sum(cx);
    
    plot(cy, bla_z, 'color', cols{j}, 'linewidth', 2, 'linestyle', ':')
    
end
subplot(1, 2, 2)
axis tight

plotDir = 'D:\TUM\SWR-Project\Figs\';

saveName = [plotDir 'ZFSWStats'];
plotpos = [0 0 15 6];

print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);


%%
all_p_H = [];
all_h_H = [];
all_p_W = [];
all_h_W = [];
%for o = 1:3
    for o = 4:6
    
    %[p_H,h_H] = ranksum(Chicken_SWR_H{o}, Chicken_SW_H{o});
    %[p_W,h_W] = ranksum(Chicken_SWR_W{o}, Chicken_SW_W{o});
    
    [p_H,h_H] = ranksum(ZF_SWR_H{o}, ZF_SW_H{o});
    [p_W,h_W] = ranksum(ZF_SWR_W{o}, ZF_SW_W{o});
    
    
    all_p_H(o) = p_H;
    all_h_H(o) = h_H;
    
    all_p_W(o) = p_W;
    all_h_W(o) = h_W;
    
    %[h2_H(o),p2_H(o)] = lillietest(log(Chicken_SWR_H{o}));
    %[h2_W(o),p2_W(o)] = lillietest(log(Chicken_SWR_W{o}));
    
    end


%%

N7 = b7.allSWR.allSWR_fs;  

n5_sTo8_s = 15+8*60+2*60;
nightOn = n5_sTo8_s*Fs;
nightOff = nightOn+12*3600*Fs;

n5_inds =  find(N7 >= nightOn & N7 < nightOff); 

ZF7_SWRs_H_night = ZF_SWR_H{7}(n5_inds);
ZF7_SWRs_W_night = ZF_SWR_W{7}(n5_inds);

Chronic_n = numel(ZF7_SWRs_H_night);
bla = randperm(Chronic_n);
inds = bla(1:1000);

ZF7_SWRs_H = ZF7_SWRs_H_night(inds);
ZF7_SWRs_W = ZF7_SWRs_W_night(inds);

figure(311);clf;

group1 = ones(1, numel(Chicken_SWR_H{1}))*7;
group2 = ones(1, numel(Chicken_SWR_H{2}))*6;
group3 = ones(1, numel(Chicken_SWR_H{3}))*5;
group4 = ones(1, numel(ZF_SWR_H{4}))*4;
group5 = ones(1, numel(ZF_SWR_H{5}))*3;
group6 = ones(1, numel(ZF_SWR_H{6}))*2;
group7 = ones(1, numel(ZF7_SWRs_H))*1;

%groups = [group1 group2 group3 group4 group5 group6 group7 ];
groups = [group7 group6 group5 group4 group3 group2 group1 ];
%xes = [Chicken_SWR_H{1} Chicken_SWR_H{2} Chicken_SWR_H{3} ZF_SWR_H{4} ZF_SWR_H{5} ZF_SWR_H{6} ZF_SWR_H{7}];
xes = [ZF7_SWRs_H ZF_SWR_H{6} ZF_SWR_H{5} ZF_SWR_H{4} Chicken_SWR_H{3} Chicken_SWR_H{2} Chicken_SWR_H{1}];
%yes = [Chicken_SWR_W{1} Chicken_SWR_W{2} Chicken_SWR_W{3} ZF_SWR_W{4} ZF_SWR_W{5} ZF_SWR_W{6} ZF_SWR_W{7}];
yes = [ZF7_SWRs_W  ZF_SWR_W{6} ZF_SWR_W{5} ZF_SWR_W{4} Chicken_SWR_W{3} Chicken_SWR_W{2} Chicken_SWR_W{1}];
h = scatterhist(xes,yes,'Group',groups,'Kernel','on', 'Location','SouthEast',...
    'Direction','out', 'LineStyle',{'-','-'}, 'Marker','..', 'color', [[0 0 0] ;cols{6} ;cols{5} ;cols{4}; cols{3} ;cols{2} ;cols{1}]);




groups_text = num2str(groups);
hold on;
clr = [[0 0 0 ]; cols{6} ;cols{5} ;cols{4}; cols{3} ;cols{2} ;cols{1}];
boxplot(h(2),xes,groups,'orientation','horizontal',...
    'label',{'','','','','','',''},'color',clr, 'plotstyle', 'compact', 'Whisker', 10);
boxplot(h(3),yes,groups,'orientation','horizontal',...
    'label', {'','','','','','',''},'color',clr, 'plotstyle', 'compact', 'Whisker', 10);
%set(h(2:3),'XTickLabel','');
view(h(3),[270,90]);  % Rotate the Y plot
axis(h(1),'auto');  % Sync axes
hold off;

saveName = [plotDir 'ZFChickenSWStats'];
plotpos = [0 0 20 12];

print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);



allData_H = {Chicken_SWR_H{1} Chicken_SWR_H{2} Chicken_SWR_H{3} ZF_SWR_H{4} ZF_SWR_H{5} ZF_SWR_H{6} ZF7_SWRs_H_night};
allData_W = {Chicken_SWR_W{1} Chicken_SWR_W{2} Chicken_SWR_W{3} ZF_SWR_W{4} ZF_SWR_W{5} ZF_SWR_W{6} ZF7_SWRs_W_night};


for j = 1:7
    for k = 1:7
        
        thisMed_H = median(allData_H{j});
        thissem_H = std(allData_H{j})/sqrt(numel(allData_H{j}));
        
        thisMed_W = median(allData_W{j});
        thissem_W = std(allData_W{j})/sqrt(numel(allData_W{j}));
        
        [p_H, h_H] = ranksum(allData_H{j}, allData_H{k});
        [p_W, h_W] = ranksum(allData_W{j}, allData_W{k});
        
        allMed_H(j,k) = thisMed_H;
        allSEM_H(j,k) = thissem_H;
        allMed_W(j,k) = thisMed_W;
        allSEM_W(j,k) = thissem_W;
        
        all_p_H(j,k) = p_H;
        all_h_H(j,k) = h_H;
        
        all_p_W(j,k) = p_W;
        all_h_W(j,k) = h_W;
    end
end
%%

 Chicken_SWR_H{j} = allSWR_H;
    Chicken_SWR_H_sem(j) = (std(allSWR_H))/(sqrt(size(allSWR_H, 2)));
    
    Chicken_SWR_H_mean(j) = mean(allSWR_H);
    Chicken_SWR_H_median(j) = median(allSWR_H);
    
    Chicken_SWR_W{j} = allSWR_W_ms;
    Chicken_SWR_W_sem(j) = (std(allSWR_W_ms))/(sqrt(size(allSWR_W_ms, 2)));
    
    Chicken_SWR_W_mean(j) = mean(allSWR_W_ms);
    Chicken_SWR_W_median(j) = median(allSWR_W_ms);
    
    Chicken_SW_H{j} = allSW_H;
    Chicken_SW_H_sem(j) = (std(allSW_H))/(sqrt(size(allSW_H, 2)));
    
    Chicken_SW_H_mean(j) = mean(allSW_H);
    Chicken_SW_H_median(j) = median(allSW_H);
    
    Chicken_SW_W{j} = allSW_W_ms;
    Chicken_SW_W_sem{j} = (std(allSW_W_ms))/(sqrt(size(allSW_W_ms, 2)));
    
    Chicken_SW_W_mean(j) = mean(allSW_W_ms);
    Chicken_SW_W_median(j) = median(allSW_W_ms);
    
    
    %%
figure (532)

group1 = ones(1, numel(Chicken_SWR_H{1}))*1;
group2 = ones(1, numel(Chicken_SW_H{1}))*2;
group3 = ones(1, numel(Chicken_SWR_H{2}))*3;
group4 = ones(1, numel(Chicken_SW_H{2}))*4;
group5 = ones(1, numel(Chicken_SWR_H{3}))*5;
group6 = ones(1, numel(Chicken_SW_H{3}))*6;





groups = [group1 group2 group3 group4 group5 group6];
xes = [Chicken_SWR_H{1} Chicken_SW_H{1} Chicken_SWR_H{2} Chicken_SW_H{2} Chicken_SWR_H{3} Chicken_SW_H{3}];

clr = [cols{1} ;cols{1} ;cols{2}; cols{2} ;cols{3} ;cols{3}];

boxplot(xes,groups,'orientation','vertical',...
    'label',{'','','','','',''},'color',clr, 'plotstyle', 'compact', 'Whisker', 10);




%%



figure (104);clf
bincenters = 1:20:1600;

x1 = Chicken_SWR_H{1};
x2 = Chicken_SWR_H{2};
x3 = Chicken_SWR_H{3};

h1 = histogram(x1, bincenters);
hold on
h2 = histogram(x2, bincenters);
h3 = histogram(x3, bincenters);

% h1 = histogram(log(x1));
% hold on
% h2 = histogram(log(x2));
% h3 = histogram(log(x3));

h1.Normalization = 'probability';
h1.BinWidth = 20;
h1.FaceColor = cols{1};
h2.Normalization = 'probability';
h2.BinWidth = 20;
h1.FaceColor = cols{2};
h3.Normalization = 'probability';
h3.BinWidth = 20;
h1.FaceColor = cols{3};

[mu,sigma] = lognfit(Chicken_SWR_H{1});

mu = mu(1);
sigma = sigma(1);

pd = makedist('Lognormal','mu',mu,'sigma',sigma);
x = Chicken_SWR_H{1};
y = pdf(pd,x);
figure
plot(x, y);



end