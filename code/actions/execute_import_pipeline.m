clear all; close all;
addpath(genpath('../functions'));
csiem_data_paths 
tic

% import_var_key_info;
% import_site_key;


import_dwer = 0;
import_dot = 0;
import_bom = 0;
import_mafrl = 0;
import_imos = 0;
import_imos_srs = 0;

import_dpird = 0;
import_moorings = 0;
import_theme2 = 0;

import_theme3 = 0;
import_theme5 = 0;
import_wc = 0;
import_fpa = 0;
import_bmtswan = 0;
import_wamsitheme1 = 0;
import_UKMO = 0;
import_NASA = 0;
import_AIMS = 0;
import_DWERPHYTO = 0;
import_IMOSPlanktonvar = 0;
import_WCWA1Phyto = 1;
import_WCWA2Phyto = 1;
import_WCWA3_9Phyto = 1;
import_UWA_AED_Phyto = 1;

import_wamsiwaves51 = 0;

create_smd = 1;

create_matfiles = 1;
create_parquet = 1;

create_dataplots = 1;
plotnew_dataplots = 0;

create_shapefiles = 1;


run_marvl = 1;


%___________________________________________________________________________

% Import Scripts.....

%___________________________________________________________________________



if import_fpa
    cd ../import/FPA;
    import_fpa_mqmp;
    cd ../../actions;
end


if import_dwer
    % DWER Export
    cd ../import/DWER;
    
    %run_WIR_import_v2;
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
    import_Barra_TFV;

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
    cd ../import/IMOS
    
    import_imos_bgc_2_csv;
    %
    import_imos_profile_2_csv;
    %
    import_imos_profile_2_2010_csv;
    
    merge_files;

    import_imos_temp_sal;
    
    % Needs updating
    % import_imos_profile_2_csv_BURST;
    %
    % import_imos_profile_2_csv_BURST2;
    
    
    cd ../../actions
end

if import_imos_srs
    cd ../import/IMOS_SRS/
    %import_IMOS_SRS_L3S_netcdf_data;
    %import_IMOS_SRS_MODIS_netcdf_data;
    %import_IMOS_SRS_MODIS_OC3_netcdf_data;
    cd ../../actions/
end

if import_dpird
    % DPIRD
    cd ../import/DPIRD
    
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
    import_theme2_seagrass;
    cd ../../actions/
end

if import_theme3
    % wamsi_theme3
    cd ../import/wamsi_theme3/CTD
    reformat_ctd;
    import_theme3ctd_data;
    
    cd ../../../actions/

    %Sediment
    cd ../import/wamsi_theme3/SEDPSD
    run ImportSEDPSDMain
    cd ../../../actions

    cd ../import/wamsi_theme3/SGREST
    run ImportSGRESTMain
    cd ../../../actions

    cd ../import/wamsi_theme3/SEDDEPO
    run IMPORTSEDDEPO
    cd ../../../actions

    
end

if import_wc
    % WC_Digitised
    cd ../import/WCWA
    import_wc_digitised_dataset;
    import_wc_digitised_dataset_b;

    import_PhyWQ_1334_09;
    
    cd ../../actions/
end
%WAMSI
if import_theme5
    cd ../import/wamsi_theme5
    
    import_netcdf_csv;
    import_netcdf_csv_ADCP;
    import_met_csv;

    cd Waves5.1/
    Waves51
    cd ../

    cd Waves5.2/
    importWAVES
    cd ../

    cd ../../actions/
end

if import_wamsiwaves51
    cd ../import/wamsi_theme5/Waves5.1
    Waves51
    cd ../

    cd ../../actions/
end


if import_bmtswan
    cd ../import/BMT-SWAN
    importSWAN
    cd ../../actions/
end

if import_UKMO
    cd ../import/UKMO
    system('python3 ImportUKMO.py') 
    cd ../../actions/
end

if import_NASA
    cd ../import/NASA

        cd ASMR_E
        ImportNASASST
        cd ..
        
    cd ../../actions/
end


%if  import_met_models
%    cd ../import/BARRA
%    import_export_barra;
%    cd ../../actions/
%end

if import_wamsitheme1
    cd ../import/wamsi_theme1/
    ImportWRF
    cd ../../actions/
end

if import_AIMS
    cd ../import/AIMS/TEMP/
    AIMSTEMP
    cd ../../../actions
end

if import_DWERPHYTO
    cd ../import/DWER/DWER_PhytoPlakton/
    import_PhytoPlanktonSpecies

    CSV_HoldingPlanktonGroup
    import_PhytoPlanktonGroup
    cd ../../../actions/
end

if import_IMOSPlanktonvar
    cd ../import/IMOS/IMOSPHYTO/
    import_IMOSPlankton

    Holding_IMOSPlanktonGroup 
    import_IMOSPlanktonGroup

    cd ../../../actions/
end

if import_WCWA1Phyto
    cd ../import/WCWA/Phytoplankton/WCWA1
    import_phytoplankton1_Species
    import_phytoplankton1_Group
    cd ../../../../actions/
end

if import_WCWA2Phyto
    cd ../import/WCWA/Phytoplankton/WCWA2
    import_phytoplankton2_Species
    import_phytoplankton2_Group
    cd ../../../../actions/
end

if import_WCWA3_9Phyto
    cd ../import/WCWA/Phytoplankton/WCWA3-9
    RunALL
    cd ../../../../actions/
end

if import_UWA_AED_Phyto
    cd ../import/UWA/AED/swan-phytoplankton/
        cd subset1/
        PhytoGroup
        %PhytoSpeciesNOTDONE 
        cd ../

        cd subset2/
        PhytoGroup
        PhytoSpecies 
        cd ../
    cd ../../../../actions/
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

if run_marvl
    addpath(genpath(marvldatapath));
    create_marvl_config_information;
    run_AEDmarvl marvl_pipeline_images;
    rmpath(genpath(marvldatapath));
end

if create_shapefiles
    header_to_shapefile;
end

B = toc;

disp(['Total Runtime: ',num2str(B/(60*60)),' Hours']);





