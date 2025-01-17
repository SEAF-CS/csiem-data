function export_lake_2_warehouse_csv_test

basedir = 'V:/data-warehouse/csv/';

filelist = dir(fullfile(basedir, '**\*DATA.csv'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list


% [snum,sstr] = xlsread('Projects.xlsx','A2:D10000');
% 
% for k = 1:length(snum(:,1))
%     thesites{k} = num2str(snum(k,1));
% end
% theproject = sstr(:,1);



for i = 1:length(filelist)
    
    newpath = regexprep(filelist(i).folder,'csv','SERF');
    
    
    
    if ~exist(newpath,'dir')
        mkdir(newpath);
    end
    
    newfile = [newpath,'\',filelist(i).name];
    
    disp(['Writing ',newfile]);
    
    filename = [filelist(i).folder,'\',filelist(i).name];
    headerfile = regexprep(filename,'DATA.csv','HEADER.csv');
    
    
    data = load_data_file(filename);
    
    data
    
    
    header = import_header(headerfile);
    
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
        
        fprintf(fid,'%s,%s,%s,%s,%s,',header.Agency_Name,header.Agency_Code,...
            header.Program_Name,header.Program_Code,header.Status);
        
        fprintf(fid,'%s,%s,%s,%s,%s,',header.Lat,header.Lon,...
            header.Time_Zone,header.Vertical_Datum,header.Station_ID);
        
        fprintf(fid,'%s,%s,%s,',header.Site_Description,header.Data_Classification,...
            header.Variable_Name);
        
        fprintf(fid,'%s,%6.4f,%6.4f,%s\n',datestr(data.Date(j),'dd-mm-yyyy HH:MM:SS'),data.Depth(j),data.Data(j),data.QC{j});
        
    end
    fclose(fid);
    
    
    
    
    
end





end

function data = load_data_file(filename)

fid = fopen(filename,'rt');


x  = 4;
textformat = [repmat('%s ',1,x)];
% read single line: number of x-values
datacell = textscan(fid,textformat,'Headerlines',1,'Delimiter',',');
fclose(fid);

data.Date = datenum(datacell{1},'dd-mm-yyyy HH:MM:SS');
data.Data = str2doubleq(datacell{3});
data.QC = datacell{4};
data.Depth_RAW = datacell{2};
tdepth = datacell{2};

for i = 1:length(tdepth)
    xval = tdepth{i};
    spt = split(xval,'-');
    
    if length(spt) > 1
        
        depth1(i,1) = str2double(spt{1});
        depth2(i,1) = str2double(spt{2});
        
        try
            depth(i,1) = (depth1(i,1) + depth2(i,1)) /2;
        catch
            depth1(i,1)
            depth2(i,1)
            stop
        end
        %         if (depth2(i,1) - depth(i,1)) < 0.3
        %             data.QC(i) = {'Possible PoreWater'};
        %
        %         end
        
        
    else
        depth1(i,1) = NaN;
        depth2(i,1) = NaN;
        depth(i,1) = str2double(spt{1});
    end
end

data.Depth = depth;
data.Depth_T = depth1;
data.Depth_B = depth2;

end

function data = import_header(filename)

fid = fopen(filename,'rt');

while ~feof(fid)
    fline = fgetl(fid);
    sline = split(fline,',');
    
    switch sline{1}
        case 'Agency Name'
            data.Agency_Name = sline{2};
            
        case 'Agency Code'
            data.Agency_Code = sline{2};
            
        case 'Program'
            data.Program_Name = sline{2};
            
        case 'Project'
            data.Program_Code = sline{2};
            
        case 'Data File Name'
            data.Data_File_Name = sline{2};
            
        case 'Location'
            data.Data_File_Location = sline{2};
            
        case 'Station Status'
            data.Status = sline{2};
            
        case 'Lat'
            data.Lat = str2num(sline{2});
            
        case 'Long'
            data.Lon = str2num(sline{2});
            
        case 'Time Zone'
            data.Time_Zone = sline{2};
            
        case 'Vertical Datum'
            data.Vertical_Datum = sline{2};
            
        case 'National Station ID'
            data.Station_ID = sline{2};
            
        case 'Site Description'
            data.Site_Description = sline{2};
            
        case 'Bad or Unavailable Data Value'
            data.Bad_Data_Code = sline{2};
            
        case 'Contact Email'
            data.Email = sline{2};
            
        case 'Variable ID'
            data.Variable_ID = sline{2};
            
        case 'Data Classification'
            data.Data_Classification = sline{2};
            
        case 'Sampling Rate (min)'
            data.Sampling_Rate = sline{2};
            
        case 'Date'
            data.Date_Format = sline{2};
            
        case 'Depth'
            data.Depth_Format = sline{2};
            
        case 'Variable'
            data.Variable_Name = sline{2};
            
        case 'QC'
            data.QC_Code = sline{2};
            
        otherwise
            disp('Header not found');
            stop;
    end
    
    
    
    
end


[data.X,data.Y] = ll2utm(data.Lat,data.Lon);
fclose(fid);

end




