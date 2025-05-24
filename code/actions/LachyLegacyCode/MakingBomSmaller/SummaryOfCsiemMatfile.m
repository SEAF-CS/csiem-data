
filename = 'SummaryOfBOM.csv';
fid = fopen(filename,'w');
fprintf(fid,'Site,Var,size,Datestart,DateEn,SizeOfArrayRemoved\n');
SITES = fields(BOM);
for i = 1:length(SITES)
    %%Sites
    SITE = BOM.(SITES{i});

    VARS = fields(SITE);
    for j = 1:length(VARS)
        varStruct = SITE.(VARS{j});
        SIZE = size(varStruct.Data);
        minDate = datestr(min(varStruct.Date),31);
        maxDate = datestr(max(varStruct.Date),31);
        lowerlim = datenum('2005-01-01 00:00:00',"yyyy-mm-dd HH:MM:SS");

        SIZETOREMOVE = size(varStruct.Date(varStruct.Date<lowerlim));
        fprintf(fid,"%s,%s,%f,%s,%s,%f\n",SITES{i},VARS{j},SIZE(1),minDate,maxDate,SIZETOREMOVE(1));

    end


end
fclose(fid);

TAB = readtable(filename);
TotalSize = sum(TAB{:,3});
REMOVESIZE = sum(TAB{:,6});
percetageReomved = REMOVESIZE/TotalSize*100
