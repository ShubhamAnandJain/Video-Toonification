%%
myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]' , ...
    [0:1/(myNumOfColors-1):1]' , [0:1/(myNumOfColors-1):1]' ];
%%
images = {'./images/Madhur.jpg'};
path = images{1};
input_im = imread(path);
imshow(input_im)