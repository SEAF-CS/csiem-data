# The National Aeronautics and Space Administration (NASA) Import

## Group for High Resolution Sea Surface Temperature (GHRSST) Data
> [!NOTE]
> This data is imported by the function importNASAGHRSST.py.

### Variable Conversion
| Variable ID | Variable Name | Conversion | Variable in ROMS |
| -------- | -------- | -------- | -------- |
| var00007 | Temperature | 1 | analysed_sst |

### Raw Data
    /GIS_DATA/csiem-data-hub/data-lake/NASA/GHRSST/

### Processed Data
    /GIS_DATA/csiem-data-hub/data-warehouse/csv/nasa/ghrsst/

## Moderate Resolution Imaging Spectroradiometer (MODIS) Data
> [!NOTE]
> This is data is imported by the function importNASAMODIS.py.

### Variable Conversion
| Variable ID | Variable Name | Conversion | Variable in ROMS |
| -------- | -------- | -------- | -------- |
| var00031 | Particulate Organic Carbon | 1 | poc |
| var00059 | Photosynthetically Active Radiation | 2.5162 | par |
| var02740 | Particulate Inorganic Carbon | 1 | pic |

### Raw Data
    /GIS_DATA/csiem-data-hub/data-lake/NASA/MODIS/

### Processed Data
    /GIS_DATA/csiem-data-hub/data-warehouse/csv/nasa/modis/

> [!IMPORTANT]
> The original raw data is combined into a single file for each site before importing.