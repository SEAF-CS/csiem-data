function write_files(mdata_all,ddata_all,data_all,filename_all,AgencyName,AgencyCode,Program,ProgramCode,path,Lat,Lon,SiteID,SiteDesc)

% Surface

load ../../actions/varkey.mat;

filename = [filename_all,'_surface'];

sts = find(ddata_all < 5);

if ~isempty(sts)

    mdata = mdata_all(sts);
    ddata = ddata_all(sts);
    data = data_all(sts);

    wdepth(1:length(sts),1) = 0.3;

    data(data == 9999) = NaN;

    fullvar = [varkey.var00023.Name,' (',varkey.var00023.Unit,')'];

    headerfile = [path,filename,'_HEADER.csv'];

    fid = fopen(headerfile,'wt');

    fprintf(fid,'Agency Name,%s\n',AgencyName);
    fprintf(fid,'Agency Code,%s\n',AgencyCode);
    fprintf(fid,'Program,%s\n',Program);
    fprintf(fid,'Project,%s\n',ProgramCode);
    fprintf(fid,'Tag,%s\n','WCWA-PSDP-1.2');
    fprintf(fid,'Data File Name,%s\n',filename);
    fprintf(fid,'Location,%s\n',path);
    fprintf(fid,'Station Status,Inactive\n');
    fprintf(fid,'Lat,%4.4f\n',Lat);
    fprintf(fid,'Long,%4.4f\n',Lon);
    fprintf(fid,'Time Zone,GMT +8\n');
    fprintf(fid,'Vertical Datum,mAHD\n');
    fprintf(fid,'National Station ID,%s\n',SiteID);
    fprintf(fid,'Site Description,%s\n',SiteDesc);
    fprintf(fid,'Deployment,%s\n','Floating');
    fprintf(fid,'Deployment Position,%s\n','0.3m from Surface');
    fprintf(fid,'Vertical Reference,%s\n','m from Surface');
    fprintf(fid,'Site Mean Depth,%s\n',[]);
    fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
    fprintf(fid,'Contact Email,\n');
    fprintf(fid,'Variable ID,var00023\n');
    fprintf(fid,'Data Category,%s\n',varkey.var00023.Category);
    fprintf(fid,'Sampling Rate (min),10080.0000\n');
    fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
    fprintf(fid,'Depth,Decimal\n');
    fprintf(fid,'Variable,%s\n',fullvar);
    fprintf(fid,'QC,String\n');

    fclose(fid);

    datafile = [path,filename,'_DATA.csv'];

    fid = fopen(datafile,'wt');

    fprintf(fid,'Date,Depth,Data,QC\n');

    for i = 1:length(mdata)
        fprintf(fid,'%s,%4.4f,%5.5f,N\n',datestr(mdata(i),'yyyy-mm-dd HH:MM:SS'),wdepth(i),data(i));
    end
    fclose(fid);
    %plot_datafile(datafile);
end

% Bottom

filename = [filename_all,'_bottom'];

sts = find(ddata_all > 5);

if ~isempty(sts)

    mdata = mdata_all(sts);
    ddata = ddata_all(sts);
    data = data_all(sts);

    data(data == 9999) = NaN;

    wdepthb(1:length(sts),1) = 0.3;

    fullvar = [varkey.var00023.Name,' (',varkey.var00023.Unit,')'];

    headerfile = [path,filename,'_HEADER.csv'];

    fid = fopen(headerfile,'wt');

    fprintf(fid,'Agency Name,%s\n',AgencyName);
    fprintf(fid,'Agency Code,%s\n',AgencyCode);
    fprintf(fid,'Program,%s\n',Program);
    fprintf(fid,'Project,%s\n',ProgramCode);
    fprintf(fid,'Tag,%s\n','WCWA-PSDP-1.2');
    fprintf(fid,'Data File Name,%s\n',filename);
    fprintf(fid,'Location,%s\n',path);
    fprintf(fid,'Station Status,Inactive\n');
    fprintf(fid,'Lat,%4.4f\n',Lat);
    fprintf(fid,'Long,%4.4f\n',Lon);
    fprintf(fid,'Time Zone,GMT +8\n');
    fprintf(fid,'Vertical Datum,mAHD\n');
    fprintf(fid,'National Station ID,%s\n',SiteID);
    fprintf(fid,'Site Description,%s\n',SiteDesc);
    fprintf(fid,'Deployment,%s\n','Fixed');
    fprintf(fid,'Deployment Position,%s\n','0.3m above Seabed');
    fprintf(fid,'Vertical Reference,%s\n','m above Seabed');
    fprintf(fid,'Site Mean Depth,%s\n',[]);
    fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
    fprintf(fid,'Contact Email,\n');
    fprintf(fid,'Variable ID,var00023\n');
    fprintf(fid,'Data Category,%s\n',varkey.var00023.Category);
    fprintf(fid,'Sampling Rate (min),10080.0000\n');
    fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
    fprintf(fid,'Depth,Decimal\n');
    fprintf(fid,'Variable,%s\n',fullvar);
    fprintf(fid,'QC,String\n');

    fclose(fid);

    datafile = [path,filename,'_DATA.csv'];

    fid = fopen(datafile,'wt');

    fprintf(fid,'Date,Height,Data,QC\n');

    for i = 1:length(mdata)
        fprintf(fid,'%s,%4.4f,%5.5f,N\n',datestr(mdata(i),'dd-mm-yyyy HH:MM:SS'),wdepthb(i),data(i));
    end
    fclose(fid);

    %plot_datafile(datafile);

end
