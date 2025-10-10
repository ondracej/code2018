function  [] = analyzeWN_FR_responses()

d = load('X:\Janie-OT-MLD\OT-MLD\OTProject\MLD\Figs\WN_FR-Zscores.mat');

allZscore = d.WN.z_score_cov;

posZs = numel(find(allZscore > 0.5));
negZs = numel(find(allZscore < -0.5));

posPercent = posZs/numel(allZscore)*100;
negPercent = negZs/numel(allZscore)*100;

figure;
violinplot(allZscore);
title('Violin Plot of Data');
ylabel('Value');

[f, xi] = ksdensity(allZscore);

% Normalize for symmetric shape
f = f / max(f) * 0.3;  % Scale width

figure;
hold on;
fill([xi, fliplr(xi)], [f, -fliplr(f)], [0.3 0.6 0.9], 'EdgeColor', 'none');
plot(mean(allZscore), 0, 'ko', 'MarkerFaceColor', 'k');
plot([median(allZscore) median(allZscore)], [-0.02 0.02], 'r', 'LineWidth', 2);
title('Custom Violin Plot');
ylabel('Density');
xlabel('Value');
xlim([min(allZscore) max(allZscore)]);
box on;


end
