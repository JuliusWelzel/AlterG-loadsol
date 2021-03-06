function [ mean_data sem_data ] = mean_SEM( data )
%mean_SEM calculates the standard error and mean of a vector of data
% Author: Julius Welzel, University of Oldenburg 2018

mean_data = [];
sem_data = [];

for r = 1:size(data,1)
    mean_data(r) = nanmean(data(r,:));
    sem_data(r) = nanstd(data(r,:));
end

end

