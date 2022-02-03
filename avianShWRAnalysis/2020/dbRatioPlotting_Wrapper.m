function [] = dbRatioPlotting_Wrapper()

%% w042
% dirsToLoad = {'H:\HamedsData\w042_w044\w042\chronic_2022-01-02_20-53-44\Ephys\' ;
%     'H:\HamedsData\w042_w044\w042\chronic_2022-01-10_21-39-26\Ephys\';
%     'H:\HamedsData\w042_w044\w042\chronic_2022-01-11_21-40-50\Ephys\'};
% ChanToLoad = '150_CH32.continuous';

%% w044
% dirsToLoad = {'H:\HamedsData\w042_w044\w044\chronic_2022-01-04_20-47-15 - trig ok\Ephys\' ;
%     'H:\HamedsData\w042_w044\w044\chronic_2022-01-10_21-39-26\Ephys\';
%     'H:\HamedsData\w042_w044\w044\chronic_2022-01-11_21-40-50\Ephys\';
%     'H:\HamedsData\w042_w044\w044\chronic_2022-01-12_21-39-12\Ephys\'};
% ChanToLoad = '150_CH10.continuous';

%% w025
% dirsToLoad = {'H:\HamedsData\w025_w027\w025\chronic_2021-07-14_20-24-58\Ephys\' ;
%     'H:\HamedsData\w025_w027\w025\chronic_2021-07-16_19-14-55\Ephys\';
%     'H:\HamedsData\w025_w027\w025\chronic_2021-07-17_21-27-58\Ephys\';
%     'H:\HamedsData\w025_w027\w025\chronic_2021-07-18_21-43-38\Ephys\';
%     'H:\HamedsData\w025_w027\w025\chronic_2021-07-19_21-38-34\Ephys\';
%     'H:\HamedsData\w025_w027\w025\chronic_2021-07-20_21-35-35\Ephys\';
%     'H:\HamedsData\w025_w027\w025\chronic_2021-07-21_21-56-25\Ephys\';
%     'H:\HamedsData\w025_w027\w025\chronic_2021-07-23_22-43-29\Ephys\';
%     'H:\HamedsData\w025_w027\w025\chronic_2021-07-24_22-37-34 - corruptTrigStarts\Ephys\';
%     'H:\HamedsData\w025_w027\w025\chronic_2021-07-25_23-03-55\Ephys\';
%     'H:\HamedsData\w025_w027\w025\chronic_2021-07-26_21-35-23\Ephys\';
%     'H:\HamedsData\w025_w027\w025\chronic_2021-07-27_21-49-20\Ephys\';
%     'H:\HamedsData\w025_w027\w025\chronic_2021-07-28_21-51-11\Ephys\';
%     'H:\HamedsData\w025_w027\w025\chronic_2021-07-29_21-47-09\Ephys\';
%     'H:\HamedsData\w025_w027\w025\chronic_2021-07-30_20-54-58\Ephys\';
%     'H:\HamedsData\w025_w027\w025\chronic_2021-07-31_21-50-14\Ephys\';
%     'H:\HamedsData\w025_w027\w025\chronic_2021-08-01_22-20-35\Ephys\';
%     'H:\HamedsData\w025_w027\w025\chronic_2021-08-02_21-26-05\Ephys\';
%     'H:\HamedsData\w025_w027\w025\chronic_2021-08-04_22-02-26\Ephys\';
%     'H:\HamedsData\w025_w027\w025\chronic_2021-08-05_22-06-10\Ephys\';
%     'H:\HamedsData\w025_w027\w025\chronic_2021-08-06_20-57-20\Ephys\';
%     'H:\HamedsData\w025_w027\w025\chronic_2021-08-08_21-11-29\Ephys\'};
%     
% ChanToLoad = '150_CH24.continuous';

%%
%% w037
% dirsToLoad = {'H:\HamedsData\w038_w037\w037\chronic_2021-09-08_21-26-20\Ephys\' ;
%     'H:\HamedsData\w038_w037\w037\chronic_2021-09-09_21-20-35\Ephys\';
%     'H:\HamedsData\w038_w037\w037\chronic_2021-09-10_22-12-57\Ephys\';
%     'H:\HamedsData\w038_w037\w037\chronic_2021-09-11_21-22-25\Ephys\';
%     'H:\HamedsData\w038_w037\w037\chronic_2021-09-12_20-26-52\Ephys\';
%     'H:\HamedsData\w038_w037\w037\chronic_2021-09-13_22-18-08\Ephys\';
%     'H:\HamedsData\w038_w037\w037\chronic_2021-09-15_22-08-48\Ephys\';
%     'H:\HamedsData\w038_w037\w037\chronic_2021-09-16_21-28-13\Ephys\';
%     'H:\HamedsData\w038_w037\w037\chronic_2021-09-18_21-59-46\Ephys\';
%     'H:\HamedsData\w038_w037\w037\chronic_2021-09-19_22-10-06\Ephys\';
%     'H:\HamedsData\w038_w037\w037\chronic_2021-09-23_21-14-20\Ephys\';
%     'H:\HamedsData\w038_w037\w037\chronic_2021-09-26_22-26-22\Ephys\';
%     'H:\HamedsData\w038_w037\w037\chronic_2021-09-27_22-28-22\Ephys\'};
%     
% ChanToLoad = '150_CH16.continuous';


%% w038
dirsToLoad = {'H:\HamedsData\w038_w037\w038\chronic_2021-08-31_21-59-35\Ephys\' ;
    'H:\HamedsData\w038_w037\w038\chronic_2021-09-01_21-54-15\Ephys\';
    'H:\HamedsData\w038_w037\w038\chronic_2021-09-02_21-57-58\Ephys\';
    'H:\HamedsData\w038_w037\w038\chronic_2021-09-03_21-51-46\Ephys\';
    'H:\HamedsData\w038_w037\w038\chronic_2021-09-04_22-18-08\Ephys\';
    'H:\HamedsData\w038_w037\w038\chronic_2021-09-05_21-13-37\Ephys\';
    'H:\HamedsData\w038_w037\w038\chronic_2021-09-07_21-59-35\Ephys\';
    'H:\HamedsData\w038_w037\w038\chronic_2021-09-08_21-26-20\Ephys\';
    'H:\HamedsData\w038_w037\w038\chronic_2021-09-09_21-20-35\Ephys\';
    'H:\HamedsData\w038_w037\w038\chronic_2021-09-10_22-12-57\Ephys\';
    'H:\HamedsData\w038_w037\w038\chronic_2021-09-11_21-22-25\Ephys\'};
    
ChanToLoad = '150_CH26.continuous';

%% w025
% dirsToLoad = {
%     'H:\HamedsData\w025_w027\w025\chronic_2021-08-09_21-51-42-trig ok\Ephys\';
%     'H:\HamedsData\w025_w027\w025\chronic_2021-08-10_21-59-22\Ephys\';
%     'H:\HamedsData\w025_w027\w025\chronic_2021-08-11_20-48-49\Ephys\';
%     'H:\HamedsData\w025_w027\w025\chronic_2021-08-12_21-55-12\Ephys\';
%     'H:\HamedsData\w025_w027\w025\chronic_2021-08-15_21-52-32\Ephys\';
%     'H:\HamedsData\w025_w027\w025\chronic_2021-08-16_22-11-06\Ephys\'};
%     
% ChanToLoad = '150_CH16.continuous';

%% w027
% dirsToLoad = {
%     'H:\HamedsData\w025_w027\w027\chronic_2021-08-09_21-51-42-trig ok\Ephys\';
%     'H:\HamedsData\w025_w027\w027\chronic_2021-08-10_21-59-22\Ephys\';
%     'H:\HamedsData\w025_w027\w027\chronic_2021-08-11_20-48-49\Ephys\';
%     'H:\HamedsData\w025_w027\w027\chronic_2021-08-12_21-55-12\Ephys\';
%     'H:\HamedsData\w025_w027\w027\chronic_2021-08-15_21-52-32\Ephys\';
%     'H:\HamedsData\w025_w027\w027\chronic_2021-08-16_22-11-06\Ephys\'};
%     
% ChanToLoad = '150_CH25.continuous';

%dirsToLoad = {'H:\HamedsData\w025_w027\w027\chronic_2021-08-17_21-47-03\Ephys\'};

%ChanToLoad = '150_CH25.continuous';

%% Cuban tree frog 1
% dirsToLoad = {'I:\Grass\FrogSleep\CubanTreeFrog1\20190625\20190625_08-32\Ephys\2019-06-25_08-32-20\' ;
%     'I:\Grass\FrogSleep\CubanTreeFrog1\20190627\20190627_08-43\Ephys\2019-06-27_08-43-09\';
%     'I:\Grass\FrogSleep\CubanTreeFrog1\20190628\20190628_10-01\Ephys\2019-06-28_10-01-21\';
%     'I:\Grass\FrogSleep\CubanTreeFrog1\20190710\20190710_09-56\Ephys\2019-07-10_09-56-32\';
%     'I:\Grass\FrogSleep\CubanTreeFrog1\20190711\20190711_11-24\Ephys\2019-07-11_11-24-35\'};
%     %'I:\Grass\FrogSleep\CubanTreeFrog1\20190725\CubanTF1_2019-07-25_20-20-58\112_CH15.continuous'
%     
% ChanToLoad = '106_CH15.continuous';

%%

for o = 1:numel(dirsToLoad)
    
    thisDir = [dirsToLoad{o} ChanToLoad];
    
    plotDBRatioMatrix_standalone(thisDir)
    
end

end