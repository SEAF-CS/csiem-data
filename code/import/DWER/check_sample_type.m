clear all; close all;

load swan.mat;

st = [];

sites = fieldnames(swan);

for i = 1:length(swan)
    vars = fieldnames(swan.(sites{i}));
    for j = 1:length(vars)
        st = [st;swan.(sites{i}).(vars{j}).Sample_Type];
    end
end

unique(st)