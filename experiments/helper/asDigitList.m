function d = asDigitList(n)

s = num2str(n);

for i = 1:length(s)
  d(i) = str2num(s(i));
end
