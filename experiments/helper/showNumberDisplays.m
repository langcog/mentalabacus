% showNumberDisplays - creates actual displays out of numbers

function dots = showNumberDisplays(ws,settings,mask,varargin)

if nargin > 3
  test = varargin{1};
else 
  test = 0;
end

max_iter = 10;
max_restarts = 50;

% PLOT FOR TEST
if test == 1
  clf
  axis([0 1280 0 800])
  axis ij
end

% PLACE DOTS FOR EACH ARRAY
signs = [-1 1]; % goes from left to right

restart = 1;
while restart
  dots = genNumberDisplays(ws,settings,settings.ratio_level(end));
  restarts = 1;
  
  for i = 1:2
    center(1) = ws.rect(3)/2 + ws.rect(3)/4 * signs(i);
    center(2) = ws.rect(4)/2;

    % centers envelope in area
    envelope = round(dots.envelope(i,:));
    envelope_tl = round(center - envelope/2);

    if test == 1
      rectangle('Position',[envelope_tl(1) envelope_tl(2) envelope(1) envelope(2)]);
    end

    % PLACE INDIVIDUAL DOTS
    j = 1;
    dots.positions{i} = zeros(4,dots.qs(i));
    while j <= dots.qs(i) && restarts < max_restarts;        
      dots.positions{i}(:,j) = newDot(dots.dot_side{i}(j),envelope,envelope_tl);

      % CHECK FOR OVERLAP
      num_iter = 1;
      overlaps = checkOverlap(dots.positions{i}(:,1:j));
      while overlaps && num_iter < max_iter
        dots.positions{i}(:,j) = newDot(dots.dot_side{i}(j),envelope,envelope_tl);
        overlaps = checkOverlap(dots.positions{i}(:,1:j));
        num_iter = num_iter + 1;      
%         fprintf('.')
      end

      % RESTART IF WE CAN'T PLACE, OTHERWISE MOVE ON
      if num_iter >= max_iter
        j = 1;
        restarts = restarts + 1;
%         fprintf('restarting\n'); 
      else
        j = j + 1;      
%         fprintf('\n');
      end     
    end
  end
  
  if restarts < max_restarts
    restart = 0;
  else
    if dots.size_correlated
      tt= 'size correlated';
    else
      tt= 'area correlated';
    end
    
    fprintf('failure. trying again. %s trial.\n',tt)
  end
   
  % PLOT FOR TEST
  if test == 1
    for i = 1:2
      for j = 1:dots.qs(i)
        rectangle('Position',[dots.positions{i}(1,j) dots.positions{i}(2,j) dots.dot_side{i}(j) ...
          dots.dot_side{i}(j)]);
%         text(dots.positions{i}(1,j),dots.positions{i}(2,j),num2str(j))
      end
    end
  end  
end

% NOW DRAW IT ALL
if test < 1 || test > 2
  for i = 1:2
    Screen('FillOval', ws.ptr, [0 0 255], dots.positions{i});   
%     Screen('FrameOval', ws.ptr, ws.black, dots.positions{i},1.5);   
    
  end
  
  Screen('DrawLine',ws.ptr,[0 0 0], ws.rect(3)/2, 0, ws.rect(3)/2, ...
    ws.rect(4), settings.line_width);

  Screen('DrawText',ws.ptr,num2str(settings.ratio_level(end)), ...
    ws.rect(3)-80,ws.rect(4)-80);
  Screen('Flip',ws.ptr);
  
  if test == -1
    waitForNewKeypress
  else
    WaitSecs(settings.dot_display_time);
  end
  
  showMask(ws,mask);
  WaitSecs(settings.mask_display_time);
end


% dots is [left, top, right, bottom]
function tf = checkOverlap(dots)

last_dot = dots(:,end);
other_dots = dots(:,1:end-1);

tf = any((other_dots(1,:) <= last_dot(1) & other_dots(3,:) >= last_dot(1) & ...
          other_dots(2,:) <= last_dot(2) & other_dots(4,:) >= last_dot(2)) | ...
         (other_dots(1,:) <= last_dot(1) & other_dots(3,:) >= last_dot(1) & ...
          other_dots(2,:) <= last_dot(4) & other_dots(4,:) >= last_dot(4)) | ...
          (other_dots(1,:) <= last_dot(3) & other_dots(3,:) >= last_dot(3) & ...
          other_dots(2,:) <= last_dot(2) & other_dots(4,:) >= last_dot(2)) | ...
          (other_dots(1,:) <= last_dot(3) & other_dots(3,:) >= last_dot(3) & ...
          other_dots(2,:) <= last_dot(4) & other_dots(4,:) >= last_dot(4)));
        
function dot = newDot(side,envelope,envelope_tl)    

center = [Randii(envelope(1)-side) Randii(envelope(2)- side)] + ...
    envelope_tl + side/2;           
    
dot = [center(1) - side/2 ...
  center(2) - side/2 ...
  center(1) + side/2 ...
  center(2) + side/2];      

function i = Randii(n)

i=ceil(n*rand);