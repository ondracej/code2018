function [] = playWNSoundWithJitter()

stimDur_s = 1;
sf = 44100;

lf = 1;   % lowest frequency
hf = 10000;   % highest frequency
%% Create Noise Stimulus
%http://www.h6.dion.ne.jp/~fff/old/technique/auditory/matlab.html#cramp

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

filNoise  = filNoise  / max(abs(filNoise ));

totalPlaybacks = 20;
%soundPlaybackInterval_s = 3600*.5;
soundPlaybackInterval_s = 5*.5;
jitter_s = 15;

%load gong.mat;
%sound(y);

tic
for j = 1:totalPlaybacks
    
    delay_s = soundPlaybackInterval_s+ rand*jitter_s;
    pause(delay_s)
    %player = audioplayer(filNoise*100, sf, 16); 
    %play(player)
    soundsc(filNoise, sf)
    fprintf('Sound at time %s\n', datestr(now,'HH:MM:SS.FFF'))
    allDelays(j) = delay_s;
end
toc

disp('')
end