function [r rt1 rt2] =  drawTwoNumbers(ws,settings,q1,q2,time_limit)

% settings
accepted_keys = {'1!','2@','3#','4$','5%','6^','7&','8*','9(','0)',...
  'RETURN','DELETE','ESCAPE','ENTER','1','2','3','4','5','6','7',...
  '8','9','0'};

% now set up the main loop
num_string = [];
start_time = GetSecs;
blanks = repmat('_',1,max([ceil(log10(q1+q2))-length(num_string)+1 0]));
ts = Screen('TextBounds',ws.ptr,['How many? ' blanks]);
s = (ts(3) - ts(1)) /2 ;

Screen('DrawText',ws.ptr,['How many? ' blanks],ws.center(1) - s,...
  ws.center(2)+100,ws.black);
drawQuants(ws,q1,q2);
Screen('Flip',ws.ptr);

running = 1;
first = 1;
end_early = 0;

while running % keep doing this until we hit escape or enter
  run_time = GetSecs - start_time;
  pressed_key = getResponseKeypad(accepted_keys,time_limit - run_time);

  if first % only do this for the first keypress
    first = 0; 
    first_time = GetSecs;
    rt1 = first_time - start_time;
  end

  switch pressed_key % now decide what to do with the keypress    
    case 'RETURN'
      running = 0;
    case 'ENTER'
      running = 0;
    case 'DELETE'
      if ~isempty(num_string)
        num_string(end) = '';
      end
    case 'ESCAPE'
      end_early = 1;
      break;     
    case 'NONE'
      r = -1;
      rt1 = time_limit;
      rt2 = time_limit;      
      return;
    otherwise
      num_string = [num_string pressed_key(1)];
  end
 
  blanks = repmat('_',1,max([ceil(log10(q1+q2))-length(num_string)+1 0]));
  Screen('DrawText',ws.ptr,['How many? ' blanks num_string],...
    ws.center(1) - s,ws.center(2)+100,ws.black);
  drawQuants(ws,q1,q2);
  Screen('Flip',ws.ptr)
end

end_time = GetSecs;
rt2 = end_time - start_time;

if end_early
  r = -9999;
else
  if ~isempty(num_string)
    r = str2num(num_string);
  else
    r = -1;
  end
end

end

% helper function to update the quantities
function drawQuants(ws,q1,q2)


max_len = max([length(num2str(q1)) length(num2str(q2))]);
pq1 = [repmat(' ',1,max_len - length(num2str(q1))) num2str(q1)];
pq2 = [repmat(' ',1,max_len - length(num2str(q2))) num2str(q2)];

[x1,y1] = Screen('TextBounds',ws.ptr,pq1);
[x2,y2] = Screen('TextBounds',ws.ptr,pq2);

Screen('DrawText',ws.ptr,pq1,ws.center(1)-(x1(3)/2),ws.center(2)- (x1(4)*1.5),ws.black);
Screen('DrawText',ws.ptr,pq2,ws.center(1)-(x2(3)/2),ws.center(2)- (x2(4)/2),ws.black);

end
