function [] = openEphys2KwikConcersionWrapper()

inputDir = '/media/janie/Data64GB/ZF-59-15/exp1_2019-04-28_18-07-21/';

outputDir = '/media/janie/Data64GB/ZF-59-15/exp1_2019-04-28_18-07-21/Kwik/';


info = convert_open_ephys_to_kwik(inputDir, outputDir);

disp('')

end