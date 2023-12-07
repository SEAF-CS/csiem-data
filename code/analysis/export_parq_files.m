datadir = 'processed_2km\';

filelist = dir(fullfile(datadir, '**\*.parq'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list
disp('loading data.......');
for i = 1:length(filelist)
    tab = parquetread([datadir,filelist(i).name]);
    writetable(tab,[datadir,regexprep(filelist(i).name,'.parq','.csv')])
end
disp('finished loading data.......');
