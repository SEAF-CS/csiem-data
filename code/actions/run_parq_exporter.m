clear all; close all;

basedir = 'D:\csiem\data-warehouse\mat\agency\'

filelist = dir(fullfile(basedir, '**\*.mat'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

for i = 1:length(filelist)

    export_matfile_2_parquet_flatfile([basedir,filelist(i).name]);
    
end



