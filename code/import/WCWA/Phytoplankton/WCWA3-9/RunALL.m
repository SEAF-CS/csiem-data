WCNums = [3,4,5,6,7,8,9];
Sheets = ...
{'231098';
 '231298';
 '200199';
 '240299';
 '010499';
 '230499';
 '240699';
};


for i = 1:length(WCNums)
    fprintf("WCWA%d\n",WCNums(i));
    fprintf("\tSpecies\n");
    import_phytoplankton_Species(WCNums(i),Sheets{i},100)
    fprintf("\tGroup\n");
    import_phytoplankton_GroupStaging(WCNums(i),Sheets{i},100)
    import_phytoplankton_GroupStaged(WCNums(i))
end
