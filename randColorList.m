function [colors, num_of_colors] = randColorList()
% list of all standard matlab colors
% extend this list if needed

%    colors = { 'r', 'g', 'b', 'c', 'm', 'k', [0.5 0.5 0.5], [0.0 0.5 0.5], [0.2 0.5 0.5], [0.4 0.5 0.5], [0.6 0.5 0.5], [0.8 0.5 0.5], [1 0.5 0.5], [.5 0.0 0.5], [.5 0.2 0.5], [.5 0.4 0.5]...
%[.5 0.6 0.5], [.5 0.8 0.5], [.5 1 0.5], [.5 0.5 0], [.5 0.5 0.2], [.5 0.5 0.4], [.5 0.5 0.6], [.5 0.5 0.8], [.5 0.5 1]};

colors = { 'r', 'g', 'b', 'c', 'm', 'k', [0.5 0.5 0.5], [0.0 0.5 0.5], [0.2 0.5 0.5], [0.4 0.5 0.5], [0.6 0.5 0.5], [0.8 0.5 0.5], [1 0.5 0.5], [.5 0.0 0.5], [.5 0.2 0.5], [.5 0.4 0.5]...
[.5 0.6 0.5], [.5 0.8 0.5], [.5 1 0.5], [.5 0.5 0], [.5 0.5 0.2], [.5 0.5 0.4], [.5 0.5 0.6], [.5 0.5 0.8], [.5 0.5 1]};
    num_of_colors = size(colors, 2);
end

%% EOF
