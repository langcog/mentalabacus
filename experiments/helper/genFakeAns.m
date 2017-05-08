% Generates fake answer based on final shape.  Differs by 1 square from original

function [f f_ord] = genFakeAns(settings,s,ord) 

% loop breaks when an appropriate position has been found to alter the
% shape

% pick random '1' to remove (turn to '0')
f = s;
f_ord = ord;

changed = Randi(size(ord,1));
f(ord(changed,1),ord(changed,2)) = 0;

% now pick a random zero
[i,j] = find(s == 0); 
n = Randi(length(i));
f(i(n),j(n)) = 1;
f_ord(changed,:) = [i(n) j(n)];

% [i,j] = find(s); 
% n = Randi(length(i));
% f(i(n),j(n)) = 0;
% 
% % find all zeros in s (doesn't include the newly created zero in f)
% % make one into a 1
 