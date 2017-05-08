function [r rt1 rt2] =  drawManyNumbersSqrt(ws,settings,qs,varargin)

  if nargin > 3
    ans = varargin{1};
  else
    ans = sum(qs);
  end

  % settings
  accepted_keys = {'1!','2@','3#','4$','5%','6^','7&','8*','9(','0)',...
    'RETURN','DELETE','ESCAPE','ENTER','1','2','3','4','5','6','7',...
    '8','9','0'};

  % now set up the main loop
  num_string = [];
  start_time = GetSecs;

  running = 1;
  first = 1;
  end_early = 0;
  
  time_limit = settings.trial_time_limit;

  drawQuants(ws,length(qs),qs,num_string,ans);

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

    drawQuants(ws,length(qs),qs,num_string,ans);
  end

  end_time = GetSecs;
  rt2 = end_time - start_time;
  
  if ~isempty(num_string)
    r = str2num(num_string);
  else
    r = -1;
  end

end

% helper function to update the quantities
function drawQuants(ws,n,qs,num_string,ans)
  rbound = ws.center(1) + 50;
  
  blanks = repmat('_',1,max([ceil(log10(ans))-length(num_string)+4 0]));
  max_len = n;
  
  [x y] = Screen('TextBounds',ws.ptr,num2str(qs));
  Screen('DrawText',ws.ptr,num2str(qs),rbound - x(3),ws.center(2),ws.black);

  prompt = ['Square root? ' blanks num_string];
  [px py] = Screen('TextBounds',ws.ptr,prompt);
  Screen('DrawText',ws.ptr,prompt,rbound-px(3),ws.center(2)+100,ws.black);

  Screen('Flip',ws.ptr);
end
