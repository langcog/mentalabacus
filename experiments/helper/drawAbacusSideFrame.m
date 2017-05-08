function drawAbacusSideFrame(ws,settings,q)

% convert to abacus format
beads = convertQuantityToAbacus(q,settings.abacus.lines);

% first set things up
dims = settings.space_dim;
h_int = dims(2) / (settings.abacus.lines + 2);
v_int = settings.abacus.bead_diam;

l_corner = ws.center(1) - dims(2) + h_int;
r_corner = ws.center(1) + h_int;

% create the lines, first the horizontal
% there should be 5 beads plus the line's width
v_space = (v_int * 5) + settings.abacus.line_width
v_margin = v_int/2
v_top = ws.center(2) - (v_int * 2.5 + v_margin)%(dims(2)/2 + v_margin)
v_bottom = ws.center(2) + (v_int * 2.5 + v_margin)%(dims(2)/2 + v_margin)
v_line_pos = v_top + v_int + v_margin - (settings.abacus.line_width/2);

% h_line_pos = (v_int * 5) + settings.abacus.line_width;
lines = [l_corner + (h_int*.5) r_corner - (h_int*.5); v_line_pos v_line_pos];

% then the vertical
for i = 1:settings.abacus.lines
  lines = [lines [l_corner + (h_int*(i + .5)) l_corner + (h_int*(i+.5)); ...
    v_top v_bottom]];

  %[l_corner + (h_int*(i + .5)) l_corner + (h_int*(i+.5)); ...
    %t_corner + (v_int*.5) b_corner - (v_int*.5)]];
end

% draw lines
Screen('DrawLines', ws.ptr, lines, settings.abacus.line_width, ws.black,[0 0]);

posx = []; posy = [];
% now plan the abacus beads
if q > 0
  p_beads(:,1) = l_corner + ((.5 + beads(:,1)) .* h_int);
  p_beads(:,2) = v_bottom - v_margin - ((beads(:,2)- .5) .* v_int);
  p_beads(beads(:,2)==5,2) = p_beads(beads(:,2)==5,2) - settings.abacus.line_width;
  posx = p_beads(:,1); posy = p_beads(:,2);
end

% now make the marker dots at every third corner
corner_dots = [];
for i = 1:3:settings.abacus.lines
  corner_dots = [corner_dots; [r_corner - ((i + .5) * h_int) v_line_pos]];
end

% Screen('DrawDots', ws.ptr, p_beads', settings.abacus.bead_diam, ws.black, [0 0], 1);
% Screen('DrawDots',ws.ptr,[r_corner - (h_int*1.5) v_line_pos ], 7, ws.white, [0 0], 1);
% Screen('DrawDots',ws.ptr,corner_dots', settings.abacus.line_width-3, ws.white, [0 0], 1);

% filloval workaround for macbooks
diam = settings.abacus.bead_diam;

for i = 1:length(posx)
  Screen('FillOval', ws.ptr, ws.black, [posx(i)-diam/2 posy(i)-diam/2 posx(i)+diam/2 posy(i)+diam/2])
end

for j = 1:length(corner_dots)
  poss = [corner_dots(j,1) - settings.abacus.line_width/3 ...
    corner_dots(j,2) - settings.abacus.line_width/3 ...
    corner_dots(j,1) + settings.abacus.line_width/3 ...
    corner_dots(j,2) + settings.abacus.line_width/3];
  Screen('FillOval',ws.ptr, ws.white, poss);
end
% 
% Screen('FillOval',ws.ptr, ws.white, [(r_corner - (h_int*1.5)) - 3.5 t_corner + (v_int*2.5) - 3.5 ...
%   r_corner - (h_int*1.5) + 3.5 t_corner + (v_int*2.5) + 3.5]); 

% Screen('Flip',ws.ptr);  
