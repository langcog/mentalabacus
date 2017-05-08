% [keyIsDown,secs,keyCode] = KbCheckM(deviceNumber)
% check all attached keyboards for keys that are down
%
% Tim Brady and Oliver Hinds 
% 2007-07-18
                                  
function [keyIsDown,secs,keyCode] = KbCheckM(deviceNumber)

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
