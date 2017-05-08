function sequentialDigits(ws,settings,d)

ds = num2str(d);

for i = 1:length(ds)
  [x1,y1] = Screen('TextBounds',ws.ptr,ds(i));
  Screen('DrawText',ws.ptr,ds(i),ws.center(1)-(x1(3)/2),ws.center(2),ws.black);
  Screen('Flip',ws.ptr)
  WaitSecs(settings.tile_time);
end
