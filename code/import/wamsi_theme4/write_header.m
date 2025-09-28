function write_header(headerfile,varID,VarS,SiteS)
filename = regexprep(headerfile,'_HEADER','_DATA');

temp = split(filename,filesep);
filename_short = temp{end};

fid = fopen(headerfile,'wt');
            fprintf(fid,'Agency Name,Western Australian Marine Science Institution\n');
            
            fprintf(fid,'Agency Code,WAMSI\n');
            fprintf(fid,'Program,WWMSP4\n');
            fprintf(fid,'Project,WWMSP4_ZOO\n');
            fprintf(fid,'Tag,WAMSI-WWMSP4-ZOO\n');

            %%
            fprintf(fid,'Data File Name,%s\n',filename_short);
            fprintf(fid,'Location,%s\n',fullfile(temp{1:end-1}));
            %%
            
            fprintf(fid,'Station Status,Inactive\n');
            fprintf(fid,'Lat,%6.9f\n',SiteS.Lat);
            fprintf(fid,'Long,%6.9f\n',SiteS.Lon);
            fprintf(fid,'Time Zone,GMT +8\n');
            fprintf(fid,'Vertical Datum,mAHD\n');
            fprintf(fid,'National Station ID,%s\n',SiteS.ID);

            %%
            fprintf(fid,'Site Description,%s\n',SiteS.Description);
            fprintf(fid,'Deployment,%s\n','Integrated');
            fprintf(fid,'Deployment Position,%s\n','Water Column');
            fprintf(fid,'Vertical Reference,%s\n','m below Surface');
            fprintf(fid,'Site Mean Depth,%4.4f\n',0);
            %%

            fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
            fprintf(fid,'Contact Email,%s\n','Lachy Gill <00114282@uwa.edu.au> 17/03/2025');

            %%
            fprintf(fid,'Variable ID,%s\n',varID);
            %%
            
            fprintf(fid,'Data Category,%s\n',VarS.Category);
            
            
    
            
            fprintf(fid,'Sampling Rate (min),%4.4f\n',-1);
            
            fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
            fprintf(fid,'Depth,Decimal\n');
            
            
            fprintf(fid,'Variable,%s\n',VarS.Name);
            fprintf(fid,'QC,String\n');
            
            fclose(fid);