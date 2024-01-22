function h_trace = lfp_browser()

% %
% fdir_session = 'C:\Users\Corinna\Dropbox\colab_neurophys_of_sleep\data\j8v8\20200227_02';
% birdname = 'j8v8';

%fdir_session = 'C:\Users\Corinna\Dropbox\colab_neurophys_of_sleep\data\g4r4\20190723_03';
%birdname = 'g4r4';

fdir_session = 'Z:\JanieData\Neuropixel\w047\raw_08_RH_P6 - SpontWAnasthesia_g0\';
birdname = 'w047';




% fdir_session = '\\zuperfinch\microdrive\birds\g4r4\Ephys\raw\20190718_02\raw_dark_01_g3\';
% birdname = 'g4r4';

% fdir_session = '\\zuperfinch\microdrive\birds\g4r4\Ephys\raw\20190716_02\20190716_02_undir_g0\';
% birdname = 'g4r4';

% fdir_session = '\\zuperfinch\microdrive\birds\o11y3\Ephys\raw\2019-11-01_02\raw_dark_g0';
% birdname = 'o11y3';
% %
% fdir_session = 'C:\Users\Corinna\Dropbox\colab_neurophys_of_sleep\data\r5n5\20201023_02\sleep_theReal_g0\';
% birdname = 'r5n5';

%
% fdir_session = 'C:\Users\Corinna\Dropbox\colab_neurophys_of_sleep\data\r11n11\20201114_03';
% birdname = 'r11n11';


gate_name = get_subfolders(fdir_session);

% choose file
g_i = 1;
fdir =  fullfile(fdir_session, gate_name{g_i});
fname = dir(fullfile(fdir, '*lf.bin'));
fname = fname.name;

%%
fprintf('start plotting figure with raw lfp data\n');

% ---------------------------------------
% figure name
figtitle = [birdname ' ' fname] ;

%% figure with two subplots:
% raw lfp trace and spike events

h_trace = findobj('Type', 'figure', 'Name', ...
    sprintf('lfp browser %s', figtitle));

if isempty(h_trace)
    h_trace = figure('Name', ...
        sprintf('lfp browser %s', figtitle), ...
        'Position', [199 228 1532 607]);
else
    figure(h_trace);
end


h_trace.UserData.fname = fname;
h_trace.UserData.fdir = fdir;



% link the axes
% linkaxes([ax1, ax2], 'x');

h_trace.WindowScrollWheelFcn = {@scrollfcn};
h_trace.WindowKeyPressFcn = {@keypressfcn};
[mmf, c2v, fs, meta] = get_mmf(fname, fdir);
h_trace.UserData.mmf = mmf;
h_trace.UserData.c2v = c2v;
h_trace.UserData.fs = fs;
h_trace.UserData.meta = meta;

h_trace.UserData.bpfilt = designfilt('bandpassiir','FilterOrder',4, ...
    'HalfPowerFrequency1',.5,'HalfPowerFrequency2', 200 , ...
    'SampleRate', fs);


h_trace.UserData.chan = 1:4:size(h_trace.UserData.mmf.Data.x,1)-1;
h_trace.UserData.chan_pos = get_chan_pos(meta, h_trace.UserData.chan);


h_trace.UserData.twin = [105 110];
h_trace.UserData.gain = 20000;

% try
%h_trace.UserData.sel_units = load_and_add_spk_data(fdir);
% catch
%     warning('no spike data found \n')
% end

h_trace.UserData.dos_channel = 200;
h_trace.UserData.do_dos = 0;


h_trace.UserData.do_overlap = 0;
% ---------------------------------------
% initialize plots

updateAxes(h_trace);


end


%%
function scrollfcn(~, event)
% zoom in time function

src = event.Source;
twin = src.UserData.twin;
inc = diff(twin)/50; % 3.3 percent
vsc = event.VerticalScrollCount; %indicates the direction and number of scroll wheel clicks

t_strt = max(0, twin(1) - inc*vsc);
t_end = min(size(src.UserData.mmf.Data.x, 2), twin(2) + inc*vsc );
src.UserData.twin = [t_strt t_end];

update_vtrace(src)

end

%%
function keypressfcn(~, event)
% key press functions

src = event.Source;
twin = src.UserData.twin;
inc = diff(twin)/5;

switch event.Key
    case 'rightarrow'
        src.UserData.twin = twin+inc;
        updateAxes(src);
        
    case 'leftarrow'
        src.UserData.twin = twin-inc;
        updateAxes(src);
        
    case 'b'
        src.UserData.twin = [0 diff(twin)];
        updateAxes(src);
        
    case 'e'
        t_end = size(src.UserData.mmf.Data.x, 2) / src.UserData.fs;
        src.UserData.twin = [t_end-diff(twin) t_end];
        updateAxes(src);
        
    case  'uparrow'
        src.UserData.gain = src.UserData.gain*1.1;
        update_vtrace(src);
        
    case 'downarrow'
        src.UserData.gain = src.UserData.gain/1.1;
        update_vtrace(src);
        
end

end

%%
function updateAxes(src)

%update_spktevents(src);
update_vtrace(src);

end

%%
function ax = update_vtrace(src)

% fprintf('update voltage trace\n');

dat = src.UserData;
dat.chan_pos = get_chan_pos(dat.meta, dat.chan); % update channel position

ax = subplot(8,1, 1:5);
cla(ax)

% converst time from seconds to samples
twin = dat.twin;
[s, x] = conv_s_to_samples(twin, dat.fs);

lf = double(dat.mmf.Data.x(dat.chan,s));
lf_filt=filtfilt(dat.bpfilt,lf')';

a = dat.gain * dat.c2v;
b = zeros(size(lf_filt)) + (dat.chan_pos-1)';
Y = lf_filt .* a + b ;

% PLOT FILTERED LF
X = zeros(size(Y)) + x;
plot(X', Y', 'color',[.3 0 1 .4]);

xlim(twin);
ylim([-5 dat.chan_pos(end)+20]);

ylabel(' Channel (~ Distance to tip [10um] )');
box off;
%ax.XTick = [];


% PLOT SCALE
% v2u = 1/a ;
% plot( [x(end) x(end)] ,  [0 v2u ] , 'color', 'k', 'LineWidth', 2);

%{
%%% overlap spikes optionally
if dat.do_overlap
    
    selu = dat.sel_units;
    
    
    % reduce spike times to the relevant window
    is_rel = selu.t > x(1) & selu.t < x(end);
    spk = selu.t(is_rel);
    clust = selu.t_clust(is_rel);
    
    Y_s = nan(size(Y));
    hold on;
    
    uch = unique(selu.chan);
    
    for k = 1:length(uch)
        
        cidx = [selu.chan] == uch(k);
        spkt = spk(ismember( clust, selu.id(cidx)));
        
        chidx = round(uch(k)/ 4);
        for j = 1:length(spkt)
            tidx = find(x -spkt(j) >=0, 1, 'first');
            
            %             scatter(X(chidx, tidx)', Y( chidx, tidx  ), 1, 'g', 'filled', 'MarkerFaceAlpha', .1);
            Y_s( chidx, tidx ) = Y( chidx, tidx  );
        end
        
    end
    %
    sc = plot(X', Y_s', 'g.');
    uistack(sc, 'bottom');
    set(sc, 'LineWidth', .5);
    %     sc.Color[:] = [sc.Color, 0.1];
end

%}

%%% DEPTH OF SLEEP SCORE

%{
% return
% detph of sleep plot
ax = subplot(6,1, 6);
cla(ax)

if twin(1)<3 || twin(end)-3> size(dat.mmf.Data.x,2)/dat.fs || ~dat.do_dos
    
    % simple, column-wise entropy
    
    A = src.UserData.spk_imagesc;
    g= src.UserData.sel_units.g ==4;
    
    
    for k = 1:size(A, 1)
        
        P(k,:) = histcounts(A(k,:), 5:10);
        P(k, :) = P(k, :)./ sum(P(k, :)) ;
        
        idx  =  P(k, :) ~= 0;
        H(k) = -sum(P(k,idx) .* log2(P(k,idx)) );
        
        B(k) =  sum(A(k,g) >=4);
    end
    
    plot(H);
    hold on;
    plot(B);
    xlim([1 length(H)]);
    ylim([0 3])
    legend('entropy', 'burst events in LMAN');
    
    %     % 2D entropy
    %     x = 10:10:size(A, 1)-10;
    %
    %     for k = x
    %         H2(k./10) =  entropy(A (k-9:k+10, :) );
    %     end
    %
    %     hold on;
    %     plot(x, H2, 'r');
    %ylim([0 1])
    
    
    
    
else
    
    s_dos = conv_s_to_samples([twin(1)-3 twin(end)+3] , dat.fs);
    lf_dos = double(dat.mmf.Data.x(dat.dos_channel, s_dos));
    lf_dos_filt=filtfilt(dat.bpfilt,lf_dos')';
    
    [LH, t] = get_DOS(dat.fs, lf_dos_filt);
    
    plot(t-1.5+twin(1), LH, '-x'); hold on;
    plot(ax.XLim, ones(2,1)*79, 'r--');
    plot(ax.XLim, ones(2,1)*19, 'r--');
    plot(ax.XLim, ones(2,1)*47, 'r--');
    
    ylabel(sprintf('chan # %d', dat.dos_channel));
    axis tight
    xlim(twin);
    ylim([0 300])
    box off;
    fprintf('done\n');
    
    linkaxes([ax.Parent.Children],'x');
    box off;
    xlabel(' Time [s] ')
end

%}

fprintf('done\n');
return


end

%%

function update_spktevents(src)

src.UserData.sel_units = load_and_add_spk_data(src.UserData.fdir);

dat = src.UserData;
selu = dat.sel_units;
twin = dat.twin;



% initiate variable
[s, x] = conv_s_to_samples(twin, dat.fs);
s = s(1:50:end);
x = x(1:50:end);
A = zeros( length(s)+1, length(selu.id) );



% reduce spike times to the relevant window
is_rel = selu.t > x(1) & selu.t < x(end);

spk = selu.t(is_rel);
clust = selu.t_clust(is_rel);


% loop through all spike clusters and extract the spike times
ax = subplot(10,1,[7 8]); cla;
j = 1;
for k = 1:length(selu.id)
    
    %     t_u = selu.t(selu.t_clust == selu.id(k));
    %     t = [t_u'; t_u'];
    %     y = ones(size(t)).* selu.chan(k); y(2,:) = y(2,:)+1;
    %     plot(t, y, 'k', 'LineWidth', 1);
    A( :, j) =  [0 histcounts(spk(clust == selu.id(k)), x)*50 0] ;
    
    j = j+1;
    
    if k<length(selu.id) && (selu.g(k) - selu.g(k+1))~=0
        
        for n_zeros = 1:3
            A( :, j) =  zeros(size(A,1), 1);
            j = j+1;
        end
    end
    
end

imagesc(x, selu.depth, A');

ax.YDir = 'normal';
% caxis([0 10]);

% colorbar('Location', 'eastoutside');
% colormap

src.UserData.spk_imagesc = A;

end

%%

function chan_pos = get_chan_pos(meta, chan)


D = textscan(meta.imroTbl, '(%d %d %*s %*d %*d %*s', ...
    'EndOfLine', ')', 'HeaderLines', 1 );

chan_pos = double(D{1}(chan)' + (D{2}(chan)*384)'+1);

end

%%
function [s, x] = conv_s_to_samples(twin, fs)

s = twin(1)*fs : 1 :  twin(2)*fs;
s(1) = max(1, s(1));
s = round(s);
x = s./fs;

end
