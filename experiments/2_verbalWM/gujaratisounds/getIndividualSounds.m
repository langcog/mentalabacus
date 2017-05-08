
[Y,FS,NBITS,OPTS]=wavread('MZ000005.WAV');

figure(1);
plot(Y);

numClicks=0;
while (1)
    drawnow;
    numClicks=numClicks+1;
    [x(numClicks), y(numClicks), button] = ginput(1);
    hold on;
    plot([x(numClicks) x(numClicks)],[-.8 .8],'r-');
    drawnow;
end
save('temp05.mat');

load('temp05.mat')
numSounds=length(x)-1
for i=1:numSounds
    
    [keyIsDown, secs, keyCode, deltaSecs] = KbCheck();
    whichOne=1;
    
    while ~keyCode(KbName('space'))
        figure(1);
        clf
        cY = Y(round(x(i)):round(x(i+1)));
        plot(cY);
        hold on;
        drawnow;

        [keyIsDown, secs, keyCode, deltaSecs] = KbCheck();
        
        keyCode(KbName('upArrow'))
        
        if keyCode(KbName('1!'))
            whichOne=0;
        elseif keyCode(KbName('2@'))
            whichOne=1;
        elseif keyCode(KbName('upArrow'))
            mysound = audioplayer([cY cY], FS, NBITS);
            playblocking(mysound);
            disp('playing');
        elseif keyCode(KbName('leftArrow'))
            x(i+whichOne)=x(i+whichOne)-1000;
        elseif keyCode(KbName('rightArrow'))
            x(i+whichOne)=x(i+whichOne)+1000;
        end

    end
    
    while KbCheck end
    
    if i<10
        fileName = fullfile('Parsed MZ000005', ['MZ000005_sound_0' num2str(i)]);
    else
        fileName = fullfile('Parsed MZ000005', ['MZ000005_sound_' num2str(i)]);
    end
    
    wavwrite(cY,FS,NBITS,fileName);
    
end

