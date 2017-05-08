

soundFiles=dir(fullfile('SoundFiles','*.wav'));
for i=1:length(soundFiles)

    [WaveForm{i},FS{i},NBITS{i},OPTS{i}]=wavread(fullfile('SoundFiles',soundFiles(i).name));
   
    normalize=1;
    if (normalize==1)
        WZ=WaveForm{i}/.10;
        WZ=WZ*.08; % BASICALLY VOLUME CONTROL
        mysound{i} = audioplayer([WZ WZ], FS{i}, NBITS{i});
    else
        mysound{i} = audioplayer([WaveForm{i} WaveForm{i}], FS{i}, NBITS{i});
    end
end

for i=1:length(soundFiles)
    
    disp(['playing ' soundFiles(i).name]);
    playblocking(mysound{i});

end
            
            


