function write_header(headerfile,lat,lon,ID,Desc,varID,Cat,varstring,wdate,sitedepth)
filename = regexprep(headerfile,'_HEADER','_DATA');

temp = split(filename,filesep);
filename_short = temp{end};

fid = fopen(headerfile,'wt');
            fprintf(fid,'Agency Name,Western Australian Marine Science Institution\n');
            
            fprintf(fid,'Agency Code,WAMSI\n');
            fprintf(fid,'Program,WWMSP3\n');
            fprintf(fid,'Project,WWMSP3.1_SEDDEP\n');
            fprintf(fid,'Tag,WAMSI-WWMSP3-SEDDEP\n');

            %%
            fprintf(fid,'Data File Name,%s\n',filename_short);
            fprintf(fid,'Location,%s\n',fullfile(temp{1:end-1}));
            %%
            
            fprintf(fid,'Station Status,Inactive\n');
            fprintf(fid,'Lat,%6.9f\n',lat);
            fprintf(fid,'Long,%6.9f\n',lon);
            fprintf(fid,'Time Zone,GMT +8\n');
            fprintf(fid,'Vertical Datum,mAHD\n');
            fprintf(fid,'National Station ID,%s\n',ID);

            %%
            fprintf(fid,'Site Description,%s\n',Desc);
            fprintf(fid,'Deployment,%s\n','Floating');
            fprintf(fid,'Deployment Position,%s\n','0m below surface');
            fprintf(fid,'Vertical Reference,%s\n','m below surface');
            fprintf(fid,'Site Mean Depth,%4.4f\n',sitedepth);
            %%

            fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
            fprintf(fid,'Contact Email,%s\n','');

            %%
            fprintf(fid,'Variable ID,%s\n',varID);
            %%
            
            fprintf(fid,'Data Category,%s\n',Cat);
            
            
            SD = mean(diff(wdate));
            
            fprintf(fid,'Sampling Rate (min),%4.4f\n',SD * (60*24));
            
            fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
            fprintf(fid,'Depth,Decimal\n');
            
            
            fprintf(fid,'Variable,%s\n',varstring);
            fprintf(fid,'QC,String\n');
            
            fclose(fid);