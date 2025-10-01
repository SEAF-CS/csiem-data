clear all; close all;
addpath(genpath('../functions'));
csiem_data_paths 
tic

import_var_key_info;
import_site_key;
csiem_file_cleaner

%not in use
import_imos_srs = 0;

import_dwer = 0;%
import_dwer_swanest_phy = 0;
import_dot = 0;
import_bom = 0;
import_mafrl = 0;
import_imos = 0;
import_dpird = 0;
import_moorings = 0;%
import_wamsitheme1 = 0;
import_theme2 = 0;
import_theme3 = 0;
import_wamsitheme4 = 0;
import_theme5 = 0;
import_wc = 0;
import_fpa = 0;
import_bmt_wp_swan = 0;

import_UKMO = 0;
import_NASA = 0;
import_aims = 0;
import_dwer_cs_phy = 0;
import_IMOSPlanktonvar = 0;
import_WCWA1Phyto = 0;
import_WCWA2Phyto = 0;
import_WCWA3_9Phyto = 0;
import_WCWA10_15Phyto = 0;
import_WCWA16_22Phyto = 0;
import_WCWA23_28Phyto = 0;
import_WCWA29Phyto = 0;
import_WCWA30Phyto = 0;
import_WCWA31Phyto = 0;
import_WCWA32Phyto = 0;

import_UWA_AED_Phyto = 0;%

import_wamsiwaves = 0;



create_smd = 0;

create_single_matfiles = 0;
create_matfiles = 0;
create_parquet = 0;

create_dataplots = 1;
plotnew_dataplots = 1;

create_shapefiles = 0;

run_agency_marvl = 0;

run_marvl = 0;


%___________________________________________________________________________

% Import Scripts.....

%___________________________________________________________________________



if import_dwer
    disp('PipeLine Importing: DWER')
    % DWER Export
    cd ../import/DWER;
    
    %run_WIR_import_v2;
    export_wir_v2_stage1;
    import_and_reformat_flatfile;
    
    % export_wir;clear all; close all;
    cd ../../actions
end

if import_dwer_swanest_phy
    disp('PipeLine Importing: DWER swanest phy')
    cd ../import/DWER/SWANESTPHY/
        DWER_SWANEST_PHY_Groups_Staging
        DWER_SWANEST_PHY_Groups_Staged
        DWER_SWANEST_PHY_Species
    cd ../../actions/
end

if import_dwer_cs_phy
    disp('PipeLine Importing: DWER CS phy')
    cd ../import/DWER/CSPHY/
    import_CSPHY_SPECIES
    import_CSPHY_GROUP_STAGING
    import_CSPHY_GROUP
    cd ../../../actions/
end


% DOT Export

if import_dot
    disp('PipeLine Importing: DOT')
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
    disp('PipeLine Importing: BOM')
    %BOM Export
    cd ../import/BOM;
    run_BOM_IDY;
    import_BOM_BARRA_TFV;

    cd ../../actions
end

%MAFRL
if import_mafrl
    disp('PipeLine Importing: MAFRL')
    cd ../import/MAFRL/
    
    import_mafrl_2_csv;
    merge_files;
    
    
    cd ../../actions
end


%IMOS
if import_imos
    disp('PipeLine Importing: IMOS')
    cd ../import/IMOS
    
    import_imos_bgc_2_csv;
    %
    import_imos_profile_2_csv;
    %
    import_imos_profile_2_2010_csv;
    
    merge_files;

    import_imos_amnm_adcp;
    
    % Needs updating
    % import_imos_profile_2_csv_BURST;
    %
    % import_imos_profile_2_csv_BURST2;
    
    
    cd ../../actions
end

if import_imos_srs
    disp('PipeLine Importing: IMOS SRS')
    cd ../import/IMOS_SRS/
    import_IMOS_SRS_L3S_netcdf_data;
    import_IMOS_SRS_MODIS_netcdf_data;
    import_IMOS_SRS_MODIS_OC3_netcdf_data;
    cd ../../actions/
end

if import_dpird
    % DPIRD
    disp('PipeLine Importing: DPIRD')
    cd ../import/DPIRD
    
    import_dpird_crp_data;
    
    cd ../../actions/
end

if import_moorings
    % DWER Mooring
    disp('PipeLine Importing: DWER Moorings')
    cd ../import/DWER_Mooring
    
    import_csmooring;
    
    cd ../../actions/
end

if import_theme2
    % wamsi_theme2

    disp('PipeLine Importing: WWMSP2')
    cd ../import/wamsi_theme2
    
    import_theme2_light;
    import_theme2_seagrass;
    cd ../../actions/
end

if import_theme3
    % wamsi_theme3
    disp('PipeLine Importing: WWMSP3')
    cd ../import/wamsi_theme3/CTD
    reformat_ctd;
    import_theme3ctd_data;
    
    cd ../../../actions/

    %Sediment
    cd ../import/wamsi_theme3/SEDPSD
    run ImportSEDPSDMain
    cd ../../actions

    cd ../import/wamsi_theme3/SGREST
    run ImportSGRESTMain
    cd ../../actions

    cd ../import/wamsi_theme3/SEDDEPO
    run IMPORTSEDDEPO
    cd ../../actions

    
end

if import_wamsitheme4
    disp('PipeLine Importing: WWMSP4')
    cd ../import/wamsi_theme4/
    run import_ZooPlankton
    cd ../../actions
end


if import_wc
    % WC_Digitised
    disp('PipeLine Importing: WCWA')
    cd ../import/WCWA
    import_wc_digitised_dataset;
    import_wc_digitised_dataset_b;

    import_PhyWQ_1334_09;
    
    cd ../../actions/
end

if import_fpa
    disp('PipeLine Importing: FPA')
    cd ../import/FPA;
    import_fpa_mqmp;
    cd ../../actions;
end


%WAMSI
if import_theme5
    disp('PipeLine Importing: WWMSP5')
    cd ../import/wamsi_theme5
    
    import_wwmsp5_wq;
    import_wwmsp5_awac;
    import_wwmsp5_met;

    cd Waves/
    import_Waves
    cd ../

    cd WWM/
    importWWM
    cd ../

    cd ../../actions/
end

if import_wamsiwaves
    disp('PipeLine Importing: WWMSP5 Waves')
    cd ../import/wamsi_theme5/Waves
    import_Waves
    cd ../

    cd ../../actions/
end


if import_bmt_wp_swan
    disp('PipeLine Importing: BMT WP SWAN')
    cd ../import/BMT/WP/
    import_BMT_WP_SWAN
    cd ../../../actions/
end

if import_UKMO
    disp('PipeLine Importing: UKMO')
    cd ../import/UKMO
    virtualEnvironmentPath = [datapath,'code/PyBusch/bin/python3'];
    system( [virtualEnvironmentPath,' ImportUKMO_OSTIA.py']) 
    cd ../../actions/
end

if import_NASA
    disp('PipeLine Importing: NASA')
    cd ../import/NASA

        cd GHRSST
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
    disp('PipeLine Importing: WWMSP1')
    cd ../import/wamsi_theme1/
    ImportWRF
    cd ../../actions/
end

if import_aims
    disp('PipeLine Importing: AIMS')
    cd ../import/AIMS/TEMP/
    import_AIMS_TEMP
    cd ../../../actions
end

if import_IMOSPlanktonvar
    disp('PipeLine Importing: IMOSPHYTO')
    cd ../import/IMOS/IMOSPHYTO/
    import_IMOSPlankton

    Holding_IMOSPlanktonGroup 
    import_IMOSPlanktonGroup

    cd ../../../actions/
end

if import_WCWA1Phyto
    disp('PipeLine Importing: WCWA PHYTO1')
    cd ../import/WCWA/Phytoplankton/WCWA1
    import_phytoplankton1_Species
    import_phytoplankton1_Group
    cd ../../../../actions/
end

if import_WCWA2Phyto 
    disp('PipeLine Importing: WCWA PHYTO2')
    cd ../import/WCWA/Phytoplankton/WCWA2
    import_phytoplankton2_Species
    import_phytoplankton2_Group
    cd ../../../../actions/
end

if import_WCWA3_9Phyto
    disp('PipeLine Importing: WCWA PHYTO3-9')
    cd ../import/WCWA/Phytoplankton/WCWA3-9
    RunALL
    cd ../../../../actions/
end

if import_WCWA10_15Phyto
    disp('PipeLine Importing: WCWA PHYTO10-15')
    cd ../import/WCWA/Phytoplankton/WCWA10-15/
    import_phytoplankton_Group_Staging
    import_phytoplankton_Group_Staged
    import_phytoplankton_Species_Staging
    import_phytoplankton_Species_Staged
    cd ../../../../actions/
end

if import_WCWA16_22Phyto
    disp('PipeLine Importing: WCWA PHYTO16-22')
    cd ../import/WCWA/Phytoplankton/WCWA16-22/
    import_phytoplankton_Group
    import_phytoplankton_Species
    cd ../../../../actions/
end

if import_WCWA23_28Phyto
    disp('PipeLine Importing: WCWA PHYTO23-28')
    cd ../import/WCWA/Phytoplankton/WCWA23-28/
    import_phytoplankton_Group_Staging
    import_phytoplankton_Group_Staged
    import_phytoplankton_Species_Staging
    import_phytoplankton_Species_Staged
    cd ../../../../actions/
end

if import_WCWA29Phyto
    disp('PipeLine Importing: WCWA PHYTO29')
    cd ../import/WCWA/Phytoplankton/WCWA29/
    import_phytoplankton_29_Group_Staging
    import_phytoplankton_29_Group_Staged
    import_phytoplankton_29_Species_Staging
    import_phytoplankton_29_Species_Staged
    cd ../../../../actions/
end

if import_WCWA30Phyto
    disp('PipeLine Importing: WCWA PHYTO30')
    cd ../import/WCWA/Phytoplankton/WCWA30/
    import_phytoplankton_30_Group_Staging
    import_phytoplankton_30_Group_Staged
    import_phytoplankton_30_Species_Staging
    import_phytoplankton_30_Species_Staged
    cd ../../../../actions/
end


if import_WCWA31Phyto
    disp('PipeLine Importing: WCWA PHYTO31')
    cd ../import/WCWA/Phytoplankton/WCWA31/
    import_phytoplankton_31_Group_Staging
    import_phytoplankton_31_Group_Staged
    import_phytoplankton_31_Species_Staging
    import_phytoplankton_31_Species_Staged
    cd ../../../../actions/
end

if import_WCWA32Phyto
    disp('PipeLine Importing: WCWA PHYTO32')
    cd ../import/WCWA/Phytoplankton/WCWA32/
    import_phytoplankton_32_Group_Staging
    import_phytoplankton_32_Group_Staged
    import_phytoplankton_32_Species_Staging
    import_phytoplankton_32_Species_Staged
    cd ../../../../actions/
end


if import_UWA_AED_Phyto
    disp('PipeLine Importing: UWA AED PHYTO')
    cd ../import/UWA/AED/swan-phytoplankton/
        cd subset1/
        PhytoGroup
        PhytoSpecies 
        cd ../

        cd subset2/
        PhytoGroup
        PhytoSpecies 
        cd ../
    cd ../../../../actions/
end





if create_smd
    disp('PipeLine SMD')
    calculate_SMD_for_headers
end

if create_single_matfiles
    disp('PipeLine Matfiles')
    csv_2_matfile_tfv_by_agency_single('csiro');
end

if create_matfiles
    disp('PipeLine Matfiles')
    csv_2_matfile_tfv_by_agency;
end
if create_parquet
    disp('PipeLine Parquet')
    csv_2_parquet_by_agency;
    %csv_2_parquet_by_category;
end

if create_dataplots
    disp('PipeLine Dataplot')
    plot_datawarehouse_csv_all(plotnew_dataplots);
end

if run_agency_marvl
    disp('PipeLine MARVL')
    for mv = [1 2 0]

        addpath(genpath(marvldatapath));
        create_marvl_config_information_agency(mv,'csiem_WAMSI_public');
        run_AEDmarvl marvl_pipeline_images;
        rmpath(genpath(marvldatapath));

    end
end

if run_marvl
    disp('PipeLine MARVL')
    for mv = [1 2 0]

        addpath(genpath(marvldatapath));
        create_marvl_config_information(mv);
        run_AEDmarvl marvl_pipeline_images;
        rmpath(genpath(marvldatapath));

    end
end

if create_shapefiles
    disp('PipeLine Shapefiles')
    header_to_shapefile;
end

B = toc;

disp(['Total Runtime: ',num2str(B/(60*60)),' Hours']);





