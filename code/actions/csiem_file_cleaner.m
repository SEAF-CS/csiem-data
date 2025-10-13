run csiem_data_paths
% Use platform-agnostic recursive pattern; ensure separators around '**'
FILES = dir(fullfile(datapath, '**', '*'));

fid = fopen('TestListOfFilesToDelete.txt','w');

% Define allowed roots for deletion based on configured datapath
root_warehouse = fullfile(datapath, 'data-warehouse');
root_lake      = fullfile(datapath, 'data-lake');

for i = 1:length(FILES)
    RelativeName = FILES(i).name;
    AbsPath = FILES(i).folder;
    if startsWith(RelativeName,'._')
        %add to list
        % Only act within data-warehouse or data-lake under datapath
        if startsWith(AbsPath, root_warehouse, 'IgnoreCase', true) || ...
           startsWith(AbsPath, root_lake, 'IgnoreCase', true)
            fprintf(fid,'%s\t%s\n',RelativeName,FILES(i).folder);
            delete(fullfile(AbsPath,RelativeName));
        end

    end
end
fclose(fid);
