# Raw Data
This dataset is structured into sheets, where each sheet contains a different years data. Each sheet is setup as a table that's columns are site, date and then all of the other variables this dataset contains. The rows are unique entries of the columns data.

# Imported Variables
  - Dissolved Oxygen
  - Ammonium
  - Chlorophyll-a
  - Chlorophyll-b
  - Chlorophyll-c
  - Density
  - Filterable Reactive Phosphate
  - Fluorescence
  - Light Attenuation Coefficient
  - Nitrate
  - O2 Saturation
  - Organic Nitrogen
  - Organic Phosphorus
  - Particulate Organic Carbon
  - pH
  - Salinity
  - Secchi Depth
  - Specific Conductivity
  - Temperature
  - Total Nitrogen
  - Total Phosphorus
  - Total Suspended Solids
  - Turbidity

# Import Code
The import code for this dataset is "import_mafrl_2_csv.m". This import code reads in one sheet at a time. Determines all/ how many sites there are in that sheet, Matches those sites to our naming scheme then iterates through each site, and any of the variables that are attacthed to those sites. The type depth data for each variable is stored in our variable key, once the type of depth is determined the code has a switch statement that will match for the correct depth/height. This is done for all sheets/years.