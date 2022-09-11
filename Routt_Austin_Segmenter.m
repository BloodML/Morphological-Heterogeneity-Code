function mask = Routt_Austin_Segmenter(originalImage)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


% Parameters
% Each type of image will require slight adjustments to these parameters
statistic = "gaussian"; % Adaptive Thresholding Statistics (mean, median, gaussian). Note, the most accurate is median, but it is slow. - []
radius = 6; %Remove specks in binary mask with this pixel radius size - [px]
spotSize = 1; %imextendedmin spot size in pixels, used on the distanceTransform image to get a mask for watershed - [px]


% Segmentation: Adaptive Thresholding, Hole Filling, Speck Removal, and Watershed

% Step 1) Adaptive Thresholding

%Normalize gray scale image
norm=mat2gray(originalImage);

%Get global image threshold using Adaptive Thresholding 
threshold = adaptthresh(norm, 0.57, 'NeighborhoodSize', [31,31],'ForegroundPolarity' ,'dark', 'Statistic', statistic);


%Create a binary mask where values greater than the threshold are true;this is the background
bw = norm>threshold;
%thicken black
se = strel('disk',14);
bw = imopen(bw,se);
%Fill in the holes in the cells by inverting the binary image; Note, does not work on cells at the image border
bw2 = imfill(~bw,'holes'); 

%Black border
bw2(1,:) = 0;
bw2(end,:) = 0;
bw2(:,1) = 0;
bw2(:,end) = 0;
% se = strel('disk',5);
% bw2 = imerode(bw2,se);

% Step 3) Remove specks
%Remove specks that have a radius less than "radius"
se = strel('disk',radius);
bw3 = imopen(bw2,se);

%Apply the mask to the original image
mask = originalImage.*double(bw3);


%Get global image threshold using Adaptive Thresholding 
threshold = adaptthresh(mask, 0.0001,'ForegroundPolarity' ,'bright', 'Statistic', 'mean');


%Create a binary mask where values greater than the threshold are true;this is the background
bw4 = norm>threshold;

%Fill in the holes in the cells by inverting the binary image; Note, does not work on cells at the image border
bw4 = imfill(~bw4,'holes'); 

%Remove specks that have a radius less than "radius"
se = strel('disk',radius);
bw4 = imopen(bw4,se);


mask = mask.*double(bw4);

end