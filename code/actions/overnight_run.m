import_var_key_info; clear all; close all;


import_site_key;

% DWER Export
cd ../import/DWER;
% export_wir;clear all; close all;
cd ../../actions

% DOT Export
cd ../import/DOT;


% import_bar_tidal_data;clear all; close all;
% 
% import_freo_tidal_data;clear all; close all;
% 
% import_hil_tidal_data;clear all; close all;
% 
% import_mgb_tidal_data;clear all; close all;

cd ../../actions

%BOM Export
cd ../import/BOM;
% export_metdata;clear all; close all;
cd ../../actions

%MAFRL

cd ../import/MAFRL/

import_mafrl_2_csv

cd ../../actions

%IMOS
cd ../import/imos

% import_imos_bgc_2_csv;clear all; close all;
% 
% import_imos_profile_2_csv;clear all; close all;
% 
% import_imos_profile_2_csv_BURST;clear all; close all;
% 
% import_imos_profile_2_csv_BURST2;clear all; close all;
% 
% import_imos_mooring_2_csv;clear all; close all;

cd ../../actions

%WAMSI
cd ../import/wamsi_theme5

% import_netcdf_csv;;clear all; close all;

cd ../../actions/

csv_2_matfile;;clear all; close all;

csv_2_matfile_tfv;;clear all; close all;

export_seaf_files;

cd ../wiki/

run_wiki;clear all; close all;


