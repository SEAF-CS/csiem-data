# Wamsi theme 3 CTD
This dataset is imported by running the reformat_ctd.m function and then the function import_theme3ctd_data.m

## Raw Data

## Variables
 - Fluorescence
 - Light Attenuation Coefficient
 - Specific Conductivity
 - Density
 - O2 Saturation
 - Dissolved Oxygen
 - Salinity
 - Secchi Depth
 - Total Suspended Solids
 - Temperature
 - Turbidity
 - pH

## Conversion
![alt text](./CTD%20Conversion.png)

## Import Code
The reformat_ctd.m function reads in all of the files in the data lake and collates them into one file "wwmsp_theme3.1_CTD_reformat_bbusch_working.csv"


The import code loops over variable and then site matching both and processes the variable.