function settings = setSettings

% set fixation and presentation times for trials
settings.isi = .5;
settings.before_trial_interval = .5;
settings.tile_time = .3;
settings.fix_time = 1;
settings.trial_time_limit = 10;

settings.feedback_dur = .7;
settings.num_staircase_trials = 30;
settings.num_trials = 30;
settings.grid_dims = [5 5];
settings.grid_time = 1;
settings.tile_dim = 2; % dimension on which to tile
settings.box_size = 80; % size of boxes in grid 
settings.min_tiles = 3;
settings.min_digits = 3;
settings.min_letters = 3;
settings.max_digits = 8;
settings.text_size = 80;
settings.resp_len = 3;
settings.digits_resp_len = 10;

settings.space_dim = [640 640];
settings.dots.diam = 63;
settings.dots.show_interval = .5;
settings.dots.between_interval = .25;


settings.num_blocks = 12;
settings.digit_time = 1;