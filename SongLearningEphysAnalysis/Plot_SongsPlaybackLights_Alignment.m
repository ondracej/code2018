function [] = Plot_SongsPlaybackLights_Alignment()

BirdName = 'w025';
RecDate =  '2021-07-19';

lightOn_time = '10:52:08'; % Morning before singing
lightOff_time = '22:49:13'; % night before sleep

unplugTime = '11:01:04'; %last frame in video
plugTime = '21:38:41'; %last frame in video
%%
saveDir = 'X:\EEG-LFP-songLearning\JaniesAnalysis\ALL_PLOTS\w025\SongPlaybackSummaries\';
PlaybackTimeInfoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w025\PlaybackTimeInfo\';
SongTimeInfoDir = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w025\SongTimeInfo\';

%lightOn_s = [10 52 8]; % Morning before singing
%lightOff_s = [22 49 13]; % night before sleep

%Playbacks = '2021-07-19-Playbacks_PlaybackTimeINFO.mat';
%First100Songs = '2021-07-19-First100Songs-Motifs_timeINFO.mat';
%Last100Songs = '2021-07-19-Last100Songs-Motifs_timeINFO.mat';

Playbacks = [RecDate '-Playbacks_PlaybackTimeINFO.mat'];
First100Songs = [RecDate '-First100Songs-Motifs_timeINFO.mat'];
Last100Songs = [RecDate '-Last100Songs-Motifs_timeINFO.mat'];

%%
m_First100 = load([SongTimeInfoDir First100Songs]);
m_Last100 = load([SongTimeInfoDir Last100Songs]);
pb = load([PlaybackTimeInfoDir Playbacks]);

m_First100_timeInfo = m_First100.TimeInfo.ds;
m_First100_timeInfo_times = m_First100.TimeInfo.times;
m_Last100_timeInfo = m_Last100.TimeInfo.ds;
pb_timeInfo = pb.TimeInfo.ds;

%% First convert the lights on / off to real times

thisDate = m_First100_timeInfo_times{1}(1:11);
LightsOnTime  = [thisDate ' ' lightOn_time];
LightsOffTime  = [thisDate ' ' lightOff_time];
UnplugTime = [thisDate ' ' unplugTime];
PlugTime = [thisDate ' ' plugTime];

LightsOn_dt = datetime(LightsOnTime);
LightsOff_dt = datetime(LightsOffTime);
Unplug_dt = datetime(UnplugTime);
Plug_dt = datetime(PlugTime);
%% Plot the motifs
figure(105);clf

rs = 1:1:numel(m_First100_timeInfo);
plot(m_First100_timeInfo, rs, 'ko', 'linestyle', 'none', 'MarkerFaceColor','w')
set(gca, 'YDir','reverse')

hold on
rs = 1:1:numel(m_Last100_timeInfo);
plot(m_Last100_timeInfo, rs, 'ko', 'linestyle', 'none', 'MarkerFaceColor','k')
set(gca, 'YDir','reverse')

hold on
rs = 1:1:numel(pb_timeInfo);
plot(pb_timeInfo, rs, 'ro', 'linestyle', 'none',  'MarkerFaceColor','r')
set(gca, 'YDir','reverse')

line([LightsOn_dt LightsOn_dt], [0 100])
line([LightsOff_dt LightsOff_dt], [0 100])

line([Unplug_dt Unplug_dt], [0 100], 'color', 'r')
line([Plug_dt Plug_dt], [0 100], 'color', 'r')


legend({'First 100 songs', 'Last 100 songs', 'Playbacks'})

thisFirstTimeForLims = '10:00:00';
thisLastTimeForLims = '23:59:59';

ylimFirstTime = [thisDate ' ' thisFirstTimeForLims];
ylimLastTime = [thisDate ' ' thisLastTimeForLims];

ylimFirst = datetime(ylimFirstTime);
ylimLast = datetime(ylimLastTime);

xlim([ylimFirst ylimLast])

title([BirdName])

%%

plotpos = [0 0 18 10];
RecName_save = [saveDir  thisDate ];
print_in_A4(0, RecName_save, '-djpeg', 0, plotpos);
print_in_A4(0, RecName_save, '-depsc', 0, plotpos);

end
