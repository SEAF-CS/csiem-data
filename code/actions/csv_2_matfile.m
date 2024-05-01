function csv_2_matfile

addpath(genpath('../functions/'));

load varkey.mat;

runlocal = 1;
tempfile = 'seaf.mat';

if ~runlocal
    
    outfile = 'V:/data-warehouse/mat/seaf.mat';
    
    filepath = 'V:/data-warehouse/csv/';
    
else
    
    outfile = 'D:/csiem/data-warehouse/mat/seaf.mat';
    filepath = 'D:/csiem/data-warehouse/csv/';
    
end

exclude_list = {...
    'bom',...
    'wamsi',...
    'csmc',...
    'dot',...
    };


%filepath = 'C:\Users\00065525\Github\csiem-data\code\import\MAFRL\csmcwq-mafrl\';

filelist = dir(fullfile(filepath, '**\*HEADER.csv'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

vars = fieldnames(varkey);


fid = fopen('excluded_sites.csv','wt');

seaf = [];

for i = 1:length(filelist)
    
        excluded = 0;
        
            for lll = 1:length(exclude_list)
        kk = strfind(filelist(i).folder,exclude_list{lll});
        if kk > 1
            excluded = 1;
        end
    end
    if excluded == 0

    headerfile = [filelist(i).folder,'\',filelist(i).name];
    
    datafile = regexprep(headerfile,'HEADER','DATA');
    
    disp(['Importing: ',filelist(i).name]);
    
    header = import_header(headerfile);
    
    agency = header.Agency_Code;
    program = header.Program_Code;
    sitecode = [agency,'_',program,'_',header.Station_ID];
    tfv_name = header.Variable_ID;
    %tfv_conv = varkey.(header.Variable_ID).tfvConv;
    
    
    
    %if strcmpi(tfv_name,'N/A') == 0
    
    data = import_datafile(datafile);
    [s,~,j] = unique(data.QC);
    QC_CODE = s{mode(j)};
    
    if isfield(seaf,sitecode)
        
        if ~isfield(seaf.(sitecode),tfv_name)
            
            
            seaf.(sitecode).(tfv_name).QC = QC_CODE;
            
            seaf.(sitecode).(tfv_name).Date = data.Date;
            seaf.(sitecode).(tfv_name).Data = data.Data;
            seaf.(sitecode).(tfv_name).Data_Raw = double(data.Data);
            seaf.(sitecode).(tfv_name).Depth = data.Depth * -1;
            seaf.(sitecode).(tfv_name).Depth_T = data.Depth_T * -1;
            seaf.(sitecode).(tfv_name).Depth_B = data.Depth_B * -1;
            
            seaf.(sitecode).(tfv_name).X = header.X;
            seaf.(sitecode).(tfv_name).Y = header.Y;
            %seaf.(sitecode).(tfv_name).Units = varkey.(header.Variable_ID).tfvUnits;
            
            
            
            
            
            
            headerfield = fieldnames(header);
            
            for k = 1:length(headerfield)
                seaf.(sitecode).(tfv_name).(headerfield{k}) = header.(headerfield{k});
                
            end
            seaf.(sitecode).(tfv_name).Sentient_Hubs_Code = varkey.(header.Variable_ID).SH;
            seaf.(sitecode).(tfv_name).Units = varkey.(header.Variable_ID).Unit;

        else
            seaf.(sitecode).(tfv_name).Date = [seaf.(sitecode).(tfv_name).Date;data.Date];
            seaf.(sitecode).(tfv_name).Data = [seaf.(sitecode).(tfv_name).Data;data.Data];
            seaf.(sitecode).(tfv_name).Data_Raw = [seaf.(sitecode).(tfv_name).Data_Raw;double(data.Data)];
            seaf.(sitecode).(tfv_name).Depth = [seaf.(sitecode).(tfv_name).Depth;data.Depth * -1];
            
            seaf.(sitecode).(tfv_name).Depth_T = [seaf.(sitecode).(tfv_name).Depth_T;data.Depth_T * -1];
            seaf.(sitecode).(tfv_name).Depth_B = [seaf.(sitecode).(tfv_name).Depth_B;data.Depth_B * -1];
            
        end
        
    else
        
        
        seaf.(sitecode).(tfv_name).QC = QC_CODE;
        
        seaf.(sitecode).(tfv_name).Date = data.Date;
        seaf.(sitecode).(tfv_name).Data = data.Data;
        seaf.(sitecode).(tfv_name).Data_Raw = double(data.Data);
        seaf.(sitecode).(tfv_name).Depth = data.Depth * -1;
        
        seaf.(sitecode).(tfv_name).Depth_T = data.Depth_T * -1;
        seaf.(sitecode).(tfv_name).Depth_B = data.Depth_B * -1;
        
        seaf.(sitecode).(tfv_name).X = header.X;
        seaf.(sitecode).(tfv_name).Y = header.Y;
        %seaf.(sitecode).(tfv_name).Units = varkey.(header.Variable_ID).tfvUnits;
        
        
        
        
        headerfield = fieldnames(header);
        
        for k = 1:length(headerfield)
            seaf.(sitecode).(tfv_name).(headerfield{k}) = header.(headerfield{k});
        end
        seaf.(sitecode).(tfv_name).Sentient_Hubs_Code = varkey.(header.Variable_ID).SH;
        seaf.(sitecode).(tfv_name).Units = varkey.(header.Variable_ID).Unit;
    end
    
    
    
    %cockburn.(sitecode).(tfv_name).QC = data.QC;
    
    
    
    else
        disp(filelist(i).folder);
    end    
end

fclose(fid);

sites = fieldnames(seaf);

for i = 1:length(sites)
    vars = fieldnames(seaf.(sites{i}));
    for j = 1:length(vars)
        
        datachx = sum(~isnan(seaf.(sites{i}).(vars{j}).Depth_T));
        
        if datachx == 0
            seaf.(sites{i}).(vars{j}) = rmfield(seaf.(sites{i}).(vars{j}),'Depth_T');
            seaf.(sites{i}).(vars{j}) = rmfield(seaf.(sites{i}).(vars{j}),'Depth_B');
            
            disp('No INT found');
            
            seaf.(sites{i}).(vars{j}).Depth_Integrated = 0;
            
        else
            seaf.(sites{i}).(vars{j}).Depth_Integrated = 1;
            %cockburn.(sites{i}).(vars{j}).Data_Classification = [cockburn.(sites{i}).(vars{j}).Data_Classification,' INT'];
        end
    end
end
for i = 1:length(sites)
    vars = fieldnames(seaf.(sites{i}));
    for j = 1:length(vars)
        
        [seaf.(sites{i}).(vars{j}).Date,dint]  = sort(seaf.(sites{i}).(vars{j}).Date);
        seaf.(sites{i}).(vars{j}).Data = seaf.(sites{i}).(vars{j}).Data(dint);
        seaf.(sites{i}).(vars{j}).Data_Raw = seaf.(sites{i}).(vars{j}).Data_Raw(dint);
        seaf.(sites{i}).(vars{j}).Depth = seaf.(sites{i}).(vars{j}).Depth(dint);
        if isfield(seaf.(sites{i}).(vars{j}),'Depth_T')
            seaf.(sites{i}).(vars{j}).Depth_T = seaf.(sites{i}).(vars{j}).Depth_T(dint);
            seaf.(sites{i}).(vars{j}).Depth_B = seaf.(sites{i}).(vars{j}).Depth_B(dint);
        end
    end
end

save(tempfile,'seaf','-mat','-v7.3');

copyfile(tempfile,outfile,'f');

%delete(tempfile);
%save(outfile,'seaf','-mat','-v7.3');


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

% sss = find(~isnan(depth2) == 1);
% if ~isempty(sss)
%     data.Date = [data.Date;data.Date(sss)];
%     data.Depth = [data.Depth;depth2(sss)];
%     data.Data = [data.Data;data.Data(sss)];
%     data.QC = [data.QC;data.QC(sss)];
% end
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
