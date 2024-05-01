function export_matfile_2_parquet_flatfile(matfile)

load(matfile);
outfile = regexprep(matfile,'\.mat','\.parq');


tab = create_blank_table;
tablefield = fieldnames(tab);

sites = fieldnames(csiem);

for i = 1:length(sites)
    disp(sites{i});
    vars = fieldnames(csiem.(sites{i}));
    for j = 1:length(vars)
        for k = 1:length(tablefield)
            
            switch tablefield{k}
                case 'Date'
                    tab.Date = [tab.Date;datestr(csiem.(sites{i}).(vars{j}).Date,'yyyy-mm-dd HH:MM:SS')];
                case 'Data'
                    tab.Data = [tab.Data;csiem.(sites{i}).(vars{j}).Data];
                case 'Depth'
                    if isnumeric(csiem.(sites{i}).(vars{j}).Depth)
                        tab.Depth = [tab.Depth;csiem.(sites{i}).(vars{j}).Depth];
                    else
                        fakedepth = [];
                        fakedepth(1:length(csiem.(sites{i}).(vars{j}).Date),1) = 0;
                        tab.Depth = [tab.Depth;fakedepth];
                    end
                        
                otherwise
                    outdata = appenddata(csiem.(sites{i}).(vars{j}).Date,csiem.(sites{i}).(vars{j}).(tablefield{k}));
                    tab.(tablefield{k}) = [tab.(tablefield{k});outdata];
            end
        end
    end
end

tab

newtable = struct2table(tab);

parquetwrite(outfile,newtable);

function outdata = appenddata(mdate,thestring)
 %thestring   
if isnumeric(thestring)
    outdata(1:length(mdate),1) = thestring;
else
    outdata = {};
    outdata(1:length(mdate),1) = {thestring};
end



function tab = create_blank_table

tab.Agency = [];
tab.Agency_Code = [];
tab.Program_Name = [];
tab.Program_Code = [];

tab.Date = [];
tab.Data = [];
tab.Depth = [];

tab.Variable_ID = [];
tab.Variable_Name = [];
tab.Units = [];

tab.Data_File_Name = [];
tab.Data_File_Location = [];
tab.Status = [];

tab.Lat = [];
tab.Lon = [];
tab.XUTM = [];
tab.YUTM = [];
tab.Time_Zone = [];

tab.Vertical_Datum = [];
tab.Station_ID = [];
tab.Site_Description = [];

tab.Deployment = [];
tab.Deployment_Position = [];
tab.Vertical_Reference = [];

tab.calc_SMD = [];
tab.mAHD = [];

% tab.Site_Mean_Depth = [];
% tab.Bad_Data_Code = [];






