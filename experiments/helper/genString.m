function string = genString(wavs,n)

ord = randperm(length(wavs));
string = ord(1:n);