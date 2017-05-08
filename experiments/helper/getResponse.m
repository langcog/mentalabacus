% courtesy EV
% rewritten for better dynamics MCF 10/10/08

function pressedkey=getResponse(willTake)

[keyIsDown, secs, startKeyCode] = KbCheckM;
[keyIsDown, secs, keyCode] = KbCheckM;

goodkeydown = 0;

while all(keyCode == startKeyCode) || ~goodkeydown;
  WaitSecs(.01);
  
  [keyIsDown, secs, keyCode] = KbCheckM;
  
  for i = 1:length(willTake)
    if any(keyCode(KbName(willTake{i}))) % if key with that name is down
      pressedkey = willTake{i};
      goodkeydown = 1;
    end
  end
  
  if ~keyIsDown, startKeyCode = zeros(size(keyCode)); end;
end

