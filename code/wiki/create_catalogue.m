clear all; close all;

filename = '../../../cseim-data-wiki/Catalogue.md';

[snum,sstr] = xlsread('../../data-governance/CSIEM_Data_Catalogue.xlsx','Catalogue','B2:O10000');

[~,headers] = xlsread('../../data-governance/CSIEM_Data_Catalogue.xlsx','Catalogue','B1:O1');

fid = fopen(filename,'wt');

fidtxt = fopen('catalogue_txt.txt','rt');

fline = fgetl(fidtxt);

while strcmpi(fline,'break') == 0
    fprintf(fid,'%s\n',fline);
    fline = fgetl(fidtxt);
end


fprintf(fid,'## High Priority\n');
fprintf(fid,'\n');
fprintf(fid,'\n');

fprintf(fid,'| %s | %s | %s | %s | %s | %s |\n',headers{4},headers{5},headers{6},headers{7},headers{8},headers{13});
fprintf(fid,'| :--- | :----: | :----: | :----: | :----: | ---: |\n');

for i = 1:length(sstr)
    if strcmpi(sstr{i,14},'High') == 1 & ...
            strcmpi(sstr{i,13},'Action Required') == 1
        
        fprintf(fid,'| %s | %s | %s | %s | %s | %s |\n',sstr{i,4},sstr{i,5},sstr{i,6},sstr{i,7},sstr{i,8},sstr{i,13});
        
    end
end


fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'## Medium Priority\n');
fprintf(fid,'\n');
fprintf(fid,'\n');

fprintf(fid,'| %s | %s | %s | %s | %s | %s |\n',headers{4},headers{5},headers{6},headers{7},headers{8},headers{13});
fprintf(fid,'| :--- | :----: | :----: | :----: | :----: | ---: |\n');

for i = 1:length(sstr)
    if strcmpi(sstr{i,14},'Medium') == 1 & ...
            strcmpi(sstr{i,13},'Action Required') == 1
        
        fprintf(fid,'| %s | %s | %s | %s | %s | %s |\n',sstr{i,4},sstr{i,5},sstr{i,6},sstr{i,7},sstr{i,8},sstr{i,13});
        
    end
end


fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'## Low Priority\n');
fprintf(fid,'\n');
fprintf(fid,'\n');

fprintf(fid,'| %s | %s | %s | %s | %s | %s |\n',headers{4},headers{5},headers{6},headers{7},headers{8},headers{13});
fprintf(fid,'| :--- | :----: | :----: | :----: | :----: | ---: |\n');

for i = 1:length(sstr)
    if strcmpi(sstr{i,14},'Low') == 1 & ...
            strcmpi(sstr{i,13},'Action Required') == 1
        
        fprintf(fid,'| %s | %s | %s | %s | %s | %s |\n',sstr{i,4},sstr{i,5},sstr{i,6},sstr{i,7},sstr{i,8},sstr{i,13});
        
    end
end


fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'## Import Required\n');
fprintf(fid,'\n');
fprintf(fid,'\n');

fprintf(fid,'| %s | %s | %s | %s | %s | %s |\n',headers{4},headers{5},headers{6},headers{7},headers{8},headers{13});
fprintf(fid,'| :--- | :----: | :----: | :----: | :----: | ---: |\n');

for i = 1:length(sstr)
    if strcmpi(sstr{i,13},'Data Lake') == 1
        
        fprintf(fid,'| %s | %s | %s | %s | %s | %s |\n',sstr{i,4},sstr{i,5},sstr{i,6},sstr{i,7},sstr{i,8},sstr{i,13});
        
    end
end


fprintf(fid,'\n');
fprintf(fid,'\n');
fprintf(fid,'## Import Finalised\n');
fprintf(fid,'\n');
fprintf(fid,'\n');

fprintf(fid,'| %s | %s | %s | %s | %s | %s |\n',headers{4},headers{5},headers{6},headers{7},headers{8},headers{13});
fprintf(fid,'| :--- | :----: | :----: | :----: | :----: | ---: |\n');

for i = 1:length(sstr)
    if strcmpi(sstr{i,13},'Data Warehouse') == 1
        
        fprintf(fid,'| %s | %s | %s | %s | %s | %s |\n',sstr{i,4},sstr{i,5},sstr{i,6},sstr{i,7},sstr{i,8},sstr{i,13});
        
    end
end

fclose(fid);
fclose(fidtxt);
