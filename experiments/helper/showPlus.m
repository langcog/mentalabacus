function showPlus(ws,settings)  
% write a big +
  
Screen('Flip',ws.ptr);
Screen('TextSize',ws.ptr,settings.textsize);
[x,y] = Screen('TextBounds',ws.ptr,'+');
Screen('DrawText',ws.ptr,'+',ws.center(1)-(x(3)/2),ws.center(2)-x(4)/2,ws.black);
Screen('Flip',ws.ptr);
