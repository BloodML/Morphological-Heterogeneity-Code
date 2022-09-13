function [] = AverageDiameterBootstrapAnalysis(data,dirExport)
% This function is used to analyze the average diameter data with respect to
% the bootrap confidence intervals and how they compare to the sample mean,
% standard deviation, and the normal confidence interval obtained use the
% classic procedures for normal distributions. Since the data is not
% perfectly normal, we trust bootstrap CIs over the heuristics.



%Input:
% data - the cell table with average diamater and associated morphology labels

%Output:
% Bootstrap 95% confidence interval plots.



%Define export file names
dirExport1 = fullfile(dirExport, strcat("Average_Diameter_Bootstrap_",table2array(data(:,'Morphology')),".png"));

%Seperate the Data
rng('default') % For reproducibility

mainTitle = strcat("Bootstrap Plots: ",table2array(data(:,'Morphology')));
%Mean & STD 
meanLC = table2array(data(:, 'Mean LC Norm'));
AVG = table2array(data(:, 'Mean'));
meanUC = table2array(data(:, 'Mean UC Norm'));
stdLC = table2array(data(:, 'STD LC Norm'));
STD = table2array(data(:, 'STD'));
stdUC = table2array(data(:, 'STD UC Norm'));
meanLCBoot = table2array(data(:, 'Mean LC Bootstrap'));
stdLCBoot = table2array(data(:, 'STD LC Bootstrap'));
meanUCBoot = table2array(data(:, 'Mean UC Bootstrap'));
stdUCBoot = table2array(data(:, 'STD UC Bootstrap'));
meanBootstats = table2array(data(:, 'Bootstats (Mean)'));
stdBootstats = table2array(data(:, 'Bootstats (STD)'));
dataNames1 = {'Bootstrap', 'Sample','', '', '', '95% CI', '95% CI (Bootstrap)'};
dataNames2 = {'Bootstrap', 'Sample','','95% CI','95% CI (Bootstrap)'};

%Median & IQR
MED = table2array(data(:, 'Median'));
IQR = table2array(data(:, 'IQR'));
medLCBoot = table2array(data(:, 'Median LC Bootstrap'));
iqrLCBoot = table2array(data(:, 'IQR LC Bootstrap'));
medUCBoot = table2array(data(:, 'Median UC Bootstrap'));
iqrUCBoot = table2array(data(:, 'IQR UC Bootstrap'));
medBootstats = table2array(data(:, 'Bootstats (Median)'));
iqrBootstats = table2array(data(:, 'Bootstats (IQR)'));
dataNames3 = {'Bootstrap', 'Sample','', '', '', '95% CI (Bootstrap)'};
dataNames4 = {'Bootstrap', 'Sample','','95% CI (Bootstrap)'};
disp(strcat(num2str(iqrLCBoot), " ",num2str(iqrUCBoot)));

Fig1 = figure('Position', [3.666666666666667,41.666666666666664,1682,839.3333333333333]); %Creates initial figure variable
p1 = uipanel('Parent',Fig1,'BorderType','none' ); %creates the panel
p1.Title = mainTitle;
p1.TitlePosition = 'centertop'; %Sets the super title in the top center position
p1.FontSize = 20; %Sets the font size of the super title
p1.FontWeight = 'bold'; %Sets the font of the super title to bold

subplot(2,3,1, 'Parent',p1)
hold on
plot(meanBootstats,stdBootstats,'o')
plot(AVG, STD, 'Xr', 'LineWidth', 3, 'MarkerSize', 10)
hold off
xline(meanLC,'--m','LineWidth',2)
xline(meanUC,'--m','LineWidth',2)


yline(stdLC,'--m','LineWidth',2)
yline(stdUC,'--m','LineWidth',2)

xline(meanLCBoot,':','LineWidth',2)
xline(meanUCBoot,':','LineWidth',2)
yline(stdLCBoot,':','LineWidth',2)
yline(stdUCBoot,':','LineWidth',2)
xlabel('Mean (\mum)')
ylabel('Standard Deviation (\mum)')
title("Bootstrap Mean vs. STD Scatterplot");
legend(dataNames1,'Location','northeast')

subplot(2,3,2, 'Parent',p1)
histogram(meanBootstats)
xline(AVG,'r', 'LineWidth',2)
xline(meanLC,'--m', 'LineWidth',2)
xline(meanUC,'--m', 'LineWidth',2)
xline(meanLCBoot,':', 'LineWidth',2)
xline(meanUCBoot,':', 'LineWidth',2)
title("Bootstrap Mean Histogram");
xlabel('Mean (\mum)')
ylabel('Counts')
legend(dataNames2,'Location','northeast')

subplot(2,3,3, 'Parent',p1)
histogram(stdBootstats)
xline(STD,'r', 'LineWidth',2)
xline(stdLC,'--m', 'LineWidth',2)
xline(stdUC,'--m', 'LineWidth',2)
xline(stdLCBoot,':', 'LineWidth',2)
xline(stdUCBoot,':', 'LineWidth',2)
title("Bootstrap Standard Deviation Histogram");
xlabel('Standard Deviation (\mum)')
ylabel('Counts')
legend(dataNames2,'Location','northeast')

subplot(2,3,4, 'Parent',p1)
hold on
plot(medBootstats,iqrBootstats,'o')
plot(MED, IQR, 'Xr', 'LineWidth', 3, 'MarkerSize', 10)
hold off

xline(medLCBoot,':','LineWidth',2)
xline(medUCBoot,':','LineWidth',2)
yline(iqrLCBoot,':','LineWidth',2)
yline(iqrUCBoot,':','LineWidth',2)
xlabel('Median (\mum)')
ylabel('IQR (\mum)')
title("Bootstrap Median vs. IQR Scatterplot");
legend(dataNames3,'Location','northeast')

subplot(2,3,5, 'Parent',p1)
histogram(medBootstats)
xline(MED,'r', 'LineWidth',2)
xline(medLCBoot,':', 'LineWidth',2)
xline(medUCBoot,':', 'LineWidth',2)
title("Bootstrap Median Histogram");
xlabel('Median (\mum)')
ylabel('Counts')
legend(dataNames4,'Location','northeast')

subplot(2,3,6, 'Parent',p1)
histogram(iqrBootstats)
xline(IQR,'r', 'LineWidth',2)
xline(iqrLCBoot,':', 'LineWidth',2)
xline(iqrUCBoot,':', 'LineWidth',2)
title("Bootstrap IQR Histogram");
xlabel('IQR (\mum)')
ylabel('Counts')
legend(dataNames4,'Location','northeast')
%Export the figure to the Data Analysis Folder
saveas(Fig1, dirExport1);

end