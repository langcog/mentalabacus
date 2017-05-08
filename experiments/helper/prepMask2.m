function mask = prepMask2(ptr,rect)

% mask = double(rand(700)>.5)*255; % make a random mask
m = repmat(spatialPattern([rect(4) rect(3)],-1),[1 1 3]);
m = m + abs(min(min(min(m))));
m = m .* (255/max(max(max(m))));
mask = Screen('MakeTexture',ptr,m); % turn it ito a texture

size(m)