function [pg tf] = genProbeGrid(grid)

if rand > .5, tf = true; else tf = false; end;

nfilled = sum(sum(grid == 1));
mask = randperm(nfilled);

if tf 
  [i,j] = find(grid==1,mask(1));
else
  [i,j] = find(grid==0,mask(1));
end

pg = zeros(size(grid));
pg(i(end),j(end)) = 1;
