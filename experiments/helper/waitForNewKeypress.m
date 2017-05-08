% waits for new keypress to happen

function waitForNewKeypress

[keyIsDown, secs, startKeyCode] = KbCheck;
[keyIsDown, secs, keyCode] = KbCheck;

while all(keyCode == startKeyCode) || ~keyIsDown
  WaitSecs(.01);
  [keyIsDown, secs, keyCode] = KbCheck;
  
  if ~keyIsDown, startKeyCode = zeros(size(keyCode)); end;
end