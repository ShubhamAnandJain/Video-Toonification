%% Mean Shift Segmentation of a video

vidObj = VideoReader('xylophone.mp4');
vidObj.CurrentTime
framecount = 0;
frame = readFrame(vidObj);
blankvid = double(frame(1:2:end,1:2:end,:));
while(hasFrame(vidObj))
    framecount =framecount+1;
    
    frame = readFrame(vidObj);
    blankvid(:,:,:,framecount)=double(frame(1:2:end,1:2:end,:));
    imshow(frame);
    title(sprintf('Current Time = %.3f sec', vidObj.CurrentTime));
    %pause(2/vidObj.FrameRate);
end
%% Pass to Mean shift Segmentation
tic;
blankvid = blankvid(:,:,:,1:20:end);
disp(size(blankvid));
mnshfvid = myMeanShiftSegmentation(blankvid,100,300,500,10,50,0.3);
tok;
%% Display video
dispvid = mnshfvid;
for time = 1:size(dispvid,4)
    imshow(dispvid(:,:,:,time)./255)
    pause(2/vidObj.FrameRate);
end
%% Image of a Baboon
%  Gaussian kernel bandwidth for the color feature : 300
%  Gaussian kernel bandwidth for the spatial feature : 100
%  Number of Iterations : 20
% im = imread('../data/baboonColor.png');
% smoothened = imgaussfilt(im,1);
% subsamp = smoothened(1:2:end,1:2:end,:);
% tic;
% mnshf = myMeanShiftSegmentation(double(subsamp),100,300,20,200,0.3);
% subplot(1, 2, 1)
% imshow(im)
% title("Original Image");
% subplot(1, 2, 2)
% imshow(mnshf./255)
% title("Mean Shift Filtered Image");
% toc;
% %% Image of a bird
% %  Gaussian kernel bandwidth for the color feature : 200
% %  Gaussian kernel bandwidth for the spatial feature : 40
% %  Number of Iterations : 20
% im = imread('../data/bird.jpg');
% smoothened = imgaussfilt(im,1);
% subsamp = smoothened(1:4:end,1:4:end,:);
% tic;
% mnshf = myMeanShiftSegmentation(double(subsamp),40,200,20,200,0.3);
% subplot(1, 2, 1)
% imshow(im)
% title("Original Image");
% subplot(1, 2, 2)
% imshow(mnshf./255)
% title("Mean Shift Filtered Image");
% toc;
% %% Image of a Flower
% %  Gaussian kernel bandwidth for the color feature : 200
% %  Gaussian kernel bandwidth for the spatial feature : 200
% %  Number of Iterations : 20
% im = imread('../data/flower.jpg');
% smoothened = imgaussfilt(im,1);
% subsamp = smoothened(1:2:end,1:2:end,:);
% tic;
% mnshf = myMeanShiftSegmentation(double(subsamp),200,200,20,200,0.3);
% subplot(1, 2, 1)
% imshow(im)
% title("Original Image");
% subplot(1, 2, 2)
% imshow(mnshf./255)
% title("Mean Shift Filtered Image");
% toc;
%%

