% if the last two are right AND the last two are the same number
  
function n = staircase(n,c,min_n,i)

if i > 2 && c(i-1) && c(i-2) && ...
    n(i-1)==n(i-2)    
  n(i) = n(i-1)+1;
elseif i > 2 && ~c(i-1) % if the last one was an error
  n(i) = max([n(i-1)-1 min_n]);
elseif i > 2
  n(i) = n(i-1);
else
  n(i) = min_n;
end