clear all
ws.center = [512 384];
ws.height = 768;
ws.width = 1024;

setSettingsEstimation

for k = 1:100
  q = 120;
  
  diam = settings.dots.diam * (rand + .5);
  space_dim = settings.space_dim .* (rand + .5);
  bound = diam * .5;

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
    tx = ws.center(1)+round((rand-.5)*(space_dim(2) - diam));
    ty = ws.center(2)+round((rand-.5)*(space_dim(1) - diam));
    dist = sqrt(((posx-tx).^2) + (posy-ty).^2);

    i = 1;
    % repeat until they're not overlapping
    while sum(dist < diam + bound)
      tx = ws.center(1)+round((rand-.5)*(space_dim(2) - diam));
      ty = ws.center(2)+round((rand-.5)*(space_dim(1) - diam));
      dist = sqrt(((posx-tx).^2) + (posy-ty).^2);
      i = i + 1;
      if i > 2000, disp('rejected overlap, ack!'); break; end;
    end

    posx = [posx tx];
    posy = [posy ty];
  end
  
  % draw them 
  cla
  for l = 1:length(posx)    
    rectangle('Position',[posx(l) posy(l) diam diam],'Curvature',[1 1],'FaceColor',[0 0 0]);
    text(posx(l),posy(l),num2str(l))
  end
  
  axis([0 1024 0 768          ]);
  drawnow
  waitForNewKeypress; 
end