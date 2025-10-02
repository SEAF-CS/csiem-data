# csiem-data import pipelines

| Agency   | Program / Dataset   | Description                                         | Category           | Ingestion pipeline               | Path to import code   | Date last ingested   |
|:---------|:--------------------|:----------------------------------------------------|:-------------------|:-------------------------|:----------------------|:---------------------|
| AIMS     | TEMP                | Temperature Logger Program                          | PHYSCHEM           | m                                | import/AIMS/TEMP/import_AIMS_TEMP.m                      |  2024-07-09                    |
| BMT      | BNA                 | Breakwater model output                             | HYDRO              | N                                |                       |                      |
| BMT      | SWAN                | SWAN model export                                   | HYDRO              | Y                                | import/BMT/WP/import_BMT_WP_SWAN                   | 2025-02-22                    |
| BOM      | BARRA               | Gridded reanalysis export                           | MET                | Y              |                       |                      |
| BOM      | IDO                 | Hillary’s tide station                              | HYDRO              | N                                |                       |                      |
| BOM      | IDY                 | Weather stations                                    | MET                | Y                                |                       |                      |
| BOM      | NGIS                | Groundwater data                                    | HYDRO              | N                                |                       |                      |
| BOM      | RAIN                | Rainfall stations                                   | MET                | N                                |                       |                      |
| CSIRO    | SRFME               | Two Rocks transect hydro monitoring                 | HYDRO              | py                                | import_py/CSIRO/importCSIROSRFME.py                      |      2024-11-13                |
| CSIRO    | DALSENO             | CS13 bottom O2 monitoring sensor (*)                | PHYSCHEM           | N                                | import_py/CSIRO/importCSIRO_dalseno.py                      |    2025-09-22                  |
| CSIRO    | ECKLONIA            | Estimated biomass data                              | BENTHIC            | N                                |                       |                      |
| CSIRO    | FILTERFEEDER        | Estimated biomass data                              | BENTHIC            | N                                |                       |                      |
| CSMC     | WQ                  | CSMC data from MAFRL                                | PHYSCHEM, NUTRIENT | Y  |                       |                      |
| CSMC     | SG                  | Seagrass occurrence data                            | BENTHIC            | N                                |                       |                      |
| DEP      | SMCWS               | South Metropolitan Coastal Waters Study WQ data (*) | PHYSCHEM, NUTRIENT | Y                                |                       |                      |
| DOT      | AWAC                | DOT AWAC stations                                   | HYDRO              | N                                |                       |                      |
| DOT      | TIDE                | DOT tide stations                                   | HYDRO              | Y  |                       |                      |
| DOT      | WAVE                | DOT wave buoys                                      | HYDRO              | N                                |                       |                      |
| DPIRD    | CRP                 | Crab Research Program                               | PHYSCHEM           | Y                                |                       |                      |
| DWER     | BORE                | Groundwater monitoring                              | HYDRO              | N                                |                       |                      |
| DWER     | CSMC-phy            | Phytoplankton taxonomy                              | PLANKTON           | Y                                |                       |                      |
| DWER     | CSMC-wq             | CSMC data via WIR                                   | PHYSCHEM, NUTRIENT | Y                                |                       |                      |
| DWER     | CSMOORING           | WQ mooring deployments, incl spectral light         | LIGHT              | Y  |                       |                      |
| DWER     | SCE-phy             | Phytoplankton taxonomy                              | PLANKTON           | N                                |                       |                      |
| DWER     | SCE-est             | Estuary monitoring                                  | PHYSCHEM, NUTRIENT | Y                                |                       |                      |
| ESA      | GC-Optics           | GlobColor ocean color satellite exports             | LIGHT              | Y                                |                       |                      |
| ESA      | GC-Plankton         |                                                     | PLANKTON           | Y                                |                       |                      |
| ESA      | GC-PP               |                                                     | PLANKTON           | Y                                |                       |                      |
| ESA      | GC-Reflectance      |                                                     | LIGHT              | Y                                |                       |                      |
| ESA      | GC-Transp           |                                                     | PHYSCHEM           | Y                                |                       |                      |
| ESA      | SEN-NC              | Sentinel satellite exports                          | PHYSCHEM           | Y                                |                       |                      |
| FPA      | MQMP                | Marine Quality Monitoring Program                   | PHYSCHEM, NUTRIENT | Y                                |                       |                      |
| FPA      | TIDE                | Tidal stations                                      | HYDRO              | N                                |                       |                      |
| GA       | SKENE               | Skene et al sediment survey                         | SEDIMENT           | N                                |                       |                      |
| IMOS     | AMNM                | Rottnest IMOS mooring data                          | HYDRO              | Y                                |                       |                      |
|          |                     |                                                     | PHYSCHEM           | Y                                |                       |                      |
| IMOS     | REF                 | Rottnest IMOS bgc / plankton data                   | NUTRIENT           | Y                                |                       |                      |
|          |                     |                                                     | PLANKTON           | Y                                |                       |                      |
| IMOS     | SOOP                | Ships of Opportunity (ferries and RV)               | PHYSCHEM           | Y                                |                       |                      |
|          | SRS                 | Selected Satellite Remote Sensing exports           | PHYSCHEM           | N                                |                       |                      |
| JPPL     | AWAC                | AWAC station                                        | HYDRO              | N                                |                       |                      |
| MOI      | NEMO                | Global model outputs                                | PHYSCHEM, NUTRIENT | Y                                |                       |                      |
| MOI      | PISCES              |                                                     |                    | Y                                |                       |                      |
| MOI      | SEAPODYM            |                                                     |                    | Y                                |                       |                      |
| NASA     | GHRSST              | Synthesized daily temperature                       | PHYSCHEM           | Y                                |                       |                      |
| NASA     | MODIS               | PAR/PIC/POC                                         | NUTRIENT           | Y                                |                       |                      |
| NESP     | NOD                 | National outfall database - WCWA monthly effluent   | HYDRO,             | N                                |                       |                      |
|          |                     |                                                     | NUTRIENT           | N                                |                       |                      |
| UKMO     | OSTIA               | Synthesized daily temperature                       | PHYSCHEM           | Y                                |                       |                      |
| UWA      | AED                 | Gedaria phytoplankton / cytometry data              | PLANKTON           | Y                                |                       |                      |
| UWA      | CWR                 | SMCWS CTD data                                      | PHYSCHEM           | Y                                |                       |                      |
| UWA      | OI                  | Kendrick light data                                 | LIGHT              | N                                |                       |                      |
| UWA      | WAWAVES             | Hillary’s wave buoy data                            | HYDRO              | Y                                |                       |                      |
| WAMSI    | WWMSP1-wrf          | WRF model export                                    | MET                |               |                       |                      |
| WAMSI    | WWMSP2-light        | Spectral light data                                 | LIGHT              | Y                                |                       |                      |
| WAMSI    | WWMSP2-seagrass     | ECU synthesis of historical seagrass & epiphytes    | BENTHIC            | Y                                |                       |                      |
| WAMSI    | WWMSP2-waves        | Wave data                                           | HYDRO              | N                                |                       |                      |
| WAMSI    | WWMSP2-sgpar        | Light data                                          | LIGHT              | Y                                |                       |                      |
| WAMSI    | WWMSP3-ctd          | MAFRL CTD cast data                                 | PHYSCHEM           | Y                                |                       |                      |
| WAMSI    | WWMSP3-seddep       | MAFRL sediment deposition expt data                 | SEDIMENT           | Y                                |                       |                      |
| WAMSI    | WWMSP3-sedpsd       | MAFRL sediment deposition expt data                 | SEDIMENT           | Y                                |                       |                      |
| WAMSI    | WWMSP3-sgrest       | MAFRL sediment data at restoration sites            | SEDIMENT           | Y                                |                       |                      |
| WAMSI    | WWMSP3-flux         | SCU sediment metabolism data                        | SEDIMENT           | N                                |                       |                      |
| WAMSI    | WWMSP3-porewater    | Porewater data                                      | SEDIMENT           | N                                |                       |                      |
| WAMSI    | WWMSP4-zoop         | Zooplankton survey data                             | PLANKTON           | Y                                |                       |                      |
| WAMSI    | WWMSP5-adcp         | Cockburn ADCP deployment                            | HYDRO              | Y                                |                       |                      |
| WAMSI    | WWMSP5-met          | Boat club met station                               | MET                | Y                                |                       |                      |
| WAMSI    | WWMSP5-roms         | ROMS T,S model export                               | HYDRO              | Y                                |                       |                      |
| WAMSI    | WWMSP5-waves        | Cockburn wave deployment                            | HYDRO              | Y                                |                       |                      |
| WAMSI    | WWMSP5-wq           | Cockburn O2/PAR deployment                          | PHYSCHEM           | Y                                |                       |                      |
| WAMSI    | WWMSP5-wwm          | WWM wave model export                               | HYDRO              | Y                                |                       |                      |
| WAMSI    | WWMSP8-dolphin      | Dolphin occurrence data                             | PELAGIC            | N                                |                       |                      |
| WAMSI    | WWMSP9-awac         | Wave expt data                                      | HYDRO              | N                                |                       |                      |
| WCWA     | PLOOM               | Historical WWTP outfall monitoring                  | PHYSCHEM, NUTRIENT | Y                                |                       |                      |
| WCWA     | PSDP                | PSDP outfall monitoring (*)                         | PHYSCHEM, NUTRIENT | Y                                |                       |                      |
| WCWA     | SDOOL               | Sepia Depression monitoring                         | PHYSCHEM, NUTRIENT | N                                |                       |                      |
| WCWA     | WC-BMT              | Oxygen data from BMT report (*)                     | PHYSCHEM           | Y                                |                       |                      |
