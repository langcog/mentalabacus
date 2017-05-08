% start getting input and then eventuall get rid of 
function resp = getNumberInput(ws,disp)

drawText('Which side has more dots?',ws,0,.01);

[resp.resp resp.rt] = twoAFCresponse;

if (resp.resp == 'l' && disp.big_side == 1) || ...
  (resp.resp == 'r' && disp.big_side == 2)
  resp.correct = 1;
else
  resp.correct = 0;
end