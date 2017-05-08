% Data analysis script

%% directory
% -------------------------------------------------------------------------

topDir=pwd;
seps=find(topDir==filesep);
dataDir=fullfile(topDir(1:seps(end)),'DataFiles','MatFiles');


%% get data files
% -------------------------------------------------------------------------

dataFiles=dir(fullfile(dataDir,'*.mat'));

% drop if it doesn't have enough trials
numTrials=[];
dropThese=[];
for i=1:length(dataFiles)
    load(fullfile(dataDir,dataFiles(i).name));
    if length(D.setSize)<25
        dropThese(i) = 1;
    else
        dropThese(i) = 0;
    end
end
dataFiles(find(dropThese))=[];

% drop if it is in the exclude list

excludeSID={'t1','t4'};

% get subject IDs
for i=1:length(dataFiles)
    
