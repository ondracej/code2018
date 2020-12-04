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

   