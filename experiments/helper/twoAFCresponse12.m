function [resp rt] = twoAFCresponse12

% accepted_keys = {'z','m','Z','M'};
start_time = GetSecs;
accepted_keys = {'.','0','z','m','Z','M','1','3','1!','3#'};
r = getResponseKeypad(accepted_keys);
rt = GetSecs - start_time;

if any(strcmp({'0','z','Z','1','1!'},r))
  resp = 1;
elseif any(strcmp({'.','m','M','3','3#'},r))
  resp = 2;
end