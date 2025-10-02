# csiem-data import pipelines

| Agency   | Program / Dataset   | Description                                         | Category           | Ingestion pipeline               | Path to import code   | Date last ingested   |
|:---------|:--------------------|:----------------------------------------------------|:-------------------|:-------------------------|:----------------------|:---------------------|
| AIMS     | TEMP                | Temperature Logger Program                          | PHYSCHEM           | m                                | import/AIMS/TEMP/import_AIMS_TEMP.m          |  2024-07-09                    |
| BMT      | BNA                 | Breakwater model output                             | HYDRO              | N                                |                       |                      |
| BMT      | SWAN                | SWAN model export                                   | HYDRO              | m                                | import/BMT/WP/import_BMT_WP_SWAN.m           | 2025-02-22                    |
| BOM      | BARRA               | Gridded reanalysis export                           | MET                | m                                | import/BOM/import_BOM_BARRA_TFV.m            | 2025-02-25                       |
| BOM      | IDO                 | Hillary’s tide station                              | HYDRO              | N                                |                       |                      |
| BOM      | IDY                 | Weather stations                                    | MET                | m                                | import/BOM/export_metdata_2_csv.m            | 2025-02-21                     |
| BOM      | NGIS                | Groundwater data                                    | HYDRO              | N                                |                       |                      |
| BOM      | RAIN                | Rainfall stations                                   | MET                | N                                |                       |                      |
| CSIRO    | SRFME               | Two Rocks transect hydro monitoring                 | HYDRO              | py                               | import_py/CSIRO/importCSIROSRFME.py          | 2024-11-13                |
| CSIRO    | DALSENO             | CS13 bottom O2 monitoring sensor (*)                | PHYSCHEM           | N                                | import_py/CSIRO/importCSIRO_dalseno.py       | 2025-09-22                  |
| CSIRO    | ECKLONIA            | Estimated biomass data                              | BENTHIC            | N                                |                       |                      |
| CSIRO    | FILTERFEEDER        | Estimated biomass data                              | BENTHIC            | N                                |                       |                      |
| CSMC     | WQ                  | CSMC data from MAFRL                                | PHYSCHEM, NUTRIENT | m                                | import/MAFR/import_mafrl_2_csv.m             | 2025-03-13                     |
| CSMC     | SG                  | Seagrass occurrence data                            | BENTHIC            | N                                |                       |                      |
| DEP      | SMCWS               | South Metropolitan Coastal Waters Study WQ data (*) | PHYSCHEM, NUTRIENT | py                               |import_py/DEP/importDEPSMCWS.py               | 2025-02-21                      |
| DOT      | AWAC                | DOT AWAC stations                                   | HYDRO              | N                                |                       |                      |
| DOT      | TIDE                | DOT tide stations                                   | HYDRO              | m                                |import/DOT/|2025-02-21                       |
| DOT      | WAVE                | DOT wave buoys                                      | HYDRO              | N                                |                       |                      |
| DPIRD    | CRP                 | Crab Research Program                               | PHYSCHEM           | m                                | import/DPIRD/import_dpird_crp_data.m         | 2025-02-21                |
| DWER     | BORE                | Groundwater monitoring                              | HYDRO              | N                                |                       |                      |
| DWER     | CSMC-phy            | Phytoplankton taxonomy                              | PLANKTON           | m                                | import/DWER/CSPHY/              | 2025-03-13                      |
| DWER     | CSMC-wq             | CSMC data via WIR                                   | PHYSCHEM, NUTRIENT | Y                                |*                       | 2025-05-04                     |
| DWER     | CSMOORING           | WQ mooring deployments, incl spectral light         | LIGHT              | m                                |import/DWER_Mooring/import_csmooring.m        | 2025-07-03                     |
| DWER     | SCE-phy             | Phytoplankton taxonomy                              | PLANKTON           | N                                |                       |                      |
| DWER     | SCE-est             | Estuary monitoring                                  | PHYSCHEM, NUTRIENT | Y                                |*                      |*                     |
| ESA      | GC-Optics           | GlobColor ocean color satellite exports             | LIGHT              | py                               | import_py/ESA/importESAGLOBCOLOR.py          | 2025-02-21                     |
| ESA      | GC-Plankton         |                                                     | PLANKTON           | py                               | import_py/ESA/importESAGLOBCOLOR.py          | 2025-02-21                     |
| ESA      | GC-PP               |                                                     | PLANKTON           | py                               | import_py/ESA/importESAGLOBCOLOR.py          | 2025-02-21                     |
| ESA      | GC-Reflectance      |                                                     | LIGHT              | py                               | import_py/ESA/importESAGLOBCOLOR.py          | 2025-02-21                     |
| ESA      | GC-Transp           |                                                     | PHYSCHEM           | py                               | import_py/ESA/importESAGLOBCOLOR.py          | 2025-02-21                     |
| ESA      | SEN-NC              | Sentinel satellite exports                          | PHYSCHEM           | py                               | import_py/ESA/importESASENTINEL.py           | 2025-02-21                     |
| FPA      | MQMP                | Marine Quality Monitoring Program                   | PHYSCHEM, NUTRIENT | m                                | import/FPA/import_fpa_mqmp.m                 | 2025-02-21                     |
| FPA      | TIDE                | Tidal stations                                      | HYDRO              | N                                |                       |                      |
| GA       | SKENE               | Skene et al sediment survey                         | SEDIMENT           | N                                |                       |                      |
| IMOS     | AMNM                | Rottnest IMOS mooring data                          | HYDRO              | m                                | import/IMOS /import_imos_amnm_adcp.m         | 2025-01-30                    |
|          |                     |                                                     | PHYSCHEM           | m                                | import/IMOS/  | 2025-01-30                     |
| IMOS     | REF                 | Rottnest IMOS bgc / plankton data                   | NUTRIENT           | m                                | import/IMOS/import_imos_bgc_2_csv.m          |  2025-02-21                  |
|          |                     |                                                     | PLANKTON           | m                                | import/IMOS/IMOSPHYTO/  | 2025-02-22              |
| IMOS     | SOOP                | Ships of Opportunity (ferries and RV)               | PHYSCHEM           | py                               | import_py/IMOS/importIMOSSOOP.py            |  2025-02-21                  |
|          | SRS                 | Selected Satellite Remote Sensing exports           | PHYSCHEM           | N                                |                       |                      |
| JPPL     | AWAC                | AWAC station                                        | HYDRO              | N                                |                       |                      |
| MOI      | NEMO                | Global model outputs                                | PHYSCHEM, NUTRIENT | Y                                |*                      | 2025-02-21           |
| MOI      | PISCES              |                                                     |                    | Y                                |*                      | 2025-02-21           |
| MOI      | SEAPODYM            |                                                     |                    | Y                                |*                      | 2025-02-21                    |
| NASA     | GHRSST              | Synthesized daily temperature                       | PHYSCHEM           | Y                                |*                      | 2025-02-22                     |
| NASA     | MODIS               | PAR/PIC/POC                                         | NUTRIENT           | Y                                |*                      | 2025-02-21                     |
| NESP     | NOD                 | National outfall database - WCWA monthly effluent   | HYDRO,             | N                                |                       |                      |
|          |                     |                                                     | NUTRIENT           | N                                |                       |                      |
| UKMO     | OSTIA               | Synthesized daily temperature                       | PHYSCHEM           | Y                                |*                      | 2025-02-24           |
| UWA      | AED                 | Gedaria phytoplankton / cytometry data              | PLANKTON           | Y                                |*                      | 2025-03-13           |
| UWA      | CWR                 | SMCWS CTD data                                      | PHYSCHEM           | Y                                |*                      | 2025-02-21                      |
| UWA      | OI                  | Kendrick light data                                 | LIGHT              | N                                |                       |                      |
| UWA      | WAWAVES             | Hillary’s wave buoy data                            | HYDRO              | Y                                |*                       | 2025-02-21                      |
| WAMSI    | WWMSP1-wrf          | WRF model export                                    | MET                | Y                                |*                      | 2025-02-22                     |
| WAMSI    | WWMSP2-light        | Spectral light data                                 | LIGHT              | Y                                | *                      | 2025-02-21                     |
| WAMSI    | WWMSP2-seagrass     | ECU synthesis of historical seagrass & epiphytes    | BENTHIC            | Y                                |*                       | 2025-02-21                     |
| WAMSI    | WWMSP2-waves        | Wave data                                           | HYDRO              | N                                |                       |                     |
| WAMSI    | WWMSP2-sgpar        | Light data                                          | LIGHT              | Y                                | *                      | 2025-04-24                      |
| WAMSI    | WWMSP3-ctd          | MAFRL CTD cast data                                 | PHYSCHEM           | Y                                |  *                     | 2025-05-04                      |
| WAMSI    | WWMSP3-seddep       | MAFRL sediment deposition expt data                 | SEDIMENT           | Y                                |*                       | 2025-05-04                      |
| WAMSI    | WWMSP3-sedpsd       | MAFRL sediment deposition expt data                 | SEDIMENT           | Y                                |*                       | 2025-05-04                      |
| WAMSI    | WWMSP3-sgrest       | MAFRL sediment data at restoration sites            | SEDIMENT           | Y                                |*                       | 2025-05-04                      |
| WAMSI    | WWMSP3-flux         | SCU sediment metabolism data                        | SEDIMENT           | N                                |                       |                      |
| WAMSI    | WWMSP3-porewater    | Porewater data                                      | SEDIMENT           | N                                |                       |                      |
| WAMSI    | WWMSP4-zoop         | Zooplankton survey data                             | PLANKTON           | Y                                |*                       | 2025-03-17                     |
| WAMSI    | WWMSP5-adcp         | Cockburn ADCP deployment                            | HYDRO              | Y                                |                       |                      |
| WAMSI    | WWMSP5-met          | Boat club met station                               | MET                | Y                                |*                       | 2025-02-22                     |
| WAMSI    | WWMSP5-roms         | ROMS T,S model export                               | HYDRO              | Y                                |*                       | 2025-02-21                     |
| WAMSI    | WWMSP5-waves        | Cockburn wave deployment                            | HYDRO              | Y                                |*                       | 2025-02-22                     |
| WAMSI    | WWMSP5-wq           | Cockburn O2/PAR deployment                          | PHYSCHEM           | Y                                |*                       | 2025-02-22                       |
| WAMSI    | WWMSP5-wwm          | WWM wave model export                               | HYDRO              | Y                                |*                       | 2025-02-22                     |
| WAMSI    | WWMSP8-dolphin      | Dolphin occurrence data                             | PELAGIC            | N                                |                       |                      |
| WAMSI    | WWMSP9-awac         | Wave expt data                                      | HYDRO              | N                                |                       |                      |
| WCWA     | PLOOM               | Historical WWTP outfall monitoring                  | PHYSCHEM, NUTRIENT | Y                                |*                       | 2025-03-13                     |
| WCWA     | PSDP                | PSDP outfall monitoring (*)                         | PHYSCHEM, NUTRIENT | Y                                |*                       | 2025-02-21                     |
| WCWA     | SDOOL               | Sepia Depression monitoring                         | PHYSCHEM, NUTRIENT | N                                |                       |                      |
| WCWA     | WC-BMT              | Oxygen data from BMT report (*)                     | PHYSCHEM           | Y                                |*                       | *                     |

# Steps to Add a New Resource

- Go to **/csiem-data/data-governance/**  
- Modify **variable_key**:
  - Add the new variable to **MASTER KEY** if it does not already exist, including its respective units and symbols.  
  - Add the new variable to the corresponding agency sheet with its current header and units.  
    - If the dataset units differ from the standard defined in the *MASTER KEY*, provide a conversion value.  
  - Update the new variable in **Model_TFV**.  
    - If the **MASTER KEY** units differ from the TFV units, provide a conversion value.  
- Modify **site_key** if the data collection site has not been added before:  
  - Select the corresponding agency sheet and add the location with its latitude and longitude.  
- Go to **/csiem-data/code/actions** and run **import_site_key.m** and **import_var_key_info.m** to update **sitekey.mat** and **varkey.mat**.  
- Create a Python script to import the data and save it in **/csiem-data/code/import_py/** under the respective agency folder.  
- Modify **/csiem-data/code/actions_py/execute_import_py_pipeline.py** to link the new Python script to the pipeline (see the folder’s `Readme.md` for more details).  
- If the process is successful, a new set of standardized CSV files will be created in **/csiem-data/data-warehouse/csv/**.  
- To generate images of the imported data, go to **/csiem-data/code/actions/execute_import_pipeline.m** and set:  
  - `create_dataplots = 1`  
  - `plotnew_dataplots = 1`  
- To update the new CSVs into the agency `.mat` files, go to **/csiem-data/code/actions/execute_import_pipeline.m** and set:  
  - `create_smd = 1`  
  - `run_agency_marvl = 1` (if only one `.mat` file needs updating)  
  - `run_marvl = 1` (if all `.mat` files need updating). This will convert the CSVs in **/csiem-data/data-warehouse/csv/** into `.mat` files saved in **/csiem-data/data-warehouse/mat/**.
