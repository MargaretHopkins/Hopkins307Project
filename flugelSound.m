function[xFl] = flugelSound(noteSource)
inputType = input("Type 1 for trumpet note input, and 2 for MIDI note");

%all fundamental frequencies used (lowest peak selected)
f0s_fl = [178.7109 218.4082 264.3201 355.2979 447.5919 529.5384 711.8332];
%amplitude ratios for the flugelhorn by partial (each row is a
%partial, each column is one of the recorded notes)
%for example, row 3, column 2 is the amplitude of the 3rd partial of the second note
%recorded (B3), divided by the amplitude of the fundamental frequency, B3
ampRatios_fl = [1 1 1 1 1 1 1;
    0.6014 0.6073 0.7339 3.6151 0.6395 0.5324 0.2697;
    1.5341 1.1901 0.4869 0.8579 0.0517 0.5499 0.0290;
    1.1769 0.4504 0.2263 0.5761 0.0504 0.1004 0.0111;
    0.3612 0.4990 0.2055 0.1066 0.0322 0.0048 0.0025;
    0.4320 0.0963 0.1338 0.1181 0.0093 0.0071 0.0075;
    0.2637 0.0259 0.0292 0.0189 0.0147 NaN NaN];


if inputType == 1
    %reading trumpet sound audio
    [Y_tpt, Fs_tpt] = audioread(noteSource);
    T=1/Fs_tpt;
    [f0, t_tpt, pks_tpt] = findF0(Y_tpt, Fs_tpt);
    f0midi = ftom(f0);
freqRatios_fl = [1 2 3 4 5 6 7];

x = 0;
if f0midi<=ftom(f0s_fl(5))
    for n = 1:7
    amp = interp1(ftom(f0s_fl), ampRatios_fl(n,:), f0midi);
    x = x + amp*pks_tpt(1)*cos(2*pi*f0*freqRatios_fl(n)*t_tpt);
    end
else 
    for n = 1:6
    amp = interp1(ftom(f0s_fl), ampRatios_fl(n,:), f0midi);
    x = x + amp*pks_tpt(1)*cos(2*pi*f0*freqRatios_fl(n)*t_tpt);
    end
end

%times of breakpoints (as proportions of total note length, converted to
%milliseconds
times = [0 .09 0.769 1]*t_tpt(length(t_tpt))*1000;
%corresponding amplitude breakpoints
y = [0.0 1.0 0.8 0.0];
%time in samples
n = 1:Fs_tpt*t_tpt(length(t_tpt));
%piecewise linear envelope created
env = interp1(times, y, 1000*n*T);   % scale the time steps to milliseconds

%multiply sine wave sum x by envelope
xFl=x.*env;

else if inputType == 2
Fs_tpt = 44100;
        f0 = mtof(noteSource);
f0midi = ftom(f0);
freqRatios_fl = [1 2 3 4 5 6 7];
pks_tpt = 0.03;
t_tpt=(1:88200)/Fs_tpt;
T = 1/Fs_tpt;


x = 0;
if f0midi<=ftom(f0s_fl(5))
    for n = 1:7
    amp = interp1(ftom(f0s_fl), ampRatios_fl(n,:), f0midi);
    x = x + amp*pks_tpt(1)*cos(2*pi*f0*freqRatios_fl(n)*t_tpt);
    end
else 
    for n = 1:6
    amp = interp1(ftom(f0s_fl), ampRatios_fl(n,:), f0midi);
    x = x + amp*pks_tpt(1)*cos(2*pi*f0*freqRatios_fl(n)*t_tpt);
    end
end

%times of breakpoints (as proportions of total note length, converted to
%milliseconds - these are based on a recording of the envelope of a single
%trumpet note
times = [0 .09 0.769 1]*t_tpt(length(t_tpt))*1000;
%corresponding amplitude breakpoints
y = [0.0 1.0 0.8 0.0];
%time in samples
n = 1:Fs_tpt*t_tpt(length(t_tpt));
%piecewise linear envelope created
env = interp1(times, y, 1000*n*T);   % scale the time steps to milliseconds

%multiply sine wave sum x by envelope
xFl=x.*env;
end




end