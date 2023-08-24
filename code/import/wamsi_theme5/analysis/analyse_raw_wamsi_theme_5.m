clear all; close all;

addpath(genpath('../../../functions/'));

dirpath = 'Y:\WAMSI\Theme 5\WAMSI_Westport_Theme5\';

dirlist = dir(dirpath);

fid = fopen('Theme5.txt','wt');

for i = 3:length(dirlist)
    fprintf(fid,'%s,\n',dirlist(i).name);
    fprintf(fid,'\n');
    dirlist_a = dir([dirpath,dirlist(i).name,'\']);
    
    for j = 3:length(dirlist_a)
        
    
    if strcmpi(dirlist_a(j).name,'raw_data') == 0;
        
        
        fprintf(fid,'%s,\n',[dirpath,dirlist(i).name,'\',dirlist_a(j).name]);
        
        data = tfv_infonetcdf([dirpath,dirlist(i).name,'\',dirlist_a(j).name]);
        
        for k = 1:length(data)
            fprintf(fid,'%s,\n',data{k});
        end
    end
    fprintf(fid,'\n');
    end
    fprintf(fid,'\n');
    fprintf(fid,'\n');
    fprintf(fid,'\n');
end

fclose(fid);
    
    
    
    
    
    
    
    
    