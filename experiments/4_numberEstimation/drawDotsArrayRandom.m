function [space_dim diam] = drawDotsArrayRandom(ws,settings,q)  
% make q dots in random locations

diam = settings.dots.diam * (rand + .5);
space_dim = settings.space_dim .* (rand + .5);
bound = diam * 2;

% make sure that everything fits
while q * diam^2 * 10 > prod(space_dim)
  % 3 is an arbitrary extra factor
  diam = settings.dots.diam * (rand + .5);
  space_dim = settings.space_dim .* (rand + .5);
  disp('rejected diam & envelope');
end

posx = [];
posy = [];
for j = 1:q
  tx = ws.center(1)+round((rand-.5)*space_dim(2));
  ty = ws.center(2)+round((rand-.5)*space_dim(1));
  dist = sqrt(((posx-tx).^2) + (posy-ty).^2);

  i = 1;
  % repeat until they're not overlapping
  while sum(dist < diam + bound)
    tx = ws.center(1)+round((rand-.5)*space_dim(2));
    ty = ws.center(2)+round((rand-.5)*space_dim(1));
    dist = sqrt(((posx-tx).^2) + (posy-ty).^2);
    i = i + 1;
    if i > 2000, disp('rejected overlap'); break; end;
  end

  posx = [posx tx];
  posy = [posy ty];
end

% filloval workaround for macbooks
for i = 1:length(posx)
  Screen('FillOval', ws.ptr, ws.black, [posx(i)-diam/2 posy(i)-diam/2 posx(i)+diam/2 posy(i)+diam/2])
end

% Screen('DrawDots', ws.ptr, [posx; posy], diam, ws.black, [0 0], 1);
Screen('Flip',ws.ptr);
  
