function data = import_agency_conv(sheet)

filename = '../../data-lake/variable_key.xlsx';

[snum,sstr] = xlsread(filename,sheet,'A2:D10000');


for i = 1:length(sstr(:,1))
    
    data.(sstr{i,3}).Old = sstr{i,1};
    data.(sstr{i,3}).Conv = snum(i,1);
    
end