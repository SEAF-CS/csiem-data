%Summarise Dataware summary
File = '/GIS_DATA/csiem-data-hub/data-warehouse/stats/warehouse_stats.csv'
Tab = readtable(File);
Tab(1:5,:)
Names = Tab.Properties.VariableNames;
for i = 1:width(Tab)
    [U,ITab,IU] = unique(Tab{:,i});
    UniqueStuff{1,i} = Names{i};
    NUniq = length(U);
    Counts = num2cell(hist(IU,NUniq)');
    if ~iscell(U)
        U = num2cell(U);
    end
    TagCell = cell(NUniq,2);
    PathCell = cell(NUniq,1);
    for j = 1:NUniq
        headerinds = IU == j;
        %% I would like to add headerfile path here
        Tags = Tab.Tag(headerinds);
        TagCell{j,1} = Tags;
        TagCell{j,2} = unique(Tags);
        Paths = Tab.Headerfilepath(headerinds);
        PathCell{j,1} = Paths;

    end


    UniqueStuff{2,i} = [U,Counts,TagCell,PathCell];
    UniqueStuff{3,i} = IU;
end

save('WarehouseDebuggingSummary.mat','UniqueStuff');

