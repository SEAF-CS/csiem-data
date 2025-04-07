function create_marvl_config_information(marvl_id,matfile_name)

disp(['Running group ',num2str(marvl_id)]);

load varkey.mat;

csiem_data_paths

allvars = fieldnames(varkey);

matdir = [datapath,'data-warehouse/mat/agency/'];

filelist = dir(fullfile(matdir, '**/*.mat'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

fid = fopen('marvl_information.m','wt');

fprintf(fid,'csiem_data_paths\n');

fprintf(fid,'master.fielddata_files = {');

%for i = 1:length(filelist)
    fprintf(fid,'''%s'',',matfile_name);
%end
fprintf(fid,'};');

fprintf(fid,'\n');
fprintf(fid,'master.varname = {...\n');

vars = [];
for i = 1:length(filelist)
    filename = [filelist(i).folder,'/',filelist(i).name]
    load(filename);
    sites = fieldnames(csiem);
    for j = 1:length(sites)
        thevars = fieldnames(csiem.(sites{j}));
        vars = [vars;thevars];
    end
end
clear csiem;
uvars = unique(vars);

count = 0;

for i = 1:length(uvars)
    for j = 1:length(allvars)
        if strcmpi(uvars{i},varkey.(allvars{j}).tfvName) == 1 & varkey.(allvars{j}).marvlID == marvl_id 
            fprintf(fid,'''%s'',''%s'';...\n',uvars{i},varkey.(allvars{j}).Name);
            count = count + 1;
        end
    end
end
fprintf(fid,'};');
fprintf(fid,'\n');
fprintf(fid,'\n');

fprintf(fid,'timeseries.start_plot_ID = 1;\n');
fprintf(fid,'timeseries.end_plot_ID = %d;\n',count);






switch marvl_id
    case 0

        fprintf(fid,"timeseries.polygon_file = [datapath,'marvl/gis/MLAU_Zones_v3_ll.shp'];\n");
        fprintf(fid,"timeseries.outputdirectory = [datapath,'marvl-images/all/'];\n");

    case 2

        fprintf(fid,"timeseries.polygon_file = [datapath,'marvl/gis/MARVL_Met_v1.shp'];\n");
        fprintf(fid,"timeseries.outputdirectory = [datapath,'marvl-images/met/'];\n");
    case 1
        fprintf(fid,"timeseries.polygon_file = [datapath,'marvl/gis/MLAU_Zones_v3_ll.shp'];\n");
        fprintf(fid,"timeseries.outputdirectory = [datapath,'marvl-images/core/'];\n");
    otherwise
        fprintf(fid,"timeseries.polygon_file = [datapath,'marvl/gis/MLAU_Zones_v3_ll.shp'];\n");
        fprintf(fid,"timeseries.outputdirectory = [datapath,'marvl-images/all/'];\n");   
end

fclose(fid);