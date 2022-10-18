clear all; close all;

addpath(genpath('../../functions/'));

filepath = '../../../data-lake/wamsi/wwmsp5/';

outdir = '../../../data-warehouse/csv/wamsi/wwmsp5/';


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

load ../../actions/varskey.mat;
allvars = fieldnames(varkey);

for i = 1:length(filelist)
    
    disp(filelist(i).name);
    
    filename = [filelist(i).folder,'/',filelist(i).name];
    
    headerfile = regexprep(filename,'.nc','.txt');
    
    
    
    tt = split(filelist(i).name,'_');
    
    site = tt{2};
    
    data = tfv_readnetcdf(filename);
    
    
    mtime = datenum(1950,01,01,00,00,00) + data.TIME;
    
    [X,Y] = ll2utm(data.LATITUDE,data.LONGITUDE);
    
    vars = fieldnames(data);
    
    for j = 1:length(vars)
        
        %sss = find(strcmpi(oldheader,vars{j}) == 1);
        
        sss = []; 
        
        for kk = 1:length(agencyvars)
        
            if strcmpi(agency.theme5.(agencyvars{kk}).Old,vars{j}) == 1
                sss = kk;
            end
        end
        if ~isempty(sss)
            
            for k = 1:length(allvars)
                
                %theme5.(site).(newheader{sss}).Date(:,1) = mtime;
                
                if strcmpi(varkey.(allvars{k}).tfvName,newheader{sss}) == 1
                
                    
                    
                
            
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
            
            
            
            
            
            
            
            
            
        end
        
    end
    
end

sites = fieldnames(theme5);

for i = 1:length(sites)
    vars = fieldnames(theme5.(sites{i}));
    for j = 1:length(vars)
        [theme5.(sites{i}).(vars{j}).Date,int] = sort(theme5.(sites{i}).(vars{j}).Date);
        theme5.(sites{i}).(vars{j}).Data = theme5.(sites{i}).(vars{j}).Data(int);
        theme5.(sites{i}).(vars{j}).Depth = theme5.(sites{i}).(vars{j}).Depth(int);
    end
end




save theme5.mat theme5 -mat -v7.3;
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
