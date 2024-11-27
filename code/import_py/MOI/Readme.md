# Mercator Ocean International (MOI) Import

## Nucleus for European Modelling of the Ocean (NEMO) Data
> [!NOTE]
> This data is imported by the function importMOINEMO.py.

### Variable Conversion
| Variable ID | Variable Name | Conversion | Variable in ROMS |
| -------- | -------- | -------- | -------- |
| var00006 | Salinity | 1 | so |

### Raw Data
    /GIS_DATA/csiem-data-hub/data-lake/MOI/NEMO/

### Processed Data
    /GIS_DATA/csiem-data-hub/data-warehouse/csv/moi/nemo/

## Pelagic Interactions Scheme for Carbon and Ecosystem Studies (PISCES) Data
> [!NOTE]
> This is data is imported by the function importMOIPISCES.py.

### Variable Conversion
| Variable ID | Variable Name | Conversion | Variable in ROMS |
| -------- | -------- | -------- | -------- |
| var00014 | Chlorophyll-a | 1 | chl |
| var00023 | Dissolved Oxygen | 0.032 | o2 |
| var00024 | Reactive Silica | 0.0281 | si |
| var00026 | Nitrate | 0.014 | no3 |
| var00027 | Filterable Reactive Phosphate | 0.031 | po4 |
| var00137 | pH | 1 | ph |
| var00139 | Total Alkalinity | 100.09 | talk |
| var00216 | Light Attenuation Coefficient | 1 | kd |
| var00267 | Dissolved Inorganic Carbon | 12 | dissic |
| var02496 | Dissolved Iron | 0.055845 | fe |
| var02733 | Total Primary Production of Phyto | 1 | nppv |
| var02734 | Surface Partial Pressure of CO2 | 1 | spco2 |
| var02735 | Phytoplankton | 1 | phyc |

### Raw Data
    /GIS_DATA/csiem-data-hub/data-lake/MOI/PISCES/

### Processed Data
    /GIS_DATA/csiem-data-hub/data-warehouse/csv/moi/pisces/

## Spatial Ecosystem and Population Dynamics Model (SEAPODYM) Data
> [!NOTE]
> This is data is imported by the function importMOISEAPODYM.py.

### Variable Conversion
| Variable ID | Variable Name | Conversion | Variable in ROMS |
| -------- | -------- | -------- | -------- |
| var02736 | Net Primary Productivity | 1 | npp |
| var02737 | Zooplankton | 1 | zooc |

### Raw Data
    /GIS_DATA/csiem-data-hub/data-lake/MOI/SEAPODYM/

### Processed Data
    /GIS_DATA/csiem-data-hub/data-warehouse/csv/moi/seapodym/