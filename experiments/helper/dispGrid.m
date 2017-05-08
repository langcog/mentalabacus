% helper function
% display grid one square at a time
% now unordered

function dispGrid(ws,n,settings,rand_ord)

for j = 1:n
  % fill in squares
  temp_grid = zeros(settings.grid_dims);
  temp_grid(rand_ord(j,1),rand_ord(j,2)) = 1;

  % draw
  drawGrid(ws, settings, ws.halfw, ws.halfh, settings.box_size, temp_grid);
  Screen('Flip', ws.ptr);

  % wait
  WaitSecs(settings.tile_time);
end

drawGrid(ws, settings, ws.halfw, ws.halfh, settings.box_size, ...
  zeros(settings.grid_dims));
Screen('Flip',ws.ptr);
WaitSecs(settings.fix_time);
