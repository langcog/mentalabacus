function new_n = makeFakeLetters(n)

ns = num2str(n);
i = Randi(length(ns));
ns(i) = num2str(Randi(10)-1);

while str2num(ns) == n & floor(log10(str2num(ns))) ~= floor(log10(n))
  ns(i) = num2str(Randi(10)-1);
end

new_n = str2num(ns);

