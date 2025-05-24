

Contours = shaperead('/GIS_DATA/csiem-data-hub/marvl/gis/MLAU_Zones_v3_ll.shp');
clf
mapshow(Contours)
AXIS = axis();
hold on

for i = [5     6    13    36    37    39    40    41    42    43    44    48    52] % this comes from down the bottom ListofRegions
    plot(Contours(i).X,Contours(i).Y,"DisplayName",Contours(i).Name)
    hold on
end


BoundsPolyX = AXIS([1,2,2,1]);
BoundsPolyY = AXIS([3,3,4,4]);


%% sites by sitekey
% % load '/GIS_DATA/csiem-data-hub/csiem-data/code/actions/sitekey.mat'
% AgencyList = fields(sitekey);
% for AgencyInd = [4 15:34]%1:length(AgencyList)
%     Agency = sitekey.(AgencyList{AgencyInd});
%     SiteList = fields(Agency);

%     for SiteInd = 1:length(SiteList)
%         Site = Agency.(SiteList{SiteInd});
%         plot(Site.Lon,Site.Lat,'x')

%     end

% end


%% sites by warehouse headers

addpath('/GIS_DATA/csiem-data-hub/csiem-data/code/functions')
% % outside the range list
Headings = 'Headerfile,sitename,lon,lat,DepthOrHeight,MeanDepth,ModeDepth\n';
SummaryFile = 'InsideTheRegionsitesZoo.csv';
fid = fopen(SummaryFile, 'w');
fprintf(fid,Headings);


filepath = ['/GIS_DATA/csiem-data-hub/data-warehouse/csv/wamsi/wwmsp4/zooplankton/'];
filelist = dir(fullfile(filepath, '**/*HEADER.csv'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list
n = length(filelist);

for i = 1:n
    filename = [filelist(i).folder,'/',filelist(i).name];
    Heada = import_header(filename);
    xq = Heada.Lon;
    yq = Heada.Lat;
    sitename = Heada.Station_ID;
    
    %% Only read in headerfiles
    % DorH = Heada.Deployment_Position;
    % MeanDepth = -101;
    % ModeDepth = -101;


    %% read in depth
    % very slow

    datafilename = replace(filename,'HEADER.csv','DATA.csv');
    DAT = readtable(datafilename);
    DorH = DAT.Properties.VariableNames{2};
    depth = DAT{:,2};

    MeanDepth = -101;
    ModeDepth = -101;
    if isnumeric(depth)
        MeanDepth = mean(depth);
        ModeDepth = mode(depth);
    end


    fprintf(fid,'%s,%s,%f,%f,%s,%f,%f\n',filename,sitename,xq,yq,DorH,MeanDepth,ModeDepth);


end
fclose(fid);
Summary = readtable(SummaryFile);
[Sitenames,ISummary,ISitename] = unique(Summary{:,2});
for i = ISummary'
    fprintf("%s,%f,%f\n",Summary{i,2}{1},Summary{i,3},Summary{i,4})
    plot(Summary{i,3},Summary{i,4},'x',"DisplayName",Summary{i,2}{1})
    hold on
end

% AXIS
axis(AXIS)
legend()

for k = 1:length(ISummary)
    i = ISummary(k);
    xq = Summary{i,3};
    yq = Summary{i,4};
    for j = 1:length(Contours)
        InBool(k,j) = inpolygon(xq,yq,Contours(j).X,Contours(j).Y);
    end
end


for j = 1:length(Contours)
    RegionNames{1,j} = Contours(j).Name;
end 

S = sum(InBool,1);
ListOfRegions= find(S>0);

%% writing the Site linker to a csv file, this is made complicated because it makes more sense if it is transposed.
fid = fopen('ZooMarvlSiteRegionLinker.csv','w');
fprintf(fid,','); % adding the empty cell at the top right

%adding the Site names to the top
for k = 1:length(Sitenames)
    fprintf(fid,"%s,",Sitenames{k});
end
fprintf(fid,"\n");


for i = 1:length(RegionNames)
    fprintf(fid,'%s,',RegionNames{1,i});% this line adds the region name to the start of a row

    %this will populate the rest of the row.
    for k = 1:length(Sitenames)
        fprintf(fid,"%d,",InBool(k,i));
    end
    fprintf(fid,"\n");

end
fclose(fid);

