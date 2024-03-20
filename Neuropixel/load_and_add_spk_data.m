function sel_units = load_and_add_spk_data(spk_dir)

% spike times coming from the ap file
spk_times = readNPY(fullfile(spk_dir, 'spike_times.npy'));  % in indices of spike glx

% corresponding spike sorting cluster 
spk_clust = readNPY(fullfile(spk_dir, 'spike_clusters.npy'));

% cluster information
cluster_info = tdfread(fullfile(spk_dir, 'cluster_info.tsv'), '\t');


if ~isfield(cluster_info, 'id')
    cluster_info.id = cluster_info.cluster_id;
end

%%% INCLUSION 
% include only units that fire with higher than 1 Hz spike rate
fr_incl = cluster_info.fr > 2 ;

% spike times and cluster for multiunits and good units only
c_incl = ~contains(cellstr(cluster_info.group), 'noise');
% c_incl = contains(cellstr(cluster_info.group), 'good');

if size(fr_incl, 1) ~= size(c_incl, 1)
    fr_incl= fr_incl';
end

%%% FILTER
sel_units.id = cluster_info.id(c_incl & fr_incl);
sel_units.chan = cluster_info.ch(c_incl & fr_incl);
sel_units.depth = cluster_info.depth(c_incl & fr_incl);
sel_units.fr= cluster_info.fr(c_incl & fr_incl);


% sort by depth
% [~, i] = sort(sel_units.fr);
[i, sel_units.g] = sort_spike_cluster(sel_units);

sel_units.id = sel_units.id(i);
sel_units.chan = sel_units.chan(i);
sel_units.depth = sel_units.depth(i);
sel_units.fr = sel_units.fr(i);

idx_incl = ismember(spk_clust, sel_units.id);


sel_units.t = double(spk_times( idx_incl )) ./ 30000;
sel_units.t_clust = spk_clust( idx_incl );



%%% correct if multiple spike clusters per channel exist

% for k = unique(sel_units.chan)
%     
%     idx_same_chan = find(sel_units.chan);
%     
%     for j = 1:length(idx_same_chan)
%         
%         sel_units.chan(idx_same_chan(j)) = sel_units.chan(idx_same_chan(j))+1/length(idx_same_chan);
%     end
% end
%     
end


function [ i, g] = sort_spike_cluster(sel_units)

% sort by firing rate and by pallium / bg

fr = sel_units.fr;
ch = sel_units.chan;

edge = [0 80 210 240 280 384];
% edge = [0 200 384];

i = [];
g = [];
for k = length(edge)-1:-1:1
    
    acc = sort_cluster_within_chrange(ch, fr, edge(k), edge(k+1));

    i = [i;acc];
    g = [g; k*ones(size(acc))];
end

end



function i = sort_cluster_within_chrange(ch, fr, ch_strt, ch_end)

A = find(ch > ch_strt & ch <= ch_end );
[~, iA] = sort(fr(A), 'descend');
i = A(iA);

end