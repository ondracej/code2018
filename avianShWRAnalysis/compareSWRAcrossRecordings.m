function []  = compareSWRAcrossRecordings()

%% ZF

%Chick 02
b1 = load('D:\TUM\SWR-Project\Chick-02\20180430\17-29-04\Analysis\SWRs');

%Chick 09
b2 = load('D:\TUM\SWR-Project\Chick-09\20190328\18-39-42\Analysis\SWRs');

%Chick 10
b3 = load('D:\TUM\SWR-Project\Chick-10\20190427\22-20-26\Analysis\SWRs');

%Zf 59
b4 = load('D:\TUM\SWR-Project\ZF-59-15\20190428\18-48-02\Analysis\SWRs');

%Zf 68
b5 = load('D:\TUM\SWR-Project\ZF-60-88\20190429\16-26-20\Analysis\SWRs');

%Zf 71 anastheisa
b6 = load('D:\TUM\SWR-Project\ZF-71-76\20190915\18-46-58_acute\Analysis\SWRs');

%Zf 71 chronic
b7 = load('D:\TUM\SWR-Project\ZF-71-76\20190919\17-51-46\Analysis\SWRs');

%%
figure(201);clf
tSW = b7.SWR.tSW;
%cols = {[.1 .3 .3], [0.7 0.1 0.5], [.5 .3 .3], [.7 .3 .3], [.9 .3 .3], [.7 .7 .7], [.7 .3 .7], [.7 .5 .7], [.7 .9 .7]};
cols = {[0.6350, 0.0780, 0.1840], [0.8500, 0.3250, 0.0980], [0.9290, 0.6940, 0.1250], [0.4940, 0.1840, 0.5560], [0, 0.5, 0],[0, 0.4470, 0.7410],[0, 0.75, 0.75], [.7 .3 .7], [.7 .5 .7], [.7 .9 .7]};

offset = 0;
for j = 1:3
    
    eval(['thisSWR_mean = b' num2str(j) '.SWR.allSWR_mean;']);
    eval(['thisSWR_sem = b' num2str(j) '.SWR.allSWR_sem;']);
    eval(['thisRipple_mean = b' num2str(j) '.SWR.all_ripple_mean;']);
    eval(['thisRipple_sem = b' num2str(j) '.SWR.all_ripple_sem;']);
    
    
    %thisSWR_mean = thisSWR_mean+ offset;
    subplot(2, 2, 1)
    plot(tSW, thisSWR_mean,  'color', cols{j}, 'linewidth', 2);
    hold on
    plot(tSW, thisSWR_mean+thisSWR_sem,  'color', cols{j});
    plot(tSW, thisSWR_mean-thisSWR_sem,  'color', cols{j});
    %    jbfill(tSW, [thisSWR_mean+thisSWR_sem],[thisSWR_mean-thisSWR_sem],'k','k',[],.3);
    axis tight
    
    thisRipple_mean = thisRipple_mean+offset;
    subplot(2, 2, 3)
    plot(tSW, thisRipple_mean,  'color', cols{j}, 'linewidth', 2);
    hold on
    plot(tSW, thisRipple_mean+thisRipple_sem,  'color', cols{j});
    plot(tSW, thisRipple_mean-thisRipple_sem,  'color', cols{j});
    %jbfill(tSW, [thisRipple_mean+thisRipple_sem],[thisRipple_mean-thisRipple_sem],'k','k',[],.3);
    axis tight
    offset = offset + 30;
end
subplot(2, 2, 1)
legend({'1', 'a', '2', 'a', '3', 'a', '4', 'a'});

subplot(2, 2, 3)
%ylim([-20 80])

%
offset = 0;
for j = 4:7
    
    eval(['thisSWR_mean = b' num2str(j) '.SWR.allSWR_mean;']);
    eval(['thisSWR_sem = b' num2str(j) '.SWR.allSWR_sem;']);
    eval(['thisRipple_mean = b' num2str(j) '.SWR.all_ripple_mean;']);
    eval(['thisRipple_sem = b' num2str(j) '.SWR.all_ripple_sem;']);
    
    if j ==7
        cols = {'k', 'k', 'k', 'k', 'k', 'k', 'k', 'k', 'k', 'k', 'k'};
    end
    
    subplot(2, 2, 2)
    plot(tSW, thisSWR_mean, 'color', cols{j}, 'linewidth', 2);
    hold on
    plot(tSW, thisSWR_mean+thisSWR_sem,  'color', cols{j});
    plot(tSW, thisSWR_mean-thisSWR_sem,  'color', cols{j});
    axis tight
    
    thisRipple_mean = thisRipple_mean+offset;
    subplot(2, 2, 4)
    plot(tSW, thisRipple_mean,  'color', cols{j}, 'linewidth', 2);
    hold on
    %jbfill(tSW, [thisRipple_mean+thisRipple_sem],[thisRipple_mean-thisRipple_sem],'k','k',[],.3);
    plot(tSW, thisRipple_mean+thisRipple_sem,  'color', cols{j});
    plot(tSW, thisRipple_mean-thisRipple_sem,  'color', cols{j});
    axis tight
    offset = offset + 5;
end
subplot(2, 2, 2)
legend({'1', 'a', '2', 'a', '3', 'a', '4', 'a'});

subplot(2, 2, 4)
%ylim([-10 10])

%%

plotDir = 'D:\TUM\SWR-Project\Figs\';

saveName = [plotDir 'SWR_SpeciesComparison-2'];
plotpos = [0 0 15 15];

print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);




%%
















end