% Generates and returns mxn matrix corresponding to the final shape: 0 means not filled, 1 means filled.
% Total number of filled squares for easy = 4, for hard = 8
% also returns a random order o

function [s o] = genShape(grid_dims, num_squares)

s = zeros(grid_dims);

% make grid
while sum(sum(s)) < num_squares
  m = ceil(grid_dims(1)*rand);
  n = ceil(grid_dims(2)*rand);
  s(m,n) = 1;
end

% make order
[ord(:,1),ord(:,2)] = find(s);  
ord_mask = randperm(size(ord,1));
o = ord(ord_mask,:);

