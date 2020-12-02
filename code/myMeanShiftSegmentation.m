function y = myMeanShiftSegmentation(vid,sp_sig,col_sig,time_sig,stopiter,numneighbour,lambda)
%Set XY coordinates
[row,col] = meshgrid(1:size(vid,2),1:size(vid,1));
%Scale XY coordinates to same dimensions as image colour intensities
coordscale=255/max([size(vid,2),size(vid,1)]);
%Create Featurespace with 5 columns and heightxwidth rows (formatted this way for knnsearch)
%Features are weighted by their gaussian variance, effectively creating a
%5D feature space where all features are equivalent
for time = 1:size(vid,4)
    for i = 1:size(vid,1)
        for j = 1:size(vid,2)
            featurespace((time*size(vid,1)+(i-1))*size(vid,2)+j,:)=[coordscale*row(i,j)/sp_sig,coordscale*col(i,j)/sp_sig,vid(i,j,1,time)/col_sig,vid(i,j,2,time)/col_sig,vid(i,j,3,time)/col_sig,time/(time_sig*size(vid,4))];
        end
    end
end
%a represents 1-learning rate (=lambda)
a=1-lambda;
%iterate over the image, each time moving via gradient ascent
for it = 1:stopiter
   [idx,D]=knnsearch(featurespace,featurespace,'k',numneighbour); %do k nearest neighbour search for each pixel
   %Calculate gradient at each pixel
   for val = 1:size(featurespace,1) 
      coef=exp(-(D(val,:).^2)/2); 
      coef = coef'./sum(coef);
      grad(val,:)=sum(featurespace(idx(val,:),:).*[coef coef coef coef coef coef]);
   end
   %update featurespace
   featurespace=a*featurespace+lambda*grad;
end
%Reshape and scale colour features back to original image size
for time = 1:size(vid,4)
    for i = 1:size(vid,1)
        for j = 1:size(vid,2)
            curr(i,j,:,time)=featurespace((time*size(vid,1)+(i-1))*size(vid,2)+j,3:5)*col_sig;
        end
    end
end
y = curr;