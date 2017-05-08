function duration = playWav(wavfile)

[wav,freq] = wavread(wavfile);
player=audioplayer(wav,freq); 
play(player); 
duration = length(wav)/freq;
WaitSecs(duration);