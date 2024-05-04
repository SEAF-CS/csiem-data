clear all; close all;
csiem_data_paths
basedir = [datapath,'mat/agency/']

filelist = dir(fullfile(basedir, '**/*.mat'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

for i = 1:length(filelist)

    export_matfile_2_parquet_flatfile([basedir,filelist(i).name]);
    
end



