% Routt, Austin
% Morphology Experiments Data Analysis
% Wednesday, June 21, 2022
clear all
close all
clc

%%  Collect all data directories and statistics into a table to centralize the data
disp('Problem 1 start: Collect all data directories and statistics into a table to centralize the data')

%Define the base import directory address
baseImportDir = 'D:\MH Dataset';

% Generate the names of all first run folders
%Start a count for each unit-week-run
count = 0;
%Create a storage cell for each unit-week-run folder
strs = {};

%Iterate through unit numbers
for ii = ['1','2','3','4','5','6','7']
    %Iterate through week numbers
    for jj = ['6','7','8']
        %Increment the count
        count = count+1;
        %Create the unit-week-run string
        temp = strcat('U', ii,'W',jj,'_1');
        %Add the unit-week-run string to the cell container
        strs(count) = {temp};
    end
end

%Manually define & add the extra runs, which are not consistently numbered
extra = [ 
"U1W6_2" 
"U1W8_2" 
"U1W8_3" 
"U1W8_4" 
"U1W8_5"
"U1W8_6"
"U1W8_7"
"U1W8_8"
"U2W6_2"
"U2W6_3"
"U2W6_4"
"U2W7_2"
"U2W7_3"
"U2W7_4"
"U2W7_5"
"U2W7_6"
"U2W7_7"
"U2W8_2"
"U2W8_3"
"U2W8_4"
"U2W8_5"
"U2W8_6"
"U3W6_2"
"U3W6_3"
"U3W6_4"
"U3W6_5"
"U3W6_6"
"U3W7_2"
"U3W7_3"
"U3W7_4"
"U3W7_5"
"U3W7_6"
"U3W7_7"
"U3W8_2"
"U3W8_3"
"U3W8_4"
"U3W8_5"
"U3W8_6"
"U4W6_2"
"U4W6_3"
"U4W6_4"
"U4W6_5"
"U4W6_6"
"U4W7_2"
"U4W7_3"
"U4W7_4"
"U4W7_5"
"U4W7_6"
"U4W7_7"
"U4W7_8"
"U4W8_2"
"U4W8_3"
"U4W8_4"
"U4W8_5"
"U4W8_6"
"U5W6_2"
"U5W6_3"
"U5W6_4"
"U5W6_5"
"U5W7_2"
"U5W7_3"
"U5W7_4"
"U5W7_5"
"U5W7_6"
"U5W8_2"
"U5W8_3"
"U5W8_4"
"U5W8_5"
"U5W8_6"
"U5W8_7"
"U6W6_2"
"U6W6_3"
"U6W6_4"
"U6W6_5"
"U6W6_6"
"U6W7_2"
"U6W7_3"
"U6W7_4"
"U6W7_5"
"U6W7_6"
"U6W7_7"
"U6W8_2"
"U6W8_3"
"U6W8_4"
"U6W8_5"
"U6W8_6"
"U6W8_7"
"U7W6_2"
"U7W6_3"
"U7W6_4"
"U7W6_5"
"U7W6_6"
"U7W7_2"
"U7W7_3"
"U7W7_4"
"U7W7_5"
"U7W7_6"
"U7W7_7"
"U7W7_8"
"U7W8_2"
"U7W8_3"
"U7W8_4"
"U7W8_5"
"U7W8_6"
"U7W8_7"
];

% Create an empty table for the results
variable_names_types = [...
    ["Unit-Week-Run", "string"]; ...
    ["Image", "string"]; ...
    ["Mask", "string"]; ...
    ["Label", "cell"]; ...
    ["Bboxes", "int32"]; ...
    ["Areas", "int32"]; ...
    ["Major Diameter", "double"]; ...
    ["Minor Diameter", "double"]; ...
    ["Centroid", "double"]];

dataTable = table('Size',[0,size(variable_names_types,1)],...
    'VariableNames', variable_names_types(:,1),...
    'VariableTypes', variable_names_types(:,2));

strs = [strs, extra'];

%Iterate through the strings
for ii = strs
%Define the image directory
dirImages = fullfile(baseImportDir, ii,'Images', '*.png');
%Get all image names
filesImages = struct2table(dir(dirImages));
%Define the mask director and get all masks
dirMasks = fullfile(baseImportDir, ii,'Masks','*.png');
%Get all mask names
filesMasks = struct2table(dir(dirMasks));
%Define the statistics directory
dirStats = fullfile(baseImportDir, ii,'Stats','stats.mat');
%Load Statistics
load(dirStats,'stats')


%Get all image & mask names in the current run folder & combine with
%unit-week-run numbers
images = string(filesImages.(1));
masks = string(filesMasks.(1));
unitWeekRun = repelem([ii], height(stats))';
ids = {unitWeekRun{:}; images{:}; masks{:}}';

%Combine the identifying  strings with the stats
newRows = [ids , table2cell(stats)];
%Add the new row to the data table
dataTable = [dataTable;newRows];
end

%Export the data table to the base import directory
baseFileName = strcat("dataTable",".mat");
dataFullFileName = fullfile(baseImportDir, baseFileName);

save(dataFullFileName,"dataTable");

disp('Problem 1 end')
disp('-----------------------------------------------------------')
%% Load the data table & compile into a table of cells

clear all
close all
clc

disp('Problem 2 start: Load the data table, extract cells, & compile into a new table')

%Define the base import directory address and filename
baseImportDir = 'D:\MH Dataset';
baseFileName = strcat("dataTable",".mat");
dataFullFileName = fullfile(baseImportDir, baseFileName);

%Load the data
load(dataFullFileName,"dataTable");

% Make a table of all cells and their associated labels and metrics
%Define the empty cell table
variable_names_types = [...
    ["ID", "double"]; ...
    ["Unit", "double"]; ...
    ["Week", "double"]; ...
    ["Run", "double"]; ...
    ["Image", "string"]; ...
    ["Mask", "string"]; ...
    ["Label", "categorical"]; ...
    ["Area", "int32"]; ...
    ["Major Diameter", "double"]; ...
    ["Minor Diameter", "double"]; ...
    ["Bboxes", "int32"]; ...
    ["Centroid", "double"]];
    

cellTable = table('Size',[0,size(variable_names_types,1)],...
    'VariableNames', variable_names_types(:,1),...
    'VariableTypes', variable_names_types(:,2));

%Start a count for the cell id
id = 0;

%Iterate through the dataTable
for ii = 1:1:height(dataTable)

    %Iterate through the labels and statistics
    for jj = 1:1:height(dataTable.Bboxes{ii})

        %Increment the count
        id = id+1;

        %Get the unit, week, run numbers
        unitWeekRun = sscanf(dataTable.("Unit-Week-Run"){ii}, "U%dW%d_%d");
        unit = unitWeekRun(1);
        week = unitWeekRun(2);
        run = unitWeekRun(3);

        %Get the associated image & mask names
        image = dataTable.("Image"){ii};
        mask = dataTable.("Mask"){ii};

        %Create a new row for the table
        label = dataTable.Label{ii}(:, jj);
        area = dataTable.Areas{ii}(jj,:);
        major = dataTable.("Major Diameter"){ii}(jj,:);
        minor = dataTable.("Minor Diameter"){ii}(jj,:);
        bbox = dataTable.Bboxes{ii}(jj,:);
        centroid = dataTable.Centroid{ii}(jj,:);


        %Add the row to the table
        newRows = {id; unit; week; run; image; mask; label; area; major; minor; bbox; centroid};
        cellTable = [cellTable;newRows'];


    end

end

%Export the cell table to the base import directory
baseFileName = strcat("cellTable",".mat");
cellFullFileName = fullfile(baseImportDir, baseFileName);

save(cellFullFileName,"cellTable");


disp('Problem 2 end')
disp('-----------------------------------------------------------')


%% Clean & Analyze the average diameter distributions to get a more precise range for future applications in identification and sorting
clear all
close all
clc

disp('Problem 3 start: Clean & Analyze the average diameter distributions')
%Define the export directory
baseDir = 'D:\MH Dataset';

%Load the data
baseFileName = strcat("cellTable",".mat");
cellFullFileName = fullfile(baseDir, baseFileName);
load(cellFullFileName,"cellTable");

%Create the export directories if they doesn't exist
dirExport = fullfile(baseDir, 'Average Diameter Analysis');
dirNormalityRaw = fullfile(dirExport, 'Normality Analysis (Raw)');
dirNormalityClean = fullfile(dirExport, 'Normality Analysis (Clean)');
dirBootstrap = fullfile(dirExport, 'Bootstrap Analysis');
dirRandom = fullfile(dirExport, 'Random Samples');
dirRandomRuns = fullfile(dirRandom, 'Randoms RBC - Runs');
dirRandomDups = fullfile(dirRandom, 'Randoms RBC - Duplicates');
dirAspectRatio = fullfile(dirExport, 'Aspect Ratio Analysis');
dirOutlierAnalysis = fullfile(dirExport, 'Outlier Analysis');
dirOutliers = fullfile(dirOutlierAnalysis, 'Outliers');
dirNotOutliers = fullfile(dirOutlierAnalysis, 'Not Outliers');
dirMedians = fullfile(dirOutlierAnalysis, 'Medians');
dirMeans = fullfile(dirOutlierAnalysis, 'Means');
if ~exist(dirExport, 'dir')
    mkdir(dirExport)
end
if ~exist(dirNormalityRaw, 'dir')
    mkdir(dirNormalityRaw)
end
if ~exist(dirNormalityClean, 'dir')
    mkdir(dirNormalityClean)
end
if ~exist(dirBootstrap, 'dir')
    mkdir(dirBootstrap)
end
if ~exist(dirRandom, 'dir')
    mkdir(dirRandom)
    mkdir(dirRandomDups)
    mkdir(dirRandomRuns)
end
if ~exist(dirAspectRatio, 'dir')
    mkdir(dirAspectRatio)
end
if ~exist(dirOutlierAnalysis, 'dir')
    mkdir(dirOutlierAnalysis)
    mkdir(dirOutliers)
    mkdir(dirNotOutliers)
    mkdir(dirMedians)
    mkdir(dirMeans)
end

%Define a conversion factor for px to um and convert the cell area into diameter
convFac = 0.2193; %[um/px]
%Also add the diameter to the cell table via a new column
cellTable.("Average Diameter") = 2*sqrt(double(cellTable.Area)/pi)*convFac;
%% Examine the Raw Data
%Define RBC morphology label order
rbcLabels = {'D', 'E1', 'E2', 'E3', 'SE', 'S', 'ST'};

%Get a boxplot of the cell morphology diameters and save it
boxplotFig1 = figure;
boxplot(cellTable.("Average Diameter"),cellTable.Label, 'GroupOrder', rbcLabels);
title('Raw Box plot: Average Diameter by Morphology Type')
xlabel('Morphology Type')
ylabel('Average RBC Diameter (\mum)')

%Create the file name for the box plot
boxplotExport = fullfile(dirExport, "RawAverageDiameterBoxplot.png");

%Export the figure to the Data Analysis Folder
saveas(boxplotFig1, boxplotExport);

%Get normality and qq-plots to determine if data is normally distributed
AverageDiameterNormalityAnalysis(cellTable,dirNormalityRaw)

%% Cleaning Begins
%  First, remove duplicates from each run by iterating through every unit-week-run
%  Create a new table without run duplicates (Bounding box duplicates)
cellTableNoDups = cellTable(1,:);
% Iterate through units
for i = 1:1:7
    %Iterate through weeks
    for j = 6:1:8
        %Since number of runs is variable, get unique runs for the unit-week
        uniqueRuns = [table2array(unique(cellTable(cellTable.Unit == i & cellTable.Week== j,'Run')))];
        %Iterate through runs
        for k = uniqueRuns'
            %Define the unit-week-run subset
            subset = unique(cellTable(cellTable.Unit == i & cellTable.Week== j & cellTable.Run == k,:));
            %Define the output image name for the random runs
            str = strcat("U", num2str(i), "W", num2str(j), "_", num2str(k), ".png");

            %Get random duplicates by finding bounding box duplicates in each run
            unitWeekRun = table2array(subset(:,11));
            [~,uidx] = unique(unitWeekRun(:,:),'rows');
            count = [1:1:height(unitWeekRun)]';
            another = setdiff(count, uidx);
            subsetWithoutDup = subset(uidx,:);
            subsetWithDup = subset(another,:);

            %Export a random sample of the duplicates in each run
            exportNameDups = fullfile(dirRandomDups, str);
            RandomTableMontage(subsetWithDup, 100, baseDir, exportNameDups);

            %Export a random sample without duplicates
            exportNameRuns = fullfile(dirRandomRuns, str);
            RandomTableMontage(subsetWithoutDup, 100, baseDir, exportNameRuns);
            %Add no duplicate rows to the new table
            cellTableNoDups = [cellTableNoDups; subsetWithoutDup];

        end
    end
end

%% Analyze each morphology class by height, width, and bounding box outliers

%Get the height, width, & Aspect Ratio of the bounding boxes
bboxesAll = table2array(cellTableNoDups(:, 'Bboxes'));
widthAll = bboxesAll(:,3);
heightAll = bboxesAll(:,4);
aspectAll = double(widthAll)./double(heightAll);
%Give each its own column in the table
cellTableNoDups(:, "Height") = table(heightAll);
cellTableNoDups(:, "Width") = table(widthAll);
cellTableNoDups(:, "Aspect Ratio") = table(aspectAll);


%Define the sample sizes
sampleSize1 = 1000-8;

%Iterate through RBC labels to examine what various standard deviation
%settings yield
for uu = rbcLabels
    %Create the subset table based on morphology
    subset = cellTableNoDups( (cellTableNoDups.Label == uu), :);

    %Get morphology specific heights, widths, and aspect ratios
    morphHeight = double(table2array(subset(:, "Height")));
    morphWidth = double(table2array(subset(:, "Width")));
    morphAspect = double(table2array(subset(:, "Aspect Ratio")));

    for numSTD = 1:1:4
        %Define Output name for random samples
        strHeight = strcat(uu," - ", num2str(numSTD)," SD Below Mean Height (n = ",num2str(sampleSize1),")");
        strHeightReg = strcat(uu," - ", num2str(numSTD)," SD Other Height (n = ",num2str(sampleSize1),")");
        strWidth = strcat(uu," - ", num2str(numSTD)," SD Below Mean Width (n = ",num2str(sampleSize1),")");
        strWidthReg = strcat(uu," - ", num2str(numSTD)," SD Other Width (n = ",num2str(sampleSize1),")");
        strAspect = strcat(uu," - ", num2str(numSTD)," SD Below & Above Mean Aspect Ratio (n = ",num2str(sampleSize1),")");
        strAspectReg = strcat(uu," - ", num2str(numSTD)," SD Other Aspect Ratio (n = ",num2str(sampleSize1),")");

        %Define too small & too big for height, width, and aspect ratio
        tooSmallHeight = mean(morphHeight)-(numSTD*std(morphHeight));
        tooSmallWidth = mean(morphWidth)-(numSTD*std(morphWidth));
        tooSmallAspect = mean(morphAspect)-(numSTD*std(morphAspect));
        tooBigAspect = mean(morphAspect)+(numSTD*std(morphAspect));
        
        %Get the subsets of the subsets
        heightOut = subset(subset.("Height")<tooSmallHeight, :);
        heightReg = subset(subset.("Height")>=tooSmallHeight, :);
        widthOut = subset(subset.("Width")<tooSmallWidth, :);
        widthReg = subset(subset.("Width")>=tooSmallWidth, :);
        aspectOut = subset(subset.("Aspect Ratio")<tooSmallAspect | subset.("Aspect Ratio")>tooBigAspect, :);
        aspectReg = subset(subset.("Aspect Ratio")>=tooSmallAspect & subset.("Aspect Ratio")<=tooBigAspect, :);

        %Define export files names
        randomHeight = fullfile(dirAspectRatio, strcat( strHeight,'.png'));
        randomHeightReg = fullfile(dirAspectRatio, strcat(strHeightReg,'.png'));

        randomWidth = fullfile(dirAspectRatio, strcat( strWidth,'.png'));
        randomWidthReg = fullfile(dirAspectRatio, strcat(strWidthReg,'.png'));

        randomAspect = fullfile(dirAspectRatio, strcat( strAspect,'.png'));
        randomAspectReg = fullfile(dirAspectRatio, strcat(strAspectReg,'.png'));

        %Get the random samples
        RandomMorphMontage(heightOut, sampleSize1, strHeight, baseDir, randomHeight)
        RandomMorphMontage(heightReg, sampleSize1, strHeightReg, baseDir, randomHeightReg)

        RandomMorphMontage(widthOut, sampleSize1, strWidth, baseDir, randomWidth)
        RandomMorphMontage(widthReg, sampleSize1, strWidthReg, baseDir, randomWidthReg)

        RandomMorphMontage(aspectOut, sampleSize1, strAspect, baseDir, randomAspect)
        RandomMorphMontage(aspectReg, sampleSize1, strAspectReg, baseDir, randomAspectReg)
    end
end
%%
% Remove RBCs based on the generated random samples from the bbox analysis
%Define RBC morphology label order
rbcLabels = {'D', 'E1', 'E2', 'E3', 'SE', 'S', 'ST'};
%Create a table for cleaned data
cellTableNoOddBbox = cellTableNoDups;
%Define the sample sizes
sampleSize1 = 1000-8;
for uu = rbcLabels
    %Create the subset table based on morphology
    subset = cellTableNoDups( (cellTableNoDups.Label == uu), :);

    %Get morphology specific heights, widths, and aspect ratios
    morphHeight = double(table2array(subset(:, "Height")));
    morphWidth = double(table2array(subset(:, "Width")));
    morphAspect = double(table2array(subset(:, "Aspect Ratio")));

    % Examine bboxes with pixel
    if strcmp(uu,'D')
        numSDHeight = 4;
        numSDWidth = 4;
        numSDAspectSmall = 4;
        numSDAspectBig = 4;
    elseif strcmp(uu,'E1')
        numSDHeight = 1;
        numSDWidth = 1;
        numSDAspectSmall = 2;
        numSDAspectBig = 2;
    elseif strcmp(uu,'E2')
        numSDHeight = 1;
        numSDWidth = 1;
        numSDAspectSmall = 2;
        numSDAspectBig = 2;
    elseif strcmp(uu,'E3')
        numSDHeight = 3;
        numSDWidth = 3;
        numSDAspectSmall = 3;
        numSDAspectBig = 3;
    elseif strcmp(uu,'SE')
        numSDHeight = 3;
        numSDWidth = 3;
        numSDAspectSmall = 6;
        numSDAspectBig = 6;
    elseif strcmp(uu,'S')
        numSDHeight = 3;
        numSDWidth = 3;
        numSDAspectSmall = 6;
        numSDAspectBig = 6;
    elseif strcmp(uu,'ST')
        numSDHeight = 1;
        numSDWidth = 2;
        numSDAspectSmall = 2;
        numSDAspectBig = 2;
    end

    %Define too small & too big for height, width, and aspect ratio
    tooSmallHeight = mean(morphHeight)-(numSDHeight*std(morphHeight));
    tooSmallWidth = mean(morphWidth)-(numSDWidth*std(morphWidth));
    tooSmallAspect = mean(morphAspect)-(numSDAspectSmall*std(morphAspect));
    tooBigAspect = mean(morphAspect)+(numSDAspectBig*std(morphAspect));
    
    %Remove the height, width, and aspect ratio bbox outliers
    cellTableNoOddBbox((cellTableNoOddBbox.Label == uu) & (cellTableNoOddBbox.("Height")<tooSmallHeight), :) = [];
    cellTableNoOddBbox((cellTableNoOddBbox.Label == uu) & (cellTableNoOddBbox.("Width")<tooSmallWidth), :) = [];
    cellTableNoOddBbox(((cellTableNoOddBbox.Label == uu) & (cellTableNoOddBbox.("Aspect Ratio")>tooBigAspect)) ...
        | ((cellTableNoOddBbox.Label == uu) & (cellTableNoOddBbox.("Aspect Ratio")<tooSmallAspect)), :) = [];
    
     %Define the output file for the clean random sample
     strFixed = strcat(uu, " - No Odd Bbox (n = ", num2str(sampleSize1),")");
     randomFix = fullfile(dirAspectRatio, strcat( strFixed,'.png'));
     %Generate a random sample of what is fixed
     RandomMorphMontage(cellTableNoOddBbox(cellTableNoOddBbox.Label == uu,:), sampleSize1, strFixed, baseDir, randomFix);
end
%% Analyze each morphology class by average diameter outliers

%Define the sample size
sampleSize2 = 306;

%Iterate through RBC labels to examine what various standard deviation
%settings yield
for uu = rbcLabels
    %Create the subset table based on morphology
    subset = cellTableNoOddBbox( (cellTableNoOddBbox.Label == uu), :);

    %Get morphology specific average diameter
    morphAvgDia = double(table2array(subset(:, "Average Diameter")));

    for numSD = 1:1:5

        %Define Output name for random samples
        strOutSmall = strcat(uu, " - ",num2str(numSD)," SD Too Small Outliers (n = ",num2str(sampleSize2),")");
        strOutBig = strcat(uu, " - ",num2str(numSD)," SD Too Big Outliers (n = ",num2str(sampleSize2),")");

        %Define too small & too big average diameter
        tooSmall = mean(morphAvgDia)-(numSD*std(morphAvgDia));
        tooBig = mean(morphAvgDia)+(numSD*std(morphAvgDia));

        %Get the subsets of the subsets
        outSmall = subset(subset.("Average Diameter")<tooSmall, :);
        outBig = subset(subset.("Average Diameter")>=tooBig, :);

        %Export a random sample of outliers
        exportSmallOutliers = fullfile(dirOutliers, strcat(strOutSmall,".png"));
        exportBigOutliers = fullfile(dirOutliers, strcat(strOutBig,".png"));
        RandomMorphMontage(outSmall, sampleSize2, strOutSmall, baseDir, exportSmallOutliers)
        RandomMorphMontage(outBig, sampleSize2, strOutBig, baseDir, exportBigOutliers)
        
    end
end

%% Remove Outliers from each morphology type depending on random sample results
%Create a table for cleaned data
cellTableClean = cellTableNoOddBbox(1,:);
%Define the sample sizes
sampleSize1 = 100;
sampleSize2 = 306;
%Define RBC morphology label order
rbcLabels = {'D', 'E1', 'E2', 'E3', 'SE', 'S', 'ST'};
%Iterate through RBC labels
for uu = rbcLabels
    %Define Output name for random samplies
    strNotOut = strcat(uu, " - Not Outliers (n = ",num2str(sampleSize2),")");
    strMedian = strcat(uu, " - Median (n = ",num2str(sampleSize1),")");
    strMean = strcat(uu, " - Mean (n = ",num2str(sampleSize1),")");
    %Create the subset table based on morphology
    subset = cellTableNoOddBbox( (cellTableNoOddBbox.Label == uu), :);
    %Get the average diameter for the morphology type
    AvgDiameter = table2array(subset(:, 'Average Diameter'));
    %Set standard deviation distance from the mean depending on morphology
    if strcmp(uu,'D') %% Random sample shows outliers are not for std = 3
        numSDBig = 4;
        numSDSmall = 3;
    elseif strcmp(uu,'E1')
        numSDBig = 3;
        numSDSmall = 3;
    elseif strcmp(uu,'E2')
        numSDBig = 3;
        numSDSmall = 3;
    elseif strcmp(uu,'E3')
        numSDBig = 3;
        numSDSmall = 3;
    elseif strcmp(uu,'SE')
        numSDBig = 5;
        numSDSmall = 4;
    elseif strcmp(uu,'S')
        numSDBig = 2;
        numSDSmall = 3;
    elseif strcmp(uu,'ST') 
        numSDBig = 3;
        numSDSmall = 2;
    end

    tooBig = mean(AvgDiameter)+(numSDBig*std(AvgDiameter));
    tooSmall = mean(AvgDiameter)-(numSDSmall*std(AvgDiameter));
    meanOneSDBig = mean(AvgDiameter)+(1*std(AvgDiameter));
    meanOneSDSmall = mean(AvgDiameter)-(1*std(AvgDiameter));
    

    %Get table of outliers and non-outliers
    notOutliers = subset((subset.("Average Diameter")>=tooSmall) & (subset.("Average Diameter")<=tooBig), :);
    medianRBCs = subset(subset.("Average Diameter") == median(AvgDiameter), :);
    meanRBCs = subset((subset.("Average Diameter")>=meanOneSDSmall) & (subset.("Average Diameter")<=meanOneSDBig), :);

    %Export a random sample of non-outliers
    exportNotOutliers = fullfile(dirNotOutliers, strcat(strNotOut,".png"));
    RandomMorphMontage(notOutliers, sampleSize2, strNotOut, baseDir, exportNotOutliers)

    exportMedian = fullfile(dirMedians, strcat(strMedian,".png"));
    RandomMorphMontage(medianRBCs, sampleSize1, strMedian, baseDir, exportMedian)

    exportMean = fullfile(dirMeans, strcat(strMean,".png"));
    RandomMorphMontage(meanRBCs, sampleSize1, strMean, baseDir, exportMean)
 
    %Add non-outlier rows to the new table
    cellTableClean = [cellTableClean; notOutliers];
end

%Export the clean cell table to the base import directory
baseFileName = strcat("cellTableClean",".mat");
cellFullFileName = fullfile(baseDir, baseFileName);

save(cellFullFileName,"cellTableClean");

%% Analyze the cleaned data via boxplots and normality tests
%Load the clean data
baseFileName = strcat("cellTableClean",".mat");
cellFullFileName = fullfile(baseDir, baseFileName);
load(cellFullFileName,"cellTableClean");

%Get another boxplot of the cell morphology diameters and save it
boxplotFig2 = figure;
boxplot(cellTableClean.("Average Diameter"),cellTableClean.Label, 'GroupOrder', rbcLabels);
title('Cleaned Box plot: Average Diameter by Morphology Type')
xlabel('Morphology Type')
ylabel('Average RBC Diameter (\mum)')

%Create the file name for the box plot
boxplotExport = fullfile(dirExport, "CleanedAverageDiameterBoxplot.png");

%Export the figure to the Data Analysis Folder
saveas(boxplotFig2, boxplotExport);

%Test for normality again
AverageDiameterNormalityAnalysis(cellTableClean,dirNormalityClean)
%% Analyze the morphology diameter medians & means for statistical significance and effect size
%Get each morphology average diameter into an array
D_avgDiameter = table2array(cellTableClean(cellTableClean.Label == 'D', 'Average Diameter'));
E1_avgDiameter = table2array(cellTableClean(cellTableClean.Label == 'E1', 'Average Diameter'));
E2_avgDiameter = table2array(cellTableClean(cellTableClean.Label == 'E2', 'Average Diameter'));
E3_avgDiameter = table2array(cellTableClean(cellTableClean.Label == 'E3', 'Average Diameter'));
SE_avgDiameter = table2array(cellTableClean(cellTableClean.Label == 'SE', 'Average Diameter'));
S_avgDiameter = table2array(cellTableClean(cellTableClean.Label == 'S', 'Average Diameter'));
ST_avgDiameter = table2array(cellTableClean(cellTableClean.Label == 'ST', 'Average Diameter'));

%Test the medians
%To make multiple comparisons of the medians, we use the the Kruskal-Wallis test
[pKW,tblKW,statsKW] = kruskalwallis(cellTableClean.("Average Diameter"),cellTableClean.Label);
%Compare the morphologies individually
[c,m,~,nms] = multcompare(statsKW);
%Make a table of the compared groups and the associated p-value
KWResults = table(nms(c(:, 1)), nms(c(:, 2)), c(:, [6]), 'VariableNames',{'Category 1', 'Category 2', 'p-value'});
%Write the anova results to a file
KWExport = fullfile(dirExport,'cleaned-Kruskal-Wallis-Results.mat');
save(KWExport,"KWResults")

% Now, test the mean via a two-sample t-test for each morphology class
% Also, get the effect size (cohen d and common lanage effect size)
%Combine double vectors into a cell array
x = {D_avgDiameter,E1_avgDiameter,E2_avgDiameter,E3_avgDiameter,SE_avgDiameter,S_avgDiameter,ST_avgDiameter};
%Define the order of the groups
groups = {'D', 'E1', 'E2', 'E3', 'SE', 'S', 'ST'};

% Get the groups count
k = numel(groups);

% Calculate the number of tests
K = (k*(k-1))/2;

% Set Alpha
alphaUnadj = 0.05;

% Ajust Alpha with Bonferroni
alphaAdj = alphaUnadj/K;

% Create an empty table for the results
variable_names_types = [...
    ["Group 1", "categorical"]; ...
    ["Group 2", "categorical"]; ...
    ["Sample Size", "double"]; ...
    ["Unadjusted T Stat", "double"]; ...
    ["Adjusted T Stat", "double"]; ...
    ["df", "double"]; ...
    ["p-unadj.", "double"]; ...
    ["p-adj.", "double"]; ...
    ["p (Bootstrap t-Test)", "double"]; ...
    ["p (Median Bootstrap Test)", "double"]; ...
    ["Unadjusted Mean Diff 95% CI", "double"]; ...
    ["Adjusted Mean Diff 95% CI", "double"]; ...
    ["Mean Difference (A-B)", "double"]; ...
    ["Average Standard Deviation", "double"]; ...
    ["Cohen's d", "double"]; ...
    ];

ttestResults = table('Size',[0,size(variable_names_types,1)],...
    'VariableNames', variable_names_types(:,1),...
    'VariableTypes', variable_names_types(:,2));

%Iterate through each category combination
for i = 1:1:k-1
    for j = i+1:1:k

        %Get the groups to compare
        cat1 = groups(i);
        cat2 = groups(j);
        %Define observations
        obs1 = x{:, i};
        obs2 = x{:,j};
        %Compute their mean, the mean difference, and sample sizes
        obs1Mean = mean(obs1);
        obs2Mean = mean(obs2);
        meanDiffAB = obs1Mean - obs2Mean;
        meanDiffBA = obs2Mean - obs1Mean;
        n = [numel(obs1), numel(obs2)];

        %Use the two-sample t-test for unequal variances to get unadjusted
        %& adjusted p-values, confidence intervals, and other statistics
        [~,pUnadj,ciUnadj,statsUnadj] = ttest2(obs1, obs2,'Vartype','unequal', 'alpha', alphaUnadj);
        [~,pAdj,ciAdj,statsAdj] = ttest2(obs1, obs2,'Vartype','unequal', 'alpha', alphaAdj);

        %Use bootstrap hypothesis testing to validate significance
        %Set the number of replicates
        replicates = 10000;
        %Validate t-test with a studentized bootstrap test
        [~,~, tBootP] = StudentBootstrapTest(obs1,obs2, replicates);
        %Validate Kruskal-Wallis test with a median bootstrap test
        [~, ~, medianBootP] = simpleBootstrapHypothesisTest(obs1,obs2, @(x)median(x), replicates);

        %Calculate Cohen's d using an averaged deviation
        sdAvg = sqrt(((std(obs1)^2)+(std(obs2)^2))/2);
        effectSize = meanDiffAB/sdAvg;


        %Add the results to the table
        newResults = {cat1, cat2, n, statsUnadj.tstat, statsAdj.tstat, statsUnadj.df, pUnadj, pAdj, tBootP,medianBootP, ciUnadj',ciAdj',meanDiffAB, sdAvg, effectSize};
        ttestResults = [ttestResults;newResults];
    end
end
%Write the ttest results to excel file
ttestResultsExport = fullfile(dirExport,'ttestResults.xls');
writetable(ttestResults,ttestResultsExport, 'FileType','spreadsheet');
%% Plot the Average Diameters by Morphology Type

%Plot the distributions for comparison to a previous study
%Get the histogram counts of each morphology diameter
%Get the histogram counts of each morphology diameter
[Dn,xout] = hist(D_avgDiameter,[4:.1:10]);%D
[E1n,xout] = hist(E1_avgDiameter,[4:.1:10]);%EI
[E2n,xout] = hist(E2_avgDiameter,[4:.1:10]);%EIIE
[E3n,xout] = hist(E3_avgDiameter,[4:.1:10]);%EIII
[SEn,xout] = hist(SE_avgDiameter,[4:.1:10]);%SE
[STn,xout] = hist(ST_avgDiameter,[4:.1:10]);%ST
[Sn,xout] = hist(S_avgDiameter,[4:.1:10]);%S

plotFig = figure;
hold on
plot(xout,Dn/sum(Dn),'.-r');
plot(xout,E1n/sum(E1n),'o-g');
plot(xout,E2n/sum(E2n),'v-b');
plot(xout,E3n/sum(E3n),'d-m');
plot(xout,SEn/sum(SEn),'s-k');
plot(xout,STn/sum(STn),'s-y');
plot(xout,Sn/sum(Sn),'*-c');

ylim([0 .16]);
xlim([4.5 9.5]);
xlabel('Average RBC Diameter (\mum)')
ylabel('Percent of Total RBCs by Morphology Class')
title('Average Diameter Distribution by Morphology Class')
legend('Discocyte','Echinocyte 1','Echinocyte 2','Echinocyte 3','Sphero-Echinocyte','Stomatocyte','Spherocyte','Location','NorthEast')

%Create the file name for the plot
plotExport = fullfile(dirExport, "AverageDiameterPlot.m");

%Export the figure to the Data Analysis Folder
saveas(plotFig, plotExport);
%%
% Get the descriptive statistics for each distribution 
means = [mean(D_avgDiameter), mean(E1_avgDiameter), mean(E2_avgDiameter), ...
    mean(E3_avgDiameter),mean(SE_avgDiameter), mean(S_avgDiameter), mean(ST_avgDiameter),];

stds = [std(D_avgDiameter), std(E1_avgDiameter), std(E2_avgDiameter), ...
    std(E3_avgDiameter),std(SE_avgDiameter), std(S_avgDiameter), std(ST_avgDiameter)];

meanMADs = [mad(D_avgDiameter), mad(E1_avgDiameter), mad(E2_avgDiameter), ...
    mad(E3_avgDiameter),mad(SE_avgDiameter), mad(S_avgDiameter), mad(ST_avgDiameter)];

medians = [median(D_avgDiameter), median(E1_avgDiameter), median(E2_avgDiameter), ...
    median(E3_avgDiameter),median(SE_avgDiameter), median(S_avgDiameter), median(ST_avgDiameter)];

medianMADs = [mad(D_avgDiameter, 1), mad(E1_avgDiameter, 1), mad(E2_avgDiameter, 1), ...
    mad(E3_avgDiameter, 1),mad(SE_avgDiameter, 1), mad(S_avgDiameter, 1), mad(ST_avgDiameter, 1)];

iqrs = [iqr(D_avgDiameter), iqr(E1_avgDiameter), iqr(E2_avgDiameter), ...
    iqr(E3_avgDiameter),iqr(SE_avgDiameter), iqr(S_avgDiameter), iqr(ST_avgDiameter)];

ranges = [range(D_avgDiameter), range(E1_avgDiameter), range(E2_avgDiameter), ...
    range(E3_avgDiameter),range(SE_avgDiameter), range(S_avgDiameter), range(ST_avgDiameter)];

skewes = [skewness(D_avgDiameter), skewness(E1_avgDiameter), skewness(E2_avgDiameter), ...
    skewness(E3_avgDiameter),skewness(SE_avgDiameter), skewness(S_avgDiameter), skewness(ST_avgDiameter)];
 
kurtosises = [kurtosis(D_avgDiameter), kurtosis(E1_avgDiameter), kurtosis(E2_avgDiameter), ...
    kurtosis(E3_avgDiameter),kurtosis(SE_avgDiameter), kurtosis(S_avgDiameter), kurtosis(ST_avgDiameter)];

samples = [numel(D_avgDiameter), numel(E1_avgDiameter), numel(E2_avgDiameter), ...
    numel(E3_avgDiameter),numel(SE_avgDiameter), numel(S_avgDiameter), numel(ST_avgDiameter)];

freqs = (samples./sum(samples))*100;

% Put the descriptive statistics in a table
descrStats = table(...
    rbcLabels',...
    means', ...
    stds', ...
    meanMADs', ...
    medians',  ...
    medianMADs', ...
    iqrs', ...
    ranges', ...
    skewes', ...
    kurtosises', ...
    samples', ...
    freqs', ...
    'VariableNames',{'Morphology','Means','STDs','Mean MADs', 'Medians', 'Median MADs', 'IQRs', 'Ranges', 'Skewness', 'Kurtosis','Sample Size', 'Frequencies'});

%Write the descriptive statistics to a file
descrStatsExport = fullfile(dirExport,'cleanedDescriptiveStats.xls');
writetable(descrStats,descrStatsExport, 'FileType','spreadsheet');
%%
%Get the mean & std confidence intervals the classic way, assumming normality
% Make 95% confidence intervals using the classic formulas for mean & std

alpha = 0.05;
%Mean CI classic
Z = norminv((1-alpha));
SEM = (stds./sqrt(samples));
CI95_Norm_Mean_LCs = means - Z.*SEM;
CI95_Norm_Mean_UCs = means + Z.*SEM;
%STD CI classic
dF = (samples-1);
chiLCs = chi2inv(1-(alpha/2),dF);
chiUCs = chi2inv((alpha/2),dF);
CI95_Norm_STD_LCs = stds.*sqrt(dF./chiLCs);
CI95_Norm_STD_UCs = stds.*sqrt(dF./chiUCs);

% Make 95% confidence interval using bootstrap for mean, std, median, and iqr
bootFunc = @(x)[mean(x) std(x) median(x) iqr(x)];
replicates = 10000; %10,000 replicates is typical for publication quality 
[ciD,bootstatD] = bootci(replicates,{bootFunc,D_avgDiameter},'Alpha', alpha);
[ciE1,bootstatE1] = bootci(replicates,{bootFunc,E1_avgDiameter},'Alpha', alpha);
[ciE2,bootstatE2] = bootci(replicates,{bootFunc,E2_avgDiameter},'Alpha', alpha);
[ciE3,bootstatE3] = bootci(replicates,{bootFunc,E3_avgDiameter},'Alpha', alpha);
[ciSE,bootstatSE] = bootci(replicates,{bootFunc,SE_avgDiameter},'Alpha', alpha);
[ciS,bootstatS] = bootci(replicates,{bootFunc,S_avgDiameter},'Alpha', alpha);
[ciST,bootstatST] = bootci(replicates,{bootFunc,ST_avgDiameter},'Alpha', alpha);

% Separate the data neatly into appropriate variables
meanBootstats = [bootstatD(:,1),bootstatE1(:,1), bootstatE2(:,1), bootstatE3(:,1), bootstatSE(:,1),bootstatS(:,1),bootstatST(:,1)]';
stdBootstats = [bootstatD(:,2),bootstatE1(:,2), bootstatE2(:,2), bootstatE3(:,2), bootstatSE(:,2),bootstatS(:,2),bootstatST(:,2)]';

medianBootstats = [bootstatD(:,3),bootstatE1(:,3), bootstatE2(:,3), bootstatE3(:,3), bootstatSE(:,3),bootstatS(:,3),bootstatST(:,3)]';
iqrBootstats = [bootstatD(:,4),bootstatE1(:,4), bootstatE2(:,4), bootstatE3(:,4), bootstatSE(:,4),bootstatS(:,4),bootstatST(:,4)]';

CI95_Bootstrap_Mean_LCs = [ciD(1,1); ciE1(1,1); ciE2(1,1); ciE3(1,1); ciSE(1,1); ciS(1,1); ciST(1,1)];
CI95_Bootstrap_Mean_UCs = [ciD(2,1); ciE1(2,1); ciE2(2,1); ciE3(2,1); ciSE(2,1); ciS(2,1); ciST(2,1)];
CI95_Bootstrap_STD_LCs = [ciD(1,2); ciE1(1,2); ciE2(1,2); ciE3(1,2); ciSE(1,2); ciS(1,2); ciST(1,2)];
CI95_Bootstrap_STD_UCs = [ciD(2,2); ciE1(2,2); ciE2(2,2); ciE3(2,2); ciSE(2,2); ciS(2,2); ciST(2,2)];

CI95_Bootstrap_Med_LCs = [ciD(1,3); ciE1(1,3); ciE2(1,3); ciE3(1,3); ciSE(1,3); ciS(1,3); ciST(1,3)];
CI95_Bootstrap_Med_UCs = [ciD(2,3); ciE1(2,3); ciE2(2,3); ciE3(2,3); ciSE(2,3); ciS(2,3); ciST(2,3)];
CI95_Bootstrap_IQR_LCs = [ciD(1,4); ciE1(1,4); ciE2(1,4); ciE3(1,4); ciSE(1,4); ciS(1,4); ciST(1,4)];
CI95_Bootstrap_IQR_UCs = [ciD(2,4); ciE1(2,4); ciE2(2,4); ciE3(2,4); ciSE(2,4); ciS(2,4); ciST(2,4)];

%% Put 95% confidence interval data into a table
% Create the confidence table
Confidences = table(...
    rbcLabels',...
    CI95_Norm_Mean_LCs', ...
    CI95_Bootstrap_Mean_LCs, ...
    means', ...
    CI95_Norm_Mean_UCs', ...
    CI95_Bootstrap_Mean_UCs, ...
    meanBootstats,...
    CI95_Norm_STD_LCs',  ...
    CI95_Bootstrap_STD_LCs, ...
    stds', ...
    CI95_Norm_STD_UCs', ...
    CI95_Bootstrap_STD_UCs, ...
    stdBootstats,...
    CI95_Bootstrap_Med_LCs, ...
    medians', ...
    CI95_Bootstrap_Med_UCs, ...
    medianBootstats,...
    CI95_Bootstrap_IQR_LCs, ...
    iqrs', ...
    CI95_Bootstrap_IQR_UCs, ...
    iqrBootstats,...
    'VariableNames',{'Morphology', ...
    'Mean LC Norm', ...
    'Mean LC Bootstrap', ...
    'Mean', 'Mean UC Norm', ...
    'Mean UC Bootstrap', ...
    'Bootstats (Mean)', ...
    'STD LC Norm', ...
    'STD LC Bootstrap', ...
    'STD','STD UC Norm', ...
    'STD UC Bootstrap', ...
    'Bootstats (STD)' ...
    'Median LC Bootstrap', ...
    'Median', ...
    'Median UC Bootstrap', ...
    'Bootstats (Median)', ...
    'IQR LC Bootstrap', ...
    'IQR', ...
    'IQR UC Bootstrap', ...
    'Bootstats (IQR)' ...
    });

%Write the table to a file
ciStatsExport = fullfile(dirExport,'ConfidenceIntervalStats.mat');
save(ciStatsExport,'Confidences');

%plot each to confirm the validity of the 95% confidence intervals
AverageDiameterBootstrapAnalysis(Confidences(strcmp(Confidences.("Morphology"),'D'), :),dirBootstrap)
AverageDiameterBootstrapAnalysis(Confidences(strcmp(Confidences.("Morphology"),'E1'), :),dirBootstrap)
AverageDiameterBootstrapAnalysis(Confidences(strcmp(Confidences.("Morphology"),'E2'), :),dirBootstrap)
AverageDiameterBootstrapAnalysis(Confidences(strcmp(Confidences.("Morphology"),'E3'), :),dirBootstrap)
AverageDiameterBootstrapAnalysis(Confidences(strcmp(Confidences.("Morphology"),'SE'), :),dirBootstrap)
AverageDiameterBootstrapAnalysis(Confidences(strcmp(Confidences.("Morphology"),'S'), :),dirBootstrap)
AverageDiameterBootstrapAnalysis(Confidences(strcmp(Confidences.("Morphology"),'ST'), :),dirBootstrap)


%%
% Calculate bootstrap effect sizes using bootstrap mean and std bootstats

%Load table
load(fullfile(dirExport,'ConfidenceIntervalStats.mat'),'Confidences');
% Set boot stats
meanBootstats = Confidences.('Bootstats (Mean)');
stdBootstats = Confidences.('Bootstats (STD)');

% Set Alpha
alphaUnadj = 0.05;
%Define the order of the groups in the bootstat vectors
groups = {'D', 'E1', 'E2', 'E3', 'SE', 'S', 'ST'};

% Get the groups count
k = numel(groups);

% Calculate the number of tests
K = (k*(k-1))/2;

% Set Alpha
alphaUnadj = 0.05;

% Adjust Alpha with Bonferroni
alphaAdj = alphaUnadj/K;

% Create an empty table for the results
variable_names_types = [...
    ["Group 1", "categorical"]; ...
    ["Group 2", "categorical"]; ...
    ["Alpha-unadj.", "double"]; ...
    ["Alpha-adj.", "double"]; ...
    ["Adjusted 95% LC CLES P(A>B) t-method", "double"]; ...
    ["Observed P(A>B)", "double"]; ...
    ["Adjusted 95% UC CLES P(A>B) t-method", "double"]; ...
    ["Adjusted 95% LC CLES P(B>A) t-method", "double"]; ...
    ["Observed P(B>A)", "double"]; ...
    ["Adjusted 95% UC CLES P(B>A) t-method", "double"]; ...
    ["Adjusted 95% LC CLES P(A>B) Prc-method", "double"]; ...
    ["Adjusted 95% UC CLES P(A>B) Prc-method", "double"]; ...
    ["Adjusted 95% LC CLES P(B>A) Prc-method", "double"]; ...
    ["Adjusted 95% UC CLES P(B>A) Prc-method", "double"]; ...
    ];

effectResults = table('Size',[0,size(variable_names_types,1)],...
    'VariableNames', variable_names_types(:,1),...
    'VariableTypes', variable_names_types(:,2));
count = 0;
%Iterate through each category combination
for i = 1:1:k-1
    for j = i+1:1:k
        count = count+1;
        %Get the groups to compare
        cat1 = groups(i);
        cat2 = groups(j);

        %Define observations
        obs1 = x{:, i};
        obs2 = x{:,j};

        %Define Bootstats
        obs1MeanBoot = meanBootstats(i,:);
        obs2MeanBoot = meanBootstats(j,:);
        obs1SDBoot = stdBootstats(i,:);
        obs2SDBoot = stdBootstats(j,:);

        %Compute the mean difference and combined standard deviation
        obs1Mean = mean(obs1);
        obs2Mean = mean(obs2);
        meanDiffAB = obs1Mean - obs2Mean;
        meanDiffBA = obs2Mean - obs1Mean;
        sdComb = sqrt(((std(obs1)^2)+(std(obs2)^2)));

        meanDiffABBoot = obs1MeanBoot - obs2MeanBoot;
        meanDiffBABoot = obs2MeanBoot - obs1MeanBoot;
        sdCombBoot = sqrt(((obs1SDBoot.^2)+(obs2SDBoot.^2)));

        %Calculate the coomon language effect size
        clesAB = normcdf(0,meanDiffAB,sdComb, 'upper');
        clesBA = normcdf(0,meanDiffBA,sdComb,'upper');

        clesABBoot = normcdf(0,meanDiffABBoot,sdCombBoot, 'upper');
        clesBABoot = normcdf(0,meanDiffBABoot,sdCombBoot,'upper');

        %Get the 95% Confidence interval through the percentile method and t distribution
        clesAB95Prc = prctile(clesABBoot,[((alpha/2)*100), ((1-(alpha/2))*100)]); %Percentile method
        clesBA95Prc = prctile(clesBABoot,[((alpha/2)*100), ((1-(alpha/2))*100)]); %Percentile method
        T_AB = tinv((1-alphaAdj), numel(clesABBoot)-1);  % t-distribution method
        T_BA = tinv((1-alphaAdj), numel(clesBABoot)-1);  % t-distribution method
        SEM_AB = (std(clesABBoot)./sqrt(numel(clesABBoot))); % t-distribution method
        SEM_BA = (std(clesBABoot)./sqrt(numel(clesBABoot))); % t-distribution method
        clesAB95 = [mean(clesABBoot) - T_AB.*SEM_AB,  mean(clesABBoot) + T_AB.*SEM_AB]; % t-distribution method
        clesBA95 = [mean(clesBABoot) - T_BA.*SEM_BA,  mean(clesBABoot) + T_AB.*SEM_BA]; % t-distribution method
      

        %Add the results to the table
        newResults = {cat1, cat2, alphaUnadj, alphaAdj, clesAB95(1),clesAB,clesAB95(2), clesBA95(1),clesBA,clesBA95(2), clesAB95Prc(1), clesAB95Prc(2), clesBA95Prc(1), clesBA95Prc(2)};
        effectResults = [effectResults;newResults];
        
        dataNames = {'Bootstrap', 'Sample','','95% CI (T-Bootstrap)', '', '95% CI (Prc-Bootstrap)'};
        %Plot the results
        Fig(count) = figure('Position', [3.666666666666667,41.666666666666664,1682,839.3333333333333]);
        subplot(1, 2, 1)
        histogram(clesABBoot.*100)
        xline(clesAB*100,'r', 'LineWidth',2)
        xline(clesAB95(1)*100,':c', 'LineWidth',2)
        xline(clesAB95(2)*100,':c', 'LineWidth',2)
        xline(clesAB95Prc(1)*100,':m', 'LineWidth',2)
        xline(clesAB95Prc(2)*100,':m', 'LineWidth',2)
        title(strcat("P(", cat1, " > ", cat2, ")_{Average Diameter}"));
        xlabel('Percentage Likelihood [%]')
        ylabel('Counts')
        legend(dataNames,'Location','northeast')

        subplot(1, 2, 2)
        histogram(clesBABoot.*100)
        xline(clesBA*100,'r', 'LineWidth',2)
        xline(clesBA95(1)*100,':c', 'LineWidth',2)
        xline(clesBA95(2)*100,':c', 'LineWidth',2)
        xline(clesBA95Prc(1)*100,':m', 'LineWidth',2)
        xline(clesBA95Prc(2)*100,':m', 'LineWidth',2)
        title(strcat("P(", cat2, " > ", cat1, ")_{Average Diameter}"));
        xlabel('Percentage Likelihood [%]')
        ylabel('Counts')
        legend(dataNames,'Location','northeast')
        
        dirExport1 = fullfile(dirBootstrap, strcat("Effect_Size_",cat1,"_VS_",cat2,".png"));
        saveas(Fig(count), dirExport1);
    end
end

%Write the effect size statistics to a file
effectStatsExport = fullfile(dirExport,'cleanedEffectSize.xls');
writetable(effectResults,effectStatsExport, 'FileType','spreadsheet');

%% Put the effect size data into a matrix, plot, and save

%Define the rbc labels 
groups = {'D', 'E1', 'E2', 'E3', 'SE', 'S', 'ST'};
%Generate a blank NaN matrix to store effect sizes in
effectMatrix = NaN(7, 7);
%Iterate through the length of the morphology classes, minus 1
for i = 1:1:length(groups)-1
    %Iterate through the morphology classes, starting with the next class
    %and ending with the last class. We want to get all comparisons 
    for j = i+1:1:length(groups)
        %From the table, place the Observed P(A>B) in the ith row and jth column element
        effectMatrix(i, j) = table2array(effectResults((effectResults.("Group 1") == groups{i})&(effectResults.("Group 2") == groups{j}), "Observed P(A>B)"));
        %From the table, place the Observed P(B>A) in the jth row and ith column
        effectMatrix(j, i) = table2array(effectResults((effectResults.("Group 1") == groups{i})&(effectResults.("Group 2") == groups{j}), "Observed P(B>A)"));
    end

end

%Plot the effect size matrix as a heat map
figHM = figure('Position', [573,135.6666666666667,889.3333333333333,722.3333333333333]);
hm = heatmap( groups, groups, effectMatrix*100, 'Colormap',cool);
hm.Title = "Common Language Effect Size Matrix: P(A>B)";
hm.XLabel = 'Group B';
hm.YLabel = 'Group A';
hm.ColorbarVisible = 'off';
hm.CellLabelFormat = '%.2f%%';

dirExportEffectSize = fullfile(dirExport, "Effect_Size_Matrix.m");
saveas(hm, dirExportEffectSize);

%% Plot the mean average diameter 95% CIs for each morphology class
dE1 = [1 2];
e2ST = [3 7];
sSE = [5 6];

xDE1 = categorical(groups(dE1));
yDE1 = means(dE1);
negDE1 = abs(CI95_Bootstrap_Mean_LCs(dE1)'- yDE1);
posDE1 = abs(CI95_Bootstrap_Mean_LCs(dE1)'- yDE1);

xE2ST = categorical(groups(e2ST));
yE2ST = means(e2ST);
negE2ST = abs(CI95_Bootstrap_Mean_LCs(e2ST)'- yE2ST);
posE2ST = abs(CI95_Bootstrap_Mean_LCs(e2ST)'- yE2ST);

xSSE = categorical(groups(sSE));
ySSE = means(sSE);
negSSE = abs(CI95_Bootstrap_Mean_LCs(sSE)'- ySSE);
posSSE = abs(CI95_Bootstrap_Mean_LCs(sSE)'- ySSE);

Fig1 = figure('Position', [100, 100, 1380, 720], 'PaperPositionMode', 'auto'); %Creates initial figure variable
p1 = uipanel('Parent',Fig1,'BorderType','none' ); %creates the panel
p1.Title = 'Mean Average Diameter 95% CIs by Morphology Class';
p1.TitlePosition = 'centertop'; %Sets the super title in the top center position
p1.FontSize = 20; %Sets the font size of the super title
p1.FontWeight = 'bold'; %Sets the font of the super title to bold

subplot(2,3,3,'Parent',p1)
errorbar(yDE1,xDE1,negDE1,posDE1, 'horizontal','ob', 'MarkerSize',1, 'CapSize',10, 'LineWidth', 2)
xline(yDE1,':r', 'LineWidth',2)
xlabel('Average RBC Diameter (\mum)')
ylabel('Morphology Class')
title('D & E1')

subplot(2,3,2,'Parent',p1)
errorbar(yE2ST,xE2ST,negE2ST,posE2ST, 'horizontal','ob','MarkerSize',1, 'CapSize',10, 'LineWidth', 2)
xline(yE2ST,':r', 'LineWidth',2)
xlabel('Average RBC Diameter (\mum)')
ylabel('Morphology Class')
title('E2 & ST')

subplot(2,3,1,'Parent',p1)
errorbar(ySSE,xSSE,negSSE,posSSE, 'horizontal','ob','MarkerSize',1, 'CapSize',10, 'LineWidth', 2)
xline(ySSE,':r', 'LineWidth',2)
xlabel('Average RBC Diameter (\mum)')
ylabel('Morphology Class')
title('S & SE')

subplot(2,3,[4 5 6],'Parent',p1)
errorbar(means,categorical(groups),abs(CI95_Bootstrap_Mean_LCs'-means),abs(CI95_Bootstrap_Mean_UCs'-means), 'horizontal','ob','MarkerSize',1, 'CapSize',10, 'LineWidth', 2)
xline(means,':r', 'LineWidth',2)
xlabel('Average RBC Diameter (\mum)')
ylabel('Morphology Class')
title('All RBC Morphologies')

dirExportConfidencePlot = fullfile(dirExport, "ConfidencePlot.png");
saveas(Fig1, dirExportConfidencePlot);

%% Export the data and cell tables to json format

cellTableClean_JSONName = 'cleanCellTable.json';
dirExportJSONcleanCellTable = fullfile(dirExport, cellTableClean_JSONName);
fid = fopen(dirExportJSONcleanCellTable,'w');
encodedJSON = jsonencode(cellTableClean);
fprintf(fid, encodedJSON);
fclose(fid);
disp('Problem 3 end')
disp('-----------------------------------------------------------')

