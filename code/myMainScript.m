%% Video Toonification
clear;
%% Define all parameters for Toonification here
%location of video file
%location = 'xylophone.mp4';
location = '../data/dubstepbird.mp4';
save_inp_loc = '../data/in_bird1_40it.mp4';
save_loc = '../data/out_bird1_40it.mp4';
downsample_x = 4;
downsample_y = 5;
downsample_frame = 2;
spatial_sigma = 100;
intensity_sigma = 100;
time_sigma = 10;
num_iter = 20;
num_neighbor = 150;
windowsize = num_neighbor;
windowed=0;
onlyy=0;
lambda = 0.3;
%% Reads video and stores in a video file
tic;
vidObj = VideoReader(location);
framecount = 0;
frame = readFrame(vidObj);
blankvid = double(frame(1:downsample_x:end, 1:downsample_y:end, :));

while(hasFrame(vidObj))
    framecount = framecount + 1;
    frame = readFrame(vidObj);
    blankvid(:,:,:,framecount) = (double(frame(1:downsample_x:end, 1:downsample_y:end, :)));
    if mod(framecount, 10) == 0
        fprintf('Current Time = %.3f sec\n', vidObj.CurrentTime);
    end
end
disp("Video downsampled and ready for processing");
disp(size(blankvid));
toc;

%% Does the actual Mean Shift segmentation
tic;
downsampled_vid = blankvid(:, :, :, 1:downsample_frame:end);
mnshftvid = myMeanShiftSegmentation(downsampled_vid,spatial_sigma,intensity_sigma,time_sigma,num_iter,num_neighbor,lambda,windowsize,windowed,onlyy);
disp("Mean Shift segmentation done");
toc;
%% Save Input Video for later comparisons
tic;
inputVid = VideoWriter(save_inp_loc);
inputVid.FrameRate = vidObj.FrameRate;
open(inputVid);
for t = 1:size(blankvid, 4)
    blankvid(:,:,:,t) = blankvid(:,:,:,t)/ max(max(max(blankvid(:,:,:,t))));
    writeVideo(inputVid, blankvid(:, :, :, t));
end
close(inputVid);
disp("Video input has been saved");
toc;

%% Output Video is created
tic;
outputVid = VideoWriter(save_loc);
% Due to downsampling, we have to modify framerate of output video
outputVid.FrameRate = vidObj.FrameRate * 1.0 / downsample_frame;
open(outputVid);
for t = 1:size(mnshftvid, 4)
    %mnshftvid(:,:,:,t)= rescale(mnshftvid())
    mnshftvid(:,:,:,t) = ((mnshftvid(:,:,:,t))/ max(max(max(mnshftvid(:,:,:,t)))));
    writeVideo(outputVid, mnshftvid(:, :, :, t));
end
close(outputVid);
disp("Video output has been created");
toc;