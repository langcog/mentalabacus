% Draws a 3-by-4 grid of squares centered at (x,y). 'd' is side-length of each square
% F is a matrix which specifies which square(s) to fill

function drawGrid(ws, settings, x, y, d, F)

topleft = [x - (settings.grid_dims(1)*d)/2, y - (settings.grid_dims(2)*d)/2];  %of box
bottomright = [x + (settings.grid_dims(1)*d)/2, y + (settings.grid_dims(2)*d)/2];  %of box

% fill area with white
bg_rect = repmat(255,round([bottomright - topleft]));
bg_text = Screen('MakeTexture',ws.ptr,bg_rect);
Screen('DrawTexture',ws.ptr,bg_text,[0 0 size(bg_rect)],[topleft bottomright]);
% Screen('FillRect', ws.ptr, ws.white, [topleft, bottomright]);

% fill squares (before drawing gridlines)

blue(1,1,1) = 0; blue(1,1,2) = 0; blue(1,1,3) = 255;
grid_rect = repmat(blue,[d d 1]);
grid_text = Screen('MakeTexture',ws.ptr,grid_rect);

for row = 1:settings.grid_dims(1)
  for col = 1:settings.grid_dims(2)
    if F(row,col) == 1
      rect_coords = [topleft(1) + d*(row-1) topleft(2) + d*(col-1) ...
        topleft(1) + d*(row) topleft(2) + d*(col)];
      Screen('DrawTexture',ws.ptr,grid_text,[0 0 size(grid_rect,1) size(grid_rect,2)],rect_coords);      
%      Screen('FillRect', ws.ptr, [0 0 255], rect_coords);
    end
  end
end

% draw frame
Screen('FrameRect', ws.ptr , ws.black, [topleft, bottomright], 2);

% draw m vertical gridlines
for i = 1:settings.grid_dims(1)
  Screen('DrawLine', ws.ptr, ws.black, topleft(1) + (d * (i-1)), ...
    topleft(2), topleft(1) + (d * (i-1)), bottomright(2), 2);
end

% draw n horizontal gridlines
for i = 1:settings.grid_dims(2)
  Screen('DrawLine', ws.ptr, ws.black, topleft(1), ...
    topleft(2) + (d * (i-1)), bottomright(1), topleft(2) + (d * (i-1)), 2);
end
