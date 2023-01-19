clear all; close all;

fid = fopen('../../../cseim-data-wiki/_Sidebar.md','wt');

fid1 = fopen('sidebar_main.txt','rt');

while ~feof(fid1)
    fline = fgetl(fid1);
    fprintf(fid,'%s\n',fline);
end
fclose(fid1);

fid1 = fopen('sidebar_image.txt','rt');
while ~feof(fid1)
    fline = fgetl(fid1);
    fprintf(fid,'%s\n',fline);
end

fclose(fid1);
for kk = 1:4; fprintf(fid,'\n'); end

fid1 = fopen('sidebar_image_2.txt','rt');
while ~feof(fid1)
    fline = fgetl(fid1);
    fprintf(fid,'%s\n',fline);
end

fclose(fid1);


fclose(fid);

