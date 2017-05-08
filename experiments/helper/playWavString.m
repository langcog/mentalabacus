function playWavString(string)

playWav('gwavs/ding.wav')

for i = 1:length(string)
  playWav(['gwavs/' num2str(string(i)) '.wav']);
end

