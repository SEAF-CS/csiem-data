%function import_daily_rainfall

addpath(genpath('../../functions/'));

[snum,sstr] = xlsread('../../../data-lake/site_key.xlsx','BOM','A2:H10000');

sitename = sstr(:,3);
siteid = snum(:,1);
Lat = snum(:,6);
Lon = snum(:,7);
shortname = sstr(:,4);

filepath = '../../../data-lake/bom/rainfall/';

filelist = dir(fullfile(filepath, '**\*.csv'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list


outdir = '../../../data-warehouse/csv/bom/rainfall/';
writepath = 'data-warehouse/csv/bom/rainfall';
if ~exist(outdir,'dir')
    mkdir(outdir);
end

for i = 1:length(filelist)
    
    filename = [filelist(i).folder,'/',filelist(i).name];
    
    fid = fopen(filename,'rt');
    
    x  = 8;
    textformat = [repmat('%s ',1,x)];
    % read single line: number of x-values
    datacell = textscan(fid,textformat,'Headerlines',1,'Delimiter',',');
    fclose(fid);
    
    tt = double(str2doubleq(datacell{2}));
    sitecode = tt(1);
    
    nyear = double(str2doubleq(datacell{3}));
    nmonth = double(str2doubleq(datacell{4}));
    nday = double(str2doubleq(datacell{5}));
    rainfall = double(str2doubleq(datacell{6})) ./1000;
    mdate = datenum(nyear,nmonth,nday);
    
    QC = datacell{8};
    
    sss = find(siteid == sitecode);
    
    
    
    
    filename = [outdir,num2str(sitecode),'_Precipitation_DATA.csv'];
    writefile = [num2str(sitecode),'_Precipitation_DATA.csv'];
    
    fid = fopen(filename,'wt');
    
    fprintf(fid,'Date,Depth,Data,QC\n');
    
    for k = 1:length(mdate)
        fprintf(fid,'%s,%s,%8.5f,%s\n',datestr(mdate(k),'dd-mm-yyyy HH:MM:SS'),' ',rainfall(k),QC{k});
    end
    fclose(fid);
    
    
    
    headerfile = regexprep(filename,'_DATA','_HEADER');
    
    fid = fopen(headerfile,'wt');
    fprintf(fid,'Agency Name,Bureau of Meteorology\n');
    fprintf(fid,'Agency Code,BOM\n');
    fprintf(fid,'Program,Weather\n');
    fprintf(fid,'Project,IDY\n');
    fprintf(fid,'Data File Name,%s\n',writefile);
    fprintf(fid,'Location,%s\n',writepath);
    
    if max(mdate) >= datenum(2019,01,01)
        fprintf(fid,'Station Status,Active\n');
    else
        fprintf(fid,'Station Status,Inactive\n');
    end
    fprintf(fid,'Lat,%8.8f\n',Lat(sss));
    fprintf(fid,'Long,%8.8f\n',Lon(sss));
    fprintf(fid,'Time Zone,GMT +8\n');
    fprintf(fid,'Vertical Datum, \n');
    fprintf(fid,'National Station ID,%s\n',num2str(siteid(sss)));
    fprintf(fid,'Site Description,%s\n',sitename{sss});
    fprintf(fid,'Bad or Unavailable Data Value,-9999\n');
    fprintf(fid,'Contact Email,climatedata@bom.gov.au\n');
    fprintf(fid,'Variable ID,%s\n','var00152');
    fprintf(fid,'Data Classification,MET General\n');
    
    SD = mean(diff(mdate));
    
    fprintf(fid,'Sampling Rate (min),%4.4f\n',SD * (60*24));
    
    fprintf(fid,'Date,dd-mm-yyyy HH:MM:SS\n');
    fprintf(fid,'Depth,Decimal\n');
    
    %thevar = [varName{sss},' (',varUnit{sss},')'];
    
    fprintf(fid,'Variable,%s\n','Precipitation (m)');
    fprintf(fid,'QC,String\n');
    
    fclose(fid);
end