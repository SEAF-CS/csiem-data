clear all; close all;

load ../actions/varkey.mat;

filename = '../../../cseim-data-wiki/Variables.md';

fidtxt = fopen('variable_txt.txt','rt');


vars = fieldnames(varkey);

wd = '100%';

fid = fopen(filename,'wt');

fline = fgetl(fidtxt);

while strcmpi(fline,'break') == 0
    fprintf(fid,'%s\n',fline);
    fline = fgetl(fidtxt);
end

fprintf(fid,'\n');

fprintf(fid,'## CSIEM Variables\n');

fprintf(fid,'\n');
fprintf(fid,'\n');
% fprintf(fid,'<sub>\n');
% 
% 
% 
% 
% fprintf(fid,'<table>\n',wd);
%   fprintf(fid,'<tr>\n');
%     fprintf(fid,'<th>Variable ID</th>\n');
%     fprintf(fid,'<th>Name</th>\n');
%     fprintf(fid,'<th>Units</th>\n');
%     %fprintf(fid,'<th>Symbol</th>\n');
%     fprintf(fid,'<th>Programmatic Name</th>\n');
%   fprintf(fid,'</tr>\n');
%   
%   for i = 1:length(vars)
%   
%   fprintf(fid,'<tr>\n');
%     fprintf(fid,'<td>%s</td>\n',vars{i});
%     fprintf(fid,'<td>%s</td>\n',varkey.(vars{i}).Name);
%     fprintf(fid,'<td>%s</td>\n',varkey.(vars{i}).Unit);
%     %fprintf(fid,'<td>%s</td>\n',varkey.(vars{i}).Symbol);
%     fprintf(fid,'<td>%s</td>\n',varkey.(vars{i}).Programmatic);
%   fprintf(fid,'</tr>\n');
%   end
% fprintf(fid,'</table>\n');
% fprintf(fid,'</sub>\n');
% 

fprintf(fid,'| Variable ID | Name | Units | Category | \n');
fprintf(fid,'| :--- | :----: | :----: | :----: |\n');

for i = 1:length(vars)
    fprintf(fid,'| *%s* | %s | %s | %s |\n',vars{i},varkey.(vars{i}).Name,varkey.(vars{i}).Unit,varkey.(vars{i}).Category);
end
fprintf(fid,'\n');
fprintf(fid,'\n');

fclose(fid);