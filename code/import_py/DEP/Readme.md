# Department of Environmental Protection (DEP) Import

## Cockburn Sound Monitoring Program Southern Metropolitan Coastal Waters Study(SMCWS)
> [!NOTE]
> This data is imported by the function importDEPSMCWS.py.

### Variable Conversion
| Variable ID | Variable Name | Conversion | Variable in ROMS |
| -------- | -------- | -------- | -------- |
| var00006 | Salinity | 1 | Salinity |
| var00007 | Temperature | 1 | Temp |
| var00007 | Temperature | 1 | Temperature |
| var00009 | Total Nitrogen | 0.001 | TN |
| var00010 | Total Phosphorus | 0.001 | TP |
| var00014 | Chlorophyll-a | 1 | CHLOROPHYLL a |
| var00014 | Chlorophyll-a | 1 | chl a |
| var00014 | Chlorophyll-a | 1 | Chlorophyll a |
| var00025 | Ammonium | 0.001 | AMMONIA |
| var00025 | Ammonium | 0.001 | NH4 |
| var00027 | Filterable Reactive Phosphate | 0.001 | PHOSPHATE |
| var00027 | Filterable Reactive Phosphate | 0.001 | TIP |
| var00032 | Dissolved Organic Nitrogen | 0.001 | DON |
| var00035 | Dissolved Organic Phosphorus | 0.001 | DOP |
| var00136 | Total Kjeldahl Nitrogen | 0.001 | TKN |
| var00140 | Secchi Depth | 1 | Secchi |
| var00216 | Light Attenuation Coefficient | 1 | AC |
| var02649 | Nitrate Nitrogen | 0.001 | NITRATE-NITRITE |
| var02649 | Nitrate Nitrogen | 0.001 | NO3 |
| var02769 | Light Attenuation Coefficient (6m) | 1 | AC6m |
| var02770 | Total Inorganic Nitrogen | 0.001 | TIN |
| var02771 | Total Dissolved Nitrogen | 0.001 | TDN |
| var02772 | Total Particulate Nitrogen | 0.001 | TPN |
| var02773 | Total Dissolved Phosphorus | 0.001 | TDP |
| var02774 | Total Particulate Phosphorus | 0.001 | TPP |

### Raw Data
    /GIS_DATA/csiem-data-hub/data-lake/DEP/SMCWS/

### Processed Data
    /GIS_DATA/csiem-data-hub/data-warehouse/csv/dep/smcws/

> [!IMPORTANT]
> The raw data is extracted from data report 
> - Water Quality Survey in Cockburn Sound, Warnbro Sound and Sepia Depression between January 1991 and February 1992 by Jennie Cary and Ray Masini
> - Water Quality Survey in the Southern Metropolitan Coastal Waters of Perth between December 1993 and March 1994 by Cary J L. and D' Adamo N
>
> Below variables are not included in the raw data but derived from other variables:
> - Dissolved Organic Phosphorus = Total Dissolved Phosphorus - Filterable Reactive Phosphate
> - Total Dissolved Nitrogen = Total Dissolved Nitrogen - Nitrate Nitrogen - Ammonium
> 
> Missing values are filled with the median of the same month-day from the available data when calculating derived variables.