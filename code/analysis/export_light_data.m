clear all; close all;
%% Data Import

lightdata = parquetread("D:\csiem\data-warehouse\parquet\category\csiem_Light_public.parq");
wqlightdata = parquetread("D:\csiem\data-warehouse\parquet\category\csiem_Water Quality (Light)_public.parq");
wqnutdata = parquetread("D:\csiem\data-warehouse\parquet\category\csiem_Water Quality (Nutrient)_public.parq");

%%
% Variables to search for:

% Secchi Depth - Light
% Light Attenuation Coefficient - Light
% 
% 
% Turbidity - WQ Light

% Chlorophyll-a - Water Quality (Nutrient)
% Total Suspended Solids - Water Quality (Nutrient)
% P Organic Carbon - Water Quality (Nutrient)
% Total Organic Carbon - Water Quality (Nutrient)
% 
% 
%% Out dirs

outdir = 'processed_1km/';
rad = 0.008 * 1;
mkdir(outdir);

%% Daterange
startdate = datenum(2021,12,01);
enddate = datenum(2022,06,01);

lightmdate = datenum(lightdata.Date,'yyyy-mm-dd HH:MM:SS');
wqlightmdate = datenum(wqlightdata.Date,'yyyy-mm-dd HH:MM:SS');
wqnutmdate = datenum(wqnutdata.Date,'yyyy-mm-dd HH:MM:SS');


%% Data Search

A = contains(lightdata.Variable_Name,'Spectral Radiative');

sss = find(A == 1);

[sites,ind] = unique(lightdata.Station_ID(sss));


for i = 1:length(sites)-1
    
    lat = lightdata.Lat(sss(ind(i)));
    lon = lightdata.Lon(sss(ind(i)));
    
    
    ttt = find(strcmpi(lightdata.Station_ID,sites{i}) == 1  & lightmdate >= startdate & lightmdate <= enddate);
    
    % Create the new table with the clipped data.
    
    newtab = lightdata(ttt,:);
    
    
    % Create the polygon
    T = nsidedpoly(360,'Center',[lon lat],'Radius',rad);
    pol(1).Lon = T.Vertices(:,1);
    pol(1).Lat = T.Vertices(:,2);
    pol(1).Name = sites{i};
    pol(1).Geometry = 'polygon';    
    shapewrite(pol,[sites{i},'.shp']);
    
    inpoly_light = inpolygon(lightdata.Lon,lightdata.Lat,pol.Lon,pol.Lat);
    inpoly_wqlight = inpolygon(wqlightdata.Lon,wqlightdata.Lat,pol.Lon,pol.Lat);
    inpoly_wqnut = inpolygon(wqnutdata.Lon,wqnutdata.Lat,pol.Lon,pol.Lat);
    
%     fff = find(inpoly_light == 1);
%     ggg = find(inpoly_wqnut == 1);
%     hhh = find(inpoly_wqlight == 1);
    
    % light searches

    lightsearch1 = find(...
        strcmpi(lightdata.Variable_Name,'Secchi Depth (m)') == 1 &...
        strcmpi(lightdata.Station_ID,sites{i}) == 0 & ...
        inpoly_light == 1 & ...
        lightmdate >= startdate & lightmdate <= enddate);
    
    if ~isempty(lightsearch1)
        newtab(end+1:end + length(lightsearch1),:) = lightdata(lightsearch1,:);
        %append(newtab,lightdata(lightsearch1,:));
        disp('Appending data');
    end
    
    lightsearch2 = find(...
        strcmpi(lightdata.Variable_Name,'Light Attenuation Coefficient (m-1)') == 1 &...
        strcmpi(lightdata.Station_ID,sites{i}) == 0 & ...
        inpoly_light == 1 & ...
        lightmdate >= startdate & lightmdate <= enddate);
    
    if ~isempty(lightsearch2)
        newtab(end+1:end + length(lightsearch2),:) = lightdata(lightsearch2,:);
        %append(newtab,lightdata(lightsearch2,:));
        disp('Appending data');
    end    
    
    
    % WQ light searches
     wqlightsearch1 = find(...
        strcmpi(wqlightdata.Variable_Name,'Turbidity (NTU)') == 1 &...
        inpoly_wqlight == 1 & ...
        wqlightmdate >= startdate & wqlightmdate <= enddate);
    
    if ~isempty(wqlightsearch1)
        newtab(end+1:end + length(wqlightsearch1),:) = wqlightdata(wqlightsearch1,:);
        %append(newtab,wqlightdata(wqlightsearch1,:));
        disp('Appending data');
    end   
    
    %WQ Nut searches
     wqnutsearch1 = find(...
        strcmpi(wqnutdata.Variable_Name,'Chlorophyll-a (µg/l)') == 1 &...
        inpoly_wqnut == 1 & ...
        wqnutmdate >= startdate & wqnutmdate <= enddate);
    
    if ~isempty(wqnutsearch1)
        newtab(end+1:end + length(wqnutsearch1),:) = wqnutdata(wqnutsearch1,:);
        %append(newtab,wqnutdata(wqnutsearch1,:));
        disp('Appending data');
    end 
    
    
 %WQ Nut searches
     wqnutsearch2 = find(...
        strcmpi(wqnutdata.Variable_Name,'Total Suspended Solids (mg/L)') == 1 &...
        inpoly_wqnut == 1 & ...
        wqnutmdate >= startdate & wqnutmdate <= enddate);
    
    if ~isempty(wqnutsearch2)
         newtab(end+1:end + length(wqnutsearch2),:) = wqnutdata(wqnutsearch2,:);
        %append(newtab,wqnutdata(wqnutsearch2,:));
        disp('Appending data');
    end 
    
    %WQ Nut searches
     wqnutsearch3 = find(...
        strcmpi(wqnutdata.Variable_Name,'Dissolved Organic Carbon (mg/L)') == 1 &...
        inpoly_wqnut == 1 & ...
        wqnutmdate >= startdate & wqnutmdate <= enddate);
    
    if ~isempty(wqnutsearch3)
        newtab(end+1:end + length(wqnutsearch3),:) = wqnutdata(wqnutsearch3,:);
        %append(newtab,wqnutdata(wqnutsearch3,:));
        disp('Appending data');
    end 
 
    
    wqnutsearch5 = find(...
        strcmpi(wqnutdata.Variable_Name,'Particulate Organic Carbon (mg/L)') == 1 &...
        inpoly_wqnut == 1 & ...
        wqnutmdate >= startdate & wqnutmdate <= enddate);
    
    if ~isempty(wqnutsearch5)
        newtab(end+1:end + length(wqnutsearch5),:) = wqnutdata(wqnutsearch5,:);
        %append(newtab,wqnutdata(wqnutsearch3,:));
        disp('Appending data');
    end 
    
%     %WQ Nut searches
     wqnutsearch4 = find(...
        strcmpi(wqnutdata.Variable_Name,'Total Suspended Solids (mg/L)') == 1 &...
        inpoly_wqnut == 1 & ...
        wqnutmdate >= startdate & wqnutmdate <= enddate);
    
    if ~isempty(wqnutsearch4)
        newtab(end+1:end + length(wqnutsearch4),:) = wqnutdata(wqnutsearch4,:);
        %append(newtab,wqnutdata(wqnutsearch4,:));
        disp('Appending data');
    end 
    
    newtab.mdate = datenum(newtab.Date);
    filename = [outdir,sites{i},'.parq'];
    parquetwrite(filename,newtab);
    writetable(newtab,regexprep(filename,'.parq','.csv'));  
    clear pol newtab;
end