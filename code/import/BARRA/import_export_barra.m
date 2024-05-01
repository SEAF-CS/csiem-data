clear all; close all;

addpath(genpath('../../functions/'));


filepath = 'Y:\csiem\Model\Barra\';

filelist = dir(fullfile(filepath, '**\*.nc'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

metshp = shaperead('..\..\..\data-mapping\By Theme\Met\data locations_met.shp');

outdir = 'D:\Cloud\AED Dropbox\AED_Cockburn_db\CSIEM\Data\data-swamp\BOM\barra_tfv\';mkdir(outdir)

for i = 1:length(filelist)
    
    filename = [filelist(i).folder,'\',filelist(i).name];
    
    lat = ncread(filename,'latitude');
    lon = ncread(filename,'longitude');
    ltime = double(ncread(filename,'local_time'));
    mtime = datenum(1990,01,01) + (ltime/24);
    
    dv = datevec(mtime(end-100));
    theyear = num2str(dv(1));
    
    thedata = tfv_readnetcdf(filename,'names',{'uwnd10m';'vwnd10m';'mslp';'lwsfcdown';'swsfcdown';'temp_scrn';'precip_rate';'relhum'});
    
    vars = fieldnames(thedata);
    for mm = 1:length(metshp)
        mlat = metshp(mm).Latitude;
        mlon = metshp(mm).Longitude;
        
        [~,ind_lat] = min(abs(lat - mlat));
        [~,ind_lon] = min(abs(lon - mlon));
        
        fid = fopen([outdir,'BARRA_',theyear,'_',metshp(mm).AED_ID,'.csv'],'wt');
        
        fprintf(fid,'Time,');
        for j = 4:length(vars)
            if j == length(vars)
                fprintf(fid,'%s\n',vars{j});
            else
                fprintf(fid,'%s,',vars{j});
            end
        end
        for k = 1:length(mtime)
            fprintf(fid,'%s,',datestr(mtime(k),'yyyy-mm-dd HH:MM:SS'));
            for j = 4:length(vars)
                if j == length(vars)
                    fprintf(fid,'%6.6f\n',thedata.(vars{j})(ind_lon,ind_lat,k));
                else
                    fprintf(fid,'%6.6f,',thedata.(vars{j})(ind_lon,ind_lat,k));
                end
            end
        end
        
        fclose(fid);
    end
end