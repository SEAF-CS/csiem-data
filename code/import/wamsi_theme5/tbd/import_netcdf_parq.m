clear all; close all;

addpath(genpath('../../functions/'));

filepath = 'V:/data-lake/wamsi/wwmsp5/';

outdir = 'V:/data-warehouse/parq/wamsi/wwmsp5/';
mkdir(outdir);

filelist = dir(fullfile(filepath, '**\*.nc'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

% Conversion
%[snum,sstr] = xlsread('Conversions_mh.xlsx','A2:D1000');
load ../../actions/agency.mat;

agencyvars = fieldnames(agency.theme5);

% oldheader = sstr(:,1);
% newheader = sstr(:,3);
% conv = snum(:,1);

theme5 = [];

load ../../actions/varkey.mat;
allvars = fieldnames(varkey);

for i = 1:length(filelist)
    
    disp(filelist(i).name);
    
    filename = [filelist(i).folder,'/',filelist(i).name];
    
    headerfile = regexprep(filename,'.nc','.txt');
    
    
    
    thedepth = ncreadatt(filename,'/','Site_depth_at_deployment');
    
    disp(thedepth);
    
    tt = split(filelist(i).name,'_');
    
    site = tt{2};
    
    data = tfv_readnetcdf(filename);
    
    
    mtime = datenum(1950,01,01,00,00,00) + data.TIME;
    
    [X,Y] = ll2utm(data.LATITUDE,data.LONGITUDE);
    
    vars = fieldnames(data);
    
    %
    %
    for j = 1:length(vars)
        pdate = [];
        pdata = [];
        pdepth = {};
        %pQC = {};
        foundvar = 0;
        for k = 1:length(agencyvars)
            if strcmpi(agency.theme5.(agencyvars{k}).Old,vars{j}) == 1
                foundvar = k;
            end
        end
        
        if foundvar ~=0
            pdate = mtime;
            pdata = data.(vars{j}) * agency.theme5.(agencyvars{foundvar}).Conv;
            if isfield(data,'DEPTH')
                for ggg = 1:length(data.DEPTH)
                    pdepth(ggg,1) = {num2str(data.DEPTH(ggg))};
                end
            else
                pdepth(1:length(pdate),1) = {thedepth};
            end
            %pQC(1:length(pdate)) = {'n'};
            
            
            varname = varkey.(agency.theme5.(agencyvars{foundvar}).ID).Name;
            varunits = varkey.(agency.theme5.(agencyvars{foundvar}).ID).Unit;
            
            thetxt = ['_',regexprep(varname,' ','_'),'_DATA.parq'];
            datafile = regexprep(filelist(i).name,'.nc',thetxt);
            fullfile = [outdir,datafile];
            headerfile = regexprep(fullfile,'DATA.parq','HEADER.parq');
            
            
            DD.Date = datestr(datestr(pdate,'dd-mm-yyyy HH:MM:SS'));
            DD.Depth = pdepth;
            DD.Data = pdata;
            %DD.QC(:,1) = pQC;
            
            tdata = struct2table(DD);
            
            parquetwrite(fullfile,tdata);clear tdata;clear DD;
            
            header = {};
            header = table;
            
            
            %             fid = fopen(fullfile,'wt');
            %             fprintf(fid,'Date,Depth,Data,QC\n');
            %             for nn = 1:length(pdata)
            %                 fprintf(fid,'%s,%4.4f,%4.4f,%s\n',datestr(pdate(nn),'dd-mm-yyyy HH:MM:SS'),pdepth(nn),pdata(nn),pQC{nn});
            %             end
            %             fclose(fid);
            %
            %             fid = fopen(headerfile,'wt');
            ii = 1;
            header(ii,:) = {'Agency Name','Western Australian Marine Science Institution'};ii = ii + 1;
            header(ii,:) = {'Agency Code','WAMSI'};ii = ii + 1;
            header(ii,:) = {'Program','WAMSI Westport Marine Science Program'};ii = ii + 1;
            header(ii,:) = {'Project','WWMSP5.1'};ii = ii + 1;
            header(ii,:) = {'Data File Name',datafile};ii = ii + 1;
            header(ii,:) = {'Location',['data-warehouse/csv/wamsi/wwmsp5']};ii = ii + 1;
            %
            %
            header(ii,:) = {'Station Status','Static'};ii = ii + 1;
            header(ii,:) = {'Lat',num2str(data.LATITUDE)};ii = ii + 1;
            header(ii,:) = {'Long',num2str(data.LONGITUDE)};ii = ii + 1;
            header(ii,:) = {'Time Zone','GMT +8'};ii = ii + 1;
            header(ii,:) = {'Vertical Datum','mAHD'};ii = ii + 1;
            header(ii,:) = {'National Station ID',site};ii = ii + 1;
            header(ii,:) = {'Site Description',site};ii = ii + 1;
            header(ii,:) = {'Bad or Unavailable Data Value','NaN'};ii = ii + 1;
            header(ii,:) = {'Contact Email','Ivica Janekovic <ivica.janekovic@uwa.edu.au>'};ii = ii + 1;
            header(ii,:) = {'Variable ID',agency.theme5.(agencyvars{foundvar}).ID};ii = ii + 1;
            %
            header(ii,:) = {'Data Classification','WQ Sensor'};ii = ii + 1;
            %
            %
                         SD = mean(diff(pdate));
            %
            header(ii,:) = {'Sampling Rate (min)',num2str(SD * (60*24))};ii = ii + 1;
            %
            header(ii,:) = {'Date','dd-mm-yyyy HH:MM:SS'};ii = ii + 1;
            header(ii,:) = {'Depth','Decimal'};ii = ii + 1;
            %
                         thevar = [varname,' (',varunits,')'];
            %
            header(ii,:) = {'Variable',thevar};ii = ii + 1;
            header(ii,:) = {'QC','String'};ii = ii + 1;
            %
            %             fclose(fid);
            
            parquetwrite(headerfile,header);clear header;

            
            
        end
        
        
        
        
    end
end
%             if ~isfield(theme5,site)
%                 theme5.(site).(newheader{sss}).Date(:,1) = mtime;
%                 theme5.(site).(newheader{sss}).Data(:,1) = data.(vars{j}) * conv(sss);
%                 if isfield(data,'DEPTH')
%
%                     theme5.(site).(newheader{sss}).Depth(:,1) = data.DEPTH * -1;
%                 else
%                     theme5.(site).(newheader{sss}).Depth(1:length(mtime),1) = 0;
%                 end
%
%                 theme5.(site).(newheader{sss}).X = X;
%                 theme5.(site).(newheader{sss}).Y = Y;
%                 theme5.(site).(newheader{sss}).Title = site;
%                 theme5.(site).(newheader{sss}).Variable_Name = vars{j};
%                 theme5.(site).(newheader{sss}).Units = '';
%
%             else
%                 if isfield(theme5.(site),newheader{sss})
%                     theme5.(site).(newheader{sss}).Date = [theme5.(site).(newheader{sss}).Date;mtime];
%                     theme5.(site).(newheader{sss}).Data = [theme5.(site).(newheader{sss}).Data;data.(vars{j}) * conv(sss)];
%
%                     if isfield(data,'DEPTH')
%
%                         theme5.(site).(newheader{sss}).Depth = [theme5.(site).(newheader{sss}).Depth;data.DEPTH * -1];
%                     else
%                         dd(1:length(mtime),1) = 0;
%                         theme5.(site).(newheader{sss}).Depth = [theme5.(site).(newheader{sss}).Depth;dd];clear dd;
%                     end
%                 else
%                     theme5.(site).(newheader{sss}).Date(:,1) = mtime;
%                     theme5.(site).(newheader{sss}).Data(:,1) = data.(vars{j}) * conv(sss);
%                     if isfield(data,'DEPTH')
%
%                         theme5.(site).(newheader{sss}).Depth(:,1) = data.DEPTH * -1;
%                     else
%                         theme5.(site).(newheader{sss}).Depth(1:length(mtime),1) = 0;
%                     end
%
%                     theme5.(site).(newheader{sss}).X = X;
%                     theme5.(site).(newheader{sss}).Y = Y;
%                     theme5.(site).(newheader{sss}).Title = site;
%                     theme5.(site).(newheader{sss}).Variable_Name = vars{j};
%                     theme5.(site).(newheader{sss}).Units = '';
%                 end
%             end









%         end
%
%     end


% sites = fieldnames(theme5);
%
% for i = 1:length(sites)
%     vars = fieldnames(theme5.(sites{i}));
%     for j = 1:length(vars)
%         [theme5.(sites{i}).(vars{j}).Date,int] = sort(theme5.(sites{i}).(vars{j}).Date);
%         theme5.(sites{i}).(vars{j}).Data = theme5.(sites{i}).(vars{j}).Data(int);
%         theme5.(sites{i}).(vars{j}).Depth = theme5.(sites{i}).(vars{j}).Depth(int);
%     end
% end




% save theme5.mat theme5 -mat -v7.3;
%
%
% load swan_new.mat;
%
% for i = 1:length(sites)
%
%         swan.(sites{i}) = theme5.(sites{i});
%
% end
% save swan_new_2.mat swan -mat -v7.3;
