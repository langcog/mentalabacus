function K = computeK(n,m,PC)

% n=number of letters in the list to remember
% m=number of possible letters
% PC=proportion of letters correctly reported
%
% model
% assumes that if you remember the items, you report them correctly, and
% that you guess randomly for items you don't remember.

% In general:
% PC = K/N + (N-K)/N * 1/(M-K)

% For example, say there were 8 items to remember (N=8), and you could remember 6
% of them. Then you would report N/K = 6/8 letters correctly for sure. On
% the remaining letters, (N-K)/N = (8-6)/8 = 2/8, you'll guess. Since there
% are 20 possible letters, and you already reported 6, your guessing rate
% will be 1/(20-6) = 2/14. So your two guesses will randomly be correct
% 2/14 proportion of the time.

% so...
% PC = 6/8 + 2/8 * 1/14 = 76.79

% uncomment the following lines to simulate some data
% n = 8
% m = 20
% 
% simK=6
% PC = simK./n + (n-simK)./n .* 1./(m-simK)

% n = [2 3 4 5 6 7];
% PC = [1.0000    1.0000    1.0000    1.0000    0.9260    0.7860]

% the general equation can be solved for K by simplifying 

K = (PC.*n.*m-n.^2)./(m+PC.*n-2.*n);

