function  [] = analyzeWN_FR_responses()

d = load('/media/janie/300GBPassport/OTProject/MLD/WN_FR-Zscores.mat');

allZscore = d.WN.z_score_cov;

posZs = numel(find(allZscore > 0.5));
negZs = numel(find(allZscore < -0.5));

posPercent = posZs/numel(allZscore)*100;
negPercent = negZs/numel(allZscore)*100;




end
