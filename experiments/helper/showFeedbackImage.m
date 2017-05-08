function showFeedbackImage(img,ws,time)

lumval=200;
im = imread(img);
im=imresize(im,[100 100]);
R=im(:,:,1);
G=im(:,:,2);
B=im(:,:,3);
useThese=R>lumval & G>lumval & B>lumval;
alpha=ones(size(R))*255;
alpha(useThese)=0;
im(:,:,4)=alpha;
imt = Screen('MakeTexture',ws,im);
Screen('DrawTexture',ws,imt);
Screen('Flip',ws);

WaitSecs(time);