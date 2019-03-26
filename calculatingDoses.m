function [required_volume_solution_ml, required_volue_solution_ul] = calculatingDoses(dose_top_mg, dose_bottom_g, birdGrams, concentration_top_mg, concentration_bottom_ml)
%% Carprofen

%dose_top_mg = 4;
%dose_bottom_g = 1000;

%birdGrams = 15;

required_dose_mg_for_bird = (dose_top_mg*birdGrams)/dose_bottom_g;

%%
%concentration_top_mg = 50;
%concentration_bottom_ml = 1;

required_volume_solution_ml = (concentration_bottom_ml*required_dose_mg_for_bird)/concentration_top_mg;
required_volue_solution_ul = required_volume_solution_ml*1000;
%%
disp([' Dose in ml:' num2str(required_volume_solution_ml)])
disp([' Dose in ul:' num2str(required_volue_solution_ul)])
end

