NameFile = 'AllNamesIn1.tsv';
if exist(NameFile,'file')
    
else
    run('DateRegularityAllNames.m')
end

Tab = readtable(NameFile,'FileType',"delimitedtext","Delimiter",sprintf("\t"));
DifferentNameRows = 0 == Tab{:,25};
DiffTab = Tab(DifferentNameRows,1:24);
DiffTab(:,1);
%its had the match row removed so all table is strings/cells

fid = fopen('Unique.tsv','w');
for i = 1:height(DiffTab)
    UniqueNames = unique(DiffTab{i,:});
    for j = 1:length(UniqueNames)
        fprintf(fid,"%s\t",UniqueNames{j});
    end
    fprintf(fid,"\n");
end

fclose(fid);

fid = fopen('UniqueTransposed.tsv','w');
for i = 1:4
    for j = 1:height(DiffTab)
        UniqueNames = unique(DiffTab{j,:});
        if length(UniqueNames)<i 
            fprintf(fid,"\t\t");
        else
            fprintf(fid,"%s\t",UniqueNames{i});

            numArray = double(UniqueNames{i});
            for k = 1:length(numArray)
                fprintf(fid,"%d,",numArray(k));
            end
            fprintf(fid,"\t");
        end
    end
    fprintf(fid,"\n");
end



fclose(fid);


