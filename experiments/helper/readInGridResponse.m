function [r rt] = readInGridResponse(ws,settings)

ShowCursor;

r = zeros(settings.grid_dims);
x = ws.halfw;
y = ws.halfh;
d = settings.box_size;

topleft = [x - (settings.grid_dims(1)*d)/2, y - (settings.grid_dims(2)*d)/2];  %of box
% bottomright = [x + (settings.grid_dims(1)*d)/2, y + (settings.grid_dims(2)*d)/2];  %of box

% set vertical gridlines
for i = 1:settings.grid_dims(1)+1
  horiz_sides(i) = topleft(1) + (d * (i-1));
  vert_sides(i) = topleft(2) + (d * (i-1));
end

% vert_sides = ws.rect(4) - vert_sides;

%% major loo
WaitSecs(.2);

begin_time = GetSecs;
drawGrid(ws, settings, ws.halfw, ws.halfh, settings.box_size, r);
Screen('Flip', ws.ptr);

while ~KbCheck
  
  [x,y,buttons] = GetMouse;
  
  to_fill_x = find(horiz_sides > x,1,'first') - 1;
  to_fill_y = find(vert_sides > y,1,'first') - 1;
  
  if numel(to_fill_x) == 1 && numel(to_fill_y) == 1 && buttons(1) == 1 && ...
      to_fill_x > 0 && to_fill_y > 0
    r(to_fill_x,to_fill_y) = 1 - r(to_fill_x,to_fill_y);
    drawGrid(ws, settings, ws.halfw, ws.halfh, settings.box_size, r);
    Screen('Flip', ws.ptr);
    WaitSecs(.1);
  end  
end

rt = GetSecs - begin_time;

HideCursor;
