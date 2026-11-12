%loading data into sleep state pipeline

function [] = calc_sleep_states_and_align_w_coh_analysis()

ephys_info = 'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysis\ALL_PLOTS\w027\All_LFP_dy/chronic_2021-07-25_23-03-55_allLFP_dyData-8.mat';
coh_info = 'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysis\ALL_PLOTS\w027\All_LFP_dy\BurstDetection\chronic_2021-07-25_23-03-55_CorCoh-12.mat';
ephysDir = 'Z:\hameddata2\EEG-LFP-songLearning\JaniesAnalysis\w027\DATA_EPHYS\chronic_2021-07-25_23-03-55\';


ei = load(ephys_info);
ci = load(coh_info);

%%
% add dirs to path

%%
entry_cnt = 2;

[channelFiles, dataPath] = defineOpenEphysFilenames(entry_cnt);

cd(dataPath)

%One thing to verify before trusting this on your data: the header-parsing step 
%assumes your files declare version >= 0.2 (which determines whether the recNum 
%field is present in each record). If your recordings came from an older Open 
%Ephys GUI version, that assumption could be wrong and would misalign every record 
%? worth printing headerInfo(1).version and headerInfo(1).nRecords from a test 
%channel first and confirming nRecords * 1024 roughly matches your expected 
%recording duration ? sample rate, as a sanity check before running the full conversion.

[readChunkFcn, nSamplesTotal, headerInfo] = openephys_continuous_reader(channelFiles);

nChan = numel(channelFiles);
fsOrig = headerInfo(1).sampleRate;   % should be ~30000

headerInfo(1).version
headerInfo(1).nRecords

data = downsample_raw_data(readChunkFcn, nSamplesTotal, nChan, fsOrig, 500, 60);
fs = 500;




avian_sleep_state_pipeline(data)






[dataBin, timestamps, info] = load_open_ephys_data_chunked(filename,tOn_toAnalyze(o), tOn_toAnalyze(o)+timeWin_s);




end


