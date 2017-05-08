% abacusMagnitudeTest
% mcf and db 7/1/08 
% compares magnitude estimation with abacus reading in terms of speed and
% accuracy
%
% note: to test, put subject number as -1.
% 
% revised 7/31/08 - added instructions, practice trials
% revised 8/19/08 - added numerals, some bug fixes
% revised 10/10/08 - fixed quantities, cleaned up abacus displays
% revised 3/6/11 - changed quantities, revised for Zenith study

function numberEstimation

home
fprintf('Number estimation experiment!\n\n');
subnum = input('Subject number: '); 

PsychJavaTrouble;
Screen('Preference', 'VisualDebugLevel',3);
Screen('Preference', 'SuppressAllWarnings', 1);

ListenChar(2); % disable write to matlab
addpath('../helper');
start_time = GetSecs;

if ~isnumeric(subnum)
  error('Subject code must be a number!  Try again using the syntax "abacusMagnitudeTest(1)"\n')
end

ws = doScreen;
mask = prepMask(ws);
setSettingsEstimation;

% OUTPUT BLOCK
Screen('TextSize',ws.ptr,32);
Screen('TextFont',ws.ptr,'Courier');
addpath('../helper');
Screen('BlendFunction', ws.ptr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
if subnum ~= -1
  exp.subphoto = grabFrame(ws.ptr);
end
[~,exp.hostname] = unix('hostname'); 
exp.hostname = strrep(exp.hostname,'.local',''); 
exp.hostname = exp.hostname(1:end-1);
exp.name = 'numberEstimation';
exp.sid = num2str(subnum);
exp.dateStr = datestr(now,30);
fid = fopen(['../' exp.hostname '_subject_log.txt'],'a');
fprintf(fid,'%s,%s,%s,%s\n',exp.hostname,exp.name,exp.sid,datestr(now,31));
fclose(fid);

% NOW PAUSE BEFORE BEGINNING
Screen('TextSize',ws.ptr,settings.textsize);
drawText('Press any key to begin',ws,1);

%% keypad training
if subnum ~= -1
  drawText('Keypad practice',ws,1);
  
  train_success = 0;
  j = 1;
  while ~train_success
    for i = 1:settings.num_training
      drawText(num2str(settings.training_items(i)),ws,0,settings.training_wait_times(i));    
      showMask(ws,mask);
      WaitSecs(settings.before_prompt_interval);
      [train_resp(j,i) train_rt(j,i,1) train_rt(j,i,2)] = readInResponse(ws,mask,settings,1);

      % give feedback
      train_correct(j,i) = train_resp(j,i) == settings.training_items(i);
      if train_correct(j,i)
        showFeedbackImage('images/Happy.jpg',ws.ptr,.6);
      else   
        showFeedbackImage('images/Sad.jpg',ws.ptr,.6);
      end

      % save the data after every trial
      save(['Data/' exp.name '_' exp.sid '_' exp.dateStr '_' exp.hostname '.mat'], 'settings','train_resp','train_rt','train_correct','exp');

      % now clear 
      Screen('Flip',ws.ptr);
      WaitSecs(settings.isi);
    end
    
    % finish if all trials after trial 1 are correct
    if sum(train_correct(j,2:end)) == length(train_resp(j,2:end)), 
      train_success=1; 
    end
  end
else
  train_resp = []; train_rt = []; train_correct = [];
end

%% basic loop for the experiment

drawText('Wait for teacher',ws,1);

% set the quantities for this block
settings.quants = settings.quants(randperm(length(settings.quants))); 
    
% now test them 
i = 1;
start_time = GetSecs;
while GetSecs - start_time < settings.experiment_duration && i <= 300
  [settings.envelope(i,:) settings.diam(i)] = drawDotsArrayRandom(ws,settings,settings.quants(i));    
  
  WaitSecs(settings.viewing_interval);
  showMask(ws,mask);
  WaitSecs(settings.before_prompt_interval);
  [resp(i) rt(i,1) rt(i,2)] = readInResponse(ws,mask,settings,1);

  % save the data after every trial
  save(['Data/' exp.name '_' exp.sid '_' exp.dateStr '_' exp.hostname '.mat'], ...
    'settings','resp','rt','train_resp','train_rt','train_correct','exp');
 
  % now clear 
  Screen('Flip',ws.ptr);
  WaitSecs(settings.isi);
  i = i + 1;
end

%% clean up
clear screen
ListenChar(0); % enable write to matlab
ShowCursor
fprintf('*** total duration: %d ***\n',GetSecs - start_time);