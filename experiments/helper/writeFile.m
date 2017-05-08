    
function WriteFile(sFilename,DataArray)
fid = fopen(sFilename,'w');
[r,c] = size(DataArray);

for i = 1:r
  for j = 1:c-1
    fprintf(fid,'%s',[num2str(DataArray{i,j}) ',']);
  end
  
  fprintf(fid,'%s\n',[num2str(DataArray{i,end})]);  
end

fclose(fid);
