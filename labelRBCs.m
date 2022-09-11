function [labels] = labelRBCs(originalImage, mask, bboxes, ensemble)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


%Set the classification image size
cropSize = 227;

%Create a 51x51 blank image and set the background color to gray
background = ones(51, 'uint8')*220;

%Initialize storage variables
croppedImages = zeros(cropSize);  %Stores the cropped RBC grayscale images
%iterate through bounding boxes and segment cells

for i= 1:1:height(bboxes)
    %Set the current bounding box
    currentBbox = bboxes(i,:);
    %Crop the cell in the current bounding box, call it rbc
    rbc = imcrop(originalImage,currentBbox );
    %Crop the mask of the cell in the current bounding box
    rbcBW = imcrop(mask,currentBbox );
    %Remove binary masks on the edge, leaving just the center cell mask
    rbcBW = bwareafilt(rbcBW,1);
    %Apply the mask to the cell
    rbc = rbc.*uint8(rbcBW);
    %Turn black to gray
    rbc(rbc == 0) = 220;
    %Find height and width of rbc image
    [w, h] = size(rbc);
    %Find the best position for rbc to be pasted onto a 51x51 blank image
    startrow =  max(1, uint8((51 - w)/2));
    startcol =  max(1, uint8((51 - h)/2));
    a = background;
    b = rbc;
    %Paste rbc into 51x51 image
    a(startrow:startrow+size(b,1)-1,startcol:startcol+size(b,2)-1) = b;
    %Resize to 227x227
    a = imresize(a, [cropSize, cropSize]);
    a = im2gray(a);      %make sure its a grayscale image
    a = mat2gray(a); %Normalize
    %Segment the rbc
    a = Routt_Austin_Segmenter(a);

    %Store all crops in the appropriate storage variable
    croppedImages =cat(3,croppedImages, a);   %Array of cropped RBCs (original)
end

%Remove the first initialization image, it's all black
croppedImages(:,:,1) = [];

net1 = ensemble(1);
net2 = ensemble(2);
net3 = ensemble(3);
net4 = ensemble(4);
%Iterate through cropped cells and get labels
labels = categorical([]);
label = categorical({'D','E1','E2','E3','S','SE','ST'});

for i = 1:1:size(croppedImages,3)
    img = croppedImages(:,:,i);
    [~, score1] = classify(net1,img);
    [~, score2] = classify(net2,img);
    [~, score3] = classify(net3,img);
    [~, score4] = classify(net4,img);
    [~, I] = max(mean([score1;score2;score3;score4]));
    labels(i) = label(I); 
end


end









