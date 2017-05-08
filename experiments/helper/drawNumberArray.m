function drawNumberArray(ws,settings,q)  
% write the number q in the center of the screen
  
Screen('Flip',ws.ptr);
Screen('TextSize',ws.ptr,settings.textsize);
[x,y] = Screen('TextBounds',ws.ptr,num2str(q));
Screen('DrawText',ws.ptr,num2str(q),ws.center(1)-(x(3)/2),ws.center(2)-x(4)/2,ws.black);
Screen('Flip',ws.ptr);
