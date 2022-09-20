clear all; close all;

load metdata.mat;

[snum,sstr] = xlsread('../../../data-lake/variable_key.xlsx','Key','A2:D10000');

varID = sstr(:,1);
varName = sstr(:,2);
varUnit = sstr(:,3);
varSymbol = sstr(:,4);

for i = 1:length(varSymbol)
    if isempty(varSymbol{i})
        varSymbol(i) = varName(i);
    end
end

[snum,sstr] = xlsread('../../../data-lake/variable_key.xlsx','BOM','B2:D10000');

conv = snum(:,1);
avarID = sstr(:,1);


[snum,sstr] = xlsread('../../../data-lake/site_key.xlsx','BOM','A2:H10000');

sitename = sstr(:,3);
siteid = snum(:,1);
Lat = snum(:,6);
Lon = snum(:,7);
shortname = sstr(:,4);


outdir = '../../../data-warehouse/csv/bom/idy/';

writepath = 'data-warehouse/csv/bom/idy';

if ~exist(outdir,'dir')
    mkdir(outdir);
end

sites = fieldnames(metdata);

for i = 1:length(sites)
    
    sss = find(strcmpi(shortname,sites{i}) == 1);
    
    aSite = sitename{sss};
    aLat = Lat(sss);
    aLon = Lon(sss);
    ID = siteid(sss);
    
    
    vars = fieldnames(metdata.(sites{i}));
    
    mtime = datenum(metdata.(sites{i}).Year,...
        metdata.(sites{i}).Month,...
        metdata.(sites{i}).Day,...
        metdata.(sites{i}).Hour,...
        metdata.(sites{i}).MI_Format,...
        00);
    
    for j = 1:length(vars)
        
        tvar = regexprep(vars{j},'_',' ');
        
        varint = find(strcmpi(varName,tvar) == 1);
        
        if ~isempty(varint)
            
            disp('valid data');
            
            dataint = find(~isnan(metdata.(sites{i}).(vars{j})) == 1);
            
            mdate = mtime(dataint);
            mdata = metdata.(sites{i}).(vars{j})(dataint);
            QC(1:length(dataint)) = {'N'};%metdata.(sites{i}).(vars{j+1})(dataint); This needs fixing
            
            if ~isempty(mdata)
                
                convint = find(strcmpi(avarID,varID{varint}) == 1);
                mdata = mdata * conv(convint);
                
                filename = [outdir,num2str(ID),'_',regexprep(varName{varint},' ','_'),'_DATA.csv'];
                
                writefile = [num2str(ID),'_',regexprep(varName{varint},' ','_'),'_DATA.csv'];
                
                fid = fopen(filename,'wt');
                
                fprintf(fid,'Date,Depth,Data,QC\n');
                
                for k = 1:length(mdate)
                    fprintf(fid,'%s,%s,%8.5f,%s\n',datestr(mdate(k),'dd-mm-yyyy HH:MM:SS'),' ',mdata(k),QC{k});
                end
                fclose(fid);
                
                headerfile = regexprep(filename,'_DATA','_HEADER');
                
                fid = fopen(headerfile,'wt');
                fprintf(fid,'Agency Name,Bureau of Meteorology\n');
                fprintf(fid,'Agency Code,BOM\n');
                fprintf(fid,'Program,Weather\n');
                fprintf(fid,'Project,IDY\n');
                fprintf(fid,'Data File Name,%s\n',writefile);
                fprintf(fid,'Location,%s\n',writepath);
                
                if max(mdate) >= datenum(2019,01,01)
                    fprintf(fid,'Station Status,Active\n');
                else
                    fprintf(fid,'Station Status,Inactive\n');
                end
                fprintf(fid,'Lat,%8.8f\n',aLat);
                fprintf(fid,'Long,%8.8f\n',aLon);
                fprintf(fid,'Time Zone,GMT +8\n');
                fprintf(fid,'Vertical Datum, \n');
                fprintf(fid,'National Station ID,%s\n',num2str(ID));
                fprintf(fid,'Site Description,%s\n',aSite);
                fprintf(fid,'Bad or Unavailable Data Value,-9999\n');
                fprintf(fid,'Contact Email,climatedata@bom.gov.au\n');
                fprintf(fid,'Variable ID,%s\n',ID);
                fprintf(fid,'Data Classification,MET General\n');

                SD = mean(diff(mdate));
                
                fprintf(fid,'Sampling Rate (min),%4.4f\n',SD * (60*24));
                
                fprintf(fid,'Date,dd-mm-yyyy HH:MM:SS\n');
                fprintf(fid,'Depth,Decimal\n');
                
                %thevar = [varName{sss},' (',varUnit{sss},')'];
                
                fprintf(fid,'%s,Decimal\n',[varName{varint},' (',varUnit{varint},')']);
                fprintf(fid,'QC,String\n');
                
                fclose(fid);
                
            end
            
        end
        
    end
    
    
    
    
    
    
    
    
    
    
    
end





