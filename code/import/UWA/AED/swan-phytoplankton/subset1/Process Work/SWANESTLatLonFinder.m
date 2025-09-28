SWANEST = readtable('site_key.xlsx',Sheet='SWANEST');
DWER = readtable('site_key.xlsx',Sheet='DWER');
b = readtable("DBCA_data_export_2024-03-08.csv");


Sites = SWANEST{:,1};
SITEKEYINDS = nan(length(Sites),1);
DWERTABLE = table();
%fid = fopen('deex.csv','w');
for i = 1:length(Sites)
    site = Sites{i};
    bools = strcmp(site,b.ProgramSiteRef);
    ind = find(bools,1);
    if ~isempty(ind)
        NUM = b.SiteRef(ind);
        DWERIND = NUM == DWER.SiteId;
        SITEKEYINDS(i) = find(DWERIND);
        if ~isempty(DWERIND)
            DWERTABLE(i,:) = DWER(DWERIND,:);
        end
    end        
    
end
DWERTABLE{length(Sites),1} = DWERTABLE{23,1};
DWERTABLE.("Sites") = Sites;
DWERTABLE.("SiteKeyIndexes") = SITEKEYINDS;
% fclose(fid);







