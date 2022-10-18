function csv_2_matfile

addpath(genpath('../functions/'));

load varkey.mat;

outfile = '../../data-warehouse/mat/cockburn.mat';

filepath = '../../data-warehouse/csv/';

filelist = dir(fullfile(filepath, '**\*HEADER.csv'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

vars = fieldnames(varkey);


for i = 1:length(filelist)
    headerfile = [filelist(i).folder,'\',filelist(i).name];
    
    datafile = regexprep(headerfile,'HEADER','DATA');
    
    disp(['Importing: ',filelist(i).name]);
    
    header = import_header(headerfile);
    
    agency = header.Agency_Code;
    sitecode = [agency,'_',header.Station_ID];
    tfv_name = varkey.(header.Variable_ID).tfvName;
    tfv_conv = varkey.(header.Variable_ID).tfvConv;
    
    
    
    if strcmpi(tfv_name,'N/A') == 0
        
        data = import_datafile(datafile);
        
        
        cockburn.(sitecode).(tfv_name).Date = data.Date;
        cockburn.(sitecode).(tfv_name).Data = data.Data * tfv_conv;
        cockburn.(sitecode).(tfv_name).Data_Raw = double(data.Data);
        cockburn.(sitecode).(tfv_name).Depth = data.Depth * -1;
        %cockburn.(sitecode).(tfv_name).QC = data.QC;
        cockburn.(sitecode).(tfv_name).X = header.X;
        cockburn.(sitecode).(tfv_name).Y = header.Y;
        cockburn.(sitecode).(tfv_name).Units = varkey.(header.Variable_ID).tfvUnits;
        
        [s,~,j] = unique(data.QC);
        cockburn.(sitecode).(tfv_name).QC = s{mode(j)};
        
        
        headerfield = fieldnames(header);
        
        for k = 1:length(headerfield)
            cockburn.(sitecode).(tfv_name).(headerfield{k}) = header.(headerfield{k});
        end
        
        
    end
    
end

save(outfile,'cockburn','-mat','-v7.3');


end

function data = import_datafile(filename)

fid = fopen(filename,'rt');


x  = 4;
textformat = [repmat('%s ',1,x)];
% read single line: number of x-values
datacell = textscan(fid,textformat,'Headerlines',1,'Delimiter',',');
fclose(fid);

data.Date = datenum(datacell{1},'dd-mm-yyyy HH:MM:SS');
data.Data = str2doubleq(datacell{3});
data.QC = datacell{4};

tdepth = datacell{2};

for i = 1:length(tdepth)
    xval = tdepth{i};
    spt = split(xval,'-');
    
    if length(spt) > 1
        depth(i,1) = str2double(spt{1});
        depth2(i,1) = str2double(spt{2});
        
        if (depth2(i,1) - depth(i,1)) < 0.3
            data.QC(i) = {'Possible PoreWater'};
            
        end
        
        
    else
        depth2(i,1) = NaN;
        depth(i,1) = str2double(spt{1});
    end
end

data.Depth = depth;

sss = find(~isnan(depth2) == 1);
if ~isempty(sss)
    data.Date = [data.Date;data.Date(sss)];
    data.Depth = [data.Depth;depth2(sss)];
    data.Data = [data.Data;data.Data(sss)];
    data.QC = [data.QC;data.QC(sss)];
end
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
            data.Site_Secription = sline{2};
            
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
