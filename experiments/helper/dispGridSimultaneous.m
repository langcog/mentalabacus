% helper function
% display grid one square at a time
% now unordered

function dispGridSimultaneous(ws,settings,grid)

drawGrid(ws, settings, ws.halfw, ws.halfh, settings.box_size, grid);
Screen('Flip', ws.ptr);
