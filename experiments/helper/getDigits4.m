function qs = getDigits4(n)

qs = round(rand*(10^n));

% make sure they have that number of digits
while qs <= 10^(n-1) || qs >= 10^(n) 
  qs = round(rand*(10^n));
end


