function l = getLetters(n)

letters = {'B','C','D','F','G','H','J','K','L','M','N','P','Q','R','S','T','V','W','X','Z'};

o = randperm(length(letters));
l = letters(o(1:n));