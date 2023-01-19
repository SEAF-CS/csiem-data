clear all; close all; fclose all;
rdir = 'Cockburn/';


if exist(rdir,'dir')
    rmdir(rdir, 's');
end


addpath(genpath('Functions'));

header_file = 'cockburn_header.m';



if ~exist(rdir,'dir')
    mkdir(rdir);
end

unzip('V:/data-lake/bom/idy/idy.zip',rdir);

% % % 
getBoMmetdata(rdir,header_file);
% 

if exist(rdir,'dir')
    rmdir(rdir, 's');
end

