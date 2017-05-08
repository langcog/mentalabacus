function mask = prepMask(ws)

% mask = double(rand(700)>.5)*255; % make a random mask
m = repmat(spatialPattern(ws.rect([4 3]),-1),[1 1 3]);
m = m + abs(min(min(min(m))));
m = m .* (255/max(max(max(m))));
mask = Screen('MakeTexture',ws.ptr,m); % turn it ito a texture
