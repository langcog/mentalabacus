function [r rt1 rt2] =  getNumResponse(ws,settings,qs)

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

  drawQuants(ws,length(qs),qs,num_string);

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

    drawQuants(ws,length(qs),qs,num_string);
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
function drawQuants(ws,n,qs,num_string)

  blanks = repmat('_',1,max([ceil(log10(sum(qs)))-length(num_string)+1 0]));
  ts = Screen('TextBounds',ws.ptr,['= ' blanks num_string]);
  s = (ts(3) - ts(1)) /2 ;
  max_len = n;

  Screen('DrawText',ws.ptr,['Sum? ' blanks num_string],ws.center(1) - s - 100,...
    ws.center(2),ws.black);

  Screen('Flip',ws.ptr);
end
