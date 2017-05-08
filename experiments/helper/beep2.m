function beep2

% FIRST DEFINE YOUR SOUND
freq        = 400;  % sound frequency
amp         = .15;   % sound amplitude
duration    = .070; % sound duration
Fs          = 44100; % sampling rate

% THEN CREATE YOUR SOUND
timepersamp = 1/Fs;
x=[0:timepersamp:duration];
wave = amp .* sin((2*pi*freq) .*x);
beepSound2 = audioplayer([wave wave], Fs);

playblocking(beepSound2)