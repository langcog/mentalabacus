function qs = getDigits3(n)

q1 = round(rand*(10^n));
q2 = round(rand*(10^n));

% make sure they have that number of digits
while q1 <= 10^(n-1) || q2 <= 10^(n-1) || ...
    q1 >= 10^(n) || q2 >= 10^(n)

  q1 = round(rand*(10^n));
  q2 = round(rand*(10^n));
end

qs = [q1 q2];


