function sequentialLetters(ws,settings,d)

for i = 1:length(d)
  [x1,y1] = Screen('TextBounds',ws.ptr,d{i});
  Screen('DrawText',ws.ptr,d{i},ws.center(1)-(x1(3)/2),ws.center(2),ws.black);
  Screen('Flip',ws.ptr)
  WaitSecs(settings.tile_time);
end
