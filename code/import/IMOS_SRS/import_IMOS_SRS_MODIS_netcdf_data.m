function import_IMOS_SRS_MODIS_netcdf_data
addpath(genpath('../../functions'));

load ../../actions/varkey.mat;
load ../../actions/agency.mat;

shp = shaperead('sat_boundary.shp');


% ______________________________________________________
% TEMP
run('../../actions/csiem_data_paths.m')
ncname = [datapath,'data-lake/IMOS/srs/MODIS/Pico-fraction/IMOS_aggregation_20230611T052104Z/IMOS_aggregation_20230611T052104Z.nc'];

outdir = [datapath,'data-warehouse/csv/imos/srs_modis/'];mkdir(outdir);

data = tfv_readnetcdf(ncname);

mdate = double(datenum(1990,01,01) + data.time);

varID = 'var00353';

conv = 1;

for i = 1:length(data.latitude)
    for j = 1:length(data.longitude)

        if inpolygon(data.longitude(j),data.latitude(i),shp(1).X,shp(1).Y)

            mdata = double(squeeze(data.picop_brewin2012in(j,i,:)));
            mdepth(1:length(mdate)) = 0;


            sss = find(mdata > -100);


            if ~isempty(sss)

                pdate = mdate(sss);
                pdata = mdata(sss);
                pdepth = mdepth(sss);


                station = ['IMOS_SRS_MODIS_',shp(1).Name,'_',num2str(j),'_',num2str(i)];

                datafile = [outdir,'IMOS_SRS_MODIS_',shp(1).Name,'_',num2str(j),'_',num2str(i),'_DATA.csv'];
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
                fprintf(fid,'Program,SRS_MODIS\n');
                fprintf(fid,'Project,%s\n','SRS_MODIS');
                thetag = ['IMSO-',upper('SRS-MODIS')];
                fprintf(fid,'Tag,%s\n',thetag);
                fprintf(fid,'Data File Name,%s\n',regexprep(datafile,outdir,''));
                fprintf(fid,'Location,%s\n',['data-warehouse/csv/imos/',lower('SRS_MODIS')]);

                if max(mdate) >= datenum(2020,01,01)
                    fprintf(fid,'Station Status,Active\n',outdir);
                else
                    fprintf(fid,'Station Status,Inactive\n',outdir);
                end
                fprintf(fid,'Lat,%6.9f\n',unique(data.latitude(i)));
                fprintf(fid,'Long,%6.9f\n',unique(data.longitude(j)));
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

