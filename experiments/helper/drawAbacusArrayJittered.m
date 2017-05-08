function drawAbacusArrayJittered(ws,settings,q)

%% convert to abacus format
clear p_beads
beads = convertQuantityToAbacus(q,settings.abacus.lines);

% first set things up
dims = settings.space_dim;
h_int = dims(2) / (settings.abacus.lines + 2);
v_int = settings.abacus.bead_diam;

l_corner = ws.center(1) - (dims(2)/2);
t_corner = ws.center(2) - (dims(1)/2);
r_corner = ws.center(1) + (dims(2)/2);
b_corner = ws.center(2) + (dims(1)/2);

% create the lines, first the horizontal
% there should be 5 beads plus the line's width
v_space = (v_int * 5) + settings.abacus.line_width;
v_margin = (dims(1) - v_space)/2;
v_top = ws.center(2) - dims(1)/2 + v_margin; 
v_bottom = ws.center(2) + dims(1)/2 - v_margin;
v_line_pos = v_top + (v_int) + settings.abacus.line_width/2;

% h_line_pos = (v_int * 5) + settings.abacus.line_width;
lines = [l_corner + (h_int*.5) r_corner - (h_int*.5); v_line_pos v_line_pos];

% then the vertical
for i = 1:settings.abacus.lines
  lines = [lines [l_corner + (h_int*(i + .5)) l_corner + (h_int*(i+.5)); ...
    t_corner + (v_int*.5) b_corner - (v_int*.5)]];
end

% now plan the abacus beads
p_beads(:,1) = l_corner + ((.5 + beads(:,1)) .* h_int);
p_beads(:,2) = v_bottom - ((-.5 + beads(:,2)) .* v_int);
p_beads(beads(:,2)==5,2) = p_beads(beads(:,2)==5,2) - settings.abacus.line_width;

% now get the bounding rectangle
b_rect = [min(p_beads,[],1) max(p_beads,[],1)];
b_dim = [b_rect(3) - b_rect(1) b_rect(4) - b_rect(2)] + settings.extra_jitter;
b_center = [b_rect(1) + b_dim(1)/2 b_rect(2) + b_dim(2)/2];

% now draw a comparable dot array
diam = settings.abacus.bead_diam;

num_beads = size(p_beads,1);

% big loop that tries to ensure a good configuration
% very hacky
c = 1;
overlap = ones(1,num_beads);
while any(overlap)
  overlap = zeros(1,num_beads);
  posx = [];
  posy = [];

  for j = 1:num_beads
    tx = b_center(1)+round((rand-.5)*b_dim(1));
    ty = b_center(2)+round((rand-.5)*b_dim(2));
    dist = sqrt(((posx-tx).^2) + (posy-ty).^2);
    
    i = 1;
    % repeat until they're not overlapping
    while sum(dist < (diam)+1)
      tx = b_center(1)+round((rand-.5)*b_dim(1));
      ty = b_center(2)+round((rand-.5)*b_dim(2));
      dist = sqrt(((posx-tx).^2) + (posy-ty).^2);
      i = i + 1;
      if i > 2000, overlap(j)=1; break; end;
    end
    
    posx = [posx tx];
    posy = [posy ty];
  end
  
  if c > 2000
    disp('*** NO NON-OVERLAPPING LOCATION ***');
    overlap = zeros(1,num_beads); % just move on
    break; 
  end
    
  c = c + 1;
end

p_jitter_beads = [posx; posy]

%% draw it all
Screen('DrawDots', ws.ptr, p_jitter_beads, settings.abacus.bead_diam, ws.black, [0 0], 1);
Screen('Flip',ws.ptr);  