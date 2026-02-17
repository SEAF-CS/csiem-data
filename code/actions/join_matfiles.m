function join_matfiles()
    addpath(genpath('../functions/'));

    run('csiem_data_paths.m')

    outfilepath = [datapath,'data-warehouse/mat/agency/'];
    mergepath = [datapath,'data-warehouse/mat/'];

    filelist = dir(fullfile(outfilepath, '**/*.mat'));  %get list of files and folders in any subfolder
    %filelist = dir(fullfile(outfilepath, '**\*.mat'));  %get list of files and folders in any subfolder

    filelist = filelist(~[filelist.isdir]);  %remove folders from list
    csiem = struct;

    for i = 1:length(filelist)
        disp(filelist(i).name);
        matdata = load([filelist(i).folder,'/',filelist(i).name]);
        sites = fieldnames(matdata.csiem);
        for j = 1:length(sites)
            csiem.(sites{j}) = matdata.csiem.(sites{j});
        end

        clear matdata;
    end

    if ~isempty(fieldnames(csiem))
        save([mergepath,'csiem.mat'],'csiem','-mat','-v7.3');
    else
        warning('No merged csiem data found; skipping save of csiem.mat');
    end
end
