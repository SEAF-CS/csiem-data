# Department of Water and Environmental Regulation (DWER) Moorings

## Overview
DWER mooring data is organized into four folders (A, B, C, D) in the data lake, each representing a different sampling campaign:
- **A** (`A-20230731`) - WIR export with Cockburn Sound buoy data (water quality + wavelength/PAR CSVs), plus site/variable description files.
- **B** (`B-20250715`) - Cockburn Mooring Data with field reports and QC databases (`EXO_DataBase_QCed_Level2_combined_FINAL.csv`, `MS9_DataBase_QCed_Level2_FINAL.csv`).
- **C** (`C-25ENV427`) - Turbidity provision (Westport and NE Garden Island) for 2022-07-11 to 2022-08-11.
- **D** (`D-CS86_DUALMS9`) - Dual MS9 optics for CS86 with raw data and post-processed including Kd calculations.

This importer corresponds to **A** and is processed by `import_csmooring.m`.

For B, C, and D, see the separate README with the Python importers and their inputs/outputs:
- [DWER Importers (B/C/D)](../../import_py/DWER/Readme.md)

## CSMOORING - A (MATLAB Importer)
> [!NOTE]
> This dataset is imported by `import_csmooring.m`.
> Variables are matched against the DWER varkey in Data Governance (`variable_key.xlsx`, sheet `DWERMOORING`).

### Variable Conversion
| Variable ID | Variable Name | Conversion | Variable in ROMS |
| -------- | -------- | -------- | -------- |
| var00153 | Air Temperature | 1 | AIRTEMP |
| var00007 | Temperature | 1 | TEMP |
| var00013 | Turbidity | 1 | WQ_DIAG_TOT_TURBIDITY |
| var00006 | Salinity | 1 | SAL |
| var00023 | Dissolved Oxygen | 1 | WQ_OXY_OXY |
| var00085 | O2 Saturation | 1 | WQ_DIAG_OXY_SAT |
| var00137 | pH | 1 | WQ_CAR_PH |
| var00008 | Depth | 1 | D |
| var00182 | Tilt | 1 | Tilt |

### Raw Data
Multiple files stored in the data lake with the same format but different variable names. These are matched to the DWER variable key and site key during import.

### Conversion Reference
![DWER MOORING CONVERSION](./DWER%20Conversion.png)


## Data-Warehouse Quality Control

### Dissolved Oxygen:
  - Values outside the range of 2–15 mg/L were removed.
  - Modified CSV files: dwermooring6147030_Dissolved_Oxygen_DATA,dwermooring6147031_Dissolved_Oxygen_DATA,dwermooring6147034_Dissolved_Oxygen_DATA,   dwermooring6147035_Dissolved_Oxygen_DATA
### Temperature:
  - Values outside the range of 12–25 C were removed.
  - Modified CSV files: dwermooring6147030_Temperature_DATA,dwermooring6147031_Temperature_DATA,dwermooring6147034_Temperature_DATA,   dwermooring6147035_Temperature_DATA

#### Salinity:
  - Values outside the range of 33–38 PSU were removed.
  - Additional clips:
    dwermooring6147031_Salinity_DATA.csv: removed values from Aug–Sep 2022 period due to sustained high bias relative to adjacent months.
    dwermooring6147034_Salinity_DATA.csv: removed the mid-record period (late 2021 to Apr 2022) and clipped the high-value period in Aug–Sep 2022.
  - Modified CSV files:dwermooring6147030_Salinity_DATA,dwermooring6147031_Salinity_DATA,dwermooring6147034_Salinity_DATA,dwermooring6147035_Salinity_DATA
### pH: 
  - Negative values were remove.
  - QC thresholds set from the empirical distribution (e.g., central 98% of values); values outside 7.8 - 8.5 were removed.
  - Modified CSV files:dwermooring6147030_pH_DATA,dwermooring6147031_pH_DATA,dwermooring6147034_pH_DATA,dwermooring6147035_pH_DATA
