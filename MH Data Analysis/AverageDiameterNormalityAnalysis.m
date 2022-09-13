function [] = AverageDiameterNormalityAnalysis(data,dirExport)
% This function is used to analyze the average diameter data with respect to 
% the normality of the distributions. To this end, Normal Probability Plots & Q-Q plots are
% used to reveal how close average diameter data follows a normal distribution.
% It also shows histograms with fitted normal distributions.

% Regarding normal probability plots, "data are plotted against a
% theoretical normal distribution in such a way that the points should 
% form an approximate straight line. Departures from this straight line 
% indicate departures from normality."(NIST, 2022). The same can be said
% for Q-Q plots.


% References
%
% Chambers, J. (1983). Graphical Methods for Data Analysis. Chapman & Hall.
%
% NIST. (2022). Engineering Statistics Handbook: Normal Probability Plot.
%   Retrieved 30 May 2022, from https://www.itl.nist.gov/div898/handbook
%   /eda/section3/normprpl.htm.

%Input:
% data - the cell table with average diamater and associated morphology labels

%Output:
% Normality & QQ-plots 

%Seperate the Data 
D_avgDiameter = table2array(data(data.Label == 'D', 'Average Diameter'));
E1_avgDiameter = table2array(data(data.Label == 'E1', 'Average Diameter'));
E2_avgDiameter = table2array(data(data.Label == 'E2', 'Average Diameter'));
E3_avgDiameter = table2array(data(data.Label == 'E3', 'Average Diameter'));
SE_avgDiameter = table2array(data(data.Label == 'SE', 'Average Diameter'));
S_avgDiameter = table2array(data(data.Label == 'S', 'Average Diameter'));
ST_avgDiameter = table2array(data(data.Label == 'ST', 'Average Diameter'));

%Define export file names
dirExport1 = fullfile(dirExport, "Normal_Probability_Plots_Average_Diameter.png");
dirExport2 = fullfile(dirExport, "Q_Q_Plots_Average_Diameter.png");
dirExport3 = fullfile(dirExport, "Fitted_Histograms_Average_Diameter.png");

% Generate & Save Normal Probability Plots & QQ-Plots for each wash

% Create the super figure for the Normal Probability Plots 
Fig1 = figure('Position', [100, 100, 1280, 720]); %Creates initial figure variable
p1 = uipanel('Parent',Fig1,'BorderType','none' ); %creates the panel
p1.Title = 'Normal Probability Plots: Average Diameter by Morphology';
p1.TitlePosition = 'centertop'; %Sets the super title in the top center position
p1.FontSize = 20; %Sets the font size of the super title
p1.FontWeight = 'bold'; %Sets the font of the super title to bold

subplot(2,4,1,'Parent',p1)
normplot(D_avgDiameter)
title('D')

subplot(2,4,2,'Parent',p1)
normplot(E1_avgDiameter)
title('E1')

subplot(2,4,3,'Parent',p1)
normplot(E2_avgDiameter)
title('E2')

subplot(2,4,4,'Parent',p1)
normplot(E3_avgDiameter)
title('E3')

subplot(2,4,5,'Parent',p1)
normplot(SE_avgDiameter)
title('SE')

subplot(2,4,6,'Parent',p1)
normplot(S_avgDiameter)
title('S')

subplot(2,4,7,'Parent',p1)
normplot(ST_avgDiameter)
title('ST')

%Export the figure to the Data Analysis Folder
saveas(Fig1, dirExport1);


% Create the super figure for the Q-Q Plots 
Fig2 = figure('Position', [100, 100, 1280, 720]); %Creates initial figure variable
p2 = uipanel('Parent',Fig2,'BorderType','none' ); %creates the panel
p2.Title = 'Q-Q Plots: Average Diameter by Morphology';
p2.TitlePosition = 'centertop'; %Sets the super title in the top center position
p2.FontSize = 20; %Sets the font size of the super title
p2.FontWeight = 'bold'; %Sets the font of the super title to bold

subplot(2,4,1,'Parent',p2)
qqplot(D_avgDiameter)
title('D')

subplot(2,4,2,'Parent',p2)
qqplot(E1_avgDiameter)
title('E1')

subplot(2,4,3,'Parent',p2)
qqplot(E2_avgDiameter)
title('E2')

subplot(2,4,4,'Parent',p2)
qqplot(E3_avgDiameter)
title('E3')

subplot(2,4,5,'Parent',p2)
qqplot(SE_avgDiameter)
title('SE')

subplot(2,4,6,'Parent',p2)
qqplot(S_avgDiameter)
title('S')

subplot(2,4,7,'Parent',p2)
qqplot(ST_avgDiameter)
title('ST')

%Export the figure to the Data Analysis Folder
saveas(Fig2, dirExport2);

% Create the super figure for the Q-Q Plots 
Fig3 = figure('Position', [100, 100, 1280, 720]); %Creates initial figure variable
p3 = uipanel('Parent',Fig3,'BorderType','none' ); %creates the panel
p3.Title = 'Fitted Histograms: Average Diameter by Morphology';
p3.TitlePosition = 'centertop'; %Sets the super title in the top center position
p3.FontSize = 20; %Sets the font size of the super title
p3.FontWeight = 'bold'; %Sets the font of the super title to bold

subplot(2,4,1,'Parent',p3)
histfit(D_avgDiameter);
title('D')

subplot(2,4,2,'Parent',p3)
histfit(E1_avgDiameter);
title('E1')

subplot(2,4,3,'Parent',p3)
histfit(E2_avgDiameter);
title('E2')

subplot(2,4,4,'Parent',p3)
histfit(E3_avgDiameter);
title('E3')

subplot(2,4,5,'Parent',p3)
histfit(SE_avgDiameter);
title('SE')

subplot(2,4,6,'Parent',p3)
histfit(S_avgDiameter);
title('S')

subplot(2,4,7,'Parent',p3)
histfit(ST_avgDiameter);
title('ST')

%Export the figure to the Data Analysis Folder
saveas(Fig3, dirExport3);

end