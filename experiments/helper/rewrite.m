files = dir('~/Desktop/bmps/*.bmp');
names = {files.name};

for i = 1:length(names)
    im = imread(['~/Desktop/bmps/' names{i}]);
    colored = (im(:,:,1)==255|im(:,:,2)==255|im(:,:,3)==255);
    im = repmat(colored*255,[1 1 3]); 
    im(im==0) = 255/2;
    im = im/255;
    im = 1-im;

    imwrite(im,['jpgs/' names{i}(1:end-3) 'jpg'],'JPG');
end
