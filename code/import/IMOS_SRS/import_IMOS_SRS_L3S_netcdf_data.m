function import_IMOS_SRS_L3S_netcdf_data
addpath(genpath('../../functions'));

load ../../actions/varkey.mat;
load ../../actions/agency.mat;

shp = shaperead('sat_boundary.shp');


% ______________________________________________________
% TEMP
run('../../actions/csiem_data_paths.m')
ncname = [datapath,'data-lake/IMOS/SRS/L3S/L3S-single-1day-night/IMOS_aggregation_20231212T044624Z.nc'];

outdir = [datapath,'data-warehouse/csv/imos/srs/l3s/'];mkdir(outdir);

data = tfv_readnetcdf(ncname);

mdate = double(datenum(1981,01,01) + (data.time/86400));

varID = 'var00007';

conv = 1;

for i = 1:length(data.lat)
    for j = 1:length(data.lon)

        if inpolygon(data.lon(j),data.lat(i),shp(1).X,shp(1).Y)

            mdata = double(squeeze(data.sea_surface_temperature(j,i,:))) -273.15;
            mdepth(1:length(mdate)) = 0;


            sss = find(mdata < 1000);


            if ~isempty(sss)

                pdate = mdate(sss);
                pdata = mdata(sss);
                pdepth = mdepth(sss);


                station = ['IMOS_SRS_L3S_',shp(1).Name,'_',num2str(j),'_',num2str(i)];
                % station = [shp(1).Name,'_',num2str(j),'_',num2str(i)];

                datafile = [outdir,'IMOS_SRS_L3S_',shp(1).Name,'_',num2str(j),'_',num2str(i),'_DATA.csv'];
                fid = fopen(datafile,'wt');
                fprintf(fid,'Date,Depth,Data,QC\n');
                for m = 1:length(pdate)
                    fprintf(fid,'%s,%3.3f,%6.6f,N\n',datestr(pdate(m),'yyyy-mm-dd HH:MM:SS'),pdepth(m),pdata(m));
                end
                fclose(fid);

                headerfile = regexprep(datafile,'_DATA.csv','_HEADER.csv')

                fid = fopen(headerfile,'wt');
                fprintf(fid,'Agency Name,Integrated Marine Observing System\n');
                fprintf(fid,'Agency Code,IMOS\n');
                fprintf(fid,'Program,SRS\n');
                fprintf(fid,'Project,%s\n','L3S');
                fprintf(fid,'Tag,%s\n','IMOS-SRS-L3S');
                fprintf(fid,'Data File Name,%s\n',regexprep(datafile,outdir,''));
                fprintf(fid,'Location,%s\n',outdir);

                if max(mdate) >= datenum(2020,01,01)
                    fprintf(fid,'Station Status,Active\n',outdir);
                else
                    fprintf(fid,'Station Status,Inactive\n',outdir);
                end
                fprintf(fid,'Lat,%6.9f\n',unique(data.lat(i)));
                fprintf(fid,'Long,%6.9f\n',unique(data.lon(j)));
                fprintf(fid,'Time Zone,GMT +8\n');
                fprintf(fid,'Vertical Datum,mAHD\n');
                fprintf(fid,'National Station ID,%s\n',station);
                fprintf(fid,'Site Description,%s\n',station);

                fprintf(fid,'Deployment,%s\n','Floating');
                fprintf(fid,'Deployment Position,%s\n','0m from Surface');
                fprintf(fid,'Vertical Reference,%s\n','m from Surface');
                fprintf(fid,'Site Mean Depth,%s\n',[]);

                fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
                fprintf(fid,'Contact Email,\n');
                fprintf(fid,'Variable ID,%s\n',varID);
                fprintf(fid,'Data Category,%s\n',varkey.(varID).Category);

                fprintf(fid,'Sampling Rate (min), \n');

                fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
                fprintf(fid,'Depth,Decimal\n');

                thevar = [varkey.(varID).Name,' (',varkey.(varID).Unit,')'];

                fprintf(fid,'Variable,%s\n',thevar);
                fprintf(fid,'QC,String\n');

                fclose(fid);
            end
        end
    end
end

