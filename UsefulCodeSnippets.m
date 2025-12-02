%% Useful Code Snippets


%% FFT
   % Fourier transfom
            %{
            %Fs = Fs;                    % Sampling frequency
            T = 1/Fs;                     % Sample time
            L = numel(LongLFtms);
            %Y = fft(squeeze(longLF));
            NFFT = 2^nextpow2(L); % Next power of 2 from length of y
            Y = fft(squeeze(longLF),NFFT)/L;
            f = Fs/2*linspace(0,1,NFFT/2+1);
            
            % Plot single-sided amplitude spectrum.
            figure
            plot(f,2*abs(Y(1:NFFT/2+1)))
            xlim([0 10])
   %}
%% Sound filtering

   %{
% set general variables
nf = sf / 2; % nyquist frequency

n = round(sf * stimDur_s);  % number of samples
nh = n / 2;  % half number of samples

% =========================================================================
% set variables for filter
lp = lf * stimDur_s; % ls point in frequency domain
hp = hf * stimDur_s; % hf point in frequency domain

% design filter
a = ['BANDPASS'];
filter = zeros(1, n);           % initializaiton by 0
filter(1, lp : hp) = 1;         % filter design in real number
filter(1, n - hp : n - lp) = 1; % filter design in imaginary number

% =========================================================================
% make noise
%rand('state',sum(100 * clock));  % initialize random seed
rng('default')
rng(1) % for consistency?
noise = randn(1, n);             % Gausian noise
noise = noise / max(abs(noise)); % -1 to 1 normalization

% do filter
filNoise = fft(noise);                  % FFT
filNoise = filNoise .* filter;                 % filtering
filNoise = ifft(filNoise);                     % inverse FFT
filNoise = real(filNoise);
%}

%% Error bar
%{
errorbar(x,y,err,'-s','MarkerSize',10,...
    'MarkerEdgeColor','red','MarkerFaceColor','red')
%}
%% Sound Amlpitude and phase Info

%{
phaseShiftedSignal = real(thisSigData_L.*exp(pi*1i));
    

X = hilbert(Xr);
%The instantaneous amplitude envelope is the magnitude of the analytic signal:
mag = abs(X);
%The instantaneous phase information can be found using the "angle" and "unwrap" functions:
phi = unwrap(angle(X));
%Finally, the instantaneous frequency can be found from the derivative of the instantaneous phase:
freq = 1/(2*pi) * diff(phi) * Fs;
%}


%% Cumulative Distribution
%{
  bincenters = 100:20:1650; % Define for data
    
    [cx, cy] = hist(thisData, bincenters);
    bla_z = cumsum(cx) ./ sum(cx);
    
    hold on
    plot(cy, bla_z, 'k', 'linewidth', 2)
    
 %} 



%% Jittered gausian dist box plot
%{
    jitterAmount = 0.1;
    jitterValuesX = 2*(rand(size(zscores))-0.5)*jitterAmount;   % +
    
    cols = cell2mat({[0 0 0]; [.5 .5 .5]});
    %cols = cell2mat({[0.6350, 0.0780, 0.1840]; [0.8500, 0.3250, 0.0980]; [0.9290, 0.6940, 0.1250]; [0, 0, 0]; [0.4940, 0.1840, 0.5560]});
    
    figure(102); clf
    h = scatterhist(zscores,jitterValuesX, 'Kernel','on', 'Location','NorthEast',...
        'Direction','out', 'LineStyle',{'-','-'}, 'Marker','..', 'Markersize', 20, 'color', cols);
    
     
   
    boxplot(h(2),zscores,'orientation','horizontal',...
        'label',{''},'color', 'k', 'plotstyle', 'compact', 'Whisker', 10);
    
    
    
    axis(h(1),'auto');  % Sync axes
    
    yss = ylim;
    xss = xlim;
    
    hold on
    line([.5 .5], [yss(1) yss(2)], 'color', 'k', 'linestyle', ':')
    line([-.5 -.5], [yss(1) yss(2)], 'color', 'k', 'linestyle', ':')
   %} 