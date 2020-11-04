function [] = plotMLDNeurons()
dbstop if error

figDir = '/media/dlc/Data8TB/TUM/OT/OTProject/MLD/ForPaper/';

ot18 = [2772; 2308; 1819; 2020; 2362; 2706; 2838; 2613; 2438; 2577; 2888; 3221; 3206]; %13
ot17 = [2438; 2577; 2888; 3221; 3206; 2771; 3377; 3377]; %
ot16 = [3227; 3545; 3575];
ot15 = [2766; 3073; 3334; 2251];
ot14 = [2743; 2807; 2479; 3086];
ot13 = [2976; 2663; 2163; 2726];
ot12 = [2086; 2515; 2576; 2969];
ot11 = [2352; 2582];


%cols = redblue(8); % not good, some white entries

cols = {[0.6350, 0.0780, 0.1840], [0.8500, 0.3250, 0.0980], [0.9290, 0.6940, 0.1250], [0.4940, 0.1840, 0.5560], [0, 0.5, 0],[0, 0.4470, 0.7410],[0 0 0], [.7 .3 .7], [.7 .5 .7], [.7 .9 .7]};

figure(100); clf

for j = 1:8

    switch j
        case 1
            thisData = ot18;
        case 2
            thisData = ot17;
        case 3
            thisData = ot16;
        case 4
            thisData = ot15;
        case 5
            thisData = ot14;
        case 6
            thisData = ot13;        
        case 7
            thisData = ot12;
        case 8
            thisData = ot11;
    end
    xes =[];
    xes = ones(1, numel(thisData))*j;
    hold on
    thisCol = cols{j};
    plot(xes, thisData, 'ko',  'MarkerFaceColor', 'k', 'linestyle', 'none')
    
    
end

set(gca, 'YDir','reverse')

xlim([-30 30])
ylim([1500 4000])
set(gca,'xtick',[])

saveName = [figDir 'DepthLocations'];
plotpos = [0 0 15 10];

print_in_A4(0, saveName, '-djpeg', 0, plotpos);
print_in_A4(0, saveName, '-depsc', 0, plotpos);


disp('')

end