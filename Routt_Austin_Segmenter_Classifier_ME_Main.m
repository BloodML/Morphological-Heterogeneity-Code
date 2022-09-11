% Routt, Austin
% RBC Segmenter and Classifier for Morphology Experiments
% Tuesday, January 11, 2021
clear all
close all
clc

%Set Random Number Generator Seed for reproducibility
rng('default')

%% Adjust Parameters and Load CNN Ensemble
% Each type of image will require slight adjustments to these parameters

statistic = "median"; % Adaptive Thresholding Statistics (mean, median, gaussian). Note, the most accurate is median, but it is slow. - []
radius = 6; %Remove specks in binary mask with this pixel radius size - [px]
spotSize = 1; %imextendedmin spot size in pixels, used on the distanceTransform image to get a mask for watershed - [px]
maximumRBCCount = 99999999; %The maximum number of RBCs in an image - [RBCs]
minimumRBCArea = 160; %The minimum area, in pixels, of an RBC in the image - [px^2]
maximumRBCArea = 1800; %The maximum area, in pixels, of an RBC in the image - [px^2]

%Load the mobilenetv2 with focal loss and scaling
load('.\Mobilenet Early Stop\Routt_Austin_Mobilenet_FocalLoss_Scale_EarlyStop.mat');
mobileNetV2 = net2;
clear net2

%Load the darknet with oversampling
load('.\Darknet\Routt_Austin_Darknet_Oversample.mat');
darkNet = net;
clear net

%Load the shuffleNet with focal loss and scaling
load('.\Shuttlenet Early Stop\Routt_Austin_Shuttlenet_FocalLoss_Scale_EarlyStop.mat');
shuffleNet = net2;
clear net2

%Load the Nasnetmobile
load('.\NASNET Mobile\Routt_Austin_Nasnetmobile_FocalLoss_Scale_EarlyStop.mat');
nasnetMobile = net2;
clear net2

%Put neural nets into an ensemble array
ensemble = [mobileNetV2, darkNet, shuffleNet, nasnetMobile ];

%% Segment and Classify a Unit-Week-Run Folder of Images

%Set a timer to test performance in seconds
tic

%Define the test set image directory address
dir = ".\U0W0_0";

%Create an image datastore using folder names as classification labels
imds = imageDatastore(dir,'IncludeSubfolders',false,'FileExtensions','.tif');

%Initialize system object blobAnalyser
%Set MinimumBlobArea, MaximumBlobArea, and MaximumCount
System = struct(...
    'blobAnalyser', vision.BlobAnalysis('BoundingBoxOutputPort', true,'AreaOutputPort', true, 'MajorAxisLengthOutputPort', true, 'MinorAxisLengthOutputPort', true, 'CentroidOutputPort', true,'MinimumBlobArea',minimumRBCArea, 'MaximumBlobArea',maximumRBCArea,'MaximumCount', maximumRBCCount) ...
    );
%Iterate through the image files
for i = 1:1:numel(imds.Files)
    %Load the original image
    originalImage = imread(imds.Files{i});
    %Add the original image to an array
    originalImages(:,:,:, i) = originalImage;
    %Segment the original image and add the mask to an array
    masks(:,:,i) = maskRBC(originalImage,statistic, radius, spotSize);
    %Get bboxes
    [areas,centroids,bboxes,majoraxis,minoraxis] = System.blobAnalyser(masks(:,:,i));
    %Put bboxes in a cell array
    areasOfImages(i) = {areas};
    centroidsOfImages(i) = {centroids};
    bboxesOfImages(i) = {bboxes};
    majoraxisOfImages(i) = {majoraxis};
    minoraxisOfImages(i) = {minoraxis};
    %Get cell labels
    [labels] = labelRBCs(originalImage, masks(:,:,i), bboxesOfImages{i}, ensemble);
    %Put labels in cell array
    labelsOfImages(i) = {labels};
end

%End the timer and get the benchmark data
toc
%% Show morphology histogram

%Create a variable for all labels
allLabels = [];
%Interate through each set of labels for each image
for ii = 1:1:width(labelsOfImages)
    %Add the set of labels to the all label's variable
    allLabels = [allLabels; labelsOfImages{ii}'];
end
%Plot the histogram of all labels to get the morphology distribution for
%the run
hist(allLabels);
%% Examine a single annotated images

%Choose an image number (each run has at least 360 images, but the example only has 7)
imageNum = 3;

%Annotate the original image with a rectangle and its tag number
originalImageAnnotated = insertObjectAnnotation(originalImages(:,:,:,imageNum),'rectangle',bboxesOfImages{imageNum},labelsOfImages{imageNum},'TextBoxOpacity',0.9,'FontSize',10);

%Draw the segmented and annotated image to the screen
%Note we are overlaying the annotated original image with the segmentation mask
figure
imshow(labeloverlay(originalImageAnnotated,masks(:,:,imageNum)))
title('Classified Cells')

%% Export Data

%Set the base export directory
baseDir ='.\';
%Set the name of the unit-week-run folder
unitWeekRun = 'U0W0_0_Output';

%Set the directories for masks, images, stats, and bounding boxes
dirMasks = strcat(baseDir,unitWeekRun,"\Masks");
dirImages = strcat(baseDir,unitWeekRun,"\Images");
dirStats = strcat(baseDir,unitWeekRun,"\Stats");



%Create the export directories if they don't exist
if ~exist(dirMasks, 'dir')
    mkdir(dirMasks)
end

if ~exist(dirImages, 'dir')
    mkdir(dirImages)
end

if ~exist(dirStats, 'dir')
    mkdir(dirStats)
end


%Save images, masks, bboxes and labels
%Iterate through image files
for i = 1:1:length(imds.Files)
    %Create a string for the file number
    n_strPadded = sprintf( '%06d', i ) ;
    %Create the base filename for images & masks
    baseFileName2 = strcat("mask",'_',num2str(n_strPadded),'.png');
    baseFileName1 = strcat("image",'_',num2str(n_strPadded),'.png');
    %Set image & mask full names
    maskFullFileName = fullfile(dirMasks, baseFileName2);
    imageFullFileName = fullfile(dirImages, baseFileName1);
    %Write image
    imwrite(originalImages(:,:,:,i), imageFullFileName);
    %Write mask
    imwrite(masks(:,:,i), maskFullFileName);
end
%Create a table for the stats (Note bounding boxes & labels are included)
stats=table(labelsOfImages', bboxesOfImages', areasOfImages', majoraxisOfImages', minoraxisOfImages', centroidsOfImages', 'VariableNames',{'Labels', 'Bboxes','Areas','Major','Minor','Centroid'});
%Create the file name
baseFileName3 = strcat("stats",".mat");
%Make the full file name
statsFullFileName = fullfile(dirStats, baseFileName3);
%Save the table as a matlab file
save(statsFullFileName,"stats");

