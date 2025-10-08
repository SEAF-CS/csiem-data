function create_marvl_config_information(marvl_id,matfile_name,selected_vars)

if nargin < 2 || isempty(matfile_name)
    matfile_name = {};  % Process all .mat files
end

if nargin < 3
    selected_vars = {}; % if this does not ocurru
end

disp(['Running group ',num2str(marvl_id)]);

load varkey.mat;

csiem_data_paths

allvars = fieldnames(varkey);

matdir = [datapath,'data-warehouse/mat/agency/'];


 % Build file list
 if isempty(matfile_name)
     filelist = dir(fullfile(matdir, '**', '*.mat'));
 else
     filelist = [];
 for k = 1:length(matfile_name)
     files = dir(fullfile(matdir, '**', [matfile_name{k}, '.mat']));
     filelist = [filelist; files];
 end
end
filelist = filelist(~[filelist.isdir]);  % Remove any directories

%filelist = dir(fullfile(matdir, '**/*.mat'));  %get list of files and folders in any subfolder
%filelist = filelist(~[filelist.isdir]);  %remove folders from list

fid = fopen('marvl_information.m','wt');

fprintf(fid,'csiem_data_paths\n');

fprintf(fid, 'master.fielddata_files = {');
if isempty(matfile_name)
    % Derive names from full file list
    for i = 1:length(filelist)
        [~, name, ~] = fileparts(filelist(i).name);
        fprintf(fid, '''%s'',', name);
    end
else
    for i = 1:length(matfile_name)
        fprintf(fid, '''%s'',', matfile_name{i});
    end
end
fprintf(fid, '};\n');

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
        tfv_match = strcmpi(uvars{i}, varkey.(allvars{j}).tfvName);

        % if marvl_id -1, ignore this
        if marvl_id == -1
            id_match = true;
        else
            id_match = varkey.(allvars{j}).marvlID == marvl_id;
        end

        % specific variables
        if isempty(selected_vars)
            var_ok = true;
        else
            var_ok = any(strcmpi(varkey.(allvars{j}).Name, selected_vars)) || ...
                     any(strcmpi(varkey.(allvars{j}).tfvName, selected_vars));
        end

        if tfv_match && id_match && var_ok
            fprintf(fid,'''%s'',''%s'';...\n', uvars{i}, varkey.(allvars{j}).Name);
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

    case 3
        % The testing case
        fprintf(fid,"timeseries.polygon_file = [datapath,'marvl/gis/MLAU_Zones_v3_ll.shp'];\n");
        fprintf(fid,"timeseries.outputdirectory = [datapath,'marvl-images/all/'];\n");

    case -1
        fprintf(fid,"timeseries.polygon_file = [marvldatapath,'/gis/Zones/MLAU_Zones_v3_ll.shp'];\n");%[datapath,'marvl/gis/MLAU_Zones_v3_ll.shp'];\n"
        fprintf(fid,"timeseries.outputdirectory = [marvldatapath,'/outputs/fast/'];\n"); 
        fprintf(fid,"timeseries.htmloutput = [marvldatapath,'/outputs/fast/HTML/'];\n"); 
       
    otherwise
        fprintf(fid,"timeseries.polygon_file = [datapath,'marvl/gis/MLAU_Zones_v3_ll.shp'];\n");
        fprintf(fid,"timeseries.outputdirectory = [datapath,'marvl-images/all/'];\n");   
end



fclose(fid);