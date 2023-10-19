%function csv_2_matfile_tfv_v2

addpath(genpath('../functions/'));

load varkey.mat;
runlocal = 1;
tempfile = 'cockburn.mat';

if ~runlocal
    
    outfile = 'V:/data-warehouse/mat/cockburn.mat';
    
    filepath = 'V:/data-warehouse/csv/';
    
else
    
    outfile = 'D:\csiem\data-warehouse/mat/cockburn.mat';
    filepath ='D:\csiem\data-warehouse/csv/';
    
end

% exclude_list = {...
%      'bom',...
%      'dot',...
%      'wamsi',...
%     };
exclude_list = [];


filelist = dir(fullfile(filepath, '**\*HEADER.csv'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

vars = fieldnames(varkey);


fid = fopen('excluded_sites.csv','wt');

cockburn = [];

for i = 1:length(filelist)
    
    excluded = 0;
    if ~isempty(exclude_list)
        for lll = 1:length(exclude_list)
            kk = strfind(filelist(i).folder,exclude_list{lll});
            if kk > 1
                excluded = 1;
            end
        end
    end
    
    if excluded == 0
        headerfile = [filelist(i).folder,'\',filelist(i).name];
        
        datafile = regexprep(headerfile,'HEADER','DATA');
        
        disp(['Importing: ',filelist(i).name]);
        
        header = import_header(headerfile);
        smd = import_header_smd(regexprep(headerfile,'HEADER','SMD'));
        header.calc_SMD = smd.calc_SMD;
        header.mAHD = smd.mAHD;
        
        program = regexprep(header.Program_Code,'-','_');

        agency = header.Agency_Code;
        
        
        
        sitecode = [agency,'_',program,'_',header.Station_ID];
        sitecode = regexprep(sitecode,'\.','');
        sitecode = [sitecode,'_',header.Deployment,'_',num2str(i)];
        sitecode = regexprep(sitecode,'-','_');
        %sitecode = [agency,'_',num2str(randi(10000,1))];
        %sitecode = [agency,'_',num2str(i)];
        tfv_name = varkey.(header.Variable_ID).tfvName;
        tfv_conv = varkey.(header.Variable_ID).tfvConv;
        
        
        
        if strcmpi(tfv_name,'N/A') == 0
            
            data = import_datafile(datafile);
            
%             if isfield(data,'Height')
%                 data.Depth = data.Height;
%             end
            
            [s,~,j] = unique(data.QC);
            QC_CODE = s{mode(j)};
            
            if isfield(cockburn,sitecode)
                
                if ~isfield(cockburn.(sitecode),tfv_name)
                    
                    
                    cockburn.(sitecode).(tfv_name).QC = QC_CODE;
                    
                    cockburn.(sitecode).(tfv_name).Date = data.Date;
                    cockburn.(sitecode).(tfv_name).Data = data.Data * tfv_conv;
                    cockburn.(sitecode).(tfv_name).Data_Raw = double(data.Data);
                     if isfield(data,'Depth')
                        cockburn.(sitecode).(tfv_name).Depth = data.Depth;% * -1;
                     else
                         cockburn.(sitecode).(tfv_name).Height = data.Height;% * -1;
                     end
%                     cockburn.(sitecode).(tfv_name).Depth_T = data.Depth_T * -1;
%                     cockburn.(sitecode).(tfv_name).Depth_B = data.Depth_B * -1;
                    
                    cockburn.(sitecode).(tfv_name).X = header.Lon;
                    cockburn.(sitecode).(tfv_name).Y = header.Lat;
                    cockburn.(sitecode).(tfv_name).XUTM = header.X;
                    cockburn.(sitecode).(tfv_name).YUTM = header.Y;
                    cockburn.(sitecode).(tfv_name).Units = varkey.(header.Variable_ID).tfvUnits;
                    
                    
                    
                    
                    
                    
                    headerfield = fieldnames(header);
                    
                    for k = 1:length(headerfield)
                        cockburn.(sitecode).(tfv_name).(headerfield{k}) = header.(headerfield{k});
                    end
                    
                    cockburn.(sitecode).(tfv_name).X = cockburn.(sitecode).(tfv_name).Lon;
                    cockburn.(sitecode).(tfv_name).Y = cockburn.(sitecode).(tfv_name).Lat;
                    cockburn.(sitecode).(tfv_name).Agency = cockburn.(sitecode).(tfv_name).Tag;
                else
                    cockburn.(sitecode).(tfv_name).Date = [cockburn.(sitecode).(tfv_name).Date;data.Date];
                    cockburn.(sitecode).(tfv_name).Data = [cockburn.(sitecode).(tfv_name).Data;data.Data * tfv_conv];
                    cockburn.(sitecode).(tfv_name).Data_Raw = [cockburn.(sitecode).(tfv_name).Data_Raw;double(data.Data)];
                    
                    if isfield(data,'Depth')
                        cockburn.(sitecode).(tfv_name).Depth = [cockburn.(sitecode).(tfv_name).Depth;data.Depth];
                     else
                         cockburn.(sitecode).(tfv_name).Height = [cockburn.(sitecode).(tfv_name).Height;data.Height];
                     end
%                     cockburn.(sitecode).(tfv_name).Depth_T = [cockburn.(sitecode).(tfv_name).Depth_T;data.Depth_T * -1];
%                     cockburn.(sitecode).(tfv_name).Depth_B = [cockburn.(sitecode).(tfv_name).Depth_B;data.Depth_B * -1];
                    
                end
                
            else
                
                
                cockburn.(sitecode).(tfv_name).QC = QC_CODE;
                
                cockburn.(sitecode).(tfv_name).Date = data.Date;
                cockburn.(sitecode).(tfv_name).Data = data.Data * tfv_conv;
                cockburn.(sitecode).(tfv_name).Data_Raw = double(data.Data);
                     if isfield(data,'Depth')
                        cockburn.(sitecode).(tfv_name).Depth = data.Depth;% * -1;
                     else
                         cockburn.(sitecode).(tfv_name).Height = data.Height;% * -1;
                     end                
%                 cockburn.(sitecode).(tfv_name).Depth_T = data.Depth_T * -1;
%                 cockburn.(sitecode).(tfv_name).Depth_B = data.Depth_B * -1;
                

                cockburn.(sitecode).(tfv_name).XUTM = header.X;
                cockburn.(sitecode).(tfv_name).YUTM = header.Y;
                cockburn.(sitecode).(tfv_name).Units = varkey.(header.Variable_ID).tfvUnits;
                
                
                
                
                headerfield = fieldnames(header);
                
                for k = 1:length(headerfield)
                    
                    cockburn.(sitecode).(tfv_name).(headerfield{k}) = header.(headerfield{k});
                end
                cockburn.(sitecode).(tfv_name).X = cockburn.(sitecode).(tfv_name).Lon;
                cockburn.(sitecode).(tfv_name).Y = cockburn.(sitecode).(tfv_name).Lat;
                cockburn.(sitecode).(tfv_name).Agency = cockburn.(sitecode).(tfv_name).Tag;
                
            end
            
            
            
            %cockburn.(sitecode).(tfv_name).QC = data.QC;
            
            
            
        end
        
    else
        disp(filelist(i).folder);
    end
    
end

fclose(fid);

% sites = fieldnames(cockburn);
% 
% for i = 1:length(sites)
%     vars = fieldnames(cockburn.(sites{i}));
%     for j = 1:length(vars)
%         
%         datachx = sum(~isnan(cockburn.(sites{i}).(vars{j}).Depth_T));
%         
%         if datachx == 0
%             cockburn.(sites{i}).(vars{j}) = rmfield(cockburn.(sites{i}).(vars{j}),'Depth_T');
%             cockburn.(sites{i}).(vars{j}) = rmfield(cockburn.(sites{i}).(vars{j}),'Depth_B');
%             
%             disp('No INT found');
%             
%             cockburn.(sites{i}).(vars{j}).Depth_Integrated = 0;
%             
%         else
%             cockburn.(sites{i}).(vars{j}).Depth_Integrated = 1;
%             %cockburn.(sites{i}).(vars{j}).Data_Classification = [cockburn.(sites{i}).(vars{j}).Data_Classification,' INT'];
%         end
%     end
% end
% for i = 1:length(sites)
%     vars = fieldnames(cockburn.(sites{i}));
%     for j = 1:length(vars)
%         
%         [cockburn.(sites{i}).(vars{j}).Date,dint]  = sort(cockburn.(sites{i}).(vars{j}).Date);
%         cockburn.(sites{i}).(vars{j}).Data = cockburn.(sites{i}).(vars{j}).Data(dint);
%         cockburn.(sites{i}).(vars{j}).Data_Raw = cockburn.(sites{i}).(vars{j}).Data_Raw(dint);
%         cockburn.(sites{i}).(vars{j}).Depth = cockburn.(sites{i}).(vars{j}).Depth(dint);
%         if isfield(cockburn.(sites{i}).(vars{j}),'Depth_T')
%             cockburn.(sites{i}).(vars{j}).Depth_T = cockburn.(sites{i}).(vars{j}).Depth_T(dint);
%             cockburn.(sites{i}).(vars{j}).Depth_B = cockburn.(sites{i}).(vars{j}).Depth_B(dint);
%         end
%     end
% end
% 
% sites = fieldnames(cockburn);
% 
% for i = 1:length(sites)
%     vars = fieldnames(cockburn.(sites{i}));
%     for j = 1:length(vars)
%         cockburn.(sites{i}).(vars{j}) = rmfield(cockburn.(sites{i}).(vars{j}),'Data_Raw');
%     end
% end
% sites = fieldnames(cockburn);
% 
% for i = 1:length(sites)
%     vars = fieldnames(cockburn.(sites{i}));
%     if isfield(cockburn.(sites{i}),'COND') & ~isfield(cockburn.(sites{i}),'SAL') & isfield(cockburn.(sites{i}),'TEMP')
%         cockburn.(sites{i}).SAL = cockburn.(sites{i}).COND;
%         disp(['Converting ',sites{i},' Salinity']);
%         for bfg = 1:length(cockburn.(sites{i}).SAL.Data)
%             sss = find(cockburn.(sites{i}).TEMP.Date == cockburn.(sites{i}).SAL.Date(bfg) + ...
%                 cockburn.(sites{i}).TEMP.Depth == cockburn.(sites{i}).SAL.Depth(bfg));
%             if ~isempty(sss)
%                 disp('Real Temp');
%                 cockburn.(sites{i}).SAL.Data(bfg) = cond2sal(cockburn.(sites{i}).COND.Data(bfg),cockburn.(sites{i}).TEMP.Data(sss));
%             else
%                 disp('Fake Temp');
%                 cockburn.(sites{i}).SAL.Data(bfg) = cond2sal(cockburn.(sites{i}).COND.Data(bfg),25);
%             end
%             
%         end
%                 
%         cockburn.(sites{i}).SAL.Variable_name = 'Salinity';
%         cockburn.(sites{i}).SAL.Units = {'psu'};
%         
%     end
%     
% end

save(tempfile,'cockburn','-mat','-v7.3');

copyfile(tempfile,outfile,'f');

delete(tempfile);

% mkdir('Summary/Images');
% mkdir('Summary/GIS');

% summerise_data(outfile,'Summary/Images/','Summary/GIS/','cockbun.shp');
%end

% function data = import_datafile(filename)
% 
% fid = fopen(filename,'rt');
% 
% 
% x  = 4;
% textformat = [repmat('%s ',1,x)];
% % read single line: number of x-values
% datacell = textscan(fid,textformat,'Headerlines',1,'Delimiter',',');
% fclose(fid);
% 
% data.Date = datenum(datacell{1},'dd-mm-yyyy HH:MM:SS');
% data.Data = str2doubleq(datacell{3});
% data.QC = datacell{4};
% data.Depth_RAW = datacell{2};
% tdepth = datacell{2};
% 
% for i = 1:length(tdepth)
%     xval = tdepth{i};
%     spt = split(xval,'-');
%     
%     if length(spt) > 1
%         
%         depth1(i,1) = str2double(spt{1});
%         depth2(i,1) = str2double(spt{2});
%         
%         try
%             depth(i,1) = (depth1(i,1) + depth2(i,1)) /2;
%         catch
%             depth1(i,1)
%             depth2(i,1)
%             stop
%         end
%         %         if (depth2(i,1) - depth(i,1)) < 0.3
%         %             data.QC(i) = {'Possible PoreWater'};
%         %
%         %         end
%         
%         
%     else
%         depth1(i,1) = NaN;
%         depth2(i,1) = NaN;
%         depth(i,1) = str2double(spt{1});
%     end
% end
% 
% data.Depth = depth;
% data.Depth_T = depth1;
% data.Depth_B = depth2;
% 
% % sss = find(~isnan(depth2) == 1);
% % if ~isempty(sss)
% %     data.Date = [data.Date;data.Date(sss)];
% %     data.Depth = [data.Depth;depth2(sss)];
% %     data.Data = [data.Data;data.Data(sss)];
% %     data.QC = [data.QC;data.QC(sss)];
% % end
% end
% 
% 
% 
% function data = import_header(filename)
% 
% fid = fopen(filename,'rt');
% 
% while ~feof(fid)
%     fline = fgetl(fid);
%     sline = split(fline,',');
%     
%     switch sline{1}
%         case 'Agency Name'
%             data.Agency_Name = sline{2};
%         case 'Tag'
%             data.Tag = sline{2};            
%         case 'Agency Code'
%             data.Agency_Code = sline{2};
%             
%         case 'Program'
%             data.Program_Name = sline{2};
%             
%         case 'Project'
%             data.Program_Code = sline{2};
%             
%         case 'Data File Name'
%             data.Data_File_Name = sline{2};
%             
%         case 'Location'
%             data.Data_File_Location = sline{2};
%             
%         case 'Station Status'
%             data.Status = sline{2};
%             
%         case 'Lat'
%             data.Lat = str2num(sline{2});
%             
%         case 'Long'
%             data.Lon = str2num(sline{2});
%             
%         case 'Time Zone'
%             data.Time_Zone = sline{2};
%             
%         case 'Vertical Datum'
%             data.Vertical_Datum = sline{2};
%             
%         case 'National Station ID'
%             data.Station_ID = sline{2};
%             
%         case 'Site Description'
%             data.Site_Description = sline{2};
%             
%         case 'Bad or Unavailable Data Value'
%             data.Bad_Data_Code = sline{2};
%             
%         case 'Contact Email'
%             data.Email = sline{2};
%             
%         case 'Variable ID'
%             data.Variable_ID = sline{2};
%             
%         case 'Data Classification'
%             data.Data_Classification = sline{2};
%             
%         case 'Sampling Rate (min)'
%             data.Sampling_Rate = sline{2};
%             
%         case 'Date'
%             data.Date_Format = sline{2};
%             
%         case 'Depth'
%             data.Depth_Format = sline{2};
%             
%         case 'Variable'
%             data.Variable_Name = sline{2};
%             
%         case 'QC'
%             data.QC_Code = sline{2};
%             
%         otherwise
%             disp('Header not found');
%             stop;
%     end
%     
%     
%     
%     
% end
% 
% 
% [data.X,data.Y] = ll2utm(data.Lat,data.Lon);
% fclose(fid);
% 
% end
