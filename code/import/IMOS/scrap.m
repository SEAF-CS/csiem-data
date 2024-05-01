addpath(genpath('../../functions/'));


data = tfv_readnetcdf('Y:\WAMSI\Model\ROMS\2016\grid.nc');

lon = data.lon_u(:);
lat = data.lat_u(:);

for i = 1:length(lon)
    S(i).Lon = lon(i);
    S(i).Lat = lat(i);
    S(i).Name = num2str(i);
    S(i).Geometry = 'point';
end
shapewrite(S,'ROMS_Grid.shp');