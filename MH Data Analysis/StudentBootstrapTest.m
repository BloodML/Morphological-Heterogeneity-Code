function [obsTestStat,bootTestStat, p] = StudentBootstrapTest(obs1,obs2, replicates)
% A studentized two sample bootstrap hypothesis test that compares the 
% difference between two sample means via a T-statistic. Although it uses
% the two sample t-test to compare means without the assumption of equal
% variance, it is a nonparametric test because the p-value is based on
% the distribution of test-statistics generated from sampling with
% replacement. Hence, it is a hypothesis test of no difference between 
% sample means that performs better with skewed distributions than a
% classic two sample t-test.
% 


% References
%
% Barber, J., & Thompson, S. (2000). Analysis of cost data in randomized 
%   trials: an application of the non-parametric bootstrap. Statistics 
%   In Medicine, 19(23), 3219-3236. https://doi.org/10.1002/1097-0258
%   (20001215)19:23<3219::aid-sim623>3.0.co;2-p
%
% Dahiru T. (2008). P - value, a true test of statistical significance? 
%   A cautionary note. Annals of Ibadan postgraduate medicine, 6(1), 21–26.
%   https://doi.org/10.4314/aipm.v6i1.64038
%
% Davison, A., & Hinkley, D. (1997). Bootstrap methods and their application.
%   Cambridge University Press.
%
% Dwivedi, A., Mallawaarachchi, I., & Alvarado, L. (2017). Analysis of 
%   small sample size studies using nonparametric bootstrap test with 
%   pooled resampling method. Statistics In Medicine. https://doi.org/10.1002/sim.7263
%
% Efron, B., & Tibshirani, R. (1993). An Introduction to the Bootstrap. 
%   https://doi.org/10.1007/978-1-4899-4541-9
%
% MarinStatsLectures. (2018, December 10). Bootstrap Hypothesis Testing in
%   Statistics with Example |Statistics Tutorial #35 |MarinStatsLectures 
%   [Video]. YouTube. https://youtu.be/9STZ7MxkNVg
%
%
% Input:
%   obs1 = The first sample (a column or row vector)
%   obs2 = The second sample (a column or row vector)
%   fun = The statistic of comparision as a function ( e.g. @(x)mean(x),@(x)median(x), @(x)std(x))
%   replicates = number of bootrap experiments
%
% Output:
%   obsTestStat = The test statistic used to compare bootstrap statistics
%   bootTestStat = The vector of bootstrap test statistics 
%   p = a ratio of the sum of boot-test-statistics that are greater or 
%       equal to the observed-test-statistic and the number of bootstraps/replicates
%


%Make sure both are row vectors
if height(obs1)>1
    obs1=obs1';
end
if height(obs2)>1
    obs2=obs2';
end


%Create a container for the boot-statistics
bootTestStat = [];
%Get the observation statistic
[~,~,~,T] = ttest2(obs1,obs2,'Vartype','unequal');
obsTestStat = abs(T.tstat);

%Combine the observations (The null hypothesis is samples are the same)
combObs = [obs1, obs2];

%Perform bootstrap for every replicate
for ii = 1:1:replicates
    %Bootstrap from the combined twice
    bootObs1 = datasample(combObs, length(obs1), 'Replace', true);
    bootObs2 = datasample(combObs, length(obs2), 'Replace', true);


    %Get the t-statistic associated with the bootstrap samples
    [~,~,~,T] = ttest2(bootObs1,bootObs2,'Vartype','unequal');
    %Add it to the bootstrap statistic container
    bootTestStat(ii) = abs(T.tstat);
    
end
%If bootTStats contains all NaN values, set the p-value to nan
if sum(isnan(bootTestStat)) == length(bootTestStat)
    p = nan;
%Else, get the p value by finding the all bootstatstics that are greater or
%equal to the observed statistic and then dividing by the number of
%experiments
else
p = (sum(bootTestStat>=obsTestStat))/(replicates);
end



end