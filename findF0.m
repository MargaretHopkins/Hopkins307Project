function[f0, t_tpt, pks_tpt] = findF0(Y_tpt, Fs_tpt)

%defining variables
L_tpt=length(Y_tpt);

t_tpt=(1:length(Y_tpt))/Fs_tpt;


%taking FFT of audio
X_tpt=fft(Y_tpt);


%finding amplitudes for lower half of frequencies
X1_tpt=abs(X_tpt(1:L_tpt/2+1)/L_tpt);
%defining a vector of frequencies corresponding to X1
f_tpt = Fs_tpt*(0:(L_tpt/2))/L_tpt;

%finding the peak frequencies in X1 (values and locations)
[pks_tpt,locs_tpt] = findpeaks(X1_tpt, 'MinPeakDistance',500, 'MinPeakHeight', 0.0003);
%creating a vector of the peak frequencies
peakFreqs_tpt=f_tpt(locs_tpt);

%un-comment this to see if the right peak has been chosen as the
%fundamental
plot(f_tpt, X1_tpt, 'r');
xline(peakFreqs_tpt(1), 'r--');

f0 = peakFreqs_tpt(1);