function[xTpt] = trumpetSound(noteSource)
inputType = input("Type 1 for trumpet note input, and 2 for MIDI note");

%all fundamental frequencies used (lowest peak selected)
f0s_tpt = [175.9836 220.7476 264.6626 351.709 438.1322 523.6096 715.6766];
%amplitude ratios for the trumpet by partial (each row is a
%partial, each column is one of the recorded notes)
%for example, row 3, column 2 is the amplitude of the 3rd partial of the second note
%recorded (B3), divided by the amplitude of the fundamental frequency, B3
ampRatios_tpt = [1 1 1 1 1 1 1;
    0.9139 0.5820 1.1404 2.5868 1.8194 0.7471 0.5534;
    2.0942 3.6387 0.9167 0.7101 1.4191 0.7703 0.4730;
    1.9680 0.8368 0.3747 0.7807 0.8594 0.2550 0.0305;
    1.1585 2.0521 0.4475 1.0866 0.1522 0.0229 0.0084;
    0.5558 1.1750 0.2515 0.2439 0.1236 0.0494 0.0198;
    0.7817 0.3994 0.1937 0.1246 0.0593 NaN NaN];


if inputType == 1
    %reading trumpet sound audio
    [Y_tpt, Fs_tpt] = audioread(noteSource);
    T=1/Fs_tpt;
    [f0, t_tpt, pks_tpt] = findF0(Y_tpt, Fs_tpt);
    f0midi = ftom(f0);
freqRatios_Tpt = [1 2 3 4 5 6 7];

x = 0;
if f0midi<=ftom(f0s_tpt(5))
    for n = 1:7
    amp = interp1(ftom(f0s_tpt), ampRatios_tpt(n,:), f0midi);
    x = x + amp*pks_tpt(1)*cos(2*pi*f0*freqRatios_Tpt(n)*t_tpt);
    end
else 
    for n = 1:6
    amp = interp1(ftom(f0s_tpt), ampRatios_tpt(n,:), f0midi);
    x = x + amp*pks_tpt(1)*cos(2*pi*f0*freqRatios_tpt(n)*t_tpt);
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
xTpt=x.*env;

else if inputType == 2
Fs_tpt = 44100;
        f0 = mtof(noteSource);
f0midi = ftom(f0);
freqRatios_tpt = [1 2 3 4 5 6 7];
pks_tpt = 0.03;
t_tpt=(1:88200)/Fs_tpt;
T = 1/Fs_tpt;


x = 0;
if f0midi<=ftom(f0s_tpt(5))
    for n = 1:7
    amp = interp1(ftom(f0s_tpt), ampRatios_tpt(n,:), f0midi);
    x = x + amp*pks_tpt(1)*cos(2*pi*f0*freqRatios_tpt(n)*t_tpt);
    end
else 
    for n = 1:6
    amp = interp1(ftom(f0s_tpt), ampRatios_tpt(n,:), f0midi);
    x = x + amp*pks_tpt(1)*cos(2*pi*f0*freqRatios_tpt(n)*t_tpt);
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
xTpt=x.*env;
end




end