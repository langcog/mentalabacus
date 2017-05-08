%NOTE:  S(i,j) MUST equal 1.  This will not work correctly if it does not.
%recursively tags all stones in an adjacent group, starting with position S(i,j)
%'tagging' means changing each 1 to a -1;  function returns the tagged grid

function T = tag( S, i, j )

S(i,j) = -1;
T = S;

if i > 1 && T(i-1,j) == 1  %north
    T = tag(T,i-1,j);
end
if i < 3 && T(i+1,j) == 1  %south
    T = tag(T,i+1,j);
end
if j > 1 && T(i,j-1) == 1  %west
    T = tag(T,i,j-1);
end
if j < 4 && T(i,j+1) == 1  %east
    T = tag(T,i,j+1);
end

