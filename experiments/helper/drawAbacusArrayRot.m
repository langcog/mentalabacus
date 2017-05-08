function drawAbacusArray(ws,settings,q)

% convert to abacus format
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

% draw it all
xoffset = -300;
yoffset = 300;

lines = [lines(2,:); lines(1,:)];
p_beads = [p_beads(:,2) p_beads(:,1)];
p_beads(:,2)  = p_beads(:,2) - yoffset;
p_beads(:,1)  = p_beads(:,1) - xoffset;
lines(2,:)  = lines(2,:) - yoffset;
lines(1,:)  = lines(1,:) - xoffset;
Screen('DrawLines', ws.ptr, lines, settings.abacus.line_width, ws.black,[0 0]);
Screen('DrawDots', ws.ptr, p_beads', settings.abacus.bead_diam, ws.black, [0 0], 1);

% now make the marker dots at every third corner
corner_dots = [];
for i = 1:3:settings.abacus.lines
  corner_dots = [corner_dots; [r_corner - ((i + .5) * h_int) v_line_pos]];
end

corner_dots = [corner_dots(:,2) corner_dots(:,1)];
corner_dots(:,2) = corner_dots(:,2) - yoffset;
corner_dots(:,1) = corner_dots(:,1) - xoffset;
% Screen('DrawDots',ws.ptr,[r_corner - (h_int*1.5) v_line_pos ], 7, ws.white, [0 0], 1);
Screen('DrawDots',ws.ptr,corner_dots', settings.abacus.line_width-3, ws.white, [0 0], 1);
Screen('Flip',ws.ptr);  