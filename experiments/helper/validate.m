% returns true if there is one group of adjacent '1's

function isValid = validate(settings, s)

if isequal(zeros(settings.grid_dims), s)
  isValid = false;
  return
end

[i,j] = find(s, 1, 'first');  % only need one '1' to start the Tag function

t = tag(s,i,j);

if isequal(zeros(settings.grid_dims), s+t)
  isValid = true;
else
  isValid = false;
end

