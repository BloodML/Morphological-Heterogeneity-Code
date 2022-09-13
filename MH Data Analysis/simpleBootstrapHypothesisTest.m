function [obsTestStat, bootTestStat, p] = simpleBootstrapHypothesisTest(obs1,obs2, fun, replicates)
% A bootstrap two sample hypothesis test that takes a user defined 
% test-statistic to compare the difference between two samples. The general
% null hypothesis is essentially no effect or no difference between samples.
% The process first gets the absolute difference between observations after
% the user defined function (e.g. @(x)mean(x),@(x)median(x), @(x)std(x))
% converts them into scalars. This is the observation test statistic we
% compare with the bootstrap test statistics. The raw samples are then 
% combined to simulate the null hypothesis condition of no difference.
% We bootstrap twice from the combined observations (sample with replacement) 
% and employ the user defined function to get two vectors of bootstrap 
% test statistics equal to the number of replicates. After taking the 
% absolute difference between the two vectors of bootstrap statistics, 
% we calculate a p-value by dividing the of sum of bootstrap test statistic
% values that are greater than or equal  to the observation test statistic
% by the number of replicates.
% Note that The P value is literally "the probability under the assumption
% of no effect or no difference (null hypothesis), of obtaining a result equal 
% to or more extreme than what was actually observed.(Dahiru, 2008).

% References
%
% Dahiru T. (2008). P - value, a true test of statistical significance? 
%   A cautionary note. Annals of Ibadan postgraduate medicine, 6(1), 21–26.
%   https://doi.org/10.4314/aipm.v6i1.64038
%
% % Davison, A., & Hinkley, D. (1997). Bootstrap methods and their application.
%   Cambridge University Press.
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

%Calculate the observation test statistic
obsTestStat = abs(fun(obs1) - fun(obs2));

%Combine the observations (The null hypothesis is samples are the same)
combObs = [obs1, obs2];

%Bootstrap from the combined twice 
bootstat1 = bootstrp(replicates,fun,combObs);
bootstat2 = bootstrp(replicates,fun ,combObs);
%Get the bootstrap test statistics
bootTestStat = abs(bootstat1 - bootstat2);

%Calculate the p-value by getting the number of boot-test-statistics that
%are greater or equal to the observed-test-statistic and dividing by the
%number of bootstraps/replicates done

p = (sum(bootTestStat>=obsTestStat)+1)/(replicates+1);
end