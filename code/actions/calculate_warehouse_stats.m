%function calculate_warehouse_stats

    addpath(genpath('../functions/'));
    
    load varkey.mat;
    
    run('csiem_data_paths.m');

    outfilepath = [datapath,'data-warehouse/stats/'];
             %'D:/csiem/data-warehouse/parquet/agency/';
    filepath = [datapath,'data-warehouse/csv/'];

    mkdir(outfilepath);

    outfile = [outfilepath,'warehouse_stats.csv'];

    filelist = dir(fullfile(filepath, '**/*HEADER.csv'));  %get list of files and folders in any subfolder
%filelist = dir(fullfile(filepath, '**\*HEADER.csv'));  %get list of files and folders in any subfolder

yeararray = (1980:01:2024);

filelist = filelist(~[filelist.isdir]);  %remove folders from list

fid = fopen(outfile,'wt');
fprintf(fid,'Agency,Agency Code,Program,Program Code,Tag,Lat,Lon,Site ID,Variable ID,Variable Name,Units,Classification,Number of Samples,Start Date,End Date\n');



for i = 1:length(filelist)
    display([filelist(i).folder,'/',filelist(i).name]);

    headerfile = [filelist(i).folder,'/',filelist(i).name];
    header = import_header(headerfile);

    fprintf(fid,'%s,%s,%s,%s,%s,%6.6f,%6.6f,',header.Agency_Name,header.Agency_Code,header.Program_Name,header.Program_Code,header.Tag,header.Lat,header.Lon);

    varID = header.Variable_ID;

    if isnumeric(header.Station_ID)
        header.Station_ID = num2str(header.Station_ID);
    end

    fprintf(fid,'%s,%s,%s,%s,',header.Station_ID,varID,varkey.(varID).Name,varkey.(varID).Unit,varkey.(varID).Category);

    

    datafile = regexprep(headerfile,'HEADER','DATA');

    tt2 = import_datafile_raw(datafile);

    fprintf(fid,'%d,%s,%s\n',length(tt2.Date),datestr(min(tt2.Date),'yyyy-mm-dd'),datestr(max(tt2.Date),'yyyy-mm-dd'));
    %fprintf(fid,' , , \n');


end

fclose(fid);