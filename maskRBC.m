function mask = maskRBC(originalImage,statistic, radius, spotSize)


%% Segmentation
%Adaptive Thresholding, Hole Filling, Speck Removal, and Watershed

% Step 1) Adaptive Thresholding

%Normalize gray scale image
norm=mat2gray(originalImage);

%Get global image threshold using Adaptive Thresholding 
threshold = adaptthresh(norm, 'ForegroundPolarity' ,'dark', 'Statistic', statistic);


%Create a binary mask where values greater than the threshold are true;this is the background
bw = norm>threshold;

% Step 2) Fill Holes

%Fill in the holes in the cells by inverting the binary image; Note, does not work on cells at the image border
bw2 = imfill(~bw,'holes'); 

%Fill cell holes at the borders by padding each corner and filling.

%Pad the top left corner and fill cells on the edge, remove padding after
bw2TopLeft = padarray(bw2,[1 1],1,'pre');
bw2TopLeftFilled = imfill(bw2TopLeft,'holes');
bw2TopLeftFilled = bw2TopLeftFilled(2:end,2:end);

%Pad the top right corner and fill cells on the edge, remove padding after
bw2TopRight = padarray(padarray(bw2,[1 0],1,'pre'),[0 1],1,'post');
bw2TopRightFilled = imfill(bw2TopRight,'holes');
bw2TopRightFilled = bw2TopRightFilled(2:end,1:end-1);

%Pad the bottom right corner and fill cells on the edge, remove padding after
bw2BottomRight = padarray(bw2,[1 1],1,'post');
bw2BottomRightFilled = imfill(bw2BottomRight,'holes');
bw2BottomRightFilled = bw2BottomRightFilled(1:end-1,1:end-1);

%Pad the bottom left corner and fill cells on the edge, remove padding after
bw2BottomLeft = padarray(padarray(bw2,[1 0],1,'post'),[0 1],1,'pre');
bw2BottomLeftFilled = imfill(bw2BottomLeft,'holes');
bw2BottomLeftFilled = bw2BottomLeftFilled(1:end-1,2:end);

%Combine all edge cases through logical OR; output array is set to logical 1 (true) if either A or B contain a nonzero element at that same array location. Otherwise, the array element is set to 0.
bw2Filled = bw2TopLeftFilled | bw2TopRightFilled | bw2BottomRightFilled | bw2BottomLeftFilled;

% Step 3) Remove specks
%Remove specks that have a radius less than "radius"
se = strel('disk',radius);
bw3 = imopen(bw2Filled,se);

% Step 4) Watershed to divide connecting cells

%Get the negative distance transform of the inverse binary image
distanceTransform = -bwdist(~bw3);

%Use imextendedmin to get small spots at the center of each blob
mask0 = imextendedmin(distanceTransform,spotSize);

%Modify the distance transform, with the mask, to have local minima at the center of each blob
distanceTransform2 = imimposemin(distanceTransform,mask0);

%Use the watershed transform to determine dividing lines based on the distance transform with imposed local minima
waterShed = watershed(distanceTransform2);

%Apply dividing lines to the cleaned binary image
bw4 = bw3;
bw4(waterShed == 0) = 0;

mask = bw4;
end
