# Bureau Of Meteorology Import

## SWAN Meteorology Data
    This data has been downloaded from BOM website to the data lake and extracted to a text file. This text file is laid out so that all of the columns are variables, site or other relevant information, and each row is a new entry of a data point. This is read in and then imported into our format using the matlab script run_BOM_IDY.m

### Variables
 - Precipitation
 - Air Temperature
 - Wet Bulb Air Temperature
 - Dew Point Temperature
 - Relative Humidity
 - Wind Speed
 - Wind Direction
 - Wind Speed (max)
 - Cloud Amount of First Group in Eighths
 - Cloud Height of First Group
 - Cloud Amount of Second Group in Eighths
 - Cloud Height of Second Group
 - Cloud Amount of Third Group in Eighths
 - Cloud Height of Third Group
 - Cloud Amount of Fourth Group in Eighths
 - Cloud Height of Fourth Group
 - Ceilometer Cloud Amount of First Group
 - Ceilometer Cloud Height of First Group
 - Ceilometer Cloud Amount of Second Group
 - Ceilometer Cloud Height of Second Group
 - Ceilometer Cloud Amount of Third Group
 - Ceilometer Cloud Height of Third Group
 - Ceilometer Sky Clear Flag
 - Horizontal Visibility
 - AWS Visibility
 - Present Weather in Code
 - Mean sea level pressure in hPa
 - Station Level Pressure
 - Water Surface Height
 - Temperature
 - Air Temperature
 - Station Level Pressure
 - Wind Direction
 - Wind Speed

### Conversion
![Conversion for BOM data](./BOM%20conversion.png)
## BARRA TFV
    This data set is simulated using data from pre existing sites. It is imported by import_Barra_TFV.m

### Variables
- eastern wind speed at 10 m height
- northern wind speed at 10 m height
- mslp
- lwsfcdown
- Photosynthetically Active Radiation
- temp_scrn
- Precipitation Rate
- Relative Humidity

### Raw Data
This code Imports the above variables from a few simple tables, in csv format, the files are located in the directory : /GIS_DATA/csiem-data-hub/data-lake/BOM/barra_tfv/. Columns are variables and the rows are each entry.

### Conversion
![Conversion for BOM Barra](./BOM%20Barra%20Conversion.png)

