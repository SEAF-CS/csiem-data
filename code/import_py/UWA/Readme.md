# University of Western Australia (UWA) Import

## Centre for Water Research (CWR) Southern Metropolitan Coastal Waters Study (SMCWS) Data
> [!NOTE]
> This data is imported by the function importUWACWR.py.

### Variable Conversion
| Variable ID | Variable Name | Conversion | Variable in ROMS |
| -------- | -------- | -------- | -------- |
| var00006 | Salinity | 1 | SALINITY (pss) |
| var00007 | Temperature | 1 | TEMPERATURE (C) |
| var00218 | Density | 1 | DENSITY (kgm-3) |
| var00284 | Current Velocity | 1 | VELOCITY (ms-1) |
| var02559 | Actual Conductivity | 10000 | CONDUCTIVITY (sm) |

### Raw Data
    /GIS_DATA/csiem-data-hub/data-lake/UWA/CWR/cwrctd

### Processed Data
    /GIS_DATA/csiem-data-hub/data-warehouse/csv/uwa/cwr/cwrctd

## Oceans Institute WA Waves (OIWAWAVES) Data
> [!NOTE]
> This is data is imported by the function importUWAWAWAVES.py.

### Variable Conversion
| Variable ID | Variable Name | Conversion | Variable in ROMS |
| -------- | -------- | -------- | -------- |
| var00007 | Temperature | 1 | SST (degC) |
| var00129 | Wind Direction | 1 | WindDirec (deg) |
| var00130 | Wind Speed | 1 | WindSpeed (m/s) |
| var00271 | Significant Wave Height | 1 | Hsig (m) |
| var00276 | Mean Wave Period | 1 | Tm (s) |
| var00277 | Peak Wave Period | 1 | Tp (s) |
| var00281 | Peak Wave Direction | 1 | Dp (deg) |
| var00283 | Mean Wave Direction | 1 | Dm (deg) |
| var00284 | Current Velocity | 1 | CurrmentMag (m/s) |
| var00285 | Current Direction | 1 | CurrentDir (deg) |
| var02741 | Significant Swell Wave Height | 1 | Hsig_swell (m) |
| var02742 | Significant Sea  Wave Height | 1 | Hsig_sea (m) |
| var02743 | Mean Swell Wave Period | 1 | Tm_swell (s) |
| var02744 | Mean Sea Wave Period | 1 | Tm_sea (s) |
| var02745 | Peak Directional Wave Spread | 1 | DpSpr (deg) |
| var02746 | Mean Swell Wave Direction | 1 | Dm_swell (deg) |
| var02747 | Mean Sea Wave Direction | 1 | Dm_sea (deg) |
| var02748 | Mean Directional Wave Spread | 1 | DmSpr (deg) |
| var02749 | Mean Directional Swell Wave Spread | 1 | DmSpr_swell (deg) |
| var02750 | Mean Directional Sea Wave Spread | 1 | DmSpr_sea (deg) |
| var02751 | Sea Bottom Temperature | 1 | Bottom Temp (degC) |

### Raw Data
    /GIS_DATA/csiem-data-hub/data-lake/UWA/WAWAVES/

### Processed Data
    /GIS_DATA/csiem-data-hub/data-warehouse/csv/uwa/wawaves/