%% Video Toonification
%% Define all parameters for Toonification here
%location of video file
location = 'xylophone.mp4';
save_inp_loc = '../data/in_x.mp4';
save_loc = '../data/out_x.mp4';
downsample_x = 1;
downsample_y = 1;
downsample_frame = 100;
spatial_sigma = 100;
intensity_sigma = 300;
time_sigma = 500;
num_iter = 5;
num_neighbor = 10;
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
    blankvid(:,:,:,framecount) = double(frame(1:downsample_x:end, 1:downsample_y:end, :));
    if mod(framecount, 10) == 0
        fprintf('Current Time = %.3f sec\n', vidObj.CurrentTime);
    end
end
disp("Video downsampled and ready for processing");
toc;

%% Does the actual Mean Shift segmentation
tic;
downsampled_vid = blankvid(:, :, :, 1:downsample_frame:end);
mnshftvid = myMeanShiftSegmentation(downsampled_vid,spatial_sigma,intensity_sigma,time_sigma,num_iter,num_neighbor,lambda);
disp("Mean Shift segmentation done");
toc;
%% Save Input Video for later comparisons
tic;
inputVid = VideoWriter(save_inp_loc);
inputVid.FrameRate = vidObj.FrameRate;
open(inputVid);
for t = 1:size(blankvid, 4)
    blankvid(:,:,:,t) = blankvid(:,:,:,t) / max(max(max(blankvid(:,:,:,t))));
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
    mnshftvid(:,:,:,t) = mnshftvid(:,:,:,t) / max(max(max(mnshftvid(:,:,:,t))));
    writeVideo(outputVid, mnshftvid(:, :, :, t));
end
close(outputVid);
disp("Video output has been created");
toc;