% modified from EV

function [r rt1] = readInLettersResponse(ws,settings)

Screen('TextSize',ws.ptr,settings.text_size);

accepted_keys = {'b','c','d','f','g','h','j','k','l','m','n','p','q','r',...
  's','t','v','w','x','z','B','C','D','F','G','H','J','K','L','M','N','P','Q','R',...
  'S','T','V','W','X','Z','RETURN','DELETE','ESCAPE','ENTER',};

num_string = [];
start_time = GetSecs;
blanks = repmat('_',1,max([settings.digits_resp_len-length(num_string)+1 0]));
ts = Screen('TextBounds',ws.ptr,[blanks]);
s = (ts(3) - ts(1)) /2 ;

Screen('DrawText',ws.ptr,[blanks],ws.center(1) - s,...
  ws.center(2),ws.black);
Screen('Flip',ws.ptr)

running = 1;
first = 1;
end_early = 0;

while running % keep doing this until we hit escape or enter
  pressed_key = getResponseKeypad(accepted_keys);

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
    otherwise
      num_string = [num_string upper(pressed_key(1))];
  end
 
  blanks = repmat('_',1,max([settings.digits_resp_len-length(num_string)+1 0]));
  Screen('DrawText',ws.ptr,[blanks num_string],...
    ws.center(1) - s,ws.center(2),ws.black);
  Screen('Flip',ws.ptr)
end

end_time = GetSecs;
rt2 = end_time - start_time;

if end_early
  r = -9999;
else
  if ~isempty(num_string)
    for i = 1:length(num_string)
      r{i} = num_string(i);
    end
  else
    r = 0;
  end
end
