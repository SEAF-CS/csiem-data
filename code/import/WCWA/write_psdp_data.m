function write_psdp_data(outdir,thesite,varID,varkey,wdate,wdata,wdepth,filecode)


filename = ([outdir,filecode,'_DATA.csv']);
headername = ([outdir,filecode,'_HEADER.csv']);

AEDSite = thesite.AED;
Lat = thesite.Lat;
Lon = thesite.Lon;
ID = thesite.ID;
Desc = thesite.Description;

Cat = varkey.(varID).Category;
varstring = [varkey.(varID).Name,' (',varkey.(varID).Unit,')'];

fid = fopen(filename,'wt');
fprintf(fid,'Date,Height,Data,QC\n');
for k = 1:length(wdate)
    fprintf(fid,'%s,%4.4f,%4.2f,N\n',datestr(wdate(k),'yyyy-mm-dd HH:MM:SS'),wdepth(k),wdata(k));
end
fclose(fid);


filename_short = [filecode,'_DATA.csv'];

fid = fopen(headername,'wt');
fprintf(fid,'Agency Name,Water Corporation WA\n');

fprintf(fid,'Agency Code,WCWA\n');
fprintf(fid,'Program,WCWA-PSDP-BMT349\n');
fprintf(fid,'Project,WCWA-PSDP-BMT349\n');
fprintf(fid,'Tag,WCWA-PSDP-BMT349\n');
fprintf(fid,'Data File Name,%s\n',filename_short);
fprintf(fid,'Location,%s\n',['data-warehouse/csv/wcwa/wcwa-psdp-bmt349']);


fprintf(fid,'Station Status,Static\n');
fprintf(fid,'Lat,%6.9f\n',Lat);
fprintf(fid,'Long,%6.9f\n',Lon);
fprintf(fid,'Time Zone,GMT +8\n');
fprintf(fid,'Vertical Datum,mAHD\n');
fprintf(fid,'National Station ID,%s\n',ID);
fprintf(fid,'Site Description,%s\n',Desc);
fprintf(fid,'Deployment,%s\n','Fixed');
fprintf(fid,'Deployment Position,%s\n',[num2str(wdepth(1)),'m above Seabed']);
fprintf(fid,'Vertical Reference,%s\n','m above Seabed');
fprintf(fid,'Site Mean Depth,%4.4f\n',thesite.Depth);
fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
fprintf(fid,'Contact Email,%s\n','');
fprintf(fid,'Variable ID,%s\n',varID);

fprintf(fid,'Data Category,%s\n',Cat);


SD = mean(diff(wdate));

fprintf(fid,'Sampling Rate (min),%4.4f\n',SD * (60*24));

fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
fprintf(fid,'Depth,Decimal\n');


fprintf(fid,'Variable,%s\n',varstring);
fprintf(fid,'QC,String\n');

fclose(fid);