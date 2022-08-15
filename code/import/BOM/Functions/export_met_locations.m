clear all; close all;

load metdata.mat;

sites = fieldnames(metdata);
for i = 1:length(sites)
    S(i).Name = sites{i};
    S(i).Lat = metdata.(sites{i}).lat;
    S(i).Lon = metdata.(sites{i}).lon;
    S(i).Geometry = 'Point';
end
shapewrite(S,'metsites.shp');
    