function q = convertQuantityToAbacus(x,lines)

q = [];
for i = 1:lines
  place(i) = floor(mod(x,10^i)/(10^(i-1)));
  top(i) = place(i) >= 5;
  bottom(i) = place(i) - (top(i)*5);
  
  if top(i)
    q = [q; lines-i+1 5];      
  end

  if bottom(i) > 0
    for j = 1:bottom(i)
      q = [q; lines-i+1 5-j];
    end
  end
    
end
