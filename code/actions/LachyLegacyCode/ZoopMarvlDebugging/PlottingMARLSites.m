

Contours = shaperead('/GIS_DATA/csiem-data-hub/marvl/gis/MLAU_Zones_v3_ll.shp');
clf
mapshow(Contours)
AXIS = axis();
BoundsPolyX = AXIS([1,2,2,1]);
BoundsPolyY = AXIS([3,3,4,4]);
hold on

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
Headings = 'Headerfile,lon,lat,DepthOrHeight,MeanDepth,ModeDepth\n';
fid1 = fopen('OutsideTheRegionsites.csv','w');
fprintf(fid1,Headings);
fid2 = fopen('InsideTheRegionsites.csv', 'w');
fprintf(fid2,Headings);


filepath = ['/GIS_DATA/csiem-data-hub/data-warehouse/csv/'];
filelist = dir(fullfile(filepath, '**/*HEADER.csv'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list
n = length(filelist);

for i = 1:n
    fid = fid1;
    filename = [filelist(i).folder,'/',filelist(i).name];
    Heada = import_header(filename);
    xq = Heada.Lon;
    yq = Heada.Lat;

    InBool = inpolygon(xq,yq,BoundsPolyX,BoundsPolyY);

    if InBool
        % fprintf('here\n')
        fid = fid2;
        % plot(xq,yq,'x')
    end
    
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


    fprintf(fid,'%s,%f,%f,%s,%f,%f\n',filename,xq,yq,DorH,MeanDepth,ModeDepth);


end
fclose(fid1);
fclose(fid2);
% AXIS
axis(AXIS)