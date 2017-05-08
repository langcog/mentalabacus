function qs = getManyDigits(m,n)

for i = 1:m
  q = round(rand*(10^n));

  % make sure they have that number of digits
  while q <= 10^(n-1) || q >= 10^(n)
    q = round(rand*(10^n));
  end
  
  qs(i) = q;
end


