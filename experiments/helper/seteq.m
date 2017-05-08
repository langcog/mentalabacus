function tf = seteq(a,b)

if length(a) == length(b)
  tf = true;
  
  for i = 1:length(a)
    if a{i} ~= b{i}
      tf = false;
    end
  end
else
  tf = false;
end

