# European Space Agency (ESA) Import

## Global Ocean Colour (GLOBCOLOR)
> [!NOTE]
> This data is imported by the function importESAGLOBCOLOR.py.

### Variable Conversion
| Variable ID | Variable Name | Conversion | Variable in ROMS |
| -------- | -------- | -------- | -------- |
| var00014 | Chlorophyll-a | 1 | CHL |
| var00140 | Secchi Depth | 1 | ZSD |
| var00240 | Diato | 1 | DIATO |
| var00241 | Dino | 1 | DINO |
| var02718 | Backscattering Coefficient | 1 | BBP |
| var02719 | Colored Dissolved Organic Matter | 1 | CDM |
| var02720 | Green Algae | 1 | GREEN |
| var02721 | Haptophytes | 1 | HAPTO |
| var02722 | Microplankton | 1 | MICRO |
| var02723 | Nanoplankton | 1 | NANO |
| var02724 | Picoplankton | 1 | PICO |
| var02725 | Prochlorococcus | 1 | PROCHLO |
| var02726 | Prokaryotes | 1 | PROKAR |
| var02727 | Primary Production | 1 | PP |
| var02728 | RS reflectance at 412nm | 1 | RRS412 |
| var02729 | RS reflectance at 443nm | 1 | RRS443 |
| var02730 | RS reflectance at 490nm | 1 | RRS490 |
| var02731 | RS reflectance at 555nm | 1 | RRS555 |
| var02732 | RS reflectance at 670nm | 1 | RRS670 |
| var02738 | Diffuse Attenuation Coefficient at 490nm | 1 | KD490 |
| var02739 | Suspended particulate matter | 1 | SPM |

### Raw Data
    /GIS_DATA/csiem-data-hub/data-lake/ESA/GC/

### Processed Data
    /GIS_DATA/csiem-data-hub/data-warehouse/csv/esa/gc/

## Ocean and Land Colour Instrument (OLCI)
> [!NOTE]
> This is data is imported by the function importESASENTINEL.py.

### Variable Conversion
| Variable ID | Variable Name | Conversion | Variable in ROMS |
| -------- | -------- | -------- | -------- |
| var00014 | Chlorophyll-a | 1 | CHL |

### Raw Data
    /GIS_DATA/csiem-data-hub/data-lake/ESA/SEN/

### Processed Data
    /GIS_DATA/csiem-data-hub/data-warehouse/csv/esa/sen/