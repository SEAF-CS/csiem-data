function write_files(mdata,ddata,data,filename,AgencyName,AgencyCode,Program,ProgramCode,path,Lat,Lon,SiteID,SiteDesc)

data(data == 9999) = NaN;

headerfile = [path,filename,'_HEADER.csv'];

fid = fopen(headerfile,'wt');

fprintf(fid,'Agency Name,%s\n',AgencyName);
fprintf(fid,'Agency Code,%s\n',AgencyCode);
fprintf(fid,'Program,%s\n',Program);
fprintf(fid,'Project,%s\n',ProgramCode);
fprintf(fid,'Tag,%s\n','WC-BMT');
fprintf(fid,'Data File Name,%s\n',filename);
fprintf(fid,'Location,%s\n',path);
fprintf(fid,'Station Status,Inactive\n');
fprintf(fid,'Lat,%4.4f\n',Lat);
fprintf(fid,'Long,%4.4f\n',Lon);
fprintf(fid,'Time Zone,GMT +8\n');
fprintf(fid,'Vertical Datum,mAHD\n');
fprintf(fid,'National Station ID,%s\n',SiteID);
fprintf(fid,'Site Description,%s\n',SiteDesc);
fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
fprintf(fid,'Contact Email,\n');
fprintf(fid,'Variable ID,var00023\n');
fprintf(fid,'Data Classification,WQ Grab\n');
fprintf(fid,'Sampling Rate (min),10080.0000\n');
fprintf(fid,'Date,dd-mm-yyyy HH:MM:SS\n');
fprintf(fid,'Depth,Decimal\n');
fprintf(fid,'Variable,Oxygen (mg/L)\n');
fprintf(fid,'QC,String\n');

fclose(fid);

datafile = [path,filename,'_DATA.csv'];

fid = fopen(datafile,'wt');

fprintf(fid,'Date,Depth,Data,QC\n');

for i = 1:length(mdata)
    fprintf(fid,'%s,%4.4f,%5.5f,N\n',datestr(mdata(i),'dd-mm-yyyy HH:MM:SS'),ddata(i),data(i));
end
fclose(fid);