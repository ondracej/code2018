function [] = calcCrossCorrOnSpectrogram()

femaleCallWav = 'E:\Data\FemaleFeedback\w022\w022D-f01557--femaleCall.wav';

fileToAnalyzeWav = 'E:\Data\FemaleFeedback\w022\w022D-f00193.wav';

spec_scale = 0.2;

ylimscale = 8000;

[femaleCallSig,fs, bits] = wavread(femaleCallWav);

%[B,F,T] = SPECGRAM(A,NFFT,Fs,WINDOW,NOVERLAP)
[femaleCall_B, Fcall, Tcall] = specgram1((femaleCallSig/spec_scale),512,fs,400,360);

[SongSig,fs, bits] = wavread(fileToAnalyzeWav);
[Song_B, Fsong, Tsong] = specgram1((SongSig/spec_scale),512,fs,400,360);
specgram1((SongSig/spec_scale),512,fs,400,360);
c = normxcorr2(abs(femaleCall_B),abs(Song_B));

cabs_T = abs(c);
csum_T = sum(cabs_T, 1);
figure; plot(csum_T)
figure; surf(c)
shading flat
axis tight

[ypeak,xpeak] = find(c==max(c(:)));


yoffSet = ypeak-size(femaleCall_B,1);
xoffSet = xpeak-size(femaleCall_B,2);

test = 20*log10(abs(femaleCall_B));

B_T_Call = femaleCall_B(1,:);
B_F_Call = femaleCall_B(:,1);

figure; plot(Tcall, B_T_Call)
figure; plot(Fcall, 20*log10(B_F_Call))

figure; plot(Fcall, femaleCall_B(1,:)')
figure
imagesc(T, F, 20*log10(abs(femaleCall_B))),axis xy; colormap(gray) 

%IMAGESC(T,F,20*log10(ABS(B))),AXIS XY, COLORMAP(JET)

figure(100)
subplot(2, 1, 1)
specgram1((femaleCallSig/spec_scale),512,fs,400,360);


%%

nimg_song = Song_B-mean(mean(Song_B));
nimg_call = femaleCall_B-mean(mean(femaleCall_B));

figure
imagesc(Tsong, Fsong, 20*log10(abs(nimg_song))),axis xy; colormap(gray) 
figure
imagesc(Tcall, Fcall, 20*log10(abs(nimg_call))),axis xy; colormap(gray) 

crr = xcorr2(nimg_song,nimg_call);

%%
[ssr,snd] = max(crr(:));
[ij,ji] = ind2sub(size(crr),snd);

figure
plot(crr(:))
title('Cross-Correlation')
hold on
plot(snd,ssr,'or')
hold off
text(snd*1.05,ssr,'Maximum')


%%
figure(100)
subplot(2, 1, 2)
specgram1((SongSig/spec_scale),512,fs,400,360);

c = xcorr2(femaleCall_B, Song_B);

figure
image(c)

figure; plot(c)



end