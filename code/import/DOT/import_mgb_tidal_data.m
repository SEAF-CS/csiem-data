clear all; close all;

main_dir = '../../../data-lake/dot/tide/RKMGL01/';

outdir = '../../../data-warehouse/csv/dot/tide/';
if ~exist(outdir,'dir')
    mkdir(outdir);
end

dirlist = dir(main_dir);

textformat = [repmat('%s ',1,2)];

aheight = [];
adate = [];

bheight = [];
bdate = [];

for i = [3:length(dirlist)]
    
    new_dir = [main_dir,dirlist(i).name,'/'];
    
    filelist = dir(new_dir);
    
    for j = 3:length(filelist)
        
        disp(filelist(j).name);
        
        fid = fopen([new_dir,filelist(j).name],'rt');
        
        
        datacell = textscan(fid,textformat,'Headerlines',2,'Delimiter',',','EndofLine','/');
        
        height = str2double(datacell{1});
        
        
        sDate = datacell{2};
        
        switch filelist(j).name(16)
            case 'a'
                disp('Sensor A');
                
                aheight = [aheight;height(1:length(sDate),1)./ 100];
                adate = [adate;datenum(sDate,'yyyymmdd.HHMM')];
            case '.'
                disp('No Backup');
                aheight = [aheight;height(1:length(sDate),1)./ 100];
                adate = [adate;datenum(sDate,'yyyymmdd.HHMM')];
                
            otherwise
                disp('Sensor B');
                bheight = [bheight;height(1:length(sDate),1)./ 100];
                bdate = [bdate;datenum(sDate,'yyyymmdd.HHMM')];
                %remander = str2double(sDate) - floor(str2double(sDate));
                
        end
        
        
        
    end
    
end

aheight(aheight < -50) = -9999;
bheight(bheight < -50) = -9999;


sss = find(aheight < -500);

for i = 1:length(sss)
    ttt = find(bdate == adate(sss(i)));
    if ~isempty(sss)
        if bheight(ttt) > -500
            disp('filled');
            aheight(sss(i)) = bheight(ttt);
        end
    end
end


depth = [];
QC = 'n';
filename = '../../../data-warehouse/csv/dot/tide/RKMGL01_Tidal_Height_DATA.csv';

fid = fopen(filename,'wt');
fprintf(fid,'Date,Depth,Data,QC\n');

ggg = find(adate >= datenum(1970,01,01,00,00,00));

for i = 1:length(ggg)
    fprintf(fid,'%s,%s,%4.4f,%s\n',datestr(adate(ggg(i)),'dd-mm-yyyy HH:MM:SS'),depth,aheight(ggg(i)),QC);
end
fclose(fid);

headerfile = regexprep(filename,'_DATA','_HEADER');

fid = fopen(headerfile,'wt');
fprintf(fid,'Agency Name,Department of Transport\n');
fprintf(fid,'Agency Code,DOT\n');
fprintf(fid,'Program,Coastal Data\n');
fprintf(fid,'Project,Tide\n');
fprintf(fid,'Data File Name,RKMGL01_Tidal_Height.csv\n');
fprintf(fid,'Location,data-warehouse/csv/dot/tide\n');

if max(adate) >= datenum(2019,01,01)
    fprintf(fid,'Station Status,Active\n');
else
    fprintf(fid,'Station Status,Inactive\n');
end
fprintf(fid,'Lat,-32.274431\n');
fprintf(fid,'Long,115.703344\n');
fprintf(fid,'Time Zone,GMT +8\n');
fprintf(fid,'Vertical Datum,Chart datum which is 2.527m below Benchmark DMH 073 \n');
fprintf(fid,'National Station ID,RKMGL01\n');
fprintf(fid,'Site Description,Mangles Bay\n');
fprintf(fid,'Bad or Unavailable Data Value,-9999\n');
fprintf(fid,'Contact Email,tides@transport.wa.gov.au\n');
fprintf(fid,'Variable ID,var00180\n');
fprintf(fid,'Data Classification,HYDRO Level\n');

SD = mean(diff(adate));

fprintf(fid,'Sampling Rate (min),%4.4f\n',SD * (60*24));

fprintf(fid,'Date,dd-mm-yyyy HH:MM:SS\n');
fprintf(fid,'Depth,Decimal\n');

%thevar = [varName{sss},' (',varUnit{sss},')'];

fprintf(fid,'Variable,Tidal Height (m)\n');
fprintf(fid,'QC,String\n');

fclose(fid);


%
% main_dir = 'Tide/PTBAR02_Tides/';
%
% dirlist = dir(main_dir);
%
% textformat = [repmat('%s ',1,2)];
%
% data.bar.height = [];
% data.bar.date = [];
%
% for i = 3:length(dirlist)
%
%     new_dir = [main_dir,dirlist(i).name,'/'];
%
%     filelist = dir(new_dir);
%
%     for j = 3:length(filelist)
%
%         disp(filelist(j).name);
%
%         fid = fopen([new_dir,filelist(j).name],'rt');
%
%
%         datacell = textscan(fid,textformat,'Headerlines',2,'Delimiter',',','EndofLine','/');
%
%         height = str2double(datacell{1});
%
%
%         sDate = datacell{2};
%
%
%         data.bar.height = [data.bar.height;height(1:length(sDate),1) ./ 100];
%
%
%         %remander = str2double(sDate) - floor(str2double(sDate));
%
%         data.bar.date = [data.bar.date;datenum(sDate,'yyyymmdd.HHMM')];
%
%
%
%     end
%
% end
%
% fid = fopen('Barrack_Tide.csv','wt');
% fprintf(fid,'record_datetime,Height (m)\n');
% for i = 1:length(data.bar.date)
%     fprintf(fid,'%s,%4.4f\n',datestr(data.bar.date(i),'dd/mm/yyyy HH:MM:SS'),data.bar.height(i));
% end
% fclose(fid);
%
% save Tidaldata.mat data -mat;
%
% save Compare' Tidal Data'/Tidaldata.mat data -mat;



