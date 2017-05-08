%%%% This function was created in 6/10 by JS at UCSD for India & related projs

%It reads image names from a folder, and then calls them up onto the  %
%screen. To test this program, please use -1 as the subject number.   %

% mod mcf june 2010 for Zenith 2010 study
% mod mcf march 2011 for Zenith 2011 study
%  - noted bug in 2010 version: aspect ratio was off on left image (small)
%  - fixed alpha blending 
%  - modified data read, added photo capacity

function numberComparison

%% SETUP

home

fprintf('Number comparison experiment!\n\n');
subnum = input('Subject number: '); 

PsychJavaTrouble;
Screen('Preference', 'VisualDebugLevel',3);
Screen('Preference', 'SuppressAllWarnings', 1);

addpath('../helper'); %makes sure that the program has access to some additional 
start_time = GetSecs; %determines when the entire program began.

if ~isnumeric(subnum)
  error('Subject code must be a number!  Try again using the syntax "readfolder2(1)"\n')
elseif ~isempty(dir(['Adapt/' 'PING' num2str(subnum) '-overall.mat'])) && subnum~=-1 
  error('datafile already exists!')
end

savetexty(.4); % saves baseline accuracy as .4. 
settings.experiment_time_limit = 600; 

HideCursor; %hides cursor
% FlushEvents %gets rid of an extraneous key presses
resp ='xxxx'; %to be used in the while loops later

[wPtr,rect]=Screen('OpenWindow',0, [255 255 255]/2, []); % prepare PTB, bracket with [1 1 1] sets background color.
center = rect/2;
Screen('TextFont',wPtr,'Courier');
Screen('TextSize',wPtr,40);

% MCF BLOCK
addpath('../helper');
Screen('BlendFunction', wPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
if subnum ~= -1
  exp.subphoto = grabFrame(wPtr);
end
[~,exp.hostname] = unix('hostname'); 
exp.hostname = strrep(exp.hostname,'.local',''); 
exp.hostname = exp.hostname(1:end-1);
exp.name = 'numberComparison';
exp.sid = num2str(subnum);
exp.dateStr = datestr(now,30);
fid = fopen(['../' exp.hostname '_subject_log.txt'],'a');
fprintf(fid,'%s,%s,%s,%s\n',exp.hostname,exp.name,exp.sid,datestr(now,31));
fclose(fid);

% NOW PAUSE BEFORE BEGINNING
Screen('DrawText',wPtr, 'Press any key to begin.', center(3)-300, center(4), [0 0 0]);
Screen(wPtr, 'Flip'); %put image on screen
% waitForNewKeypress;

%% FIRST LEVEL

i=1; %defines i (trial number) as 1. We already did this, but this just makes sure that the program doesn't get confused, especially if there were any errors above.
levelname(i)=5;  %first level will always be seven if testing children 5 or older, 1 if 5 or younger.
level{i}=levelname; % creates a way to store more than one level name
levelz=levelname(i) ; % provides input for experiment, tells the experiment which level to look at.
showNumCompImages(levelz,wPtr,rect,exp)

i=i+1 ; %increases the i
load acc.mat; % loads the accuracy from the previous run
accuracy = cell2mat(accuracy1); %converts loaded info into a usable number
accur{i}=accuracy;
levnum{i}=levelz;
save(['Data/' exp.name '_' exp.sid '_' exp.dateStr '_' exp.hostname '.mat'], 'accur', 'levnum','exp');

%% ADAPTIVELY CREATES THE SECOND LEVEL    

if accuracy >= .75  %if they have mastered the previous level
    levelname(i)= min([cell2mat(level(1:1,i-1:i-1))+1 16]); % the next level will be either 1 higher than the previous or level 12, whichever is smaller.
else
  levelname(i)= max([cell2mat(level(1:1,i-1:i-1))-1 1]); %the next level will be either 1 lower thant he previous level or 1, whichever is larger.
end
    
level{i}=levelname; %updates level name
levelz=levelname(i); % provides level input for experiment

showNumCompImages(levelz,wPtr,rect,exp)
i=i+1;
load acc.mat;
accuracy = cell2mat(accuracy1);
accur{i}=accuracy;
levnum{i}=levelz;
save(['Data/' exp.name '_' exp.sid '_' exp.dateStr '_' exp.hostname '.mat'], 'accur', 'levnum','exp');
    
%% TIMED EXPERIMENT BEGINS... THE FIRST TWO LEVELS ARE UNTIMED

% BEGINS A LOOP THAT WILL RUN UNTIL TIME LIMIT IS UP   
while GetSecs - start_time < settings.experiment_time_limit; %defines how long the program will run. change settings.experiment_time_limit if you want to change this. 

  load acc.mat;
  accuracy = cell2mat(accuracy1);

  if accuracy >=.75
    levelname(i)=min([levelname(i-1)+1 16]);
  else
    levelname(i)=max([levelname(i-1)-1 1]);
  end

  levelz=levelname(i);
  showNumCompImages(levelz,wPtr,rect,exp)
  i=i+1;
  accur{i}=accuracy;
  levnum{i}=levelz;
  save(['Data/' exp.name '_' exp.sid '_' exp.dateStr '_' exp.hostname '.mat'], 'accur', 'levnum','exp');
end

%% CLOSES THE PROGRAM
ShowCursor; %%shows cursor
cls;
