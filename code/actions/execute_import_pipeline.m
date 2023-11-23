clear all; close all;
addpath(genpath('../functions'));
tic

import_var_key_info;
import_site_key;


import_dwer = 0;
import_dot = 0;
import_bom = 0;
import_mafrl = 0;
import_imos = 0;
import_dpird = 0;
import_moorings = 0;
import_theme2 = 0;
import_theme3 = 0;
import_theme5 = 0;
import_wc = 0;
import_fpa = 0;

create_smd = 1;

create_matfiles = 1;
create_parquet = 1;

create_dataplots = 1;
plotnew_dataplots = 1;



if import_fpa
    cd ../import/FPA;
    import_fpa_mqmp;
    cd ../../actions;
end


if import_dwer
    % DWER Export
    cd ../import/DWER;
    
    run_WIR_import_v2;
    export_wir_v2_stage1;
    import_and_reformat_flatfile;
    
    % export_wir;clear all; close all;
    cd ../../actions
end
% DOT Export

if import_dot
    cd ../import/DOT;
    
    
    import_bar_tidal_data;
    %
    import_freo_tidal_data;
    %
    import_hil_tidal_data;
    %
    import_mgb_tidal_data;
    
    cd ../../actions
end

if import_bom
    %BOM Export
    cd ../import/BOM;
    run_bom_import;
    cd ../../actions
end
%MAFRL
if import_mafrl
    cd ../import/MAFRL/
    
    import_mafrl_2_csv;
    merge_files;
    
    
    cd ../../actions
end


%IMOS
if import_imos
    cd ../import/imos
    
    import_imos_bgc_2_csv;
    %
    import_imos_profile_2_csv;
    %
    import_imos_profile_2_2010_csv;
    
    merge_files;
    
    % Needs updating
    % import_imos_profile_2_csv_BURST;
    %
    % import_imos_profile_2_csv_BURST2;
    
    
    cd ../../actions
end


if import_dpird
    % DPIRD
    cd ../import/dpird
    
    import_dpird_crab_data;
    
    cd ../../actions/
end

if import_moorings
    % DWER Mooring
    cd ../import/DWER_Mooring
    
    import_mooring_data_v2;
    
    cd ../../actions/
end

if import_theme2
    % wamsi_theme2
    cd ../import/wamsi_theme2
    
    import_theme2_light;
    
    cd ../../actions/
end

if import_theme3
    % wamsi_theme3
    cd ../import/wamsi_theme3
    reformat_ctd;
    import_theme3ctd_data;
    
    cd ../../actions/
end

if import_wc
    % WC_Digitised
    cd ../import/WC_Digitised
    import_wc_digitised_dataset;
    import_wc_digitised_dataset_b;
    
    cd ../../actions/
end
%WAMSI
if import_theme5
    cd ../import/wamsi_theme5
    
    import_netcdf_csv;
    import_netcdf_csv_ADCP;
    import_met_csv;
    cd ../../actions/
end

if create_smd
    calculate_SMD_for_headers
end

if create_matfiles
    csv_2_matfile_tfv_by_agency;
end
if create_parquet
    csv_2_parquet_by_agency;
    csv_2_parquet_by_category;
end

if create_dataplots
    plot_datawarehouse_csv_all(plotnew_dataplots);
end
B = toc;

disp(['Total Runtime: ',num2str(B/(60*60)),' Hours']);





