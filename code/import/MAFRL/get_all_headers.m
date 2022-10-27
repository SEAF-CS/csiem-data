clear all; close all;

filename = '../../../data-lake/csmc/csmcwq-mafrl/MAFRL - WQ data - 1982 to 2020_BBEdit.xlsx';

theyears = [1983 1985 1986 1987 1990:1:1993 1997:1:2020];

headers = [];

for i = 1:length(theyears)
    sheetname = num2str(theyears(i));
    
    [~,sstr]  = xlsread(filename,sheetname,'A1:ZZ1');
    
    headers = [headers;sstr'];
    
end

uheaders = unique(headers);

uheaders