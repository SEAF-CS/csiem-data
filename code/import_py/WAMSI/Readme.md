# Western Australian Marine Science Institution (WAMSI) Import

## Westport Marine Science Program (WWMSP5) Regional Ocean Modelling Systems (ROMS) Data
> [!NOTE]
> This data is imported by the function importWAMSIWWMSP5ROMS.py.

### Variable Conversion
| Variable ID | Variable Name | Conversion | Variable in ROMS |
| -------- | -------- | -------- | -------- |
| var00006 | Salinity | 1 | salt |
| var00007 | Temperature | 1 | temp |

### Raw Data
    \CSIEM\1.6.0\csiem-data\data-lake\WAMSI\WWMSP5\ROMS\

### Processed Data
    G:\CSIEM\1.6.0\csiem-data\data-warehousecsv/wamsi/wwmsp5/roms
## Westport Marine Science Program (WWMSP4)

### Chlorophyll-a (CHLA)
> [!NOTE]
> Imported by importWAMSIWWMSP4_chla.py.
### Variable Conversion
| Variable ID | Variable Name | Conversion | Variable in WWMSP4_zoop |
| -------- | -------- | -------- | -------- |
| var00014 | Chlorophyll-a | 1 | Total chlorophyll |

### Raw Data
   \CSIEM\1.6.0\csiem-data\data-lake\WAMSI\WWMSP4\WWMSP4_zoop
### Processed Data
   \CSIEM\1.6.0\csiem-data\data-warehouse\csv\wamsi\wwmsp4\chla

### Zooplankton (biovolume/biomass)
> [!NOTE]
> Update of the Zooplankton data. Imported by importWAMSIWWMSP4_zoop.py.

### Variable Conversion
| Variable ID | Variable Name | Conversion | Variable in WWMSP4_zoop|
| -------- | -------- | -------- | -------- |
| var02824 | Total Zooplankton Biomass | 1 | Total Zooplankton Biomass |
| var02825 | Predator Biomass | 1 | Predator Biomass |
| var02826 | Grazer Biomas | 1 | Grazer Biomas |

### Raw Data
   \CSIEM\1.6.0\csiem-data\data-lake\WAMSI\WWMSP4\WWMSP4_zoop
### Processed Data
   \CSIEM\1.6.0\csiem-data\data-warehouse\csv\wamsi\wwmsp4\zooplankton2




