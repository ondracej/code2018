y = hilbert(data);
smoothwin_ms = 5;
smoothwin_samp = smoothwin_ms/1000*fs ;
env = abs(y);

figure (100); clf
subplot(2, 1, 1)
plot(data)
hold on
plot(smooth(data, smoothwin_samp), 'k')
subplot(2, 1, 2)
plot(env)
hold on
plot(smooth(env, smoothwin_samp), 'k')
