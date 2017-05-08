function spatialWM()
PsychJavaTrouble;

% PROGRAM OUTLINE
% =========================================================================
% STEP 1: Basic Setup (get subject ID, get keys for subject to press...etc)
% STEP 2: Setup and open a data file
% STEP 3: Setup coordinates for where to draw stimuli
% STEP 4: Setup variables for drawing items
% STEP 5: Counterbalance experiment conditions
% STEP 6: Run Trials
% STEP 7: Clean Up
% =========================================================================

useText=1;
getIm=0;

% STEP 1: BASIC SETUP
% =========================================================================

rand('twister',sum(100*clock));
clc;
commandwindow; 
disp(' '); 
disp('Task1-SpatialWM'); 
disp(' ');

% experiment information
exp.name                = 'spatialWM';

% get subject ID
exp.sid                 = input('enter subject ID: ', 's');

exp.dateStr             = datestr(now, 30);
exp.sessionNum          = 1; %input('enter session number:  ');

% get number of trials, block information
if (strcmp(exp.sid,'demo')==1)
    exp.numTrials           = [6 24];  % 12 practice trials, 40 trials ~ XX min
else
    exp.numTrials           = [10 24];  % 12 practice trials, 40 trials ~ XX min
end

exp.numBlocks           = length(exp.numTrials);
exp.blockBreaks         = [cumsum(exp.numTrials)+1];
exp.blockBreaks(end)    = [];
exp.feedbackType        = 2; % faces

% choose keyboard
% keyboard = adsf;

% get keys for responses
keys = [KbName('l') KbName('s') KbName('escape')];


% open the main screen
window                  = openMainScreen;
window

% MCF BLOCK
addpath('../helper');
if ~strcmp('exp.sid','demo') 
  Screen('Flip',window.onScreen);
  exp.subphoto = grabFrame(window.onScreen);
end
[~,exp.hostname]      = unix('hostname'); 
exp.hostname = strrep(exp.hostname,'.local',''); 
exp.hostname = exp.hostname(1:end-1);
fid = fopen(['../' exp.hostname '_subject_log.txt'],'a');
fprintf(fid,'%s,%s,%s,%s\n',exp.hostname,exp.name,exp.sid,datestr(now,31));
fclose(fid);


% STEP 1: BASIC SETUP
% =========================================================================

if strcmp(exp.sid,'demo')
    dotDur=1.800;
else
    dotDur=0.900;
end

% STEP 2: SETUP DATA STRUCTURE, OPEN DATA FILE
% =========================================================================

% setup D struct, to store data...
D.exp   = {}; % experiment name
D.sid   = {}; % subject ID
D.session = [];
D.blockNum = [];
D.blockType = {};
D.trialNum = []; % trial number
D.oddEven = [];
D.date = {};
D.time = {};

% for some data analysis, you want your conditions to be labeled with
% numbers (e.g., for use in SPSS).

% but I can never rememer what the numbers mean, so I record both a number
% and a name for some variables...

D.testItem=[];
D.samplePos=[];
D.testPos=[];

D.setSize = []; % 1 to 16
D.yesNo = [];
D.testItem = [];

D.respKey = [];
D.respName = [];
D.respRT = [];
D.respCorrect = [];
D.respError = [];

       
D.correctStreak = [];
D.errorStreak = [];

% for i=1:16
%     eval(['D.correctOrder' num2str(i) ' = [];']);
% end
% 
% for i=1:16
%     eval(['D.clickedOrder' num2str(i) ' = [];']);
% end
% 
% for i=1:16
%     eval(['D.clickedRT' num2str(i) ' = [];']);
% end
    
exp.fid             = fopen(fullfile('DataFiles','TextFiles',[exp.name '_' exp.sid '_' exp.dateStr '.xls']), 'a');


writeHeaderToFile(D, exp.fid);

% STEP : SETUP BEEPS
%=========================================================================


% FIRST DEFINE YOUR SOUND
freq        = 800;  % sound frequency
amp         = .3;   % sound amplitude
duration    = .070; % sound duration
Fs          = 44100; % sampling rate

% THEN CREATE YOUR SOUND
timepersamp = 1/Fs;
x=[0:timepersamp:duration];
wave = amp .* sin((2*pi*freq) .*x);
beepSound1 = audioplayer([wave wave], Fs);


% FIRST DEFINE YOUR SOUND
freq        = 400;  % sound frequency
amp         = .15;   % sound amplitude
duration    = .070; % sound duration
Fs          = 44100; % sampling rate

% THEN CREATE YOUR SOUND
timepersamp = 1/Fs;
x=[0:timepersamp:duration];
wave = amp .* sin((2*pi*freq) .*x);
beepSound2 = audioplayer([wave wave], Fs);

% STEP : LOAD IN FEEDBACK STIMULI
% =========================================================================

% smiley/frowny feedback
lumval=200;

im=(imread(fullfile('ImageFiles-Feedback','Happy.jpg')));
im=imresize(im,[100 100]);
R=im(:,:,1);
G=im(:,:,2);
B=im(:,:,3);
useThese=find(R>lumval & G>lumval & B>lumval);
alpha=ones(size(R))*255;
alpha(useThese)=0;
im(:,:,4)=alpha;
posFeedback=Screen('MakeTexture',window.onScreen,im);

im=(imread(fullfile('ImageFiles-Feedback','Sad.jpg')));
im=imresize(im,[100 100]);
R=im(:,:,1);
G=im(:,:,2);
B=im(:,:,3);
useThese=find(R>lumval & G>lumval & B>lumval);
alpha=ones(size(R))*255;
alpha(useThese)=0;
im(:,:,4)=alpha;
negFeedback=Screen('MakeTexture',window.onScreen,im);


% STEP : LOAD IN TEXT MESSAGES
% =========================================================================

if (useText==0)
    
    im=(imread(fullfile('ImageFiles','blockBreak.jpg')));
    blockBreak=Screen('MakeTexture',window.onScreen,im);
    
    im=(imread(fullfile('ImageFiles','dotMessage1.jpg')));
    dotMessage1=Screen('MakeTexture',window.onScreen,im);
    
    im=(imread(fullfile('ImageFiles','dotMessage2.jpg')));
    dotMessage2=Screen('MakeTexture',window.onScreen,im);
    
    im=(imread(fullfile('ImageFiles','nextTrial.jpg')));
    nextTrial=Screen('MakeTexture',window.onScreen,im);
    
    im=(imread(fullfile('ImageFiles','practiceMessage.jpg')));
    practiceMessage=Screen('MakeTexture',window.onScreen,im);
    
    im=(imread(fullfile('ImageFiles','quitMessage.jpg')));
    quitMessage=Screen('MakeTexture',window.onScreen,im);
    
    im=(imread(fullfile('ImageFiles','finishedMessage.jpg')));
    finishedMessage=Screen('MakeTexture',window.onScreen,im);
 
end

% STEP : LOAD IN ATTENTION GRABBING MOVIE
% =========================================================================

[Y,FS,NBITS]=wavread(fullfile('SoundFiles','dotsound.wav'));
dotSound=audioplayer(Y*.45,FS); 
 
% STEP 3: SETUP THE DISPLAY COORDINATES	
%=========================================================================



% setup grid of display coordinates
nX = 5; % number of columns
nY = 5; % number of rows
nT = nX*nY; % total number of cells

% grid height and width
gW = 125*nX;
gH = 125*nY;
dR = 1.1*sqrt(125^2+125^2);

% get x coordinates
xPos = linspace(window.centerX-250,window.centerX+250,nX+1);
xPos = xPos + (xPos(2)-xPos(1))/2;
xPos(end) = [];

% get y coordinates
yPos = linspace(window.centerY-250,window.centerY+250,nY+1);
yPos = yPos + (yPos(2)-yPos(1))/2;
yPos(end) = [];

% coordinates for each position...
coords.numPos = nT;
count=0;
for i=1:nY
    for j=1:nX
        count=count+1;
        coords.x(count) = xPos(j);
        coords.y(count) = yPos(i);
    end
end

% STEP 4: SETUP VARIABLES FOR DRAWING ITEMS
%=========================================================================
    
COLORS(1,:) = [255 0 0]; % red
COLORS(2,:) = [0 255 0]; % green
COLORS(3,:) = [0 0 255]; % blue
COLORS(4,:) = [0 255 255]; % cyan 
COLORS(5,:) = [255 0 255]; % magenta
COLORS(6,:) = [255 255 0]; % yellow
COLORS(7,:) = [250 118 20]; % orange
COLORS(8,:) = [187 124 254]; % lavender
COLORS(9,:) = [253 194 192]; % pink
COLORS(10,:) = [0 0 0]; % black
COLORS(11,:) = [255 255 255]; % white

numColors = length(COLORS);
    
% STEP 5: COUNTERBALANCE EXPERIMENT CONDITIONS
% =========================================================================

% choose order for setsizes during practice
practSS=ceil((1:exp.numTrials(1)+.5)/2)+1;
for i=1:2:exp.numTrials(1)
    practCh(i:i+1)=randperm(2);
end

% actually will choose these dynamically, because the difficulty will be
% staircased...

SetSizes    = [1:16]; 
Changes     = {'NoChange','Change'};
ff          = fullfact([length(SetSizes) 2]);

RandOrder = [];
for i=1:exp.numBlocks
    RandOrder   = [RandOrder mod(randperm(exp.numTrials(i)),length(ff))+1];
end

if (strcmp(exp.sid,'demo')==1)
    pSetSize=[1 1 2 2 3 3];
    pChange=[Shuffle([0 1]) Shuffle([0 1]) Shuffle([0 1])];
else
    pSetSize=[1 1 2 2 2 2 2 2 3 3];
    pChange=[Shuffle([0 1]) Shuffle([0 1]) Shuffle([0 0 1 1]) Shuffle([0 1])];
end

% STEP 6: SETUP K STRUCT FOR COMPUTING CAPACITY
% =========================================================================

K.numTrials(1:length(SetSizes)) = 0;
K.numChange(1:length(SetSizes)) = 0;
K.numHIT(1:length(SetSizes))    = 0;
K.hitRate(1:length(SetSizes))   = 0;

K.numSame(1:length(SetSizes))   = 0;
K.numFA(1:length(SetSizes))     = 0;
K.faRate(1:length(SetSizes))    = 0;

K.estimate(1:length(SetSizes))  = 0;
K.drop = 0;

% RUN THE TRIALS
% =========================================================================

if (useText==1)
    drawCenterText('Press the space bar to begin practice.', window, window.centerX, window.centerY, [0 0 0]);
else
    Screen('DrawTexture', window.onScreen, practiceMessage);
end

if (getIm==1)
    A=double(Screen('GetImage', window.onScreen,[],'backBuffer'))/255;
    imwrite(A,fullfile('ImageFiles','practiceMessage.jpg'),'jpg');
end

Screen('Flip', window.onScreen);


[jnk1 jnk2] = getKeypressResponse(KbName('space'), GetSecs);
currBlock=1;
allCorrectStreak=0;
errorStreak=0;
currSetSize=2;

i=0;
while i<sum(exp.numTrials)

    while KbCheck() end;
    
    i=i+1;
    
    SetMouse(window.screenX,window.screenY,window.onScreen);
    %HideCursor;
    
    % check for a block break
    % ---------------------------------------------------------------------
    if any(i==exp.blockBreaks)
        
        if (useText==1)
            textStr=['To repeat practice, press ''P'''];
            drawCenterText(textStr, window, window.centerX, window.centerY-32, [0 0 0]);
            
            textStr=['Or press the space bar to begin the test.'];
            drawCenterText(textStr, window, window.centerX, window.centerY+32, [0 0 0]);
        else
            Screen('DrawTexture', window.onScreen, blockBreak);
        end
        
        if (getIm==1)
            A=double(Screen('GetImage', window.onScreen,[],'backBuffer'))/255;
            imwrite(A,fullfile('ImageFiles','blockBreak.jpg'),'jpg');
        end
        
        Screen('Flip', window.onScreen);
        
        waitForKey;
        while KbCheck(); end;
        
        [blockKey blockRT] = getKeypressResponse([KbName('P') KbName('space')], GetSecs);
        
        % clear screen, wait for random time between 500 and 1000 ms
        Screen('FillRect', window.onScreen, window.bcolor);
        Screen('Flip', window.onScreen);
        ITI = 1.000;
        t=GetSecs; while (GetSecs()-t < ITI); end
        
        if (blockKey==1)
            currBlock=1;
            i=1;
            
            if (strcmp(exp.sid,'demo')==1)
                pSetSize=[1 1 2 2 3 3];
                pChange=[Shuffle([0 1]) Shuffle([0 1]) Shuffle([0 1])];
            else
                pSetSize=[1 1 2 2 2 2 2 2 3 3];
                pChange=[Shuffle([0 1]) Shuffle([0 1]) Shuffle([0 0 1 1]) Shuffle([0 1])];
            end

        else
            currBlock=currBlock+1;
        end
        
    end
        
    % store basic trial info in D struct (data struct)
    % ---------------------------------------------------------------------
    D.exp{i}   = exp.name; % experiment name
    D.sid{i}   = exp.sid; % subject ID
    D.session(i) = exp.sessionNum; % session number
    D.blockNum(i) = currBlock;
    
    if (currBlock==1)
        D.blockType{i} = 'Practice';
    else
        D.blockType{i} = 'Test';
    end
    
    D.trialNum(i) = i; % trial number
    D.oddEven(i) = mod(i,2);
    
    D.date{i}             = date; % date
    time=clock;
    if (time(5)<10)
        D.time{i}             = [num2str(time(4)) ':0' num2str(time(5))]; % time
    else
        D.time{i}             = [num2str(time(4)) ':' num2str(time(5))]; % time
    end


    % set trial variables
    % ---------------------------------------------------------------------

    if (currBlock==1 & i<=length(pChange))
        D.yesNo(i) = pChange(i);
        D.setSize(i) = pSetSize(i);
    else
        D.yesNo(i) = RandSample(0:1);
        D.setSize(i) = currSetSize;
    end
        
    % get item locations for this trial
    % ---------------------------------------------------------------------

    % randomly shuffle display positions
    I(i).currPos=Randperm(coords.numPos);
    
    I(i).targPos = zeros([1 nT]);
    I(i).targPos(I(i).currPos(1:D.setSize(i))) = 1;
    
    correctOrder = [];
    correctOrder = I(i).currPos(1:D.setSize(i));
    
    % get corresponding x,y coordinates
    for j=1:D.setSize(i)
        
        % get this position from your rand position list
        thisPos = I(i).currPos(j);
        
        % get corresponding x,y coordinate
        % add some jitter so the items aren't in a fixed grid
        jitter = 0;
        I(i).currPos(j) = thisPos;
        I(i).currX(j) = coords.x(thisPos) + RandSample([-jitter:jitter],[1 1]);
        I(i).currY(j) = coords.y(thisPos) + RandSample([-jitter:jitter],[1 1]);
        
    end
    
    % get corresponding x,y coordinates for test
    for j=1:D.setSize(i)
        
        % get this position from your rand position list
        thisPos = I(i).currPos(j);
        
        % get corresponding x,y coordinate
        % add some jitter so the items aren't in a fixed grid
        jitter = 0;
        I(i).currPos(j) = thisPos;
        I(i).testX(j) = coords.x(thisPos) + RandSample([-jitter:jitter],[1 1]);
        I(i).testY(j) = coords.y(thisPos) + RandSample([-jitter:jitter],[1 1]);
        
    end
    
    if (D.yesNo(i)==0)
        
        % list of possible items to change
        sampleItems = I(i).currPos(1:D.setSize(i));
        possibleChangeItems = Shuffle(sampleItems);
        
        success=0;
        for currItem=possibleChangeItems
            
            % xy of this item
            tx=coords.x(currItem);
            ty=coords.y(currItem);
        
            % distance to all other items
            delta=[];
            pos=[];
            for item=1:nT
                if (item ~= currItem)
                    delta(end+1)=sqrt( (coords.x(item)-tx)^2 + (coords.y(item)-ty)^2);
                    pos(end+1)=item;
                end
            end
            
            closeEnough=pos(find(delta<dR));
            validTestItems=closeEnough(~ismember(closeEnough,sampleItems))
            
            if (~isempty(validTestItems))
                
                D.samplePos(i)=currItem;
                D.testItem(i)=find(sampleItems==currItem);
                thisPos = RandSample(validTestItems);
                I(i).testX(D.testItem(i)) = coords.x(thisPos) + RandSample([-jitter:jitter],[1 1]);
                I(i).testY(D.testItem(i)) = coords.y(thisPos) + RandSample([-jitter:jitter],[1 1]);
                D.testPos(i)=thisPos;
                success=1;
                break;
            end
            
        end
        
        if (success==0)
            
            % choose random item to change
            D.testItem(i)=RandSample(1:D.setSize(i));
            D.samplePos(i)=I(i).currPos(D.testItem(i));
            thisPos = I(i).currPos(D.setSize(i)+1);
            I(i).testX(D.testItem(i)) = coords.x(thisPos) + RandSample([-jitter:jitter],[1 1]);
            I(i).testY(D.testItem(i)) = coords.y(thisPos) + RandSample([-jitter:jitter],[1 1]);
            D.testPos(i)=thisPos;
        end
        
    else
        
        D.samplePos(i)=0;
        D.testItem(i)=0;
        D.testPos(i)=0;
        
    end

    dotSize=56;
    
    % wait for keypress
    % ---------------------------------------------------------------------    

    if (useText==1)
        drawCenterText('Press space bar to begin next trial.', window, window.centerX, window.centerY, [0 0 0]);
    else
        Screen('DrawTexture', window.onScreen, nextTrial);
    end

    if (getIm==1)
        A=double(Screen('GetImage', window.onScreen,[],'backBuffer'))/255;
        imwrite(A,fullfile('ImageFiles','nextTrial.jpg'),'jpg');
    end
    
    drawCenterText([num2str(D.setSize(i))], window, window.screenX-64, window.screenY-64, [0 0 0]);
    
    Screen('Flip', window.onScreen);
    [jnk1 jnk2] = getKeypressResponse(KbName('space'), GetSecs);

    % wait 1 second
    % ---------------------------------------------------------------------    

    % clear screen, wait for random time between 500 and 1000 ms
    Screen('FillRect', window.onScreen, window.bcolor);
    Screen('Flip', window.onScreen);
    ITI = 1.000;
    t=GetSecs; while (GetSecs()-t < ITI); end
    
    % present sample display, 900ms per item, 500 ms blank
    % ---------------------------------------------------------------------
    
    Screen('FillRect', window.onScreen, window.bcolor);
    Screen('DrawDots', window.onScreen, [coords.x; coords.y], dotSize+2, [0 0 0], [], 2);
    Screen('DrawDots', window.onScreen, [coords.x; coords.y], dotSize, window.bcolor, [], 2);
    Screen('Flip', window.onScreen);
    t=GetSecs; while (GetSecs()-t < 1.00); end
        
    playblocking(beepSound2); 
    playblocking(beepSound2);
    
    for currItem=1:D.setSize(i)
        
        % blank screen for 500 ms
        Screen('FillRect', window.onScreen, window.bcolor);
        Screen('DrawDots', window.onScreen, [coords.x; coords.y], dotSize+2, [0 0 0], [], 2);
        Screen('DrawDots', window.onScreen, [coords.x; coords.y], dotSize, window.bcolor, [], 2);
        Screen('Flip', window.onScreen);
        t=GetSecs; while (GetSecs()-t < .500); end
        
        % item for 900ms
        play(dotSound);
        Screen('FillRect', window.onScreen, window.bcolor);
        Screen('DrawDots', window.onScreen, [coords.x; coords.y], dotSize+2, [0 0 0], [], 2);
        Screen('DrawDots', window.onScreen, [coords.x; coords.y], dotSize, window.bcolor, [], 2);
        Screen('DrawDots', window.onScreen, [I(i).currX(currItem); I(i).currY(currItem)], dotSize, [220 220 0], [], 2);
        Screen('Flip', window.onScreen);
        t=GetSecs; 
        while (GetSecs()-t < dotDur);
            [keyIsDown,secs,keyCode] = KbCheckM();
            if (keyCode(KbName('escape')))
                break;
            end
        end
 
        if (keyCode(KbName('escape')))
            break;
        end
        
    end

    if (keyCode(KbName('escape')))
        break;
    end

    % blank screen for 500 ms
    Screen('FillRect', window.onScreen, window.bcolor);
    Screen('DrawDots', window.onScreen, [coords.x; coords.y], dotSize+2, [0 0 0], [], 2);
    Screen('DrawDots', window.onScreen, [coords.x; coords.y], dotSize, window.bcolor, [], 2);
    Screen('Flip', window.onScreen);
    
    if (strcmp(exp.sid,'demo'))
        waitForKey;
    end
    
    t=GetSecs; while (GetSecs()-t < 1.00); end
    
    playblocking(beepSound2); 
    playblocking(beepSound2); 
    
    % test display
    % ---------------------------------------------------------------------
    for currItem=1:D.setSize(i)

        % blank screen for 500 ms
        Screen('FillRect', window.onScreen, window.bcolor);
        Screen('DrawDots', window.onScreen, [coords.x; coords.y], dotSize+2, [0 0 0], [], 2);
        Screen('DrawDots', window.onScreen, [coords.x; coords.y], dotSize, window.bcolor, [], 2);
        Screen('Flip', window.onScreen);
        t=GetSecs; while (GetSecs()-t < .500); end
        
        % item for 900ms
        play(dotSound);
        Screen('FillRect', window.onScreen, window.bcolor);
        Screen('DrawDots', window.onScreen, [coords.x; coords.y], dotSize+2, [0 0 0], [], 2);
        Screen('DrawDots', window.onScreen, [coords.x; coords.y], dotSize, window.bcolor, [], 2);
        Screen('DrawDots', window.onScreen, [I(i).testX(currItem); I(i).testY(currItem)], dotSize, [0 0 240], [], 2);
        Screen('Flip', window.onScreen);
        t=GetSecs; 
        while (GetSecs()-t < dotDur);
            [keyIsDown,secs,keyCode] = KbCheckM();
            if (keyCode(KbName('escape')))
                break;
            end
        end
 
        if (keyCode(KbName('escape')))
            break;
        end
        
    end
    
    if (keyCode(KbName('escape')))
        break;
    end
    
    % blank screen for 500 ms
    Screen('FillRect', window.onScreen, window.bcolor);
    Screen('DrawDots', window.onScreen, [coords.x; coords.y], dotSize+2, [0 0 0], [], 2);
    Screen('DrawDots', window.onScreen, [coords.x; coords.y], dotSize, window.bcolor, [], 2);
    Screen('Flip', window.onScreen);
    t=GetSecs; while (GetSecs()-t < .250); end
    
    % get response
    % ---------------------------------------------------------------------
    
    % show a little fixation cross for 250 ms
    Screen('FillRect', window.onScreen, window.bcolor);
    
    if (D.setSize(i)==1)
        
        if (useText==1)
            drawCenterText(['Was the blue dot in the same place as the yellow dot?'], window, window.centerX, window.centerY-32, [0 0 0]);
        else
            Screen('DrawTexture', window.onScreen, dotMessage1);
        end
        
        if (getIm==1)
            A=double(Screen('GetImage', window.onScreen,[],'backBuffer'))/255;
            imwrite(A,fullfile('ImageFiles','dotMessage1.jpg'),'jpg');
        end
        
    else
        if (useText==1)
            drawCenterText(['Were the blue dots in the same places as the yellow dots?'], window, window.centerX, window.centerY-32, [0 0 0]);
        else
            Screen('DrawTexture', window.onScreen, dotMessage2);
        end
        
        if (getIm==1)
            A=double(Screen('GetImage', window.onScreen,[],'backBuffer'))/255;
            imwrite(A,fullfile('ImageFiles','dotMessage2.jpg'),'jpg');
        end
        
    end
    
    Screen('Flip', window.onScreen);
    
    [pressedKey RT] = getKeypressResponse(keys, GetSecs);
    pressedKey=pressedKey(1);
    
    if (pressedKey==length(keys))
        break;
    end

    % check accuracy
    % ---------------------------------------------------------------------

    ResponseKeys={'Same','Different'};
    
    D.respKey(i)    = pressedKey; % key pressed by subject  
    D.respName{i}   = ResponseKeys{pressedKey}; % color reported by subject
    D.respRT(i)     = RT*1000; % reaction time of response in ms
    
    if ((pressedKey-1) == D.yesNo(i)) % whether response was correct or incorrect
        D.respCorrect(i) = 1; 
        D.respError(i) = 0; 
        textStr = 'Correct';
        feedBackColor = [0 255 0];
    else
        D.respCorrect(i) = 0; 
        D.respError(i) = 1; 
        textStr = 'Incorrect';
        feedBackColor = [0 0 0];
    end
    
    % give feedback
    % ---------------------------------------------------------------------     
    if (exp.feedbackType == 1)
        Screen('FillRect',window.onScreen, window.bcolor);
        drawCenterText(textStr, window, window.centerX, window.centerY, feedBackColor);
        Screen('Flip', window.onScreen);
        t=GetSecs; while (GetSecs()-t < 1); end
    else
        if (D.respCorrect(i)==1)
            Screen('DrawTexture', window.onScreen, posFeedback);
            Screen('Flip', window.onScreen);
            t=GetSecs; while (GetSecs()-t < .6); end
        else
            Screen('DrawTexture', window.onScreen, negFeedback);
            Screen('Flip', window.onScreen);
            t=GetSecs; while (GetSecs()-t < .6); end
        end
    end
    
    Screen('FillRect',window.onScreen, window.bcolor);
    Screen('Flip', window.onScreen);
        
    % compute capacity estimate
    % ---------------------------------------------------------------------
    D.correctStreak(i) = allCorrectStreak;
    D.errorStreak(i) = errorStreak;
    
    % record data for this trial
    % ---------------------------------------------------------------------    
    writeTrialToFile(D, i, exp.fid)

    % record workspace for this trial
    workspaceFile=fullfile('DataFiles','WorkspaceFiles',[exp.name '_workspace_' exp.sid '_' exp.dateStr '.mat']);
    save(workspaceFile);
    
    % updateStaircase
    % ---------------------------------------------------------------------
    if (currBlock > 1)
        
        % update streak counts
        % only increase streak count if there was a HIT
        % decrease streak count for any error
        
%         if (D.respCorrect(i)==1)
%             allCorrectStreak=allCorrectStreak+1;
%             errorStreak=0;
%         else
%             allCorrectStreak=0;
%             errorStreak=errorStreak+1;
%         end
%         
%         if (allCorrectStreak==2)
%             currSetSize=min(nT,currSetSize+1);
%             allCorrectStreak=0;
%         end
%         
%         if (errorStreak==2)
%             currSetSize=max(1,currSetSize-1);
%             errorStreak=0;
%         end

        if (D.respCorrect(i)==1)
            allCorrectStreak=allCorrectStreak+1;
            errorStreak=0;
        elseif (D.respCorrect(i)==0)
            allCorrectStreak=0;
            errorStreak=errorStreak+1;
        end
        
        if (allCorrectStreak==2)
            currSetSize=min(nT,currSetSize+1);
            allCorrectStreak=0;
        end
        
        if (errorStreak==1)
            currSetSize=max(1,currSetSize-1);
            errorStreak=0;
        end
        
    end
    
    
end

% STEP 7: CLEAN UP
% =========================================================================

% message to user...
if (keyCode(KbName('escape')) | pressedKey==length(keys))
    clc;
    disp('User quit...');
    
    if (useText==1)
        drawCenterText('User quit...', window, window.centerX, window.centerY, [0 0 0]);
    else
        Screen('DrawTexture', window.onScreen, quitMessage);
    end
    
    if (getIm==1)
        A=double(Screen('GetImage', window.onScreen,[],'backBuffer'))/255;
        imwrite(A,fullfile('ImageFiles','quitMessage.jpg'),'jpg');
    end
    
    Screen('Flip', window.onScreen);
    pause(1);
else
    
    if (useText==1)
        drawCenterText('End of session! Thank you.', window, window.centerX, window.centerY, [0 0 0]);
    else
        Screen('DrawTexture', window.onScreen, finishedMessage);
    end
    
    if (getIm==1)
        A=double(Screen('GetImage', window.onScreen,[],'backBuffer'))/255;
        imwrite(A,fullfile('ImageFiles','finishedMessage.jpg'),'jpg');t
    end
    
    Screen('Flip', window.onScreen);
    pause(1);
end

% try
%     % calculate a capacity estimate
%     K.faRate(1:length(SetSizes))    = K.numFA./K.numSame;
%     K.hitRate(1:length(SetSizes))   = K.numHIT./K.numChange;
%     K.estimate(1:length(SetSizes))  = (K.hitRate-K.faRate).*SetSizes;
%     K.drop = K.estimate(1)-K.estimate(end);
%     
%     % save capacity estimate in data file
%     fprintf(exp.fid, '\n\n=====================================\n');
%     fprintf(exp.fid, '%s\t%s\t%s\t%s\t\n','SetSize','HitRate','FARate','K');
%     for i=1:length(SetSizes)
%         if (K.numTrials(i)>6)
%             fprintf(exp.fid, '%d\t%f\t%f\t%f\t\n',SetSizes(i),K.hitRate(i),K.faRate(i),K.estimate(i));
%         end
%     end
% catch
%     disp('oops, could not compute capacity');
% end

%K.attnDrop=K.estimate(1)-K.estimate(end);
%fprintf(exp.fid, 'K drop:\t%f', K.attnDrop);
%fprintf(exp.fid, '\n=====================================\n');

% save MAT file with all data
fileName=fullfile('DataFiles','MatFiles',[exp.name '_' exp.sid '_' exp.dateStr '_' exp.hostname '.mat']); % MCF
save(fileName,'D','K','I','exp','window','coords');

% close all files, clear screen, quit out
fclose('all');
sca;
clear all;

% =========================================================================
%                               SUBFUNCTIONS
% =========================================================================


% =========================================================================
function sid = getSubjectID(exp)

sid = input('enter subject ID:  ', 's');     % get sid fropm user
allsids = dir(fullfile(pwd,'*.xls')); % get all existing sids
[sidnames{1:length(allsids)}]=deal(allsids.name); % deal file names into array "sidnames"

% loop until you get a unique sid from the user
while (any(strcmp(sidnames,[exp.name '_' sid '.xls'])))
    disp('Sorry, that ID already exist, please enter a new subject ID.');
    sid = input('enter subject ID:  ', 's');
end;
% =========================================================================


% =========================================================================
function window = openMainScreen

% display requirements (resolution and refresh rate)
window.requiredRes  = [];
window.requiredRefreshrate = [];

%basic drawing and screen variables
window.gray        = 127;
window.black       = 0;
window.white       = 255;
window.fontsize    = 32;
window.bcolor      = window.gray;

%open main screen, get basic information about the main screen
screens=Screen('Screens'); % how many screens attached to this computer?
window.screenNumber=max(screens); % use highest value (usually the external monitor)
window.onScreen=Screen('OpenWindow',window.screenNumber, 0, [], 32, 2); % open main screen
[window.screenX, window.screenY]=Screen('WindowSize', window.onScreen); % check resolution
window.screenDiag = sqrt(window.screenX^2 + window.screenY^2); % diagonal size
window.screenRect  =[0 0 window.screenX window.screenY]; % screen rect
window.centerX = window.screenRect(3)*.5; % center of screen in X direction
window.centerY = window.screenRect(4)*.5; % center of screen in Y direction

% set some screen preferences
[sourceFactorOld, destinationFactorOld]=Screen('BlendFunction', window.onScreen, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
Screen('Preference','SkipSyncTests', 1);
Screen('Preference','VisualDebugLevel', 0);

% get screen rate
[window.frameTime nrValidSamples stddev] =Screen('GetFlipInterval', window.onScreen);
window.monitorRefreshRate=1/window.frameTime;

% paint mainscreen bcolor, show it
Screen('FillRect', window.onScreen, window.bcolor);
Screen('Flip', window.onScreen);
Screen('FillRect', window.onScreen, window.bcolor);
Screen('TextSize', window.onScreen, window.fontsize);

% =========================================================================


% =========================================================================
function keys = getKeys(window)

keys = [KbName('s') KbName('l') KbName('q')];

% =========================================================================


% =========================================================================
function drawCenterText(textStr, window, x, y, color);

[normBoundsRect, offsetBoundsRect]=Screen('TextBounds', window.onScreen, textStr);
newRect = CenterRectOnPoint(normBoundsRect,x,y);
Screen('DrawText', window.onScreen, textStr, newRect(1), newRect(2), color);
% =========================================================================


% =========================================================================
function writeHeaderToFile(D, fid)

h = fieldnames(D);

for i=1:length(h)
    fprintf(fid, '%s\t', h{i});
end
fprintf(fid, '\n');
% =========================================================================


% =========================================================================
function writeTrialToFile(D, trial, fid)

h = fieldnames(D);
for i=1:length(h)
    data = D.(h{i})(trial);
    if isnumeric(data)   
        fprintf(fid, '%s\t', num2str(data));
    elseif iscell(data)
        fprintf(fid, '%s\t', char(data));
    else
        error('wrong format!')
    end
end     
fprintf(fid, '\n');
% =========================================================================


% =========================================================================
function [pressedKey RT] = getKeypressResponse(keys, tstart)
% assumes that key struct, with all ok key values in the field
% allKeys, also assumes 'q' quits

pressedKey=0;
while (1)
    
    [keyIsDown,secs,keyCode]=KbCheckM();
        
    if any(keyCode(keys))
        pressedKey = find(keyCode(keys));
        RT = GetSecs - tstart;
        break;
    end
    
end


% =========================================================================
function D = prepareTrial(i,exp,D)

D.exp{i} = exp.name; % experiment name
D.sid{i} = exp.sid; % subject name
D.trial(i) = i; % trial number

if (exp.key.order==1) % red, green
    names = {'Green', 'Red'};
else
    names = {'Red', 'Green'};
end

D.colorNum(i) = RandSample([1 2],[1 1]); % color of target on this trial
D.colorName{i} = names{D.colorNum(i)}; % color of target on this trial

names = {'Left', 'Right'};
D.locationNum(i) = RandSample([1 2],[1 1]); % location of the target on this trial
D.locationName{i} = names{D.locationNum(i)};; % location of the target on this trial

names = {'Consistent', 'Inconsistent'};
if (D.colorNum(i) == D.locationNum(i)) 
    D.conditionNum(i) = 1;
else
    D.conditionNum(i) = 2;
end

D.conditionName{i} = names{D.conditionNum(i)}; % congruent, incongruent color/location


if (i==1)
    D.colorStreak(i) = 0; % number of trials in a row with the same target color
    D.locationStreak(i) = 0; % number of trials in a row with the same target location
    D.comboStreak(i) = 0; % number of trials in a row with same color/location
else
    if (D.colorNum(i) == D.colorNum(i-1))
        D.colorStreak(i) = D.colorStreak(i-1)+1;
    else
        D.colorStreak(i) = 0;
    end
    
    if (D.locationNum(i) == D.locationNum(i-1))
        D.locationStreak(i) = D.locationStreak(i-1)+1;
    else
        D.locationStreak(i) = 0;
    end
    
    if (D.colorNum(i) == D.colorNum(i-1) & D.locationNum(i) == D.locationNum(i-1))
        D.comboStreak(i) = D.comboStreak(i-1)+1;
    else
        D.comboStreak(i) = 0;
    end
end

% =========================================================================


% =========================================================================
function waitForKey;

%---------------------------------------------
% wait for key to start initiate trial
%---------------------------------------------
% make sure no key is currently pressed
[keyIsDown,secs,keyCode]=KbCheckM();
while(keyIsDown)
    [keyIsDown,secs,keyCode]=KbCheckM();
end
% get keyquit
while(1)
    [keyIsDown,secs,keyCode]=KbCheckM();
    if keyIsDown
        break;
    end
end


% =========================================================================
% =========================================================================

function p=genDisplay(Range, Ratio, Control, WhichMore)

% Range: range of allowable numbers of dots
% Ratio: relative number of large/small dots
% Control: either control the area or the size of the dots

% demo: p=genDisplay(5:16, 1/2, 1, 1)

% CHOOSE NUMBER OF DOTS
% =========================================================================

validNumber = 0;

while (~validNumber)

    num1 = RandSample(Range);
    num2 = round(num1*Ratio);

    if (num2<5)
        num2 = round(num1/Ratio);
    end

    if (num2 >= 5 & num2 <= 16)
        validNumber = 1;
    end
    
end

num1, num2

if (num1>num2)
    p.whichMore = 1;
else
    p.whichMore = 2;
end
    
% CHOOSE DOT SIZES
% =========================================================================

if (Control==1) % 'dot size controlled'

    M = RandSample([20:80]);
    SD = M * .35/2;
    p.set1 = getRandomSizes(num1,M,SD,[-inf inf],5);
    p.set2 = getRandomSizes(num2,M,SD,[-inf inf],5);
    
else            % 'area controlled' 

    M1          = RandSample([20:80])
    SD1         = M1 * .35/2;
    ExpectedA1  = pi*(M1/2)^2*num1

    
    M2 = sqrt(ExpectedA1/pi/num2)*2
    SD2 = M2 * .35/2;
    ExpectedA2  = pi*(M2/2)^2*num2
    
    p.areaDiff = inf;
    while (abs(p.areaDiff)>1)
        p.set1 = getRandomSizes(num1,M1,SD1,[-inf inf],5);
        p.set2 = getRandomSizes(num2,M2,SD2,[-inf inf],5);
        p.areaDiff = (p.set1.totalArea-p.set2.totalArea)/((p.set1.totalArea+p.set2.totalArea)/2)*100
    end
end

if (WhichMore == 1) % blue has more
    
    if (num1>num2)
        
        p.blueSet   = p.set1; % blue has more
        p.yellowSet = p.set2;
        
    else
        
        p.blueSet   = p.set2; % blue has more
        p.yellowSet = p.set1;
        
    end
    
    
else % yellow has more
    
    if (num1>num2)
        
        p.blueSet   = p.set2;
        p.yellowSet = p.set1; % yellow has more
        
    else
        
        p.blueSet   = p.set1;
        p.yellowSet = p.set2; % yellow has more
        
    end
    
end

    
    
% more blue or more yellow?
% press space bar
% 250 ms blank
% 200 ms dots
% Number of dots per set varied from 5 to 16
% 50/50 blue/yellow larger
% 4 ratio bins 1:2, 3:4, 5:6 or 7:8

% dot size control
% size of the average blue dot equal to the size of the average yellow

% area controlled
% total area of the two sets matched

% individual dot size
% varied randomly by up to 35% of the set average



function p = getRandomSizes(nItems,M,SD,range,minR) 
  
% randomly generate item sizes until there is at least one item within the
% specified range, and the mean and std are about right (within .1 desired)

r=0;
while ( (abs(mean(r)-M) >M*.025) | (abs(std(r)-SD) >.1) | min(r) < minR)
    r = round(M + SD.*randn(nItems,1));
    if (isempty(find(r>=range(1) & r<=range(2))))
        r=0;
    end
    [M*.1 mean(r)];
end

% store the mean, SD, size, target number, and target size
p.M    = mean(r);
p.SD   = std(r);
p.Diam = r;
p.totalArea = sum(pi*(p.Diam/2).^2);

%-------------------------------------------------------------------------
function [keyIsDown,secs,keyCode] = KbCheckM(deviceNumber)
% [keyIsDown,secs,keyCode] = KbCheckM(deviceNumber)
% check all attached keyboards for keys that are down
%
% Tim Brady and Oliver Hinds 
% 2007-07-18

  if(~IsOSX)
      if exist('deviceNumber', 'var')
        [keyIsDown, secs, keyCode] = KbCheck(deviceNumber);
      else
        [keyIsDown, secs, keyCode] = KbCheck();
      end 
    return
    %error('only call this function on mac OS X!');
  end
  
  if nargin==1
    [keyIsDown,secs,keyCode]= PsychHID('KbCheck', deviceNumber);
  elseif nargin == 0
    keyIsDown = 0;
    keyCode = logical(zeros(1,256));
    
    invalidProducts = {'USB Trackball'};
    devices = PsychHID('devices');
    for i = 1:length(devices)
      if(strcmp(devices(i).usageName, 'Keyboard') )
	for j = 1:length(invalidProducts)
	  if(~(strcmp(invalidProducts{j}, devices(i).product)))
	    [down,secs,codes]= PsychHID('KbCheck', i);
        codes(83) = 0;
	  
	    keyIsDown = keyIsDown | down;
	    keyCode = codes | keyCode;
	  end
	end
      end
    end
  elseif nargin > 1
    error('Too many arguments supplied to KbCheckM');
  end

return

