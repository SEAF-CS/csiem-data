clear all; close all;

addpath(genpath('../../functions/'));

filepath = 'V:/data-lake/wamsi/wwmsp5/';

outdir = 'V:/data-warehouse/csv/wamsi/wwmsp5/';


filelist = dir(fullfile(filepath, '**\*.nc'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

vars = [];

for i = 1:length(filelist)
    
    %disp(filelist(i).name);
    
    filename = [filelist(i).folder,'/',filelist(i).name];
    
    headerfile = regexprep(filename,'\.nc','.txt');
    
    
    
    tt = split(filelist(i).name,'_');
    
    site = tt{2};
    
    data1 = tfv_readnetcdf(filename);
    
    vars = [vars;fieldnames(data1)];
    
%     if isfield(data,'DEPTH')
%         length(data.DEPTH)
%     end
    if isfield(data1,'NOMINAL_DEPTH')
%         length(data.NOMINAL_DEPTH)
%         data.NOMINAL_DEPTH
                 
        ncdisp(filename);
         %stop
        
    end
    
    if ~isfield(data1,'DEPTH') & ~isfield(data1,'NOMINAL_DEPTH')
        ncdisp(filename);
        %filename
        stop
    end
    
end
uvars = unique(vars);


