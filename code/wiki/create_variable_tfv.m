clear all; close all;

load ../actions/varkey.mat;

filename = '../../../cseim-data-wiki/TFV_Variables.md';

vars = fieldnames(varkey);

wd = '100%';

fid = fopen(filename,'wt');

fprintf(fid,'## CSIEM TFV Variables\n');

fprintf(fid,'\n');
fprintf(fid,'\n');

% 

fprintf(fid,'| Variable ID | Name | TFV Name | TFV Units | Conversion  | \n');
fprintf(fid,'| :--- | :----: | :----: | :----: | :--- |\n');

for i = 1:length(vars)
    if strcmpi(varkey.(vars{i}).tfvName,'N/A') == 0
        fprintf(fid,'| *%s* | %s | %s | %s | %4.4f |\n',vars{i},varkey.(vars{i}).Name,varkey.(vars{i}).tfvName,varkey.(vars{i}).tfvUnits,varkey.(vars{i}).tfvConv);
    end
end
fprintf(fid,'\n');
fprintf(fid,'\n');

fclose(fid);