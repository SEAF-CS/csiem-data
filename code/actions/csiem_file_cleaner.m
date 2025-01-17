run csiem_data_paths
FILES = dir([datapath,'**/*']);

fid = fopen('TestListOfFilesToDelete.txt','W');

for i = 1:length(FILES)
    RelativeName = FILES(i).name;
    AbsPath = FILES(i).folder;
    if startsWith(RelativeName,'._')
        %add to list
        % fprintf(fid,'%s\t%s\n',RelativeName,FILES(i).folder);
        if startsWith(AbsPath,'/GIS_DATA/csiem-data-hub/data-warehouse/')
            fprintf(fid,'%s\t%s\n',RelativeName,FILES(i).folder);
            delete(fullfile(AbsPath,RelativeName));
        end

    end
end
fclose(fid);
