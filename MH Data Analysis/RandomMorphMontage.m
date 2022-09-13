function [] = RandomMorphMontage(table1, samplesize, heading, baseDir, dirExport)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[r c] = size(table1);
if r<samplesize
samplesize = r;
end
if r ~= 1 && c ~= 1
Y = datasample(table1,samplesize,'Replace',false);
samples = [];
str = [];
for ii = 1:1:height(Y)
    unit = table2array(Y(ii, 2));
    week = table2array(Y(ii, 3));
    run = table2array(Y(ii, 4));
    image = table2array(Y(ii, 5));
    bbox = table2array(Y(ii, 11));
    str = strcat("U", num2str(unit),"W",num2str(week), "_", num2str(run));

    %Create a 51x51 blank image
    background1 = ones(51, 'uint8')*0;
    imageDir = fullfile(baseDir,str,"Images", image );
    temp = imread(imageDir, 'png');


    points = bbox2points(bbox);
    colStart = max(1, points(1,1));
    colEnd = max(4, points(2,1))-1;
    rowStart = max(1, points(1,2));
    rowEnd = max(3, points(3,2))-1;

    col = colStart:1:colEnd;
    row = rowStart:1:rowEnd;

    rbc = temp(row, col);

    %Reize
    rbc = imresize(rbc,1.7);
    %Find height and width of rbc image
    [w, h] = size(rbc);
    %Find the best position for rbc to be pasted onto a 51x51 blank image
    startrow =  max(1, uint8((51 - w)/2));
    startcol =  max(1, uint8((51 - h)/2));
    a = background1;
    b = rbc;
    %Paste rbc into 51x51 image
    a(startrow:startrow+size(b,1)-1,startcol:startcol+size(b,2)-1) = b;

    %Resize to 227x227
    cropSize = 227;
    a = imresize(a, [cropSize, cropSize]);
    samples(:,:,ii) = uint8(a);

end
fig = figure;
montage(uint8(samples))
title(heading)
saveas(fig, dirExport);
end
