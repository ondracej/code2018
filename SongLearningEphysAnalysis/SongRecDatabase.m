function [SongRec_DB] = SongRecDatabase()


rec = 1;

%% w038, 2021-08-23 Song Recording
SongRec_DB(rec).songDir = 'X:\EEG-LFP-songLearning\JaniesAnalysis\SONGS\w038\Data\';
SongRec_DB(rec).songRecDate =  '2021-08-23';
SongRec_DB(rec).First100Present = 1;
SongRec_DB(rec).Last100Present = 1;
SongRec_DB(rec).EphysPresent =  1;

rec = rec+1;





end