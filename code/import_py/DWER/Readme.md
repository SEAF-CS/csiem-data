# Department of Water and Environmental Regulation (DWER) Imports

## Campaign Context (CSMOORING)
DWER mooring data is organized into four folders (A, B, C, D) in the data lake:
- **A** (`A-20230731`) is handled by the MATLAB importer (`import_csmooring.m`).
- **B** (`B-20250715`), **C** (`C-25ENV427`), and **D** (`D-CS86_DUALMS9`) are handled below.

For A, see:
- [DWER Mooring Importer (A)](../../import/DWER_Mooring/Readme.md)

## CSMOORING - MS9D (CS86 Dual MS9)
> [!NOTE]
> This dataset is imported by `import_py/DWER/importDWER_CSMooring_MS9D.py`.
> Input file: `CS86_Kd_Interpolated_Trustworthy_Hourly.csv`.

### Variable Conversion
| Variable ID | Variable Name | Conversion | Variable in ROMS |
| -------- | -------- | -------- | -------- |
| var00216 | Light Attenuation Coefficient | 1 | WQ_DIAG_TOT_EXTC |

### Raw Data
    \CSIEM\1.7.0\csiem-data\data-lake\DWER\CSMOORING\D-CS86_DUALMS9\

### Processed Data
    \CSIEM\1.7.0\csiem-data\data-warehouse\csv\dwer\csmooring\d\


## CSMOORING - WQB (Cockburn Mooring Data)
> [!NOTE]
> This dataset is imported by `import_py/DWER/importDWER_CSMooring_WQB.py`.
> Input file: `EXO_DataBase_QCed_Level2_combined_FINAL.csv`.

### Variable Conversion
| Variable ID | Variable Name | Conversion | Variable in ROMS |
| -------- | -------- | -------- | -------- |
| var00007 | Temperature | 1 | TEMP |
| var00006 | Salinity | 1 | SAL |
| var00023 | Dissolved Oxygen | 1 | WQ_OXY_OXY |
| var00013 | Turbidity | 1 | WQ_DIAG_TOT_TURBIDITY |
| var00137 | pH | 1 | WQ_CAR_PH |
| var00014 | Chlorophyll-a | 1 | WQ_DIAG_PHY_TCHLA |
| var02693 | Fluorescent Dissolved Organic Matter | 1 | Fluorescent_DOM |

### Raw Data
    \CSIEM\1.7.0\csiem-data\data-lake\DWER\CSMOORING\B-20250715\Cockburn Mooring Data\

### Processed Data
    \CSIEM\1.7.0\csiem-data\data-warehouse\csv\dwer\csmooring\b\



## CSMOORING - WQC (Turbidity Provision)
> [!NOTE]
> This dataset is imported by `import_py/DWER/importDWER_CSMooring_WQC.py`.
> Input files: `*.csv` with `Time` and turbidity columns.
> Source columns `turbidity_qc [ntu]` and `turbidity_raw [ntu]` are mapped to `Turbidity-Neph (NTU)` in the varkey.

### Variable Conversion
| Variable ID | Variable Name | Conversion | Variable in ROMS |
| -------- | -------- | -------- | -------- |
| var00013 | Turbidity | 1 | WQ_DIAG_TOT_TURBIDITY |

### Raw Data
    \CSIEM\1.7.0\csiem-data\data-lake\DWER\CSMOORING\C-25ENV427\25ENV427_DWER Turbidity Data Provision_2025-11-21\

### Processed Data
    \CSIEM\1.7.0\csiem-data\data-warehouse\csv\dwer\csmooring\c\


## Data-Warehouse Quality Control CSMooring B:


### Chlorophyll-a:
  - QC thresholds set from the empirical distribution (e.g., central 99% of values); values outside 0 - 7 ug/l were removed.
  - Modified CSV files: dwermooring6140265_Chlorophyll-a_WQB_DATA
### Dissolved Oxygen:
 - 2-11 mg/L
 - Modified CSV files: dwermooring6140265_Dissolved_Oxygen_WQB_DATA.csv, dwermooring6140266_Dissolved_Oxygen_WQB_DATA.csv, dwermooring6140267_Dissolved_Oxygen_WQB_DATA.csv, dwermooring6140268_Dissolved_Oxygen_WQB_DATA.csv, dwermooring6140269_Dissolved_Oxygen_WQB_DATA.csv, dwermooring6147032_Dissolved_Oxygen_WQB_DATA.csv,dwermooring6147033_Dissolved_Oxygen_WQB_DATA.csv, dwermooring6147036_Dissolved_Oxygen_WQB_DATA.csv, dwermooring6147037_Dissolved_Oxygen_WQB_DATA.csv, dwermooring6140281_Dissolved_Oxygen_WQB_DATA.csv
### Salinity:
 - 30-38 PSU
 - Modified CSV files: dwermooring6140265_Salinity_WQB_DATA.csv, dwermooring6140266_Salinity_WQB_DATA.csv, dwermooring6140267_Salinity_WQB_DATA.csv, dwermooring6140268_Salinity_WQB_DATA.csv, dwermooring6140269_Salinity_WQB_DATA.csv, dwermooring6147032_Salinity_WQB_DATA.csv,dwermooring6147033_Salinity_WQB_DATA.csv, dwermooring6147036_Salinity_WQB_DATA.csv, dwermooring6147037_Salinity_WQB_DATA.csv, dwermooring6140281_Salinity_WQB_DATA.csv
### Temperature:
 - 14-28 C
 - Modified CSV files: dwermooring6140265_Temperature_WQB_DATA.csv, dwermooring6140266_Temperature_WQB_DATA.csv, dwermooring6140267_Temperature_WQB_DATA.csv, dwermooring6140268_Temperature_WQB_DATA.csv, dwermooring6140269_Temperature_WQB_DATA.csv, dwermooring6147032_Temperature_WQB_DATA.csv,dwermooring6147033_Temperature_WQB_DATA.csv, dwermooring6147036_Temperature_WQB_DATA.csv, dwermooring6147037_Temperature_WQB_DATA.csv, dwermooring6140281_Temperature_WQB_DATA.csv 

### pH:
 - 14-28 C
 - Modified CSV files: dwermooring6140265_Temperature_WQB_DATA.csv, dwermooring6140266_Temperature_WQB_DATA.csv, dwermooring6140267_Temperature_WQB_DATA.csv, dwermooring6140268_Temperature_WQB_DATA.csv, dwermooring6140269_Temperature_WQB_DATA.csv, dwermooring6147032_Temperature_WQB_DATA.csv,dwermooring6147033_Temperature_WQB_DATA.csv, dwermooring6147036_Temperature_WQB_DATA.csv, dwermooring6147037_Temperature_WQB_DATA.csv, dwermooring6140281_Temperature_WQB_DATA.csv  