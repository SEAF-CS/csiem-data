function export_lake_2_warehouse_csv_test

basedir = '../../data-warehouse/csv/';

filelist = dir(fullfile(basedir, '**\*DATA.csv'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list


% [snum,sstr] = xlsread('Projects.xlsx','A2:D10000');
% 
% for k = 1:length(snum(:,1))
%     thesites{k} = num2str(snum(k,1));
% end
% theproject = sstr(:,1);



for i = 1:length(filelist)
    
    newpath = regexprep(filelist(i).folder,'csv','csv_test_new');
    
    
    
    if ~exist(newpath,'dir')
        mkdir(newpath);
    end
    
    newfile = [newpath,'\',filelist(i).name];
    
    disp(['Writing ',newfile]);
    
    filename = [filelist(i).folder,'\',filelist(i).name];
    headerfile = regexprep(filename,'DATA.csv','HEADER.csv');
    
    
    data = load_data_file(filename);
    
    %data
    
    
    header = load_header_file(headerfile);
    
    %header
    
%     sss = find(strcmpi(thesites,header.StationID)==1);
%     
%     
%     if ~isempty(sss)
%         
%         proj = theproject{sss};
%         oldproj = header.Project;
%         header.Project = proj;
%         newfile = regexprep(newfile,lower(oldproj),lower(proj));
%         newpath = regexprep(newpath,lower(oldproj),lower(proj));
%         if ~exist(newpath,'dir')
%             mkdir(newpath);
%         end
%     end
    
    
    
    
    fid = fopen(newfile,'wt');
    theheader = 'Agency Name,Agency Code,Program,Project,Station Status,Lat,Long,Time Zone,Vertical Datum,National Station ID,Site Description,Data Classification,Variable,Date,Depth,Data,QC';
    
    fprintf(fid,'%s\n',theheader);
    
    for j = 1:length(data.Date)
        
        fprintf(fid,'%s,%s,%s,%s,%s,',header.Agency,header.AgencyCode,...
            header.Program,header.Project,header.Status);
        
        fprintf(fid,'%s,%s,%s,%s,%s,',header.Lat,header.Lon,...
            header.TimeZone,header.Datum,header.StationID);
        
        fprintf(fid,'%s,%s,%s,',header.Description,header.Classification,...
            header.FullVar);
        
        fprintf(fid,'%s,%6.4f,%6.4f,%s\n',data.Date{j},data.Depth(j),data.Data(j),data.QC{j});
        
    end
    fclose(fid);
    
    
    
    
    
end





end

function data = load_data_file(filename)

X = 4;

fid = fopen(filename,'rt');
textformat = [repmat('%s ',1,X)];
datacell = textscan(fid,textformat,'Headerlines',1,'Delimiter',',');
fclose(fid);

data.Date = datacell{1};
data.Depth = str2doubleq(datacell{2});
data.Data = str2doubleq(datacell{3});
data.QC = datacell{4};

end

function header = load_header_file(headerfile)
fid = fopen(headerfile,'rt');

fline = fgetl(fid); spt = split(fline,',');

header.Agency = spt{2};

fline = fgetl(fid); spt = split(fline,',');

header.AgencyCode = spt{2};

fline = fgetl(fid); spt = split(fline,',');

header.Program = spt{2};

fline = fgetl(fid); spt = split(fline,',');

header.Project = spt{2};

fline = fgetl(fid); spt = split(fline,',');

header.DataFile = spt{2};

fline = fgetl(fid); spt = split(fline,',');

header.Location = spt{2};

fline = fgetl(fid); spt = split(fline,',');

header.Status = spt{2};

fline = fgetl(fid); spt = split(fline,',');

header.Lat = spt{2};

fline = fgetl(fid); spt = split(fline,',');

header.Lon = spt{2};

fline = fgetl(fid); spt = split(fline,',');

header.TimeZone = spt{2};

fline = fgetl(fid); spt = split(fline,',');

header.Datum = spt{2};

fline = fgetl(fid); spt = split(fline,',');

header.StationID = spt{2};

fline = fgetl(fid); spt = split(fline,',');

header.Description = spt{2};

fline = fgetl(fid); spt = split(fline,',');

header.BadValue = spt{2};

fline = fgetl(fid); spt = split(fline,',');

header.Email = spt{2};

fline = fgetl(fid); spt = split(fline,',');

header.Classification = spt{2};

fline = fgetl(fid); spt = split(fline,',');

header.SamplingRate = spt{2};

fline = fgetl(fid); spt = split(fline,',');

header.DateFormat = spt{2};

fline = fgetl(fid); spt = split(fline,',');

header.Depth = spt{2};

fline = fgetl(fid); spt = split(fline,',');

header.FullVar = spt{1};

fline = fgetl(fid); spt = split(fline,',');

header.QC = spt{2};

fclose(fid);

end




