function dot = newDot(side,envelope,envelope_tl)    

center = [Randii(envelope(1)-side) Randii(envelope(2)- side)] + ...
    envelope_tl + side/2;           
    
dot = [center(1) - side/2 ...
  center(2) - side/2 ...
  center(1) + side/2 ...
  center(2) + side/2];      

function i = Randii(n)

i=ceil(n*rand);