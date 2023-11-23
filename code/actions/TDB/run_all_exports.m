% DWER Export
cd ../import/DWER;
export_wir;clear all; close all;
cd ../../actions

% DOT Export
cd ../import/DOT;


import_bar_tidal_data;clear all; close all;

import_freo_tidal_data;clear all; close all;

import_hil_tidal_data;clear all; close all;

import_mgb_tidal_data;clear all; close all;

cd ../../actions

%BOM Export
cd ../import/BOM;
export_metdata;clear all; close all;
cd ../../actions



