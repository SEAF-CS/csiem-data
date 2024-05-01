clear all; close all;

ldata = readtable('light_processing_curtain_dates.csv');

outfile = 'all_data_processed_2weeks_5km_r.csv';

fid = fopen(outfile,'wt');

fprintf(fid,['Date,time,Station,K_490,Max_Depth,R_sq,Secchi Depth (m),Count,Light Attenuation Coefficient (m-1),Count,Turbidity (NTU),Count,' ...
    'Chlorophyll-a (µg/l),Count,Total Suspended Solids (mg/L),Count,Particulate Organic Carbon (mg/L),Count,Total Suspended Solids (mg/L),Count\n']);
days = datenum(ldata.date);
hours = datenum(ldata.time);
mdate = days + hours;


% "Chlorophyll-a (µg/l)"
%     "Light Attenuation Coefficient (m-1)"
%     "Secchi Depth (m)"
%     "Spectral Radiative Flux (WL - 410µW) (µW/cm2/nm)"
%     "Spectral Radiative Flux (WL - 440µW) (µW/cm2/nm)"
%     "Spectral Radiative Flux (WL - 490µW) (µW/cm2/nm)"
%     "Spectral Radiative Flux (WL - 510µW) (µW/cm2/nm)"
%     "Spectral Radiative Flux (WL - 550µW) (µW/cm2/nm)"
%     "Spectral Radiative Flux (WL - 590µW) (µW/cm2/nm)"
%     "Spectral Radiative Flux (WL - 635µW) (µW/cm2/nm)"
%     "Spectral Radiative Flux (WL - 660µW) (µW/cm2/nm)"
%     "Spectral Radiative Flux (WL - 700µW) (µW/cm2/nm)"
%     "Turbidity (NTU)"
search_vars = {...
'Secchi Depth (m)';...
'Light Attenuation Coefficient (m-1)';...
'Turbidity (NTU)';...
'Chlorophyll-a (µg/l)';...
'Total Suspended Solids (mg/L)';...
'Particulate Organic Carbon (mg/L)';...
'Total Suspended Solids (mg/L)';...
};

datadir = 'processed_5km\';

filelist = dir(fullfile(datadir, '**\*.parq'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list
disp('loading data.......');
for i = 1:length(filelist)
    thedata.(['pq_',regexprep(filelist(i).name,'.parq','')]) = parquetread([datadir,filelist(i).name]);
end
disp('finished loading data.......');


for i = 1:length(mdate)
    
    disp(['Searching ',num2str(i),' of ',num2str(length(mdate))]);

    fprintf(fid,'%s,%s,%d,%4.4f,%4.4f,%4.4f,',ldata.date(i),ldata.time(i),ldata.station(i),ldata.K_490(i),ldata.max_depth(i),ldata.R_sq(i));

    SID = ldata.station(i);
    thetime = mdate(i);
    %pdata = parquetread(['processed_2km\',num2str(SID),'.parq']);
    pdata = thedata.(['pq_',num2str(SID)]);

    for k = 1:length(search_vars)

        sss = find(pdata.mdate >= mdate(i) - 7 & ...
            pdata.mdate <= mdate(i) + 7 & ...
            strcmpi(pdata.Variable_Name,search_vars{k}) == 1);

        if ~isempty(sss)
            SD_T = pdata.Data(sss);
            SD = std(SD_T(~isnan(SD_T)));
            fprintf(fid,'%4.4f,%4.4f,',mean(pdata.Data(sss)),length(sss));
        else
            fprintf(fid,'NaN,NaN,');
        end
    end
    fprintf(fid,'\n');
end
fclose(fid);
    