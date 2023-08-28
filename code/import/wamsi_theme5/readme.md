# WAMSi Theme 5 Data Import

The raw data has been split into 3 catagories:

- WQ
- ADCP
- Met

## WQ

WQ data is imported directly from the data lake via the script import_netcdf_csv.m. Each netcdf is read and data is converted to csv and written tot he data warehouse. Validation images are automatically created and stored along side the csv files.

### Issues

Some of the data files are missing depth data. For these datasets a mean depth was created from the closes ADCP, and have been tagged as "Fixed +0.3m Above Seabed"

![image](https://github.com/AquaticEcoDynamics/csiem-data/assets/19967037/c8ea73e8-78a8-4d97-8196-213e6002226b)


## ADCP

WQ data is imported directly from the data lake via the script import_netcdf_csv_ADCP.m. Each netcdf is read and data is converted to csv and written tot he data warehouse. Validation images are automatically created and stored along side the csv files.

### Issues

All single dimension ADCP data has been imported into the data lake. However, 2 ADCP deployments contain no depth data, and the temperature data for these deployments have been excluded from the main csv export. These are:

- 20211221_CS7_EcoADCP_0223_EPSG7844.nc
- 20220311_CS7_EcoADCP_0223_EPSG7844.nc

## Met


All met has been imported from a single csv file "20220713_COL_CockburnCement_WSCR300_29784_Raw_(Prelim_Jul-Nov22)" and imported vai the script import_met_csv.m. 

### Issues

Midway through the file extra columns appear, without any header information. Columns AB and AC are assumed to be a continuation of columns T & U, column T - AA have been removed from import from row 32282 onwards.

![image](https://github.com/AquaticEcoDynamics/csiem-data/assets/19967037/b6551ee2-b766-4beb-8c8a-4428ee782559)

The exact deployment height of the sensors is unknown and not listed in the Theme 5 report.
