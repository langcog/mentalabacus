function ws = doScreen

try
	% screen stuff
  Screen('Preference', 'SkipSyncTests',1);
	screens=Screen('Screens');
	screenNumber=0; %max(screens);
	[ws.ptr, ws.rect] = Screen('OpenWindow',screenNumber);
	ws.center = [ws.rect(3) ws.rect(4)]/2;
	ws.black = BlackIndex(ws.ptr);
  ws.white = WhiteIndex(ws.ptr);
  ws.width = ws.rect(3);
  ws.halfw = ws.width/2;
  ws.height = ws.rect(4);
  ws.halfh = ws.height/2;
  
  % needed for drawdots
  Screen('BlendFunction',ws.ptr,'GL_SRC_ALPHA','GL_ONE_MINUS_SRC_ALPHA');
  
	Screen('TextFont',ws.ptr, 'Geneva');
	Screen('TextSize',ws.ptr,24);
% 	Screen('FillRect', ws.ptr, ws.black);
  Screen('FillRect', ws.ptr, ws.white/2);
	Screen('Flip',ws.ptr);
	HideCursor;
catch
	cls;
end