clear all

ratios = [1 5; 1 4; 1 3; 1 2; 2 3; 3 4; 4 5; 5 6; 6 7; 7 8; 8 9; 9 10; 10 11; 11 12; 12 13; 13 14; 14 15];
for i = 1:length(ratios)
  ratios_txt{i} = [num2str(ratios(i,1)) '/' num2str(ratios(i,2))];
end

figure(1)
clf

% get all filenames
files = dir('IndiaAdapt2010/*.mat');
files = {files.name};

% for each one, plot
for f = 1:length(files)
  % load the data
  load(['IndiaAdapt2010/' files{f}]);
  level_number = [levnum{:}];
  accuracy = [accur{:}];
  
  % set up the plot
  subplot(ceil(sqrt(length(files))),ceil(sqrt(length(files))),f)
  cla
  hold on
  plot(level_number)
  axis([0 22 0 15])
  title(files{f}(11:end-12))
  
  % now put on a summary stat
  range = length(level_number)-3:length(level_number);
  means(f) = mean(level_number(range));
  m = max(level_number(accuracy>=.75));
  if ~isempty(m)
    maxs(f) = m;
  else
    maxs(f) = 1;
  end
  
  plot(range,repmat(means(f),1,length(range)),'r-')
  text(length(level_number)+.5,means(f),ratios_txt{round(means(f))}, ...
    'Color',[1 0 0])
  set(gca,'XTick',[],'YTick',[]);
end

%%
figure(2)
clf

n = 16
subplot(1,2,1)
hist(means,1:n)
set(gca,'XTick',0:n,'XTickLabel',ratios_txt)
axis([0 n 0 20])
title('mean of last 4 trials')

subplot(1,2,2)
hist(maxs,1:n)
set(gca,'XTick',0:n,'XTickLabel',ratios_txt)
axis([0 n 0 20])
title('max with >= .75 acc')