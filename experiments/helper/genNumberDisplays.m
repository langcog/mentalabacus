% genNumberDisplays - heart of number comparison code.

function dots = genNumberDisplays(ws,settings,level)
% level = 4;
% settings = setSettingsNumComp;
% 
ratio = settings.ratios(level,:);

% PICK SIDE
dots.big_side = (rand > .5) + 1;
dots.small_side = 3 - dots.big_side;

if dots.big_side == 1
  dots.ratio = ratio([2 1]);
else
  dots.ratio = ratio;
end

% SET UP CONSTANTS
envelope_unit = [ws.rect(3)/2 ws.rect(4)];
envelope_range = settings.max_envelope - settings.min_envelope;
% area_unit = prod(envelope_unit) * settings.min_envelope * settings.max_area; 
area_range = settings.max_area - settings.min_area;
size_range = settings.max_size - settings.min_size;

% pick quantities - note they are limited by the ratio!
multiplier_range = [floor(settings.max_dots / dots.ratio(dots.big_side)) ...
  floor(settings.min_dots / dots.ratio(dots.small_side))];
multiplier = Randi(multiplier_range(1) - multiplier_range(2)) + multiplier_range(2); 
dots.qs = dots.ratio .* multiplier;

% PICK WHETHER AREA OR SIDE SIZE IS CONTROLLED
dots.area_correlated = rand > .5;
dots.size_correlated = 1 - dots.area_correlated;

% PARAMETERS FOR EACH DOT ARRAY
for i = 1:2 
  base = ones(1,dots.qs(i));
  % pick envelopes and areas
  dots.envelope_fraction(i) = (rand * envelope_range) + settings.min_envelope;
  dots.envelope(i,:) = round(dots.envelope_fraction(i) * envelope_unit);

  if dots.size_correlated
%     dots.correction = (dots.ratio(3-i) / dots.ratio(i));
    dots.density(i) = (rand * area_range) + settings.min_area;
    
    % correct to make anticorrelated
%     dots.density(i) = dots.density(i) * dots.correction;
    
    dots.dot_area(i) = round(dots.density(i) * prod(dots.envelope(i,:)));

    % get individual quantity distribution 
    % start with having them uniform
    dots.dot_areas{i} = base * (dots.dot_area(i)/dots.qs(i));

    % dot area = pi * r^2, so r = sqrt(area / pi)
    dots.dot_side{i} = round(sqrt(dots.dot_areas{i} / pi) * 2);
  elseif dots.area_correlated
    % now choose side size randomly
    dot_side{i} = round(base .* prod(dots.envelope(i,:)) .* ((rand * size_range) + settings.min_size));
    
%     dots.correction = (dots.ratio(3-i) / dots.ratio(i));
%     dot_side{i} = dot_side{i} .* dots.correction;
    
    % and now calculate the dot areas and density
    dot_areas{i} = pi .* ((dot_side{i}./2).^2);
    dot_area(i) = sum(dot_areas{i});
    density(i) = dot_area(i) ./ prod(dots.envelope(i,:));
    
    % OMG DO YOU HAVE TO DEFINE FIELDS IN THE SAME ORDER?!?!?
    dots.density(i) = density(i);
    dots.dot_area(i) = dot_area(i);
    dots.dot_areas{i} = dot_areas{i};
    dots.dot_side{i} = dot_side{i};
    dots.single_side(i) = dot_side{i}(1);
  end
end

