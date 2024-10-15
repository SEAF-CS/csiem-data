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
fprintf(fid,"Agency_Name,Tag,Agency_Code,Program_Name,Program_Code,File_Name,File_Location,Status,Lat,Lon,Time_Zone,Vertical_Datum,Station_ID,Site_Description,Bad_Code,Deployment,Deployment_Position,Vertical_Reference,Site_Mean_Depth,Email,Variable_ID,Sampling_Rate,Date_Format,Depth_Format,Variable_Name,QC_Code,Category\n");



for i = 1:length(filelist)
    display([filelist(i).folder,'/',filelist(i).name]);

    headerfile = [filelist(i).folder,'/',filelist(i).name];
    header = import_header(headerfile);
    %fprintf(fid,'%s,%s,%s,%s,%s,%6.6f,%6.6f,',header.Agency_Name,header.Agency_Code,header.Program_Name,header.Program_Code,header.Tag,header.Lat,header.Lon);
    %varID = header.Variable_ID;


    fprintf(fid,"%s,",header.Agency_Name);
    fprintf(fid,"%s,",header.Tag);
    fprintf(fid,"%s,",header.Agency_Code);
    fprintf(fid,"%s,",header.Program_Name);
    fprintf(fid,"%s,",header.Program_Code);
    fprintf(fid,"%s,",header.Data_File_Name);
    fprintf(fid,"%s,",header.Data_File_Location);
    fprintf(fid,"%s,",header.Status);
    fprintf(fid,"%f,",header.Lat);
    fprintf(fid,"%f,",header.Lon);
    fprintf(fid,"%s,",header.Time_Zone);
    fprintf(fid,"%s,",header.Vertical_Datum);
    fprintf(fid,"%s,",header.Station_ID);
    fprintf(fid,"%s,",header.Site_Description);
    fprintf(fid,"%s,",header.Bad_Data_Code);
    fprintf(fid,"%s,",header.Deployment);
    fprintf(fid,"%s,",header.Deployment_Position);
    fprintf(fid,"%s,",header.Vertical_Reference);
    fprintf(fid,"%s,",header.Site_Mean_Depth);
    fprintf(fid,"%s,",header.Email);
    fprintf(fid,"%s,",header.Variable_ID);
    fprintf(fid,"%s,",header.Sampling_Rate);
    fprintf(fid,"%s,",header.Date_Format);
    fprintf(fid,"%s,",header.Depth_Format);
    fprintf(fid,"%s,",header.Variable_Name);
    fprintf(fid,"%s,",header.QC_Code);
    fprintf(fid,"%s",header.DataCategory);

    fprintf(fid,"\n");

    % if isnumeric(header.Station_ID)
    %     header.Station_ID = num2str(header.Station_ID);
    % end

    % fprintf(fid,'%s,%s,%s,%s,',header.Station_ID,varID,varkey.(varID).Name,varkey.(varID).Unit,varkey.(varID).Category);


    % datafile = regexprep(headerfile,'HEADER','DATA');

    % tt2 = import_datafile_raw(datafile);

    % fprintf(fid,'%d,%s,%s\n',length(tt2.Date),datestr(min(tt2.Date),'yyyy-mm-dd'),datestr(max(tt2.Date),'yyyy-mm-dd'));
    %fprintf(fid,' , , \n');
end

fclose(fid);