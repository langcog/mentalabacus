% grab a single frame that's an image from the iSight

function img = grabFrame(varargin)

  % variables
  codec = ':CodecType=1635148593'; % H.264 codec.
  moviename = 'movie.mov';
  withsound = 0;

  % open window if there isn't one
  if nargin > 0 
    ws.ptr = varargin{1};    
  else
    oldsynclevel = Screen('Preference', 'SkipSyncTests');
    screen=max(Screen('Screens')); 
    ws.ptr=Screen('OpenWindow', screen);    
  end

  [w h] = Screen('WindowSize', ws.ptr);
  ws.center = [w/2 h/2];
  ws.black = [0 0 0];
  
  % now get frame
  try
    drawText('Press space for photo.',ws,1);
    Screen('Flip',ws.ptr);
        
    grabber = Screen('OpenVideoCapture', ws.ptr, [], [],[] ,[], [] , [moviename codec], withsound);
    Screen('StartVideoCapture', grabber, 30, 1);   

    good_photo = false;
    while ~good_photo
      tex = Screen('GetCapturedImage', ws.ptr, grabber, 1, 0);
      Screen('DrawTexture', ws.ptr, tex);
      Screen('DrawText',ws.ptr,'Good photo (y/n)?',ws.center(1)-400, ws.center(2)-350);
      Screen('Flip',ws.ptr);
      if getResponse({'y','n'}) == 'y', good_photo = 1; else good_photo = 0; end;
    end

    img = Screen('GetImage',ws.ptr, ...
      [ws.center(1) - 400 ws.center(2) - 300 ws.center(1) + 400 ws.center(2) + 300]);
    
    Screen('Flip',ws.ptr);
    Screen('StopVideoCapture', grabber);
    Screen('CloseVideoCapture', grabber);  
  
  catch exception
    exception
    
    for i = 1:length(exception.stack)
      exception.stack(i).file
      exception.stack(i).name
      exception.stack(i).line
    end
    img = -1;
  end
  
  % close window if there isn't one
  if nargin > 0 
  else
    Screen('CloseAll')
    Screen('Preference', 'SkipSyncTests', oldsynclevel);
  end
end