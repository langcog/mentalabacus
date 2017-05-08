%%%% This function was created in 1/10 by JS at UCSD for PING & related projs

%It reads image names from a folder, and then calls them up onto the  %
%screen. To test this program, please use -1 as the subject number.   %

% THIS PROGRAM IS PART OF AN ADAPTIVE TASK. That means that it really makes a difference
% whether the response is correct. Please be careful entering responses.
% All responses should be entered as either a '1' or a '2'. If you make a
% typo, this will count as an incorrect response, which will influence the kinds of trials
% that the kid will see next. '

% THIS PROGRAM CAN BE RUN SEPARATELY FROM THE ADAPTIVE TASK
% If you choose to do this, please use the format Adapt(subnum, level). The
% level is the level of difficulty, with level 1 being 1:5 and level 16
% being 13:14.

% THIS PROGRAM IS NOT TIMED. 

%If you move the directory where the program is, please be sure to change
%the save directory and the cd (below)


%If, for whatever reason, the program crashes, hit ctrl+c (and I do mean
%ctrl, not apple) repeatedly until you hear beeping. Then, type 'cls' and
%press enter. This will end the program.

%If a participant changes their mind about an answer, the delete key will
%allow you to change the input.

%If a participant refuses to answer or otherwise gives a non-data response,
%please enter a '0'. This way, I will know that the response was
%intentionally omitted. This will be counted as in incorrect response

%If you have any questions, please e-mail jsulliva@ucsd.edu

function showNumCompImages(levelname,wPtr,rect,exp)

start_time = GetSecs;
start_time1 = round(start_time);        

%% SETTINGS
settings.viewing_interval = .25; % in seconds, so .4 = 400ms
settings.isi = 1; % inter stimulus interval
settings.space_dim = [450 650];
settings.response_size = 70;
settings.before_trial_interval = .5;
settings.experiment_time_limit = 10; % this is in seconds

%% DETERMINES WHICH OF 4 POSSIBLE FOLDERS TO DRAW THE STIMULI FROM
if rand > .5
    levelz1=levelname;
else
    levelz1=levelname + 40;
end

if rand >.5
    levelz=levelz1;
else
    levelz=levelz1+ 20;
end

disp(levelz);
    
%% STARTS PROGRAM    
center = rect/2;
folder=dir (['levelz/' num2str(levelz) 'a/*mat']); %finds all bmp images in the specified directory
folder2=dir(['levelz/' num2str(levelz) 'b/*mat']); %finds all bmp images in the specified directory 
resp ='x'; 

for  i = 1:length(folder) %goes through all the images found in directory
  image_file_name = folder(i).name;  %finds the image file name
  image_file_name2 = folder2(i).name; %finds image file # 2?
  current_image_name = lower(image_file_name(1:end-7)); %removes extension (.bmp) to use as desired input
  current_image_name2 = lower(image_file_name2(1:end-7)); %removes extension (.bmp) to use as desired input
  img=imread(['jpgs/' current_image_name 'jpg']); %reads the image
  img2=imread(['jpgs/' current_image_name2 'jpg']); %reads the image
  
  % make sure images aren't bigger than screen
  size_proportion = center(3)/800;
  
  img = imresize(img,size_proportion);
  img2 = imresize(img2,size_proportion);
  [m n o] = size(img);
  mask = prepMask2(wPtr,rect);
  textureIndex=Screen('MakeTexture', wPtr, img); %prepares image to be presented in PTB
  textureIndex2=Screen('MakeTexture', wPtr, img2); %prepares 2nd image to be presented in PTB

  beep2
  beep2
  WaitSecs(.3);
  Screen('DrawTexture', wPtr, textureIndex, [], ...
    [center(3)-n center(4)-n/2 m center(4)+n/2], [],0); 
  Screen('DrawTexture', wPtr, textureIndex2, [], ...
    [center(3) center(4)-n/2 center(3)+m center(4)+n/2], [],0); 
  Screen('DrawLine',wPtr, [0 0 0], center(3), 0, center(3), rect(4),3);
  Screen(wPtr, 'Flip'); %put images on screen

  WaitSecs(1); %Waits some period of time          

  Screen('DrawTexture', wPtr, mask); %draw the mask
  Screen(wPtr, 'Flip'); %put mask on screen

  WaitSecs(.3);

  Screen('DrawText',wPtr, 'Which one has more dots?', center(3)-250, center(4), [0 0 0]);
  Screen(wPtr, 'Flip'); %put image on screen

  % GATHERS AND FORMATS RESPONSES        
  greenday=lower(current_image_name(end-1));
  actualcorrect{i} = str2num(greenday);

  [resp(i) rt(i)] = twoAFCresponse12;
  numbertrials{i}=i; % determines total number of responses provided
  rt1 = GetSecs - start_time;   
  whatpressed = resp;

  timeresponse{i}=rt1;
  imgnm{i} = image_file_name; %figures out name of first image
  imgnm2{i} = image_file_name2; %figures out name of second image

 
  % EVALUATES ACCURACY  
  answer(i) = resp(i);
  righty{i} = resp(i) == actualcorrect{i};
  
  if righty{i}
    showFeedbackImage('images/Happy.jpg',wPtr,.6);
  else   
    showFeedbackImage('images/Sad.jpg',wPtr,.6);
  end

  bestacc = sum(cell2mat(righty(1:1,1:i))); %%determines total # of correct responses for this experiment
  totcorr{i} = bestacc; % saves the total number of correct responses

  % calculates accuracy rate!
  if  bestacc>=1  %%just changed from best acc
  acc=(cell2mat(totcorr(1:1,i:i)))/cell2mat(numbertrials(1:1,i:i)); %removed (i)--with (i) worked though
  else acc=.01;
  end

  accuracy{i}=acc;  %saves accuracy rate
  responsename{i} = resp; %saves response
  save(['Data/IndividualLevels/'  exp.name '_' exp.sid '_' exp.dateStr '_' exp.hostname '_level' num2str(levelname) '.mat'], 'imgnm','actualcorrect','imgnm2','righty','responsename','totcorr','numbertrials','accuracy','timeresponse','answer');

  Screen('DrawText',wPtr, 'Press the space bar to continue.', center(3)-350, center(4), [0 0 0]);
  Screen(wPtr, 'Flip'); %put image on screen
  getResponseKeypad(' ');  
  Screen(wPtr, 'Flip'); %put image on screen
  Screen('Close',textureIndex);
  Screen('Close',textureIndex2);
end

savetexty(acc); %%this will allow the accuracy to get transferred to other programs.






