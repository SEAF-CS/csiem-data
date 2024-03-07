function run_bom_import
lakedir = '../../../../data-lake/BOM/idy/idy/';
%'D:\csiem\data-lake\BOM\idy\idy\';

addpath(genpath('Functions'));

header_file = 'cockburn_header.m';

% % % 
getBoMmetdata(lakedir,header_file);
% 
export_metdata_2_csv;

% if exist(rdir,'dir')
%     rmdir(rdir, 's');
% end

