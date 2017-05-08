% FIRST DEFINE YOUR SOUND
freq        = 800;  % sound frequency
amp         = .3;   % sound amplitude
duration    = .070; % sound duration
Fs          = 44100; % sampling rate

% THEN CREATE YOUR SOUND
timepersamp = 1/Fs;
x=[0:timepersamp:duration];
wave = amp .* sin((2*pi*freq) .*x);
mysound = audioplayer([wave wave], Fs);


% FIRST DEFINE YOUR SOUND
freq        = 400;  % sound frequency
amp         = .3;   % sound amplitude
duration    = .070; % sound duration
Fs          = 44100; % sampling rate

% THEN CREATE YOUR SOUND
timepersamp = 1/Fs;
x=[0:timepersamp:duration];
wave = amp .* sin((2*pi*freq) .*x);
mysound2 = audioplayer([wave wave], Fs);

% THEN PLAY YOUR SOUND (you can call this as many times as you want)

% plays from beginning; does not return until playback completes.

%playblocking(mysound); 
playblocking(mysound2); 
playblocking(mysound2); 
%playblocking(mysound); 

%playblocking(mysound); 
%playblocking(mysound); 

disp('done');

