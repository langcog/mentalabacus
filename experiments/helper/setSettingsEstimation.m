
settings.viewing_interval = .4; % in seconds, so .4 = 400ms
settings.isi = 1; % inter stimulus interval
settings.dots.diam = 26; % 64 * (2/3)  
settings.textsize = 70;
settings.space_dim = [(ws.height-50) * (2/3) ws.height * (2/3)]; % note that this was 450 until 10/21 to match with analogestim
settings.response_size = 70;
settings.resp_len = 2;

settings.experiment_duration = 600;

settings.training_wait_times = [1 1 1 1 1];
settings.training_items = [3 7 22 164 50];
settings.num_training = length(settings.training_items);

% set up the quantities so that there are different quantities for each of
% abacus and numbers but twice as many trials for dots
% settings.quants = repmat([1:9],1,8); % from 1:20 x 4 for first estimation expt, then 1:9 x 8 for the second on 10/21

settings.quants = [repmat([3 8 15 30 60 90],1,6) repmat([4 5 7 12 20 25 40 50 75 120],1,2)];
settings.num_trials = length(settings.quants); 
settings.quants = [settings.quants(randperm(settings.num_trials)) ...
  settings.quants(randperm(settings.num_trials)) ...
  settings.quants(randperm(settings.num_trials)) ...
  settings.quants(randperm(settings.num_trials)) ...
  settings.quants(randperm(settings.num_trials))];
settings.num_trials = length(settings.quants); 

settings.before_trial_interval = .5;
settings.before_prompt_interval = 0;
