

function TF = isAdj( dims, ind1, ind2 )
%checks to see if the positions ind1 and ind2 are adjacent in matrix M and returns true or false accordingly
[i1,j1] = ind2sub(dims, ind1);
[i2,j2] = ind2sub(dims, ind2);
if i1 == i2 && abs(j1-j2) == 1
    TF = true;
elseif j1 == j2 && abs(i1-i2) == 1
    TF = true;
else
    TF = false;
end

