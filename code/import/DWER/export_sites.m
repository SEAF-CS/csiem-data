clear all; close all;

load swan.mat;

sites = fieldnames(swan);

for i = 1:length(sites)
    vars = fieldnames(swan.(sites{i}));
    X = swan.(sites{i}).(vars{1}).X;
    Y = swan.(sites{i}).(vars{1}).Y;
    
    S(i).X = X;
    S(i).Y = Y;
    S(i).Name = sites{i};
    
    if isfield(swan.(sites{i}),'Flow')
         S(i).Program = 'swancatch';
    else
        S(i).Program = 'swanest';
    end
    S(i).Agency = 'DWER';
    S(i).Geometry = 'Point';
end
shapewrite(S,'DWER.shp');