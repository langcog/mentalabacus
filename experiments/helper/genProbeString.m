function [ps tf] = genProbeString(settings,s)

if rand > .5, tf = true; else tf = false; end;

n = Randi(length(s));
ps = zeros(size(s));

if tf
  ps(n) = s(n);
else
  dists = 1:length(settings.wavs);
  dists(dists==s(n)) = [];
  ps(n) = dists(Randi(length(dists))); % choose a syllable at random
end

