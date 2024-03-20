%% local waves

j_lw = 0.22
j_lw_err = 0.12


a_lw = 0.33
a_lw_err = 0.21


clf
x = 1:2;
data = [j_lw a_lw]';
errhigh = [j_lw_err a_lw_err ];
errlow  = [j_lw_err a_lw_err ];

bar(x,data)                

hold on

er = errorbar(x,data,errlow,errhigh);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  


figDir = '/home/janie/Dropbox/Writing/00_Articles/0_HamedsPaper/March2023/For submission/Review/New/NewFigs/';
FigName = 'Fig3_mean_lw';


saveName = [figDir FigName];

plotpos = [0 0 8 4]; %Fig 2
  print_in_A4(0, saveName, '-djpeg', 0, plotpos);
 print_in_A4(0, saveName, '-depsc', 3, plotpos);


%% Corrs

a_7294 = 0.7286;
a_7294_sd = 0.1137;

a_7303 = 0.7253;
a_7303_sd =  0.1435; 


a_7200 = 0.7323;
a_7200_sd = 0.1341;

j_w0009 = 0.6621;
j_w0009_sd = 0.1317

j_w0016 = 0.5416;
j_w0016_sd = 0.1934;

j_w0018 = 0.4953;
j_w0018_sd = 0.1874;

j_w0020 = 0.6890;
j_w0020_sd = 0.1663;

j_w0021 = 0.5767;
j_w0021_sd = 0.2727;

j_w0041 = 0.5828;
j_w0041_sd =  0.1589;

j_w0043 = 0.6711;
j_w0043_sd = 0.1128;

allCorrs = [j_w0009 j_w0016 j_w0018 j_w0020 j_w0021 j_w0041 j_w0043 a_7200 a_7303 a_7294];
markersA = {'+', '*', 'x', 'sq', 'd', 'v', '^', 'o', '<', '>'};
err = [j_w0009_sd j_w0016_sd j_w0018_sd j_w0020_sd j_w0021_sd j_w0041_sd j_w0043_sd a_7200_sd a_7303_sd a_7294_sd];

xes = 1:10; 
clf
for j = 1:10
    hold on
plot(xes(j), allCorrs(j), 'Marker', markersA{j}, 'linestyle', 'none');
errorbar(xes(j), allCorrs(j), err(j), 'LineStyle','none');
end
xlim([0 11])
ylim([0 1])



figDir = '/home/janie/Dropbox/Writing/00_Articles/0_HamedsPaper/March2023/For submission/Review/New/NewFigs/';
FigName = 'S-FigCorrs';

saveName = [figDir FigName];

plotpos = [0 0 10 4]; %Fig 2
  print_in_A4(0, saveName, '-djpeg', 0, plotpos);
 print_in_A4(0, saveName, '-depsc', 3, plotpos);


%% d/y means

juvenile_dy = 49.9
juvenile_dy_err = 32.2


adult_dy = 19.5
adult_dy_err = 8.4

%%

clf
x = 1:2;
data = [juvenile_dy adult_dy]';
errhigh = [juvenile_dy_err adult_dy_err ];
errlow  = [juvenile_dy_err adult_dy_err ];

bar(x,data)                

hold on

er = errorbar(x,data,errlow,errhigh);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
ylim([0 120])


figDir = '/home/janie/Dropbox/Writing/00_Articles/0_HamedsPaper/March2023/For submission/Review/New/NewFigs/';
FigName = 'Fig1_mean_dy';

saveName = [figDir FigName];

plotpos = [0 0 8 4]; %Fig 2
  print_in_A4(0, saveName, '-djpeg', 0, plotpos);
 print_in_A4(0, saveName, '-depsc', 3, plotpos);



%% Transitions

j_SWS_REM = 64.1078;
j_SWS_REM_err = 20.4814;

a_SWS_REM = 74.3958;
a_SWS_REM_err = 26.1723;
%%

j_SWS_IS = 68.9314;
j_SWS_IS_err = 21.7335;

a_SWS_IS = 40.0000;
a_SWS_IS_err = 15.6766;

%%

j_REM_SWS = 63.3088;
j_REM_SWS_err = 24.4164;

a_REM_SWS = 73.6354;
a_REM_SWS_err = 26.2031;

%%
j_REM_IS = 76.6814;
j_REM_IS_err = 37.9907;

a_REM_IS = 44.0208;
a_REM_IS_err = 16.1859;

%%
clf
subplot(1, 4, 1)
x = 1:2;
data = [j_SWS_REM a_SWS_REM]';
errhigh = [j_SWS_REM_err a_SWS_REM_err ];
errlow  = [j_SWS_REM_err a_SWS_REM_err ];

bar(x,data)                

hold on

er = errorbar(x,data,errlow,errhigh);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
ylim([0 120])
title('SWS-REM')
%%

subplot(1, 4, 2)
x = 1:2;
data = [j_REM_SWS a_REM_SWS]';
errhigh = [j_REM_SWS_err a_REM_SWS_err ];
errlow  = [j_REM_SWS_err a_REM_SWS_err ];

bar(x,data)                

hold on

er = errorbar(x,data,errlow,errhigh);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
ylim([0 120])
title('REM-SWS')
%%

subplot(1, 4, 3)
x = 1:2;
data = [j_SWS_IS a_SWS_IS]';
errhigh = [j_SWS_IS_err a_SWS_IS_err ];
errlow  = [j_SWS_IS_err a_SWS_IS_err ];

bar(x,data)                

hold on

er = errorbar(x,data,errlow,errhigh);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
ylim([0 120])
title('SWS-IS')
%%
subplot(1, 4, 4)
x = 1:2;
data = [j_REM_IS a_REM_IS]';
errhigh = [j_REM_IS_err a_REM_IS_err ];
errlow  = [j_REM_IS_err a_REM_IS_err ];

bar(x,data)                

hold on

er = errorbar(x,data,errlow,errhigh);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
ylim([0 120])
title('REM-IS')

figDir = '/home/janie/Dropbox/Writing/00_Articles/0_HamedsPaper/March2023/For submission/Review/New/NewFigs/';
FigName = 'Fig2-MeanTransitions';

saveName = [figDir FigName];

plotpos = [0 0 12 4]; %Fig 2
  print_in_A4(0, saveName, '-djpeg', 0, plotpos);
 print_in_A4(0, saveName, '-depsc', 3, plotpos);

%% Power in gamma and delta


gamma_juv = 0.004;
gamma_juv_err = 0.005;

gamma_adult = 0.0038;
gamma_adult_err = 0.0052;

delta_juv = 0.088;
delta_juv_err = 0.059;

delta_adult = 0.062;
delta_adult_err = 0.080;

%%
subplot(1, 2, 1)
x = 1:2;
data = [delta_juv delta_adult]';
errhigh = [delta_juv_err delta_adult_err ];
errlow  = [delta_juv_err delta_adult_err ];

bar(x,data)                

hold on

er = errorbar(x,data,errlow,errhigh);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
ylim([0 0.15])

subplot(1, 2, 2)
x = 1:2;
data = [gamma_juv gamma_adult ]';
errhigh = [gamma_juv_err gamma_adult_err ];
errlow  = [gamma_juv_err gamma_adult_err ];

bar(x,data)                

hold on

er = errorbar(x,data,errlow,errhigh);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  

ylim([0 10e-3])

figDir = '/home/janie/Dropbox/Writing/00_Articles/0_HamedsPaper/March2023/For submission/Review/New/NewFigs/SuppFig5//';
FigName = 'FigS2-gmaaDelta';

saveName = [figDir FigName];

plotpos = [0 0 12 8]; %Fig 2
  print_in_A4(0, saveName, '-djpeg', 0, plotpos);
 print_in_A4(0, saveName, '-depsc', 3, plotpos);
 



%% Nodes


NetworkSize_Adult = 8.2;
NetworkSize_Adult_err = 2.9;

NetworkSize_Juvenile = 4.2;
NetworkSize_Juvenile_err = 2.1;

NetworkNumber_Adult = 7.3;
NetworkNumber_Adult_err = 4.6;

NetworkNumber_Juvenile = 10.6;
NetworkNumber_Juvenile_err = 4.6;

%%
subplot(1, 2, 1)
x = 1:2;
data = [NetworkSize_Juvenile NetworkSize_Adult ]';
errhigh = [NetworkSize_Juvenile_err NetworkSize_Adult_err  ];
errlow  = [NetworkSize_Juvenile_err NetworkSize_Adult_err  ];

bar(x,data)                

hold on

er = errorbar(x,data,errlow,errhigh);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
%ylim([0 1])

subplot(1, 2, 2)
x = 1:2;
data = [NetworkNumber_Juvenile NetworkNumber_Adult  ]';
errhigh = [NetworkNumber_Juvenile_err NetworkNumber_Adult_err  ];
errlow  = [NetworkNumber_Juvenile_err NetworkNumber_Adult_err  ];

bar(x,data)                

hold on

er = errorbar(x,data,errlow,errhigh);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  

%ylim([0 1])

figDir = '/home/janie/Dropbox/Writing/00_Articles/0_HamedsPaper/March2023/For submission/Review/New/NewFigs/SuppFig5//';
FigName = 'FigS5-juvneiles';

saveName = [figDir FigName];

plotpos = [0 0 16 12]; %Fig 2
  print_in_A4(0, saveName, '-djpeg', 0, plotpos);
 print_in_A4(0, saveName, '-depsc', 3, plotpos);
 


%% CC analysis

LL_adults = 0.62;
LL_Adults_err = 0.16;

RR_adults = 0.57;
RR_Adults_err = 0.14;

LR_adults = 0.27;
LR_Adults_err = 0.15;


LL_juveniles = 0.54;
LL_juveniles_err = 0.15;

RR_juveniles = 0.51;
RR_juveniles_err = 0.11;

LR_juveniles = 0.26;
LR_juveniles_err = 0.16;

%%
subplot(1, 2, 1)
x = 1:3;
data = [LL_adults RR_adults LR_adults]';
errhigh = [LL_Adults_err RR_Adults_err LR_Adults_err];
errlow  = [LL_Adults_err RR_Adults_err LR_Adults_err];

bar(x,data)                

hold on

er = errorbar(x,data,errlow,errhigh);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
ylim([0 1])

subplot(1, 2, 2)
x = 1:3;
data = [LL_juveniles RR_juveniles LR_juveniles]';
errhigh = [LL_juveniles_err RR_juveniles_err LR_juveniles_err];
errlow  = [LL_juveniles_err RR_juveniles_err LR_juveniles_err];

bar(x,data)                

hold on

er = errorbar(x,data,errlow,errhigh);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  

ylim([0 1])

figDir = '/home/janie/Dropbox/Writing/00_Articles/0_HamedsPaper/March2023/For submission/Review/New/NewFigs/';
FigName = 'Fig2-StageByAge';
SEM
saveName = [figDir FigName];

plotpos = [0 0 14 4]; %Fig 2
  print_in_A4(0, saveName, '-djpeg', 0, plotpos);
 print_in_A4(0, saveName, '-depsc', 3, plotpos);
 

%% w043

%% 

SWS = 0.4832;
REM = 0.2324;
IS = 0.1186;
Wake = 0.1658;

meanSWS = mean(SWS);
meanREM = mean(REM);
meanIS = mean(IS);
meanWake = mean(Wake);


stdSWS = std(SWS);
stdREM = std(REM);
stdIS = std(IS);
stdWake = std(Wake);

semSWS = stdSWS/sqrt(numel(SWS));
semREM = stdREM/sqrt(numel(REM));
semIS = stdIS/sqrt(numel(IS));
semWake = stdWake/sqrt(numel(Wake));

birdID = 'w043';


%%

a1 = load('/home/janie/Data/HamedSleepSegments/72-00.mat');
a2 = load('/home/janie/Data/HamedSleepSegments/72-94.mat');
a3 = load('/home/janie/Data/HamedSleepSegments/73-03.mat');

j1 = load('/home/janie/Data/HamedSleepSegments/w009.mat');
j2 = load('/home/janie/Data/HamedSleepSegments/w016.mat');
j3 = load('/home/janie/Data/HamedSleepSegments/w021.mat');
j4 = load('/home/janie/Data/HamedSleepSegments/w041.mat');
j5 = load('/home/janie/Data/HamedSleepSegments/w043.mat');



%% SWS

figure(293); clf
subplot(3, 3, [1 2])

xes = [1 2 3 4 5];
j_sws = [j1.meanSWS j2.meanSWS j3.meanSWS j4.meanSWS j5.meanSWS*100];
j_sws_err = [j1.semSWS j2.semSWS j3.semSWS j4.semSWS j5.semSWS];

markers = {'+', '*', 'd','v', '^'};

for j = 1:5
hold on    
errorbar(xes(j), j_sws(j), j_sws_err(j), markers{j})
end

xesA = [7 8 9];
a_sws = [a1.meanSWS a2.meanSWS a3.meanSWS];
a_sws_err = [a1.semSWS a2.semSWS a3.semSWS];

markersA = {'<', 'o', '>'};

for j = 1:3
hold on    
errorbar(xesA(j), a_sws(j), a_sws_err(j), markersA{j})
end

xlim([0 10])
title('SWS')
ylim([0 60])
%%
subplot(2, 2, 1);

meanSWS_j = mean(j_sws);
stdSWS_j = std(j_sws);
semSWS_j = stdSWS_j/(sqrt(numel(j_sws)));

meanSWS_a = mean(a_sws);
stdSWS_a = std(a_sws);
semSWS_a = stdSWS_a/(sqrt(numel(a_sws)));

%errorbar(1, meanSWS_j, semSWS_j, 'o')
errorbar(1, meanSWS_j, stdSWS_j, 'o')
hold on
%errorbar(2, meanSWS_a, semSWS_a, 'o')
errorbar(2, meanSWS_a, stdSWS_a, 'o')

xlim([0 3])
title('SWS')
ylim([0 60])
%% REM
 
subplot(3, 3, [4 5])

xes = [1 2 3 4 5];
j_rem = [j1.meanREM j2.meanREM j3.meanREM j4.meanREM j5.meanREM*100];
j_is_err = [j1.semREM j2.semREM j3.semREM j4.semREM j5.semREM];

markers = {'+', '*', 'd','v', '^'};

for j = 1:5
hold on    
errorbar(xes(j), j_rem(j), j_is_err(j), markers{j})
end

xesA = [7 8 9];
a_rem = [a1.meanREM a2.meanREM a3.meanREM];
a_rem_err = [a1.semREM a2.semREM a3.semREM];

markersA = {'<', 'o', '>'};

for j = 1:3
hold on    
errorbar(xesA(j), a_rem(j), a_rem_err(j), markersA{j})
end

xlim([0 10])
title('REM')
ylim([0 60])
%%

subplot(3, 3, [6]);
subplot(2, 2, [2]);

meanREM_j = mean(j_rem);
stdREM_j = std(j_rem);
semREM_j = stdREM_j/(sqrt(numel(j_rem)));

meanREM_a = mean(a_rem);
stdREM_a = std(a_rem);
semREM_a = stdREM_a/(sqrt(numel(a_rem)));

%errorbar(1, meanREM_j, semREM_j, 'o')
errorbar(1, meanREM_j, stdREM_j, 'o')
hold on
%errorbar(2, meanREM_a, semREM_a, 'o')
errorbar(2, meanREM_a, stdREM_a, 'o')

xlim([0 3])
title('REM')
ylim([0 60])
%%  IS


subplot(3, 3, [7 8]); cla

xes = [1 2 3 4 5];
j_is = [j1.meanIS j2.meanIS j3.meanIS j4.meanIS j5.meanIS*100];
j_is_err = [j1.semIS j2.semIS j3.semIS j4.semIS j5.semIS];

markers = {'+', '*', 'd','v', '^'};

for j = 1:5
hold on    
errorbar(xes(j), j_is(j), j_is_err(j), markers{j})
end

xesA = [7 8 9];
a_is = [a1.meanIS a2.meanIS a3.meanIS];
a_is_err = [a1.semIS a2.semIS a3.semIS];

markersA = {'<', 'o', '>'};

for j = 1:3
hold on    
errorbar(xesA(j), a_is(j), a_is_err(j), markersA{j})
end

xlim([0 10])
ylim([0 60])
title('IS')

%%
subplot(3, 3, [9]);
subplot(2, 2, 3)

meanIS_j = mean(j_is);
stdIS_j = std(j_is);
semIS_j = stdIS_j/(sqrt(numel(j_is)));

meanIS_a = mean(a_is);
stdIS_a = std(a_is);
semIS_a = stdIS_a/(sqrt(numel(a_is)));

%errorbar(1, meanIS_j, semIS_j, 'o')
errorbar(1, meanIS_j, stdIS_j, 'o')
hold on
%errorbar(2, meanIS_a, semIS_a, 'o')
errorbar(2, meanIS_a, stdIS_a, 'o')

xlim([0 3])
title('IS')
ylim([0 60])


%%

%% SWS+IS

j1_swsis = j1.IS + j1.SWS;
j2_swsis = j2.IS + j2.SWS;
j3_swsis = j3.IS + j3.SWS;
j4_swsis = j4.IS + j4.SWS;
j5_swsis = j5.IS*100 + j5.SWS*100;

a1_swsis = a1.IS + a1.SWS;
a2_swsis = a2.IS + a2.SWS;
a3_swsis = a3.IS + a3.SWS;

%%
j1_meanSWSIS = mean(j1_swsis);
j2_meanSWSIS = mean(j2_swsis);
j3_meanSWSIS = mean(j3_swsis);
j4_meanSWSIS = mean(j4_swsis);
j5_meanSWSIS = mean(j5_swsis);

a1_meanSWSIS = mean(a1_swsis);
a2_meanSWSIS = mean(a2_swsis);
a3_meanSWSIS = mean(a3_swsis);


j1_stdSWSIS = std(j1_swsis);
j2_stdSWSIS = std(j2_swsis);
j3_stdSWSIS = std(j3_swsis);
j4_stdSWSIS = std(j4_swsis);
j5_stdSWSIS = std(j5_swsis);

a1_stdSWSIS = std(a1_swsis);
a2_stdSWSIS = std(a2_swsis);
a3_stdSWSIS = std(a3_swsis);

j1_semSWSIS = j1_stdSWSIS/sqrt(numel(j1_swsis));
j2_semSWSIS = j2_stdSWSIS/sqrt(numel(j2_swsis));
j3_semSWSIS = j3_stdSWSIS/sqrt(numel(j3_swsis));
j4_semSWSIS = j4_stdSWSIS/sqrt(numel(j4_swsis));
j5_semSWSIS = j5_stdSWSIS/sqrt(numel(j5_swsis));

a1_semSWSIS = a1_stdSWSIS/sqrt(numel(a1_swsis));
a2_semSWSIS = a2_stdSWSIS/sqrt(numel(a2_swsis));
a3_semSWSIS = a3_stdSWSIS/sqrt(numel(a3_swsis));


j_swsis = [j1_meanSWSIS j2_meanSWSIS j3_meanSWSIS j4_meanSWSIS j5_meanSWSIS];
j_swsis_err = [j1_semSWSIS j2_semSWSIS j3_semSWSIS j4_semSWSIS j5_semSWSIS];

a_swsis = [a1_meanSWSIS a2_meanSWSIS a3_meanSWSIS ];
a_swsis_err = [a1_semSWSIS a2_semSWSIS a3_semSWSIS ];

%%

subplot(2, 2, 4)

meanSWSIS_j = mean(j_swsis);
stdSWSIS_j = std(j_swsis);
semSWSIS_j = stdSWSIS_j/(sqrt(numel(j_swsis)));

meanSWSIS_a = mean(a_swsis);
stdSWSIS_a = std(a_swsis);
semSWSIS_a = stdSWSIS_a/(sqrt(numel(a_swsis)));

%errorbar(1, meanSWSIS_j, semSWSIS_j, 'o')
errorbar(1, meanSWSIS_j, stdSWSIS_j, 'o')
hold on
%errorbar(2, meanSWSIS_a, semSWSIS_a, 'o')
errorbar(2, meanSWSIS_a, stdSWSIS_a, 'o')

xlim([0 3])
title('SWS+IS')
ylim([0 60])


%% 
xes = [1 2 3 4 5];
markers = {'+', '*', 'd','v', '^'};
for j = 1:5
hold on    
errorbar(xes(j), j_swsis(j), j_swsis_err(j), markers{j})
end

%%

xesA = [7 8 9];
markersA = {'<', 'o', '>'};

for j = 1:3
hold on    
errorbar(xesA(j), a_swsis(j), a_swsis_err(j), markersA{j})
end

xlim([0 10])
ylim([0 65])

%%


subplot(2, 2, [1]);

meanSWSIS_j = mean(j_swsis);
stdSWSIS_j = std(j_swsis);
semIS_j = stdSWSIS_j/(sqrt(numel(j_swsis)));

meanIS_a = mean(a_is);
stdIS_a = std(a_is);
semIS_a = stdIS_a/(sqrt(numel(meanIS_a)));

errorbar(1, meanIS_j, semIS_j, 'o')
hold on
errorbar(2, meanIS_a, semIS_a, 'o')

xlim([0 3])
title('IS')
ylim([0 60])


figDir = '/home/janie/Dropbox/Writing/00_Articles/0_HamedsPaper/March2023/For submission/Review/New/NewFigs/';
FigName = 'SX-Means';

saveName = [figDir FigName];

plotpos = [0 0 6 6]; %Fig 2
  print_in_A4(0, saveName, '-djpeg', 0, plotpos);
 print_in_A4(0, saveName, '-depsc', 3, plotpos);

 

%%

y = [j_rem a_rem]';
y = [j_sws a_sws]';
y = [j_is a_is]';
y = [j_swsis a_swsis]';

g1 = [1 1 1 1 1 2 2 2]; 

p = anovan(y,{g1})



[p,h] = ranksum(j_rem, a_rem)
[p,h] = ranksum(j_sws, a_sws)
[p,h] = ranksum(j_is, a_is)

[p,h] = ranksum(j_swsis, a_swsis)

males = [j1_meanSWSIS j4_meanSWSIS j5_meanSWSIS];
[p,h] = ranksum(j_swsis, a_swsis)
[p,h] = ranksum(males, a_swsis)

%%

figDir = '/home/janie/Dropbox/Writing/00_Articles/0_HamedsPaper/March2023/For submission/Review/New/NewFigs/';
FigName = 'Fig2-SWS-REM';

saveName = [figDir FigName];

plotpos = [0 0 10 8]; %Fig 2
  print_in_A4(0, saveName, '-djpeg', 0, plotpos);
 print_in_A4(0, saveName, '-depsc', 3, plotpos);
