function [] = InitCode()

hostName = gethostname;

switch hostName
    case 'deadpool'
        addpath(genpath('/home/janie/Code/code2018/'))
    case 'TURTLE'
        addpath(genpath('/home/janie/code/code2018/'))
        
end



