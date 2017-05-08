function [q1 q2] = getDigits2(n)

% split the n digits between the two numbers

% split = Randi(n-1);

%nonrandom split
split = floor(n/2);

n1 = n - split;
n2 = n - (n-split);

q1 = round(rand*(10^n1));
q2 = round(rand*(10^n2));

% make sure they have that number of digits
while q1 <= 10^(n1-1) || q2 <= 10^(n2-1) || ...
    q1 >= 10^(n1) || q2 >= 10^(n2)

  q1 = round(rand*(10^n1));
  q2 = round(rand*(10^n2));
end


